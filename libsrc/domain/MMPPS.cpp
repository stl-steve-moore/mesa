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

#include "MMPPS.hpp"

MMPPS::MMPPS()
{
  tableName("mpps");
  insert("patnam");
  insert("patid");
  insert("patbirdat");
  insert("patsex");
  insert("ppsid");
  insert("perstaaetit");
  insert("perstanam");
  insert("perloc");
  insert("ppsstadat");
  insert("ppsstatim");
  insert("ppssta");
  insert("ppsdes");
  insert("pptypdes");
  insert("ppsenddat");
  insert("ppsendtim");
  insert("mod");
  insert("stuid");
  //insert("perserseq");
  //insert("schsteattseq");
  //insert("refstucomseq");
}

MMPPS::MMPPS(const MMPPS& cpy) :
  mPatientName(cpy.mPatientName),
  mPatientID(cpy.mPatientID),
  mPatientBirthDate(cpy.mPatientBirthDate),
  mPatientSex(cpy.mPatientSex),
  mPPSID(cpy.mPPSID),
  mPerformedStationAETitle(cpy.mPerformedStationAETitle),
  mPerformedStationName(cpy.mPerformedStationName),
  mPerformedLocation(cpy.mPerformedLocation),
  mPPSStartDate(cpy.mPPSStartDate),
  mPPSStartTime(cpy.mPPSStartTime),
  mPPSStatus(cpy.mPPSStatus),
  mPPSDescription(cpy.mPPSDescription),
  mPPTypeDescription(cpy.mPPTypeDescription),
  mPPSEndDate(cpy.mPPSEndDate),
  mPPSEndTime(cpy.mPPSEndTime),
  mModality(cpy.mModality),
  mStudyID(cpy.mStudyID)
  //mPerformedSeriesSequence(cpy.mPerformedSeriesSequence),
  //mScheduledStepAttributesSequence(cpy.mScheduledStepAttributesSequence),
  //mReferencedStudyComponentSequence(cpy.mReferencedStudyComponentSequence)
{
  tableName("mpps");
  insert("patnam", cpy.mPatientName);
  insert("patid", cpy.mPatientID);
  insert("patbirdat", cpy.mPatientBirthDate);
  insert("patsex", cpy.mPatientSex);
  insert("ppsid", cpy.mPPSID);
  insert("perstaaetit", cpy.mPerformedStationAETitle);
  insert("perstanam", cpy.mPerformedStationName);
  insert("perloc", cpy.mPerformedLocation);
  insert("ppsstadat", cpy.mPPSStartDate);
  insert("ppsstatim", cpy.mPPSStartTime);
  insert("ppssta", cpy.mPPSStatus);
  insert("ppsdes", cpy.mPPSDescription);
  insert("pptypdes", cpy.mPPTypeDescription);
  insert("ppsenddat", cpy.mPPSEndDate);
  insert("ppsendtim", cpy.mPPSEndTime);
  insert("mod", cpy.mModality);
  insert("stuid", cpy.mStudyID);
  //insert("perserseq", cpy.mPerformedSeriesSequence);
  //insert("schsteattseq", cpy.mScheduledStepAttributesSequence);
  //insert("refstucomseq", cpy.mReferencedStudyComponentSequence);
}

MMPPS::~MMPPS()
{
}

void
MMPPS::printOn(ostream& s) const
{
  s << "MMPPS:"
  << mPatientName << ":"
  << mPatientID << ":"
  << mPatientBirthDate << ":"
  << mPatientSex << ":"
  << mPPSID << ":"
  << mPerformedStationAETitle << ":"
  << mPerformedStationName << ":"
  << mPerformedLocation << ":"
  << mPPSStartDate << ":"
  << mPPSStartTime << ":"
  << mPPSStatus << ":"
  << mPPSDescription << ":"
  << mPPTypeDescription << ":"
  << mPPSEndDate << ":"
  << mPPSEndTime << ":"
  << mModality << ":"
  << mStudyID ;
  //<< mPerformedSeriesSequence << ":"
  //<< mScheduledStepAttributesSequence << ":"
  //<< mReferencedStudyComponentSequence;
}

MMPPS::MMPPS(const MString& patientName, const MString& patientID,
	     const MString& patientBirthDate, const MString& patientSex,
	     const MString& pPSID, const MString& performedStationAETitle,
	     const MString& performedStationName,
	     const MString& performedLocation,
	     const MString& pPSStartDate, const MString& pPSStartTime,
	     const MString& pPSStatus, const MString& pPSDescription,
	     const MString& pPTypeDescription, const MString& pPSEndDate,
	     const MString& pPSEndTime, const MString& modality,
	     const MString& studyID) :
  mPatientName(patientName),
  mPatientID(patientID),
  mPatientBirthDate(patientBirthDate),
  mPatientSex(patientSex),
  mPPSID(pPSID),
  mPerformedStationAETitle(performedStationAETitle),
  mPerformedStationName(performedStationName),
  mPerformedLocation(performedLocation),
  mPPSStartDate(pPSStartDate),
  mPPSStartTime(pPSStartTime),
  mPPSStatus(pPSStatus),
  mPPSDescription(pPSDescription),
  mPPTypeDescription(pPTypeDescription),
  mPPSEndDate(pPSEndDate),
  mPPSEndTime(pPSEndTime),
  mModality(modality),
  mStudyID(studyID)
{
  tableName("mpps");
  insert("patnam", patientName);
  insert("patid", patientID);
  insert("patbirdat", patientBirthDate);
  insert("patsex", patientSex);
  insert("ppsid", pPSID);
  insert("perstaaetit", performedStationAETitle);
  insert("perstanam", performedStationName);
  insert("perloc", performedLocation);
  insert("ppsstadat", pPSStartDate);
  insert("ppsstatim", pPSStartTime);
  insert("ppssta", pPSStatus);
  insert("ppsdes", pPSDescription);
  insert("pptypdes", pPTypeDescription);
  insert("ppsenddat", pPSEndDate);
  insert("ppsendtim", pPSEndTime);
  insert("mod", modality);
  insert("stuid", studyID);
  //insert("perserseq", performedSeriesSequence);
  //insert("schsteattseq", scheduledStepAttributesSequence);
  //insert("refstucomseq", referencedStudyComponentSequence);
}

void
MMPPS::streamIn(istream& s)
{
  s >> mPatientName;
}

MString
MMPPS::patientName() const
{
  return mPatientName;
}

MString
MMPPS::patientID() const
{
  return mPatientID;
}

MString
MMPPS::patientBirthDate() const
{
  return mPatientBirthDate;
}

MString
MMPPS::patientSex() const
{
  return mPatientSex;
}

MString
MMPPS::pPSID() const
{
  return mPPSID;
}

MString
MMPPS::performedStationAETitle() const
{
  return mPerformedStationAETitle;
}

MString
MMPPS::performedStationName() const
{
  return mPerformedStationName;
}

MString
MMPPS::performedLocation() const
{
  return mPerformedLocation;
}

MString
MMPPS::pPSStartDate() const
{
  return mPPSStartDate;
}

MString
MMPPS::pPSStartTime() const
{
  return mPPSStartTime;
}

MString
MMPPS::pPSStatus() const
{
  return mPPSStatus;
}

MString
MMPPS::pPSDescription() const
{
  return mPPSDescription;
}

MString
MMPPS::pPTypeDescription() const
{
  return mPPTypeDescription;
}

MString
MMPPS::pPSEndDate() const
{
  return mPPSEndDate;
}

MString
MMPPS::pPSEndTime() const
{
  return mPPSEndTime;
}

MString
MMPPS::modality() const
{
  return mModality;
}

MString
MMPPS::studyID() const
{
  return mStudyID;
}

#if 0
MString
MMPPS::performedSeriesSequence() const
{
  return mPerformedSeriesSequence;
}

MString
MMPPS::scheduledStepAttributesSequence() const
{
  return mScheduledStepAttributesSequence;
}

MString
MMPPS::referencedStudyComponentSequence() const
{
  return mReferencedStudyComponentSequence;
}
#endif

void
MMPPS::patientName(const MString& s)
{
  mPatientName = s;
  insert("patnam", s);
}

void
MMPPS::patientID(const MString& s)
{
  mPatientID = s;
  insert("patid", s);
}

void
MMPPS::patientBirthDate(const MString& s)
{
  mPatientBirthDate = s;
  insert("patbirdat", s);
}

void
MMPPS::patientSex(const MString& s)
{
  mPatientSex = s;
  insert("patsex", s);
}

void
MMPPS::pPSID(const MString& s)
{
  mPPSID = s;
  insert("ppsid", s);
}

void
MMPPS::performedStationAETitle(const MString& s)
{
  mPerformedStationAETitle = s;
  insert("perstaaetit", s);
}

void
MMPPS::performedStationName(const MString& s)
{
  mPerformedStationName = s;
  insert("perstanam", s);
}

void
MMPPS::performedLocation(const MString& s)
{
  mPerformedLocation = s;
  insert("perloc", s);
}

void
MMPPS::pPSStartDate(const MString& s)
{
  mPPSStartDate = s;
  insert("ppsstadat", s);
}

void
MMPPS::pPSStartTime(const MString& s)
{
  mPPSStartTime = s;
  insert("ppsstatim", s);
}

void
MMPPS::pPSStatus(const MString& s)
{
  mPPSStatus = s;
  insert("ppssta", s);
}

void
MMPPS::pPSDescription(const MString& s)
{
  mPPSDescription = s;
  insert("ppsdes", s);
}

void
MMPPS::pPTypeDescription(const MString& s)
{
  mPPTypeDescription = s;
  insert("pptypdes", s);
}

void
MMPPS::pPSEndDate(const MString& s)
{
  mPPSEndDate = s;
  insert("ppsenddat", s);
}

void
MMPPS::pPSEndTime(const MString& s)
{
  mPPSEndTime = s;
  insert("ppsendtim", s);
}

void
MMPPS::modality(const MString& s)
{
  mModality = s;
  insert("mod", s);
}

void
MMPPS::studyID(const MString& s)
{
  mStudyID = s;
  insert("stuid", s);
}

#if 0
void
MMPPS::performedSeriesSequence(const MString& s)
{
  mPerformedSeriesSequence = s;
  insert("perserseq", s);
}

void
MMPPS::scheduledStepAttributesSequence(const MString& s)
{
  mScheduledStepAttributesSequence = s;
  insert("schsteattseq", s);
}

void
MMPPS::referencedStudyComponentSequence(const MString& s)
{
  mReferencedStudyComponentSequence = s;
  insert("refstucomseq", s);
}
#endif

void
MMPPS::import(MDomainObject& o)
{
  patientName(o.value("patname"));
  patientID(o.value("patid"));
  patientBirthDate(o.value("patbirdat"));
  patientSex(o.value("patsex"));
  pPSID(o.value("ppsid"));
  performedStationAETitle(o.value("perstaaetit"));
  performedStationName(o.value("perstanam"));
  performedLocation(o.value("perloc"));
  pPSStartDate(o.value("ppsstadat"));
  pPSStartTime(o.value("ppsstatim"));
  pPSStatus(o.value("ppssta"));
  pPSDescription(o.value("ppsdes"));
  pPTypeDescription(o.value("pptypdes"));
  pPSEndDate(o.value("ppsenddat"));
  pPSEndTime(o.value("ppsendtim"));
  modality(o.value("mod"));
  studyID(o.value("stuid"));
  //performedSeriesSequence(o.value("perserseq"));
  //scheduledStepAttributesSequence(o.value("schsteattseq"));
  //referencedStudyComponentSequence(o.value("refstucomseq"));
}
