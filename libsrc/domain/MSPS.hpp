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

// $Id: MSPS.hpp,v 1.9 2006/06/29 16:08:31 bhasselfeld Exp $ $Author: bhasselfeld $ $Revision: 1.9 $ $Date: 2006/06/29 16:08:31 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MSPS.hpp
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
//	$Revision: 1.9 $
//
//  = DATE RELEASED
//	$Date: 2006/06/29 16:08:31 $
//
//  = COMMENTS
//

#ifndef MSPSISIN
#define MSPSISIN

#include <iostream>
#include "MDomainObject.hpp"

using namespace std;

class MSPS : public MDomainObject
// = TITLE
///	A domain object that corresponds to a Scheduled Procedure Step.
//
// = DESCRIPTION
/**	This class is a container for attributes which define a DICOM
	Scheduled Procedure Step.  It inherits from <{MDomainObject}>
	and supports the
	ability to get and set values with specific methods.  Because this
	class is just a container, it performs no validation tests. */
{
public:
  // = The standard methods in this framework.

  MSPS();
  ///< Default constructor

  MSPS(const MSPS& cpy);

  virtual ~MSPS();

  virtual void printOn(ostream& s) const;
  /**<\brief This method is used in conjunction with the streaming operator <<
  	     to print the current state of MSPS. */

  virtual void streamIn(istream& s);
  /**<\brief This method is used in conjunction with the streaming operator >>
  	     to read the current state of MSPS. */
  
  // = Class specific methods.

  MSPS(const MString& scheduledProcedureStepID,
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
       const MString& studyInstanceUID,
       const MString& sPSStatus);
  /**<\brief This constructor takes a variable for each attribute that is managed
  	     by this object.  The values of the variables are copied to the internal
   	     state of the object. */

  void import(const MDomainObject& o);
  ///< This method imports the key-value pairs from the MDomainObject <{o}>.
  /**< The values are copied from <{o}> and stored in the internal state
       maintained by this object. */

  // A number of get methods that return values.  Use the method name
  // as a guide to the attribute.
  MString scheduledProcedureStepID() const;
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
  MString studyInstanceUID() const;
  MString sPSStatus() const;

  // A number of set methods that set one attribute value.  Use the method
  // name as a guide to the attribute.
  void scheduledProcedureStepID(const MString& s);
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
  void studyInstanceUID(const MString& s);
  void sPSStatus(const MString& s);

private:
  MString mScheduledProcedureStepID;
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
  MString mStudyInstanceUID;
  MString mSPSStatus;
};

inline ostream& operator<< (ostream& s, const MSPS& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MSPS& c) {
  c.streamIn(s);
  return s;
}

#endif
