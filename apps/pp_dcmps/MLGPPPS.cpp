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
#include "MLGPPPS.hpp"
#include "MDICOMWrapper.hpp"
#include "MDICOMDomainXlate.hpp"
#include "MFileOperations.hpp"
#include "MLogClient.hpp"
#include "MDBPostProcMgr.hpp"
#include "MGPPPSWorkitem.hpp"
#include "MGPPPSObject.hpp"
#include "MPPSAssistant.hpp"

//#include "MDBImageManagerStudy.hpp"
//#include "MPatient.hpp"
//#include "MStudy.hpp"
//#include "MSeries.hpp"
//#include "MSOPInstance.hpp"
//#include "MPPSAssistant.hpp"

#if 0
MLGPPPS::MLGPPPS()
{
}
#endif

MLGPPPS::MLGPPPS(const MLGPPPS& cpy) :
  mPostProcMgr(cpy.mPostProcMgr),
  mLogDir(cpy.mLogDir),
  mStorageDir(cpy.mStorageDir)
{
}

MLGPPPS::~MLGPPPS()
{
}

void
MLGPPPS::printOn(ostream& s) const
{
  s << "MLGPPPS";
}

void
MLGPPPS::streamIn(istream& s)
{
  //s >> this->member;
}

// Non-boiler plate methods to follow

MLGPPPS::MLGPPPS(MDBPostProcMgr& manager,
		const MString& logDir,
		const MString& storageDir) :
  mPostProcMgr(manager),
  mLogDir(logDir),
  mStorageDir(storageDir)
{

}

int
MLGPPPS::initialize()
{
  MFileOperations f;
  f.createDirectory(mLogDir);

  return 0;
}

CONDITION
MLGPPPS::handleNCreateCommand(DUL_PRESENTATIONCONTEXT* ctx,
			       MSG_N_CREATE_REQ** message,
			       MSG_N_CREATE_RESP* response,
			       DUL_ASSOCIATESERVICEPARAMETERS* params,
			       MString& directoryName)
{
  directoryName = ".";

  MLogClient logClient;
  logClient.log(MLogClient::MLOG_VERBOSE,
		params->callingAPTitle,
		"MLGPPPS::handleNCreateCommand",
		__LINE__,
		"GP-PPS N-Create command received");

  return 0;
}

CONDITION
MLGPPPS::handleNCreateDataSet(DUL_PRESENTATIONCONTEXT* ctx,
			       MSG_N_CREATE_REQ** message,
			       MSG_N_CREATE_RESP* response,
			       DUL_ASSOCIATESERVICEPARAMETERS* params,
			       MString& directoryName)
{
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_VERBOSE,
		params->callingAPTitle,
		"MLGPPPS::handleNCreateDataSetCommand",
		__LINE__,
		"GP-PPS N-Create dataset received");

  //::DCM_DumpElements(&(*message)->dataSet, 1);

  MString instanceUID((*message)->instanceUID);
  if (instanceUID == "") {
    logClient.log(MLogClient::MLOG_ERROR,
		params->callingAPTitle,
		"MLGPPPS::handleNCreateDataSetCommand",
		__LINE__,
		"Zero-length instance UID received with N-Create message");
  }

//cout << "\nInside MLGPPPS::handleNCreateDataSet()\n";
//cout << "instanceUID: " << (*message)->instanceUID << "\n";

  MDICOMWrapper w((*message)->dataSet);
  MDICOMDomainXlate xlate;

  MGPPPSObject msg_pps;
  xlate.translateDICOM(w, msg_pps);

  msg_pps.SOPInstanceUID( (*message)->instanceUID);

//cout << msg_pps;

  if( msg_pps.status().compare("IN PROGRESS") != 0) {
// need to return attribute list with invalid attribute (GPPPS status)
    response->dataSetType = DCM_CMDDATANULL;
    response->conditionalFields = 0;
    response->status = 0x0106;
    return SRV_NORMAL;
  }

  mPostProcMgr.createPPS(msg_pps);

  MFileOperations f;

  MString slash("/");
  MString callingAPTitle(params->callingAPTitle);

  MString newDirectory = mStorageDir + slash + params->callingAPTitle
    + slash + instanceUID;

  f.createDirectory(newDirectory);
  MString s = f.uniqueFile(newDirectory, "crt");

  char* s1 = s.strData();

  ::DCM_WriteFile(&(*message)->dataSet,
		  DCM_ORDERLITTLEENDIAN,
		  s1 );

  logClient.log(MLogClient::MLOG_CONVERSATION,
		params->callingAPTitle,
		"MLGPPPS::handleNCreateDataSetCommand",
		__LINE__,
		"N-Create stored in " + s);

  delete [] s1;

  char mppsPath[512];
  newDirectory.safeExport(mppsPath, sizeof(mppsPath));

  strcat (mppsPath, "/gppps.dcm"); 
   ::DCM_WriteFile(&(*message)->dataSet,
 		  DCM_ORDERLITTLEENDIAN,
 		  mppsPath);

  logClient.log(MLogClient::MLOG_CONVERSATION,
		params->callingAPTitle,
		"MLGPPPS::handleNCreateDataSetCommand",
		__LINE__,
		MString("MPPS status stored in ") + mppsPath);

  response->dataSetType = DCM_CMDDATANULL;
  response->conditionalFields = 0;
  response->status = MSG_K_SUCCESS;
  return SRV_NORMAL;
}

CONDITION
MLGPPPS::handleNSetCommand(DUL_PRESENTATIONCONTEXT* ctx,
			  MSG_N_SET_REQ** message,
			  MSG_N_SET_RESP* response,
			  DUL_ASSOCIATESERVICEPARAMETERS* params,
			  MString& directoryName)
{
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_VERBOSE,
		params->callingAPTitle,
		"MLGPPPS::handleNSetCommand",
		__LINE__,
		"MPPS N-Set command received");

#if 0
  directoryName = mStorageDir;

#endif
  return 0;
}

CONDITION
MLGPPPS::handleNSetDataSet(DUL_PRESENTATIONCONTEXT* ctx,
			  MSG_N_SET_REQ** message,
			  MSG_N_SET_RESP* response,
			  DUL_ASSOCIATESERVICEPARAMETERS* params,
			  MString& directoryName)
{
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_VERBOSE,
		params->callingAPTitle,
		"MLGPPPS::handleNSetDataSet",
		__LINE__,
		"GPPPS N-Set dataset received");

  //::DCM_DumpElements(&(*message)->dataSet, 1);

  MString instanceUID((*message)->instanceUID);
  if (instanceUID == "") {
    logClient.log(MLogClient::MLOG_ERROR,
		params->callingAPTitle,
		"MLGPPPS::handleNSetDataSetCommand",
		__LINE__,
		"Zero-length instance UID received with N-Set message");
  }

//cout << "\nInside MLGPPPS::handleNSetDataSet()\n";
//cout << "instanceUID: " << (*message)->instanceUID << "\n";

  MString status = mPostProcMgr.PPSstatus(instanceUID);
  if( status == "") {
     // no such PPS instance.
     response->dataSetType = DCM_CMDDATANULL;
     response->conditionalFields = 0;
     ::strcpy(response->classUID, (*message)->classUID);
     ::strcpy(response->instanceUID, (*message)->instanceUID);
     response->status = MSG_K_NOSUCHOBJECTINSTANCE;
     return SRV_NORMAL;
  }
//cout << "current status: " << status << "\n";

  if( status != "IN PROGRESS") {
     response->dataSetType = DCM_CMDDATANULL;
     response->conditionalFields = 0;
     ::strcpy(response->classUID, (*message)->classUID);
     ::strcpy(response->instanceUID, (*message)->instanceUID);
     response->status = 0xa506;
     return SRV_NORMAL;
  }

  MDICOMWrapper w((*message)->dataSet);
  MDICOMDomainXlate xlate;

  MGPPPSObject msg_pps;
  xlate.translateDICOM(w, msg_pps);

  msg_pps.SOPInstanceUID( (*message)->instanceUID);

//cout << msg_pps;

  //mPostProcMgr.updatePPS(msg_pps);
  mPostProcMgr.setPPS(msg_pps);

#if 0
  mPostProcMgr.PPSstatus(instanceUID, MString("new status"));

  status = mPostProcMgr.PPSstatus(instanceUID);
//cout << "new status: " << status << "\n";
#endif

#if 0
  MGPPPSObject pps;
  if( mPostProcMgr.findPPS( instanceUID, &pps) != 1) {
     // error, no such pps instance.
cout << "didn't find pps with sopinsuid " << instanceUID << "\n";
  }
  else {
cout << pps;
  }
#endif

#if 0

  MString instanceUID((*message)->instanceUID);

  if (instanceUID == "") {
    logClient.log(MLogClient::MLOG_ERROR,
		params->callingAPTitle,
		"MLGPPPS::handleNSetDataSetCommand",
		__LINE__,
		"Zero-length instance UID received with N-Set message");

  }
#endif

  MString slash("/");
  MString callingAPTitle(params->callingAPTitle);

  MString newDirectory = mStorageDir + slash + params->callingAPTitle
    + slash + instanceUID;

  MFileOperations f;
  f.createDirectory(newDirectory);

  f.createDirectory(newDirectory);
  MString s = f.uniqueFile(newDirectory, "set");
  char* s1 = s.strData();

  ::DCM_WriteFile(&(*message)->dataSet,
		  DCM_ORDERLITTLEENDIAN,
		  s1 );

  logClient.log(MLogClient::MLOG_CONVERSATION,
		params->callingAPTitle,
		"MLGPPPS::handleNSetDataSet",
		__LINE__,
		"MPPS N-Set data set written to " + s);

  char mppsPath[512];
  newDirectory.safeExport(mppsPath, sizeof(mppsPath));
  strcat (mppsPath, "/gppps.dcm"); 

  MPPSAssistant assistant;

  int rslt;

  rslt = assistant.validateNSetDataSet(mppsPath, s1);
  rslt = assistant.mergeNSetDataSet(mppsPath, s1);

  logClient.log(MLogClient::MLOG_CONVERSATION,
		params->callingAPTitle,
		"MLGPPPS::handleNSetDataSet",
		__LINE__,
		MString("MPPS status updated ") + mppsPath);

  delete [] s1;

  response->dataSetType = DCM_CMDDATANULL;
  response->conditionalFields = 0;
  ::strcpy(response->classUID, (*message)->classUID);
  ::strcpy(response->instanceUID, (*message)->instanceUID);
  response->status = MSG_K_SUCCESS;

  return SRV_NORMAL;
}
