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

static char rcsid[] = "$Revision: 1.3 $ $RCSfile: cmove_study.cpp,v $";

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
#include "MSOPHandler.hpp"
#include "MLQuery.hpp"
#include "MLMove.hpp"
#include "MDICOMWrapper.hpp"
#include "ctn_api.h"

#ifdef SOLARIS
extern "C" {
int gethostname(char *name, int namelen);
};
#endif


static void
usageerror()
{
    char msg[] = "\
cmove_study [-a title] [-c title] [-p] [-v] [-x class] node port tag value dest\n\
\n\
    a     Application title of this application\n\
    c     Called AP title to use during Association setup\n\
    f     File containing a dcm object with query\n\
    v     Verbose mode for DUL/SRV facilities\n\
\n\
    node  Node name of server\n\
    port  Port number of server\n\
    tag   Tag of attribute for Study level query\n\
    value Value to use to select study \n\
    dest  AE title of destination system\n";

    fprintf(stderr, msg);
    exit(1);
}
static void myExit(DUL_ASSOCIATIONKEY ** association);


typedef struct {
  char* synonym;
  char* sopClass;
} STRING_MAP;

static STRING_MAP m1[] = {
  { "PATIENT", DICOM_SOPPATIENTQUERY_FIND },
  { "STUDY", DICOM_SOPSTUDYQUERY_FIND },
  { DICOM_SOPPATIENTQUERY_FIND, DICOM_SOPPATIENTQUERY_FIND },
  { DICOM_SOPSTUDYQUERY_FIND, DICOM_SOPSTUDYQUERY_FIND }
};


int main(int argc, char **argv)
{

  CONDITION cond;
  DUL_NETWORKKEY* network = NULL;
  DUL_ASSOCIATIONKEY* association = NULL;
  DUL_ASSOCIATESERVICEPARAMETERS params;
  char
    *calledAPTitle = "CFIND_SCP",
    *callingAPTitle = "CFIND_SCU";

  char localHost[40];

  int port;
  char *nodeText;
  char *portText;
  char *tagText;
  char *valueText;
  char *destinationText;

  CTNBOOLEAN
    verbose = FALSE,
    abortFlag = FALSE,
    paramsFlag = FALSE;
  char *fileName = NULL;
  bool localVerbose = false;
  DUL_SC_ROLE
    role = DUL_SC_ROLE_DEFAULT;

  char* sopClassFind = DICOM_SOPSTUDYQUERY_FIND;
  char* sopClassMove = DICOM_SOPSTUDYQUERY_MOVE;
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
    case 'z':
      localVerbose = TRUE;
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

  nodeText = *argv++;
  portText = *argv++;
  tagText = *argv++;
  valueText = *argv++;
  destinationText = *argv++;

  if (sscanf(portText, "%d", &port) != 1)
    usageerror();

  if( gethostname(localHost, sizeof(localHost)) != 0) {
	  // gethostname is failing under Win32
	  //fprintf(stderr, "gethostname() failed.\n");
  }

  cond = DUL_InitializeNetwork(DUL_NETWORK_TCP, DUL_AEREQUESTOR,
				 NULL, 10, DUL_ORDERBIGENDIAN, &network);
  if (cond != DUL_NORMAL)
    myExit(&association);

  ::DUL_DefaultServiceParameters(&params);
  ::sprintf(params.calledPresentationAddress, "%s:%s", nodeText, portText);
  ::strcpy(params.callingPresentationAddress, localHost);
  ::strcpy(params.calledAPTitle, calledAPTitle);
  ::strcpy(params.callingAPTitle, callingAPTitle);
  cond = ::SRV_RequestServiceClass(sopClassFind, role, &params);
  if (cond != SRV_NORMAL) {
    ::COND_DumpConditions();
    ::THR_Shutdown();
    ::exit(1);
  }
  cond = ::SRV_RequestServiceClass(sopClassMove, role, &params);
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

  MDICOMWrapper qStudy;
  qStudy.setString(DCM_IDQUERYLEVEL, "STUDY");
  DCM_TAG tag;
#ifdef _WIN32
  tag = ::strtol(tagText, 0, 16);
#else
  tag = ::strtoll(tagText, 0, 16);
#endif
  qStudy.setString(DCM_RELSTUDYINSTANCEUID, "");
  qStudy.setString(tag, valueText);
  
  DCM_OBJECT* queryObj = qStudy.getNativeObject();

  MLQuery qHandlerStudy(outputPath);
  MLMove moveHandler;
  moveHandler.verbose(localVerbose);

  MDICOMReactor reactor;

  reactor.registerHandler(&qHandlerStudy, sopClassFind);
  qHandlerStudy.sendCFindRequest(&association, &params,
			    sopClassFind, &queryObj);
  reactor.processRequests(&association, &params, 1);

  WRAPPERVector studyVector = qHandlerStudy.wrapperVector();


  WRAPPERVector::iterator studyIterator = studyVector.begin();
  for (; studyIterator != studyVector.end(); studyIterator++) {
    MDICOMWrapper* w = *studyIterator;

    MDICOMWrapper moveRequest;
    MString studyUID = w->getString(DCM_RELSTUDYINSTANCEUID);
    moveRequest.setString(DCM_RELSTUDYINSTANCEUID, studyUID);
    moveRequest.setString(DCM_IDQUERYLEVEL, "STUDY");
    DCM_OBJECT* moveObj = moveRequest.getNativeObject();

    reactor.registerHandler(&moveHandler, sopClassMove);
    moveHandler.sendCMoveRequest(&association, &params,
				 sopClassMove, destinationText, &moveObj);

    reactor.processRequests(&association, &params, 1);
  }

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
