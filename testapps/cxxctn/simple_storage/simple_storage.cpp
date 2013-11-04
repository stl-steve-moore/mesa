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
**			serviceRequests
**			serviceThisCommand
**			echoRequest
**			echoCallback
**			storeRequest
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
** Usage:		simple_storage [-a] [-d FAC] [-i] [-m maxPDU] [-p] [-t trips] [-v] [-w] [-z sec] port
** Last Update:		$Author: smm $, $Date: 1999/06/25 22:13:33 $
** Source File:		$RCSfile: simple_storage.cpp,v $
** Revision:		$Revision: 1.2 $
** Status:		$State: Exp $
*/

static char rcsid[] = "$Revision: 1.2 $ $RCSfile: simple_storage.cpp,v $";

#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
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

#if 0
#include "dicom.h"
#include "utility.h"
#include "dicom_uids.h"
#include "lst.h"
#include "condition.h"
#include "dulprotocol.h"
#include "dicom_objects.h"
#include "dicom_messages.h"
#include "dicom_services.h"
#include "dbquery.h"
#include "iap.h"
#include "ctnthread.h"
#endif

#include "simple_storage.h"

#include "MString.hpp"
#include "MDICOMReactor.hpp"
#include "MSOPHandler.hpp"
#include "MLStorage.hpp"


typedef struct {
    DUL_NETWORKKEY **network;
    DUL_ASSOCIATESERVICEPARAMETERS *params;
}   MOVE_PARAMS;

static void usageerror();
static CONDITION
serviceRequests(DUL_NETWORKKEY ** network, DUL_ASSOCIATIONKEY ** association,
	     DUL_ASSOCIATESERVICEPARAMETERS * service, CTNBOOLEAN abortFlag,
		int releaseDelay, const char *namingConvention);
static CONDITION
serviceThisCommand(DUL_NETWORKKEY ** network, DUL_ASSOCIATIONKEY ** association,
		   DUL_PRESENTATIONCONTEXT * ctx, MSG_TYPE messageType,
		   void **message, DUL_ASSOCIATESERVICEPARAMETERS * params,
		   const char *namingConvention);
static CONDITION
echoRequest(DUL_ASSOCIATIONKEY ** association,
	    DUL_PRESENTATIONCONTEXT * ctx, MSG_C_ECHO_REQ ** message);
static CONDITION
storeRequest(DUL_ASSOCIATIONKEY ** association,
	     DUL_PRESENTATIONCONTEXT * ctx, MSG_C_STORE_REQ ** message,
	     const char *namingConvention,
	     DUL_ASSOCIATESERVICEPARAMETERS * params);
static CONDITION
echoCallback(MSG_C_ECHO_REQ * echoRequest,
	     MSG_C_ECHO_RESP * echoResponse, void *ctx,
	     DUL_PRESENTATIONCONTEXT * pci);
static CONDITION
storageCallback(MSG_C_STORE_REQ * request, MSG_C_STORE_RESP * response,
		unsigned long received, unsigned long estimate,
		DCM_OBJECT ** object, void *string,
		DUL_PRESENTATIONCONTEXT * pci);
static CONDITION
sendCallback(MSG_C_STORE_REQ * request, MSG_C_STORE_RESP * response,
	     unsigned long transmitted, unsigned long total,
	     char *string);
static CONDITION
findRequest(DUL_ASSOCIATIONKEY ** association,
	    DUL_ASSOCIATESERVICEPARAMETERS * params,
	    DUL_PRESENTATIONCONTEXT * ctx, MSG_C_FIND_REQ ** request);
static CONDITION
findCallback(MSG_C_FIND_REQ * request, MSG_C_FIND_RESP * response,
	     int responseCount, char *SOPClass, char *queryLevel,
/*	     DUL_ASSOCIATESERVICEPARAMETERS * params); */
	     void *paramsVoid);
static CONDITION
moveRequest(DUL_NETWORKKEY ** network, DUL_ASSOCIATIONKEY ** association,
	    DUL_PRESENTATIONCONTEXT * ctx, MSG_C_MOVE_REQ ** request,
	    DUL_ASSOCIATESERVICEPARAMETERS * params);
static CONDITION
moveCallback(MSG_C_MOVE_REQ * request, MSG_C_MOVE_RESP * response,
	     int responseCount, char *SOPClass, char *queryLevel,
/*	     MOVE_PARAMS * moveParams); */
	     void *moveParamsVoid);
static void findMoveClasses(LST_HEAD ** SOPClassList);

static int supportedClass(char *abstractSyntax, char **classArray);
static void fakeDBQuery(LST_HEAD ** queryList);
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
#if 0
#ifdef CTN_USE_THREADS
#ifdef _MSC_VER
#else
    int j;
    THR_ObtainMutex(FAC_ATH);
    while (completedThreads > 0) {
	j = thr_join(0, NULL, NULL);
	if (j != 0) {
	    perror("thread join");
	    exit(1);
	}
	completedThreads--;
    }
    THR_ReleaseMutex(FAC_ATH);
#endif
#endif
#endif
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
    char namingConvention[1024];
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


    MDICOMReactor reactor;
    MSOPHandler echoHandler;
    MLStorage storageHandler;

    reactor.registerHandler(&echoHandler, DICOM_SOPCLASSVERIFICATION);
    reactor.registerHandler(&storageHandler, DICOM_SOPCLASSCOMPUTEDRADIOGRAPHY);
    reactor.registerHandler(&storageHandler, DICOM_SOPCLASSCT);
    reactor.registerHandler(&storageHandler, DICOM_SOPCLASSMR);

    reactor.registerHandler(&storageHandler, DICOM_SOPPATIENTQUERY_FIND);
    reactor.registerHandler(&storageHandler, DICOM_SOPSTUDYQUERY_FIND);
    reactor.registerHandler(&storageHandler, DICOM_SOPPATIENTSTUDYQUERY_FIND);

    reactor.processRequests(&s->association, s->service);

#if 0
    cond = serviceRequests(s->network, &s->association, s->service,
			s->abortFlag, s->releaseDelay, s->namingConvention);
    if (cond == SRV_PEERREQUESTEDRELEASE)
	cond = SRV_NORMAL;
    if (!s->abortFlag) {
	(void) DUL_DropAssociation(&s->association);
    }
#endif

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
			const char *namingConvention)
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

main(int argc, char **argv)
{
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
    int
        port,
        trips = 2048,		/* Trips through the main loop */
        classCount = 0,
        releaseDelay = 0;
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
	DICOM_SOPCLASSCOMPUTEDRADIOGRAPHY,
	DICOM_SOPCLASSCT,
	DICOM_SOPCLASSMR,
	DICOM_SOPCLASSNM,
	DICOM_SOPCLASSUS1993,
	DICOM_SOPCLASSUS,
	DICOM_SOPCLASSUSMULTIFRAMEIMAGE1993,
	DICOM_SOPCLASSUSMULTIFRAMEIMAGE,
	DICOM_SOPCLASSSECONDARYCAPTURE,
	DICOM_SOPCLASSXRAYANGIO,
	DICOM_SOPCLASSXRAYFLUORO,
	DICOM_SOPCLASSPET,
	DICOM_SOPCLASSSTANDALONEPETCURVE,
	DICOM_SOPRTIMAGESTORAGE,
	DICOM_SOPRTDOSESTORAGE,
	DICOM_SOPRTSTRUCTURESETSTORAGE,
	DICOM_SOPRTPLANSTORAGE,
	DICOM_SOPPATIENTQUERY_FIND,
	DICOM_SOPPATIENTQUERY_MOVE,
	DICOM_SOPSTUDYQUERY_FIND,
	DICOM_SOPSTUDYQUERY_MOVE,
	DICOM_SOPPATIENTSTUDYQUERY_FIND,
	DICOM_SOPPATIENTSTUDYQUERY_MOVE,
    ""};

    char *serverTitle = SIMPLE_STORAGE_AE_TITLE;
    char *namingConvention = "";

    while (--argc > 0 && (*++argv)[0] == '-') {
	switch (*(argv[0] + 1)) {
	case 'a':
	    abortFlag = TRUE;
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
	    fprintf(stderr, "simple_storage was not compiled with threads\n");
	    return 1;
#else
	    threadFlag = TRUE;
	    break;
#endif
	case 'k':
	    killFlag = TRUE;
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

#ifdef CTN_USE_THREADS
    THR_Init();
#endif

    DCM_Debug(verboseDCM);
    DUL_Debug(verboseDUL);
    SRV_Debug(verboseSRV);

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
				verboseDUL, releaseDelay, namingConvention);

#if 0
		cond = DUL_AcknowledgeAssociationRQ(&association, service);
		if (cond != DUL_NORMAL) {
		    COND_DumpConditions();
		    exit(1);
		}
		if (verboseDUL)
		    DUL_DumpParams(&service);
		cond = serviceRequests(&network, &association, &service,
				 abortFlag, releaseDelay, namingConvention);
		if (cond == SRV_PEERREQUESTEDRELEASE)
		    cond = SRV_NORMAL;
		if (!abortFlag) {
		    (void) DUL_DropAssociation(&association);
		}
#endif
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
Usage: simple_storage [-a] [-c <title>] [-d FAC] [-f] [-i] [-j] [-k] [-m maxPDU] [-n naming] [-p] [-s] [-t trips] [-v] [-w] [-x dir] [-z sec] port\n\
\n\
    -a    Abort Association after receiving one image (debugging tool)\n\
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


/* serviceRequests
**
** Purpose:
**	This function reads requests from the network and services those
**	requests.
**
** Parameter Dictionary:
**	network		The key which is used to access the network.
**	association	They key which is used to access the association
**			on which requests are received.
**	service		The parameter list which describes the association.
**			This list includes the list of presentation contexts
**			for the association.
**	abortFlag	A test flag which tells this function to abort the
**			Association after it receives one image.
**	releaseDelay	Amount of time to delay (sleep) after release
**			is requested before acknowledging release.
**	namingConvention Name of a file that contains convention for
**			naming the files created with DICOM images.
**
** Return Values:
**
** Algorithm:
**	Description of the algorithm (optional) and any other notes.
*/

static CONDITION
serviceRequests(DUL_NETWORKKEY ** network, DUL_ASSOCIATIONKEY ** association,
	     DUL_ASSOCIATESERVICEPARAMETERS * service, CTNBOOLEAN abortFlag,
		int releaseDelay, const char *namingConvention)
{
    CONDITION
    cond;
    DUL_PRESENTATIONCONTEXT
	* ctx;
    DUL_PRESENTATIONCONTEXTID
	ctxID;
    void
       *message;
    MSG_TYPE
	messageType;
    CTNBOOLEAN
	networkLink = TRUE,
	commandServiced;

    cond = SRV_NORMAL;
    while ((networkLink == TRUE) && !CTN_ERROR(cond)) {
	cond = SRV_ReceiveCommand(association, service, DUL_BLOCK, 0, &ctxID,
				  NULL, &messageType, &message);
	if (cond == SRV_PEERREQUESTEDRELEASE) {
	    networkLink = FALSE;
	    if (releaseDelay != 0) {
#ifdef _MSC_VER
		(void) Sleep(releaseDelay * 1000);
#else
		(void) sleep(releaseDelay);
#endif
	    }
	    (void) DUL_AcknowledgeRelease(association);
	} else if (cond == SRV_PEERABORTEDASSOCIATION) {
	    networkLink = FALSE;
	} else if (cond != SRV_NORMAL) {
	    COND_DumpConditions();
	    cond = 0;
	} else {
	    ctx = (DUL_PRESENTATIONCONTEXT*)::LST_Head(&service->acceptedPresentationContext);
	    if (ctx != NULL)
		(void) LST_Position(&service->acceptedPresentationContext, ctx);
	    commandServiced = FALSE;
	    while (ctx != NULL) {
		if (ctx->presentationContextID == ctxID) {
		    if (commandServiced) {
			fprintf(stderr,
			      "Context ID Repeat in serviceRequests (%d)\n",
				ctxID);
		    } else {
			cond = serviceThisCommand(network, association, ctx,
			  messageType, &message, service, namingConvention);
			if (cond == SRV_OPERATIONCANCELLED) {
			    printf("Operation cancelled\n");
			    (void) COND_PopCondition(TRUE);
			} else if (cond != SRV_NORMAL)
			    COND_DumpConditions();
			commandServiced = TRUE;
#if 0
			COND_DumpConditions();
#else
			(void) COND_PopCondition(TRUE);
#endif
		    }
		}
		ctx = (DUL_PRESENTATIONCONTEXT*)::LST_Next(&service->acceptedPresentationContext);
	    }
	    if (!commandServiced) {
		fprintf(stderr, "In serviceRequests, context ID %d not found\n",
			ctxID);
		(void) DUL_DropAssociation(association);
		networkLink = FALSE;
	    } else if (abortFlag) {
		(void) DUL_DropAssociation(association);
		networkLink = FALSE;
	    }
	}
    }
    return cond;
}

/* serviceThisCommand
**
** Purpose:
**	This function serves as a dispatch routine for the commands
**	that can be received from the network.  It uses a case statement
**	to identify the command and call the function which will
**	respond to the request.
**
** Parameter Dictionary:
**	association	They key which is used to access the association
**			on which requests are received.
**	ctx		Pointer to the presentation context for this command
**	messageType	The type of message that we are to recognize.
**	message		Pointer to a structure which contains the message.
**			We will use "messageType" to get the proper type.
**
** Return Values:
**
** Algorithm:
**	Description of the algorithm (optional) and any other notes.
*/

static CONDITION
serviceThisCommand(DUL_NETWORKKEY ** network, DUL_ASSOCIATIONKEY ** association,
		   DUL_PRESENTATIONCONTEXT * ctx, MSG_TYPE messageType,
		   void **message, DUL_ASSOCIATESERVICEPARAMETERS * params,
		   const char *namingConvention)
{
    CONDITION
    cond;
    MSG_GENERAL
	* general;


    if (!silent) {
	general = *(MSG_GENERAL **) message;
	MSG_DumpMessage(general, stdout);
    }
    switch (messageType) {
    case MSG_K_C_ECHO_REQ:
	cond = echoRequest(association, ctx, (MSG_C_ECHO_REQ **) message);
	break;
    case MSG_K_C_STORE_REQ:
	cond = storeRequest(association, ctx, (MSG_C_STORE_REQ **) message,
			    namingConvention, params);
	break;
    case MSG_K_C_FIND_REQ:
	cond = findRequest(association, params, ctx,
			   (MSG_C_FIND_REQ **) message);
	break;
    case MSG_K_C_MOVE_REQ:
	cond = moveRequest(network, association, ctx,
			   (MSG_C_MOVE_REQ **) message, params);
	break;
    case MSG_K_C_CANCEL_REQ:
	cond = SRV_NORMAL;	/* This must have happened after we were done */
	break;
    default:
	fprintf(stderr, "Unimplemented message type: %d\n", messageType);
	cond = 1;
	break;
    }
    return cond;
}


/* echoRequest
**
** Purpose:
**	This function responds to an echo request from the network.
**	It creates an echo response message with a status of success
**	and sends the message to the peer application.
**
** Parameter Dictionary:
**	association	They key which is used to access the association
**			on which requests are received.
**	ctx		Pointer to the presentation context for this command
**	message		Pointer to the MSG_C_ECHO_REQ message that was
**			received by the server.
**
** Return Values:
**
**	SRV_CALLBACKABORTEDSERVICE
**	SRV_ILLEGALPARAMETER
**	SRV_NOCALLBACK
**	SRV_NORMAL
**	SRV_OBJECTBUILDFAILED
**	SRV_RESPONSEFAILED
**
** Algorithm:
**	Description of the algorithm (optional) and any other notes.
*/

static CONDITION
echoRequest(DUL_ASSOCIATIONKEY ** association,
	    DUL_PRESENTATIONCONTEXT * ctx, MSG_C_ECHO_REQ ** echoReq)
{
    MSG_C_ECHO_RESP
    echoResponse = {
	MSG_K_C_ECHO_RESP, 0, 0, DCM_CMDDATANULL, 0, ""
    };

    return SRV_CEchoResponse(association, ctx, echoReq,
			     &echoResponse, echoCallback, NULL, "");
}

/* echoCallback
**
** Purpose:
**	Call back routine provided by the service provider. It is invoked
**	by the SRV Echo Response function.
**
** Parameter Dictionary:
**	request		Pointer to C-Echo Request Message
**	response	Pointer to C-Echo Response Message
**	ctx		Context information which we ignore
**	pci		Presentation context for this operation (ignored)
**
** Return Values:
**	SRV_NORMAL
**
** Notes:
**
** Algorithm:
**	Description of the algorithm (optional) and any other notes.
*/
static CONDITION
echoCallback(MSG_C_ECHO_REQ * request,
	     MSG_C_ECHO_RESP * response, void *ctx,
	     DUL_PRESENTATIONCONTEXT * pci)
{
    if (!silent)
	printf("Echo Request Received/Acknowledged\n");

    response->dataSetType = DCM_CMDDATANULL;
    response->messageIDRespondedTo = request->messageID;
    response->status = MSG_K_SUCCESS;
    strcpy(response->classUID, request->classUID);

    return SRV_NORMAL;
}

static int
createDirectory(char *path)
{
    int i;
    struct stat buf;

    i = stat(path, &buf);
    if (i == 0) {
#ifdef _MSC_VER
	if ((buf.st_mode & _S_IFDIR) != 0)
	    return 1;
#else
	if (S_ISDIR(buf.st_mode))
	    return 1;
#endif
	else {
	    COND_PushCondition(APP_DIRECTORYFAILURE,
	    "APP Path %s is expected to be a directory and is not\n", path);
	    return 1;
	}
    }
#ifdef _MSC_VER
    i = mkdir(path);
#else
    i = mkdir(path, 0777);
#endif
    if (i == 0)
	return 1;
    else {
	COND_PushCondition(APP_DIRECTORYFAILURE,
			   "APP Unable to create directory: %s", path);
	COND_PushCondition(APP_DIRECTORYFAILURE,
		"APP Check that the path up to the last directory exists.");
	COND_PushCondition(APP_DIRECTORYFAILURE,
			   "APP This application only tries to create the last directory in %s", path);
	return 1;
    }
}

static void
concatenateAttribute(DCM_OBJECT * obj, const char *txt,
		     char *path)
{
    int group = 0;
    int element = 0;
    char defaultText[512] = "";
    char c = 0;
    CONDITION cond;
    DCM_ELEMENT e;
    char localText[512] = "";
    char *p;

    sscanf(txt, "%c %x %x %s", &c, &group, &element, defaultText);

    memset(&e, 0, sizeof(e));
    e.tag = DCM_MAKETAG(group, element);
    cond = DCM_LookupElement(&e);
    if (cond != DCM_NORMAL) {
	strcat(path, defaultText);
	COND_PopCondition(TRUE);
	return;
    }
    e.d.string = localText;
    e.length = sizeof(localText);
    cond = DCM_ParseObject(&obj, &e, 1, NULL, 0, NULL);
    if (cond != DCM_NORMAL) {
	strcat(path, defaultText);
	COND_PopCondition(TRUE);
	return;
    }
    p = localText;
    while (*p == ' ')
	p++;

    if (p[0] == '\0')
	strcat(path, defaultText);
    else
	strcat(path, p);
}


static void
extractDirectoryAndName(DCM_OBJECT * obj,
			const char *namingConvention,
			DUL_ASSOCIATESERVICEPARAMETERS * params,
			char *newDirectory,
			char *newName)
{
    FILE *f;
    char txt[128];
    char tempName[256] = "";

    newDirectory[0] = '\0';
    newName[0] = '\0';
    f = fopen(namingConvention, "r");
    if (f == NULL) {
	fprintf(stderr,
		"Could not open naming convention: %s\n",
		namingConvention);
	return;
    }
    while (fgets(txt, sizeof(txt), f) != NULL) {
	if (txt[0] == 'A') {
	    strcat(newDirectory, params->callingAPTitle);
	    strcat(newDirectory, "/");
	} else if (txt[0] == 'C') {
	    strcat(newDirectory, params->calledAPTitle);
	    strcat(newDirectory, "/");
	} else if (txt[0] == 'D') {
	    concatenateAttribute(obj, txt, newDirectory);
	    strcat(newDirectory, "/");
	} else if (txt[0] == 'F') {
	    concatenateAttribute(obj, txt, tempName);
	}
    }
    sprintf(newName, "%s%s", newDirectory, tempName);

    fclose(f);
}

static void
fileNameChecks(char *name)
{
    while (*name != '\0') {
	if (*name == '^' || *name == ' ')
	    *name = '_';
	name++;
    }
}

static void
renameFile(const char *fileName, const char *namingConvention,
	   DUL_ASSOCIATESERVICEPARAMETERS * params)
{
    DCM_OBJECT *obj;
    CONDITION cond;
    char newDirectory[1024];
    char newName[1024];

    cond = DCM_OpenFile(fileName, DCM_ORDERLITTLEENDIAN, &obj);
    if (cond != DCM_NORMAL) {
	COND_DumpConditions();
	return;
    }
    extractDirectoryAndName(obj, namingConvention, params, newDirectory, newName);

    (void) DCM_CloseObject(&obj);

    fileNameChecks(newDirectory);
    fileNameChecks(newName);
    UTL_VerifyCreatePath(newDirectory);

    rename(fileName, newName);



}

/* storeRequest
**
** Purpose:
**	This function responds to a request to store an image.
**
** Parameter Dictionary:
**	association	They key which is used to access the association
**			on which requests are received.
**	ctx		Pointer to the presentation context for this command
**	message		Pointer to the MSG_C_STORE_REQ message that was
**			received by the server.
**
** Return Values:
**
**	SRV_FILECREATEFAILED
**	SRV_NORMAL
**	SRV_OBJECTBUILDFAILED
**	SRV_RESPONSEFAILED
**	SRV_UNEXPECTEDPDVTYPE
**
** Algorithm:
**	Description of the algorithm (optional) and any other notes.
*/

typedef struct {
    char *directory;
    char *SOPClass;
}   CLASS_DIRECTORY;

static CONDITION
storeRequest(DUL_ASSOCIATIONKEY ** association,
	     DUL_PRESENTATIONCONTEXT * ctx, MSG_C_STORE_REQ ** request,
	     const char *namingConvention,
	     DUL_ASSOCIATESERVICEPARAMETERS * params)
{
    static CLASS_DIRECTORY directoryMap[] = {
	{"./CR", DICOM_SOPCLASSCOMPUTEDRADIOGRAPHY},
	{"./CT", DICOM_SOPCLASSCT},
	{"./MR", DICOM_SOPCLASSMR},
	{"./NM", DICOM_SOPCLASSNM},
	{"./US1993", DICOM_SOPCLASSUS1993},
	{"./US", DICOM_SOPCLASSUS},
	{"./USMF", DICOM_SOPCLASSUSMULTIFRAMEIMAGE},
	{"./USMF1993", DICOM_SOPCLASSUSMULTIFRAMEIMAGE1993},
	{"./SC", DICOM_SOPCLASSSECONDARYCAPTURE},
	{"./XRA", DICOM_SOPCLASSXRAYANGIO},
	{"./XRF", DICOM_SOPCLASSXRAYFLUORO},
	{"./PET", DICOM_SOPCLASSPET},
	{"./PETCURVE", DICOM_SOPCLASSSTANDALONEPETCURVE},
	{"./RTIMAGE", DICOM_SOPRTIMAGESTORAGE},
	{"./RTDOSE", DICOM_SOPRTDOSESTORAGE},
	{"./RTSSET", DICOM_SOPRTSTRUCTURESETSTORAGE},
	{"./RTPLAN", DICOM_SOPRTPLANSTORAGE},
    };
    int
        index;
    char
        directory[1024],
        fileName[1024];
    MSG_C_STORE_RESP
	response;
    CONDITION cond;

    fileName[0] = '\0';
    for (index = 0; index < (int) DIM_OF(directoryMap); index++) {
	if (strcmp((*request)->classUID, directoryMap[index].SOPClass) == 0) {
	    sprintf(directory, "%s/%s", baseDirectory, directoryMap[index].directory);
	    if (createDirectory(directory) == 0)
		return 0;
	    sprintf(fileName, "%s/%s", directory, (*request)->instanceUID);
	}
    }
    if (strlen(fileName) == 0) {
	sprintf(fileName, "%s", (*request)->instanceUID);
	printf("simple_storage::storeRequest could not map SOP Class to a directory name\n");
	printf("SOP Class: %s\n", (*request)->classUID);
    }
    cond = SRV_CStoreResponse(association, ctx, request, &response,
			  fileName, storageCallback, "callback string", "");

    if (killFlag) {
	if (unlink(fileName) != 0)
	    perror(fileName);
    } else if (namingConvention[0] != '\0')
	renameFile(fileName, namingConvention, params);
    return cond;
}

/* storageCallback
**
** Purpose:
**	Call back routine provided by the service provider and invoked by
**	the C-STORE response routine
**
** Parameter Dictionary:
**	request		Pointer to C-STORE request message
**	response	Pointer to C-STORE response message
**	received	Number of bytes received so far
**	estimate	Estimated number of bytes in the data set
**	object		Handle to DICOM object
**	string		Context information
**	pci		Presentation context for this operation
**
** Return Values:
**	SRV_NORMAL
**
** Algorithm:
**	Description of the algorithm (optional) and any other notes.
*/

static CONDITION
storageCallback(MSG_C_STORE_REQ * request, MSG_C_STORE_RESP * response,
		unsigned long received, unsigned long estimate,
		DCM_OBJECT ** object, void *string,
		DUL_PRESENTATIONCONTEXT * pci)
{
    if (!silent)
	printf("%8d bytes received of %8d estimated (%s)\n", received, estimate,
	       (char *) string);
    if (!silent && (object != NULL))
	(void) DCM_DumpElements(object, 0);

    if (response != NULL)
	response->status = MSG_K_SUCCESS;

    return SRV_NORMAL;
}

/* findRequest
**
** Purpose:
**	This function responds to a query request
**
** Parameter Dictionary:
**	association	They key which is used to access the association
**			on which requests are received.
**	ctx		Pointer to the presentation context for this command
**	message		Pointer to the MSG_C_FIND_REQ message that was
**			received by the server.
**
** Return Values:
**
**	SRV_ILLEGALPARAMETER
**	SRV_NOCALLBACK
**	SRV_NORMAL
**	SRV_OPERATIONCANCELLED
**	SRV_RESPONSEFAILED
**	SRV_SUSPICIOUSRESPONSE
**
** Algorithm:
**	Description of the algorithm (optional) and any other notes.
*/

static CONDITION
findRequest(DUL_ASSOCIATIONKEY ** association,
	    DUL_ASSOCIATESERVICEPARAMETERS * params,
	    DUL_PRESENTATIONCONTEXT * ctx, MSG_C_FIND_REQ ** request)
{
    MSG_C_FIND_RESP
    response = {
	MSG_K_C_FIND_RESP, 0, 0, 0, 0, NULL, ""
    };

    return SRV_CFindResponse(association, ctx, request, &response,
			     findCallback, params, "");
}

/* findCallback
**
** Purpose:
**	Callback routine called by SRV C-FIND Response handling routine
**
** Parameter Dictionary:
**	request		Pointer to C-FIND request message
**	response	Pointer to C-FIND response message
**	responseCount	Total number of responses
**	SOPClass	Abstract Syntax (to be found)
**	queryLevel	Database access level
**	paramsVoid	Service parameters describing the Association
**			(passed as void *)
**
** Return Values:
**	SRV_NORMAL
**
** Notes:
**
** Algorithm:
**	Description of the algorithm (optional) and any other notes.
*/
static CONDITION
findCallback(MSG_C_FIND_REQ * request, MSG_C_FIND_RESP * response,
	     int responseCount, char *SOPClass, char *queryLevel,
/*	     DUL_ASSOCIATESERVICEPARAMETERS * params) */
	     void *paramsVoid)
{
#if 1
  return SRV_NORMAL;
#else
    CONDITION
    cond;
    static char
        patient_name[24] = "",
        birth_date[24] = "";
    DCM_ELEMENT e[] = {
	{DCM_PATNAME, DCM_PN, "", 1, 0, (void *) patient_name},
	{DCM_PATBIRTHDATE, DCM_DA, "", 1, 0, (void *) birth_date}
    };
#if STANDARD_VERSION >= VERSION_JUL1993
    DCM_ELEMENT
	titleElement = {
	DCM_IDRETRIEVEAETITLE, DCM_AE, "", 1, 0, NULL
    };
#endif
/*  This declaration and following cast to satisfy prototypes and compilers.*/
    DUL_ASSOCIATESERVICEPARAMETERS *params;

    params = (DUL_ASSOCIATESERVICEPARAMETERS *) paramsVoid;

    printf("Find callback\n");
    printf("SOP Class:      %s\n", SOPClass);
    printf("Query Level:    %s\n", queryLevel);
    printf("Response Count: %d\n", responseCount);
    if (response->status == MSG_K_CANCEL) {
	printf("Query cancelled\n");
	return SRV_NORMAL;
    }
    if (responseCount == 1)
	(void) DCM_DumpElements(&request->identifier, 0);

    response->status = MSG_K_C_FIND_MATCHCONTINUING;
    response->dataSetType = DCM_CMDDATAIDENTIFIER;
    if (responseCount == 5) {
	response->status = MSG_K_SUCCESS;
	response->dataSetType = DCM_CMDDATANULL;
    } else {
	sprintf(patient_name, "Name:%x", responseCount);
	sprintf(birth_date, "1993120%1d", responseCount);
	cond = DCM_ModifyElements(&response->identifier, e, (int) DIM_OF(e),
				  NULL, 0, NULL);
	if (!CTN_SUCCESS(cond)) {
	    COND_DumpConditions();
	    (void) DCM_DumpElements(&response->identifier, 0);
	}
#if STANDARD_VERSION >= VERSION_JUL1993
	titleElement.d.string = params->calledAPTitle;
	titleElement.length = strlen(titleElement.d.string);
	cond = DCM_ModifyElements(&response->identifier, &titleElement, 1,
				  NULL, 0, NULL);
	if (!CTN_SUCCESS(cond)) {
	    COND_DumpConditions();
	    (void) DCM_DumpElements(&response->identifier, 0);
	}
#endif
    }
    if (waitFlag) {
#ifdef _MSC_VER
	(void) Sleep(1000);
#else
	(void) sleep(1);
#endif
    }
    return SRV_NORMAL;
#endif
}

/* moveRequest
**
** Purpose:
**	This function responds to a request to move an image.
**
** Parameter Dictionary:
**	association	They key which is used to access the association
**			on which requests are received.
**	ctx		Pointer to the presentation context for this command
**	message		Pointer to the MSG_C_FIND_REQ message that was
**			received by the server.
**
** Return Values:
**
**	SRV_ILLEGALPARAMETER
**	SRV_LISTFAILURE
**	SRV_NOCALLBACK
**	SRV_NORMAL
**	SRV_OPERATIONCANCELLED
**	SRV_RESPONSEFAILED
**	SRV_SUSPICIOUSRESPONSE
**
** Algorithm:
**	Description of the algorithm (optional) and any other notes.
*/

static CONDITION
moveRequest(DUL_NETWORKKEY ** network, DUL_ASSOCIATIONKEY ** association,
	    DUL_PRESENTATIONCONTEXT * ctx, MSG_C_MOVE_REQ ** request,
	    DUL_ASSOCIATESERVICEPARAMETERS * params)
{
    MSG_C_MOVE_RESP
    response = {
	MSG_K_C_MOVE_RESP, 0, 0, DCM_CMDDATANULL, 0, 0,
	0, 0, 0,
#if STANDARD_VERSION < VERSION_JUL1993
	NULL, NULL, NULL,	/* success, failed, warning UID Lists */
#else
	NULL,			/* DCM_OBJECT for failed UID List (data set) */
#endif
	""			/* SOP Class UID */
    };
    MOVE_PARAMS
	p;
    CONDITION
	cond;
    p.network = network;
    p.params = params;
    cond = SRV_CMoveResponse(association, ctx, request, &response,
			     moveCallback, &p, "");
    return cond;
}

typedef struct {
    void *reserved[2];
    char classUID[DICOM_UI_LENGTH + 1];
}   UID_STRUCT;

/* moveCallback
**
** Purpose:
**	Callback routine called by the C-MOVE Response handling routine.
**
** Parameter Dictionary:
**	request		Pointer to the C-MOVE request message
**	response	Pointer to the C-MOVE response message
**	responseCount	Total number of responses
**	SOPClass	Abstract Syntax for which MOVE has been requested
**	queryLevel	Database access query level
**	moveParamsVoid	Parameters describing the move operation
**			(passed as void * to satisfy compilers)
**
** Return Values:
**	APP_FAILURE
**	SRV_NORMAL
**
** Notes:
**
** Algorithm:
**	Description of the algorithm (optional) and any other notes.
*/

static CONDITION
moveCallback(MSG_C_MOVE_REQ * request, MSG_C_MOVE_RESP * response,
	     int responseCount, char *SOPClass, char *queryLevel,
/*	     MOVE_PARAMS * moveParams) */
	     void *moveParamsVoid)
{
#if 1
  return SRV_NORMAL;
#else
    CONDITION
    cond;
    static LST_HEAD
    *   queryList = NULL,
       *failedList = NULL;
    Query
	* q;
    static DUL_NETWORKKEY
    *   network;
    static DUL_ASSOCIATIONKEY
    *   sendAssociation = NULL;
    DUL_ASSOCIATESERVICEPARAMETERS
	* params;
    static DUL_ASSOCIATESERVICEPARAMETERS
        sendParams = {
	DICOM_STDAPPLICATIONCONTEXT, "DICOM_TEST", SIMPLE_STORAGE_AE_TITLE,
	"", 16384, 0, 0, 0,
	"calling presentation addr", "called presentation addr",
	NULL, NULL, 0, 0,
	MIR_IMPLEMENTATIONCLASSUID, MIR_IMPLEMENTATIONVERSIONNAME,
	"", ""
    };
    MSG_UID_ITEM
	* UIDItem;
    DCM_ELEMENT
	e = {
	DCM_IDFAILEDINSTANCEUIDLIST, DCM_UI, "", 1, 0, NULL
    };

/*  This declaration and following cast to satisfy compilers */
    MOVE_PARAMS *moveParams;
    moveParams = (MOVE_PARAMS *) moveParamsVoid;

    network = *moveParams->network;
    params = moveParams->params;
    response->conditionalFields = 0;
    response->dataSetType = DCM_CMDDATANULL;
    if (response->status == MSG_K_CANCEL) {
	printf("Move cancelled\n");
	if (queryList != NULL) {
	    while ((q = LST_Dequeue(&queryList)) != NULL)
		free(q);
	}
    } else
	response->status = MSG_K_C_MOVE_SUBOPERATIONSCONTINUING;

    if (responseCount == 1) {
	queryList = LST_Create();
	if (queryList == NULL)
	    return 0;

	printf("Move callback\n");
	printf("SOP Class:      %s\n", SOPClass);
	printf("Query Level:    %s\n", queryLevel);
	printf("AE Destination: %s\n", request->moveDestination);
	printf("Response Count: %d\n", responseCount);

	fakeDBQuery(&queryList);
	q = LST_Head(&queryList);
	(void) LST_Position(&queryList, q);
	while (q != NULL) {
	    printf("%s\n", q->Series.Modality);
	    q = LST_Next(&queryList);
	}
	response->remainingSubOperations = (unsigned short) LST_Count(&queryList);
	cond = establishSendAssociation(&network, queryList,
		   request->moveDestination, &sendAssociation, &sendParams);
	q = LST_Head(&queryList);
	(void) LST_Position(&queryList, q);
#if STANDARD_VERSION >= VERSION_JUL1993
	failedList = LST_Create();
	if (failedList == NULL)
	    return 0;
#endif
    }
    if (queryList != NULL)
	q = LST_Dequeue(&queryList);
    else
	q = NULL;

    if (q != NULL) {
	printf("%s: %s\n", q->Series.Modality, q->Image.ClassUID);
	UIDItem = malloc(sizeof(*UIDItem));
	if (UIDItem == NULL)
	    return 0;
	(void) strcpy(UIDItem->UID, q->Image.ImageUID);

	if (sendAssociation != NULL)
	    cond = IAP_SendImage(&sendAssociation, &sendParams,
				 q->Image.FileName,
	     params->callingAPTitle, request->messageID, sendCallback, "X");
	else
	    cond = APP_FAILURE;

	free(q);
	if (CTN_SUCCESS(cond)) {
	    response->completedSubOperations++;
#if STANDARD_VERSION < VERSION_JUL1993
	    cond = LST_Enqueue(&response->successUIDList, UIDItem);
#endif
	} else if (CTN_WARNING(cond)) {
	    COND_DumpConditions();
	    response->warningSubOperations++;
#if STANDARD_VERSION < VERSION_JUL1993
	    cond = LST_Enqueue(&response->warningUIDList, UIDItem);
#endif
	} else {
	    COND_DumpConditions();
	    response->failedSubOperations++;
#if STANDARD_VERSION < VERSION_JUL1993
	    cond = LST_Enqueue(&response->failedUIDList, UIDItem);
#else
	    cond = LST_Enqueue(&failedList, UIDItem);
#endif
	}
	response->remainingSubOperations--;
	response->conditionalFields |=
	    MSG_K_C_MOVE_REMAINING | MSG_K_C_MOVE_COMPLETED |
	    MSG_K_C_MOVE_FAILED | MSG_K_C_MOVE_WARNING;
    } else {
	if (response->status == MSG_K_CANCEL);
	else if (response->failedSubOperations == 0)
	    response->status = MSG_K_SUCCESS;
	else
	    response->status = MSG_K_C_MOVE_COMPLETEWITHFAILURES;

	if (response->status != MSG_K_CANCEL) {
#if STANDARD_VERSION < VERSION_JUL1993
	    response->dataSetType = DCM_CMDDATANULL;
	    if (LST_Count(&response->successUIDList) != 0)
		response->conditionalFields |= MSG_K_C_MOVE_SUCCESSUID;
	    if (LST_Count(&response->failedUIDList) != 0)
		response->conditionalFields |= MSG_K_C_MOVE_FAILEDUID;
	    if (LST_Count(&response->warningUIDList) != 0)
		response->conditionalFields |= MSG_K_C_MOVE_WARNINGUID;
#else
	    response->dataSetType = DCM_CMDDATANULL;
	    if (LST_Count(&failedList) != 0) {
		response->dataSetType = DCM_CMDDATAOTHER;
		cond = DCM_AddElementList(&response->dataSet, &e, failedList,
					  STRUCT_OFFSET(MSG_UID_ITEM, UID));
	    }
#endif
	    response->conditionalFields |=
		MSG_K_C_MOVE_REMAINING | MSG_K_C_MOVE_COMPLETED |
		MSG_K_C_MOVE_FAILED | MSG_K_C_MOVE_WARNING;
	} else {
#if STANDARD_VERSION >= VERSION_JUL1993
	    while ((UIDItem = LST_Dequeue(&failedList)) != NULL)
		free(UIDItem);
#endif
	}

	if (sendAssociation != NULL)
	    (void) DUL_ReleaseAssociation(&sendAssociation);
    }
    if (waitFlag) {
#ifdef _MSC_VER
	(void) Sleep(1000);
#else
	(void) sleep(1);
#endif
    }
    return SRV_NORMAL;
#endif
}


/* fakeDBQuery
**
** Purpose:
**	Enqueue queries in the query list and return to caller.
**
** Parameter Dictionary:
**	queryList	Handle to a list of queries
**
** Return Values:
**	None
**
** Notes:
**
** Algorithm:
**	Description of the algorithm (optional) and any other notes.
*/
static void
fakeDBQuery(LST_HEAD ** queryList)
{
#if 0
    char
       *l[] = {"MR", "CT"},
       *classes[] = {DICOM_SOPCLASSMR, DICOM_SOPCLASSCT};
    int
        index;
    Query
	* q;
    CONDITION
	cond;

    for (index = 0; index < (int) DIM_OF(l); index++) {
	q = malloc(sizeof(*q));
	if (q == NULL) {
	    fprintf(stderr, "malloc error in findMoveClasses\n");
	    exit(1);
	}
	strcpy(q->Series.Modality, l[index]);
	strcpy(q->Image.ClassUID, classes[index]);
	sprintf(q->Image.ImageUID, "1.2.840.%s", l[index]);
	strcpy(q->Image.FileName, "mr1.1");
	cond = LST_Enqueue(queryList, q);
	if (cond != LST_NORMAL) {
	    COND_DumpConditions();
	    exit(1);
	}
    }
#endif
}

/* establishSendAssociation
**
** Purpose:
**	Request for the specific service class and then establish an
**	Association
**
** Parameter Dictionary:
**	networkKey		Key describing the network connection
**	queryList		Handle to list of queries
**	moveDestination		Name of destination where images are to be moved
**	sendAssociation		Key describing the Association
**	params			Service parameters describing the Association
**
** Return Values:
**	DUL_NORMAL	on success
**
** Notes:
**
** Algorithm:
**	Description of the algorithm (optional) and any other notes.
*/
CONDITION
establishSendAssociation(DUL_NETWORKKEY ** networkKey,
			 LST_HEAD * queryList, char *moveDestination,
			 DUL_ASSOCIATIONKEY ** sendAssociation,
			 DUL_ASSOCIATESERVICEPARAMETERS * params)
{
#if 0
    Query
	* q;
    CONDITION
	cond;

    strcpy(params->calledPresentationAddress, moveDestination);
    q = LST_Head(&queryList);
    (void) LST_Position(&queryList, q);
    while (q != NULL) {
	cond = SRV_RequestServiceClass(q->Image.ClassUID, DUL_SC_ROLE_DEFAULT,
				       params);
	if (CTN_INFORM(cond))
	    (void) COND_PopCondition(FALSE);
	else if (cond != SRV_NORMAL)
	    return 0;		/* repair */
	q = LST_Next(&queryList);
    }
    cond = DUL_RequestAssociation(networkKey, params, sendAssociation);
    if (cond != DUL_NORMAL) {
	COND_DumpConditions();
	return 0;		/* repair */
    }
    return DUL_NORMAL;
#endif
}

/* sendCallback
**
** Purpose:
**	Callback routine for the C-SEND Response primitive
**
** Parameter Dictionary:
**	request		Pointer to request message
**	response	Pointer to response message
**	transmitted	Number of bytes sent
**	total		Total number of bytes to be sent
**	string		Context Information
**
** Return Values:
**	SRV_NORMAL
**
** Algorithm:
**	Description of the algorithm (optional) and any other notes.
*/
static CONDITION
sendCallback(MSG_C_STORE_REQ * request, MSG_C_STORE_RESP * response,
	     unsigned long transmitted, unsigned long total,
	     char *string)
{
    if (transmitted == 0)
	printf("Initial call to sendCallback\n");

    printf("%8d bytes transmitted of %8d (%s)\n", transmitted, total, string);

    if (response != NULL)
	MSG_DumpMessage(response, stdout);

    return SRV_NORMAL;
}

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
    if (strcmp(params->calledAPTitle, title) != 0) {
	abortItems->result = DUL_REJECT_PERMANENT;
	abortItems->source = DUL_ULSU_REJECT;
	abortItems->reason = DUL_ULSU_REJ_UNREC_CALLED_TITLE;
	cond = COND_PushCondition(APP_ILLEGALSERVICEPARAMETER,
				  APP_Message(APP_ILLEGALSERVICEPARAMETER),
				  "AE Title", params->calledAPTitle);
    }
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
