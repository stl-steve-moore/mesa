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

static char rcsid[] = "$Revision: 1.15 $ $RCSfile: nset.cpp,v $";

#include "ctn_os.h"
#include "MESA.hpp"
#include "ctn_api.h"
#include "MDICOMProxyTCP.hpp"
#include "MDICOMAssociation.hpp"
#include "MDICOMReactor.hpp"
#include "MSOPHandler.hpp"
#include "MLNSet.hpp"
#include "MDICOMWrapper.hpp"
#include "MWrapperFactory.hpp"

DCM_OBJECT *createQueryObject(const char *fileName);
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
nset [-a title] [-c title] [-l] [-p] [-v] node port class <create file> <instance UID>\n\
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

int main(int argc, char **argv)
{

  CONDITION			/* Return values from DUL and ACR routines */
    cond;
  char* calledAPTitle = "MPPSMGR";
  char* callingAPTitle = "MODALITY";
  char *deltaFile = 0;

  int port;			/* TCP port used to establish Association */
  char *node;			/* The node we are calling */
  MLogClient::LOGLEVEL logLevel = MLogClient::MLOG_NONE;

  CTNBOOLEAN
    verbose = FALSE;
  DUL_SC_ROLE
    role = DUL_SC_ROLE_DEFAULT;
  int simulateCTNError = 0;

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
    case 'd':
      argc--;
      argv++;
      if (argc <= 0)
	usageerror();
      deltaFile = *argv;
      break;
    case 'e':
      simulateCTNError = 1;
      break;
    case 'l':
      printSupportedClasses();
      return 0;
      break;
    case 'L':
      argc--;
      argv++;
      if (argc <= 0)
	usageerror();
      // Ignore the log level for now.
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
    ::SRV_SimulateError(simulateCTNError);

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
    MDICOMWrapper w(queryObj);
    if (deltaFile != 0) {
      MWrapperFactory factory;
      if (factory.modifyWrapper(w, deltaFile) != 0) {
	cerr << "Unable to apply delta file: " << deltaFile
	     << " to: " << fileName << endl;
	return 1;
      }
    }

    MLNSet setHandler;
    MDICOMReactor reactor;

    reactor.registerHandler(&setHandler, requestedSOPClass);
    setHandler.sendNSetRequest(assoc,
			       requestedSOPClass,
			       sopInstanceUID, w);
    reactor.processRequests(assoc, 1);

    ::DCM_CloseObject(&queryObj);

    assoc.releaseAssociation();

    ::THR_Shutdown();
    return 0;
}

