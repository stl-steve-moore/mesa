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
#include "MLQuery.hpp"
#include "MDBImageManager.hpp"
#include "MDBImageManagerStudy.hpp"
#include "MDICOMWrapper.hpp"
#include "MDICOMDomainXlate.hpp"
#include "MPatient.hpp"
#include "MStudy.hpp"
#include "MSeries.hpp"
#include "MSOPInstance.hpp"
#include "MPatientStudy.hpp"
#include "MLogClient.hpp"
#include "MFileOperations.hpp"

#if 0
MLQuery::MLQuery()
{
}
#endif

MLQuery::MLQuery(const MLQuery& cpy) :
  mImageManager(cpy.mImageManager),
  mStoreCFindQueries(cpy.mStoreCFindQueries),
  mStorageDirectory(cpy.mStorageDirectory),
  mAETitle(cpy.mAETitle)
{
}

MLQuery::~MLQuery()
{
}

void
MLQuery::printOn(ostream& s) const
{
  s << "MLQuery";
}

void
MLQuery::streamIn(istream& s)
{
  //s >> this->member;
}

// Non-boiler plate methods to follow

MLQuery::MLQuery(MDBImageManager* manager, int storeCFindQueries,
		 MString& storageDirectory, MString& aeTitle) :
  mImageManager(manager),
  mStoreCFindQueries(storeCFindQueries),
  mStorageDirectory(storageDirectory),
  mAETitle(aeTitle)
{
}

CONDITION
MLQuery::handleCFindCommand(DUL_PRESENTATIONCONTEXT* ctx,
			       MSG_C_FIND_REQ** message,
			       MSG_C_FIND_RESP* response,
			       DUL_ASSOCIATESERVICEPARAMETERS* params,
			       const MString& queryLevel)
{
  MLogClient logClient;
  MString callingAPTitle;

  if (!params) {
    // We have been called as a standalone app
    callingAPTitle = "STANDALONE";
  } else {
    callingAPTitle = params->callingAPTitle;
  }

  logClient.log(MLogClient::MLOG_VERBOSE,
                callingAPTitle,
                "MLQuery::handleCFindCommand",
                __LINE__,
                "C-Find command received");

  // Section in braces stores the query in a file in the
  // event we want to examine it later for debugging.
  if (mStoreCFindQueries) {
    MFileOperations f;
    MString s = f.uniqueFile(mStorageDirectory, "qry");
    char* s1 = s.strData();
    ::DCM_WriteFile(&(*message)->identifier,
		    DCM_ORDERLITTLEENDIAN,
		    s1);

    logClient.log(MLogClient::MLOG_VERBOSE,
		  callingAPTitle,
		  "MLQuery::handleCFindCommand",
		  __LINE__,
		  MString("C-Find query stored in ") + s);
    delete[] s1;
  }

  MDICOMDomainXlate xlate;
  MQRObjectsVector::iterator oStart = mObjectsVector.begin();
  MQRObjectsVector::iterator oEnd = mObjectsVector.end();
  mObjectsVector.erase(oStart, oEnd);


  MDICOMWrapper w((*message)->identifier);

  w.log(logClient, MLogClient::MLOG_VERBOSE);

  if (strcmp((*message)->classUID, DICOM_SOPSTUDYQUERY_FIND) == 0) {
    MPatientStudy patientStudy;
    xlate.translateDICOM(w, patientStudy);

    MSeries series;
    xlate.translateDICOM(w, series);

    MSOPInstance sopInstance;
    xlate.translateDICOM(w, sopInstance);

    mImageManager->queryDICOMStudyRoot(patientStudy, series, sopInstance,
				      "STUDY", queryLevel, *this);
  } else {
    MPatient patient;
    xlate.translateDICOM(w, patient);

    MStudy study;
    xlate.translateDICOM(w, study);

    MSeries series;
    xlate.translateDICOM(w, series);

    MSOPInstance sopInstance;
    xlate.translateDICOM(w, sopInstance);

    mImageManager->queryDICOMPatientRoot(patient, study, series, sopInstance,
					"PATIENT", queryLevel, *this);
  }

#if 0
  MQRObjectsVector::iterator objIt = mObjectsVector.begin();
  for (; objIt != mObjectsVector.end(); objIt++) {
    MPatient x1 = (*objIt).patient();
    MStudy x2 = (*objIt).study();
    MSeries x3 = (*objIt).series();
    MSOPInstance x4 = (*objIt).sopInstance();

    cout << x1 << endl;
    cout << x2 << endl;
    cout << x3 << endl;
    cout << x4 << endl;

    xlate.translateDICOM(x1, (*message)->identifier, response->identifier);
  }
#endif

  return 0;
}

//  virtual
CONDITION
MLQuery::returnCFindDataSet(DUL_PRESENTATIONCONTEXT* ctx,
                                       MSG_C_FIND_REQ** message,
                                       MSG_C_FIND_RESP* response,
                                       DUL_ASSOCIATESERVICEPARAMETERS* params,
                                       const MString& queryLevel,
                                       int index)
{
  if (index > mObjectsVector.size()) {
    response->status = MSG_K_SUCCESS;
    response->dataSetType = DCM_CMDDATANULL;
  } else {
    response->status = MSG_K_C_FIND_MATCHCONTINUING;
    response->dataSetType = DCM_CMDDATAIDENTIFIER;
    MDICOMDomainXlate xlate;

    if (strcmp((*message)->classUID, DICOM_SOPSTUDYQUERY_FIND) == 0) {
      MPatientStudy x0 = mObjectsVector[index-1].patientStudy();
      xlate.translateDICOM(x0, (*message)->identifier, response->identifier);
    } else {
      MPatient x1 = mObjectsVector[index-1].patient();

      xlate.translateDICOM(x1, (*message)->identifier, response->identifier);

      if (queryLevel == "STUDY" || queryLevel == "SERIES" ||
	  queryLevel == "IMAGE") {
	MStudy x2 = mObjectsVector[index-1].study();
	xlate.translateDICOM(x2, (*message)->identifier, response->identifier);
      }
    }
    if (queryLevel == "SERIES" || queryLevel == "IMAGE") {
      MSeries x3 = mObjectsVector[index-1].series();
      xlate.translateDICOM(x3, (*message)->identifier, response->identifier);
    }
    if (queryLevel == "IMAGE") {
      MSOPInstance x4 = mObjectsVector[index-1].sopInstance();
      xlate.translateDICOM(x4, (*message)->identifier, response->identifier);
    }
    MDICOMWrapper r(response->identifier);
    r.setString(DCM_IDQUERYLEVEL, queryLevel);
    if (queryLevel == "IMAGE") {
      r.setString(DCM_IDRETRIEVEAETITLE, mAETitle);
    } else {
      r.setString(DCM_IDRETRIEVEAETITLE, "");
    }
    r.setString(DCM_IDINSTANCEAVAILABILITY, "ONLINE");
  }
  return SRV_NORMAL;
}

int
MLQuery::selectCallback(const MPatient& patient, const MStudy& study,
			const MSeries& series, const MSOPInstance& sop)
{
  MQRObjects obj(patient, study, series, sop);
  mObjectsVector.push_back(obj);

  return 0;
}

int
MLQuery::selectCallback(const MPatientStudy& patientStudy,
			const MSeries& series, const MSOPInstance& sop)
{
  MQRObjects obj(patientStudy, series, sop);
  mObjectsVector.push_back(obj);

  return 0;
}
