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

// $Id: MOrder.hpp,v 1.11 2006/06/29 16:08:31 bhasselfeld Exp $ $Author: bhasselfeld $ $Revision: 1.11 $ $Date: 2006/06/29 16:08:31 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MOrder.hpp
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
//	$Revision: 1.11 $
//
//  = DATE RELEASED
//	$Date: 2006/06/29 16:08:31 $
//
//  = COMMENTS
//
#ifndef MORDER
#define MORDER

#include <iostream>
#include <vector>
#include "MDomainObject.hpp"

using namespace std;

class MOrder;
typedef vector < MOrder > MOrderVector;

class MOrder : public MDomainObject
// = TITLE
///	A domain object which corresponds to an HL7 order.
//
// = DESCRIPTION
/**	This class is a container for attributes which define an HL7
	order.  These are the attributes common to Placer and Filler
	orders.  It inherits from <{MDomainObject}> and supports the
	ability to get and set values with specific methods.  Because this
	class is just a container, it performs no validation tests. */

{
public:
  // The standard methods in this framework.

  MOrder();
  ///< Default constructor.

  MOrder(const MOrder& cpy);

  virtual ~MOrder();

  virtual void printOn(ostream& s) const;

  virtual void streamIn(istream& s);

  // Class specific methods.

  MOrder(const MString& placerOrderNumber,
    const MString& fillerOrderNumber,
    const MString& visitNumber,
    const MString& universalServiceID,
    const MString& orderControl,
    const MString& placerGroupNumber,
    const MString& orderStatus,
    const MString& mesaStatus,
    const MString& quantityTiming,
    const MString& parent,
    const MString& dateTimeOfTransaction,
    const MString& enteredBy,
    const MString& orderingProvider,
    const MString& referringDoctor,
    const MString& enteringOrganization,
    const MString& orderEffectiveDateTime,
    const MString& specimenSource,
    const MString& transportArrangementResponsibility,
    const MString& reasonForStudy,
    const MString& orderCallbackPhoneNumber,
    const MString& observationValue,
    const MString& dangerCode,
    const MString& relevantClinicalInfo);
  ///< This constructor takes a value for each attribute managed by this class.  
  /**< The constructor copies each attribute into the internal state managed by this class. */

  void import(MDomainObject& o);
  /**<\brief Import the key-value pairs from the domain object <{o}>.  This method
  	     copies the values from <{o}>, overwriting any existing value. */

  // Get methods which return values according to method name.
  MString placerOrderNumber() const;
  MString fillerOrderNumber() const;
  MString visitNumber() const;
  MString universalServiceID() const;
  MString orderControl() const;
  MString placerGroupNumber() const;
  MString orderStatus() const;
  MString mesaStatus() const;
  MString quantityTiming() const;
  MString parent() const;
  MString dateTimeOfTransaction() const;
  MString enteredBy() const;
  MString orderingProvider() const;
  MString referringDoctor() const;
  MString enteringOrganization() const;
  MString orderEffectiveDateTime() const;
  MString specimenSource() const;
  MString transportArrangementResponsibility() const;
  MString reasonForStudy() const;
  MString orderCallbackPhoneNumber() const;
  MString observationValue() const;
  MString dangerCode() const;
  MString relevantClinicalInfo() const;
  MString orderUID() const;

  // Set methods according to the method name.
  void placerOrderNumber(const MString& s);
  void fillerOrderNumber(const MString& s);
  void visitNumber(const MString& s);
  void universalServiceID(const MString& s);
  void orderControl(const MString& s);
  void placerGroupNumber(const MString& s);
  void orderStatus(const MString& s);
  void mesaStatus(const MString& s);
  void quantityTiming(const MString& s);
  void parent(const MString& s);
  void dateTimeOfTransaction(const MString& s);
  void enteredBy(const MString& s);
  void orderingProvider(const MString& s);
  void referringDoctor(const MString& s);
  void enteringOrganization(const MString& s);
  void orderEffectiveDateTime(const MString& s);
  void specimenSource(const MString& s);
  void transportArrangementResponsibility(const MString& s);
  void reasonForStudy(const MString& s);
  void orderCallbackPhoneNumber(const MString& s);
  void observationValue(const MString& s);
  void dangerCode(const MString& s);
  void relevantClinicalInfo(const MString& s);
  void orderUID(const MString& s);

private:

protected:
  MString mPlacerOrderNumber;
  MString mFillerOrderNumber;
  MString mVisitNumber;
  MString mUniversalServiceID;
  MString mOrderControl;
  MString mPlacerGroupNumber;
  MString mOrderStatus;
  MString mMesaStatus;
  MString mQuantityTiming;
  MString mParent;
  MString mDateTimeOfTransaction;
  MString mEnteredBy;
  MString mOrderingProvider;
  MString mReferringDoctor;
  MString mEnteringOrganization;
  MString mOrderEffectiveDateTime;
  MString mSpecimenSource;
  MString mTransportArrangementResponsibility;
  MString mReasonForStudy;
  MString mOrderCallbackPhoneNumber;
  MString mObservationValue;
  MString mDangerCode;
  MString mRelevantClinicalInfo;
  MString mOrderUID;
};

inline ostream& operator<< (ostream& s, const MOrder& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MOrder& c) {
  c.streamIn(s);
  return s;
}

#endif
