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
#include "MLIAN.hpp"
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
MLIAN::MLIAN()
{
}
#endif

MLIAN::MLIAN(const MLIAN& cpy) :
  mOrderFiller(cpy.mOrderFiller),
  mStorageDir(cpy.mStorageDir)
{
}

MLIAN::~MLIAN()
{
}

void
MLIAN::printOn(ostream& s) const
{
  s << "MLIAN";
}

void
MLIAN::streamIn(istream& s)
{
  //s >> this->member;
}

// Non-boiler plate methods to follow

MLIAN::MLIAN(MDBOrderFillerBase& OrderFiller, const MString& storageDir) :
  mOrderFiller(OrderFiller),
  mStorageDir(storageDir + "/ian")
{
}

int
MLIAN::initialize()
{
  MFileOperations f;
  MLogClient logClient;
  if (f.createDirectory(mStorageDir) != 0) {
    logClient.log(MLogClient::MLOG_VERBOSE,
		"",
		"IAN::initialize",
		__LINE__,
		MString("Unable to create IAN directory: ") + mStorageDir);
    return -1;

  }

  logClient.log(MLogClient::MLOG_VERBOSE,
		"",
		"IAN::initialize",
		__LINE__,
		MString("IAN handler initialized; IAN messages stored in: ") + mStorageDir);

  return 0;
}

CONDITION
MLIAN::handleNCreateCommand(DUL_PRESENTATIONCONTEXT* ctx,
			       MSG_N_CREATE_REQ** message,
			       MSG_N_CREATE_RESP* response,
			       DUL_ASSOCIATESERVICEPARAMETERS* params,
			       MString& directoryName)
{
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_VERBOSE,
		params->callingAPTitle,
		"IAN::handleNCreateCommand",
		__LINE__,
		"IAN N-Create command received");

  directoryName = mStorageDir;
  //::MSG_DumpMessage(*message, stdout);

  return SRV_NORMAL;
}

CONDITION
MLIAN::handleNCreateDataSet(DUL_PRESENTATIONCONTEXT* ctx,
			       MSG_N_CREATE_REQ** message,
			       MSG_N_CREATE_RESP* response,
			       DUL_ASSOCIATESERVICEPARAMETERS* params,
			       MString& directoryName)
{
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_VERBOSE,
		params->callingAPTitle,
		"MLIAM::handleNCreateDataSetCommand",
		__LINE__,
		"IAN N-Create dataset received");

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
	      "MLIAN::handleNCreateDataSetCommand",
	      __LINE__,
	      "N-Create stored in " + s);

  delete [] s1;

  char ianPath[512];
  newDirectory.safeExport(ianPath, sizeof(ianPath));

  strcat(ianPath, "/ian.dcm");

  ::DCM_WriteFile(&(*message)->dataSet,
 		  DCM_ORDERLITTLEENDIAN,
 		  ianPath);

  logClient.log(MLogClient::MLOG_VERBOSE,
	       params->callingAPTitle,
	       "MLIAN::handleNCreateDataSetCommand",
	       __LINE__,
	       MString("IAN stored in ") + ianPath);

  response->dataSetType = DCM_CMDDATANULL;
  response->conditionalFields = 0;
  response->status = MSG_K_SUCCESS;
  return SRV_NORMAL;
}

/*CONDITION
MLIAN::handleNSetCommand(DUL_PRESENTATIONCONTEXT* ctx,
			  MSG_N_SET_REQ** message,
			  MSG_N_SET_RESP* response,
			  DUL_ASSOCIATESERVICEPARAMETERS* params,
			  MString& directoryName)
{
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_VERBOSE,
		params->callingAPTitle,
		"MLIAN::handleNSetCommand",
		__LINE__,
		"IAN N-Set command received");

  directoryName = mStorageDir;
  //::MSG_DumpMessage(*message, stdout);

  return SRV_NORMAL;
}

CONDITION
MLIAN::handleNSetDataSet(DUL_PRESENTATIONCONTEXT* ctx,
			  MSG_N_SET_REQ** message,
			  MSG_N_SET_RESP* response,
			  DUL_ASSOCIATESERVICEPARAMETERS* params,
			  MString& directoryName)
{
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_VERBOSE,
		params->callingAPTitle,
		"MLIAN::handleNSetDataSet",
		__LINE__,
		"IAN N-Set dataset received");

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
		"MLIAN::handleNSetDataSet",
		__LINE__,
		"IAN N-Set data set written to " + s);

  char ianPath[512];
  newDirectory.safeExport(ianPath, sizeof(ianPath));
  strcat (ianPath, "/ian.dcm"); 

  MPPSAssistant assistant;

  int rslt;

  rslt = assistant.validateNSetDataSet(ianPath, s1);
  rslt = assistant.mergeNSetDataSet(ianPath, s1);

  logClient.log(MLogClient::MLOG_VERBOSE,
		params->callingAPTitle,
		"MLIAN::handleNSetDataSet",
		__LINE__,
		MString("IAN status updated ") + ianPath);

  delete [] s1;

  response->dataSetType = DCM_CMDDATANULL;
  response->conditionalFields = 0;
  ::strcpy(response->classUID, (*message)->classUID);
  ::strcpy(response->instanceUID, (*message)->instanceUID);
  response->status = MSG_K_SUCCESS;
  return SRV_NORMAL;
}
*/
