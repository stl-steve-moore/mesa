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

// $Id: MDBSPS.hpp,v 1.4 2006/06/29 16:08:30 bhasselfeld Exp $ $Author: bhasselfeld $ $Revision: 1.4 $ $Date: 2006/06/29 16:08:30 $ $State: Exp $
//
// ====================
//  = LIBRARY
//	IHE
//
//  = FILENAME
//	MDBSPS.hpp
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

#ifndef MDBSPSISIN
#define MDBSPSISIN

#include <iostream>
#include <string>
#include "MDBBase.hpp"

class MSPS;

using namespace std;

class MDBSPS : public MDBBase
// = TITLE
///	Scheduled Step Procedure Database Operations 
//
// = DESCRIPTION
//	Describe the class and how to use it
{
public:
  // = The standard methods in this framework.
  MDBSPS();
  ///< Default constructor
  MDBSPS(const MDBSPS& cpy);
  virtual ~MDBSPS();
  virtual void printOn(ostream& s) const;
  /**<\brief This method is used in conjunction with the streaming operator <<
  	     to print the current state of MDBPatient */

  virtual void streamIn(istream& s);
  
  // = Class specific methods.

  MDBSPS(const string& databaseName);
  ///< Construct a database interface for the database databaseName.

  int insert(const MSPS& spStep);
  ///< Insert a new record into the sps database.

  int update(const MSPS& spStep, const MSPS& updateCriteria);
  ///< Update values in the sps database.  
  /**< Use attributes in sps to go into the database.  Use attributes in updateCriteria to
       determine which sps(s) is/are updated. */

  int select(MSPS& spStep, const MSPS& selectCriteria);
  ///< Select one sps based on the criteria in selectCriteria

  int remove(const MSPS& deleteCriteria);
  ///< Delete the sps(s) specfied by the criteria in deleteCriteria

private:
};

inline ostream& operator<< (ostream& s, const MDBSPS& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MDBSPS& c) {
  c.streamIn(s);
  return s;
}

#endif
