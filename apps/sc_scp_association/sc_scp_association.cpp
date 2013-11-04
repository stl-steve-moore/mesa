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

static char rcsid[] = "$Revision: 1.6 $ $RCSfile: sc_scp_association.cpp,v $";

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
sc_scp_association [-a title] [-c title] [-v] node port \n\
\n\
    a     Application title of this application\n\
    c     Called AP title to use during Association setup\n\
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

static CONDITION
requestAssociation(const char* host, int port,
		   const char* callingAPTitle, const char* calledAPTitle,
		   DUL_SC_ROLE role,
		   DUL_NETWORKKEY* network,
		   DUL_ASSOCIATESERVICEPARAMETERS *params,
		   DUL_ASSOCIATIONKEY **association)
{
  CONDITION cond;

  ::memset(params, 0, sizeof(*params));
  ::DUL_DefaultServiceParameters(params);
  ::sprintf(params->calledPresentationAddress, "%s:%-d", host, port);
  ::strcpy(params->callingPresentationAddress, "");
  ::strcpy(params->calledAPTitle, calledAPTitle);
  ::strcpy(params->callingAPTitle, callingAPTitle);

  cond = ::SRV_RequestServiceClass(DICOM_SOPCLASSVERIFICATION,
				   DUL_SC_ROLE_DEFAULT, params);
  if (cond != SRV_NORMAL) {
    ::COND_DumpConditions();
    ::THR_Shutdown();
    ::exit(1);
  }

  cond = ::SRV_RequestServiceClass(DICOM_SOPCLASSSTORAGECOMMITMENTPUSHMODEL,
				   role, params);
  if (cond != SRV_NORMAL) {
    ::COND_DumpConditions();
    ::THR_Shutdown();
    ::exit(1);
  }

  cond = ::DUL_RequestAssociation(&network, params, association);
  if (cond != DUL_NORMAL) {
      if (cond == DUL_ASSOCIATIONREJECTED) {
	fprintf(stderr, "Association Rejected\n");
	fprintf(stderr, " Result: %2x Source %2x Reason %2x\n",
		    params->result, params->resultSource,
		    params->diagnostic);
      }
      myExit(association);
  }

  return cond;
}

// Test 1 is for normal association requests where the caller
// negotiates with the default SCU role.  This should not be
// accepted by the server application.

static int
test1(const char* host, int port,
		  const char* callingAPTitle, const char* calledAPTitle,
		  DUL_NETWORKKEY *network)
{
  DUL_ASSOCIATIONKEY *association = NULL;
  DUL_ASSOCIATESERVICEPARAMETERS params;
  CONDITION cond;

  cond = requestAssociation(host, port, callingAPTitle, calledAPTitle,
			    DUL_SC_ROLE_DEFAULT, network,
			    &params, &association);

  DUL_PRESENTATIONCONTEXT *ctx;
  ctx = (DUL_PRESENTATIONCONTEXT*)::LST_Head(&params.acceptedPresentationContext);

  ::LST_Position(&params.acceptedPresentationContext, ctx);
  bool pass = true;
  while (ctx != NULL) {
    if (strcmp(DICOM_SOPCLASSSTORAGECOMMITMENTPUSHMODEL,
	       ctx->abstractSyntax) == 0) {
      if (ctx->result == 0)
	pass = false;
    }
    ctx = (DUL_PRESENTATIONCONTEXT*)::LST_Next(&params.acceptedPresentationContext);
  }

  cond = ::DUL_ReleaseAssociation(&association);
  if (cond != DUL_RELEASECONFIRMED) {
    (void) ::fprintf(stderr, "%x\n", cond);
    ::COND_DumpConditions();
  }
  (void) ::DUL_ClearServiceParameters(&params);

  if (!pass) {
    cout << "WARN: Did not pass test 1; role negotiation with SCU/SCP default."
         << endl;
    cout << "WARN: Your server is a Storage Commitment SCU.  It should not accept" << endl
	 << "WARN: this association request where the caller proposes the " << endl
	 << "WARN: SCU default role" << endl
	 << "WARN: We will allow this because some SCPs do send the wrong request" << endl;
    return 0;
  } else {
    return 0;
  }
}

// Test 2 is for association requests with a proposed role of SCP.
// This should be accepted by the server.

static int
test2(const char* host, int port,
		  const char* callingAPTitle, const char* calledAPTitle,
		  DUL_NETWORKKEY *network)
{
  DUL_ASSOCIATIONKEY *association = NULL;
  DUL_ASSOCIATESERVICEPARAMETERS params;
  CONDITION cond;

  cond = requestAssociation(host, port, callingAPTitle, calledAPTitle,
			    DUL_SC_ROLE_SCP, network,
			    &params, &association);

  DUL_PRESENTATIONCONTEXT *ctx;
  ctx = (DUL_PRESENTATIONCONTEXT*)::LST_Head(&params.acceptedPresentationContext);

  ::LST_Position(&params.acceptedPresentationContext, ctx);
  bool pass = false;
  while (ctx != NULL) {
    if (strcmp(DICOM_SOPCLASSSTORAGECOMMITMENTPUSHMODEL,
	       ctx->abstractSyntax) == 0) {
      if ((ctx->acceptedSCRole == DUL_SC_ROLE_SCP) &&
		(ctx->result == 0))
	pass = true;
    }
    ctx = (DUL_PRESENTATIONCONTEXT*)::LST_Next(&params.acceptedPresentationContext);
  }

  cond = ::DUL_ReleaseAssociation(&association);
  if (cond != DUL_RELEASECONFIRMED) {
    (void) ::fprintf(stderr, "%x\n", cond);
    ::COND_DumpConditions();
  }
  (void) ::DUL_ClearServiceParameters(&params);

  if (!pass) {
    cout << "Did not pass test 2; role negotiation with SCP."
         << endl;
    cout << "Your server is a Storage Commitment SCU.  " << endl
	 << "The calling application proposes to be an SCP of the" << endl
	 << " Storage Commitment SOP Class.  Your server is supposed to" << endl
	 << " accept this role negotiation" << endl;
    return 1;
  } else {
    return 0;
  }
}


int main(int argc, char **argv)
{

  CONDITION			/* Return values from DUL and ACR routines */
    cond;
  DUL_NETWORKKEY		/* Used to initialize our network */
    * network = NULL;

  char* calledAPTitle = "MPPSMGR";
  char* callingAPTitle = "MODALITY";

  char* node;
  int port;			/* TCP port used to establish Association */

  CTNBOOLEAN
    verbose = FALSE,
    abortFlag = FALSE,
    paramsFlag = FALSE;

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
    case 'v':
      verbose = TRUE;
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

  cond = ::DUL_InitializeNetwork(DUL_NETWORK_TCP, DUL_AEREQUESTOR,
				 NULL, 10, DUL_ORDERBIGENDIAN, &network);
  if (cond != DUL_NORMAL)
    return 1;

  int rtnValue = 0;

  rtnValue = test1(node, port, callingAPTitle, calledAPTitle, network);

  rtnValue |= test2(node, port, callingAPTitle, calledAPTitle, network);

  (void) ::DUL_DropNetwork(&network);
  ::THR_Shutdown();
  return rtnValue;
}


