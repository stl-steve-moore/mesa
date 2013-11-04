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
#include "MLMove.hpp"
#include "MDBImageManager.hpp"
#include "MDBImageManagerStudy.hpp"
#include "MDICOMWrapper.hpp"
#include "MDICOMDomainXlate.hpp"
#include "MPatient.hpp"
#include "MStudy.hpp"
#include "MSeries.hpp"
#include "MSOPInstance.hpp"
#include "MPatientStudy.hpp"
#include "MStorageAgent.hpp"
#include "MDICOMApp.hpp"
#include "MLogClient.hpp"
#include "MFileOperations.hpp"

#if 0
MLMove::MLMove()
{
}
#endif

MLMove::MLMove(const MLMove& cpy) :
  mImageManager(cpy.mImageManager),
  mCompletedSubOperations(cpy.mCompletedSubOperations),
  mFailedSubOperations(cpy.mFailedSubOperations),
  mWarningSubOperations(cpy.mWarningSubOperations),
  mStoreCMoveQueries(cpy.mStoreCMoveQueries),
  mStorageDirectory(cpy.mStorageDirectory)
{
}

MLMove::~MLMove()
{
}

void
MLMove::printOn(ostream& s) const
{
  s << "MLMove";
}

void
MLMove::streamIn(istream& s)
{
  //s >> this->member;
}

// Non-boiler plate methods to follow

MLMove::MLMove(MDBImageManager* manager,
		int storeCMoveQueries,
		MString& storageDirectory) :
  mImageManager(manager),
  mCompletedSubOperations(0),
  mFailedSubOperations(0),
  mWarningSubOperations(0),
  mStoreCMoveQueries(storeCMoveQueries),
  mStorageDirectory(storageDirectory)
{
}

CONDITION
MLMove::handleCMoveCommand(DUL_PRESENTATIONCONTEXT* ctx,
			   MSG_C_MOVE_REQ** message,
			   MSG_C_MOVE_RESP* response,
			   DUL_ASSOCIATESERVICEPARAMETERS* params,
			   const MString& queryLevel)
{
  MDICOMDomainXlate xlate;

  MDICOMWrapper w((*message)->identifier);
  MQRObjectsVector::iterator pStart = mObjectsVector.begin();
  MQRObjectsVector::iterator pEnd = mObjectsVector.end();
  mObjectsVector.erase(pStart, pEnd);
  mCompletedSubOperations = 0;
  mFailedSubOperations = 0;
  mWarningSubOperations = 0;

  MString callingAPTitle = "";
  char tmp[1024] = "";

  if (!params) {
    // We have been called as a standalone app)
    callingAPTitle = "STANDALONE";
  } else {
    callingAPTitle = params->callingAPTitle;
  }

  MLogClient logClient;
  logClient.log(MLogClient::MLOG_VERBOSE,
                callingAPTitle,
                "MLMove::handleCMoveCommand",
                __LINE__,
                "C-Move command received");

  if (mStoreCMoveQueries) {
    MFileOperations f;
    MString s = f.uniqueFile(mStorageDirectory, "mov");
    char* s1 = s.strData();
    ::DCM_WriteFile(&(*message)->identifier,
		    DCM_ORDERLITTLEENDIAN,
		    s1);

    logClient.log(MLogClient::MLOG_VERBOSE,
		  callingAPTitle,
		  "MLMove::handleCMoveCommand",
		  __LINE__,
		  MString("C-Move dataset stored in ") + s);
    delete[] s1;
  }

  if (strcmp((*message)->classUID, DICOM_SOPSTUDYQUERY_MOVE) == 0) {
    MPatientStudy patientStudy;
    xlate.translateDICOM(w, patientStudy);

    MSeries series;
    xlate.translateDICOM(w, series);

    MSOPInstance sopInstance;
    xlate.translateDICOM(w, sopInstance);

    strstream x(tmp, sizeof(tmp)-1);
    x << "MLMove::handleCMoveCommand STUDY level move"
	<< " Study UID " << patientStudy.studyInstanceUID()
	<< " Series UID " << series.seriesInstanceUID() << '\0';
    logClient.logTimeStamp(MLogClient::MLOG_VERBOSE, tmp);

    mImageManager->queryDICOMStudyRoot(patientStudy, series, sopInstance,
				      "STUDY", "IMAGE", *this);
  } else {
    MPatient patient;
    xlate.translateDICOM(w, patient);

    MStudy study;
    xlate.translateDICOM(w, study);

    MSeries series;
    xlate.translateDICOM(w, series);

    MSOPInstance sopInstance;
    xlate.translateDICOM(w, sopInstance);

    strstream x(tmp, sizeof(tmp)-1);
    x << "MLMove::handleCMoveCommand PATIENT level move"
	<< " Patient ID " << patient.patientID()
	<< " Study UID " << study.studyInstanceUID()
	<< " Series UID " << series.seriesInstanceUID() << '\0';
    logClient.logTimeStamp(MLogClient::MLOG_VERBOSE, tmp);

    mImageManager->queryDICOMPatientRoot(patient, study, series, sopInstance,
					"PATIENT", "IMAGE", *this);
  }

  return 0;
}

//  virtual
CONDITION
MLMove::returnCMoveStatus(DUL_PRESENTATIONCONTEXT* ctx,
			  MSG_C_MOVE_REQ** message,
			  MSG_C_MOVE_RESP* response,
			  DUL_ASSOCIATESERVICEPARAMETERS* params,
			  const MString& queryLevel,
			  int index)
{
  MLogClient logClient;
  char tmp[1024] = "";
  logClient.logTimeStamp(MLogClient::MLOG_VERBOSE,
	"MLMove::returnCMoveStatus enter method");

  if (index == 0) {
    strstream x(tmp, sizeof(tmp)-1);
    x << "MLMove::returnCMoveStatus, index = 0, number of responses = "
	<< mObjectsVector.size() << '\0';
    logClient.logTimeStamp(MLogClient::MLOG_VERBOSE, tmp);
  }

  if (index > mObjectsVector.size()) {
    logClient.logTimeStamp(MLogClient::MLOG_VERBOSE,
	"MLMove::returnCMoveStatus about to send final status");
    response->status = MSG_K_SUCCESS;
    response->dataSetType = DCM_CMDDATANULL;
    response->completedSubOperations = mCompletedSubOperations;
    response->failedSubOperations = mFailedSubOperations;
    response->warningSubOperations = mWarningSubOperations;
    response->conditionalFields = MSG_K_C_MOVE_COMPLETED;
    if (mFailedSubOperations > 0) {
      response->conditionalFields |= MSG_K_C_MOVE_FAILED;
    }
    if (mWarningSubOperations > 0) {
      response->conditionalFields |= MSG_K_C_MOVE_WARNING;
    }
//    response->conditionalFields |= ( MSG_K_C_MOVE_COMPLETED |
//					MSG_K_C_MOVE_FAILED  |
//					MSG_K_C_MOVE_WARNING );
  } else {
    MString path;
    if (strcmp((*message)->classUID, DICOM_SOPSTUDYQUERY_MOVE) == 0) {
      MPatientStudy x0 = mObjectsVector[index-1].patientStudy();
      MSeries x1 = mObjectsVector[index-1].series();
      MSOPInstance x2 = mObjectsVector[index-1].sopInstance();

      path = x2.fileName();

      //cout << x0 << endl;
      //cout << x1 << endl;
      //cout << x2 << endl;
      //cout << x1.seriesInstanceUID() << endl;
      //cout << path << endl;
    } else if (strcmp((*message)->classUID, DICOM_SOPPATIENTQUERY_MOVE) == 0) {
      MSeries x1 = mObjectsVector[index-1].series();
      MSOPInstance x2 = mObjectsVector[index-1].sopInstance();

      path = x2.fileName();

      //cout << x0 << endl;
      //cout << x1 << endl;
      //cout << x2 << endl;
      //cout << x1.seriesInstanceUID() << endl;
      //cout << path << endl;
    } else {
    }

    MDICOMApp app;
    mImageManager->selectDICOMApp((*message)->moveDestination, app);
    int port = app.port().intData();
    MStorageAgent storageAgent;

    U16 result;
    MString resultMessage;
    MString aeTitle = app.aeTitle();
    MString host = app.host();
//    cout << aeTitle << ":"
//	 << host << ":"
//	 << port << endl;
    if (index == 0 || index == mObjectsVector.size()-1) {
      strstream x(tmp, sizeof(tmp)-1);
      x << "About to C-MOVE first or last object "
        << "index = " << index
	<< "total count = " << mObjectsVector.size()
	<< "path = " << path
	<< "destination = " << app.aeTitle() << ":"
	<< app.host() << ":"
	<< port << '\0';
      logClient.logTimeStamp(MLogClient::MLOG_VERBOSE, tmp);
    }
    int status = storageAgent.storeInstance(params->calledAPTitle,
					    app.aeTitle(),
					    app.host(),
					    port,
					    path,
					    result,
					    resultMessage);

    if (status == 0) {
      mCompletedSubOperations++;
    } else {
      strstream x(tmp, sizeof(tmp)-1);
      x << "Failed to store object to destination"
        << " index = " << index
	<< " total count = " << mObjectsVector.size()
	<< " path = " << path
	<< " destination = " << app.aeTitle() << ":"
	<< app.host() << ":"
	<< port << '\0';
      logClient.logTimeStamp(MLogClient::MLOG_ERROR, tmp);
      mFailedSubOperations++;
    }

    response->status = MSG_K_C_MOVE_SUBOPERATIONSCONTINUING;
    response->dataSetType = DCM_CMDDATANULL;
    response->conditionalFields = 0;
  }

  logClient.logTimeStamp(MLogClient::MLOG_VERBOSE,
	"MLMove::returnCMoveStatus exit method");
  return SRV_NORMAL;
}

int
MLMove::selectCallback(const MPatient& patient, const MStudy& study,
			const MSeries& series, const MSOPInstance& sop)
{
  MQRObjects obj(patient, study, series, sop);
  mObjectsVector.push_back(obj);

  return 0;
}

int
MLMove::selectCallback(const MPatientStudy& patientStudy,
			const MSeries& series, const MSOPInstance& sop)
{
  MQRObjects obj(patientStudy, series, sop);
  mObjectsVector.push_back(obj);

  return 0;
}
