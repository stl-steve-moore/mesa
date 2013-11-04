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

#include "MMWL.hpp"

MMWL::MMWL()
{
  tableName("mwl");
  //Requested Procedure
  insert("stuinsuid");
  insert("refstusopcla");
  insert("refstusopins");
  insert("reqproid");
  insert("plaordnum");
  insert("filordnum");
  insert("accnum");
  insert("quatim");
  insert("everea");
  insert("reqdattim");
  insert("spesou");
  insert("ordpro");
  insert("reqprodes");
  insert("reqprocod");
  insert("occnum");
  insert("apptimqua");
  insert("orduid");
  //Requested Procedure Code Item
  insert("codval");
  insert("codmea");
  insert("codschdes");
  //SPS
  insert("spsid");
  insert("spsindex");
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
  insert("spssta");
  // Imaging Service Request
  insert("reqphynam");
  insert("refphynam");
  //Patient
  insert("patid");
  insert("issuer");
  insert("patid2");
  insert("issuer2");
  insert("nam");
  insert("datbir");
  insert("sex");
  //Patient Medical
  insert("pregstat");
  insert("curpatloc", mCurrentPatientLocation);
  insert("admid", mAdmissionID);
}

MMWL::MMWL(const MMWL& cpy) :
  mStudyInstanceUID(cpy.mStudyInstanceUID),
  mReferencedStudySOPClass(cpy.mReferencedStudySOPClass),
  mReferencedStudySOPInstance(cpy.mReferencedStudySOPInstance),
  mRequestedProcedureID(cpy.mRequestedProcedureID),
  mPlacerOrderNumber(cpy.mPlacerOrderNumber),
  mFillerOrderNumber(cpy.mFillerOrderNumber),
  mAccessionNumber(cpy.mAccessionNumber),
  mQuantityTiming(cpy.mQuantityTiming),
  mEventReason(cpy.mEventReason),
  mRequestedDateTime(cpy.mRequestedDateTime),
  mSpecimenSource(cpy.mSpecimenSource),
  mOrderingProvider(cpy.mOrderingProvider),
  mRequestedProcedureDescription(cpy.mRequestedProcedureDescription),
  mRequestedProcedureCodeSeq(cpy.mRequestedProcedureCodeSeq),
  mOccurrenceNumber(cpy.mOccurrenceNumber),
  mAppointmentTimingQuantity(cpy.mAppointmentTimingQuantity),
  mOrderUID(cpy.mOrderUID),
  //Requested Procedure Code Item
  mCodeValue(cpy.mCodeValue),
  mCodeMeaning(cpy.mCodeMeaning),
  mCodeSchemeDesignator(cpy.mCodeSchemeDesignator),
  //SPS
  mScheduledProcedureStepID(cpy.mScheduledProcedureStepID),
  mSPSIndex(cpy.mSPSIndex),
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
  mSPSStatus(cpy.mSPSStatus),
  // Imaging Service Request
  mRequestingPhysicianName(cpy.mRequestingPhysicianName),
  mReferringPhysicianName(cpy.mReferringPhysicianName),
  //Patient
  mPatientID(cpy.mPatientID),
  mIssuerOfPatientID(cpy.mIssuerOfPatientID),
  mPatientID2(cpy.mPatientID2),
  mIssuerOfPatientID2(cpy.mIssuerOfPatientID2),
  mPatientName(cpy.mPatientName),
  mDateOfBirth(cpy.mDateOfBirth),
  mPatientSex(cpy.mPatientSex),
  mPregnancyStatus(cpy.mPregnancyStatus),
  mCurrentPatientLocation(cpy.mCurrentPatientLocation),
  mAdmissionID(cpy.mAdmissionID)
{
  tableName("mwl");
  //Requested Procedure
  insert("stuinsuid", mStudyInstanceUID);
  insert("refstusopcla", mReferencedStudySOPClass);
  insert("refstusopins", mReferencedStudySOPInstance);
  insert("reqproid", mRequestedProcedureID);
  insert("plaordnum", mPlacerOrderNumber);
  insert("filordnum", mFillerOrderNumber);
  insert("accnum", mAccessionNumber);
  insert("quatim", mQuantityTiming);
  insert("everea", mEventReason);
  insert("reqdattim", mRequestedDateTime);
  insert("spesou", mSpecimenSource);
  insert("ordpro", mOrderingProvider);
  insert("reqprodes", mRequestedProcedureDescription);
  insert("reqprocod", mRequestedProcedureCodeSeq);
  insert("occnum", mOccurrenceNumber);
  insert("apptimqua", mAppointmentTimingQuantity);
  insert("orduid", mOrderUID);
  //Requested Procedure Code Item
  insert("codval", mCodeValue);
  insert("codmea", mCodeMeaning);
  insert("codschdes", mCodeSchemeDesignator);
  //SPS
  insert("spsid", mScheduledProcedureStepID);
  insert("spsindex", mSPSIndex);
  insert("schaet", mScheduledAETitle);
  insert("spsstadat", mSPSStartDate);
  insert("spsstatim", mSPSStartTime);
  insert("mod", mModality);
  insert("schperphynam", mScheduledPerformingPhysicianName);
  insert("spsdes", mSPSDescription);
  insert("spsloc", mSPSLocation);
  insert("premed", mPreMedication);
  insert("reqconage", mRequestedContrastAgent);
  insert("schstanam", mScheduledStationName);
  insert("spssta", mSPSStatus);
  // Imaging Service Request
  insert("reqphynam", mRequestingPhysicianName);
  insert("refphynam", mReferringPhysicianName);
  //Patient
  insert("patid", mPatientID);
  insert("issuer", mIssuerOfPatientID);
  insert("patid2", mPatientID2);
  insert("issuer2", mIssuerOfPatientID2);
  insert("nam", mPatientName);
  insert("datbir", mDateOfBirth);
  insert("sex", mPatientSex);
  insert("pregstat", mPregnancyStatus);
  insert("curpatloc", mCurrentPatientLocation);
  insert("admid", mAdmissionID);
}

MMWL::~MMWL()
{
}

void
MMWL::printOn(ostream& s) const
{
  s << "MMWL:\n" <<
    "Requested Procedure:\n"
    << mStudyInstanceUID << ":"
    << mReferencedStudySOPClass << ":"
    << mReferencedStudySOPInstance << ":"
    << mRequestedProcedureID << ":"
    << mPlacerOrderNumber << ":"
    << mFillerOrderNumber << ":"
    << mAccessionNumber << ":"
    << mQuantityTiming << ":"
    << mEventReason << ":"
    << mRequestedDateTime << ":"
    << mSpecimenSource << ":"
    << mOrderingProvider << ":"
    << mRequestedProcedureDescription << ":"
    << mRequestedProcedureCodeSeq << ":"
    << mOccurrenceNumber << ":"
    << mAppointmentTimingQuantity << ":"
    << mOrderUID << "\n" <<
    "Requested Procedure Code Item:\n"
    << mCodeValue << ":"
    << mCodeMeaning << ":"
    << mCodeSchemeDesignator << "\n"
    "SPS:\n" 
    << mScheduledProcedureStepID << ":"
    << mSPSIndex << ":"
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
    << mSPSStatus << "\n" <<
    "Imaging Service Request: \n"
    << mRequestingPhysicianName
    << mReferringPhysicianName << endl <<
    "Patient: \n"
    << mPatientID << ":"
    << mIssuerOfPatientID << ":"
    << mPatientID2 << ":"
    << mIssuerOfPatientID2 << ":"
    << mPatientName << ":"
    << mDateOfBirth << ":"
    << mPatientSex << ":"
    << mPregnancyStatus << ":"
    << mCurrentPatientLocation << ":"
    << mAdmissionID;
}

MMWL::MMWL(const MString& studyInstanceUID,
	   const MString& referencedStudySOPClass,
	   const MString& referencedStudySOPInstance,
	   const MString& requestedProcedureID,
	   const MString& placerOrderNumber,
	   const MString& fillerOrderNumber,
	   const MString& accessionNumber, const MString& quantityTiming,
	   const MString& eventReason, const MString& requestedDateTime,
	   const MString& specimenSource, const MString& orderingProvider,
	   const MString& requestedProcedureDescription, const MString& requestedProcedureCodeSeq,
	   const MString& occurrenceNumber, const MString& appointmentTimingQuantity,
	   const MString& orderUID,
	   const MString& codeValue, const MString& codeMeaning, const MString& codeSchemeDesignator,
	   const MString& scheduledProcedureStepID,
	   const MString& spsIndex,
	   const MString& scheduledAETitle,
	   const MString& sPSStartDate, const MString& sPSStartTime,
	   const MString& modality, const MString& scheduledPerformingPhysicianName,
	   const MString& sPSDescription, const MString& sPSLocation,
	   const MString& preMedication, const MString& requestedContrastAgent,
	   const MString& scheduledStationName,
	   const MString& sPSStatus,
	   const MString& requestingPhysicianName,
	   const MString& referringPhysicianName,
	   const MString& patientID, const MString& issuerOfPatientID,
	   const MString& patientID2, const MString& issuerOfPatientID2,
	   const MString& patientName, const MString& dateOfBirth,
	   const MString& patientSex,
	   const MString& pregnancyStatus,
	   const MString& currentPatientLocation,
	   const MString& admissionID)  :
  mStudyInstanceUID(studyInstanceUID),
  mReferencedStudySOPClass(referencedStudySOPClass),
  mReferencedStudySOPInstance(referencedStudySOPInstance),
  mRequestedProcedureID(requestedProcedureID),
  mPlacerOrderNumber(placerOrderNumber),
  mFillerOrderNumber(fillerOrderNumber),
  mAccessionNumber(accessionNumber),
  mQuantityTiming(quantityTiming),
  mEventReason(eventReason),
  mRequestedDateTime(requestedDateTime),
  mSpecimenSource(specimenSource),
  mOrderingProvider(orderingProvider),
  mRequestedProcedureDescription(requestedProcedureDescription),
  mRequestedProcedureCodeSeq(requestedProcedureCodeSeq),
  mOccurrenceNumber(occurrenceNumber),
  mAppointmentTimingQuantity(appointmentTimingQuantity),
  mOrderUID(orderUID),
  //Requested Procedure Code Item
  mCodeValue(codeValue),
  mCodeMeaning(codeMeaning),
  mCodeSchemeDesignator(codeSchemeDesignator),
  //SPS
  mScheduledProcedureStepID(scheduledProcedureStepID),
  mSPSIndex(spsIndex),
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
  mSPSStatus(sPSStatus),
  // Imaging Service Request
  mRequestingPhysicianName(requestingPhysicianName),
  mReferringPhysicianName(referringPhysicianName),
  //Patient
  mPatientID(patientID),
  mIssuerOfPatientID(issuerOfPatientID),
  mPatientID2(patientID2),
  mIssuerOfPatientID2(issuerOfPatientID2),
  mPatientName(patientName),
  mDateOfBirth(dateOfBirth),
  mPatientSex(patientSex),
  mPregnancyStatus(pregnancyStatus),
  mCurrentPatientLocation(currentPatientLocation),
  mAdmissionID(admissionID)

{
  tableName("mwl");
  //Requested Procedure
  insert("stuinsuid", studyInstanceUID);
  insert("refstusopcla", referencedStudySOPClass);
  insert("refstusopins", referencedStudySOPInstance);
  insert("reqproid", requestedProcedureID);
  insert("plaordnum", placerOrderNumber);
  insert("filordnum", fillerOrderNumber);
  insert("accnum", accessionNumber);
  insert("quatim", quantityTiming);
  insert("everea", eventReason);
  insert("reqdattim", requestedDateTime);
  insert("spesou", specimenSource);
  insert("ordpro", orderingProvider);
  insert("reqprodes", requestedProcedureDescription);
  insert("reqprocod", requestedProcedureCodeSeq);
  insert("occnum", occurrenceNumber);
  insert("apptimqua", appointmentTimingQuantity);
  insert("orduid", orderUID);
  //Requested Procedure Code Item
  insert("codval", codeValue);
  insert("codmea", codeMeaning);
  insert("codschdes", codeSchemeDesignator);
  //SPS
  insert("spsid", scheduledProcedureStepID);
  insert("spsindex", spsIndex);
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
  insert("spssta", sPSStatus);
  // Imaging Service Request
  //Patient
  insert("reqphynam", requestingPhysicianName);
  insert("refphynam", referringPhysicianName);
  insert("patid", patientID);
  insert("issuer", issuerOfPatientID);
  insert("patid2", patientID2);
  insert("issuer2", issuerOfPatientID2);
  insert("nam", patientName);
  insert("datbir", dateOfBirth);
  insert("sex", patientSex);
  insert("pregstat", pregnancyStatus);
  // Visit Identification
  insert("admid", admissionID);
  // Visit Status
  insert("curpatloc", currentPatientLocation);
}

void
MMWL::streamIn(istream& s)
{
  //s >> this->member;
}

//Requested Procedure
MString
MMWL::studyInstanceUID() const
{
   return mStudyInstanceUID;
}

MString
MMWL::referencedStudySOPClass() const
{
   return mReferencedStudySOPClass;
}

MString
MMWL::referencedStudySOPInstance() const
{
   return mReferencedStudySOPInstance;
}

MString
MMWL::requestedProcedureID() const
{
   return mRequestedProcedureID;
}

MString
MMWL::placerOrderNumber() const
{
   return mPlacerOrderNumber;
}


MString
MMWL::fillerOrderNumber() const
{
   return mFillerOrderNumber;
}

MString
MMWL::accessionNumber() const
{
   return mAccessionNumber;
}

MString
MMWL::quantityTiming() const
{
   return mQuantityTiming;
}

MString
MMWL::eventReason() const
{
   return mEventReason;
}

MString
MMWL::requestedDateTime() const
{
   return mRequestedDateTime;
}

MString
MMWL::specimenSource() const
{
   return mSpecimenSource;
}

MString
MMWL::orderingProvider() const
{
   return mOrderingProvider;
}

MString
MMWL::requestedProcedureDescription() const
{
   return mRequestedProcedureDescription;
}

MString
MMWL::requestedProcedureCodeSeq() const
{
   return mRequestedProcedureCodeSeq;
}

MString
MMWL::occurrenceNumber() const
{
   return mOccurrenceNumber;
}

MString
MMWL::appointmentTimingQuantity() const
{
   return mAppointmentTimingQuantity;
}

MString
MMWL::orderUID() const
{
   return mOrderUID;
}

//Requested Procedure Code Item
MString
MMWL::codeValue() const
{
  return mCodeValue;
}

MString
MMWL::codeMeaning() const
{
  return mCodeMeaning;
}

MString
MMWL::codeSchemeDesignator() const
{
  return mCodeSchemeDesignator;
}

//SPS
MString
MMWL::scheduledProcedureStepID() const
{
  return mScheduledProcedureStepID;
}

MString
MMWL::spsIndex() const
{
  return mSPSIndex;
}

MString
MMWL::scheduledAETitle() const
{
  return mScheduledAETitle;
}

MString
MMWL::sPSStartDate() const
{
  return mSPSStartDate;
}

MString
MMWL::sPSStartTime() const
{
  return mSPSStartTime;
}

MString
MMWL::modality() const
{
  return mModality;
}

MString
MMWL::scheduledPerformingPhysicianName() const
{
  return mScheduledPerformingPhysicianName;
}

MString
MMWL::sPSDescription() const
{
  return mSPSDescription;
}

MString
MMWL::sPSLocation() const
{
  return mSPSLocation;
}

MString
MMWL::preMedication() const
{
  return mPreMedication;
}

MString
MMWL::requestedContrastAgent() const
{
  return mRequestedContrastAgent;
}

MString
MMWL::scheduledStationName() const
{
  return mRequestedContrastAgent;
}

MString
MMWL::sPSStatus() const
{
  return mSPSStatus;
}

// Imaging Service Request
MString
MMWL::requestingPhysicianName() const
{
  return mRequestingPhysicianName;
}

MString
MMWL::referringPhysicianName() const
{
  return mReferringPhysicianName;
}

//Patient
MString
MMWL::patientID() const
{
  return mPatientID;
}

MString
MMWL::issuerOfPatientID() const
{
  return mIssuerOfPatientID;
}

MString
MMWL::patientID2() const
{
  return mPatientID2;
}

MString
MMWL::issuerOfPatientID2() const
{
  return mIssuerOfPatientID2;
}

MString
MMWL::patientName() const
{
  return mPatientName;
}

MString
MMWL::dateOfBirth() const
{
  return mDateOfBirth;
}

MString
MMWL::patientSex() const
{
  return mPatientSex;
}

// Patient Medical
MString
MMWL::pregnancyStatus() const
{
  return mPregnancyStatus;
}

// Visit Identification
MString
MMWL::admissionID() const
{
  return mAdmissionID;
}

// Visit Status
MString
MMWL::currentPatientLocation() const
{
  return mCurrentPatientLocation;
}

//Requested Procedure
void
MMWL::studyInstanceUID(const MString& s)
{
   mStudyInstanceUID = s;
   insert("stuinsuid", s);
}

void
MMWL::referencedStudySOPClass(const MString& s)
{
   mReferencedStudySOPClass = s;
   insert("refstusopcla", s);
}

void
MMWL::referencedStudySOPInstance(const MString& s)
{
   mReferencedStudySOPInstance = s;
   insert("refstusopins", s);
}

void
MMWL::requestedProcedureID(const MString& s)
{
   mRequestedProcedureID = s;
   insert("reqproid", s);
}

void
MMWL::placerOrderNumber(const MString& s)
{
   mPlacerOrderNumber = s;
   insert("plaordnum", s);
}

void
MMWL::fillerOrderNumber(const MString& s)
{
   mFillerOrderNumber = s;
   insert("filordnum", s);
}

void
MMWL::accessionNumber(const MString& s)
{
   mAccessionNumber = s;
   insert("accnum", s);
}

void
MMWL::quantityTiming(const MString& s)
{
   mQuantityTiming = s;
   insert("quatim", s);
}

void
MMWL::eventReason(const MString& s)
{
   mEventReason = s;
   insert("everea", s);
}

void
MMWL::requestedDateTime(const MString& s)
{
   mRequestedDateTime = s;
   insert("reqdattim", s);
}

void
MMWL::specimenSource(const MString& s)
{
   mSpecimenSource = s;
   insert("spesou", s);
}

void
MMWL::orderingProvider(const MString& s)
{
   mOrderingProvider = s;
   insert("ordpro", s);
}

void
MMWL::requestedProcedureDescription(const MString& s)
{
   mRequestedProcedureDescription = s;
   insert("reqprodes", s);
}

void
MMWL::requestedProcedureCodeSeq(const MString& s)
{
   mRequestedProcedureCodeSeq = s;
   insert("reqprocod", s);
}

void
MMWL::occurrenceNumber(const MString& s)
{
   mOccurrenceNumber = s;
   insert("occnum", s);
}

void
MMWL::appointmentTimingQuantity(const MString& s)
{
   mAppointmentTimingQuantity = s;
   insert("apptimqua", s);
}

void
MMWL::orderUID(const MString& s)
{
   mOrderUID = s;
   insert("orduid", s);
}

//Requested Procedure Code Item
void
MMWL::codeValue(const MString& s)
{
  mCodeValue = s;
  insert("codval", s);
}

void
MMWL::codeMeaning(const MString& s)
{
  mCodeMeaning = s;
  insert("codmea", s);
}

void
MMWL::codeSchemeDesignator(const MString& s)
{
  mCodeSchemeDesignator = s;
  insert("codschdes", s);
}

//SPS
void
MMWL::scheduledProcedureStepID(const MString& s)
{
  mScheduledProcedureStepID = s;
  insert("spsid", s);
}

void
MMWL::spsIndex(const MString& s)
{
  mSPSIndex = s;
  insert("spsindex", s);
}

void
MMWL::scheduledAETitle(const MString& s)
{
  mScheduledAETitle = s;
  insert("schaet", s);
}

void
MMWL::sPSStartDate(const MString& s)
{
  mSPSStartDate = s;
  insert("spsstadat", s);
}

void
MMWL::sPSStartTime(const MString& s)
{
  mSPSStartTime = s;
  insert("spsstatim", s);
}

void
MMWL::modality(const MString& s)
{
  mModality = s;
  insert("mod", s);
}

void
MMWL::scheduledPerformingPhysicianName(const MString& s)
{
  mScheduledPerformingPhysicianName = s;
  insert("schperphynam", s);
}

void
MMWL::sPSDescription(const MString& s)
{
  mSPSDescription = s;
  insert("spsdes", s);
}

void
MMWL::sPSLocation(const MString& s)
{
  mSPSLocation = s;
  insert("spsloc", s);
}

void
MMWL::preMedication(const MString& s)
{
  mPreMedication = s;
  insert("premed", s);
}

void
MMWL::requestedContrastAgent(const MString& s)
{
  mRequestedContrastAgent = s;
  insert("reqconage", s);
}

void
MMWL::scheduledStationName(const MString& s)
{
  mScheduledStationName = s;
  insert("schstanam", s);
}

void
MMWL::sPSStatus(const MString& s)
{
  mSPSStatus = s;
  insert("spssta", s);
}

// Imaging Service Request
void
MMWL::requestingPhysicianName(const MString& s)
{
  mRequestingPhysicianName = s;
  insert("reqphynam", s);
}

void
MMWL::referringPhysicianName(const MString& s)
{
  mReferringPhysicianName = s;
  insert("refphynam", s);
}


//Patient
void
MMWL::patientID(const MString& s)
{
  mPatientID = s;
  insert("patid", s);
}

void
MMWL::issuerOfPatientID(const MString& s)
{
  mIssuerOfPatientID = s;
  insert("issuer", s);
}

void
MMWL::patientID2(const MString& s)
{
  mPatientID2 = s;
  insert("patid2", s);
}

void
MMWL::issuerOfPatientID2(const MString& s)
{
  mIssuerOfPatientID2 = s;
  insert("issuer2", s);
}

void
MMWL::patientName(const MString& s)
{
  mPatientName = s;
  insert("nam", s);
}

void
MMWL::dateOfBirth(const MString& s)
{
  mDateOfBirth = s;
  insert("datbir", s);
}

void
MMWL::patientSex(const MString& s)
{
  mPatientSex = s;
  insert("sex", s);
}

// Patient Medical
void
MMWL::pregnancyStatus(const MString& s)
{
  mPregnancyStatus = s;
  insert("pregstat", s);
}

// Visit Identification
void
MMWL::admissionID(const MString& s)
{
  mAdmissionID = s;
  insert("admid", s);
}

// Visit Status
void
MMWL::currentPatientLocation(const MString& s)
{
  mCurrentPatientLocation = s;
  insert("curpatloc", s);
}

void MMWL::import(const MDomainObject& o)
{
  //Requested Procedure
  requestedProcedureID(o.value("reqproid"));
  codeValue(o.value("codval"));
  codeMeaning(o.value("codmea"));
  codeSchemeDesignator(o.value("codschdes"));
  studyInstanceUID(o.value("stuinsuid"));
  referencedStudySOPClass(o.value("refstusopcla"));
  referencedStudySOPInstance(o.value("refstusopins"));

  // Imaging Service Request
  placerOrderNumber(o.value("plaordnum"));
  fillerOrderNumber(o.value("filordnum"));
  accessionNumber(o.value("accnum"));
  quantityTiming(o.value("quatim"));
  eventReason(o.value("everea"));
  requestedDateTime(o.value("reqdattim"));
  specimenSource(o.value("spesou"));
  orderingProvider(o.value("ordpro"));
  requestedProcedureDescription(o.value("reqprodes"));
  requestedProcedureCodeSeq(o.value("reqprocodseq"));
  occurrenceNumber(o.value("occnum"));
  appointmentTimingQuantity(o.value("apptimqua"));
  orderUID(o.value("orduid"));
  //SPS
  scheduledProcedureStepID(o.value("spsid"));
  spsIndex(o.value("spsindex"));
  scheduledAETitle(o.value("schaet"));
  sPSStartDate(o.value("spsstadat"));
  sPSStartTime(o.value("spsstatim"));
  modality(o.value("mod"));
  scheduledPerformingPhysicianName(o.value("schperphynam"));
  sPSDescription(o.value("spsdes"));
  sPSLocation(o.value("spsloc"));
  preMedication(o.value("premed"));
  requestedContrastAgent(o.value("reqconage"));
  scheduledStationName(o.value("schstanam"));
  sPSStatus(o.value("spssta"));
  // Imaging Service Request
  requestingPhysicianName(o.value("reqphynam"));
  referringPhysicianName(o.value("refphynam"));
  //Patient
  patientID(o.value("patid"));
  issuerOfPatientID(o.value("issuer"));
  patientID2(o.value("patid2"));
  issuerOfPatientID2(o.value("issuer2"));
  patientName(o.value("nam"));
  dateOfBirth(o.value("datbir"));
  patientSex(o.value("sex"));

  // Patient Medical
  pregnancyStatus(o.value("pregstat"));

  // Visit Identification
  admissionID(o.value("admid"));

  // Visit Status
  currentPatientLocation(o.value("curpatloc"));
}
