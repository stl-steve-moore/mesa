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
#include "MLGPSPS.hpp"
#include "MFileOperations.hpp"
#include "MLogClient.hpp"
#include "MDBPostProcMgr.hpp"
#include "MDICOMWrapper.hpp"
#include "MDICOMDomainXlate.hpp"


#if 0
MLGPSPS::MLGPSPS()
{
}
#endif

MLGPSPS::MLGPSPS(const MLGPSPS& cpy) :
  mPostProcMgr(cpy.mPostProcMgr),
  mLogDir(cpy.mLogDir)
{
}

MLGPSPS::~MLGPSPS()
{
}

void
MLGPSPS::printOn(ostream& s) const
{
  s << "MLGPSPS";
}

void
MLGPSPS::streamIn(istream& s)
{
  //s >> this->member;
}

// Non-boiler plate methods to follow

MLGPSPS::MLGPSPS(MDBPostProcMgr& ppmgr, MString logDir) :
  mPostProcMgr(ppmgr),
  mLogDir(logDir)
{
}

int
MLGPSPS::initialize()
{
  MFileOperations f;
  f.createDirectory(mLogDir);

  return 0;
}

CONDITION
MLGPSPS::handleNActionCommand(DUL_PRESENTATIONCONTEXT* ctx,
				  MSG_N_ACTION_REQ** message,
				  MSG_N_ACTION_RESP* response,
				  DUL_ASSOCIATESERVICEPARAMETERS* params,
				  MString& directoryName)
{
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_VERBOSE,
		params->callingAPTitle,
		"MLGPSPS::handleNActionCommand",
		__LINE__,
		"GP_SPS N-Action command received");

  directoryName = ".";

  return SRV_NORMAL;
}

CONDITION
MLGPSPS::handleNActionDataSet(DUL_PRESENTATIONCONTEXT* ctx,
				  MSG_N_ACTION_REQ** message,
				  MSG_N_ACTION_RESP* response,
				  DUL_ASSOCIATESERVICEPARAMETERS* params,
				  MString& directoryName)
{
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_VERBOSE,
		params->callingAPTitle,
		"MLGPSPS::handleNActionDataSet",
		__LINE__,
		"GP_SPS N-Action dataset received");

//cout << "\nInside MLGPSPS::handleNActionDataSet()\n";
//cout << "instanceUID: " << (*message)->instanceUID << "\n";

  MDICOMWrapper w((*message)->actionInformation);
  MDICOMDomainXlate xlate;

  MGPWorkitem msg_wi;
  xlate.translateDICOM(w, msg_wi);

  //cout << msg_wi;

  response->dataSetType = DCM_CMDDATANULL;
  response->conditionalFields = 0;

  MGPWorkitem result_wi;
  if( mPostProcMgr.findWorkitem( (*message)->instanceUID, &result_wi) != 1) {
     response->status = MSG_K_NOSUCHOBJECTINSTANCE;
     return SRV_NORMAL;
  }
  
  //cout << result_wi;

  if( result_wi.status().compare("COMPLETED") == 0 || 
      result_wi.status().compare("DISCONTINUED") == 0) {
     // GP SPS object may no longer be updated.
     response->status = 0xa501;
     return SRV_NORMAL;
  }
  
  if( result_wi.status().compare("IN PROGRESS") == 0 ) {
     if( msg_wi.status().compare("IN PROGRESS") == 0 ) {
        // GP SPS object is already "In Progress".
        response->status = 0xa503;
        return SRV_NORMAL;
     }
     if( msg_wi.transactionUID().compare(result_wi.transactionUID()) == 0) {
        mPostProcMgr.updateStatus( result_wi, msg_wi);
        response->status = MSG_K_SUCCESS;
        return SRV_NORMAL;
     }
     else {
        // wrong transaction UID used.
        response->status = 0xa502;
        return SRV_NORMAL;
     }
  }

  if( result_wi.status().compare("SCHEDULED") == 0 ||
      result_wi.status().compare("SUSPENDED") == 0 ) {
     mPostProcMgr.updateStatus( result_wi, msg_wi);
     response->status = MSG_K_SUCCESS;
     return SRV_NORMAL;
  }


#if 0
  MFileOperations f;

  MString apTitle(params->callingAPTitle);
  MString fullPath = mLogDir + "/" + apTitle;

  f.createDirectory(fullPath);

  MString s = f.uniqueFile(fullPath, "opn");
  char* s1 = s.strData();

  ::DCM_WriteFile(&(*message)->actionInformation,
		  DCM_ORDERLITTLEENDIAN,
		  s1);

  logClient.log(MLogClient::MLOG_VERBOSE,
		params->callingAPTitle,
		"MLGPSPS::handleNActionDataSet",
		__LINE__,
		"GP_SPS N-Action dataset written to " + s);

  delete []s1;

  response->dataSetType = DCM_CMDDATANULL;
  response->conditionalFields = 0;
  response->status = MSG_K_SUCCESS;
#endif

  return SRV_NORMAL;
}
