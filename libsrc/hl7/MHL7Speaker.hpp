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

// $Id: MHL7Speaker.hpp,v 1.5 2009/01/16 20:33:25 smm Exp $ $Author: smm $ $Revision: 1.5 $ $Date: 2009/01/16 20:33:25 $ $State: Exp $
//
// ====================
//  = LIBRARY
//	xxx
//
//  = FILENAME
//	MHL7Speaker.hpp
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
//	$Revision: 1.5 $
//
//  = DATE RELEASED
//	$Date: 2009/01/16 20:33:25 $
//
//  = COMMENTTEXT
//	Comments

#ifndef MHL7SpeakerISIN
#define MHL7SpeakerISIN

#include <iostream>
#include <string>

using namespace std;

class MHL7Msg;

class MHL7Speaker
// = TITLE
//	Short title/description
//
// = DESCRIPTION
//	Describe the class and how to use it
{
public:
  // = The standard methods in this framework.
  MHL7Speaker();
  ///< Default constructor
  MHL7Speaker(const MHL7Speaker& cpy);
  virtual ~MHL7Speaker();
  virtual void printOn(ostream& s) const;
  /**<\brief This method is used in conjunction with the streaming operator <<
   to print the current state of MHL7Speaker */

  virtual void streamIn(istream& s);
  
  // = Class specific methods.

  virtual void pushORM(const MHL7Msg& msg);
  ///< Push an ORM message to this object.  
  ///< Object is responsible for processing the message and providing a response.

private:
};

inline ostream& operator<< (ostream& s, const MHL7Speaker& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MHL7Speaker& c) {
  c.streamIn(s);
  return s;
}

#endif
