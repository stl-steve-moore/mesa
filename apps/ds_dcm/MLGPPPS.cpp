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
#include "MDBImageManager.hpp"
#include "MDBImageManagerStudy.hpp"
#include "MDICOMWrapper.hpp"
#include "MDICOMDomainXlate.hpp"
#include "MPatient.hpp"
#include "MStudy.hpp"
#include "MSeries.hpp"
#include "MSOPInstance.hpp"
#include "MFileOperations.hpp"
#include "MPPSAssistant.hpp"
#include "MLogClient.hpp"

#if 0
MLGPPPS::MLGPPPS()
{
}
#endif

MLGPPPS::MLGPPPS(const MLGPPPS& cpy) :
  mImageManager(cpy.mImageManager),
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

MLGPPPS::MLGPPPS(MDBImageManager* manager, const MString& logDir,
	       const MString& storageDir) :
  mImageManager(manager),
  mLogDir(logDir),
  mStorageDir(storageDir)
{

}

int
MLGPPPS::initialize()
{
  MFileOperations f;
  f.createDirectory(mLogDir);
  f.createDirectory(mStorageDir);

  return 0;
}

CONDITION
MLGPPPS::handleNCreateCommand(DUL_PRESENTATIONCONTEXT* ctx,
			       MSG_N_CREATE_REQ** message,
			       MSG_N_CREATE_RESP* response,
			       DUL_ASSOCIATESERVICEPARAMETERS* params,
			       MString& directoryName)
{
  directoryName = mStorageDir;

  MLogClient logClient;
  logClient.log(MLogClient::MLOG_VERBOSE,
		params->callingAPTitle,
		"MLGPPPS::handleNCreateCommand",
		__LINE__,
		"GPPPS N-Create command received");

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
		"GPPPS N-Create dataset received");

  //::DCM_DumpElements(&(*message)->dataSet, 1);

  MFileOperations f;

  MString instanceUID((*message)->instanceUID);
  if (instanceUID == "") {
    logClient.log(MLogClient::MLOG_ERROR,
		params->callingAPTitle,
		"MLGPPPS::handleNCreateDataSetCommand",
		__LINE__,
		"Zero-length instance UID received with N-Create message");

  }

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

  char gpppsPath[512];
  newDirectory.safeExport(gpppsPath, sizeof(gpppsPath));

  strcat (gpppsPath, "/gppps.dcm"); 
   ::DCM_WriteFile(&(*message)->dataSet,
 		  DCM_ORDERLITTLEENDIAN,
 		  gpppsPath);

  logClient.log(MLogClient::MLOG_CONVERSATION,
		params->callingAPTitle,
		"MLGPPPS::handleNCreateDataSetCommand",
		__LINE__,
		MString("GPPPS status stored in ") + gpppsPath);

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
		"GPPPS N-Set command received");

  directoryName = mStorageDir;

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

  MFileOperations f;

  MString instanceUID((*message)->instanceUID);

  if (instanceUID == "") {
    logClient.log(MLogClient::MLOG_ERROR,
		params->callingAPTitle,
		"MLGPPPS::handleNSetDataSetCommand",
		__LINE__,
		"Zero-length instance UID received with N-Set message");

  }

  MString slash("/");
  MString callingAPTitle(params->callingAPTitle);

  MString newDirectory = mStorageDir + slash + params->callingAPTitle
    + slash + instanceUID;

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
		"GPPPS N-Set data set written to " + s);

  char gpppsPath[512];
  newDirectory.safeExport(gpppsPath, sizeof(gpppsPath));
  strcat (gpppsPath, "/gppps.dcm"); 

  MPPSAssistant assistant;

  int rslt;

  //rslt = assistant.validateNSetDataSet(gpppsPath, s1);
  rslt = assistant.mergeNSetDataSet(gpppsPath, s1);

  logClient.log(MLogClient::MLOG_CONVERSATION,
		params->callingAPTitle,
		"MLGPPPS::handleNSetDataSet",
		__LINE__,
		MString("GPPPS status updated ") + gpppsPath);

  delete [] s1;

  response->dataSetType = DCM_CMDDATANULL;
  response->conditionalFields = 0;
  ::strcpy(response->classUID, (*message)->classUID);
  ::strcpy(response->instanceUID, (*message)->instanceUID);
  response->status = MSG_K_SUCCESS;
  return SRV_NORMAL;
}
