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

static char rcsid[] = "$Revision: 1.5 $ $RCSfile: cfind_image_avail.cpp,v $";

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

#include "MESA.hpp"
#include "ctn_api.h"
#include "MDICOMReactor.hpp"
#include "MDICOMWrapper.hpp"
#include "MSOPHandler.hpp"
#include "MLQuery.hpp"

#ifdef SOLARIS
extern "C" {
int gethostname(char *name, int namelen);
};
#endif

static void usageerror();
static void myExit(DUL_ASSOCIATIONKEY ** association);

static DCM_OBJECT *
createQueryObject(const char *fileName)
{
    DCM_OBJECT *obj;
    CONDITION cond;

    MDICOMWrapper mppsWrapper(fileName);
    cond = ::DCM_CreateObject(&obj, 0);
    if (cond != DCM_NORMAL) {
	::COND_DumpConditions();
	exit(1);
    }
    MDICOMWrapper w(obj);

    w.setString(0x00080052, "IMAGE");
    MString s;

    s = mppsWrapper.getString(0x00400270,	// Scheduled Step Attribute Seq
			      0x0020000D);	// Study Instance UID
    w.setString(0x0020000D, s);

    s = mppsWrapper.getString(0x00400340,	// Performed Series Sequence
			      0x0020000E);	// Series Instance UID
    w.setString(0x0020000E, s);

    w.setString(0x00080016, "");		// SOP Class UID
    w.setString(0x00080018, "");		// SOP Instance UID

    return obj;
}

int main(int argc, char **argv)
{

  CONDITION cond;
  DUL_NETWORKKEY* network = NULL;
  DUL_ASSOCIATIONKEY* association = NULL;
  DUL_ASSOCIATESERVICEPARAMETERS params;
  char
    *calledAPTitle = "CFIND_SCP",
    *callingAPTitle = "CFIND_SCU";

  int port;
  char *node;

  CTNBOOLEAN
    verbose = FALSE,
    abortFlag = FALSE,
    paramsFlag = FALSE;
  char *fileName = NULL;
  DUL_SC_ROLE
    role = DUL_SC_ROLE_DEFAULT;

  char* sopClass = DICOM_SOPSTUDYQUERY_FIND;
  char* outputPath = "";

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
    case 'o':
      argc--;
      argv++;
      if (argc <= 0)
	usageerror();
      outputPath = *argv;
      break;
    case 'v':
      verbose = TRUE;
      break;
    default:
      break;
    }
  }

  if (argc < 3)
    usageerror();

  ::THR_Init();
  ::DUL_Debug(verbose);
  ::SRV_Debug(verbose);

  node = *argv;
  if (::sscanf(*++argv, "%d", &port) != 1)
    usageerror();

  cond = DUL_InitializeNetwork(DUL_NETWORK_TCP, DUL_AEREQUESTOR,
				 NULL, 10, DUL_ORDERBIGENDIAN, &network);
  if (cond != DUL_NORMAL)
    myExit(&association);

  ::DUL_DefaultServiceParameters(&params);
  ::sprintf(params.calledPresentationAddress, "%s:%s", node, *argv);
  ::strcpy(params.callingPresentationAddress, "");
  ::strcpy(params.calledAPTitle, calledAPTitle);
  ::strcpy(params.callingAPTitle, callingAPTitle);
  cond = ::SRV_RequestServiceClass(sopClass, role, &params);
  if (cond != SRV_NORMAL) {
    ::COND_DumpConditions();
    ::THR_Shutdown();
    ::exit(1);
  }

  cond = ::DUL_RequestAssociation(&network, &params, &association);
  if (cond != DUL_NORMAL) {
    if (cond == DUL_ASSOCIATIONREJECTED) {
      ::fprintf(stderr, "Association Rejected\n");
      ::fprintf(stderr, " Result: %2x Source %2x Reason %2x\n",
		params.result, params.resultSource,
		params.diagnostic);
    }
    myExit(&association);
  }
  if (verbose || paramsFlag) {
    (void) ::printf("Association accepted, parameters:\n");
    ::DUL_DumpParams(&params);
  }

  fileName = *++argv;
  DCM_OBJECT* queryObj = createQueryObject(fileName);

  MLQuery qHandler(outputPath);
  MDICOMReactor reactor;

  reactor.registerHandler(&qHandler, sopClass);
  qHandler.sendCFindRequest(&association, &params,
			    sopClass, &queryObj);
  reactor.processRequests(&association, &params, 1);

  ::DCM_CloseObject(&queryObj);

  cond = ::DUL_ReleaseAssociation(&association);
  if (cond != DUL_RELEASECONFIRMED) {
    (void) ::fprintf(stderr, "%x\n", cond);
    ::COND_DumpConditions();
  }
  (void) ::DUL_ClearServiceParameters(&params);

  (void) ::DUL_DropNetwork(&network);
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
cfind_image_avail [-a title] [-c title] [-o output] [-v] node port <MPPS status file>\n\
\n\
    a     Application title of this application\n\
    c     Called AP title to use during Association setup\n\
    o     Store responses in directory named <output>\n\
    v     Verbose mode for DUL/SRV facilities\n\
\n\
    node  Node name of server\n\
    port  Port number of server\n\
    file  File containing final MPPS status";

    cerr << msg << endl;
    ::exit(1);
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
    cerr << "Abnormal exit" << endl;
    ::COND_DumpConditions();

    if (association != NULL)
	if (*association != NULL)
	    (void) ::DUL_DropAssociation(association);
    ::THR_Shutdown();
    ::exit(1);
}
