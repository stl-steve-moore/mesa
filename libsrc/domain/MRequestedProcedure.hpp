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

// $Id: MRequestedProcedure.hpp,v 1.9 2006/06/29 16:08:31 bhasselfeld Exp $ $Author: bhasselfeld $ $Revision: 1.9 $ $Date: 2006/06/29 16:08:31 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MRequestedProcedure.hpp
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

#ifndef MRequestedProcedureISIN
#define MRequestedProcedureISIN

#include <iostream>
#include "MDomainObject.hpp"
//#include <MString>

using namespace std;

class MRequestedProcedure : public MDomainObject
// = TITLE
///	A domain object that corresponds to a DICOM Requested Procedure.
//
// = DESCRIPTION
/**	This class is a container for attributes which define a DICOM
	Requested Procedure.  It inherits from <{MDomainObject}> and
	supports the
	ability to get and set values with specific methods.  Because this
	class is just a container, it performs no validation tests. */
{
public:
  // = The standard methods in this framework.

  MRequestedProcedure();
  ///< Default constructor

  MRequestedProcedure(const MRequestedProcedure& cpy);

  virtual ~MRequestedProcedure();

  virtual void printOn(ostream& s) const;
  /**<\brief This method is used in conjunction with the streaming operator <<
	     to print the current state of MRequestedProcedure. */

  virtual void streamIn(istream& s);
  /**<\brief This method is used in conjunction with the streaming operator >>
  	     to read the current state of MRequestedProcedure. */

  // = Class specific methods.

  MRequestedProcedure(const MString& studyInstanceUID, 
     const MString& requestedProcedureID,
     const MString& fillerOrderNumber, 
     const MString& accessionNumber,
     const MString& quantityTiming, 
     const MString& eventReason, const MString& requestedDateTime, 
     const MString& specimenSource, const MString& orderingProvider, 
     const MString& referringDoctor,
     const MString& requestedProcedureDescription, 
     const MString& requestedProcedureCodeSeq,
     const MString& occurrenceNumber, 
     const MString& appointmentTimingQuantity,
     const MString& orderUID);
  /**<\brief This constructor takes a variable for each attribute that is managed
  	     by this object.  The values of the variables are copied to the internal
	     state of the object. */

  // A number of get methods that return values.  Use the method name
  // as a guide to the attribute.

  MString studyInstanceUID() const;
  MString requestedProcedureID() const;
  MString fillerOrderNumber() const;
  MString accessionNumber() const;
  MString quantityTiming() const;
  MString eventReason() const;
  MString requestedDateTime() const;
  MString specimenSource() const;
  MString orderingProvider() const;
  MString referringDoctor() const;
  MString requestedProcedureDescription() const;
  MString requestedProcedureCodeSeq() const;
  MString occurrenceNumber() const;
  MString appointmentTimingQuantity() const;
  MString orderUID() const;

  // A number of set methods that set one attribute value.  Use the method
  // name as a guide to the attribute.
  void studyInstanceUID(const MString& s);
  void requestedProcedureID(const MString& s);
  void fillerOrderNumber(const MString& s);
  void accessionNumber(const MString& s);
  void quantityTiming(const MString& s);
  void eventReason(const MString& s);
  void requestedDateTime(const MString& s);
  void specimenSource(const MString& s);
  void orderingProvider(const MString& s);
  void referringDoctor(const MString& s);
  void requestedProcedureDescription(const MString& s);
  void requestedProcedureCodeSeq(const MString& s);
  void occurrenceNumber(const MString & s);
  void appointmentTimingQuantity(const MString& s);
  void orderUID(const MString& s);

private:
  MString mStudyInstanceUID;
  MString mRequestedProcedureID;
  MString mFillerOrderNumber;
  MString mAccessionNumber;
  MString mQuantityTiming;
  MString mEventReason;
  MString mRequestedDateTime;
  MString mSpecimenSource;
  MString mOrderingProvider;
  MString mReferringDoctor;
  MString mRequestedProcedureDescription;
  MString mRequestedProcedureCodeSeq;
  MString mOccurrenceNumber;
  MString mAppointmentTimingQuantity;
  MString mOrderUID;
};

inline ostream& operator<< (ostream& s, const MRequestedProcedure& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MRequestedProcedure& c) {
  c.streamIn(s);
  return s;
}

#endif
