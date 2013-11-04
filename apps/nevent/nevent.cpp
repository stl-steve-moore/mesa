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

static char rcsid[] = "$Revision: 1.9 $ $RCSfile: nevent.cpp,v $";

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#ifdef _WIN32
#include <io.h>
#include <winsock.h>
#else
#include <unistd.h>
#include <sys/file.h>
#endif
#include <sys/types.h>
#include <sys/stat.h>

#ifdef SOLARIS
extern "C" {
int gethostname(char* name, int namelen);
};
#endif

#include "MESA.hpp"
#include "ctn_api.h"
#include "MDICOMReactor.hpp"
#include "MSOPHandler.hpp"
#include "MLNEventReport.hpp"

static DCM_OBJECT *
createQueryObject(const char *fileName)
{
    DCM_OBJECT *obj;
    CONDITION cond;
    DCM_ELEMENT e;
    char txt[1024] = "";

    int group = 0;
    int element = 0;
    char textValue[1024];

    if (fileName != NULL) {
	cond = DCM_OpenFile(fileName, DCM_ORDERLITTLEENDIAN, &obj);
	if (cond != DCM_NORMAL) {
	    COND_DumpConditions();
	    exit(1);
	}
	return obj;
    }
    cond = DCM_CreateObject(&obj, 0);
    if (cond != DCM_NORMAL) {
	COND_DumpConditions();
	exit(1);
    }
    while (fgets(txt, sizeof(txt), stdin) != NULL) {
	if (txt[0] == '#' || txt[0] == '\0')
	    continue;
	if (txt[0] == '\n' || txt[0] == '\r')
	    continue;

	if (sscanf(txt, "%x %x %[^\n]", &group, &element, textValue) != 3)
	    continue;

	e.tag = DCM_MAKETAG(group, element);
	DCM_LookupElement(&e);
	if (strncmp(textValue, "#", 1) == 0) {
	    e.length = 0;
	    e.d.string = NULL;
	} else {
	    e.length = strlen(textValue);
	    e.d.string = textValue;
	}

	cond = DCM_AddElement(&obj, &e);
	if (cond != DCM_NORMAL) {
	    COND_DumpConditions();
	    exit(1);
	}
    }

    return obj;
}

/* usageerror
**
** Purpose:
**	Print the usage message for this program and exit.
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
    char msg[] = "\
nevent [-a title] [-c title] [-l] [-p] [-v] node port class <create file> <instance UID>\n\
\n\
    a     Application title of this application\n\
    c     Called AP title to use during Association setup\n\
    f     File containing a dcm object with query\n\
    l     List the expressions for supported DICOM SOP Classes\n\
    p     Dump service parameters after Association Request\n\
    v     Verbose mode for DUL/SRV facilities\n\
\n\
    node  Node name of server\n\
    port  Port number of server\n\
    class One of a set of key words to identify the DICOM SOP Class\n\
    <create file>  Name of the file with the N-Create object\n\
    <instance UID> SOP Instance UID of the object to be created\n";

    fprintf(stderr, msg);
    exit(1);
}


/* myExit
**
** Purpose:
**	Exit routines which closes network connections, dumps error
**	messages and exits.
**
** Parameter Dictionary:
**	association	A handle for an association which is possibly open.
**
** Return Values:
**	None
**
** Algorithm:
**	Description of the algorithm (optional) and any other notes.
*/

static void
myExit(DUL_ASSOCIATIONKEY ** association)
{
    fprintf(stderr, "Abnormal exit\n");
    COND_DumpConditions();

    if (association != NULL)
	if (*association != NULL)
	    (void) DUL_DropAssociation(association);
    THR_Shutdown();
    exit(1);
}

typedef struct {
  char* sopClass;
  char* synonym;
} CLASS_MAP;

CLASS_MAP m1[] = {
  { DICOM_SOPCLASSSTORAGECOMMITMENTPUSHMODEL, "commitment" },
  { DICOM_SOPCLASSSTORAGECOMMITMENTPUSHMODEL, "commit" },
  { DICOM_SOPCLASSSTORAGECOMMITMENTPUSHMODEL, DICOM_SOPCLASSSTORAGECOMMITMENTPUSHMODEL }

};

static void
printSupportedClasses()
{
  int i;

  for (i = 0; i < (int)DIM_OF(m1); i++) {
    cout << m1[i].sopClass << " " << m1[i].synonym << endl;
  }
}

static void
translateSOPClass(const char* synonym, char* translation)
{
  int i;

  for (i = 0; i < (int)DIM_OF(m1); i++) {
    if (strcmp(m1[i].synonym, synonym) == 0) {
      strcpy(translation, m1[i].sopClass);
      return;
    }
  }
  strcpy(translation, synonym);
}


int main(int argc, char **argv)
{

  CONDITION			/* Return values from DUL and ACR routines */
    cond;
  DUL_NETWORKKEY		/* Used to initialize our network */
    * network = NULL;
  DUL_ASSOCIATIONKEY		/* Describes the Association with the
				 * Acceptor */
    * association = NULL;
  DUL_ASSOCIATESERVICEPARAMETERS	/* The items which describe this
					 * Association */
    params;
  char* calledAPTitle = "MPPSMGR";
  char* callingAPTitle = "MODALITY";

  char localHost[40];

  int port;			/* TCP port used to establish Association */
  char *node;			/* The node we are calling */
  int eventTypeID = 1;		// For the N-Event Request

  CTNBOOLEAN
    verbose = FALSE,
    abortFlag = FALSE,
    paramsFlag = FALSE;
  DUL_SC_ROLE
    role = DUL_SC_ROLE_SCP;

  while (--argc > 0 && (*++argv)[0] == '-') {
    switch (*(argv[0] + 1)) {
    case 'a':
      argc--;
      argv++;
      if (argc <= 0)
	usageerror();
      callingAPTitle = *argv;
      break;
    case 'c':
      argc--;
      argv++;
      if (argc <= 0)
	usageerror();
      calledAPTitle = *argv;
      break;
    case 'i':
      argc--;
      argv++;
      if (argc <= 0)
	usageerror();
      eventTypeID = atoi(*argv);
      break;
    case 'l':
      printSupportedClasses();
      return 0;
      break;
    case 'p':
      paramsFlag = TRUE;
      break;
    case 'v':
      verbose = TRUE;
      break;
    default:
      break;
    }
  }

  if (argc < 5)
    usageerror();

    ::THR_Init();
    ::DUL_Debug(verbose);
    ::SRV_Debug(verbose);

    node = *argv;
    if (sscanf(*++argv, "%d", &port) != 1)
	usageerror();

    argv++;
    char requestedSOPClass[DICOM_UI_LENGTH+1];
    translateSOPClass(*argv, requestedSOPClass);

    char* fileName = *++argv;
    MString sopInstanceUID(*++argv);

    (void) ::gethostname(localHost, sizeof(localHost));

    cond = ::DUL_InitializeNetwork(DUL_NETWORK_TCP, DUL_AEREQUESTOR,
				 NULL, 10, DUL_ORDERBIGENDIAN, &network);
    if (cond != DUL_NORMAL)
	myExit(&association);

    ::DUL_DefaultServiceParameters(&params);
    ::sprintf(params.calledPresentationAddress, "%s:%-d", node, port);
    ::strcpy(params.callingPresentationAddress, localHost);
    ::strcpy(params.calledAPTitle, calledAPTitle);
    ::strcpy(params.callingAPTitle, callingAPTitle);
    cond = ::SRV_RequestServiceClass(requestedSOPClass, role,
				     &params);
    if (cond != SRV_NORMAL) {
	::COND_DumpConditions();
	::THR_Shutdown();
	::exit(1);
    }
    cond = ::DUL_RequestAssociation(&network, &params, &association);
    if (cond != DUL_NORMAL) {
	if (cond == DUL_ASSOCIATIONREJECTED) {
	    fprintf(stderr, "Association Rejected\n");
	    fprintf(stderr, " Result: %2x Source %2x Reason %2x\n",
		    params.result, params.resultSource,
		    params.diagnostic);
	}
	myExit(&association);
    }
    if (verbose || paramsFlag) {
	(void) printf("Association accepted, parameters:\n");
	::DUL_DumpParams(&params);
    }
    DCM_OBJECT* queryObj = createQueryObject(fileName);

    MLNEventReport eventReportHandler;
    MDICOMReactor reactor;

    reactor.registerHandler(&eventReportHandler, requestedSOPClass);
    eventReportHandler.sendNEventReportRequest(&association, &params,
					       requestedSOPClass,
					       sopInstanceUID,
					       eventTypeID,
					       &queryObj);

    reactor.processRequests(&association, &params, 1);

    ::DCM_CloseObject(&queryObj);

    cond = DUL_ReleaseAssociation(&association);
    if (cond != DUL_RELEASECONFIRMED) {
	(void) fprintf(stderr, "%x\n", cond);
	COND_DumpConditions();
    }
    (void) DUL_ClearServiceParameters(&params);

    (void) DUL_DropNetwork(&network);
    THR_Shutdown();
    return 0;
}


