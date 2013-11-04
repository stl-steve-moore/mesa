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

// $Id: MVisit.hpp,v 1.10 2006/06/29 16:08:32 bhasselfeld Exp $ $Author: bhasselfeld $ $Revision: 1.10 $ $Date: 2006/06/29 16:08:32 $ $State: Exp $
// ===========================
// = LIBRARY
//      IHE
//
// = FILENAME
//      MVisit.hpp
//
// = AUTHOR
//      Saeed Akbani
//
//  = COPYRIGHT
//	Copyright HIMSS, RSNA, Washington University: 1999, 2000
//
// ====================
//
//  = VERSION
//	$Revision: 1.10 $
//
//  = DATE RELEASED
//	$Date: 2006/06/29 16:08:32 $
//
//  = COMMENTS
//
#ifndef MVisitISIN
#define MVisitISIN

#include <iostream>
#include "MDomainObject.hpp"

using namespace std;

// = TITLE
///	A domain object which has attributes for a visit object.
//
// = DESCRIPTION
/**	This class is a container for attributes which define a visit
	object.  It inherits from <{MDomainObject}> and supports the
	ability to get and set values with specific methods.  Because this
	class is just a container, it performs no validation tests. */

class MVisit : public MDomainObject
{
public:
  // = The standard methods in this framework.
  MVisit();
  ///< Default constructor.

  MVisit(const MVisit& cpy);

  virtual ~MVisit();

  virtual void printOn(ostream& s) const;
  /**<\brief This method is used in conjunction with the streaming operator <<
  	     to print the current state of MVisit. */

  virtual void streamIn(istream& s);
  /**<\brief This method is used in conjunction with the streaming operator >>
  	     to read the current state of MVisit. */

  // Class specific methods.

  MVisit(const MString& visitNumber, const MString& patientID,
    const MString& issuerOfPatientID, const MString& patientClass,
    const MString& assignedPatientLocation, const MString& attendingDoctor,
    const MString& admitDate, const MString& admitTime,
    const MString& admittingDoctor, const MString& referringDoctor);
  /**<\brief This constructor takes a variable for each attribute managed by this
  	     class.  The constructor copies the values of the attributes into the
	     internal state of this class. */

  void import(MDomainObject& o);
  ///< This method imports the key-value pairs from the domain object <{o}>.
  /**< The imported key-value pairs overwrite existing values in this object. */

  // Get methods return values which match the method name.
  MString visitNumber() const;
  MString patientID() const;
  MString issuerOfPatientID() const;
  MString patientClass() const;
  MString assignedPatientLocation() const;
  MString attendingDoctor() const;
  MString admitDate() const;
  MString admitTime() const;
  MString admittingDoctor() const;
  MString referringDoctor() const;

  // Set methods set values according to method names.
  void visitNumber(const MString& s);
  void patientID(const MString& s);
  void issuerOfPatientID(const MString& s);
  void patientClass(const MString& s);
  void assignedPatientLocation(const MString& s);
  void attendingDoctor(const MString& s);
  void admitDate(const MString& s);
  void admitTime(const MString& s);
  void admittingDoctor(const MString& s);
  void referringDoctor(const MString& s);
  
private:
  MString mVisitNumber;
  MString mPatientID;
  MString mIssuerOfPatientID;
  MString mPatientClass;
  MString mAssignedPatientLocation;
  MString mAttendingDoctor;
  MString mAdmitDate;
  MString mAdmitTime;
  MString mAdmittingDoctor;
  MString mReferringDoctor;
};

inline ostream& operator<< (ostream& s, const MVisit& o) {
	  o.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MVisit& o) {
  o.streamIn(s);
  return s;
}

#endif
