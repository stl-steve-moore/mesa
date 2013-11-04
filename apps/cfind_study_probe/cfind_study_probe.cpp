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

static char rcsid[] = "$Revision: 1.5 $ $RCSfile: cfind_study_probe.cpp,v $";

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
#include "MDICOMWrapper.hpp"

#ifdef SOLARIS
extern "C" {
int gethostname(char *name, int namelen);
};
#endif

static void usageerror();
static void myExit(DUL_ASSOCIATIONKEY ** association);


static void
usageerror()
{
    char msg[] = "\
cfind [-a title] [-c title] [-o path] [-v] node port <patient ID> q1 q2 q3\n\
\n\
    a     Application title of this application\n\
    c     Called AP title to use during Association setup\n\
    o     Set output path to record query results \n\
    v     Verbose mode for DUL/SRV facilities\n\
\n\
    node           Node name of server\n\
    port           Port number of server\n\
    patient ID     Identify the patient to select\n\
    q1             CTN file with study level query\n\
    q2             CTN file with series level query\n\
    q3             CTN file with image level query\n";

    cerr << msg << endl;
    ::exit(1);
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

  char localHost[40] = "";

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

  if (argc < 5)
    usageerror();

  ::THR_Init();
  ::DUL_Debug(verbose);
  ::SRV_Debug(verbose);

  node = *argv;
  if (sscanf(*++argv, "%d", &port) != 1)
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
  ::sprintf(params.calledPresentationAddress, "%s:%s", node, *argv);
  ::strcpy(params.callingPresentationAddress, localHost);
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

  MString patientID(*++argv);
  MDICOMWrapper qStudy(*++argv);
  qStudy.setString(0x00100020, patientID);
  MDICOMWrapper qSeries(*++argv);
  MDICOMWrapper qSOPInstance(*++argv);

  DCM_OBJECT* queryObj = qStudy.getNativeObject();

  MLQuery qHandlerStudy(outputPath);
  MLQuery qHandlerSeries(outputPath);
  MLQuery qHandlerInstance(outputPath);

  MDICOMReactor reactor;

  reactor.registerHandler(&qHandlerStudy, sopClass);
  qHandlerStudy.sendCFindRequest(&association, &params,
			    sopClass, &queryObj);
  reactor.processRequests(&association, &params, 1);

  WRAPPERVector studyVector = qHandlerStudy.wrapperVector();


  WRAPPERVector::iterator studyIterator = studyVector.begin();
  for (; studyIterator != studyVector.end(); studyIterator++) {
    MDICOMWrapper* w = *studyIterator;

    DCM_OBJECT* obj = w->getNativeObject();
    ::DCM_FormatElements(&obj, 1, "");
    reactor.registerHandler(&qHandlerSeries, sopClass);

    MString studyUID = w->getString(0x0020000D);
    qSeries.setString(0x0020000D, studyUID);

    DCM_OBJECT* seriesQueryObj = qSeries.getNativeObject();
    qHandlerSeries.sendCFindRequest(&association, &params,
				    sopClass, &seriesQueryObj);

    qHandlerSeries.clearVector();
    reactor.processRequests(&association, &params, 1);

    WRAPPERVector seriesVector = qHandlerSeries.wrapperVector();

    WRAPPERVector::iterator seriesIterator = seriesVector.begin();
    for (; seriesIterator != seriesVector.end(); seriesIterator++) {
      MDICOMWrapper* w2 = *seriesIterator;
      DCM_OBJECT* objSeries = w2->getNativeObject();
      ::DCM_FormatElements(&objSeries, 1, "  ");

      reactor.registerHandler(&qHandlerInstance, sopClass);
      MString seriesUID = w2->getString(0x0020000E);
      qSOPInstance.setString(0x0020000D, studyUID);
      qSOPInstance.setString(0x0020000E, seriesUID);
      DCM_OBJECT* instanceQueryObj = qSOPInstance.getNativeObject();
      qHandlerInstance.sendCFindRequest(&association, &params,
					sopClass, &instanceQueryObj);
      qHandlerInstance.clearVector();
      reactor.processRequests(&association, &params, 1);

      WRAPPERVector instanceVector = qHandlerInstance.wrapperVector();

      WRAPPERVector::iterator instanceIterator = instanceVector.begin();
      for (; instanceIterator != instanceVector.end(); instanceIterator++) {
	MDICOMWrapper* w3 = *instanceIterator;
	DCM_OBJECT* objInstance = w3->getNativeObject();
	::DCM_FormatElements(&objInstance, 1, "    ");
      }
    }
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
