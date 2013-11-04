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

// $Id: MDateTime.hpp,v 1.2 2006/06/29 16:08:28 bhasselfeld Exp $ $Author: bhasselfeld $ $Revision: 1.2 $ $Date: 2006/06/29 16:08:28 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MDateTime.hpp
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
//	$Revision: 1.2 $
//
//  = DATE RELEASED
//	$Date: 2006/06/29 16:08:28 $
//
//  = COMMENTS

#ifndef MDateTimeISIN
#define MDateTimeISIN

#include <iostream>
#include <string>

using namespace std;

class MDateTime
// = TITLE
///	provides a set of wrappers for simple file operations used routinely by this framework.
//
// = DESCRIPTION
/**	This class provides a set of directory operations that are useful
	in the MESA framework.  Some of the methods work together
	(for example, opening and reading a directory), while other methods
	are defined independently.
	This class does not provide low-level file I/O. */

{
public:
  // = The standard methods in this framework.

  MDateTime();
  ///< Default constructor

  MDateTime(const MDateTime& cpy);
  ///< Copy constructor

  virtual ~MDateTime();
  ///< Destructor

  virtual void printOn(ostream& s) const;
  /**<\brief This method is used in conjunction with the streaming operator <<
   to print the current state of MDateTime */

  virtual void streamIn(istream& s);
  /**<\brief This method is used in conjuction with the streaming operator >>
   to read the current state of MDateTime. */
  
  // = Class specific methods.

  int formatXSDateTime(MString& dateTime);
  int formatRFC3339DateTime(MString& dateTime);

private:
};

inline ostream& operator<< (ostream& s, const MDateTime& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MDateTime& c) {
  c.streamIn(s);
  return s;
}

#endif
