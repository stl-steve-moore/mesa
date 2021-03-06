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

// $Id: MAMessenger.hpp,v 1.3 2000/05/09 03:33:31 smm Exp $ $Author: smm $ $Revision: 1.3 $ $Date: 2000/05/09 03:33:31 $ $State: Exp $
// ====================
//  = LIBRARY
//	im_hl7ps Analysis mode
//
//  = FILENAME
//	MAMessenger.hpp
//
//  = AUTHOR
//	CJT
//
//  = COPYRIGHT
//	Copyright Washington University, 1999
//
// ====================
//
//  = VERSION
//	$Revision: 1.3 $
//
//  = DATE RELEASED
//	$Date: 2000/05/09 03:33:31 $
//
//  = COMMENTTEXT
// The local messenger used in the "Analysis" mode. It will log recieved messages
// to files for later inspection.

// Extends the MHL7Messenger class.  This class contains the application
// specific details of how to manage HL7 messages that are received
// and/or to be sent.

#ifndef MAMessengerISIN
#define MAMessengerISIN

#include <iostream>

#include "MLMessenger.hpp"

using namespace std;

class MAMessenger : public MLMessenger
{
public:
  //MAMessenger();
  // Default constructor
  MAMessenger(const MAMessenger& cpy);
  ~MAMessenger();
  virtual void printOn(ostream& s) const;
  // This method is used in conjunction with the streaming operator <<
  // to print the current state of MAMessenger

  virtual void streamIn(istream& s);

  // = Class specific methods.
  MAMessenger (MHL7Factory& factory, MDBImageManager& mDatabase, MString LogDir);
  
  MAMessenger* clone();

  int acceptADT(MHL7Msg& message, const MString& event);
  int acceptORM(MHL7Msg& message, const MString& event);

private:
  int logMsg (MHL7Msg& message, const MString& event, char* hl7Type);
  // Helper routine to log hl7 messages to a file.

private:
  MString mLogDir;
  // The location to store logged messages
};  

inline istream& operator >> (istream& s, MAMessenger& c) {
  c.streamIn(s);
  return s;
}

#endif
