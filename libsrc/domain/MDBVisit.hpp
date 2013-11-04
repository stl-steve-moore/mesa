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

// $Id: MDBVisit.hpp,v 1.4 2006/06/29 16:08:30 bhasselfeld Exp $ $Author: bhasselfeld $ $Revision: 1.4 $ $Date: 2006/06/29 16:08:30 $ $State: Exp $
//
// ====================
//  = LIBRARY
//	IHE
//
//  = FILENAME
//	MDBVisit.hpp
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

#ifndef MDBVisitISIN
#define MDBVisitISIN

#include <iostream>
#include <string>
#include "MDBBase.hpp"

class MVisit;

using namespace std;

class MDBVisit : public MDBBase
// = TITLE
//	Short title/description
//
// = DESCRIPTION
//	Describe the class and how to use it
{
public:
  // = The standard methods in this framework.
  MDBVisit();
  ///< Default constructor
  MDBVisit(const MDBVisit& cpy);
  virtual ~MDBVisit();
  virtual void printOn(ostream& s) const;
  /**<\brief This method is used in conjunction with the streaming operator <<
             to print the current state of MDBPatient */

  virtual void streamIn(istream& s);
  
  // = Class specific methods.

  MDBVisit(const string& databaseName);
  ///< Construct a database interface for the database databaseName.

  int insert(const MVisit& visit);
  ///< Insert a new record into the visit database.

  int update(const MVisit& visit, const MVisit& updateCriteria);
  ///< Update values in the visit database.  
  /**< Use attributes in visit to go into the database.  Use attributes in updateCriteria to
       determine which visit(s) is/are updated. */

  int select(MVisit& visit, const MVisit& selectCriteria);
  ///< Select one visit based on the criteria in selectCriteria

  int remove(const MVisit& deleteCriteria);
  ///< Delete the visit(s) specfied by the criteria in deleteCriteria

private:
};

inline ostream& operator<< (ostream& s, const MDBVisit& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MDBVisit& c) {
  c.streamIn(s);
  return s;
}

#endif
