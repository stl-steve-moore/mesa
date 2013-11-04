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

// $Id: MLMessenger.hpp,v 1.2 2000/05/09 19:06:54 smm Exp $ $Author: smm $ $Revision: 1.2 $ $Date: 2000/05/09 19:06:54 $ $State: Exp $
// ====================
//  = LIBRARY
//	hl7
//
//  = FILENAME
//	MLMessenger.hpp (Mesa ADT Messenger)
//
//  = AUTHOR
//	PD
//
//  = COPYRIGHT
//	Copyright Washington University, 1999
//
// ====================
//
//  = VERSION
//	$Revision: 1.2 $
//
//  = DATE RELEASED
//	$Date: 2000/05/09 19:06:54 $
//
//  = COMMENTTEXT
// Serves as the HL7 message interface for the Order Filler. Extends the
// MHL7Messenger class.

#ifndef MLMessengerISIN
#define MLMessengerISIN

#include <iostream>

#include "MHL7Messenger.hpp"

class MDBADT;

using namespace std;

class MLMessenger : public MHL7Messenger
{
public:
  //MLMessenger();
  // Default constructor
  MLMessenger(const MLMessenger& cpy);
  ~MLMessenger();
  virtual void printOn(ostream& s) const;
  // This method is used in conjunction with the streaming operator <<
  // to print the current state of MLMessenger

  virtual void streamIn(istream& s);

  // = Class specific methods.

  MLMessenger(MHL7Factory& factory, MDBADT& database);

  acceptADT(MHL7Msg& message, const MString& event);
  acceptORM(MHL7Msg& message, const MString& event);

private:
  MDBADT& mDatabase;
  // The database reference for storing messages.   
};  

inline istream& operator >> (istream& s, MLMessenger& c) {
  c.streamIn(s);
  return s;
}

#endif
