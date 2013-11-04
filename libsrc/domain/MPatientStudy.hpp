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

// $Id: MPatientStudy.hpp,v 1.12 2006/06/29 16:08:31 bhasselfeld Exp $ $Author: bhasselfeld $ $Revision: 1.12 $ $Date: 2006/06/29 16:08:31 $ $State: Exp $
// ======================
// = FILENAME
//	MPatientStudy.hpp
//
// = AUTHOR
//	Steve Moore
//
//  = COPYRIGHT
//	Copyright HIMSS, RSNA, Washington University: 1999, 2000
//
// ======================
//
//  = VERSION
//	$Revision: 1.12 $
//
//  = DATE RELEASED
//	$Date: 2006/06/29 16:08:31 $
//
//  = COMMENTS
//
#ifndef MPatientStudyISIN
#define MPatientStudyISIN

#include <iostream>
#include "MDomainObject.hpp"
#include "MPatient.hpp"
#include "MStudy.hpp"

class MPatientStudy;
typedef vector < MPatientStudy > MPatientStudyVector;

using namespace std;

// = TITLE
/**\brief	A domain object which corresponds to the patient/study
		definition in DICOM query/retrieve classes. */

// = DESCRIPTION
/**	This class is a container for attributes which define a DICOM
	patient/study.  It inherits from <{MDomainObject}> and supports the
	ability to get and set values with specific methods.  Because this
	class is just a container, it performs no validation tests. */

class MPatientStudy : public MDomainObject
{
public:
  MPatientStudy();
  MPatientStudy(const MPatientStudy& patient);
  MPatientStudy(const MPatient& patient, const MStudy& study);
  virtual ~MPatientStudy();
  virtual void printOn(ostream& s) const;

  MPatientStudy(const MString& patientID, const MString& issuerOfPatientID,
          const MString& patientID2, const MString& issuerOfPatientID2,
	  const MString& patientName, const MString& dateOfBirth,
	  const MString& patientSex);
  virtual void streamIn(istream& s);
  void import(const MDomainObject& o);

  MString patientID() const;
  // Return the Patient ID attribute

  MString issuerOfPatientID() const;
  MString patientID2() const;
  MString issuerOfPatientID2() const;
  MString patientName() const;
  MString dateOfBirth() const;
  MString patientSex() const;
  MString studyInstanceUID() const;
  MString studyID() const;
  MString studyDate() const;
  MString studyTime() const;
  MString accessionNumber() const;
  MString referringPhysicianName() const;
  MString studyDescription() const;
  MString patientAge() const;
  MString patientSize() const;
  MString modalitiesInStudy() const;
  //MString patientSex() const;
  MString studyOrigin() const;
  MString numberStudyRelatedSeries() const;
  MString numberStudyRelatedInstances() const;
  MString timeStudyLastModified() const;

  void patientID(const MString& s);
  void issuerOfPatientID(const MString& s);
  void patientID2(const MString& s);
  void issuerOfPatientID2(const MString& s);
  void patientName(const MString& s);
  void dateOfBirth(const MString& s);
  void patientSex(const MString& s);
  void studyInstanceUID(const MString& s);
  void studyID(const MString& s);
  void studyDate(const MString& s);
  void studyTime(const MString& s);
  void accessionNumber(const MString& s);
  void referringPhysicianName(const MString& s);
  void studyDescription(const MString& s);
  void patientAge(const MString& s);
  void patientSize(const MString& s);
  void modalitiesInStudy(const MString& s);
  void numberStudyRelatedSeries(const MString& s);
  void numberStudyRelatedSeries(int c);
  void numberStudyRelatedInstances(const MString& s);
  void numberStudyRelatedInstances(int c);
  void studyOrigin(const MString& s);
  void timeStudyLastModified(const MString& s);
  //void patientSex(const MString& s);

private:
  
  MString mPatientID;
  MString mIssuerOfPatientID;
  MString mPatientID2;
  MString mIssuerOfPatientID2;
  MString mPatientName;
  MString mDateOfBirth;
  MString mPatientSex;

  MString mStudyInstanceUID;
  MString mStudyID;
  MString mStudyDate;
  MString mStudyTime;
  MString mAccessionNumber;
  MString mReferringPhysicianName;
  MString mStudyDescription;
  MString mPatientAge;
  MString mPatientSize;

  MString mModalitiesInStudy;
  MString mNumberStudyRelatedSeries;
  MString mNumberStudyRelatedInstances;
  MString mStudyOrigin;
  MString mTimeLastModified;

  void fillMap();

};

inline ostream& operator<< (ostream& s, const MPatientStudy& patient) {
	  patient.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MPatientStudy& patient) {
  patient.streamIn(s);
  return s;
}

#endif
