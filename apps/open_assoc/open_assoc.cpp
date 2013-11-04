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

static char rcsid[] = "$Revision: 1.14 $ $RCSfile: open_assoc.cpp,v $";

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
//#include <stl.h>
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
int gethostname(char *name, int namelen);
};
#endif

#include "MESA.hpp"
#include "ctn_api.h"

static void usageerror();
static void myExit(DUL_ASSOCIATIONKEY ** association);

static DUL_PRESENTATIONCONTEXT *
findPresentationContext(DUL_ASSOCIATESERVICEPARAMETERS * params, char *classUID) {
  DUL_PRESENTATIONCONTEXT * presentationCtx = NULL;

  if (params->acceptedPresentationContext == NULL)
    return NULL;

  presentationCtx = (DUL_PRESENTATIONCONTEXT*)::LST_Head(&params->acceptedPresentationContext);
  if (presentationCtx == NULL)
    return NULL;

  (void) ::LST_Position(&params->acceptedPresentationContext, presentationCtx);
  while (presentationCtx != NULL) {

    fprintf(stdout, "%d <%s> <%s>\n", presentationCtx->result,
		classUID, presentationCtx->abstractSyntax);

    if ((::strcmp(classUID, presentationCtx->abstractSyntax) == 0) &&
            (presentationCtx->result == DUL_PRESENTATION_ACCEPT))
      return presentationCtx;

    presentationCtx = (DUL_PRESENTATIONCONTEXT*)::LST_Next(&params->acceptedPresentationContext);
  }
  return NULL;
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
  char
    *calledAPTitle = "ECHO_SCP",
    *callingAPTitle = "ECHO_SCU";

  char localHost[40];

  int  port;			/* TCP port used to establish Association */
  char *node;			/* The node we are calling */

  int num = 1;		/* The starting message number for logs */

  CTNBOOLEAN
    verbose = FALSE,
    abortFlag = FALSE,
    paramsFlag = FALSE,
    classCheckFlag = FALSE;

  DUL_SC_ROLE
    role = DUL_SC_ROLE_DEFAULT;

  int sleepTime = 10;
  char* requestedSOPClass = DICOM_SOPCLASSVERIFICATION;

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
    case 'p':
      paramsFlag = TRUE;
      break;
    case 's':
      argc--; argv++;
      if (argc <= 0)
	usageerror();
      sleepTime = atoi(*argv);
      break;
    case 'v':
      verbose = TRUE;
      break;
    case 'x':
      argc--; argv++;
      if (argc <= 0)
	usageerror();
      requestedSOPClass = *argv;
      break;
    case 'z':
      classCheckFlag = TRUE;
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
  if (::sscanf(*++argv, "%d", &port) != 1)
    usageerror();
  (void) ::gethostname(localHost, sizeof(localHost));

  cond = ::DUL_InitializeNetwork(DUL_NETWORK_TCP, DUL_AEREQUESTOR,
				 NULL, 10, DUL_ORDERBIGENDIAN, &network);
  if (cond != DUL_NORMAL)
    myExit(&association);

  ::DUL_DefaultServiceParameters(&params);
  ::sprintf(params.calledPresentationAddress, "%s:%s", node, *argv);
  ::strcpy(params.callingPresentationAddress, localHost);
  ::strcpy(params.calledAPTitle, calledAPTitle);
  ::strcpy(params.callingAPTitle, callingAPTitle);
  cond = ::SRV_RegisterSOPClass(requestedSOPClass, role, &params);
  if (cond != SRV_NORMAL) {
    ::COND_DumpConditions();
    ::THR_Shutdown();
    ::exit(1);
  }
  cond = ::DUL_RequestAssociation(&network, &params, &association);
  if (cond != DUL_NORMAL) {
    if (cond == DUL_ASSOCIATIONREJECTED) {
      ::fprintf(stdout, "Association Rejected\n");
      ::fprintf(stdout, " Result: %2x Source %2x Reason %2x\n",
		params.result, params.resultSource,
		params.diagnostic);
    }
    myExit(&association);
  }
  if (verbose || paramsFlag) {
    (void) ::printf("Association accepted, parameters:\n");
    ::DUL_DumpParams(&params);
  }

  if (classCheckFlag) {
    DUL_PRESENTATIONCONTEXT* ctx = NULL;
    ctx = findPresentationContext(&params, requestedSOPClass);
    if (ctx == NULL) {
      ::printf("Assocation accepted, SOP class rejected %s\n", requestedSOPClass);
      myExit(&association);
    }
  }

#ifdef _WIN32
  ::Sleep(sleepTime*1000);
#else
  ::sleep (sleepTime);
#endif

  cond = ::DUL_ReleaseAssociation(&association);
#if 0
  if (cond != DUL_RELEASECONFIRMED) {
    (void) ::fprintf(stderr, "%x\n", cond);
    ::COND_DumpConditions();
  }
#endif
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
mwlquery [-a title] [-c title] [-p] [-s sleep] [-v] [-x UID] node port\n\
\n\
    a     Application title of this application\n\
    c     Called AP title to use during Association setup\n\
    p     Print Association Response parameters \n\
    s     Time to sleep before releasing association\n\
    x     Request SOP class identified by UID rather than default verification\n\
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
    fprintf(stdout, "Abnormal exit\n");
    COND_DumpConditions();

    if (association != NULL)
	if (*association != NULL)
	    (void) DUL_DropAssociation(association);
    THR_Shutdown();
    exit(1);
}






