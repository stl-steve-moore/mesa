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
#include "MDICOMWrapper.hpp"
#include "MDICOMDomainXlate.hpp"
#include "MPatient.hpp"
#include "MStudy.hpp"
#include "MSeries.hpp"
#include "MSOPInstance.hpp"
#include "MPatientStudy.hpp"
#include "MStorageAgent.hpp"
#include "MDICOMApp.hpp"

#if 0
MLMove::MLMove()
{
}
#endif

MLMove::MLMove(const MLMove& cpy) :
  mImageManager(cpy.mImageManager)
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

MLMove::MLMove(MDBImageManager& manager) :
  mImageManager(manager)
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
  MQRObjectsVector::iterator pStart = mObjectsVector.begin();
  MQRObjectsVector::iterator pEnd = mObjectsVector.end();
  mObjectsVector.erase(pStart, pEnd);

  MDICOMWrapper w((*message)->identifier);

  if (strcmp((*message)->classUID, DICOM_SOPSTUDYQUERY_MOVE) == 0) {
    MPatientStudy patientStudy;
    xlate.translateDICOM(w, patientStudy);

    MSeries series;
    xlate.translateDICOM(w, series);

    MSOPInstance sopInstance;
    xlate.translateDICOM(w, sopInstance);

    mImageManager.queryDICOMStudyRoot(patientStudy, series, sopInstance,
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

    mImageManager.queryDICOMPatientRoot(patient, study, series, sopInstance,
					"PATIENT", "IMAGE", *this);
  }

#if 0
  MQRObjectsVector::iterator objIt = mObjectsVector.begin();
  for (; objIt != mObjectsVector.end(); objIt++) {
    MPatient x1 = (*objIt).patient();
    MStudy x2 = (*objIt).study();
    MSeries x3 = (*objIt).series();
    MSOPInstance x4 = (*objIt).sopInstance();

    MDICOMApp app;
    mImageManager.selectDICOMApp((*message).moveDestination, app);
    int port = app.port().intData();
    MStorageAgent storageAgent;

    U16 result;
    MString resultMessage;
    int status = storageAgent.storeInstance(params->calledAPTitle,
					    app.aeTitle(),
					    app.host(),
					    port,
					    result,
					    resultMessage);

    xlate.translateDICOM(x1, (*message)->identifier, response->identifier);
  }
#endif
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
  if (index > mObjectsVector.size()) {
    response->status = MSG_K_SUCCESS;
    response->dataSetType = DCM_CMDDATANULL;
  } else {
    MString path;
    if (strcmp((*message)->classUID, DICOM_SOPSTUDYQUERY_MOVE) == 0) {
      MPatientStudy x0 = mObjectsVector[index-1].patientStudy();
      MSeries x1 = mObjectsVector[index-1].series();
      MSOPInstance x2 = mObjectsVector[index-1].sopInstance();

      path = x2.fileName();

      cout << x0 << endl;
      cout << x1 << endl;
      cout << x2 << endl;
    } else {
    }

    MDICOMApp app;
    mImageManager.selectDICOMApp((*message)->moveDestination, app);
    int port = app.port().intData();
    MStorageAgent storageAgent;

    U16 result;
    MString resultMessage;
    int status = storageAgent.storeInstance(params->calledAPTitle,
					    app.aeTitle(),
					    app.host(),
					    port,
					    path,
					    result,
					    resultMessage);

    response->status = MSG_K_C_MOVE_SUBOPERATIONSCONTINUING;
    response->dataSetType = DCM_CMDDATANULL;
  }

  return SRV_NORMAL;
}

int
MLMove::selectCallback(const MPatient& patient, const MStudy& study,
			const MSeries& series, const MSOPInstance& sop)
{
  MQRObjects obj(patient, study, series, sop);
  mObjectsVector.push_back(obj);
}

int
MLMove::selectCallback(const MPatientStudy& patientStudy,
			const MSeries& series, const MSOPInstance& sop)
{
  MQRObjects obj(patientStudy, series, sop);
  mObjectsVector.push_back(obj);
}
