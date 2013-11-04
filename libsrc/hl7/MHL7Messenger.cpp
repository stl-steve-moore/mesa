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

/* File: MHL7Messenger.cpp

Mesa HL7 Messenger base class. Is called by MHL7Handler
with a stream of HL7 characters. It translates the stream into an 
MHL7Msg object and passes it onto the "acceptHL7Msg" method.

That method should be redefined in a Local Messenger class to react
to the message.

Warning: The order of the #include files is crucial since ACE is very picky about it.

5/1999 FDS

*/

#include "ace/OS.h"
#include "MESA.hpp"
#include "MHL7Handler.hpp"
#include "MHL7Msg.hpp"
#include "MHL7Factory.hpp"
#include "MHL7Messenger.hpp"
#include "MLogClient.hpp"

MHL7Messenger::MHL7Messenger(MHL7Factory& factory) :
  mVerbose(0),
  mFactory(factory),
  mHandler(0),
  mStreamSize(STREAMSIZE),
  mListening(1)
{
  if (! (mStream = new char[STREAMSIZE]))
    cerr << "(MHL7Messenger constructor) \
Cannot allocate stream buffer memory. Cannot send HL7 messages.\n";    
}

MHL7Messenger::MHL7Messenger(const MHL7Messenger& cpy) :
  mVerbose(cpy.mVerbose),
  mFactory(cpy.mFactory),
  mHandler(cpy.mHandler),
  mStreamSize(cpy.mStreamSize),
  mListening(cpy.mListening)
{
  if (! (mStream = new char[mStreamSize]))
           ACE_ERROR ((LM_ERROR,
                           "(%P|%t) Cannot allocate stream buffer memory\n"));    
}

MHL7Messenger*
MHL7Messenger::clone ()
{
  MHL7Messenger* clone = new MHL7Messenger (mFactory);
  return clone;
}

MHL7Messenger::~MHL7Messenger()
{
}

void
MHL7Messenger::printOn(ostream& s) const
{
  s << "MHL7Messenger";
}

void
MHL7Messenger::streamIn(istream& s)
{
  //s >> this->member;
}

// Non-boilerplate methods below


int
MHL7Messenger::sendHL7Message(MHL7Msg& message)
{
  int length = 0;

  //Serialize message for network transmission
  message.exportToWire(mStream, mStreamSize, length);

  if (mVerbose)
    cout << "MHL7Messenger about to send message of length "
	 << length
	 << endl;

  if (mHandler) {
    if (strlen(mStream)) {
      mHandler->handle_output (mStream, length);
    }
    else {
      cout << "(MHL7Messenger sendHL7Message) I have been asked to send an empty string, \
check the HL7 input file.\n";
      return -1;
    }
  }
  else {			// No handler available
#if 0
    cerr << "(MHL7Messenger sendHL7Message) \
My Handler must open() me before I send a message. I dont know whom to send to.\n";
    return -1;
#else
    return 0;
#endif
  }

  return 0;
}

int
MHL7Messenger::sendSlowly (MHL7Msg& message)
{
  int length = 0;

  //Serialize message for network transmission
  message.exportToWire(mStream, mStreamSize, length);

  if (mHandler) {
    mHandler->sendSlowly (mStream, length);
    cout << "(MHL7Messenger sendSlowly) Sent a " <<  length << " byte message in fragments\n";
  }
  else {
    cerr << "(MHL7Messenger sendHL7Message) \
The Handler must open() me before I send a message.\n";
    return -1;
  }

  return 0;
}  

int
MHL7Messenger::acceptStream(const char* HL7stream, int len)
{
  MLogClient logClient;
  char txt[128];
  sprintf(txt, "Accepting HL7 Stream of length: %d", len);

  logClient.log(MLogClient::MLOG_VERBOSE,
                this->mHandler->getPeerName(),
                "MHL7Messenger::acceptStream",
                __LINE__,
                txt);

  this->logHL7Stream(HL7stream, len);

  // Factory will parse the raw HL7 stream
  MHL7Msg* msg = mFactory.produce(HL7stream, len);
  int rtnStatus = this->acceptHL7Message(*msg);

  delete msg;
 
  return rtnStatus;
}

// virtual
void
MHL7Messenger::logHL7Stream(const char* HL7stream, int len)
{
}

int
MHL7Messenger::acceptHL7Message(MHL7Msg& message)
{
  MString msgType = message.getValue("MSH", 9, 1);
  MString event = message.getValue("MSH", 9, 2);

  if (mVerbose)
    cout << "MHL7Messenger accept HL7 Message of type "
	 << msgType << ":" << event
	 << endl;

  int rtnStatus = 0;

  if (msgType == "ADT")
    rtnStatus = this->acceptADT(message, event);
  else if (msgType == "ORM")
    rtnStatus = this->acceptORM(message, event);
  else if (msgType == "ACK")
    rtnStatus = this->acceptACK(message, event);
  else if (msgType == "ORR")
    rtnStatus = this->acceptORR(message, event);
  else if (msgType == "XXX")
    rtnStatus = this->acceptXXX(message, event);
  else if (msgType == "ORU")
    rtnStatus = this->acceptORU(message, event);
  else if (msgType == "BAR")
    rtnStatus = this->acceptBAR(message, event);
  else if (msgType == "DFT")
    rtnStatus = this->acceptDFT(message, event);
  else {
    string s;

    cout << "(Messenger) Received an HL7 message: " << endl;
    
    s = message.firstSegment();
    while (s != "") {
      cerr << s << endl;
      s = message.nextSegment();
    }
  }

  return rtnStatus;
}

// virtual
int
MHL7Messenger::acceptADT(MHL7Msg& message, const MString& event)
{
  cout << event << endl;
  return 0;
}

// virtual
int
MHL7Messenger::acceptORM(MHL7Msg& message, const MString& event)
{
  cout << event << endl;
  return 0;
}

// virtual
int
MHL7Messenger::acceptORR(MHL7Msg& message, const MString& event)
{
  cout << event << endl;
  return 0;
}

// virtual
int
MHL7Messenger::acceptACK(MHL7Msg& message, const MString& event)
{
  cout << event << endl;
  return 0;
}

// virtual
int
MHL7Messenger::acceptXXX(MHL7Msg& message, const MString& event)
{
  cout << event << endl;
  return 0;
}

// virtual
int
MHL7Messenger::acceptORU(MHL7Msg& message, const MString& event)
{
  cout << event << endl;
  return 0;
}

// virtual
int
MHL7Messenger::acceptBAR(MHL7Msg& message, const MString& event)
{
  cout << event << endl;
  return 0;
}

// virtual
int
MHL7Messenger::acceptDFT(MHL7Msg& message, const MString& event)
{
  cout << event << endl;
  return 0;
}

int
MHL7Messenger::open (MHL7Handler* handler)
{
  mHandler = handler;
  mListening=1;
  return 0;
}

int
MHL7Messenger::close ()
{
  mListening=0;			// we can stop listening to reactor->handle_events
  if (mHandler)
    mHandler->reset();		// Close the socket and unregister from the reactor
  return 0;
}

void
MHL7Messenger::destroy ()
{
  delete mStream;
  delete this;
}


void
MHL7Messenger::verbose(int verbose)
{
  mVerbose = verbose;
}
