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

#include "MSPS.hpp"

MSPS::MSPS()
{
  tableName("sps");
  insert("spsid");
  insert("schaet");
  insert("spsstadat");
  insert("spsstatim");
  insert("mod");
  insert("schperphynam");
  insert("spsdes");
  insert("spsloc");
  insert("premed");
  insert("reqconage");
  insert("schstanam");
  insert("stuinsuid");
  insert("spssta");
}

MSPS::MSPS(const MSPS& cpy)  :
  mScheduledProcedureStepID(cpy.mScheduledProcedureStepID),
  mScheduledAETitle(cpy.mScheduledAETitle),
  mSPSStartDate(cpy.mSPSStartDate),
  mSPSStartTime(cpy.mSPSStartTime),
  mModality(cpy.mModality),
  mScheduledPerformingPhysicianName(cpy.mScheduledPerformingPhysicianName),
  mSPSDescription(cpy.mSPSDescription),
  mSPSLocation(cpy.mSPSLocation),
  mPreMedication(cpy.mPreMedication),
  mRequestedContrastAgent(cpy.mRequestedContrastAgent),
  mScheduledStationName(cpy.mScheduledStationName),
  mStudyInstanceUID(cpy.mStudyInstanceUID),
  mSPSStatus(cpy.mSPSStatus)
{
  tableName("sps");
  insert("spsid", cpy.mScheduledProcedureStepID);
  insert("schaet", cpy.mScheduledAETitle);
  insert("spsstadat", cpy.mSPSStartDate);
  insert("spsstatim", cpy.mSPSStartTime);
  insert("mod", cpy.mModality);
  insert("schperphynam", cpy.mScheduledPerformingPhysicianName);
  insert("spsdes", cpy.mSPSDescription);
  insert("spsloc", cpy.mSPSLocation);
  insert("premed", cpy.mPreMedication);
  insert("reqconage", cpy.mRequestedContrastAgent);
  insert("schstanam", cpy.mScheduledStationName);
  insert("stuinsuid", cpy.mStudyInstanceUID);
  insert("spssta", cpy.mSPSStatus);
}

MSPS::~MSPS()
{
}

void
MSPS::printOn(ostream& s) const
{
  s << "MSPS:"
    << mScheduledProcedureStepID << ":"
    << mScheduledAETitle << ":"
    << mSPSStartDate << ":"
    << mSPSStartTime << ":"
    << mModality << ":"
    << mScheduledPerformingPhysicianName << ":"
    << mSPSDescription << ":"
    << mSPSLocation << ":"
    << mPreMedication << ":"
    << mRequestedContrastAgent << ":"
    << mScheduledStationName << ":"
    << mStudyInstanceUID << ":"
    << mSPSStatus;
}

void
MSPS::import(const MDomainObject& o)
{
  scheduledAETitle(o.value("schaet"));
  studyInstanceUID(o.value("stuinsuid"));
}

MSPS::MSPS(const MString& scheduledProcedureStepID,
           const MString& scheduledAETitle,
           const MString& sPSStartDate, const MString& sPSStartTime,
           const MString& modality, const MString& scheduledPerformingPhysicianName,
           const MString& sPSDescription, const MString& sPSLocation,
           const MString& preMedication, const MString& requestedContrastAgent,
	   const MString& scheduledStationName, const MString& studyInstanceUID,
	   const MString& sPSStatus)  :
  mScheduledProcedureStepID(scheduledProcedureStepID),
  mScheduledAETitle(scheduledAETitle),
  mSPSStartDate(sPSStartDate),
  mSPSStartTime(sPSStartTime),
  mModality(modality),
  mScheduledPerformingPhysicianName(scheduledPerformingPhysicianName),
  mSPSDescription(sPSDescription),
  mSPSLocation(sPSLocation),
  mPreMedication(preMedication),
  mRequestedContrastAgent(requestedContrastAgent),
  mScheduledStationName(scheduledStationName),
  mStudyInstanceUID(studyInstanceUID),
  mSPSStatus(sPSStatus)
{
  tableName("sps");
  insert("spsid", scheduledProcedureStepID);
  insert("schaet", scheduledAETitle);
  insert("spsstadat", sPSStartDate);
  insert("spsstatim", sPSStartTime);
  insert("mod", modality);
  insert("schperphynam", scheduledPerformingPhysicianName);
  insert("spsdes", sPSDescription);
  insert("spsloc", sPSLocation);
  insert("premed", preMedication);
  insert("reqconage", requestedContrastAgent);
  insert("schstanam", scheduledStationName);
  insert("stuinsuid", studyInstanceUID);
  insert("spssta", sPSStatus);
}

void
MSPS::streamIn(istream& s)
{
  //s >> this->member;
}

MString
MSPS::scheduledProcedureStepID() const
{
  return mScheduledProcedureStepID;
}

MString
MSPS::scheduledAETitle() const
{
  return mScheduledAETitle;
}

MString
MSPS::sPSStartDate() const
{
  return mSPSStartDate;
}

MString
MSPS::sPSStartTime() const
{
  return mSPSStartTime;
}

MString
MSPS::modality() const
{
  return mModality;
}

MString
MSPS::scheduledPerformingPhysicianName() const
{
  return mScheduledPerformingPhysicianName;
}

MString
MSPS::sPSDescription() const
{
  return mSPSDescription;
}

MString
MSPS::sPSLocation() const
{
  return mSPSLocation;
}

MString
MSPS::preMedication() const
{
  return mPreMedication;
}

MString
MSPS::requestedContrastAgent() const
{
  return mRequestedContrastAgent;
}

MString
MSPS::scheduledStationName() const
{
  return mRequestedContrastAgent;
}

MString
MSPS::studyInstanceUID() const
{
  return mStudyInstanceUID;
}

MString
MSPS::sPSStatus() const
{
  return mSPSStatus;
}

void
MSPS::scheduledProcedureStepID(const MString& s)
{
  mScheduledProcedureStepID = s;
  insert("spsid", s);
}

void
MSPS::scheduledAETitle(const MString& s)
{
  mScheduledAETitle = s;
  insert("schaet", s);
}

void
MSPS::sPSStartDate(const MString& s)
{
  mSPSStartDate = s;
  insert("spsstadat", s);
}

void
MSPS::sPSStartTime(const MString& s)
{
  mSPSStartTime = s;
  insert("spsstatim", s);
}

void
MSPS::modality(const MString& s)
{
  mModality = s;
  insert("mod", s);
}

void
MSPS::scheduledPerformingPhysicianName(const MString& s)
{
  mScheduledPerformingPhysicianName = s;
  insert("schperphynam", s);
}

void
MSPS::sPSDescription(const MString& s)
{
  mSPSDescription = s;
  insert("spsdes", s);
}

void
MSPS::sPSLocation(const MString& s)
{
  mSPSLocation = s;
  insert("spsloc", s);
}

void
MSPS::preMedication(const MString& s)
{
  mPreMedication = s;
  insert("premed", s);
}

void
MSPS::requestedContrastAgent(const MString& s)
{
  mRequestedContrastAgent = s;
  insert("reqconage", s);
}

void
MSPS::scheduledStationName(const MString& s)
{
  mScheduledStationName = s;
  insert("schstanam", s);
}

void
MSPS::studyInstanceUID(const MString& s)
{
  mStudyInstanceUID = s;
  insert("stuinsuid", s);
}

void
MSPS::sPSStatus(const MString& s)
{
  mSPSStatus = s;
  insert("spssta", s);
}
