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

// $Id: MDBDeptSysSched.hpp,v 1.7 2006/06/29 16:08:29 bhasselfeld Exp $ $Author: bhasselfeld $ $Revision: 1.7 $ $Date: 2006/06/29 16:08:29 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MDBDepSysSched.hpp
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
//	$Revision: 1.7 $
//
//  = DATE RELEASED
//	$Date: 2006/06/29 16:08:29 $
//
//  = COMMENTS
//

#ifndef MDBDeptSysSchedISIN
#define MDBDeptSysSchedISIN

#include <iostream>
#include <string>

using namespace std;

#include "MPatient.hpp"
#include "MVisit.hpp"
#include "MPlacerOrder.hpp"

class MDBDeptSysSched
// = TITLE
///	Database interface for an IHE defined Department System Scheduler.
//
// = DESCRIPTION
/**	This class provides an abstraction to a (relational) database
	for a Dept System Scheduler.  The methods define typical operations for
	a DSS system (which correspond closely to transactions defined
	in the IHE Technical Framework). */
{
public:
  // = The standard methods in this framework.
  MDBDeptSysSched();
  ///< Default constructor

  MDBDeptSysSched(const MDBDeptSysSched& cpy);
  ///< Copy constructor.

  virtual ~MDBDeptSysSched();

  virtual void printOn(ostream& s) const;
  /**<\brief This method is used in conjunction with the streaming operator <<
   to print the current state of MDBDeptSysSched. */

  virtual void streamIn(istream& s);
  /**<\brief This method is used in conjunction with the streaming operator >>
   to read the current state of MDBDeptSysSched. */

  // = Class specific methods.

  MDBDeptSysSched(const MString& databaseName);


  int admitRegisterPatient(const MPatient& patient, const MVisit& visit);
  /**<\brief A patient has been admitted as an in-patient or registered as an
   outpatient.  The visit argument defines the registration mode.
   Update our tables accordingly. */

  int updatePatient(const MPatient& patient);
  ///< Update demographics in the patient record.

  int transferPatient(const MPatient& patient, const MVisit& visit);
  /**<\brief Patient has been transferred.  Update our records with new location
   described in the visit argument. */

  int enterOrder(const MPatient& patient, const MPlacerOrder& order);
  ///< An order is placed for this patient.  Enter the order information into the database.

private:
};

inline ostream& operator<< (ostream& s, const MDBDeptSysSched& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MDBDeptSysSched& c) {
  c.streamIn(s);
  return s;
}

#endif
