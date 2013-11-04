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

// $Id: MDBBase.hpp,v 1.11 2006/06/29 16:08:29 bhasselfeld Exp $ $Author: bhasselfeld $ $Revision: 1.11 $ $Date: 2006/06/29 16:08:29 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MDBBase.hpp
//
//  = AUTHOR
//      Saeed Akbani
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
//	$Date: 2006/06/29 16:08:29 $
//
//  = COMMENTS

#ifndef MDBBaseISIN
#define MDBBaseISIN

#include <iostream>
#include <string>
#include <strstream>

#include "ctn_api.h"
#include "MString.hpp"

using namespace std;

class MDBBase
// = TITLE
///	Relational database base class.
//
// = DESCRIPTION
/**	This class provides a low-level API for relational databases based
	the MIR CTN libraries. */
{
public:
  // indicates number of database records retrieved
  // = The standard methods in this framework.
  MDBBase();
  ///< Default constructor
  MDBBase(const MDBBase& cpy);
  virtual ~MDBBase();
  virtual void printOn(ostream& s) const;
  /**<\brief This method is used in conjunction with the streaming operator <<
   to print the current state of MDBBase */

  virtual void streamIn(istream& s);
  
  // = Class specific methods.  Methods return 0 on success and -1 on failure.

  virtual int open(const MString& dbName);
  ///< Open the dartabase named <{dbName}>.  A database is a collection of tables.

  virtual int insertRow(TBL_FIELD* f, const MString& tableName);
  ///< Insert one row whose attributes are defined by the fields in <{f}>. The name of the table is passed in <{tableName}>.

  virtual int deleteRow(TBL_CRITERIA* c, const MString& tableName);
  /**<\brief Delete one row (or more) from the table named in <{tableName}>.
   The criteria which define the data to be deleted is passed in <{c}>. */

  virtual int updateRow(TBL_CRITERIA* c, TBL_UPDATE* u,
			const MString& tableName);
  /**<\brief Update all rows in the table <{tableName}> who satisfy the search crieria
   in the argument <{c}>.  The attributes to be updated are passed in <{u}>. */

  virtual int selectRow(TBL_CRITERIA* c, TBL_FIELD* f,
			CONDITION (*callback)(TBL_FIELD*, long, void*),
			void *ctx, const MString& tableName, long* count);
  ///< Select rows from the table named in <{tableName}>.  
  /**< The caller specifies
   the search criteria in <{c}> and the fields to be returned in <{f}>.
   For each row selected, this method invokes the caller's <{callback}>
   function.  In the argument list, <{ctx}> is context information defined
   by the caller which is passed to the <{callback}> function.
   The number of rows which are selected is returned to the caller
   through the <{count}> pointer. */

  int nextSequence(const MString& sequenceName, long& sequenceNumber);
  ///< Find the next sequence number for the name specified by the caller.
  /**< <{sequenceName}> is the name of the sequence known by the database.
   <{sequenceNumber}> is a reference to the integer value returned
   by this method.
   This method returns 0 on success or -1 on failure */

  int nextSequence(const MString& sequenceName, MString& sequenceNumber);

  ///< Find the next sequence number for the name specified by the caller.
  /**< <{sequenceName}> is the name of the sequence known by the database.
   <{sequenceNumber}> is a reference to the integer value returned
   by this method.
   This method returns 0 on success or -1 on failure */

  int safeExport(const string& s, char* target, size_t len) const;
  ///< Export the ASCII characters from <{s}> to <{target}> in a safe fashion.
  /**<  <{Len}> is the size of target (including a terminator).  Copy no
   more than <{len}>-1 characters and add the terminator. */

protected:
  void* mDBHandle;
  ///< Handle for database operations;

private:
  void logErrorStack(const MString& modifier) const;
  // Log the entire Error stack to the logging system.
};

inline ostream& operator<< (ostream& s, const MDBBase& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MDBBase& c) {
  c.streamIn(s);
  return s;
}

#endif
