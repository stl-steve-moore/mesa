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

#include "MUPS.hpp"

MUPS::MUPS()
{
  tableName("ups");
  insert("id");
  // SOP Common
  insert("specharset");
  insert("sopclauid");
  insert("sopinsuid");

  // Unified Procedure Step Scheduled Procedure Information
  insert("spspri");
  insert("spsmoddattim");
  insert("prostelbl");
  insert("worlbl");
  insert("spsstadattim");
  insert("expcomdattim");
  insert("stuinsuid");

  // Unified Procedure Step Relationship Module
  insert("nam");
  insert("patid");
  insert("issuer");
  insert("datbir");
  insert("sex");
  insert("admid");
  insert("admdiagdes");
  insert("upsstate");

  //Requested Procedure
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
  insert("patid2");
  insert("issuer2");
  //Patient Medical
  insert("pregstat");
  insert("curpatloc", mCurrentPatientLocation);
}

MUPS::MUPS(const MUPS& cpy) :
  mSpecificCharacterSet(cpy.mSpecificCharacterSet),
  mSOPClassUID(cpy.mSOPClassUID),
  mSOPInstanceUID(cpy.mSOPInstanceUID),
  mSPSPriority(cpy.mSPSPriority),
  mSPSModificationDateTime(cpy.mSPSModificationDateTime),
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
  mPatientID2(cpy.mPatientID2),
  mIssuerOfPatientID2(cpy.mIssuerOfPatientID2),
  mPregnancyStatus(cpy.mPregnancyStatus),
  mCurrentPatientLocation(cpy.mCurrentPatientLocation)
{
  tableName("ups");
  insert("id", cpy.value("id"));
  //Requested Procedure
  insert("specharset", mSpecificCharacterSet);
  insert("sopclauid", mSOPClassUID);
  insert("sopinsuid", mSOPInstanceUID);
  insert("spspri", mSPSPriority);
  insert("spsmoddattim", mSPSModificationDateTime);
  insert("prostelbl", cpy.value("prostelbl"));
  insert("worlbl", cpy.value("worlbl"));
  insert("spsstadattim", cpy.value("spsstadattim"));
  insert("expcomdattim", cpy.value("expcomdattim"));

  insert("stuinsuid",  cpy.value("stuinsuid"));
  insert("nam",        cpy.value("nam"));
  insert("patid" ,     cpy.value("patid"));
  insert("issuer",     cpy.value("issuer"));
  insert("datbir",     cpy.value("datbir"));
  insert("sex",        cpy.value("sex"));
  insert("admid",      cpy.value("admid"));
  insert("admdiagdes", cpy.value("admdiagdes"));
  insert("upsstate",   cpy.value("upsstate"));

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
  insert("patid2", mPatientID2);
  insert("issuer2", mIssuerOfPatientID2);
  insert("pregstat", mPregnancyStatus);
  insert("curpatloc", mCurrentPatientLocation);
}

MUPS::~MUPS()
{
}

void
MUPS::printOn(ostream& s) const
{
  s << "MUPS:\n" <<
    "Requested Procedure:\n"
    << this->value("stuinsuid") << ":"
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
    << this->value("patid") << ":"
    << this->value("issuer") << ":"
    << mPatientID2 << ":"
    << mIssuerOfPatientID2 << ":"
    << this->value("nam") << ":"
    << this->value("datbir") << ":"
    << this->value("sex") << ":"
    << mPregnancyStatus << ":"
    << mCurrentPatientLocation << ":"
    << this->value("admid");
}

MUPS::MUPS(const MString& studyInstanceUID,
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
  mPatientID2(patientID2),
  mIssuerOfPatientID2(issuerOfPatientID2),
  mPregnancyStatus(pregnancyStatus),
  mCurrentPatientLocation(currentPatientLocation)

{
  tableName("ups");
  //Requested Procedure
  insert("stuinsuid", studyInstanceUID);

  // Unified Procedure Step Relationship Module
  insert("nam", patientName);
  insert("patid", patientID);
  insert("issuer", issuerOfPatientID);
  insert("datbir", dateOfBirth);
  insert("sex", patientSex);
  insert("admid", admissionID);

  // Unified Procedure Step Progress Information Module

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
  insert("patid2", patientID2);
  insert("issuer2", issuerOfPatientID2);
  insert("pregstat", pregnancyStatus);
  // Visit Identification
  // Visit Status
  insert("curpatloc", currentPatientLocation);
}

void
MUPS::streamIn(istream& s)
{
  //s >> this->member;
}

// SOP Common
void
MUPS::specificCharacterSet(const MString& s)
{
  mSpecificCharacterSet = s;
  insert("specharset", s);
}

void
MUPS::SOPClassUID(const MString& s)
{
  mSOPClassUID = s;
  insert("sopclauid", s);
}

void
MUPS::SOPInstanceUID(const MString& s)
{
  mSOPInstanceUID = s;
  insert("sopinsuid", s);
}

void
MUPS::scheduledProcedureStepPriority(const MString& s)
{
  mSPSPriority = s;
  insert("spspri", s);
}

void
MUPS::scheduledProcedureStepModDateTime(const MString& s)
{
  mSPSModificationDateTime = s;
  insert("spsmoddattim", s);
}

MString
MUPS::id() const
{
  cout << "UPS id" << this->value("id");
   return this->value("id");
}


//Requested Procedure
MString
MUPS::studyInstanceUID() const
{
   return this->value("stuinsuid");
}

MString
MUPS::referencedStudySOPClass() const
{
   return mReferencedStudySOPClass;
}

MString
MUPS::referencedStudySOPInstance() const
{
   return mReferencedStudySOPInstance;
}

MString
MUPS::requestedProcedureID() const
{
   return mRequestedProcedureID;
}

MString
MUPS::placerOrderNumber() const
{
   return mPlacerOrderNumber;
}


MString
MUPS::fillerOrderNumber() const
{
   return mFillerOrderNumber;
}

MString
MUPS::accessionNumber() const
{
   return mAccessionNumber;
}

MString
MUPS::quantityTiming() const
{
   return mQuantityTiming;
}

MString
MUPS::eventReason() const
{
   return mEventReason;
}

MString
MUPS::requestedDateTime() const
{
   return mRequestedDateTime;
}

MString
MUPS::specimenSource() const
{
   return mSpecimenSource;
}

MString
MUPS::orderingProvider() const
{
   return mOrderingProvider;
}

MString
MUPS::requestedProcedureDescription() const
{
   return mRequestedProcedureDescription;
}

MString
MUPS::requestedProcedureCodeSeq() const
{
   return mRequestedProcedureCodeSeq;
}

MString
MUPS::occurrenceNumber() const
{
   return mOccurrenceNumber;
}

MString
MUPS::appointmentTimingQuantity() const
{
   return mAppointmentTimingQuantity;
}

MString
MUPS::orderUID() const
{
   return mOrderUID;
}

//Requested Procedure Code Item
MString
MUPS::codeValue() const
{
  return mCodeValue;
}

MString
MUPS::codeMeaning() const
{
  return mCodeMeaning;
}

MString
MUPS::codeSchemeDesignator() const
{
  return mCodeSchemeDesignator;
}

//SPS
MString
MUPS::scheduledProcedureStepID() const
{
  return mScheduledProcedureStepID;
}

MString
MUPS::spsIndex() const
{
  return mSPSIndex;
}

MString
MUPS::scheduledAETitle() const
{
  return mScheduledAETitle;
}

MString
MUPS::sPSStartDate() const
{
  return mSPSStartDate;
}

MString
MUPS::sPSStartTime() const
{
  return mSPSStartTime;
}

MString
MUPS::modality() const
{
  return mModality;
}

MString
MUPS::scheduledPerformingPhysicianName() const
{
  return mScheduledPerformingPhysicianName;
}

MString
MUPS::sPSDescription() const
{
  return mSPSDescription;
}

MString
MUPS::sPSLocation() const
{
  return mSPSLocation;
}

MString
MUPS::preMedication() const
{
  return mPreMedication;
}

MString
MUPS::requestedContrastAgent() const
{
  return mRequestedContrastAgent;
}

MString
MUPS::scheduledStationName() const
{
  return mRequestedContrastAgent;
}

MString
MUPS::sPSStatus() const
{
  return mSPSStatus;
}

// Imaging Service Request
MString
MUPS::requestingPhysicianName() const
{
  return mRequestingPhysicianName;
}

MString
MUPS::referringPhysicianName() const
{
  return mReferringPhysicianName;
}

//Patient
MString
MUPS::patientID() const
{
  return this->value("patid");
}

MString
MUPS::issuerOfPatientID() const
{
  return this->value("issuer");
}

MString
MUPS::patientID2() const
{
  return mPatientID2;
}

MString
MUPS::issuerOfPatientID2() const
{
  return mIssuerOfPatientID2;
}

MString
MUPS::patientName() const
{
  return this->value("nam");
}

MString
MUPS::dateOfBirth() const
{
  return this->value("datbir");
}

MString
MUPS::patientSex() const
{
  return this->value("sex");
}

// Patient Medical
MString
MUPS::pregnancyStatus() const
{
  return mPregnancyStatus;
}

// Visit Identification
MString
MUPS::admissionID() const
{
  return this->value("admid");
}

// Visit Status
MString
MUPS::currentPatientLocation() const
{
  return mCurrentPatientLocation;
}

//Requested Procedure
void
MUPS::studyInstanceUID(const MString& s)
{
   insert("stuinsuid", s);
}

void
MUPS::referencedStudySOPClass(const MString& s)
{
   mReferencedStudySOPClass = s;
   insert("refstusopcla", s);
}

void
MUPS::referencedStudySOPInstance(const MString& s)
{
   mReferencedStudySOPInstance = s;
   insert("refstusopins", s);
}

void
MUPS::requestedProcedureID(const MString& s)
{
   mRequestedProcedureID = s;
   insert("reqproid", s);
}

void
MUPS::placerOrderNumber(const MString& s)
{
   mPlacerOrderNumber = s;
   insert("plaordnum", s);
}

void
MUPS::fillerOrderNumber(const MString& s)
{
   mFillerOrderNumber = s;
   insert("filordnum", s);
}

void
MUPS::accessionNumber(const MString& s)
{
   mAccessionNumber = s;
   insert("accnum", s);
}

void
MUPS::quantityTiming(const MString& s)
{
   mQuantityTiming = s;
   insert("quatim", s);
}

void
MUPS::eventReason(const MString& s)
{
   mEventReason = s;
   insert("everea", s);
}

void
MUPS::requestedDateTime(const MString& s)
{
   mRequestedDateTime = s;
   insert("reqdattim", s);
}

void
MUPS::specimenSource(const MString& s)
{
   mSpecimenSource = s;
   insert("spesou", s);
}

void
MUPS::orderingProvider(const MString& s)
{
   mOrderingProvider = s;
   insert("ordpro", s);
}

void
MUPS::requestedProcedureDescription(const MString& s)
{
   mRequestedProcedureDescription = s;
   insert("reqprodes", s);
}

void
MUPS::requestedProcedureCodeSeq(const MString& s)
{
   mRequestedProcedureCodeSeq = s;
   insert("reqprocod", s);
}

void
MUPS::occurrenceNumber(const MString& s)
{
   mOccurrenceNumber = s;
   insert("occnum", s);
}

void
MUPS::appointmentTimingQuantity(const MString& s)
{
   mAppointmentTimingQuantity = s;
   insert("apptimqua", s);
}

void
MUPS::orderUID(const MString& s)
{
   mOrderUID = s;
   insert("orduid", s);
}

//Requested Procedure Code Item
void
MUPS::codeValue(const MString& s)
{
  mCodeValue = s;
  insert("codval", s);
}

void
MUPS::codeMeaning(const MString& s)
{
  mCodeMeaning = s;
  insert("codmea", s);
}

void
MUPS::codeSchemeDesignator(const MString& s)
{
  mCodeSchemeDesignator = s;
  insert("codschdes", s);
}

//SPS
void
MUPS::scheduledProcedureStepID(const MString& s)
{
  mScheduledProcedureStepID = s;
  insert("spsid", s);
}

void
MUPS::spsIndex(const MString& s)
{
  mSPSIndex = s;
  insert("spsindex", s);
}

void
MUPS::scheduledAETitle(const MString& s)
{
  mScheduledAETitle = s;
  insert("schaet", s);
}

void
MUPS::sPSStartDate(const MString& s)
{
  mSPSStartDate = s;
  insert("spsstadat", s);
}

void
MUPS::sPSStartTime(const MString& s)
{
  mSPSStartTime = s;
  insert("spsstatim", s);
}

void
MUPS::modality(const MString& s)
{
  mModality = s;
  insert("mod", s);
}

void
MUPS::scheduledPerformingPhysicianName(const MString& s)
{
  mScheduledPerformingPhysicianName = s;
  insert("schperphynam", s);
}

void
MUPS::sPSDescription(const MString& s)
{
  mSPSDescription = s;
  insert("spsdes", s);
}

void
MUPS::sPSLocation(const MString& s)
{
  mSPSLocation = s;
  insert("spsloc", s);
}

void
MUPS::preMedication(const MString& s)
{
  mPreMedication = s;
  insert("premed", s);
}

void
MUPS::requestedContrastAgent(const MString& s)
{
  mRequestedContrastAgent = s;
  insert("reqconage", s);
}

void
MUPS::scheduledStationName(const MString& s)
{
  mScheduledStationName = s;
  insert("schstanam", s);
}

void
MUPS::sPSStatus(const MString& s)
{
  mSPSStatus = s;
  insert("spssta", s);
}

// Imaging Service Request
void
MUPS::requestingPhysicianName(const MString& s)
{
  mRequestingPhysicianName = s;
  insert("reqphynam", s);
}

void
MUPS::referringPhysicianName(const MString& s)
{
  mReferringPhysicianName = s;
  insert("refphynam", s);
}


//Patient
void
MUPS::patientID(const MString& s)
{
  insert("patid", s);
}

void
MUPS::issuerOfPatientID(const MString& s)
{
  insert("issuer", s);
}

void
MUPS::patientID2(const MString& s)
{
  mPatientID2 = s;
  insert("patid2", s);
}

void
MUPS::issuerOfPatientID2(const MString& s)
{
  mIssuerOfPatientID2 = s;
  insert("issuer2", s);
}

void
MUPS::patientName(const MString& s)
{
  insert("nam", s);
}

void
MUPS::dateOfBirth(const MString& s)
{
  insert("datbir", s);
}

void
MUPS::patientSex(const MString& s)
{
  insert("sex", s);
}

// Patient Medical
void
MUPS::pregnancyStatus(const MString& s)
{
  mPregnancyStatus = s;
  insert("pregstat", s);
}

// Visit Identification
void
MUPS::admissionID(const MString& s)
{
  insert("admid", s);
}

// Visit Status
void
MUPS::currentPatientLocation(const MString& s)
{
  mCurrentPatientLocation = s;
  insert("curpatloc", s);
}

void MUPS::import(const MDomainObject& o)
{
  //SOP Common
  insert("id", o.value("id"));
  specificCharacterSet(o.value("specharset"));
  SOPClassUID(o.value("sopclauid"));
  SOPInstanceUID(o.value("sopinsuid"));

  // Unified Procedure Step Scheduled Procedure Information
  scheduledProcedureStepPriority(o.value("spspri"));
  scheduledProcedureStepModDateTime(o.value("spsmoddattim"));
  this->insert("prostelbl", o.value("prostelbl"));
  this->insert("worlbl", o.value("worlbl"));
  this->insert("spsstadattim", o.value("spsstadattim"));
  this->insert("expcomdattim", o.value("expcomdattim"));
  this->insert("stuinsuid", o.value("stuinsuid"));

  patientName(o.value("nam"));
  patientID(o.value("patid"));
  issuerOfPatientID(o.value("issuer"));
  dateOfBirth(o.value("datbir"));
  patientSex(o.value("sex"));
  admissionID(o.value("admid"));
  this->insert("admdiagdes", o.value("admdiagdes"));
  this->insert("upsstate", o.value("upsstate"));

  //Requested Procedure
  requestedProcedureID(o.value("reqproid"));
  codeValue(o.value("codval"));
  codeMeaning(o.value("codmea"));
  codeSchemeDesignator(o.value("codschdes"));
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
  patientID2(o.value("patid2"));
  issuerOfPatientID2(o.value("issuer2"));

  // Patient Medical
  pregnancyStatus(o.value("pregstat"));

  // Visit Identification

  // Visit Status
  currentPatientLocation(o.value("curpatloc"));
}
