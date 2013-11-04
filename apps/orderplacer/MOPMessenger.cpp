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

/* File: MOPMessenger.cpp

The Mesa Order Placer Messenger. Does the work after
getting a MHL7Msg. Will translate the message into a 
MPatient or MVisit object, and insert it into the database.

*/

#include "MOPMessenger.hpp"

MOPMessenger::MOPMessenger (MHL7Factory& factory) :
  MHL7Messenger::MHL7Messenger(factory)
{
}

MOPMessenger::MOPMessenger(MHL7Factory& factory, MDBInterface& database) :
  MHL7Messenger::MHL7Messenger(factory),
  mDatabase(database)
{
}

MOPMessenger::MOPMessenger(const MOPMessenger& cpy) :
  MHL7Messenger::MHL7Messenger(cpy),
  mDatabase(cpy.mDatabase)
{
}

MOPMessenger*
MOPMessenger::clone () 
{
  MOPMessenger* clone = new MOPMessenger (mFactory, mDatabase);
  return clone;
}

MOPMessenger::~MOPMessenger ()
{
}

int
MOPMessenger::acceptHL7Message(MHL7Msg& message)
{
  string s;

  cout << "(Order Placer Messenger) Recieved an HL7 message: " << endl;

  s = message.firstSegment();
  while (s != "") {
    cerr << s << endl;
    s = message.nextSegment();
  }

  // Send ACK slowly (send 1/2 message, wait 1s, send other 1/2)
  MHL7Msg *ack = mFactory.produceACK(message);
  this->sendSlowly(*ack);
  //this->sendHL7Message(*ack);

  // Translate HL7 message into a MPatient object
//   MHL7DomainXlate translator;
//   MPatient patient;
//   translator.translateHL7 (message, patient);

  // cout << "(Order Placer Messenger) Translated message into an MPatient object\n";

  // Insert message into database
  //mDatabase.insert (patient);

  cout << "(Order Placer Messenger) Sent ack.\n";


  return 0;  
}
