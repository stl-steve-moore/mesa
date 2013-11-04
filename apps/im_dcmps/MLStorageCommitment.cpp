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
#include "MLStorageCommitment.hpp"
#include "MDBImageManager.hpp"
#include "MFileOperations.hpp"
#include "MLogClient.hpp"

#if 0
MLStorageCommitment::MLStorageCommitment()
{
}
#endif

MLStorageCommitment::MLStorageCommitment(const MLStorageCommitment& cpy) :
  mImageManager(cpy.mImageManager),
  mLogDir(cpy.mLogDir)
{
}

MLStorageCommitment::~MLStorageCommitment()
{
}

void
MLStorageCommitment::printOn(ostream& s) const
{
  s << "MLStorageCommitment";
}

void
MLStorageCommitment::streamIn(istream& s)
{
  //s >> this->member;
}

// Non-boiler plate methods to follow

MLStorageCommitment::MLStorageCommitment(MDBImageManager& manager,
					 const MString& logDir) :
  mImageManager(manager),
  mLogDir(logDir + "/st_comm")
{
}

int
MLStorageCommitment::initialize()
{
  MFileOperations f;
  f.createDirectory(mLogDir);
}

CONDITION
MLStorageCommitment::handleNActionCommand(DUL_PRESENTATIONCONTEXT* ctx,
					  MSG_N_ACTION_REQ** message,
					  MSG_N_ACTION_RESP* response,
					  DUL_ASSOCIATESERVICEPARAMETERS* params,
					  MString& directoryName)
{
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_VERBOSE,
		params->callingAPTitle,
		"MLStorageCommitment::handleNActionCommand",
		__LINE__,
		"Storage Commit N-Action command received");


  directoryName = ".";
}

CONDITION
MLStorageCommitment::handleNActionDataSet(DUL_PRESENTATIONCONTEXT* ctx,
					  MSG_N_ACTION_REQ** message,
					  MSG_N_ACTION_RESP* response,
					  DUL_ASSOCIATESERVICEPARAMETERS* params,
					  MString& directoryName)
{
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_VERBOSE,
		params->callingAPTitle,
		"MLStorageCommitment::handleNActionDataSet",
		__LINE__,
		"Storage Commit N-Action dataset received");

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
		"MLStorageCommitment::handleNActionDataSet",
		__LINE__,
		"Storage Commit N-Action dataset written to " + s);

  delete []s1;

  response->dataSetType = DCM_CMDDATANULL;
  response->conditionalFields = 0;
  response->status = MSG_K_SUCCESS;
  return SRV_NORMAL;
}
