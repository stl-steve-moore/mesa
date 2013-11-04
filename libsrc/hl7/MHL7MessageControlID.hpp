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

// $Id: MHL7MessageControlID.hpp,v 1.6 2006/06/29 16:08:32 bhasselfeld Exp $ $Author: bhasselfeld $ $Revision: 1.6 $ $Date: 2006/06/29 16:08:32 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MHL7MessageControlID.hpp
//
//  = AUTHOR
//	F. David Sacerdoti
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
//	$Date: 2006/06/29 16:08:32 $
//
//  = COMMENTS
//	This class needs a richer implementation to produce IDs that
//	are unique across processes and machines.

#ifndef MHL7MessageControlIDISIN
#define MHL7MessageControlIDISIN

#include <iostream>
#include <string>

using namespace std;

class MHL7MessageControlID
// = TITLE
///	A class to produce HL7 Message Control IDs.
//
// = DESCRIPTION
///	This class produces Message Control IDs.
{
public:
  // = The standard methods in this framework.

  MHL7MessageControlID();
  ///< Default constructor

  MHL7MessageControlID(const MHL7MessageControlID& cpy);

  virtual ~MHL7MessageControlID();

  virtual void printOn(ostream& s) const;
  /**<\brief This method is used in conjunction with the streaming operator <<
   to print the current state of MHL7MessageControlID. */

  virtual void streamIn(istream& s);
  /**<\brief This method is used in conjunction with the streaming operator >>
   to read the current state of MHL7MessageControlID. */

  // = Class specific methods.

  MString controlID() const;
  ///< Produce a new Message Control ID.

private:
};

inline ostream& operator<< (ostream& s, const MHL7MessageControlID& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MHL7MessageControlID& c) {
  c.streamIn(s);
  return s;
}

#endif
