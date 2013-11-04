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

static char rcsid[] = "$Revision: 1.13 $ $RCSfile: naction.cpp,v $";

#include "ctn_os.h"

#include "MESA.hpp"
#include "ctn_api.h"
#include "MDICOMProxyTCP.hpp"
#include "MDICOMAssociation.hpp"
#include "MDICOMReactor.hpp"
#include "MSOPHandler.hpp"
#include "MLNAction.hpp"
#include "MDICOMWrapper.hpp"

DCM_OBJECT* createQueryObject(const char *fileName);
void printSupportedClasses();
void translateSOPClass(const char* synonym, char* translation);

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
naction [-a title] [-c title] [-l] [-p] [-v] node port class <create file> <instance UID>\n\
\n\
    a     Application title of this application\n\
    c     Called AP title to use during Association setup\n\
    l     List the expressions for supported DICOM SOP Classes\n\
    p     Dump service parameters after Association Request\n\
    v     Verbose mode for DUL/SRV facilities\n\
\n\
    node  Node name of server\n\
    port  Port number of server\n\
    class One of a set of key words to identify the DICOM SOP Class\n\
    <create file>  Name of the file with the N-Create object\n\
    <instance UID> SOP Instance UID of the object to be created\n";

    cerr << msg;
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

int main(int argc, char **argv)
{

  CONDITION			/* Return values from DUL and ACR routines */
    cond;
  char* calledAPTitle = "MPPSMGR";
  char* callingAPTitle = "MODALITY";

  int port;			/* TCP port used to establish Association */
  char *node;			/* The node we are calling */
  int actionID = 1;		// For the N-Action Request

  CTNBOOLEAN
    verbose = FALSE,
    abortFlag = FALSE,
    paramsFlag = FALSE;
  DUL_SC_ROLE
    role = DUL_SC_ROLE_DEFAULT;

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
      actionID = atoi(*argv);
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

  MDICOMAssociation assoc;
  int status;
    status = assoc.registerSOPClass(requestedSOPClass,
        DUL_SC_ROLE_DEFAULT,
        DICOM_TRANSFERLITTLEENDIAN);
    if (status != 0) {
      return 1;
    }

    MDICOMProxy* proxy = new MDICOMProxyTCP;

    if (proxy->connect(node, port) != 0) {
      cout << "Unable to connect to " << node << endl;
    }

    status = assoc.requestAssociation(*proxy, callingAPTitle, calledAPTitle);
    if (status != 0) {
      return 1;
    }

    DCM_OBJECT* queryObj = createQueryObject(fileName);

    MLNAction actionHandler;
    MDICOMReactor reactor;

    MDICOMWrapper w(queryObj);
    reactor.registerHandler(&actionHandler, requestedSOPClass);
    actionHandler.sendNActionRequest(assoc,
			requestedSOPClass,
			sopInstanceUID,
			actionID, w);
    reactor.processRequests(assoc, 1);

    ::DCM_CloseObject(&queryObj);

    assoc.releaseAssociation();

    ::THR_Shutdown();
    return 0;
}

