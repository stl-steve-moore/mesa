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

#include "MPatientStudy.hpp"
#include <strstream>

MPatientStudy::MPatientStudy() :
  mPatientID(""),
  mIssuerOfPatientID(""),
  mPatientID2(""),
  mIssuerOfPatientID2(""),
  mPatientName(""),
  mDateOfBirth(""),
  mPatientSex(""),

  mStudyInstanceUID(""),
  mStudyID(""),
  mStudyDate(""),
  mStudyTime(""),
  mAccessionNumber(""),
  mReferringPhysicianName(""),
  mStudyDescription(""),
  mPatientAge(""),
  mPatientSize(""),
  mModalitiesInStudy(""),
  mNumberStudyRelatedSeries(""),
  mNumberStudyRelatedInstances(""),
  mStudyOrigin(""),
  mTimeLastModified("")
{
  tableName("ps_view");
  this->fillMap();
}

MPatientStudy::MPatientStudy(const MPatientStudy& cpy) :
  mPatientID(cpy.mPatientID),
  mIssuerOfPatientID(cpy.mIssuerOfPatientID),
  mPatientID2(cpy.mPatientID2),
  mIssuerOfPatientID2(cpy.mIssuerOfPatientID2),
  mPatientName(cpy.mPatientName),
  mDateOfBirth(cpy.mDateOfBirth),
  mPatientSex(cpy.mPatientSex),

  mStudyInstanceUID(cpy.mStudyInstanceUID),
  mStudyID(cpy.mStudyID),
  mStudyDate(cpy.mStudyDate),
  mStudyTime(cpy.mStudyTime),
  mAccessionNumber(cpy.mAccessionNumber),
  mReferringPhysicianName(cpy.mReferringPhysicianName),
  mStudyDescription(cpy.mStudyDescription),
  mPatientAge(cpy.mPatientAge),
  mPatientSize(cpy.mPatientSize),
  mModalitiesInStudy(cpy.mModalitiesInStudy),
  mNumberStudyRelatedSeries(cpy.mNumberStudyRelatedSeries),
  mNumberStudyRelatedInstances(cpy.mNumberStudyRelatedInstances),
  mStudyOrigin(cpy.mStudyOrigin),
  mTimeLastModified(cpy.mTimeLastModified)
{
  tableName("ps_view");
  this->fillMap();
}

MPatientStudy::MPatientStudy(const MPatient& patient, const MStudy& study) :
  mPatientID(patient.patientID()),
  mIssuerOfPatientID(patient.issuerOfPatientID()),
  mPatientID2(patient.patientID2()),
  mIssuerOfPatientID2(patient.issuerOfPatientID2()),
  mPatientName(patient.patientName()),
  mDateOfBirth(patient.dateOfBirth()),
  mPatientSex(patient.patientSex()),

  mStudyInstanceUID(study.studyInstanceUID()),
  mStudyID(study.studyID()),
  mStudyDate(study.studyDate()),
  mStudyTime(study.studyTime()),
  mAccessionNumber(study.accessionNumber()),
  mReferringPhysicianName(study.referringPhysicianName()),
  mStudyDescription(study.studyDescription()),
  mPatientAge(study.patientAge()),
  mPatientSize(study.patientSize()),
  mModalitiesInStudy(study.modalitiesInStudy()),
  mNumberStudyRelatedSeries(study.numberStudyRelatedSeries()),
  mNumberStudyRelatedInstances(study.numberStudyRelatedInstances()),
  mStudyOrigin(""),
  mTimeLastModified("")

{
  tableName("ps_view");
  this->fillMap();
}

MPatientStudy::~MPatientStudy()
{
}

void
MPatientStudy::printOn(ostream& s) const
{
  s << mPatientID << ":"
    << mIssuerOfPatientID << ":"
    << mPatientID2 << ":"
    << mIssuerOfPatientID2 << ":"
    << mPatientName << ":"
    << mDateOfBirth << ":"
    << mPatientSex;
}

MPatientStudy::MPatientStudy(const MString& patientID, const MString& issuerOfPatientID,
	  const MString& patientID2, const MString& issuerOfPatientID2,
	  const MString& patientName, const MString& dateOfBirth,
	  const MString& patientSex) :
	  mPatientID(patientID),
	  mIssuerOfPatientID(issuerOfPatientID),
	  mPatientID2(patientID2),
	  mIssuerOfPatientID2(issuerOfPatientID2),
	  mPatientName(patientName),
	  mDateOfBirth(dateOfBirth),
	  mPatientSex(patientSex),
	  mNumberStudyRelatedSeries("0"),
	  mNumberStudyRelatedInstances("0"),
	  mTimeLastModified("")
{
  tableName("ps_view");
  insert("patid", patientID);
  insert("issuer", issuerOfPatientID);
  insert("patid2", patientID2);
  insert("issuer2", issuerOfPatientID2);
  insert("nam", patientName);
  insert("datbir", dateOfBirth);
  insert("sex", patientSex);

  insert("numser", mNumberStudyRelatedSeries);
  insert("numins", mNumberStudyRelatedInstances);
}

void
MPatientStudy::streamIn(istream& s)
{
  s >> mPatientID;
}


// lots of accessor methods:
MString
MPatientStudy::patientID() const
{
  return mPatientID;
}

MString
MPatientStudy::issuerOfPatientID() const
{
  return mIssuerOfPatientID;
}

MString
MPatientStudy::patientID2() const
{
  return mPatientID2;
}

MString
MPatientStudy::issuerOfPatientID2() const
{
  return mIssuerOfPatientID2;
}

MString
MPatientStudy::patientName() const
{
  return mPatientName;
}

MString
MPatientStudy::dateOfBirth() const
{
  return mDateOfBirth;
}

MString
MPatientStudy::patientSex() const
{
  return mPatientSex;
}

MString
MPatientStudy::studyDescription() const
{
  return mStudyDescription;
}

MString
MPatientStudy::studyID() const
{
  return mStudyID;
}

MString
MPatientStudy::studyOrigin() const
{
  return mStudyOrigin;
}

MString
MPatientStudy::studyDate() const
{
  return mStudyDate;
}

MString
MPatientStudy::studyTime() const
{
  return mStudyTime;
}

MString
MPatientStudy::accessionNumber() const
{
  return mAccessionNumber;
}

MString
MPatientStudy::modalitiesInStudy() const
{
  return mModalitiesInStudy;
}

MString
MPatientStudy::numberStudyRelatedSeries() const
{
  return mNumberStudyRelatedSeries;
}

MString
MPatientStudy::numberStudyRelatedInstances() const
{
  return mNumberStudyRelatedInstances;
}

MString
MPatientStudy::timeStudyLastModified() const
{
  return mTimeLastModified;
}

// lots of mutator methods:
void
MPatientStudy::patientID(const MString& s)
{
  mPatientID = s;
  insert("patid", s);
}

void
MPatientStudy::issuerOfPatientID(const MString& s)
{
  mIssuerOfPatientID = s;
  insert("issuer", s);
}

void
MPatientStudy::patientID2(const MString& s)
{
  mPatientID2 = s;
  insert("patid2", s);
}

void
MPatientStudy::issuerOfPatientID2(const MString& s)
{
  mIssuerOfPatientID2 = s;
  insert("issuer2", s);
}

void
MPatientStudy::patientName(const MString& s)
{
  mPatientName = s;
  insert("nam", s);
}

void
MPatientStudy::dateOfBirth(const MString& s)
{
  mDateOfBirth = s;
  insert("datbir", s);
}

void
MPatientStudy::patientSex(const MString& s)
{
  mPatientSex = s;
  insert("sex", s);
}

MString
MPatientStudy::studyInstanceUID() const
{
  return mStudyInstanceUID;
}

void
MPatientStudy::studyInstanceUID(const MString& s)
{
  mStudyInstanceUID = s;
  insert("stuinsuid", s);
}

void
MPatientStudy::studyID(const MString& s)
{
  mStudyID = s;
  insert("stuid", s);
}

void
MPatientStudy::studyOrigin(const MString& s)
{
  mStudyOrigin = s;
  insert("stuorg", s);
}

void
MPatientStudy::studyDate(const MString& s)
{
  mStudyDate = s;
  insert("studat", s);
}

void
MPatientStudy::
studyTime(const MString& s)
{
  mStudyTime = s;
  insert("stutim", s);
}

void
MPatientStudy::accessionNumber(const MString& s)
{
  mAccessionNumber = s;
  insert("accnum", s);
}

void
MPatientStudy::referringPhysicianName(const MString& s)
{
  mReferringPhysicianName = s;
  insert("refphynam", s);
}

void
MPatientStudy::studyDescription(const MString& s)
{
  mStudyDescription = s;
  insert("studes", s);
}

void
MPatientStudy::patientAge(const MString& s)
{
  mPatientAge = s;
  insert("patage", s);
}

void
MPatientStudy::patientSize(const MString& s)
{
  mPatientSize = s;
  insert("patsiz", s);
}

void
MPatientStudy::modalitiesInStudy(const MString& s)
{
  mModalitiesInStudy = s;
  insert("modinstu", s);
}

void
MPatientStudy::numberStudyRelatedSeries(const MString& s)
{
  mNumberStudyRelatedSeries = s;
  insert("numser", s);
}

void
MPatientStudy::numberStudyRelatedSeries(int c)
{
  char tmp[16];
  strstream x(tmp, 15);
  x << c << '\0';
  this->numberStudyRelatedSeries(tmp);
}

void
MPatientStudy::numberStudyRelatedInstances(const MString& s)
{
  mNumberStudyRelatedInstances = s;
  insert("numins", s);
}

void
MPatientStudy::numberStudyRelatedInstances(int c)
{
  char tmp[16];
  strstream x(tmp, 15);
  x << c << '\0';
  this->numberStudyRelatedInstances(tmp);
}

void
MPatientStudy::timeStudyLastModified(const MString& s)
{
  mTimeLastModified = s;
  insert("lastmod", s);
}

void MPatientStudy::import(const MDomainObject& o)
{
  patientID(o.value("patid"));
  issuerOfPatientID(o.value("issuer"));
  patientID2(o.value("patid2"));
  issuerOfPatientID2(o.value("issuer2"));
  patientName(o.value("nam"));
  dateOfBirth(o.value("datbir"));
  patientSex(o.value("sex"));

  studyInstanceUID(o.value("stuinsuid"));
  studyID(o.value("stuid"));
  studyOrigin(o.value("stuorg"));
  studyDate(o.value("studat"));
  studyTime(o.value("stutim"));
  accessionNumber(o.value("accnum"));
  referringPhysicianName(o.value("refphynam"));
  studyDescription(o.value("studes"));
  patientAge(o.value("patage"));
  patientSize(o.value("patsiz"));

  modalitiesInStudy(o.value("modinstu"));
  numberStudyRelatedSeries(o.value("numser"));
  numberStudyRelatedInstances(o.value("numins"));
  timeStudyLastModified(o.value("lastmod"));
}

void
MPatientStudy::fillMap()
{
  insert("patid", mPatientID);
  insert("issuer", mIssuerOfPatientID);
  insert("patid2", mPatientID2);
  insert("issuer2", mIssuerOfPatientID2);
  insert("nam", mPatientName);
  insert("datbir", mDateOfBirth);
  insert("sex", mPatientSex);

  insert("stuinsuid", mStudyInstanceUID);
  insert("stuid", mStudyID);
  insert("stuorg", mStudyOrigin);
  insert("studat", mStudyDate);
  insert("stutim", mStudyTime);
  insert("accnum", mAccessionNumber);
  insert("refphynam", mReferringPhysicianName);
  insert("studes", mStudyDescription);
  insert("patage", mPatientAge);
  insert("patsiz", mPatientSize);

  insert("modinstu", mModalitiesInStudy);
  insert("numser", mNumberStudyRelatedSeries);
  insert("numins", mNumberStudyRelatedInstances);
  insert("lastmod", mTimeLastModified);
}
