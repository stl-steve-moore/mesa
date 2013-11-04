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

#include "MVisit.hpp"

MVisit::MVisit()
{
  tableName("visit");
  insert("visnum");
  insert("patid");
  insert("issuer");
  insert("patcla");
  insert("asspatloc");
  insert("attdoc");
  insert("admdat");
  insert("admtim");
  insert("admdoc");
}

MVisit::MVisit(const MVisit& cpy) :
  mVisitNumber(cpy.mVisitNumber),
  mPatientID(cpy.mPatientID),
  mIssuerOfPatientID(cpy.mIssuerOfPatientID),
  mPatientClass(cpy.mPatientClass),
  mAssignedPatientLocation(cpy.mAssignedPatientLocation),
  mAttendingDoctor(cpy.mAttendingDoctor),
  mAdmitDate(cpy.mAdmitDate),
  mAdmitTime(cpy.mAdmitTime),
  mAdmittingDoctor(cpy.mAdmittingDoctor),
  mReferringDoctor(cpy.mReferringDoctor)
{
  tableName("visit");
  insert("visnum",cpy.mVisitNumber);
  insert("patid", cpy.mPatientID);
  insert("issuer", cpy.mIssuerOfPatientID);
  insert("patcla", cpy.mPatientClass);
  insert("asspatloc", cpy.mAssignedPatientLocation);
  insert("attdoc", cpy.mAttendingDoctor);
  insert("admdat", cpy.mAdmitDate);
  insert("admtim", cpy.mAdmitTime);
  insert("admdoc", cpy.mAdmittingDoctor);
  insert("refdoc", cpy.mReferringDoctor);
}

MVisit::~MVisit()
{
}

void
MVisit::printOn(ostream& s) const
{
  s << "VISIT:"
    << mVisitNumber << ":"
    << mPatientID << ":"
    << mIssuerOfPatientID << ":"
    << mPatientClass << ":"
    << mAssignedPatientLocation << ":"
    << mAttendingDoctor << ":"
    << mAdmitDate << ":"
    << mAdmitTime << ":"
    << mAdmittingDoctor << ":"
    << mReferringDoctor;
}

MVisit::MVisit(const MString& visitNumber, const MString& patientID,
    const MString& issuerOfPatientID, const MString& patientClass,
    const MString& assignedPatientLocation, const MString& attendingDoctor,
    const MString& admitDate, const MString& admitTime,
    const MString& admittingDoctor, const MString& referringDoctor) :
  mVisitNumber(visitNumber),
  mPatientID(patientID),
  mIssuerOfPatientID(issuerOfPatientID),
  mPatientClass(patientClass),
  mAssignedPatientLocation(assignedPatientLocation),
  mAttendingDoctor(attendingDoctor),
  mAdmitDate(admitDate),
  mAdmitTime(admitTime),
  mAdmittingDoctor(admittingDoctor),
  mReferringDoctor(referringDoctor)
{
  tableName("visit");
  insert("visnum",visitNumber);
  insert("patid", patientID);
  insert("issuer", issuerOfPatientID);
  insert("patcla", patientClass);
  insert("asspatloc", assignedPatientLocation);
  insert("attdoc", attendingDoctor);
  insert("admdat", admitDate);
  insert("admtim", admitTime);
  insert("admdoc", admittingDoctor);
  insert("refdoc", referringDoctor);
}

void
MVisit::streamIn(istream& s)
{
  s >> mVisitNumber;
}

MString
MVisit::visitNumber() const
{
  return mVisitNumber;
}

MString
MVisit::patientID() const
{
  return mPatientID;
}

MString
MVisit::issuerOfPatientID() const
{
  return mIssuerOfPatientID;
}

MString
MVisit::patientClass() const
{
  return mPatientClass;
}

MString
MVisit::assignedPatientLocation() const
{
  return mAssignedPatientLocation;
}

MString
MVisit::attendingDoctor() const
{
  return mAttendingDoctor;
}

MString
MVisit::admitDate() const
{
  return mAdmitDate;
}

MString
MVisit::admitTime() const
{
  return mAdmitTime;
}

MString
MVisit::admittingDoctor() const
{
  return mAdmittingDoctor;
}

MString
MVisit::referringDoctor() const
{
  return mReferringDoctor;
}

void
MVisit::visitNumber(const MString& s)
{
  mVisitNumber = s;
  insert("visnum", s);
}

void
MVisit::patientID(const MString& s)
{
  mPatientID = s;
  insert("patid", s);
}

void
MVisit::issuerOfPatientID(const MString& s)
{
  mIssuerOfPatientID = s;
  insert("issuer", s);
}

void
MVisit::patientClass(const MString& s)
{
  mPatientClass = s;
  insert("patcla", s);
}

void
MVisit::assignedPatientLocation(const MString& s)
{
  mAssignedPatientLocation = s;
  insert("asspatloc", s);
}

void
MVisit::attendingDoctor(const MString& s)
{
  mAttendingDoctor = s;
  insert("attdoc", s);
}

void
MVisit::admitDate(const MString& s)
{
  mAdmitDate = s;
  insert("admdat", s);
}

void
MVisit::admitTime(const MString& s)
{
  mAdmitTime = s;
  insert("admtim", s);
}

void
MVisit::admittingDoctor(const MString& s)
{
  mAdmittingDoctor = s;
  insert("admdoc", s);
}

void
MVisit::referringDoctor(const MString& s)
{
  mReferringDoctor = s;
  insert("refdoc", s);
}

void
MVisit::import(MDomainObject& o)
{
  visitNumber(o.value("visnum"));
  patientID(o.value("patid"));
  issuerOfPatientID(o.value("issuer"));
  patientClass(o.value("patcla"));
  assignedPatientLocation(o.value("asspatloc"));
  attendingDoctor(o.value("attdoc"));
  admitDate(o.value("admdat"));
  admitTime(o.value("admtim"));
  admittingDoctor(o.value("admdoc"));
  referringDoctor(o.value("refdoc"));
}
