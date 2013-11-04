/*
          Copyright (C) 1993, 1994, RSNA and Washington University

          The software and supporting documentation for the Radiological
          Society of North America (RSNA) 1993, 1994 Digital Imaging and
          Communications in Medicine (DICOM) Demonstration were developed
          at the
                  Electronic Radiology Laboratory
                  Mallinckrodt Institute of Radiology
                  Washington University School of Medicine
                  510 S. Kingshighway Blvd.
                  St. Louis, MO 63110
          as part of the 1993, 1994 DICOM Central Test Node project for, and
          under contract with, the Radiological Society of North America.

          THIS SOFTWARE IS MADE AVAILABLE, AS IS, AND NEITHER RSNA NOR
          WASHINGTON UNIVERSITY MAKE ANY WARRANTY ABOUT THE SOFTWARE, ITS
          PERFORMANCE, ITS MERCHANTABILITY OR FITNESS FOR ANY PARTICULAR
          USE, FREEDOM FROM ANY COMPUTER DISEASES OR ITS CONFORMITY TO ANY
          SPECIFICATION. THE ENTIRE RISK AS TO QUALITY AND PERFORMANCE OF
          THE SOFTWARE IS WITH THE USER.

          Copyright of the software and supporting documentation is
          jointly owned by RSNA and Washington University, and free access
          is hereby granted as a license to use this software, copy this
          software and prepare derivative works based upon this software.
          However, any distribution of this software source code or
          supporting documentation or derivative works (source code and
          supporting documentation) must include the three paragraphs of
          the copyright notice.
*/
/* Copyright marker.  Copyright will be inserted above.  Do not remove */
/*
** @$=@$=@$=
*/
/*
**				DICOM 93
**		     Electronic Radiology Laboratory
**		   Mallinckrodt Institute of Radiology
**		Washington University School of Medicine
**
** Module Name(s):	main
**			usageerrror
**			echoRequest
**			echoCallback
**			storageCallback
**			findRequest
**			findCallback
**			moveRequest
**			moveCallback
**			fakeDBQuery
**			establishSendAssociation
**			sendCallback
**			supportedClass
**			associationCheck
** Author, Date:	Stephen M. Moore, 17-Apr-93
** Intent:		This program is an example and test program
**			which demonstrates the DICOM Upper Layer (DUL)
**			software and service classes for the DICOM 93 software.
**			It provides the storage and verification service
**			classes.
** Usage:		mesa_storage [-a] [-d FAC] [-i] [-m maxPDU] [-p] [-t trips] [-v] [-w] [-z sec] port
** Last Update:		$Author: smm $, $Date: 2009/03/06 18:47:21 $
** Source File:		$RCSfile: mesa_storage.cpp,v $
** Revision:		$Revision: 1.5 $
** Status:		$State: Exp $
*/

static char rcsid[] = "$Revision: 1.5 $ $RCSfile: mesa_storage.cpp,v $";

#include "ctn_os.h"

#if 0
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
#endif

#include "MESA.hpp"
#include "ctn_api.h"

#include "im_dcmps.h"

#include "MDICOMConfig.hpp"
#include "MDICOMReactor.hpp"
#include "MDICOMProxyTCP.hpp"
#include "MSOPHandler.hpp"
#include "MDBImageManager.hpp"
#include "MDBImageManagerJapanese.hpp"
#include "MDBImageManagerStudy.hpp"

#include "MLStorage.hpp"
#include "MFileOperations.hpp"

#include "MLogClient.hpp"
#include "MConfigFile.hpp"

#include <vector>
typedef vector < MSOPHandler* > MSOPHandlerVector;

typedef struct {
    DUL_NETWORKKEY **network;
    DUL_ASSOCIATESERVICEPARAMETERS *params;
}   MOVE_PARAMS;

static void usageerror();

static CONDITION
sendCallback(MSG_C_STORE_REQ * request, MSG_C_STORE_RESP * response,
	     unsigned long transmitted, unsigned long total,
	     char *string);

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

// Register a set of DICOM Storage SOP classes with one
// storage handler.  Order of registration does not matter.
// SOP Class UIDs are read from a text file at run-time.

static void
registerStorageClasses(MLStorage& storageHandler, MDICOMReactor& reactor,
		       MConfigFile& configFile)
{
  MString storageClassesFile = configFile.completePath("STORAGE_CLASSES");

  MDICOMConfig config;

  int v = config.registerStorageClasses(&storageHandler,
					reactor,
					storageClassesFile);

  if (v != 0) {
    cerr << "Unable to register storage classes" << endl;
    ::exit(1);
  }
}


static void
registerSOPClasses(MSOPHandler& handler, MDICOMReactor& reactor,
		   MConfigFile& configFile, const MString& key)
{
  MString classesFile = configFile.completePath(key);
  if (classesFile == "")
    return;

  MDICOMConfig config;

  int v = config.registerSOPClasses(&handler,
				    reactor,
				    classesFile);

  if (v != 0) {
    cerr << "Unable to register classes: " << key << endl;
    ::exit(1);
  }
}


// Register external Application Entities with the Move Handler

static void
registerExternalApplications(MSOPHandler& h)
{
  MDICOMConfig config;

  int v = config.registerApplicationEntities(h,
					     "ae.txt");
  if (v != 0) {
    cerr << "Unable to register Application Entities with move handler" << endl;
    ::exit(1);
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
    char databaseName[256];
    MDICOMReactor* reactor;
    MSOPHandlerVector* handlerVector;
    MDBImageManager* imageManager;
}   THREAD_STRUCT;

static void *
runThread(void *arg)
{
  THREAD_STRUCT *s;
  CONDITION cond;
  CTNBOOLEAN abortFlag;
  int runMode;

  s = (THREAD_STRUCT *) arg;

  MSOPHandlerVector* v  = s->handlerVector;

  MSOPHandlerVector::iterator i = v->begin();

  MLogClient logClient;
  logClient.log(MLogClient::MLOG_VERBOSE,
		  "no peer", "runThread", __LINE__,
		  "About to initialize Image Mgr with DB: ", s->databaseName);
  int status = 0;
  if (s->imageManager != 0) {
    status = (s->imageManager)->initialize(s->databaseName);
  }
  if (status != 0) {
    logClient.log(MLogClient::MLOG_ERROR,
		  "no peer", "runThread", __LINE__,
		  "Unable to initialize Image Mgr with DB: ", s->databaseName);
    logClient.logTimeStamp(MLogClient::MLOG_ERROR,
		"mesa_storage shutting down");
    ::exit(1);
  }

  while (i != v->end()) {
    (*i)->initialize();
    i++;
  }

  cond = ::DUL_AcknowledgeAssociationRQ(&s->association, s->service);
  if (cond != DUL_NORMAL) {
    ::COND_DumpConditions();
    //goto exitLabel;
  }
  if (s->verboseDUL)
    ::DUL_DumpParams(s->service);

  (s->reactor)->processRequests(&s->association, s->service);

  abortFlag = s->abortFlag;
  runMode = s->runMode;
  ::DUL_ClearServiceParameters(s->service);
  ::free(s->service);
  ::free(s);
  if (runMode == MODE_FORK) {
    ::exit(0);
  } else if (runMode == MODE_THREAD) {
#ifdef CTN_USE_THREADS
    ::THR_ObtainMutex(FAC_ATH);
    completedThreads++;
    ::THR_ReleaseMutex(FAC_ATH);

#ifdef _WIN32
    ::_endthread();
#else
    ::pthread_exit(NULL);
#endif
#endif
  } else {
    return 0;
  }
  return 0;
}
#if 0
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
    //registerStorageClasses(storageHandler, reactor);

    registerExternalApplications(moveHandler);

    reactor.registerHandler(&moveHandler, DICOM_SOPPATIENTQUERY_MOVE);
    reactor.registerHandler(&moveHandler, DICOM_SOPSTUDYQUERY_MOVE);
    reactor.registerHandler(&moveHandler, DICOM_SOPPATIENTSTUDYQUERY_MOVE);

    reactor.registerHandler(&ppsHandler, DICOM_SOPCLASSMPPS);

    reactor.registerHandler(&storageCommitmentHandler,
			    DICOM_SOPCLASSSTORAGECOMMITMENTPUSHMODEL);
#endif

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
			const MString& databaseName,
			MDICOMReactor* reactor,
			MSOPHandlerVector* handlerVector,
			MDBImageManager* imageManager)
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
  databaseName.safeExport(s->databaseName, sizeof(s->databaseName));
  s->reactor = reactor;
  s->handlerVector = handlerVector;
  s->imageManager = imageManager;

  if (threadFlag) {
#ifdef CTN_USE_THREADS
#ifdef _WIN32
    cerr <<  "Not designed for threads and Windows." << endl;
    ::exit(1);
#else
    pthread_t threadID;
    s->runMode = MODE_THREAD;
    pthread_create(&threadID, NULL, runThread, s);
    harvestThreads();
#endif
#else
    cerr <<  "Code not compiled for thread use." << endl;
    ::exit(1);
#endif
    return;
  } else if (forkFlag) {
    harvestChildren();
    s->runMode = MODE_FORK;
    pid = fork();
    if (pid == 0) {
      runThread(s);
    } else {
      (void) ::DUL_DropAssociation(&association);
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

static void
checkConfigurationParameters(MConfigFile& configFile)
{


}

static void
checkPort(int port)
{
  if (port <= 0) {
    cerr << "Port must be positive; check definition in config file." << endl;
    ::exit(1);
  }

#ifndef _WIN32
  if (port < 1024) {
    if (geteuid() != 0) {
      cerr << "To use this port ("
	   << port
	   << "), you must run as root are the application"
	   << endl
	   << " must be setuid root (see chmod command)"
	   << endl;
      ::exit(1);
    }
  }
#endif
}

static MString
getServerName(MConfigFile& configFile)
{
  MString s = configFile.value("SERVER_NAME");

  if (s == "") {
    cerr << "SERVER_NAME must be defined in the config file."  << endl;
    ::exit(1);
  }

  return s;
}

// Signal Handler Type Definition
typedef void (*sighandler_t)(int);

void sighandler(int signal) {
  exit(0);
}

static void
buildSOPHandlerVector(MConfigFile& configFile,
		      MDICOMReactor& reactor,
		      MDBImageManager* imageManager,
		      MSOPHandlerVector& v)
{
  MFileOperations f;
  MString logDir = configFile.completePath("LOG_DIRECTORY");
  MString storageDir = configFile.completePath("STORAGE_DIRECTORY");

  MString imgMgrAETitle = configFile.value("AETITLE");

  MSOPHandler* echoHandler = new MSOPHandler;
  v.push_back(echoHandler);

  if (storageDir != "") {
    MLStorage* storageHandler = new MLStorage(imageManager, logDir, storageDir);
    registerSOPClasses(*storageHandler, reactor, configFile, "STORAGE_CLASSES");
    v.push_back(storageHandler);
  }
}

/* supportedClass
**
** Purpose:
**	This function determines if an SOP class is supported by this
**	application.  The caller supplies an abstract syntax which defines
**	an SOP Class that is proposed for an Association.
**	The function returns 1 if the requested
**	class is supported and 0 if not.
**
** Parameter Dictionary:
**	abstractSyntax		SOP Class to be supported
**	reactor			MDICOMReactor which holds registered handlers
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
supportedClass(const MString& callingAETitle,
	       const MString& abstractSyntax, DUL_SC_ROLE scRole,
	       MDICOMReactor& reactor)
{
  MLogClient logClient;
  {
    logClient.log(MLogClient::MLOG_CONVERSATION,
		  callingAETitle, "supportedClass", __LINE__,
		  MString("Server to determine if SOP Class is supported: ") + abstractSyntax);
    MString s = "Undefined SOP Class Role";

    switch (scRole) {
      case DUL_SC_ROLE_DEFAULT:
	s = "Default SCU";
	break;
      case DUL_SC_ROLE_SCU:
	s = "Explicit SCU";
	break;
      case DUL_SC_ROLE_SCP:
	s = "SCP";
	break;
      case DUL_SC_ROLE_SCUSCP:
	s = "SCU/SCP";
	break;
    }
    logClient.log(MLogClient::MLOG_CONVERSATION,
		  callingAETitle, "supportedClass", __LINE__,
		  MString("Client app proposes SCU/SCP role: ") + s);
  }

  MSOPHandler* handler = reactor.recallHandler(abstractSyntax);

  if (handler == 0) {
    logClient.log(MLogClient::MLOG_CONVERSATION,
                  callingAETitle, "supportedClass", __LINE__,
                  MString("Server has no handler registered for SOP Class: ") + abstractSyntax);

    return 0;
  }

  if (!handler->supportsSCRole(scRole)) {
    logClient.log(MLogClient::MLOG_CONVERSATION,
		callingAETitle, "supportedClass", __LINE__,
		MString("Server rejects SOP Class: ") + abstractSyntax);
    return 0;
  }

  logClient.log(MLogClient::MLOG_CONVERSATION,
		callingAETitle, "supportedClass", __LINE__,
		MString("Server accepts SOP Class: ") + abstractSyntax);
  return 1;
}

int main(int argc, char **argv)
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

  int
    trips = -1,		/* Trips through the main loop */
    classCount = 0,
    releaseDelay = 0,
    parameterPort = 0;
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
    acceptFlag = FALSE,
    drop = FALSE,
    done = FALSE,
    printConnectionStatistics = FALSE,
    useParameterLogLevel = FALSE;
  DUL_SC_ROLE scRole;
  int associationRequests = 0;

  char *serverTitle = "MESA_STORAGE";
  //char *namingConvention = "";
  MLogClient::LOGLEVEL logLevel = MLogClient::MLOG_NONE;

  MConfigFile configFile;

  while (--argc > 0 && (*++argv)[0] == '-') {
      int l1 = 0;
	switch (*(argv[0] + 1)) {
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
	case 'l':
	    argc--;
	    argv++;
	    if (argc < 1)
		usageerror();
	    if (sscanf(*argv, "%d", &l1) != 1)
		usageerror();
	    logLevel = (MLogClient::LOGLEVEL)l1;
            useParameterLogLevel = TRUE;
	    break;
	case 'm':
	    argc--;
	    argv++;
	    if (argc < 1)
		usageerror();
	    if (sscanf(*argv, "%lu", &maxPDU) != 1)
		usageerror();
	    break;
	case 'p':
	    paramsFlag = TRUE;
	    break;
	case 'r':
	    argc--;
	    argv++;
	    if (argc < 1)
		usageerror();
	    if (sscanf(*argv, "%d", &parameterPort) != 1)
		usageerror();
            if (parameterPort <= 0)
                usageerror();
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
	default:
	    (void) fprintf(stderr, "Unrecognized option: %c\n", *(argv[0] + 1));
	    break;
	}
  }

  if (argc < 1)
    usageerror();

  ::THR_Init();

  ::DCM_Debug(verboseDCM);
  ::DUL_Debug(verboseDUL);
  ::SRV_Debug(verboseSRV);

  int status = configFile.readConfigFile(*argv);
  if (status != 0) {
    cerr << "Unable to read config file: " << *argv << endl;
    ::exit(1);
  }

  checkConfigurationParameters(configFile);
  checkEnvironment();
  // The parameter value of port overrides the configuration file value
  int port = parameterPort ? parameterPort : configFile.intValue("PORT");
  checkPort(port);

  MString serverName = getServerName(configFile);

  // The parameter value of log level overrides the configuration file value
  if (!useParameterLogLevel) {
    int tmp = configFile.intValue("LOG_LEVEL");
    if (tmp <= 0)
      logLevel = MLogClient::MLOG_NONE;
    else
      logLevel = (MLogClient::LOGLEVEL)tmp;
  }

  MLogClient logClient;
  if (logLevel != MLogClient::MLOG_NONE) {
    MString logDirectory = configFile.completePath("LOG_DIRECTORY");
    f.createDirectory(logDirectory);
    MString logFile = logDirectory + "/" + serverName + ".log";

    logClient.initialize(logLevel, logFile);

    logClient.log(MLogClient::MLOG_VERBOSE,
		  "<no peer>", "mesa_storage<main>", __LINE__,
		  "Begin server process");
    cerr << "mesa_storage logging messages at level "
	 << logLevel
	 << " to "
	 << logFile
	 << endl;
  }

  MSOPHandlerVector handlerVector;
  MDICOMReactor reactor;

  MString dbName = configFile.value("DATABASE_NAME");
  MString dataModel = configFile.value ("DATA_MODEL");
  MString language = configFile.value("LANGUAGE");
  MDBImageManager* imageManager;

  imageManager = new MDBImageManager();

  buildSOPHandlerVector(configFile, reactor, imageManager, handlerVector);

  MDICOMProxy* proxy = new MDICOMProxyTCP;
  if (proxy->registerPort(port, "") != 0) {
    logClient.log(MLogClient::MLOG_ERROR,
		    "<no peer>", "mesa_storage", __LINE__,
		    "Unable to register TCP port");
    return 1;
  }

  /*  Go back to the proper uid so we don't mess with things we don't own.
   */

#ifndef _WIN32
  (void) ::setuid(getuid());
#endif

  done = FALSE;
  while (!done) {
    drop = FALSE;
    service = (DUL_ASSOCIATESERVICEPARAMETERS*) ::malloc(sizeof(*service));
    if (service == NULL) {
      cerr << "Could not allocate memory for association parameters" << endl;
      ::exit(1);
    }
    (void) ::memset(service, 0, sizeof(*service));
    service->maxPDU = maxPDU;
    ::strcpy(service->calledImplementationClassUID, MIR_IMPLEMENTATIONCLASSUID);
    ::strcpy(service->calledImplementationVersionName,
	       MIR_IMPLEMENTATIONVERSIONNAME);
    if (proxy->acceptConnection(-1) != 0) {
      logClient.log(MLogClient::MLOG_ERROR,
	"<no peer>", "mesa_storage<main>", __LINE__,
	"Accept TCP connection failed");
      ::free(service);
      continue;
    }
    DUL_PROXY proxyStruct;
    proxy->configure(&proxyStruct);
    cond = ::DUL_ReceiveAssociationRQWithProxy(&network, DUL_BLOCK,
		    service, &proxyStruct, &association);

    logClient.log(MLogClient::MLOG_VERBOSE,
		    service->callingAPTitle,
		    "mesa_storage<main>", __LINE__,
		    "Association Request");


    acceptFlag = TRUE;
    if (cond != DUL_NORMAL) {
      ::COND_DumpConditions();
      if (cond == DUL_UNSUPPORTEDPEERPROTOCOL) {
	acceptFlag = FALSE;
	cond = APP_NORMAL;	// Yes, this is normal
      } else
	::exit(0);
    }
    if (acceptFlag) {
      cond = associationCheck(service, serverTitle, forgiveFlag, &abortItems);
      if (CTN_ERROR(cond)) {
	acceptFlag = FALSE;
	cerr <<  "Incorrect Association Request" << endl;
	::COND_DumpConditions();
	cond = ::DUL_RejectAssociationRQ(&association, &abortItems);
	if (cond != DUL_NORMAL) {
	  cerr <<  "Unable to cleanly reject Association\n";
	  ::COND_DumpConditions();
	}
      } else if (!CTN_SUCCESS(cond)) {
	::COND_DumpConditions();
      }
    }
    if (acceptFlag) {
      if (verboseDUL || paramsFlag) {
	cout << "Application is about to accept association.  "
	     << "The association parameters" << endl
	     << "before the app has decided which presentation contexts to "
	     << "accept follow." << endl;
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

	if (supportedClass(service->callingAPTitle,
			   requestedCtx->abstractSyntax,
			   requestedCtx->proposedSCRole,
			   reactor)) {
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
	  cond = ::SRV_AcceptServiceClass(requestedCtx, scRole, service);
	  if (cond == SRV_NORMAL) {
	    classCount++;
	  } else {
	    cout << "SRV Facility rejected SOP Class: "
		 << requestedCtx->abstractSyntax << endl;
	    ::COND_DumpConditions();
	  }
	} else {
	  cout << "Server rejects SOP Class with UID: "
	       << requestedCtx->abstractSyntax << endl;
	  dumpUIDDescription(requestedCtx->abstractSyntax);
	  cond = ::SRV_RejectServiceClass(requestedCtx,
				     DUL_PRESENTATION_REJECT_USER, service);
	  if (cond != SRV_NORMAL) {
	    drop = TRUE;
	  }
	}
	requestedCtx = (DUL_PRESENTATIONCONTEXT*)::LST_Next(&service->requestedPresentationContext);
      }

      if (paramsFlag) {
	cout << "Application has now decided which presentation contexts to "
	     << "accept." << endl
	     << "Association parameters now look like this." << endl;
	::DUL_DumpParams(service);
      }
      if (drop) {
	(void) ::DUL_DropAssociation(&association);
	::COND_DumpConditions();
      } else {
	if (printConnectionStatistics) {
	  ::printf("%6d: %16s %16s %s\n",
			   ++associationRequests,
			   service->calledAPTitle,
			   service->callingAPTitle,
			   service->callingPresentationAddress);
	}
	acceptManageAssociation(&network, association, service,
				forkFlag, threadFlag, abortFlag,
				verboseDUL, releaseDelay, "", 
				dbName, &reactor,
				&handlerVector,
				imageManager);

      }
    }

    if (CTN_ERROR(cond))
      done = TRUE;
    if (trips >= 0) {
      if (trips-- <= 0)
	done = TRUE;
    }
  }
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
Usage: mesa_storage [-c <title>] [-d FAC] [-f] [-i] [-j] [-l level] [-m maxPDU] [-p] [-r port] [-t trips] [-v] [-y] <config file>\n\
\n\
    -c    Set the AE title of this server\n\
    -d    Place one facility (DCM, DUL, SRV) in verbose mode\n\
    -f    Fork a new process for each connection\n\
    -i    Ignore some incorrect parameters in Association request\n\
    -j    Use thread model.  Spawn a new thread for each connection\n\
    -l    Set log level (0-4, default is 0: none) \n\
    -L    Set language (Japanese) \n\
    -m    Set the maximum received PDU in the Association RP to maxPDU\n\
    -p    Dump the Association RQ parameters\n\
    -r    Set port number (>0; overrides value in config file)\n\
    -t    Execute the main loop trips times (debugging tool)\n\
    -v    Place DUL and SRV facilities in verbose mode\n\
    -y    Print connection stats for each trip\n\
\n\
    <config file> \n\
          Contains configuration information for data server \n";
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

