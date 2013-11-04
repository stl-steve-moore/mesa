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

// $Id: MDBPatient.hpp,v 1.6 2006/06/29 16:08:30 bhasselfeld Exp $ $Author: bhasselfeld $ $Revision: 1.6 $ $Date: 2006/06/29 16:08:30 $ $State: Exp $
//
// ====================
//  = LIBRARY
//	xxx
//
//  = FILENAME
//	MDBPatient.hpp
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
//	$Revision: 1.6 $
//
//  = DATE RELEASED
//	$Date: 2006/06/29 16:08:30 $
//
//  = COMMENTTEXT
//	Comments

#ifndef MDBPatientISIN
#define MDBPatientISIN

#include <iostream>
#include <string>
#include "MDBBase.hpp"

class MPatient;

using namespace std;

class MDBPatient : public MDBBase
// = TITLE
//	Short title/description
//
// = DESCRIPTION
//	Describe the class and how to use it
{
public:
  // = The standard methods in this framework.
  MDBPatient();
  // Default constructor
  MDBPatient(const MDBPatient& cpy);
  virtual ~MDBPatient();
  virtual void printOn(ostream& s) const;
  // This method is used in conjunction with the streaming operator <<
  // to print the current state of MDBPatient

  virtual void streamIn(istream& s);
  
  // = Class specific methods.

  MDBPatient(const MString& databaseName);
  ///< Construct a database interface for the database databaseName.

  void insert(const MPatient& patient);
  ///< Insert a new record into the patient database.

  int update(const MPatient& patient, const MPatient& updateCriteria);
  ///< Update values in the patient database.  
  /**< Use attributes in patient
   to go into the database.  Use attributes in updateCriteria to
   determine which patient(s) is/are updated. */

  int select(MPatient& patient, const MPatient& selectCriteria);
  ///< Select one patient based on the criteria in selectCriteria

  int remove(const MPatient& deleteCriteria);
  ///< Delete the patient(s) specfied by the criteria in deleteCriteria

private:
};

inline ostream& operator<< (ostream& s, const MDBPatient& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MDBPatient& c) {
  c.streamIn(s);
  return s;
}

#endif
