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

// $Id: MMWL.hpp,v 1.15 2006/06/29 16:08:31 bhasselfeld Exp $ $Author: bhasselfeld $ $Revision: 1.15 $ $Date: 2006/06/29 16:08:31 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MMWL.hpp
//
//  = AUTHOR
//	Phil DiCorpo
//
//  = COPYRIGHT
//	Copyright HIMSS, RSNA, Washington University: 1999, 2000
//
// ====================
//
//  = VERSION
//	$Revision: 1.15 $
//
//  = DATE RELEASED
//	$Date: 2006/06/29 16:08:31 $
//
//  = COMMENTS
//

#ifndef MMWLISIN
#define MMWLISIN

#include <iostream>
#include "MDomainObject.hpp"

using namespace std;

class MMWL : public MDomainObject
// = TITLE
///	A domain object which corresponds to one entry in a DICOM Modality Worklist.
//
// = DESCRIPTION
/**	This class is a container for attributes which define a DICOM
	Modality Worklist.  It inherits from <{MDomainObject}> and supports the
	ability to get and set values with specific methods.  Because this
	class is just a container, it performs no validation tests. */

{
public:
  // = The standard methods in this framework.

  MMWL();
  ///< Default constructor

  MMWL(const MMWL& cpy);

  virtual ~MMWL();

  virtual void printOn(ostream& s) const;
  /**<\brief This method is used in conjunction with the streaming operator <<
  	     to print the current state of MMWL. */

  virtual void streamIn(istream& s);
  /**<\brief This method is used in conjunction with the streaming operator >>
  	     to read the current state of MMWL. */

  MMWL(const MString& studyInstanceUID,
       const MString& referencedStudySOPClass,
       const MString& referencedStudySOPInstance,
       const MString& requestedProcedureID,
       const MString& placerOrderNumber, const MString& fillerOrderNumber, 
       const MString& accessionNumber, const MString& quantityTiming, 
       const MString& eventReason, const MString& requestedDateTime, 
       const MString& specimenSource, const MString& orderingProvider, 
       const MString& requestedProcedureDescription, 
       const MString& requestedProcedureCodeSeq,
       const MString& occurrenceNumber, 
       const MString& appointmentTimingQuantity,
       const MString& orderUID,
       const MString& codeValue,
       const MString& codeMeaning,
       const MString& codeSchemeDesignator,
       const MString& scheduledProcedureStepID,
       const MString& spsIndex,
       const MString& scheduledAETitle,
       const MString& scheduledProcedureStepStartDate,
       const MString& scheduledProcedureStepStartTime,
       const MString& modality,
       const MString& scheduledPerformingPhysicianName,
       const MString& scheduledProcedureStepDescription,
       const MString& scheduledProcedureStepLocation,
       const MString& preMedication,
       const MString& requestedContrastAgent,
       const MString& scheduledStationName,
       const MString& sPSStatus,
       const MString& requestingPhysicianName,
       const MString& referringPhysicianName,
       const MString& patientID, 
       const MString& issuerOfPatientID,
       const MString& patientID2,
       const MString& issuerOfPatientID2,
       const MString& patientName,
       const MString& dateOfBirth,
       const MString& patientSex,
       const MString& pregnancyStatus,
       const MString& currentPatientLocation,
       const MString& admissionID);
  /**<\brief This constructor takes a number of attributes which are defined for
  	     a Modality Worklist item and copies them into the internal state of
  	     this object. */

  
  // = Class specific methods.
  //Requested Procedure Module.  Return copies of attributes.
  MString studyInstanceUID() const;
  MString referencedStudySOPClass() const;
  MString referencedStudySOPInstance() const;
  MString requestedProcedureID() const;
  MString placerOrderNumber() const;
  MString fillerOrderNumber() const;
  MString accessionNumber() const;
  MString quantityTiming() const;
  MString eventReason() const;
  MString requestedDateTime() const;
  MString specimenSource() const;
  MString orderingProvider() const;
  MString requestedProcedureDescription() const;
  MString requestedProcedureCodeSeq() const;
  MString occurrenceNumber() const;
  MString appointmentTimingQuantity() const;
  MString orderUID() const;

  //Requested Procedure Code Item Module.  Return copies of attributes.
  MString codeValue() const;
  MString codeMeaning() const;
  MString codeSchemeDesignator() const;

  //SPS Module.  Return copies of attributes.
  MString scheduledProcedureStepID() const;
  MString spsIndex() const;
  MString scheduledAETitle() const;
  MString sPSStartDate() const;
  MString sPSStartTime() const;
  MString modality() const;
  MString scheduledPerformingPhysicianName() const;
  MString sPSDescription() const;
  MString sPSLocation() const;
  MString preMedication() const;
  MString requestedContrastAgent() const;
  MString scheduledStationName() const;
  MString sPSStatus() const;
  MString requestingPhysicianName() const;
  MString referringPhysicianName() const;

  //Patient Module.  Return copies of attributes.
  MString patientID() const;
  MString issuerOfPatientID() const;
  MString patientID2() const;
  MString issuerOfPatientID2() const;
  MString patientName() const;
  MString dateOfBirth() const;
  MString patientSex() const;

  ///  Patient Medical Module. Return copies of attributes
  MString pregnancyStatus() const;

  /// Visit Identification
  MString admissionID() const;

  /// Visit Status
  MString currentPatientLocation() const;

  //Requested Procedure Module.  Set attributes.
  void studyInstanceUID(const MString& s);
  void referencedStudySOPClass(const MString& s);
  void referencedStudySOPInstance(const MString& s);
  void requestedProcedureID(const MString& s);
  void placerOrderNumber(const MString& s);
  void fillerOrderNumber(const MString& s);
  void accessionNumber(const MString& s);
  void quantityTiming(const MString& s);
  void eventReason(const MString& s);
  void requestedDateTime(const MString& s);
  void specimenSource(const MString& s);
  void orderingProvider(const MString& s);
  void requestedProcedureDescription(const MString& s);
  void requestedProcedureCodeSeq(const MString& s);
  void occurrenceNumber(const MString & s);
  void appointmentTimingQuantity(const MString& s);
  void orderUID(const MString& s);

  //Requested Procedure Code Item. Set attributes.
  void codeValue(const MString& s);
  void codeMeaning(const MString& s);
  void codeSchemeDesignator(const MString& s);

  //SPS Module.  Set attributes.
  void scheduledProcedureStepID(const MString& s);
  void spsIndex(const MString& s);
  void scheduledAETitle(const MString& s);
  void sPSStartDate(const MString& s);
  void sPSStartTime(const MString& s);
  void modality(const MString& s);
  void scheduledPerformingPhysicianName(const MString& s);
  void sPSDescription(const MString& s);
  void sPSLocation(const MString& s);
  void preMedication(const MString& s);
  void requestedContrastAgent(const MString& s);
  void scheduledStationName(const MString& s);
  void sPSStatus(const MString& s);
  void requestingPhysicianName(const MString& s);
  void referringPhysicianName(const MString& s);

  //Patient Module.  Set attributes.
  void patientID(const MString& s);
  void issuerOfPatientID(const MString& s);
  void patientID2(const MString& s);
  void issuerOfPatientID2(const MString& s);
  void patientName(const MString& s);
  void dateOfBirth(const MString& s);
  void patientSex(const MString& s);

  /// Patient Medical. Set attributes.
  void pregnancyStatus(const MString& s);

  /// Visit Identification. Set attributes.
  void admissionID(const MString& s);

  /// Visit Status. Set attributes.
  void currentPatientLocation(const MString& s);

  void import(const MDomainObject& o);
  /**<\brief Import the key-value pairs from the MDomainObject <{o}> and set the
  	     appropriate values in this object. */

private:
  //Requested Procedure Module
  MString mStudyInstanceUID;
  MString mReferencedStudySOPClass;
  MString mReferencedStudySOPInstance;
  MString mRequestedProcedureID;
  MString mPlacerOrderNumber;
  MString mFillerOrderNumber;
  MString mAccessionNumber;
  MString mQuantityTiming;
  MString mEventReason;
  MString mRequestedDateTime;
  MString mSpecimenSource;
  MString mOrderingProvider;
  MString mRequestedProcedureDescription;
  MString mRequestedProcedureCodeSeq;
  MString mOccurrenceNumber;
  MString mAppointmentTimingQuantity;
  MString mOrderUID;
  //Requested Procedure Code Item
  MString mCodeValue;
  MString mCodeMeaning;
  MString mCodeSchemeDesignator;
  //SPS Module
  MString mScheduledProcedureStepID;
  MString mSPSIndex;
  MString mScheduledAETitle;
  MString mSPSStartDate;
  MString mSPSStartTime;
  MString mModality;
  MString mScheduledPerformingPhysicianName;
  MString mSPSDescription;
  MString mSPSLocation;
  MString mPreMedication;
  MString mRequestedContrastAgent;
  MString mScheduledStationName;
  MString mSPSStatus;
  // Imaging Service Request
  MString mRequestingPhysicianName;
  MString mReferringPhysicianName;
  //Patient Module
  MString mPatientID;
  MString mIssuerOfPatientID;
  MString mPatientID2;
  MString mIssuerOfPatientID2;
  MString mPatientName;
  MString mDateOfBirth;
  MString mPatientSex;
  MString mPregnancyStatus;
  MString mCurrentPatientLocation;
  MString mAdmissionID;
};

typedef vector< MMWL > MMWLVector;

inline ostream& operator<< (ostream& s, const MMWL& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MMWL& c) {
  c.streamIn(s);
  return s;
}

#endif
