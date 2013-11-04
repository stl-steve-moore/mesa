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

// $Id: MWorkOrder.hpp,v 1.3 2006/06/29 16:08:32 bhasselfeld Exp $ $Author: bhasselfeld $ $Revision: 1.3 $ $Date: 2006/06/29 16:08:32 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MWorkOrder.hpp
//
//  = AUTHOR
//	Steve Moore
//
//  = COPYRIGHT
//	Copyright HIMSS, RSNA, Washington University: 1999, 2000
//
// ====================
//
//  = VERSION
//	$Revision: 1.3 $
//
//  = DATE RELEASED
//	$Date: 2006/06/29 16:08:32 $
//
//  = COMMENTS
//

#ifndef MWorkOrderISIN
#define MWorkOrderISIN

#include <iostream>
#include "MDomainObject.hpp"

class MWorkOrder;
typedef vector < MWorkOrder > MWorkOrderVector;

using namespace std;

class MWorkOrder : public MDomainObject
// = TITLE
///  Domain object for a work order. 
//
// = DESCRIPTION
//
{
public:
  // = The standard methods in this framework.

  MWorkOrder();
  ///< Default constructor

  MWorkOrder(const MWorkOrder& cpy);

  virtual ~MWorkOrder();

  virtual void printOn(ostream& s) const;
  /**<\brief This method is used in conjunction with the streaming operator <<
  	     to print the current state of MWorkOrder. */

  virtual void streamIn(istream& s);
  /**<\brief This method is used in conjunction with the streaming operator >>
  	     to read the current state of MWorkOrder. */

  // = Class specific methods.

  MWorkOrder(const MString& orderNumber,
	 const MString& type,
	 const MString& parameters,
	 const MString& orderedBy,
	 const MString& dateOrderd,
	 const MString& timeOrdered,
	 const MString& dateCompleted,
	 const MString& timeCompleted,
	 const MString& elapsedTime,
	 const MString& workTime,
	 const MString& status );
  /**<\brief This constructor takes a variable for each attribute managed by this
  	     class.  The value of each variable is copied into the internal state
  	     managed by this object. */

  void import(const MDomainObject& o);
  ///< This method imports the key-value pairs from the MDomainObject <{o}>.
  /**< The values are copied from <{o}> and stored in the internal state
       maintained by this object. */

  // A number of get methods that return values.  Use the method name
  // as a guide to the attribute.
  MString orderNumber() const;
  MString type() const;
  MString parameters() const;
  MString orderedBy() const;
  MString dateOrdered() const;
  MString timeOrdered() const;
  MString dateCompleted() const;
  MString timeCompleted() const;
  MString elapsedTime() const;
  MString workTime() const;
  MString status() const;
 
  // A number of set methods that set one attribute value.  Use the method
  // name as a guide to the attribute.
  void orderNumber(const MString& s);
  void type(const MString& s);
  void parameters(const MString& s);
  void orderedBy(const MString& s);
  void dateOrdered(const MString& s);
  void timeOrdered(const MString& s);
  void dateCompleted(const MString& s);
  void timeCompleted(const MString& s);
  void elapsedTime(const MString& s);
  void workTime(const MString& s);
  void status(const MString& s);

private:
  MString mOrderNumber;
  MString mType;
  MString mParameters;
  MString mOrderedBy;
  MString mDateOrdered;
  MString mTimeOrdered;
  MString mDateCompleted;
  MString mTimeCompleted;
  MString mElapsedTime;
  MString mWorkTime;
  MString mStatus;
};

inline ostream& operator<< (ostream& s, const MWorkOrder& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MWorkOrder& c) {
  c.streamIn(s);
  return s;
}

#endif
