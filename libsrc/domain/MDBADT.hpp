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

// $Id: MDBADT.hpp,v 1.9 2006/06/29 16:08:29 bhasselfeld Exp $ $Author: bhasselfeld $ $Revision: 1.9 $ $Date: 2006/06/29 16:08:29 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MDBADT.hpp
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
//	$Revision: 1.9 $
//
//  = DATE RELEASED
//	$Date: 2006/06/29 16:08:29 $
//
//  = COMMENTS
//

#ifndef MDBADTISIN
#define MDBADTISIN

#include <iostream>
#include <string>

using namespace std;

#include "MPatient.hpp"
#include "MVisit.hpp"
#include "MDBInterface.hpp"

class MDBADT
// = TITLE
///	Database interface for an ADT system.
//
// = DESCRIPTION
/**	This class provides an abstraction to a (relational) database
	for an ADT system.  The methods define typical operations for
	an ADT system (which correspond closely to transactions defined
	in the IHE Technical Framework). */
{
public:
  // = The standard methods in this framework.
  MDBADT();
  ///< Default constructor
  MDBADT(const MDBADT& cpy);
  virtual ~MDBADT();
  virtual void printOn(ostream& s) const;
  /**<\brief This method is used in conjunction with the streaming operator <<
   to print the current state of MDBADT */

  virtual void streamIn(istream& s);
  
  // = Class specific methods.
  MDBADT(const string& databaseName);
  ///< Construct an ADT DB interface for the database whose name is in databaseName.  
  /**This constructor does not perform consistency
   checks on the database.  That is, it does not test to make
   sure that all tables are present in the database. */

  int admitRegisterPatient(const MPatient& patient, const MVisit& visit);
  ///< Admit patient as in-patient or register patient as out-patient.
  ///< The visit argument defines the registration mode.

  int dischargePatient(const MPatient& patient, const MVisit& visit);
  ///< Discharge the patient.  
  ///<The current visit information (in/out patient) is found in the visit argument.

  int updatePatient(MPatient& patient);
  ///< Update any demographics in the patient record.

  int transferPatient(const MPatient& patient, const MVisit& visit);
  ///< Transfer the patient from current location to the location described in the visit argument.

private:
  MDBInterface* mDBInterface;
};

inline ostream& operator<< (ostream& s, const MDBADT& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MDBADT& c) {
  c.streamIn(s);
  return s;
}

#endif
