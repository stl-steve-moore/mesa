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

#include "MStudy.hpp"

MStudy::MStudy()
{
  tableName("study");
  insert("patid");
  insert("stuinsuid");
  insert("constuuid");
  insert("stuid");
  insert("studat");
  insert("stutim");
  insert("accnum");
  insert("refphynam");
  insert("studes");
  insert("patage");
  insert("patsiz");
  insert("modinstu");
  insert("numser");
  insert("numins");
  //insert("patsex");
}

MStudy::MStudy(const MStudy& cpy) :
  mPatientID(cpy.mPatientID),
  mStudyInstanceUID(cpy.mStudyInstanceUID),
  mConceptualStudyUID(cpy.mConceptualStudyUID),
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
  mNumberStudyRelatedInstances(cpy.mNumberStudyRelatedInstances)
{
  tableName("study");
  insert("patid", mPatientID);
  insert("stuinsuid", mStudyInstanceUID);
  insert("constuuid", mConceptualStudyUID);
  insert("stuid", mStudyID);
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
  //insert("patsex", mPatientSex);
}

MStudy::~MStudy()
{
}

void
MStudy::printOn(ostream& s) const
{
  s << "Study:"
    << mPatientID << ":"
    << mStudyInstanceUID << ":"
    << mConceptualStudyUID << ":"
    << mStudyID << ":"
    << mStudyDate << ":"
    << mStudyTime << ":"
    << mAccessionNumber << ":"
    << mReferringPhysicianName << ":"
    << mStudyDescription << ":"
    << mPatientAge << ":"
    << mPatientSize;
}

void
MStudy::streamIn(istream& s)
{
  s >> mStudyInstanceUID;
}

MStudy::MStudy(const MString& patientID,
	       const MString& studyInstanceUID, 
	       const MString& conceptualStudyUID, 
	       const MString& studyID, 
	       const MString& studyDate,
	       const MString& studyTime,
	       const MString& accessionNumber,
	       const MString& referringPhysicianName,
	       const MString& studyDescription,
	       const MString& patientAge,
	       const MString& patientSize) :
  mPatientID(patientID),
  mStudyInstanceUID(studyInstanceUID),
  mConceptualStudyUID(conceptualStudyUID),
  mStudyID(studyID),
  mStudyDate(studyDate),
  mStudyTime(studyTime),
  mAccessionNumber(accessionNumber),
  mReferringPhysicianName(referringPhysicianName),
  mStudyDescription(studyDescription),
  mPatientAge(patientAge),
  mPatientSize(patientSize),
  mModalitiesInStudy(""),
  mNumberStudyRelatedSeries("0"),
  mNumberStudyRelatedInstances("0")
{
  tableName("study");
  insert("patid", mPatientID);
  insert("stuinsuid", mStudyInstanceUID);
  insert("constuuid", mConceptualStudyUID);
  insert("stuid", mStudyID);
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
  //insert("patsex", mPatientSex);
}

MString
MStudy::patientID() const
{
  return mPatientID;
}

MString
MStudy::studyInstanceUID() const
{
  return mStudyInstanceUID;
}

MString
MStudy::conceptualStudyUID() const
{
  return mConceptualStudyUID;
}

MString
MStudy::studyID() const
{
  return mStudyID;
}

MString
MStudy::studyDate() const
{
  return mStudyDate;
}

MString
MStudy::studyTime() const
{
  return mStudyTime;
}

MString
MStudy::accessionNumber() const
{
  return mAccessionNumber;
}

MString
MStudy::referringPhysicianName() const
{
  return mReferringPhysicianName;
}

MString
MStudy::studyDescription() const
{
  return mStudyDescription;
}

MString
MStudy::patientAge() const
{
  return mPatientAge;
}

MString
MStudy::patientSize() const
{
  return mPatientSize;
}

MString
MStudy::modalitiesInStudy() const
{
  return mModalitiesInStudy;
}

MString
MStudy::numberStudyRelatedSeries() const
{
  return mNumberStudyRelatedSeries;
}

MString
MStudy::numberStudyRelatedInstances() const
{
  return mNumberStudyRelatedInstances;
}


void
MStudy::patientID(const MString& s)
{
  mPatientID = s;
  insert("patid", s);
}

void
MStudy::studyInstanceUID(const MString& s)
{
  mStudyInstanceUID = s;
  insert("stuinsuid", s);
}

void
MStudy::conceptualStudyUID(const MString& s)
{
  mConceptualStudyUID = s;
  insert("constuuid", s);
}

void
MStudy::studyID(const MString& s)
{
  mStudyID = s;
  insert("stuid", s);
}

void
MStudy::studyDate(const MString& s)
{
  mStudyDate = s;
  insert("studat", s);
}

void
MStudy::studyTime(const MString& s)
{
  mStudyTime = s;
  insert("stutim", s);
}

void
MStudy::accessionNumber(const MString& s)
{
  mAccessionNumber = s;
  insert("accnum", s);
}

void
MStudy::referringPhysicianName(const MString& s)
{
  mReferringPhysicianName = s;
  insert("refphynam", s);
}

void
MStudy::studyDescription(const MString& s)
{
  mStudyDescription = s;
  insert("studes", s);
}

void
MStudy::patientAge(const MString& s)
{
  mPatientAge = s;
  insert("patage", s);
}

void
MStudy::patientSize(const MString& s)
{
  mPatientSize = s;
  insert("patsiz", s);
}

void
MStudy::modalitiesInStudy(const MString& s)
{
  mModalitiesInStudy = s;
  insert("modinstu", s);
}

void
MStudy::numberStudyRelatedSeries(const MString& s)
{
  mNumberStudyRelatedSeries = s;
  insert("numser", s);
}


void
MStudy::numberStudyRelatedInstances(const MString& s)
{
  mNumberStudyRelatedInstances = s;
  insert("numins", s);
}

#if 0
void
MStudy::patientSex(const MString& s)
{
  mPatientSex = s;
  //insert("patsex", s);
}
#endif

void
MStudy::import(const MDomainObject& o)
{
  patientID(o.value("patid"));
  studyInstanceUID(o.value("stuinsuid"));
  conceptualStudyUID(o.value("constuuid"));
  studyID(o.value("stuid"));
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
}
