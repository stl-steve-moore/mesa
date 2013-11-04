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

// $Id: MDBRequestedProcedure.hpp,v 1.4 2006/06/29 16:08:30 bhasselfeld Exp $ $Author: bhasselfeld $ $Revision: 1.4 $ $Date: 2006/06/29 16:08:30 $ $State: Exp $
//
// ====================
//  = LIBRARY
//	IHE
//
//  = FILENAME
//	MDBRequestedProicedure.hpp
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
//	$Revision: 1.4 $
//
//  = DATE RELEASED
//	$Date: 2006/06/29 16:08:30 $
//
//  = COMMENTTEXT
//	Comments

#ifndef MDBRequestedProcedureISIN
#define MDBRequestedProcedureISIN

#include <iostream>
#include <string>
#include "MDBBase.hpp"

class MRequestedProcedure;

using namespace std;

class MDBRequestedProcedure : public MDBBase
// = TITLE
//	Short title/description
//
// = DESCRIPTION
//	Describe the class and how to use it
{
public:
  // = The standard methods in this framework.
  MDBRequestedProcedure();
  ///< Default constructor
  MDBRequestedProcedure(const MDBRequestedProcedure& cpy);
  virtual ~MDBRequestedProcedure();
  virtual void printOn(ostream& s) const;
  /** This method is used in conjunction with the streaming operator <<
      to print the current state of MDBPatient */

  virtual void streamIn(istream& s);
  
  // = Class specific methods.

  MDBRequestedProcedure(const string& databaseName);
  ///< Construct a database interface for the database databaseName.

  int insert(const MRequestedProcedure& reqProc);
  ///< Insert a new record into the reqProcedure database.

  int update(const MRequestedProcedure& reqProc, const MRequestedProcedure& updateCriteria);
  ///< Update values in the reqprocedure database.  
  /**< Use attributes in reqprocedureto go into the database.  Use attributes in updateCriteria to
       determine which requested procedure(s) is/are updated. */

  int select(MRequestedProcedure& reqProc, const MRequestedProcedure& selectCriteria);
  ///< Select one requested procedure based on the criteria in selectCriteria

  int remove(const MRequestedProcedure& deleteCriteria);
  ///< Delete the requested procedure(s) specfied by the criteria in deleteCriteria

private:
};

inline ostream& operator<< (ostream& s, const MDBRequestedProcedure& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MDBRequestedProcedure& c) {
  c.streamIn(s);
  return s;
}

#endif
