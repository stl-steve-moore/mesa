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

#include "MESA.hpp"
#include "MStorageAgent.hpp"
#include "MDICOMWrapper.hpp"
#include "MSOPHandler.hpp"
#include "MDICOMReactor.hpp"
#include "MLogClient.hpp"

#include <strstream>

static char rcsid[] = "$Id: MStorageAgent.cpp,v 1.11 2006/10/17 03:48:34 smm Exp $";

MStorageAgent::MStorageAgent() :
  mNetwork(0),
  mAssociation(0)
{
  ::memset(&mParams, 0, sizeof(mParams));
}

MStorageAgent::MStorageAgent(const MStorageAgent& cpy)
{
}

MStorageAgent::~MStorageAgent()
{
  MLogClient logClient;
  if (mNetwork != 0) {
    ::DUL_DropNetwork(&mNetwork);
    mNetwork = 0;
    ::COND_PopCondition(TRUE);
  }
}

void
MStorageAgent::printOn(ostream& s) const
{
  s << "MStorageAgent";
}

void
MStorageAgent::streamIn(istream& s)
{
  //s >> this->member;
}
 

// Non boiler plate methods below

int
MStorageAgent::storeInstance(const MString& callingAETitle,
			     const MString& calledAETitle,
			     const MString& host,
			     int port,
			     const MString& path,
			     U16& result,
			     MString& resultMessage)
{
  MDICOMWrapper w(path);

  int status;

  status = this->storeInstance(callingAETitle, calledAETitle, host, port,
			       w, result, resultMessage);

  return status;
}

int
MStorageAgent::storeInstance(const MString& callingAETitle,
			     const MString& calledAETitle,
			     const MString& host,
			     int port,
			     MDICOMWrapper& w,
			     U16& result,
			     MString& resultMessage)
{
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_VERBOSE,
	"", "MStorageAgent::storeInstance", __LINE__,
	"Enter method");

  DCM_OBJECT* obj = 0;
  int status;
  MString xferSyntaxFile = "";
  char tmp[1024] = "";

  if (w.groupPresent(0x0002)) {
    xferSyntaxFile = w.getString(0x00020010);
    w.removeGroup(0x0002);
    logClient.logTimeStamp(MLogClient::MLOG_VERBOSE,
	MString("Part 10 file with xfer syntax to be stored: ") + xferSyntaxFile);
  }
  obj = w.getNativeObject();
  MString sopClass = w.getString(DCM_IDSOPCLASSUID);

  if( (status = this->initialize()) != 0)
    return status;

  if( (status = this->requestAssociation(callingAETitle,
			   calledAETitle,
			   host,
			   port,
			   sopClass,
			   xferSyntaxFile)) != 0) {
    strstream x(tmp, sizeof(tmp)-1);
    x << "Unable to request association with these parameters"
	<< " calling AE " << callingAETitle
	<< " called AE " << calledAETitle
	<< " host " << host
	<< " port " << port
	<< " class " << sopClass
	<< " xfer " << xferSyntaxFile
	<< '\0';
    logClient.logTimeStamp(MLogClient::MLOG_ERROR, tmp);

    return status;
  }

  MSOPHandler handler;
  MDICOMReactor reactor;

  reactor.registerHandler(&handler, sopClass);
  if((status = handler.sendCStoreRequest(&mAssociation, &mParams, &obj)) != 0) {
    this->releaseAssociation();
    return CSTORE_REQ_FAILED;
  }

  reactor.processRequests(&mAssociation, &mParams, 1);

  this->releaseAssociation();

  logClient.log(MLogClient::MLOG_VERBOSE,
	"", "MStorageAgent::storeInstance", __LINE__,
	"Exit method");
  return 0;
}


// Private methods below
int
MStorageAgent::initialize()
{
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_VERBOSE,
	"", "MStorageAgent::initialize", __LINE__,
	"enter method");

  if (mNetwork == 0) {
    logClient.log(MLogClient::MLOG_VERBOSE,
	"MStorageAgent::initialize about to call DUL_InitializeNetwork");

    CONDITION cond;
    cond = ::DUL_InitializeNetwork(DUL_NETWORK_TCP, DUL_AEREQUESTOR,
				   NULL, 10, DUL_ORDERBIGENDIAN, &mNetwork);
    if (cond != DUL_NORMAL) {
      logClient.logCTNErrorStack(MLogClient::MLOG_ERROR, "");
      return NET_INIT_ERROR;
    }
  }
  ::COND_PopCondition(TRUE);
  return 0;
}

int
MStorageAgent::requestAssociation(const MString& callingAETitle,
				  const MString& calledAETitle,
				  const MString& host,
				  int port,
				  const MString& sopClass,
				  const MString& xferSyntax)
{
  MLogClient logClient;
  char classTxt[65];
  sopClass.safeExport(classTxt, sizeof(classTxt));
  char hostTxt[256];
  host.safeExport(hostTxt, sizeof(hostTxt));
  CONDITION cond;
  char* xferLittleEndian[] = { DICOM_TRANSFERLITTLEENDIAN,
	DICOM_TRANSFERLITTLEENDIANEXPLICIT };

  (void) ::DUL_ClearServiceParameters(&mParams);

  ::DUL_DefaultServiceParameters(&mParams);
  ::sprintf(mParams.calledPresentationAddress, "%s:%d", hostTxt, port);
  ::strcpy(mParams.callingPresentationAddress, "");

  calledAETitle.safeExport(mParams.calledAPTitle,
			   sizeof(mParams.calledAPTitle));
  callingAETitle.safeExport(mParams.callingAPTitle,
			    sizeof(mParams.callingAPTitle));


  if (xferSyntax == "") {	// Normal xfer syntax (default little endian)
    cond = ::SRV_RequestServiceClass(classTxt, DUL_SC_ROLE_DEFAULT, &mParams);
    if (cond != SRV_NORMAL) {
      logClient.logCTNErrorStack(MLogClient::MLOG_ERROR, "");
      ::COND_DumpConditions();
      return SRV_CLASS_ABNORMAL;
    }
  } else if (xferSyntax == DICOM_TRANSFERLITTLEENDIAN ||
	xferSyntax == DICOM_TRANSFERLITTLEENDIANEXPLICIT) {
    cond = ::SRV_ProposeSOPClassWithXfer(classTxt, DUL_SC_ROLE_DEFAULT,
		xferLittleEndian, 2, 1, &mParams);
    if (cond != SRV_NORMAL) {
      logClient.logCTNErrorStack(MLogClient::MLOG_ERROR, "");
      ::COND_DumpConditions();
      return SRV_CLASS_ABNORMAL;
    }
  } else {
    char xferSyntaxText[65] = "";
    xferSyntax.safeExport(xferSyntaxText, sizeof(xferSyntaxText));
    cond = ::SRV_RegisterSOPClassXfer(classTxt, xferSyntaxText,
		DUL_SC_ROLE_DEFAULT, &mParams);
    if (cond != SRV_NORMAL) {
      logClient.logCTNErrorStack(MLogClient::MLOG_ERROR, "");
      ::COND_DumpConditions();
      return SRV_CLASS_ABNORMAL;
    }
  }

  cond = ::DUL_RequestAssociation(&mNetwork, &mParams, &mAssociation);
  if (cond != DUL_NORMAL) {
    logClient.logCTNErrorStack(MLogClient::MLOG_ERROR, "");
    ::COND_DumpConditions();
    if (cond == DUL_ASSOCIATIONREJECTED) {
      char tmp[1024] = "";
      ::sprintf(tmp, "Association Rejected\n Result: %2x Source %2x Reason %2x\n",
		mParams.result, mParams.resultSource,
		mParams.diagnostic);
      logClient.logTimeStamp(MLogClient::MLOG_ERROR, tmp);
      return ASSOC_REQ_REJECTED;
    }
    if (cond == DUL_REQUESTASSOCIATIONFAILED) {
      char tmp[1024] = "";
      ::sprintf(tmp, "Association Rejectec\n Result: %2x Source %2x Reason %2x\n",
		mParams.result, mParams.resultSource,
		mParams.diagnostic);
      logClient.logTimeStamp(MLogClient::MLOG_ERROR, tmp);
      return ASSOC_REQ_FAILED;
    }
  }
  LST_HEAD* lst = mParams.acceptedPresentationContext;
  if (lst == NULL) {
	  logClient.logTimeStamp(MLogClient::MLOG_ERROR, "No presentation contexts returned from association request");
	  return ASSOC_REQ_FAILED;
  }
  LST_NODE *n = LST_Head(&lst);
  DUL_PRESENTATIONCONTEXT* ctx = (DUL_PRESENTATIONCONTEXT*)n;
  if (ctx->result != 0) {
	  char txt[1024] = "";
	  strstream xx(txt, sizeof txt);
	  switch (ctx->result) {
		  case 1:
			  xx << "SOP Class rejected: 1/user" << '\0';
			  break;
		  case 2:
			  xx << "SOP Class rejected: 2/No reason given" << '\0';
			  break;
		  case 3:
			  xx << "SOP Class rejected: 3/Abstract syntax" << '\0';
			  break;
		  case 4:
			  xx << "SOP Class rejected: 4/Transfer syntax" << '\0';
			  break;
		  default:
			  xx << "SOP Class rejected: Unrecognized code " << ctx->result << '\0';
			  break;
	  }
	  logClient.logTimeStamp(MLogClient::MLOG_ERROR, txt);
	  return ASSOC_REQ_FAILED;
  }

  ::COND_PopCondition(TRUE);
  return 0;
}

int
MStorageAgent::releaseAssociation()
{
  if (mAssociation != 0) {
    CONDITION cond;

    cond = ::DUL_ReleaseAssociation(&mAssociation);
    if (cond != DUL_RELEASECONFIRMED) {
      // Dump error code if here.
      // We should use MLogClient for this.
    }

    ::DUL_DropAssociation(&mAssociation);

    (void) ::DUL_ClearServiceParameters(&mParams);

    ::COND_PopCondition(TRUE);
    mAssociation = 0;
  }

  return 0;
}
