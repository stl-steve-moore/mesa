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

#include "MRequestedProcedure.hpp"

MRequestedProcedure::MRequestedProcedure()
{
  tableName("reqprocedure");
  insert("stuinsuid");
  insert("reqproid");
  insert("filordnum");
  insert("accnum");
  insert("quatim");
  insert("everea");
  insert("reqdattim");
  insert("spesou");
  insert("ordpro");
  insert("refdoc");
  insert("reqprodes");
  insert("reqprocod");
  insert("occnum");
  insert("apptimqua");
  insert("orderUID");
}

MRequestedProcedure::MRequestedProcedure(const MRequestedProcedure& cpy) :
  mStudyInstanceUID(cpy.mStudyInstanceUID),
  mRequestedProcedureID(cpy.mRequestedProcedureID),
  mFillerOrderNumber(cpy.mFillerOrderNumber),
  mAccessionNumber(cpy.mAccessionNumber),
  mQuantityTiming(cpy.mQuantityTiming),
  mEventReason(cpy.mEventReason),
  mRequestedDateTime(cpy.mRequestedDateTime),
  mSpecimenSource(cpy.mSpecimenSource),
  mOrderingProvider(cpy.mOrderingProvider),
  mReferringDoctor(cpy.mReferringDoctor),
  mRequestedProcedureDescription(cpy.mRequestedProcedureDescription),
  mRequestedProcedureCodeSeq(cpy.mRequestedProcedureCodeSeq),
  mOccurrenceNumber(cpy.mOccurrenceNumber),
  mAppointmentTimingQuantity(cpy.mAppointmentTimingQuantity),
  mOrderUID(cpy.mOrderUID)
{
  tableName("reqprocedure");
  insert("stuinsuid", cpy.mStudyInstanceUID);
  insert("reqproid", cpy.mRequestedProcedureID);
  insert("filordnum", cpy.mFillerOrderNumber);
  insert("accnum", cpy.mAccessionNumber);
  insert("quatim", cpy.mQuantityTiming);
  insert("everea", cpy.mEventReason);
  insert("reqdattim", cpy.mRequestedDateTime);
  insert("spesou", cpy.mSpecimenSource);
  insert("ordpro", cpy.mOrderingProvider);
  insert("refdoc", cpy.mReferringDoctor);
  insert("reqprodes", cpy.mRequestedProcedureDescription);
  insert("reqprocod", cpy.mRequestedProcedureCodeSeq);
  insert("occnum", cpy.mOccurrenceNumber);
  insert("apptimqua", cpy.mAppointmentTimingQuantity);
  insert("orduid", cpy.mOrderUID);
}

MRequestedProcedure::~MRequestedProcedure()
{
}

void
MRequestedProcedure::printOn(ostream& s) const
{
  s << "MRequestedProcedure:"
    << mStudyInstanceUID << ":"
    << mRequestedProcedureID << ":"
    << mFillerOrderNumber << ":"
    << mAccessionNumber << ":"
    << mQuantityTiming << ":"
    << mEventReason << ":"
    << mRequestedDateTime << ":"
    << mSpecimenSource << ":"
    << mOrderingProvider << ":"
    << mReferringDoctor << ":"
    << mRequestedProcedureDescription << ":"
    << mRequestedProcedureCodeSeq << ":"
    << mOccurrenceNumber << ":"
    << mAppointmentTimingQuantity << ":"
    << mOrderUID;
}

MRequestedProcedure::MRequestedProcedure(const MString& studyInstanceUID,
    const MString& requestedProcedureID, const MString& fillerOrderNumber,
    const MString& accessionNumber, const MString& quantityTiming,
    const MString& eventReason, const MString& requestedDateTime,
    const MString& specimenSource, const MString& orderingProvider,
    const MString& referringDoctor,
    const MString& requestedProcedureDescription, const MString& requestedProcedureCodeSeq,
    const MString& occurrenceNumber, const MString& appointmentTimingQuantity,
    const MString& orderUID)  :
  mStudyInstanceUID(studyInstanceUID),
  mRequestedProcedureID(requestedProcedureID),
  mFillerOrderNumber(fillerOrderNumber),
  mAccessionNumber(accessionNumber),
  mQuantityTiming(quantityTiming),
  mEventReason(eventReason),
  mRequestedDateTime(requestedDateTime),
  mSpecimenSource(specimenSource),
  mOrderingProvider(orderingProvider),
  mReferringDoctor(referringDoctor),
  mRequestedProcedureDescription(requestedProcedureDescription),
  mRequestedProcedureCodeSeq(requestedProcedureCodeSeq),
  mOccurrenceNumber(occurrenceNumber),
  mAppointmentTimingQuantity(appointmentTimingQuantity),
  mOrderUID(orderUID)
{
  tableName("reqprocedure");
  insert("stuinsuid", studyInstanceUID);
  insert("reqproid", requestedProcedureID);
  insert("filordnum", fillerOrderNumber);
  insert("accnum", accessionNumber);
  insert("quatim", quantityTiming);
  insert("everea", eventReason);
  insert("reqdattim", requestedDateTime);
  insert("spesou", specimenSource);
  insert("ordpro", orderingProvider);
  insert("refdoc", referringDoctor);
  insert("reqprodes", requestedProcedureDescription);
  insert("reqprocod", requestedProcedureCodeSeq);
  insert("occnum", occurrenceNumber);
  insert("apptimqua", appointmentTimingQuantity);
  insert("orduid", orderUID);
}

void
MRequestedProcedure::streamIn(istream& s)
{
  //s >> this->member;
}

MString
MRequestedProcedure::studyInstanceUID() const
{
   return mStudyInstanceUID;
}

MString
MRequestedProcedure::requestedProcedureID() const
{
   return mRequestedProcedureID;
}

MString
MRequestedProcedure::fillerOrderNumber() const
{
   return mFillerOrderNumber;
}

MString
MRequestedProcedure::accessionNumber() const
{
   return mAccessionNumber;
}

MString
MRequestedProcedure::quantityTiming() const
{
   return mQuantityTiming;
}

MString
MRequestedProcedure::eventReason() const
{
   return mEventReason;
}

MString
MRequestedProcedure::requestedDateTime() const
{
   return mRequestedDateTime;
}

MString
MRequestedProcedure::specimenSource() const
{
   return mSpecimenSource;
}

MString
MRequestedProcedure::orderingProvider() const
{
   return mOrderingProvider;
}

MString
MRequestedProcedure::referringDoctor() const
{
   return mReferringDoctor;
}

MString
MRequestedProcedure::requestedProcedureDescription() const
{
   return mRequestedProcedureDescription;
}

MString
MRequestedProcedure::requestedProcedureCodeSeq() const
{
   return mRequestedProcedureCodeSeq;
}

MString
MRequestedProcedure::occurrenceNumber() const
{
   return mOccurrenceNumber;
}

MString
MRequestedProcedure::appointmentTimingQuantity() const
{
   return mAppointmentTimingQuantity;
}

MString
MRequestedProcedure::orderUID() const
{
   return mOrderUID;
}

void
MRequestedProcedure::studyInstanceUID(const MString& s)
{
   mStudyInstanceUID = s;
   insert("stuinsuid", s);
}

void
MRequestedProcedure::requestedProcedureID(const MString& s)
{
   mRequestedProcedureID = s;
   insert("reqproid", s);
}

void
MRequestedProcedure::fillerOrderNumber(const MString& s)
{
   mFillerOrderNumber = s;
   insert("filordnum", s);
}

void
MRequestedProcedure::accessionNumber(const MString& s)
{
   mAccessionNumber = s;
   insert("accnum", s);
}

void
MRequestedProcedure::quantityTiming(const MString& s)
{
   mQuantityTiming = s;
   insert("quatim", s);
}

void
MRequestedProcedure::eventReason(const MString& s)
{
   mEventReason = s;
   insert("everea", s);
}

void
MRequestedProcedure::requestedDateTime(const MString& s)
{
   mRequestedDateTime = s;
   insert("reqdattim", s);
}

void
MRequestedProcedure::specimenSource(const MString& s)
{
   mSpecimenSource = s;
   insert("spesou", s);
}

void
MRequestedProcedure::orderingProvider(const MString& s)
{
   mOrderingProvider = s;
   insert("ordpro", s);
}

void
MRequestedProcedure::referringDoctor(const MString& s)
{
   mReferringDoctor = s;
   insert("refdoc", s);
}

void
MRequestedProcedure::requestedProcedureDescription(const MString& s)
{
   mRequestedProcedureDescription = s;
   insert("reqprodes", s);
}

void
MRequestedProcedure::requestedProcedureCodeSeq(const MString& s)
{
   mRequestedProcedureCodeSeq = s;
   insert("reqprocod", s);
}

void
MRequestedProcedure::occurrenceNumber(const MString& s)
{
   mOccurrenceNumber = s;
   insert("occnum", s);
}

void
MRequestedProcedure::appointmentTimingQuantity(const MString& s)
{
   mAppointmentTimingQuantity = s;
   insert("apptimqua", s);
}

void
MRequestedProcedure::orderUID(const MString& s)
{
   mOrderUID = s;
   insert("orduid", s);
}
