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
#include "MLMPPS.hpp"
#include "MDBOrderFillerBase.hpp"
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
MLMPPS::MLMPPS()
{
}
#endif

MLMPPS::MLMPPS(const MLMPPS& cpy) :
  mOrderFiller(cpy.mOrderFiller),
  mStorageDir(cpy.mStorageDir)
{
}

MLMPPS::~MLMPPS()
{
}

void
MLMPPS::printOn(ostream& s) const
{
  s << "MLMPPS";
}

void
MLMPPS::streamIn(istream& s)
{
  //s >> this->member;
}

// Non-boiler plate methods to follow

MLMPPS::MLMPPS(MDBOrderFillerBase& OrderFiller, const MString& storageDir) :
  mOrderFiller(OrderFiller),
  mStorageDir(storageDir + "/mpps")
{
}

int
MLMPPS::initialize()
{
  MFileOperations f;
  MLogClient logClient;
  if (f.createDirectory(mStorageDir) != 0) {
    logClient.log(MLogClient::MLOG_VERBOSE,
		"",
		"MPPS::initialize",
		__LINE__,
		MString("Unable to create MPPS directory: ") + mStorageDir);
    return -1;

  }

  logClient.log(MLogClient::MLOG_VERBOSE,
		"",
		"MPPS::initialize",
		__LINE__,
		MString("MPPS handler initialized; MPPS messages stored in: ") + mStorageDir);

  return 0;
}

CONDITION
MLMPPS::handleNCreateCommand(DUL_PRESENTATIONCONTEXT* ctx,
			       MSG_N_CREATE_REQ** message,
			       MSG_N_CREATE_RESP* response,
			       DUL_ASSOCIATESERVICEPARAMETERS* params,
			       MString& directoryName)
{
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_VERBOSE,
		params->callingAPTitle,
		"MPPS::handleNCreateCommand",
		__LINE__,
		"MPPS N-Create command received");

  directoryName = mStorageDir;
  //::MSG_DumpMessage(*message, stdout);

  return SRV_NORMAL;
}

CONDITION
MLMPPS::handleNCreateDataSet(DUL_PRESENTATIONCONTEXT* ctx,
			       MSG_N_CREATE_REQ** message,
			       MSG_N_CREATE_RESP* response,
			       DUL_ASSOCIATESERVICEPARAMETERS* params,
			       MString& directoryName)
{
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_VERBOSE,
		params->callingAPTitle,
		"MLMPPS::handleNCreateDataSetCommand",
		__LINE__,
		"MPPS N-Create dataset received");

  //::DCM_DumpElements(&(*message)->dataSet, 1);

  MFileOperations f;

  MString instanceUID((*message)->instanceUID);

  MString slash("/");

  MString newDirectory = mStorageDir
    + slash + params->callingAPTitle
    + slash + instanceUID;

  f.createDirectory(newDirectory);
  MString s = f.uniqueFile(newDirectory, "crt");

  char* s1 = s.strData();

  ::DCM_WriteFile(&(*message)->dataSet,
		  DCM_ORDERLITTLEENDIAN,
		  s1);

  logClient.log(MLogClient::MLOG_VERBOSE,
	      params->callingAPTitle,
	      "MLMPPS::handleNCreateDataSetCommand",
	      __LINE__,
	      "N-Create stored in " + s);

  delete [] s1;

  char mppsPath[512];
  newDirectory.safeExport(mppsPath, sizeof(mppsPath));

  strcat(mppsPath, "/mpps.dcm");

  ::DCM_WriteFile(&(*message)->dataSet,
 		  DCM_ORDERLITTLEENDIAN,
 		  mppsPath);

  logClient.log(MLogClient::MLOG_VERBOSE,
	       params->callingAPTitle,
	       "MLMPPS::handleNCreateDataSetCommand",
	       __LINE__,
	       MString("MPPS status stored in ") + mppsPath);

  response->dataSetType = DCM_CMDDATANULL;
  response->conditionalFields = 0;
  response->status = MSG_K_SUCCESS;
  return SRV_NORMAL;
}

CONDITION
MLMPPS::handleNSetCommand(DUL_PRESENTATIONCONTEXT* ctx,
			  MSG_N_SET_REQ** message,
			  MSG_N_SET_RESP* response,
			  DUL_ASSOCIATESERVICEPARAMETERS* params,
			  MString& directoryName)
{
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_VERBOSE,
		params->callingAPTitle,
		"MLMPPS::handleNSetCommand",
		__LINE__,
		"MPPS N-Set command received");

  directoryName = mStorageDir;
  //::MSG_DumpMessage(*message, stdout);

  return SRV_NORMAL;
}

CONDITION
MLMPPS::handleNSetDataSet(DUL_PRESENTATIONCONTEXT* ctx,
			  MSG_N_SET_REQ** message,
			  MSG_N_SET_RESP* response,
			  DUL_ASSOCIATESERVICEPARAMETERS* params,
			  MString& directoryName)
{
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_VERBOSE,
		params->callingAPTitle,
		"MLMPPS::handleNSetDataSet",
		__LINE__,
		"MPPS N-Set dataset received");

  MFileOperations f;

  MString instanceUID((*message)->instanceUID);

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

  logClient.log(MLogClient::MLOG_VERBOSE,
		params->callingAPTitle,
		"MLMPPS::handleNSetDataSet",
		__LINE__,
		"MPPS N-Set data set written to " + s);

  char mppsPath[512];
  newDirectory.safeExport(mppsPath, sizeof(mppsPath));
  strcat (mppsPath, "/mpps.dcm"); 

  MPPSAssistant assistant;

  int rslt;

  rslt = assistant.validateNSetDataSet(mppsPath, s1);
  rslt = assistant.mergeNSetDataSet(mppsPath, s1);

  logClient.log(MLogClient::MLOG_VERBOSE,
		params->callingAPTitle,
		"MLMPPS::handleNSetDataSet",
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
