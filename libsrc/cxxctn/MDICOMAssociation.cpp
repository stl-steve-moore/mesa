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

#include "ctn_os.h"

#include "MESA.hpp"
#include "MDICOMAssociation.hpp"
#include "MDICOMProxy.hpp"
#include "MString.hpp"
#include "MSOPHandler.hpp"
#include "MLogClient.hpp"

MDICOMAssociation::MDICOMAssociation() :
  mNetworkKey(0),
  mAssociationKey(0)
{
}

MDICOMAssociation::MDICOMAssociation(const MDICOMAssociation& cpy)

{
}

MDICOMAssociation::~MDICOMAssociation()
{
}

void
MDICOMAssociation::printOn(ostream& s) const
{
  s << "MDICOMAssociation";
}

void
MDICOMAssociation::streamIn(istream& s)
{
  //s >> this->member;
}

// Non-boilerplate methods follow.

int
MDICOMAssociation::registerSOPClass(const MString& sopClass,
    DUL_SC_ROLE role, const MString& xferSyntax1,
    const MString& xferSyntax2, const MString& xferSyntax3)
{
  CONDITION cond = 0;

  if (mNetworkKey == 0) {
    cond = ::DUL_InitializeNetwork(DUL_NETWORK_TCP, DUL_AEREQUESTOR,
			NULL, DUL_TIMEOUT, DUL_ORDERBIGENDIAN,
			&mNetworkKey);
    if (cond != DUL_NORMAL) {
      MLogClient logClient;
      logClient.log(MLogClient::MLOG_ERROR, "<none>", "MDICOMAssociation::registerSOPClass",
	      __LINE__, "Unable to initialize DUL Network");
      return -1;
    }
    ::DUL_DefaultServiceParameters(&mServiceParameters);
    (void) ::COND_PopCondition(TRUE);
  }

  char xfer1[65];
  xferSyntax1.safeExport(xfer1, sizeof xfer1);
  char xfer2[65];
  xferSyntax2.safeExport(xfer2, sizeof xfer2);
  char xfer3[65];
  xferSyntax3.safeExport(xfer3, sizeof xfer3);
  char* xferSyntaxes[] = {xfer1, xfer2, xfer3, 0};

  char classUID[65];
  sopClass.safeExport(classUID, sizeof classUID);

  cond = ::SRV_ProposeSOPClassWithXfer(classUID, role, xferSyntaxes, 3,
		1, // isStorageClass
		&mServiceParameters);
  if (cond != SRV_NORMAL) {
    MLogClient logClient;
    logClient.log(MLogClient::MLOG_ERROR, "<none>", "MDICOMAssociation::registerSOPClass",
	      __LINE__, "Unable to register SOP Class: ", sopClass);
    return 1;
  }

  return 0;
}

int
MDICOMAssociation::releaseAssociation()
{
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_CONVERSATION,
	mServiceParameters.calledAPTitle,
	"MDICOMAssociation::releaseAssociation", __LINE__,
	"client request to release association with: ",
	mServiceParameters.calledAPTitle);

  (void) ::DUL_ReleaseAssociation(&mAssociationKey);
  (void) ::COND_PopCondition(TRUE);
  return 0;
}

int
MDICOMAssociation::requestAssociation(const MString& callingAE,
				      const MString& calledAE,
				      const MString& node, int port)
{
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_CONVERSATION,
	mServiceParameters.calledAPTitle,
	"MDICOMAssociation::requestAssociation", __LINE__,
	"client request association with: ",
	calledAE);

  if (mNetworkKey == 0) {
    MLogClient logClient;
    logClient.log(MLogClient::MLOG_ERROR, "<none>",
	    "MDICOMAssociation::requestAssociation", __LINE__,
	    "Attempt to request association before any SOP classes were registered");
    return -1;
  }
  
  char txt[128];
  node.safeExport(txt, sizeof txt);
  ::sprintf(mServiceParameters.calledPresentationAddress, "%s:%d", txt, port);
  ::strcpy(mServiceParameters.callingPresentationAddress, "");
  callingAE.safeExport(mServiceParameters.callingAPTitle,
			sizeof mServiceParameters.callingAPTitle);
  calledAE.safeExport(mServiceParameters.calledAPTitle,
			sizeof mServiceParameters.calledAPTitle);

  CONDITION cond = ::DUL_RequestAssociation(&mNetworkKey,
					    &mServiceParameters,
					    &mAssociationKey);
  if (cond != DUL_NORMAL) {
    MLogClient logClient;
    if (cond == DUL_ASSOCIATIONREJECTED) {
      ::sprintf(txt, "(Remote: %s Result: %2x Source %2x Reason %2x)",
		mServiceParameters.calledPresentationAddress,
		mServiceParameters.result,
		mServiceParameters.resultSource,
		mServiceParameters.diagnostic);

      logClient.log(MLogClient::MLOG_WARN, calledAE,
		"MDICOMAssociation::requestAssociation", __LINE__,
		"Association request rejected (result, source diag) ",
		txt);
      return 1;
    }

    logClient.log(MLogClient::MLOG_ERROR, calledAE,
	    "MDICOMAssociation::requestAssociation", __LINE__,
	    "Error in attempting association with ",
	    mServiceParameters.calledPresentationAddress);

    logClient.logCTNErrorStack(MLogClient::MLOG_ERROR, calledAE);
    return -1;
  }

  return 0;
}

int
MDICOMAssociation::requestAssociation(CTN_SOCKET sock, const MString& callingAE,
				      const MString& calledAE)
{
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_CONVERSATION,
	mServiceParameters.calledAPTitle,
	"MDICOMAssociation::requestAssociation", __LINE__,
	"client request association with: ",
	calledAE);

  if (mNetworkKey == 0) {
    MLogClient logClient;
    logClient.log(MLogClient::MLOG_ERROR, "<none>",
	    "MDICOMAssociation::requestAssociation", __LINE__,
	    "Attempt to request association before any SOP classes were registered");
    return -1;
  }
  
  char txt[128];
  ::strcpy(mServiceParameters.calledPresentationAddress, "");
  ::strcpy(mServiceParameters.callingPresentationAddress, "");
  callingAE.safeExport(mServiceParameters.callingAPTitle,
			sizeof mServiceParameters.callingAPTitle);
  calledAE.safeExport(mServiceParameters.calledAPTitle,
			sizeof mServiceParameters.calledAPTitle);

  CONDITION cond = ::DUL_ReqAssocExternalSocket(&mNetworkKey,
					    &mServiceParameters,
					    &mAssociationKey,
					    sock);
  if (cond != DUL_NORMAL) {
    MLogClient logClient;
    if (cond == DUL_ASSOCIATIONREJECTED) {
      ::sprintf(txt, "(Remote: %s Result: %2x Source %2x Reason %2x)",
		mServiceParameters.calledPresentationAddress,
		mServiceParameters.result,
		mServiceParameters.resultSource,
		mServiceParameters.diagnostic);

      logClient.log(MLogClient::MLOG_WARN, calledAE,
		"MDICOMAssociation::requestAssociation", __LINE__,
		"Association request rejected (result, source diag) ",
		txt);
      return 1;
    }

    logClient.log(MLogClient::MLOG_ERROR, calledAE,
	    "MDICOMAssociation::requestAssociation", __LINE__,
	    "Error in attempting association with ",
	    mServiceParameters.calledPresentationAddress);

    logClient.logCTNErrorStack(MLogClient::MLOG_ERROR, calledAE);
    return -1;
  }

  return 0;
}

int
MDICOMAssociation::requestAssociation(MDICOMProxy& proxy, const MString& callingAE,
				      const MString& calledAE)
{
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_CONVERSATION,
	mServiceParameters.calledAPTitle,
	"MDICOMAssociation::requestAssociation", __LINE__,
	"client request association with: ",
	calledAE);

  if (mNetworkKey == 0) {
    MLogClient logClient;
    logClient.log(MLogClient::MLOG_ERROR, "<none>",
	    "MDICOMAssociation::requestAssociation", __LINE__,
	    "Attempt to request association before any SOP classes were registered");
    return -1;
  }

  char txt[128];
  ::strcpy(mServiceParameters.calledPresentationAddress, "");
  ::strcpy(mServiceParameters.callingPresentationAddress, "");
  callingAE.safeExport(mServiceParameters.callingAPTitle,
			sizeof mServiceParameters.callingAPTitle);
  calledAE.safeExport(mServiceParameters.calledAPTitle,
			sizeof mServiceParameters.calledAPTitle);

  DUL_PROXY p;
  ::memset(&p, 0, sizeof(p));
  proxy.configure(&p);

  CONDITION cond = ::DUL_RequestAssociationWithProxy(&mNetworkKey,
					    &mServiceParameters,
					    &p,
					    &mAssociationKey);
  if (cond != DUL_NORMAL) {
    MLogClient logClient;
    if (cond == DUL_ASSOCIATIONREJECTED) {
      ::sprintf(txt, "(Remote: %s Result: %2x Source %2x Reason %2x)",
		mServiceParameters.calledPresentationAddress,
		mServiceParameters.result,
		mServiceParameters.resultSource,
		mServiceParameters.diagnostic);

      logClient.log(MLogClient::MLOG_WARN, calledAE,
		"MDICOMAssociation::requestAssociation", __LINE__,
		"Association request rejected (result, source diag) ",
		txt);
      return 1;
    }

    logClient.log(MLogClient::MLOG_ERROR, calledAE,
	    "MDICOMAssociation::requestAssociation", __LINE__,
	    "Error in attempting association with ",
	    mServiceParameters.calledPresentationAddress);

    logClient.logCTNErrorStack(MLogClient::MLOG_ERROR, calledAE);
    return -1;
  }

  return 0;
}

DUL_ASSOCIATESERVICEPARAMETERS*
MDICOMAssociation::getParameters()
{
  return &mServiceParameters;
}

DUL_ASSOCIATIONKEY*
MDICOMAssociation::getAssociationKey()
{
  return mAssociationKey;
}

