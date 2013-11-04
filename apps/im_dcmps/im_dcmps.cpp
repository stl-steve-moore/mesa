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

static char rcsid[] = "$Revision: 1.17 $ $RCSfile: im_dcmps.cpp,v $";

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

#include "im_dcmps.h"

#include "MDICOMReactor.hpp"
#include "MSOPHandler.hpp"
#include "MLQuery.hpp"
#include "MLMove.hpp"
#include "MLStorage.hpp"
#include "MLMPPS.hpp"
#include "MFileOperations.hpp"
#include "MLStorageCommitment.hpp"
#include "MDBImageManager.hpp"
#include "MLogClient.hpp"
#include "MServerAgent.hpp"


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

static CTNBOOLEAN silent = FALSE;
static CTNBOOLEAN waitFlag = FALSE;
static CTNBOOLEAN killFlag = FALSE;
static int completedThreads = 0;

static char *baseDirectory = ".";

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

// Register a set of DICOM Storage SOP classes with one
// storage handler.  Order of registration does not matter.

static void
registerStorageClasses(MLStorage& storageHandler, MDICOMReactor& reactor)
{
  char* sopClasses[] = {
    "1.2.840.10008.5.1.4.1.1.1",	// Computed Radiography
    "1.2.840.10008.5.1.4.1.1.1.1",	// Digital XRay Storage - Presentation
    "1.2.840.10008.5.1.4.1.1.2",	// CT
    "1.2.840.10008.5.1.4.1.1.20",	// NM (circa 1994)
    "1.2.840.10008.5.1.4.1.1.29",	// Hardcopy Grayscale Image
    "1.2.840.10008.5.1.4.1.1.30",	// Hardcopy Color Image
    "1.2.840.10008.5.1.4.1.1.4",	// MR
    "1.2.840.10008.5.1.4.1.1.128",	// Pet
    "1.2.840.10008.5.1.4.1.1.481.2",	// RT Dose
    "1.2.840.10008.5.1.4.1.1.481.1",	// RT Image
    "1.2.840.10008.5.1.4.1.1.481.3",	// RT Structure Set
    "1.2.840.10008.5.1.4.1.1.7",	// Secondary Capture
    "1.2.840.10008.5.1.4.1.1.9",	// Stand-alone Curve
    "1.2.840.10008.5.1.4.1.1.10",	// Stand-alone Modality Lut
    "1.2.840.10008.5.1.4.1.1.8",	// Stand-alone Overlay
    "1.2.840.10008.5.1.4.1.1.11",	// Stand-alone VOI LUT
    "1.2.840.10008.5.1.4.1.1.129",	// Stand-alone PET Curve
    "1.2.840.10008.5.1.4.1.1.27",	// Stored Print
    "1.2.840.10008.5.1.4.1.1.6",	// Ultrasound Image (retired)
    "1.2.840.10008.5.1.4.1.1.6.1",	// Ultrasound Image (circa 1995)
    "1.2.840.10008.5.1.4.1.1.3",	// US Multiframe (retired)
    "1.2.840.10008.5.1.4.1.1.3.1",	// US Multiframe (circa 1995)
    "1.2.840.10008.5.1.4.1.1.12.3",	// XRay Angiographic Bi-Plane
    "1.2.840.10008.5.1.4.1.1.12.1",	// Xray Angiographic Image
    "1.2.840.10008.5.1.4.1.1.12.2",	// XRF
    "1.2.840.10008.5.1.4.1.1.1.1",	// Dig XRay Image - For Presesentation
    "1.2.840.10008.5.1.4.1.1.1.2",	// Digital Mammo - For Presentation
    "1.2.840.10008.5.1.4.1.1.1.3"	// Dig Intra-oral XRay - For Presen
  };

  int index = 0;
  for (index = 0; index < (int)DIM_OF(sopClasses); index++) {
    reactor.registerHandler(&storageHandler, sopClasses[index]);
  }
}

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
    char namingConvention[1024];
    char logDir[256];
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
    
    MDBImageManager imageManager("imgmgr");
    MDICOMReactor reactor;
    MSOPHandler echoHandler;
    MLQuery queryHandler(imageManager);
    MLMove moveHandler(imageManager);
    MLStorage storageHandler(imageManager, logDir);
    storageHandler.initialize();
    MLMPPS ppsHandler(imageManager, logDir);
    ppsHandler.initialize();
    MLStorageCommitment storageCommitmentHandler(imageManager, logDir);
    storageCommitmentHandler.initialize();

    reactor.registerHandler(&echoHandler, DICOM_SOPCLASSVERIFICATION);
    registerStorageClasses(storageHandler, reactor);

    reactor.registerHandler(&queryHandler, DICOM_SOPPATIENTQUERY_FIND);
    reactor.registerHandler(&queryHandler, DICOM_SOPSTUDYQUERY_FIND);
    reactor.registerHandler(&queryHandler, DICOM_SOPPATIENTSTUDYQUERY_FIND);

    reactor.registerHandler(&moveHandler, DICOM_SOPPATIENTQUERY_MOVE);
    reactor.registerHandler(&moveHandler, DICOM_SOPSTUDYQUERY_MOVE);
    reactor.registerHandler(&moveHandler, DICOM_SOPPATIENTSTUDYQUERY_MOVE);

    reactor.registerHandler(&ppsHandler, DICOM_SOPCLASSMPPS);

    reactor.registerHandler(&storageCommitmentHandler,
			    DICOM_SOPCLASSSTORAGECOMMITMENTPUSHMODEL);

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

static void
acceptManageAssociation(DUL_NETWORKKEY ** network,
			DUL_ASSOCIATIONKEY * association,
			DUL_ASSOCIATESERVICEPARAMETERS * service,
			CTNBOOLEAN forkFlag,
			CTNBOOLEAN threadFlag,
			CTNBOOLEAN abortFlag,
			CTNBOOLEAN verboseDUL,
			int releaseDelay,
			const char *namingConvention,
			const char* logDir)
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
    strcpy(s->namingConvention, namingConvention);
    strcpy(s->logDir, logDir);

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
  c = getenv("MESA_TARGET");
  if (c == 0) {
    cerr << "This application requires the environment variable: MESA_TARGET"
         << endl;
    ::exit(1);
  }
}

// Signal Handler Type Definition
typedef void (*sighandler_t)(int);

void sighandler(int signal) {
  MServerAgent a("im_dcmps");
  a.closeServerPID();
  exit(0);
}

main(int argc, char **argv)
{
  // Setup Signal Handler, to exit gracefully on an INT signal
  signal(SIGINT, *sighandler);

  CONDITION cond;
  DUL_NETWORKKEY* network = NULL;
  DUL_ASSOCIATIONKEY * association = NULL;
  DUL_ASSOCIATESERVICEPARAMETERS *service;
  DUL_PRESENTATIONCONTEXT * requestedCtx;
  DUL_ABORTITEMS abortItems;
    
  MFileOperations f;
  char path[256];
  f.expandPath(path, "MESA_STORAGE", "imgmgr");
  MString logDir(path);            // Default is Storage Area

  int
    port,
    trips = -1,		/* Trips through the main loop */
    classCount = 0,
    releaseDelay = 0;
  unsigned long maxPDU = 16384;
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
  DUL_SC_ROLE scRole;
  int associationRequests = 0;

  char *classArray[] = {
    DICOM_SOPCLASSVERIFICATION,
    DICOM_SOPPATIENTQUERY_FIND,
    DICOM_SOPPATIENTQUERY_MOVE,
    DICOM_SOPSTUDYQUERY_FIND,
    DICOM_SOPSTUDYQUERY_MOVE,
    DICOM_SOPPATIENTSTUDYQUERY_FIND,
    DICOM_SOPPATIENTSTUDYQUERY_MOVE,
    DICOM_SOPCLASSMPPS,
    DICOM_SOPCLASSSTORAGECOMMITMENTPUSHMODEL,

    "1.2.840.10008.5.1.4.1.1.1",	// Computed Radiography
    "1.2.840.10008.5.1.4.1.1.2",	// CT
    "1.2.840.10008.5.1.4.1.1.20",	// NM (circa 1994)
    "1.2.840.10008.5.1.4.1.1.29",	// Hardcopy Grayscale Image
    "1.2.840.10008.5.1.4.1.1.30",	// Hardcopy Color Image
    "1.2.840.10008.5.1.4.1.1.4",	// MR
    "1.2.840.10008.5.1.4.1.1.128",	// Pet
    "1.2.840.10008.5.1.4.1.1.481.2",	// RT Dose
    "1.2.840.10008.5.1.4.1.1.481.1",	// RT Image
    "1.2.840.10008.5.1.4.1.1.481.3",	// RT Structure Set
    "1.2.840.10008.5.1.4.1.1.7",	// Secondary Capture
    "1.2.840.10008.5.1.4.1.1.9",	// Stand-alone Curve
    "1.2.840.10008.5.1.4.1.1.10",	// Stand-alone Modality Lut
    "1.2.840.10008.5.1.4.1.1.8",	// Stand-alone Overlay
    "1.2.840.10008.5.1.4.1.1.11",	// Stand-alone VOI LUT
    "1.2.840.10008.5.1.4.1.1.129",	// Stand-alone PET Curve
    "1.2.840.10008.5.1.4.1.1.27",	// Stored Print
    "1.2.840.10008.5.1.4.1.1.6",	// Ultrasound Image (retired)
    "1.2.840.10008.5.1.4.1.1.6.1",	// Ultrasound Image (circa 1995)
    "1.2.840.10008.5.1.4.1.1.3",	// US Multiframe (retired)
    "1.2.840.10008.5.1.4.1.1.3.1",	// US Multiframe (circa 1995)
    "1.2.840.10008.5.1.4.1.1.12.3",	// XRay Angiographic Bi-Plane
    "1.2.840.10008.5.1.4.1.1.12.1",	// Xray Angiographic Image
    "1.2.840.10008.5.1.4.1.1.12.2",	// XRF
    "1.2.840.10008.5.1.4.1.1.1.1",	// Dig XRay Image - For Presesentation
    "1.2.840.10008.5.1.4.1.1.1.2",	// Digital Mammo - For Presentation
    "1.2.840.10008.5.1.4.1.1.1.3",	// Dig Intra-oral XRay - For Presen

    ""};

    char *serverTitle = SIMPLE_STORAGE_AE_TITLE;
    char *namingConvention = "";
    MLogClient::LOGLEVEL logLevel = MLogClient::MLOG_NONE;

    while (--argc > 0 && (*++argv)[0] == '-') {
      int l1 = 0;
	switch (*(argv[0] + 1)) {
	case 'a':
	  argc--; argv++;
	  if (argc < 1)
	    usageerror();
	  logDir = MString(*argv);
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
	    fprintf(stderr, "im_dcmps was not compiled with threads\n");
	    return 1;
#else
	    //threadFlag = TRUE;
	    break;
#endif
	case 'k':
	    killFlag = TRUE;
	    break;
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
	    namingConvention = *argv;
	    break;
	case 'p':
	    paramsFlag = TRUE;
	    break;
	case 's':
	    silent = TRUE;
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
	case 'w':
	    waitFlag = TRUE;
	    break;
	case 'x':
	    argc--;
	    argv++;
	    if (argc < 1)
		usageerror();
	    baseDirectory = *argv;
	    break;
	case 'y':
	    printConnectionStatistics = TRUE;
	    break;
	case 'z':
	    argc--;
	    argv++;
	    if (argc < 1)
		usageerror();
	    if (sscanf(*argv, "%d", &releaseDelay) != 1)
		usageerror();
	    break;
	default:
	    (void) fprintf(stderr, "Unrecognized option: %c\n", *(argv[0] + 1));
	    break;
	}
    }

    if (argc < 1)
	usageerror();
    if (sscanf(*argv, "%d", &port) != 1)
	usageerror();

    checkEnvironment();
    //Write PID file
    MServerAgent a("im_dcmps");
    a.registerServerPID();

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
      logClient.initialize(logLevel, logDir + "/imgmgr.log");

      logClient.log(MLogClient::MLOG_VERBOSE,
		    "<no peer>", "im_dcmps<main>", __LINE__,
		    "Begin server process");
      cerr << "im_dcmps logging messages at level "
	   << logLevel
	   << " to "
	   << logDir + "/imgmgr.log"
	   << endl;
    }

    cond = DUL_InitializeNetwork(DUL_NETWORK_TCP, DUL_AEBOTH,

		 (void *) &port, DUL_TIMEOUT, DUL_ORDERBIGENDIAN, &network);
    if (cond != DUL_NORMAL) {
	COND_DumpConditions();
	exit(1);
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
	    fprintf(stderr, "Could not allocate memory for association parameters\n");
	    exit(1);
	}
	(void) memset(service, 0, sizeof(*service));
	service->maxPDU = maxPDU;
	strcpy(service->calledImplementationClassUID,
	       MIR_IMPLEMENTATIONCLASSUID);
	strcpy(service->calledImplementationVersionName,
	       MIR_IMPLEMENTATIONVERSIONNAME);
	cond = DUL_ReceiveAssociationRQ(&network, DUL_BLOCK,
					service, &association);

	{
	  MLogClient logClient;
	  logClient.log(MLogClient::MLOG_VERBOSE,
		    service->callingAPTitle,
			"im_dcmps<main>", __LINE__,
			"Association Request");
	}


	acceptFlag = TRUE;
	if (cond != DUL_NORMAL) {
	    COND_DumpConditions();
	    if (cond == DUL_UNSUPPORTEDPEERPROTOCOL) {
		acceptFlag = FALSE;
		cond = APP_NORMAL;	/* Yes, this is normal */
	    } else
		exit(0);
	}
	if (acceptFlag) {
	    cond = associationCheck(service, serverTitle,
				    forgiveFlag, &abortItems);
	    if (CTN_ERROR(cond)) {
		acceptFlag = FALSE;
		fprintf(stderr, "Incorrect Association Request\n");
		COND_DumpConditions();
		cond = DUL_RejectAssociationRQ(&association, &abortItems);
		if (cond != DUL_NORMAL) {
		    fprintf(stderr, "Unable to cleanly reject Association\n");
		    COND_DumpConditions();
		}
	    } else if (!CTN_SUCCESS(cond)) {
		COND_DumpConditions();
	    }
	}
	if (acceptFlag) {
	    if (verboseDUL || paramsFlag) {
		fprintf(stdout,
			"Application is about to accept association.  The association parameters\n\
before the app has decided which presentation contexts to accept follow.\n");
		DUL_DumpParams(service);
	    }
	    requestedCtx = (DUL_PRESENTATIONCONTEXT*)::LST_Head(&service->requestedPresentationContext);
	    if (requestedCtx != NULL)
		(void) LST_Position(&service->requestedPresentationContext,
				    requestedCtx);
	    classCount = 0;
	    while (requestedCtx != NULL) {
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
		    cond = SRV_AcceptServiceClass(requestedCtx, scRole,
						  service);
		    if (cond == SRV_NORMAL) {
			classCount++;
		    } else {
			printf("SRV Facility rejected SOP Class: %s\n",
			       requestedCtx->abstractSyntax);
			COND_DumpConditions();
		    }
		} else {
		    printf("Simple server rejects SOP Class with UID: %s\n",
			   requestedCtx->abstractSyntax);
		    dumpUIDDescription(requestedCtx->abstractSyntax);
		    cond = SRV_RejectServiceClass(requestedCtx,
				     DUL_PRESENTATION_REJECT_USER, service);
		    if (cond != SRV_NORMAL) {
			drop = TRUE;
		    }
		}
		requestedCtx = (DUL_PRESENTATIONCONTEXT*)::LST_Next(&service->requestedPresentationContext);
	    }
#if 0
	    printf("Supported classes: %d\n", classCount);
#endif
	    if (paramsFlag) {
		fprintf(stdout,
			"Application has now decided which presentation contexts to accept.\n\
Association parameters now look like this.\n");
		DUL_DumpParams(service);
	    }
	    if (drop) {
		(void) DUL_DropAssociation(&association);
		COND_DumpConditions();
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
				verboseDUL, releaseDelay, namingConvention, 
					logDir.strData());

	    }
	}
#if 0
	(void) DUL_ClearServiceParameters(service);
#endif
	if (CTN_ERROR(cond))
	    done = TRUE;
	if (trips >= 0) {
	    if (trips-- <= 0)
		done = TRUE;
	}
    }
    if (abortFlag) {
	exit(1);
    }
    (void) DUL_DropNetwork(&network);
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
Usage: im_dcmps [-a log directory] [-c <title>] [-d FAC] [-f] [-i] [-j] [-k] [-m maxPDU] [-n naming] [-p] [-s] [-t trips] [-v] [-w] [-x dir] [-z sec] port\n\
\n\
    -a    Analysis mode. Used for MESA exams\n\
    -d    Place one facility (DCM, DUL, SRV) in verbose mode\n\
    -c    Set the AE title of this server\n\
    -f    Fork a new process for each connection\n\
    -i    Ignore some incorrect parameters in Association request\n\
    -j    Use thread model.  Spawn a new thread for each connection\n\
    -k    Kill (delete) files immediately after they are received\n\
    -m    Set the maximum received PDU in the Association RP to maxPDU\n\
    -n    <naming> contains naming convention for files stored\n\
    -p    Dump the Association RQ parameters\n\
    -s    Silent mode.  Don't dump attributes of received images\n\
    -t    Execute the main loop trips times (debugging tool)\n\
    -v    Place DUL and SRV facilities in verbose mode\n\
    -w    Wait flag.  Wait for 1 second in callback routines (debugging)\n\
    -x    Set base directory for image creation.  Default is current directory\n\
    -z    Wait for sec seconds before releasing association\n\
\n\
    port  The TCP/IP port number to use\n";

    (void) fprintf(stderr, usage);
    exit(1);
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
