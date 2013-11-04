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

// $Id: MPlacerOrder.hpp,v 1.14 2006/06/29 16:08:31 bhasselfeld Exp $ $Author: bhasselfeld $ $Revision: 1.14 $ $Date: 2006/06/29 16:08:31 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MPlacerOrder.hpp
//
//  = AUTHOR
//	Author Name
//
//  = COPYRIGHT
//	Copyright HIMSS, RSNA, Washington University: 1999, 2000
//
// ====================
//
//  = VERSION
//	$Revision: 1.14 $
//
//  = DATE RELEASED
//	$Date: 2006/06/29 16:08:31 $
//
//  = COMMENTS
//
#ifndef MPLACERORDER
#define MPLACERORDER

#include <iostream>
#include "MDomainObject.hpp"
#include "MOrder.hpp"

using namespace std;

// = TITLE
///	A domain object that corresponds to a Placer Order.
//
// = DESCRIPTION
/**	This class is a container for attributes which define an HL7
	Placer Order.  It inherits from <{MDomainObject}> and supports the
	ability to get and set values with specific methods.  Because this
	class is just a container, it performs no validation tests.
	A Placer Order may have more than one order associated with it; this
	class maintains a vector of <{MOrder}> objects. */
class MPlacerOrder : public MDomainObject
{
public:
  // = The standard methods in this framework.
  MPlacerOrder();

  MPlacerOrder(const MPlacerOrder& cpy);

  virtual ~MPlacerOrder();

  virtual void printOn(ostream& s) const;
  /**<\brief This method is used in conjunction with the streaming operator <<
  	     to print the current state of MPlacerOrder. */

  virtual void streamIn(istream& s);
  /**<\brief This method is used in conjunction with the streaming operator >>
  	     to read the current state of MPlacerOrder. */

  // Class specific methods.

  MPlacerOrder(const MString& patientID, const MString& issuerOfPatientID,
	       const MOrder& order);
  /**<\brief This constructor takes a patient ID from the combination of
   <{patientID}> and <{issuerOfPatientID}> and one order.  These
   are copied into the internal state of the MPlacerOrder. */

  void import(MDomainObject& o);
  ///< This method imports the key-value pairs from the MDomainObject <{o}>.
  /**< The values are read from <{o}> and overwrite existing attributes in
       the Placer Order. */

  MString patientID() const;
  ///< Return Patient ID.

  MString issuerOfPatientID() const;
  ///< Return Issuer of Patient ID.

  MString placerOrderNumber() const;
  ///< Return Placer Order Number.

  MString fillerOrderNumber() const;
  ///< Return Filler Order Number.

  MString mesaStatus () const;
  ///< Return the status of the order.

  MOrder& order(int index);
  /**<\brief Return a reference to the order in the internal vector designated
  	     by <{index>}.  The value for <{index}> starts at 0. */
  
  void patientID(const MString& s);
  ///< Set the Patient ID according to the value passed in <{s}>.

  void issuerOfPatientID(const MString& s);
  ///< Set the Isuer of Patient ID according to the value passed in <{s}>.

  void mesaStatus(const MString& s);
  ///< Set the order status according to the value passed in <{s}>.

  void placerOrderNumber(const MString& s);
  ///< Set the Placer Order Number according to the value passed in <{s}>.

  void fillerOrderNumber(const MString& s);
  ///< Set the Filler Order Number according to the value passed in <{s}>.

  void add(const MOrder& o);
  ///< Add an order <{o}> to the vendor of orders maintained by this class.
  ///< The order is copied, and the copy maintained by this class.
  
  bool orderEmpty() const;
  ///< Return <{true}> if the vector of orders is empty and false otherwise.

  int  numOrders() const;
  ///< Return the number of orders in the internal vector of orders.

private:
  MString mPatientID;
  MString mIssuerOfPatientID;
  MString mMesaStatus;
  MString mPlacerOrderNumber;
  MString mFillerOrderNumber;
  MOrderVector mOrderVector;
};

inline ostream& operator<< (ostream& s, const MPlacerOrder& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MPlacerOrder& c) {
  c.streamIn(s);
  return s;
}

#endif
