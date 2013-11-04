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

// $Id: MMPPS.hpp,v 1.8 2006/06/29 16:08:31 bhasselfeld Exp $ $Author: bhasselfeld $ $Revision: 1.8 $ $Date: 2006/06/29 16:08:31 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MMPPS.hpp
//
//  = AUTHOR
//	Saeed Akbani
//
//  = COPYRIGHT
//	Copyright HIMSS, RSNA, Washington University: 1999, 2000
//
// ====================
//
//  = VERSION
//	$Revision: 1.8 $
//
//  = DATE RELEASED
//	$Date: 2006/06/29 16:08:31 $
//
//  = COMMENTS
//

#ifndef MMPPSISIN
#define MMPPSISIN

#include <iostream>
#include "MDomainObject.hpp" 

using namespace std;

class MMPPS : public MDomainObject
// = TITLE
///	A domain object corresponding to a Modality Performed Procedure Step.
//
// = DESCRIPTION
/**	This class is a container for attributes which define a DICOM
	Modality Performed Procedure Step item.  It inherits from
	<{MDomainObject}> and supports the
	ability to get and set values with specific methods.  Because this
	class is just a container, it performs no validation tests.
	Describe the class and how to use it */
{
public:
  // = The standard methods in this framework.

  MMPPS();
  ///< Default constructor

  MMPPS(const MMPPS& cpy);

  virtual ~MMPPS();

  virtual void printOn(ostream& s) const;
  /**<\brief This method is used in conjunction with the streaming operator <<
             to print the current state of MMPPS. */

  virtual void streamIn(istream& s);
  /**<\brief This method is used in conjunction with the streaming operator >>
             to read the current state of MMPPS. */

  // = Class specific methods.

  MMPPS(const MString& patientName,
        const MString& patientID,
        const MString& patientBirthDate,
        const MString& patientSex,
        const MString& pPSID,
        const MString& performedStationAETitle,
        const MString& performedStationName,
        const MString& performedLocation,
        const MString& pPSStartDate,
        const MString& pPSStartTime,
        const MString& pPSStatus,
        const MString& pPSDescription,
        const MString& pPTypeDescription,
        const MString& pPSEndDate,
        const MString& pPSEndTime,
        const MString& modality,
        const MString& studyID);
  ///< This constructor takes a value for each attribute which is managed by this class.  
  /**< The values are copied into the internal state of the object. */

  // A number of get methods which return values corresponding to the
  // method name.

  MString patientName() const;
  MString patientID() const;
  MString patientBirthDate() const;
  MString patientSex() const;
  MString pPSID() const;
  MString performedStationAETitle() const;
  MString performedStationName() const;
  MString performedLocation() const;
  MString pPSStartDate() const;
  MString pPSStartTime() const;
  MString pPSStatus() const;
  MString pPSDescription() const;
  MString pPTypeDescription() const;
  MString pPSEndDate() const;
  MString pPSEndTime() const;
  MString modality() const;
  MString studyID() const;

  // A number of set methods which set attribute values according to
  // the method name.
  void patientName(const MString& s);
  void patientID(const MString& s);
  void patientBirthDate(const MString& s);
  void patientSex(const MString& s);
  void pPSID(const MString& s);
  void performedStationAETitle(const MString& s);
  void performedStationName(const MString& s);
  void performedLocation(const MString& s);
  void pPSStartDate(const MString& s);
  void pPSStartTime(const MString& s);
  void pPSStatus(const MString& s);
  void pPSDescription(const MString& s);
  void pPTypeDescription(const MString& s);
  void pPSEndDate(const MString& s);
  void pPSEndTime(const MString& s);
  void modality(const MString& s);
  void studyID(const MString& s);

  void import(MDomainObject& o);
  ///< This method imports the key-value pairs from the MDomainObject <{o}>.
  /**< The values are copied from <{o}> and overwrite existing attributes in this object. */

private:
  MString mPatientName;
  MString mPatientID;
  MString mPatientBirthDate;
  MString mPatientSex;
  MString mPPSID;
  MString mPerformedStationAETitle;
  MString mPerformedStationName;
  MString mPerformedLocation;
  MString mPPSStartDate;
  MString mPPSStartTime;
  MString mPPSStatus;
  MString mPPSDescription;
  MString mPPTypeDescription;
  MString mPPSEndDate;
  MString mPPSEndTime;
  MString mModality;
  MString mStudyID;
  //MString mPerformedSeriesSequence;
  //MString mScheduledStepAttributesSequence;
  //MString mReferencedStudyComponentSequence;
};

inline ostream& operator<< (ostream& s, const MMPPS& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MMPPS& c) {
  c.streamIn(s);
  return s;
}

#endif
