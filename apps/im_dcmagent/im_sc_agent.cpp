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

static char rcsid[] = "$Revision: 1.12 $ $RCSfile: im_sc_agent.cpp,v $";
#ifndef _WIN32
#include <unistd.h>
#endif

#include "MESA.hpp"
#include "ctn_api.h"

#include "MString.hpp"
#include "MDICOMWrapper.hpp"
#include "MDBImageManager.hpp"
#include "MStorageCommitItem.hpp"
#include "MStorageCommitRequest.hpp"
#include "MStorageCommitResponse.hpp"
#include "MDICOMDomainXlate.hpp"
#include "MDICOMReactor.hpp"
#include "MSOPHandler.hpp"
#include "MDICOMApp.hpp"

#ifdef SOLARIS
extern "C" {
int gethostname(char *name, int namelen);
};
#endif

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
Usage: im_sc_agent [-a title] [-c title] host port file\n\
\n\
    -a    Specify callng Application Entity Title (this application) \n\
    -c    Specify called Application Entity Title (server) \n\
\n\
    host  Host name of system running server \n\
    port  TCP/IP port of server application \n\
    file  Input file with commitment N-Action Request\n";

    (void) fprintf(stderr, usage);
    exit(1);
}

static void
myExit(DUL_ASSOCIATIONKEY ** association)
{
  ::fprintf(stderr, "Abnormal exit\n");
  ::COND_DumpConditions();

  if (association != NULL)
    if (*association != NULL)
      (void) ::DUL_DropAssociation(association);
  ::THR_Shutdown();
  ::exit(1);
}


static int
sendNEvent(MStorageCommitResponse& response,
	   const char* callingAETitle,
	   const char* calledAETitle,
	   const MString& host,
	   const MString& port)
{
  DUL_NETWORKKEY* network = 0;
  DUL_ASSOCIATIONKEY* association = 0;
  DUL_ASSOCIATESERVICEPARAMETERS params;
  CONDITION cond;

  char localHost[512] = "";
  char hostTxt[512];
  char portTxt[512];
  host.safeExport(hostTxt, sizeof(hostTxt));
  port.safeExport(portTxt, sizeof(portTxt));

#ifndef _WIN32
  (void) ::gethostname(localHost, sizeof(localHost));
#endif

  cond = ::DUL_InitializeNetwork(DUL_NETWORK_TCP, DUL_AEREQUESTOR,
				 NULL, 10, DUL_ORDERBIGENDIAN, &network);
  if (cond != DUL_NORMAL)
    myExit(&association);

  ::DUL_DefaultServiceParameters(&params);
  ::sprintf(params.calledPresentationAddress, "%s:%s", hostTxt, portTxt);
  ::strcpy(params.callingPresentationAddress, localHost);
  ::strcpy(params.calledAPTitle, calledAETitle);
  ::strcpy(params.callingAPTitle, callingAETitle);
  cond = ::SRV_RequestServiceClass(DICOM_SOPCLASSSTORAGECOMMITMENTPUSHMODEL,
				   DUL_SC_ROLE_SCP,
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

  MSOPHandler handler;
  MDICOMReactor reactor;

  DCM_OBJECT* responseObj;
  ::DCM_CreateObject(&responseObj, 0);

  MDICOMDomainXlate xlate;
  xlate.translateDICOM(response, responseObj);
  int eventTypeID;
  if (response.failureItemCount() == 0)
    eventTypeID = 1;
  else
    eventTypeID = 2;

  reactor.registerHandler(&handler,
			  DICOM_SOPCLASSSTORAGECOMMITMENTPUSHMODEL);
  handler.sendNEventReportRequest(&association, &params,
				  DICOM_SOPCLASSSTORAGECOMMITMENTPUSHMODEL,
				  DICOM_WELLKNOWNSTORAGECOMMITMENTPUSHMODEL,
				  eventTypeID,
				  &responseObj);

  reactor.processRequests(&association, &params, 1);

  ::DCM_CloseObject(&responseObj);

  cond = ::DUL_ReleaseAssociation(&association);
  if (cond != DUL_RELEASECONFIRMED) {
    (void) ::fprintf(stderr, "%x\n", cond);
    ::COND_DumpConditions();
  }
  (void) ::DUL_ClearServiceParameters(&params);

  (void) ::DUL_DropNetwork(&network);

  U16 rtnStatus = handler.lastStatus();
  if (rtnStatus != 0x0000) {
    MString comment = handler.lastComment();
    if (comment != "") {
      cerr << comment << endl;
    }
  }
  return rtnStatus;
}


int main(int argc, char **argv)
{
  CTNBOOLEAN
    verboseDCM = FALSE,
    done = FALSE,
    silent = FALSE;

  char* callingAETitle = "MESA_MGR";
  char* calledAETitle = "MODALITY";

  while (--argc > 0 && (*++argv)[0] == '-') {
    switch (*(argv[0] + 1)) {
    case 'a':
      argc--;
      argv++;
      if (argc < 1)
	usageerror();
      callingAETitle = *argv;
      break;
    case 'c':
      argc--;
      argv++;
      if (argc < 1)
	usageerror();
      calledAETitle = *argv;
      break;
    default:
      (void) fprintf(stderr, "Unrecognized option: %c\n", *(argv[0] + 1));
      break;
    }
  }

  if (argc < 3)
    usageerror();

  ::THR_Init();

  MString host(*argv++);
  MString port(*argv++);

  //cout << "im_ac_agent" << endl;
  //cout << " About to examine open SC request in file: " << *argv << endl;

  MDICOMWrapper w(*argv);

  MDICOMDomainXlate xlate;

  MStorageCommitRequest scRequest;

  xlate.translateDICOM(w, scRequest);

  MDBImageManager imageManager("imgmgr");

  //cout << scRequest.transactionUID() << endl;
  //cout << scRequest.retrieveAETitle() << endl;

  int count = scRequest.itemCount();
  int i = 1;

  MStorageCommitResponse scResponse;
  MString s;
  s = scRequest.transactionUID();
  scResponse.transactionUID(s);
  //cout << " Transaction UID: <" << s << ">" << endl;

  s = scRequest.retrieveAETitle();
  scResponse.retrieveAETitle(s);

  for (i = 0; i < count; i++) {
    MStorageCommitItem item = scRequest.item(i);
    //cout << " " << item << endl;

    imageManager.storageCommitmentStatus(item);

    if (item.status() == "0")
      scResponse.addSuccessItem(item);
    else
      scResponse.addFailureItem(item);
  }

  int status;

  //MDICOMApp app;
  //imageManager.selectDICOMApp(calledAETitle, app);
  //cout << app << endl;
  status = sendNEvent(scResponse, callingAETitle, calledAETitle, host, port);

  return status;
}
