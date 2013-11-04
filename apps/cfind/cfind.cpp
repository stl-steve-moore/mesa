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

static char rcsid[] = "$Revision: 1.21 $ $RCSfile: cfind.cpp,v $";

#include "ctn_os.h"

#include "MESA.hpp"
#include "ctn_api.h"
#include "MDICOMProxyTCP.hpp"
#include "MDICOMAssociation.hpp"
#include "MDICOMReactor.hpp"
#include "MWrapperFactory.hpp"
#include "MDICOMWrapper.hpp"
#include "MSOPHandler.hpp"
#include "MLQuery.hpp"

static void usageerror();
static void myExit(DUL_ASSOCIATIONKEY ** association);

DCM_OBJECT* createQueryObject(const char *fileName);
char* translateQueryClass(const char* str);
void printSupportedClasses();

int main(int argc, char **argv)
{
  char
    *calledAPTitle = "CFIND_SCP",
    *callingAPTitle = "CFIND_SCU";

  int port;
  char *node;

  CTNBOOLEAN
    verbose = FALSE;
  char *fileName = NULL;
  DUL_SC_ROLE
    role = DUL_SC_ROLE_DEFAULT;

  char* sopClass = DICOM_SOPMODALITYWORKLIST_FIND;
  char* outputPath = "";
  char* deltaFile = 0;

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
    case 'f':
      argc--;
      argv++;
      if (argc <= 0)
	usageerror();
      fileName = *argv;
      break;
    case 'o':
      argc--;
      argv++;
      if (argc <= 0)
	usageerror();
      outputPath = *argv;
      break;
    case 'p':
      printSupportedClasses();
      return 1;
      break;
    case 'v':
      verbose = TRUE;
      break;
    case 'x':
      argc--;
      argv++;
      if (argc <= 0)
	usageerror();
      sopClass = translateQueryClass(*argv);
      break;
    default:
      break;
    }
  }

  if (argc < 2)
    usageerror();

  ::THR_Init();
  ::DUL_Debug(verbose);
  ::SRV_Debug(verbose);

  node = *argv;
  if (sscanf(*++argv, "%d", &port) != 1)
    usageerror();

  MDICOMAssociation assoc;
  int status;
  status = assoc.registerSOPClass(sopClass,
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
      cerr << "Unable to apply delta file: " << deltaFile << endl;
      return 1;
    }
  }

  MLQuery qHandler(outputPath);
  MDICOMReactor reactor;

  reactor.registerHandler(&qHandler, sopClass);
  qHandler.sendCFindRequest(assoc, sopClass, w);
  reactor.processRequests(assoc, 1);

  ::DCM_CloseObject(&queryObj);

  assoc.releaseAssociation();

  ::THR_Shutdown();
  return 0;
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
cfind [-a title] [-c title] [-d delta] [-f file] [-o output] [-p] [-v] [-x class] node port\n\
\n\
    a     Application title of this application\n\
    c     Called AP title to use during Association setup\n\
    d     Delta file to apply to query before sending \n\
    f     File containing a dcm object with query\n\
    o     Output directory for responses\n\
    p     Print list of supported SOP class names\n\
    x     Use <class> as the SOP class for the C-Find operation\n\
    v     Verbose mode for DUL/SRV facilities\n\
\n\
    node  Node name of server\n\
    port  Port number of server\n";

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
