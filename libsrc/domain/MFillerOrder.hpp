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

// $Id: MFillerOrder.hpp,v 1.11 2006/06/29 16:08:30 bhasselfeld Exp $ $Author: bhasselfeld $ $Revision: 1.11 $ $Date: 2006/06/29 16:08:30 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MFillerOrder.hpp
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
//	$Revision: 1.11 $
//
//  = DATE RELEASED
//	$Date: 2006/06/29 16:08:30 $
//
//  = COMMENTS
//

#ifndef MFillerOrderISIN
#define MFillerOrderISIN

#include <iostream>
#include "MOrder.hpp"

using namespace std;

class MFillerOrder : public MDomainObject
// = TITLE
///	A domain object which corresponds to Filler Orders.
//
// = DESCRIPTION
/**	This class is a container for attributes which define an HL7
	Filler Order.  It inherits from <{MDomainObject}> and supports the
	ability to get and set values with specific methods.  Because this
	class is just a container, it performs no validation tests.
	A Filler Order may have more than one order associated with it; this
	class maintains a vector of <{MOrder}> objects. */

{
public:
  // = The standard methods in this framework.

  MFillerOrder();
  ///< Default constructor

  MFillerOrder(const MFillerOrder& cpy);

  virtual ~MFillerOrder();

  virtual void printOn(ostream& s) const;
  /**<\brief This method is used in conjunction with the streaming operator <<
  	     to print the current state of MFillerOrder. */

  virtual void streamIn(istream& s);
  /**<\brief This method is used in conjunction with the streaming operator >>
             to read the current state of MFillerOrder. */

  // Class specific methods to follow.

  MFillerOrder(const MString& patientID, const MString& issuerOfPatientID,
               const MString& accessionNumber, const MOrder& order);
  ///< Constructor which takes several identifiers and an <{MOrder}> object.
  /**< All values are copied into the internal state of the MFillerOrder. */

  void import(MDomainObject& o);
  ///< Import all named key-value pairs from the MDomainObject <{o}>.  
  /**< This replaces attributes of the same name in this object. */

  MString patientID() const;
  ///< Return a copy of the Patient ID.

  MString issuerOfPatientID() const;
  ///< Return a copy of the Issuer of the Patient ID.

  MString placerOrderNumber() const;
  ///< Return a copy of the Placer Order Number.

  MString fillerOrderNumber() const;
  ///< Return a copy of the Filler Order Number.

  MString accessionNumber() const;
  ///< Return a copy of the Accession Number.

  const MOrder& order(int index) const;
  /**<\brief Return a const reference to the order whose position in the
             internal vector is given by <{index}>.  The first <{index}> is 0. */
  
  void patientID(const MString& s);
  ///< Set the Patient ID to the value passed in <{s}>.

  void issuerOfPatientID(const MString& s);
  ///< Set the Issuer of Patient ID to the value passed in <{s}>.

  void placerOrderNumber(const MString& s);
  ///< Set the Placer Order Number to the value passed in <{s}>.

  void fillerOrderNumber(const MString& s);
  ///< Set the Filler Order Number to the value passed in <{s}>.

  void accessionNumber(const MString& s);
  ///< Set the Accession Number to the value passed in <{s}>.

  void add(const MOrder& o);
  ///< Add an order to the vector of orders maintained by this object.
  /**< The order specified in <{o}> is copied and placed in the internal
       vector of orders. */

  bool orderEmpty() const;
  ///< Returns <{true}> if there are no orders in the internal vector of orders and false otherwise.

  int  numOrders() const;
  ///< Returns the number of orders in the internal vector of orders.

private:
  MString mPatientID;
  MString mIssuerOfPatientID;
  MString mPlacerOrderNumber;
  MString mFillerOrderNumber;
  MString mAccessionNumber;
  MOrderVector mOrderVector;
  
};

inline ostream& operator<< (ostream& s, const MFillerOrder& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MFillerOrder& c) {
  c.streamIn(s);
  return s;
}

#endif
