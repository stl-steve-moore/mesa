//
//        Copyright (C) 1999, 2000, HIMSS, RSNA and Washington University
//
//        The MESA test tools software and supporting documentation were
//        developed for the Integrating the Healthcare Enterprise (IHE)
//        initiative Year 1 (1999-2000), under the sponsorship of the
//        Healthcare Information and Management Systems Society (HIMSS)
//        and the Radiological Society of North America (RSNA) by:
//                Electronic Radiology Laboratory
//                Mallinckrodt Institute of Radiology
//                Washington University School of Medicine
//                510 S. Kingshighway Blvd.
//                St. Louis, MO 63110
//        
//        THIS SOFTWARE IS MADE AVAILABLE, AS IS, AND NEITHER HIMSS, RSNA NOR
//        WASHINGTON UNIVERSITY MAKE ANY WARRANTY ABOUT THE SOFTWARE, ITS
//        PERFORMANCE, ITS MERCHANTABILITY OR FITNESS FOR ANY PARTICULAR
//        USE, FREEDOM FROM ANY DEFECTS OR COMPUTER DISEASES OR ITS CONFORMITY 
//        TO ANY SPECIFICATION. THE ENTIRE RISK AS TO QUALITY AND PERFORMANCE OF
//        THE SOFTWARE IS WITH THE USER.
//
//        Copyright of the software and supporting documentation is
//        jointly owned by HIMSS, RSNA and Washington University, and free
//        access is hereby granted as a license to use this software, copy
//        this software and prepare derivative works based upon this software.
//        However, any distribution of this software source code or supporting
//        documentation or derivative works (source code and supporting
//        documentation) must include the three paragraphs of this copyright
//        notice.

static char rcsid[] = "$Revision: 1.5 $ $RCSfile: pp_dcmps.cpp,v $";

#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <signal.h>
#ifdef _MSC_VER
#include <io.h>
#include <fcntl.h>
#include <direct.h>
#include <winsock.h>
#include <process.h>
#else
#include <sys/file.h>
#endif
#include <sys/stat.h>
#include <stdlib.h>
#include <string.h>
#if !defined(MACH) && !defined (_MSC_VER)
#include <unistd.h>
#include <sys/wait.h>
#endif

#ifdef CTN_USE_THREADS
#ifdef SOLARIS
#include <sys/types.h>
#include <pthread.h>
#include <thread.h>
#elif (_MSC_VER)

#endif
#endif

#include "MESA.hpp"
#include "ctn_api.h"

#include "pp_dcmps.h"

#include "MString.hpp"
#include "MDICOMReactor.hpp"
#include "MDICOMWrapper.hpp"
#include "MDICOMDomainXlate.hpp"
#include "MSOPHandler.hpp"
#include "MLQuery.hpp"
#include "MDBPostProcMgr.hpp"
#include "MFileOperations.hpp"
#include "MLogClient.hpp"
#include "MServerAgent.hpp"
#include "MLGPSPS.hpp"
#include "MLGPPPS.hpp"

typedef struct {
    DUL_NETWORKKEY **network;
    DUL_ASSOCIATESERVICEPARAMETERS *params;
}   MOVE_PARAMS;

static void usageerror();

static CONDITION
sendCallback(MSG_C_STORE_REQ * request, MSG_C_STORE_RESP * response,
	     unsigned long transmitted, unsigned long total,
	     char *string);

static int supportedClass(char *abstractSyntax, char **classArray);

CONDITION
establishSendAssociation(DUL_NETWORKKEY ** networkKey,
			 LST_HEAD * queryList, char *moveDestination,
			 DUL_ASSOCIATIONKEY ** sendAssociation,
			 DUL_ASSOCIATESERVICEPARAMETERS * params);
static CONDITION
associationCheck(DUL_ASSOCIATESERVICEPARAMETERS * params,
		 const char *serverTitle, CTNBOOLEAN forgive,
		 DUL_ABORTITEMS * abortItems);
static void dumpUIDDescription(char *uid);

static int completedThreads = 0;

static void
harvestThreads()
{

}

static void
harvestChildren()
{
#ifndef _MSC_VER
    int pid = 0;

    while ((pid = waitpid(-1, NULL, WNOHANG)) > 0) {
	;
    }
#endif
}

#ifdef _MSC_VER
static int
fork()
{
    return 0;
}
#endif

#define	MODE_THREAD	1
#define	MODE_FORK	2
#define	MODE_SINGLE	3

typedef struct {
    DUL_NETWORKKEY **network;
    DUL_ASSOCIATIONKEY *association;
    DUL_ASSOCIATESERVICEPARAMETERS *service;
    CTNBOOLEAN abortFlag;
    CTNBOOLEAN verboseDUL;
    int releaseDelay;
    int runMode;
    char logDir[256];
    char storageDir[256];
    char dbName[32];
}   THREAD_STRUCT;

static void *
runThread(void *arg)
{
    THREAD_STRUCT *s;
    CONDITION cond;
    CTNBOOLEAN abortFlag;
    int runMode;

    s = (THREAD_STRUCT *) arg;

    cond = DUL_AcknowledgeAssociationRQ(&s->association, s->service);
    if (cond != DUL_NORMAL) {
	COND_DumpConditions();
	//goto exitLabel;
    }
    if (s->verboseDUL)
	DUL_DumpParams(s->service);

    MString logDir(s->logDir);
    MString storageDir(s->storageDir);
    MString gpppsStorageDir = storageDir + "/gppps";

    MDBPostProcMgr ppmgr(s->dbName);
    MDICOMReactor reactor;
    MSOPHandler echoHandler;
    MLQuery queryHandler(ppmgr, logDir);
    MLGPSPS gPSPSHandler(ppmgr, logDir);
    MLGPPPS gPPPSHandler(ppmgr, logDir, gpppsStorageDir);

    reactor.registerHandler(&echoHandler, DICOM_SOPCLASSVERIFICATION);
    reactor.registerHandler(&queryHandler, DICOM_SOPGPWORKLIST_FIND);
    reactor.registerHandler(&gPSPSHandler, DICOM_SOPGPSPS);
    reactor.registerHandler(&gPPPSHandler, DICOM_SOPGPPPS);

    reactor.processRequests(&s->association, s->service);

exitLabel:
    abortFlag = s->abortFlag;
    runMode = s->runMode;
    DUL_ClearServiceParameters(s->service);
    free(s->service);
    free(s);
    if (runMode == MODE_FORK) {
	exit(0);
    } else if (runMode == MODE_THREAD) {
#ifdef CTN_USE_THREADS
	THR_ObtainMutex(FAC_ATH);
	completedThreads++;
	THR_ReleaseMutex(FAC_ATH);

#ifdef _MSC_VER
	_endthread();
#else
	pthread_exit(NULL);
#endif
#endif
    } else {
	return 0;
    }
    return 0;
}

void
ppwlQuery (const char* inFile, const MString& logDir, int numBase, 
           const char* dbName) {
  
  MDBPostProcMgr ppmgr(dbName);

  MLQuery queryHandler(ppmgr, logDir);
  MString queryLevel("");
  
  //Build a GPWorkitem query object
  MDICOMWrapper w(inFile);
  DCM_OBJECT* q = w.getNativeObject();
  MSG_C_FIND_REQ query =  { MSG_K_C_FIND_REQ, 0, 0, DCM_CMDDATAIDENTIFIER,
			     0, NULL, "" };
  strcpy(query.classUID, DICOM_SOPGPWORKLIST_FIND);
  query.identifier = q;
  MSG_C_FIND_REQ *queryMessage = &query;

  //Build a MWL response object
  MSG_C_FIND_RESP response = { MSG_K_C_FIND_RESP, 0, 0, 
			       DCM_CMDDATAIDENTIFIER, 0, NULL, "" };
  strcpy(response.classUID, DICOM_SOPGPWORKLIST_FIND);

  queryHandler.handleCFindCommand (NULL, // presentation context
				   &queryMessage, //c-find request message
				   &response, // c-find response message
				   NULL, // associate service parameters
				   queryLevel);

  char filename[1024];
  char logDirText[1024];
  logDir.safeExport(logDirText, sizeof(logDirText));

  int index;
  int count = queryHandler.objectVectorSize();

  MDICOMDomainXlate xlate;

  for (index = 0; index < count; index++) {
    //cout << "--PostProc worklist query result " << index+1 << endl;
    MGPWorkitem workitem = queryHandler.getMGPWorkitemObject(index).workitem();
    /*
    MActionItemVector aiv =
      queryHandler.getMMWLObjects(index).actionItemVector();
    */

    //cout << workitem << endl;
    DCM_OBJECT* r;
    ::DCM_CreateObject(&r, 0);
    xlate.translateDICOM(workitem, q, r);

    // Log query results to a file. The filename is built with 'numBase'
    if (response.dataSetType != DCM_CMDDATANULL) {
      sprintf(filename, "%s/msg%d_result.PPWL", logDirText, numBase+index);
      ::DCM_WriteFile(&r,
		      DCM_ORDERLITTLEENDIAN,
		      filename);
      
      ::DCM_CloseObject(&r);
    }
  }
  return;
}

static void
acceptManageAssociation(DUL_NETWORKKEY ** network,
			DUL_ASSOCIATIONKEY * association,
			DUL_ASSOCIATESERVICEPARAMETERS * service,
			CTNBOOLEAN forkFlag,
			CTNBOOLEAN threadFlag,
			CTNBOOLEAN abortFlag,
			CTNBOOLEAN verboseDUL,
			int releaseDelay,
			const char* logDir,
			const char* storageDir,
                        const char* dbName)
{
    int pid = 0;
    CONDITION cond = 0;
    THREAD_STRUCT *s;

    s = (THREAD_STRUCT*)malloc(sizeof(*s));
    memset(s, 0, sizeof(*s));
    s->network = network;
    s->association = association;
    s->service = service;
    s->abortFlag = abortFlag;
    s->releaseDelay = releaseDelay;
    strcpy(s->logDir, logDir);
    strcpy(s->storageDir, storageDir);
    strcpy(s->dbName, dbName);

    if (threadFlag) {
#ifdef CTN_USE_THREADS
#ifdef _MSC_VER
	fprintf(stderr, "Not designed for threads and Windows (yet)\n");
	exit(1);
#else
	pthread_t threadID;
	s->runMode = MODE_THREAD;
	pthread_create(&threadID, NULL, runThread, s);
	harvestThreads();
#endif
#else
	fprintf(stderr, "Code not compiled for thread use\n");
	exit(1);
#endif
	return;
    } else if (forkFlag) {
	harvestChildren();
	s->runMode = MODE_FORK;
	pid = fork();
	if (pid == 0) {
	    runThread(s);
	} else {
	    (void) DUL_DropAssociation(&association);
	    return;
	}
    } else {
	s->runMode = MODE_SINGLE;
	runThread(s);
    }

}

static void
checkEnvironment()
{
  char* c;

  c = getenv("MESA_STORAGE");
  if (c == 0) {
    cerr << "This application requires the environment variable: MESA_STORAGE"
         << endl;
    ::exit(1);
  }
}

// Signal Handler Type Definition
typedef void (*sighandler_t)(int);

void sighandler(int signal) {
  MServerAgent a("pp_dcmps");
  a.closeServerPID();
  exit(0);
}

int main(int argc, char **argv)
{
    // Setup Signal Handler, to exit gracefully on an INT signal
    signal(SIGINT, *sighandler);

    CONDITION
	cond;
    DUL_NETWORKKEY
	* network = NULL;
    DUL_ASSOCIATIONKEY
	* association = NULL;
    DUL_ASSOCIATESERVICEPARAMETERS *service;
    DUL_PRESENTATIONCONTEXT
	* requestedCtx;
    DUL_ABORTITEMS
	abortItems;

    MFileOperations f;
    char path[256];
    f.expandPath(path, "MESA_TARGET", "logs");
    MString logDir(path);            // Default is Storage Area
    f.expandPath(path, "MESA_STORAGE", "postproc");
    MString storageDir(path);            // Default is Storage Area
    char *dbName = "ppwf";            // Default database nameea

    int
        port,
        trips = 2048,		/* Trips through the main loop */
        classCount = 0,
        releaseDelay = 0,
        numBase = 100;		// msg number base for logging
    unsigned long
        maxPDU = 16384;
    CTNBOOLEAN
	verboseDUL = FALSE,
	verboseSRV = FALSE,
	verboseDCM = FALSE,
	abortFlag = FALSE,
	forgiveFlag = FALSE,
	forkFlag = FALSE,
	threadFlag = FALSE,
	paramsFlag = FALSE,
	acceptFlag,
	drop,
	done = FALSE,
	printConnectionStatistics = FALSE;
    DUL_SC_ROLE
	scRole;
    int associationRequests = 0;

    char *classArray[] = {
	DICOM_SOPCLASSVERIFICATION,
	DICOM_SOPGPWORKLIST_FIND,
	DICOM_SOPGPSPS,
	DICOM_SOPGPPPS,
    ""};

    char *serverTitle = POST_PROC_AE_TITLE;
    MLogClient::LOGLEVEL logLevel = MLogClient::MLOG_NONE;
    int fileMode = 0;
   
    while (--argc > 0 && (*++argv)[0] == '-') {
      int l1 = 0;
	switch (*(argv[0] + 1)) {
	case 'a':
	   argc--; argv++;
	   if (argc < 1)
	     usageerror();
	   logDir = MString(*argv);
	   break;
	case 'b':
	   argc--; argv++;
	   if (argc < 1)
	     usageerror();
	   if (sscanf(*argv, "%d", &numBase) != 1)
	     usageerror();
	   break;
	case 'c':
	    argc--;
	    argv++;
	    if (argc < 1)
		usageerror();
	    serverTitle = *argv;
	    break;
	case 'd':
	    argc--;
	    argv++;
	    if (argc < 1)
		usageerror();
	    if (strcmp(*argv, "DCM") == 0)
		verboseDCM = TRUE;
	    else if (strcmp(*argv, "DUL") == 0)
		verboseDUL = TRUE;
	    else if (strcmp(*argv, "SRV") == 0)
		verboseSRV = TRUE;
	    else
		usageerror();
	    break;
	case 'f':
	    forkFlag = TRUE;
	    break;
	case 'i':
	    forgiveFlag = TRUE;
	    break;
	case 'j':
#ifndef CTN_USE_THREADS
	    fprintf(stderr, "pp_dcmps was not compiled with threads\n");
	    return 1;
#else
	    //threadFlag = TRUE;
	    break;
#endif
	case 'l':
	    argc--;
	    argv++;
	    if (argc < 1)
		usageerror();
	    if (sscanf(*argv, "%d", &l1) != 1)
		usageerror();
	    logLevel = (MLogClient::LOGLEVEL)l1;
	    break;
	case 'm':
	    argc--;
	    argv++;
	    if (argc < 1)
		usageerror();
	    if (sscanf(*argv, "%lu", &maxPDU) != 1)
		usageerror();
	    break;
	case 'n':
	    argc--;
	    argv++;
	    if (argc < 1)
		usageerror();
	    dbName = *argv;
	    break;
	case 'p':
	    paramsFlag = TRUE;
	    break;
	case 't':
	    argc--;
	    argv++;
	    if (argc < 1)
		usageerror();
	    if (sscanf(*argv, "%d", &trips) != 1)
		usageerror();
	    break;
	case 'v':
	    verboseDUL = TRUE;
	    verboseSRV = TRUE;
	    break;
	case 'y':
	    printConnectionStatistics = TRUE;
	    break;
	case 'z':
	    fileMode++;
	    break;
	default:
	    (void) fprintf(stderr, "Unrecognized option: %c\n", *(argv[0] + 1));
	    break;
	}
    }

    if (argc < 1)
	usageerror();

    // If in filemode, perform the query and exit
    if (fileMode) {
      ppwlQuery (*argv, logDir, numBase, dbName);
      return 0;
    }
    
    // Write PID file
    MServerAgent a("pp_dcmps");
    a.registerServerPID();

    if (sscanf(*argv, "%d", &port) != 1)
      usageerror();

    checkEnvironment();

    ::THR_Init();

    ::DCM_Debug(verboseDCM);
    ::DUL_Debug(verboseDUL);
    ::SRV_Debug(verboseSRV);

#ifndef _MSC_VER
    if (port < 1024) {
	if (geteuid() != 0) {
	    char errmsg[] =
	    "To use this port (%d), you must run as root or the application must be\n\
setuid root (see chmod)\n";

	    fprintf(stderr, errmsg, port);
	    perror("");
	    exit(1);
	}
    }
#endif

    if (logLevel != MLogClient::MLOG_NONE) {
      MLogClient logClient;
      logClient.initialize(logLevel, logDir + "/pp_dcmps.log");

      logClient.log(MLogClient::MLOG_ERROR,
		    "<no peer>", "pp_dcmps<main>", __LINE__,
		    "Begin server process");
      cout << "pp_dcmps logging messages at level "
	   << logLevel
	   << " to "
	   << logDir + "/pp_dcmps.log"
	   << endl;
    }

    cond = ::DUL_InitializeNetwork(DUL_NETWORK_TCP, DUL_AEBOTH,

		 (void *) &port, DUL_TIMEOUT, DUL_ORDERBIGENDIAN, &network);
    if (cond != DUL_NORMAL) {
	::COND_DumpConditions();
	::exit(1);
    }
/*  Go back to the proper uid so we don't mess with things we don't own.
*/

#ifndef _MSC_VER
    (void) setuid(getuid());
#endif

    done = FALSE;
    while (!done) {
	drop = FALSE;
	service = (DUL_ASSOCIATESERVICEPARAMETERS*)malloc(sizeof(*service));
	if (service == NULL) {
	    ::fprintf(stderr, "Could not allocate memory for association parameters\n");
	    ::exit(1);
	}
	(void) ::memset(service, 0, sizeof(*service));
	service->maxPDU = maxPDU;
	strcpy(service->calledImplementationClassUID,
	       MIR_IMPLEMENTATIONCLASSUID);
	strcpy(service->calledImplementationVersionName,
	       MIR_IMPLEMENTATIONVERSIONNAME);
	cond = ::DUL_ReceiveAssociationRQ(&network, DUL_BLOCK,
					service, &association);
	{
	  MLogClient logClient;
	  logClient.log(MLogClient::MLOG_CONVERSATION,
		    service->callingAPTitle,
			"pp_dcmps<main>", __LINE__,
			"Association Request");
	}

	acceptFlag = TRUE;
	if (cond != DUL_NORMAL) {
	    ::COND_DumpConditions();
	    if (cond == DUL_UNSUPPORTEDPEERPROTOCOL) {
		acceptFlag = FALSE;
		cond = APP_NORMAL;	/* Yes, this is normal */
	    } else
		::exit(0);
	}
	if (acceptFlag) {
	    cond = associationCheck(service, serverTitle,
				    forgiveFlag, &abortItems);
	    if (CTN_ERROR(cond)) {
		acceptFlag = FALSE;
		::fprintf(stderr, "Incorrect Association Request\n");
		::COND_DumpConditions();
		cond = ::DUL_RejectAssociationRQ(&association, &abortItems);
		if (cond != DUL_NORMAL) {
		    ::fprintf(stderr, "Unable to cleanly reject Association\n");
		    ::COND_DumpConditions();
		}
	    } else if (!CTN_SUCCESS(cond)) {
		::COND_DumpConditions();
	    }
	}
	if (acceptFlag) {
	    if (verboseDUL || paramsFlag) {
		fprintf(stdout,
			"Application is about to accept association.  The association parameters\n\
before the app has decided which presentation contexts to accept follow.\n");
		::DUL_DumpParams(service);
	    }
	    requestedCtx = (DUL_PRESENTATIONCONTEXT*)::LST_Head(&service->requestedPresentationContext);
	    if (requestedCtx != NULL)
		(void) ::LST_Position(&service->requestedPresentationContext,
				    requestedCtx);
	    classCount = 0;
	    while (requestedCtx != NULL) {
		if (strcmp(requestedCtx->abstractSyntax, MIR_SOPCLASSKILLSERVER) == 0)
		    done = TRUE;

		if (supportedClass(requestedCtx->abstractSyntax, classArray)) {
		    switch (requestedCtx->proposedSCRole) {
		    case DUL_SC_ROLE_DEFAULT:
			scRole = DUL_SC_ROLE_DEFAULT;
			break;
		    case DUL_SC_ROLE_SCU:
			scRole = DUL_SC_ROLE_SCU;
			break;
		    case DUL_SC_ROLE_SCP:
			scRole = DUL_SC_ROLE_DEFAULT;
			break;
		    case DUL_SC_ROLE_SCUSCP:
			scRole = DUL_SC_ROLE_SCU;
			break;
		    default:
			scRole = DUL_SC_ROLE_DEFAULT;
			break;
		    }
		    cond = ::SRV_AcceptServiceClass(requestedCtx, scRole,
						  service);
		    if (cond == SRV_NORMAL) {
			classCount++;
		    } else {
			::printf("SRV Facility rejected SOP Class: %s\n",
			       requestedCtx->abstractSyntax);
			::COND_DumpConditions();
		    }
		} else {
		    ::printf("Simple server rejects SOP Class with UID: %s\n",
			   requestedCtx->abstractSyntax);
		    dumpUIDDescription(requestedCtx->abstractSyntax);
		    cond = ::SRV_RejectServiceClass(requestedCtx,
				     DUL_PRESENTATION_REJECT_USER, service);
		    if (cond != SRV_NORMAL) {
			drop = TRUE;
		    }
		}
		requestedCtx = (DUL_PRESENTATIONCONTEXT*)::LST_Next(&service->requestedPresentationContext);
	    }
#if 0
	    ::printf("Supported classes: %d\n", classCount);
#endif
	    if (paramsFlag) {
		::fprintf(stdout,
			"Application has now decided which presentation contexts to accept.\n\
Association parameters now look like this.\n");
		::DUL_DumpParams(service);
	    }
	    if (drop) {
		(void) ::DUL_DropAssociation(&association);
		::COND_DumpConditions();
	    } else {
		if (printConnectionStatistics) {
		    printf("%6d: %16s %16s %s\n",
			   ++associationRequests,
			   service->calledAPTitle,
			   service->callingAPTitle,
			   service->callingPresentationAddress);
		}
		acceptManageAssociation(&network, association, service,
					forkFlag, threadFlag, abortFlag,
				verboseDUL, releaseDelay,
					logDir.strData(),
					storageDir.strData(),
                                        dbName );

	    }
	}
#if 0
	(void) ::DUL_ClearServiceParameters(service);
#endif
	if (CTN_ERROR(cond))
	    done = TRUE;
	if (trips >= 0) {
	    if (trips-- <= 0)
		done = TRUE;
	}
    }
    a.closeServerPID();
    if (abortFlag) {
	::exit(1);
    }
    (void) ::DUL_DropNetwork(&network);
    return 0;
}


/* usageerror
**
** Purpose:
**	Print the usage text for this program and exit
**
** Parameter Dictionary:
**	None
**
** Return Values:
**	None
**
** Algorithm:
**	Description of the algorithm (optional) and any other notes.
*/

static void
usageerror()
{
    char usage[] = "\
Usage: pp_dcmps [-a logdir] [-c title] [-d FAC] [-f] [-i] [-j] [-l level] [-m maxPDU] [-n dbName] [-p] [-t trips] [-v] [-y] [-z] <port | input file>\n\
\n\
\
  Post Processing Manager DICOM server. If last argument is a port number, \n\
  server will listen for queries; if its a -z filename, server will process \n\
  the queryfile and exit.\n\
\n\
    -a    Set the log directory; default is $MESA_TARGET/logs \n\
    -b    Set starting number for output files when run in file mode\n\
    -d    Place one facility (DCM, DUL, SRV) in verbose mode\n\
    -c    Set the AE title of this server\n\
    -f    Fork a new process for each connection\n\
    -i    Ignore some incorrect parameters in Association request\n\
    -j    Use thread model; spawn a new thread for each connection\n\
    -l    Set log level (0-4); default is 0: none \n\
    -m    Set the maximum received PDU in the Association RP to maxPDU\n\
    -n    Set the database name (default is ppwf\n\
    -p    Dump the Association RQ parameters\n\
    -t    Execute the main loop trips times (debugging tool)\n\
    -v    Place DUL and SRV facilities in verbose mode\n\
    -y    Print connection statistics \n\
    -z    Run in file mode.  Process Post Processing worklist query from a file\n\
\n\
    port/file  Use TCP/IP port or read Post Processing worklist query from file";

    cerr << usage << endl;
    ::exit(1);
}



typedef struct {
    char *directory;
    char *SOPClass;
}   CLASS_DIRECTORY;




typedef struct {
    void *reserved[2];
    char classUID[DICOM_UI_LENGTH + 1];
}   UID_STRUCT;


/* supportedClass
**
** Purpose:
**	This function determines if an SOP class is supported by this
**	application.  The caller supplies an abstract syntax which defines
**	an SOP Class that is proposed for an Association.  The caller
**	also provides a static list of supported classes which this
**	routine can search.  The function returns 1 if the requested
**	class is found in the list and 0 if not.
**
** Parameter Dictionary:
**	abstractSyntax		SOP Class to be supported
**	classArray		List of SOP classes supported
**
** Return Values:
**	1 => success (supported)
**	0 => class not supported
**
** Notes:
**
** Algorithm:
**	Description of the algorithm (optional) and any other notes.
*/

static int
supportedClass(char *abstractSyntax, char **classArray)
{
    while (strlen(*classArray) != 0) {
	if (strcmp(abstractSyntax, *classArray) == 0)
	    return 1;
	else
	    classArray++;
    }
    return 0;
}

/* associationCheck
**
** Purpose:
**	Check the validity of the Association service parameters
**
** Parameter Dictionary:
**	params		Service parameters describing the Association
**	title		Expected AE title of this server
**	forgive		Decides whether to return a warning or a failure status
**	abortItems	Structure specifying reasons for aborting the
**			Association
**
** Return Values:
**
**	APP_NORMAL
**	APP_PARAMETERFAILURE
**	APP_PARAMETERWARNINGS
**
** Notes:
**
** Algorithm:
**	Description of the algorithm (optional) and any other notes.
*/
static CONDITION
associationCheck(DUL_ASSOCIATESERVICEPARAMETERS * params,
		 const char *title, CTNBOOLEAN forgive,
		 DUL_ABORTITEMS * abortItems)
{
    CONDITION
    cond = APP_NORMAL;

    if (strcmp(params->applicationContextName, DICOM_STDAPPLICATIONCONTEXT) != 0) {
	abortItems->result = DUL_REJECT_PERMANENT;
	abortItems->source = DUL_ULSU_REJECT;
	abortItems->reason = DUL_ULSU_REJ_UNSUP_APP_CTX_NAME;
	cond = COND_PushCondition(APP_ILLEGALSERVICEPARAMETER,
				  APP_Message(APP_ILLEGALSERVICEPARAMETER),
		"Application Context Name", params->applicationContextName);
    }
    if (strlen(params->callingImplementationClassUID) == 0) {
	abortItems->result = DUL_REJECT_PERMANENT;
	abortItems->source = DUL_ULSU_REJECT;
	abortItems->reason = DUL_ULSU_REJ_NOREASON;

	cond = COND_PushCondition(APP_MISSINGSERVICEPARAMETER,
				  APP_Message(APP_MISSINGSERVICEPARAMETER),
				  "Requestor's ImplementationClassUID");
    }
#if 0
    if (strcmp(params->calledAPTitle, title) != 0) {
	abortItems->result = DUL_REJECT_PERMANENT;
	abortItems->source = DUL_ULSU_REJECT;
	abortItems->reason = DUL_ULSU_REJ_UNREC_CALLED_TITLE;
	cond = COND_PushCondition(APP_ILLEGALSERVICEPARAMETER,
				  APP_Message(APP_ILLEGALSERVICEPARAMETER),
				  "AE Title", params->calledAPTitle);
    }
#endif
    if (cond != APP_NORMAL) {
	if (forgive)
	    cond = COND_PushCondition(APP_PARAMETERWARNINGS,
				      APP_Message(APP_PARAMETERWARNINGS));
	else
	    cond = COND_PushCondition(APP_PARAMETERFAILURE,
				      APP_Message(APP_PARAMETERFAILURE));
    }
    return cond;
}

static void
dumpUIDDescription(char *uid)
{
    UID_DESCRIPTION description;

    if (UID_Lookup(uid, &description) != UID_NORMAL)
	(void) COND_PopCondition(FALSE);

    fprintf(stdout, "    UID Description: %s\n", description.description);
    fprintf(stdout, "    UID Originator:  %s\n", description.originator);
}
