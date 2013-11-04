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

#include "ctn_os.h"
#include "MESA.hpp"
#include "MHL7ProtocolHandlerLLP.hpp"
#include "MHL7Msg.hpp"
#include "MHL7Factory.hpp"
#include "MHL7Dispatcher.hpp"
#include "MLogClient.hpp"

MHL7Dispatcher::MHL7Dispatcher(MHL7Factory& factory) :
  mVerbose(0),
  mFactory(factory),
  mHandler(0),
  mStreamSize(STREAMSIZE),
  mListening(1),
  mAcknowledgementCode("")
{
  if (! (mStream = new char[STREAMSIZE])) {
    cerr << "(MHL7Dispatcher constructor) \
Cannot allocate stream buffer memory. Cannot send HL7 messages.\n";    
  }
}

MHL7Dispatcher::MHL7Dispatcher(const MHL7Dispatcher& cpy) :
  mVerbose(cpy.mVerbose),
  mFactory(cpy.mFactory),
  mHandler(cpy.mHandler),
  mStreamSize(cpy.mStreamSize),
  mListening(cpy.mListening),
  mAcknowledgementCode(cpy.mAcknowledgementCode)
{
  if (! (mStream = new char[mStreamSize]))
    cerr << "(MHL7Dispatcher constructor) Cannot allocate stream buffer memory. Cannot send HL7 messages.\n";    
}

MHL7Dispatcher*
MHL7Dispatcher::clone ()
{
  MHL7Dispatcher* clone = new MHL7Dispatcher (mFactory);
  return clone;
}

MHL7Dispatcher::~MHL7Dispatcher()
{
  if (mStream != 0) {
    delete []mStream;
    mStream = 0;
  }
}

void
MHL7Dispatcher::printOn(ostream& s) const
{
  s << "MHL7Dispatcher";
}

void
MHL7Dispatcher::streamIn(istream& s)
{
  //s >> this->member;
}

// Non-boilerplate methods below


int
MHL7Dispatcher::sendHL7Message(MHL7Msg& message)
{
  int status;

  status = mHandler->sendHL7Message(message);

  return status;

#if 0
  int length = 0;

  //Serialize message for network transmission
  message.exportToWire(mStream, mStreamSize, length);

  if (mVerbose)
    cout << "MHL7Dispatcher about to send message of length "
	 << length
	 << endl;

  if (mHandler) {
    if (strlen(mStream)) {
      mHandler->writeBytes (mStream, length);
    }
    else {
      cout << "(MHL7Dispatcher sendHL7Message) I have been asked to send an empty string, \
check the HL7 input file.\n";
      return -1;
    }
  }
  else {			// No handler available
    return 0;
  }

  return 0;
#endif
}

int
MHL7Dispatcher::acceptStream(const char* HL7stream, int len)
{
  MLogClient logClient;
  char txt[128];
  sprintf(txt, "Accepting HL7 Stream of length: %d", len);

  logClient.log(MLogClient::MLOG_VERBOSE,
                "",
                "MHL7Dispatcher::acceptStream",
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
MHL7Dispatcher::logHL7Stream(const char* HL7stream, int len)
{
}

int
MHL7Dispatcher::acceptHL7Message(MHL7Msg& message)
{
  MString msgType = message.getValue("MSH", 9, 1);
  MString event = message.getValue("MSH", 9, 2);

  if (mVerbose)
    cout << "MHL7Dispatcher accept HL7 Message of type "
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
  else if (msgType == "QBP")
    rtnStatus = this->acceptQBP(message, event);
  else if (msgType == "RSP")
    rtnStatus = this->acceptRSP(message, event);
  else if (msgType == "SIU")
    rtnStatus = this->acceptSIU(message, event);
  else {
    string s;

    //cout << "(Messenger) Received an HL7 message: " << endl;
    
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
MHL7Dispatcher::acceptMessageApplicationError(MHL7Msg& message,
	const MString& event, const MString& ackCode, const MString& errorCondition)
{
  MHL7Msg* ack = mFactory.produceACK(message, "", ackCode, errorCondition);
  mHandler->sendHL7Message(*ack);
  delete ack;
  return 0;
}

// virtual
int
MHL7Dispatcher::acceptADT(MHL7Msg& message, const MString& event)
{
  //cout << event << endl;

  MHL7Msg* ack = mFactory.produceACK(message);
  mHandler->sendHL7Message(*ack);
  delete ack;
  return 0;
}

// virtual
int
MHL7Dispatcher::acceptSIU(MHL7Msg& message, const MString& event)
{
  //cout << event << endl;

  MHL7Msg* ack = mFactory.produceACK(message);
  mHandler->sendHL7Message(*ack);
  delete ack;
  return 0;
}

// virtual
int
MHL7Dispatcher::acceptORM(MHL7Msg& message, const MString& event)
{
  //cout << event << endl;
  MHL7Msg* ack = mFactory.produceACK(message);
  mHandler->sendHL7Message(*ack);
  delete ack;
  return 0;
}

// virtual
int
MHL7Dispatcher::acceptORM(MHL7Msg& message, const MString& event, const bool produceORR)
{
  //cout << event << endl;
  MHL7Msg* response = 0;
  if (produceORR) {
	response = mFactory.produceORR(message);
  }
  else {
	response = mFactory.produceACK(message);
  }  
  mHandler->sendHL7Message(*response);
  delete response;
  return 0;
}

// virtual
int
MHL7Dispatcher::acceptORR(MHL7Msg& message, const MString& event)
{
  //cout << event << endl;
  MHL7Msg* ack = mFactory.produceACK(message);
  mHandler->sendHL7Message(*ack);
  delete ack;
  return 0;
}

// virtual
int
MHL7Dispatcher::acceptACK(MHL7Msg& message, const MString& event)
{
  mAcknowledgementCode = message.getValue("MSA", 1, 0);
  //cout << "Ack code: " << mAcknowledgementCode << endl;
  //cout << event << endl;
  return 0;
}

// virtual
int
MHL7Dispatcher::acceptXXX(MHL7Msg& message, const MString& event)
{
  //cout << event << endl;
  MHL7Msg* ack = mFactory.produceACK(message);
  mHandler->sendHL7Message(*ack);
  delete ack;
  return 0;
}

// virtual
int
MHL7Dispatcher::acceptORU(MHL7Msg& message, const MString& event)
{
  //cout << event << endl;
  MHL7Msg* ack = mFactory.produceACK(message);
  mHandler->sendHL7Message(*ack);
  delete ack;
  return 0;
}

// virtual
int
MHL7Dispatcher::acceptBAR(MHL7Msg& message, const MString& event)
{
  //cout << event << endl;
  MHL7Msg* ack = mFactory.produceACK(message);
  mHandler->sendHL7Message(*ack);
  delete ack;
  return 0;
}

// virtual
int
MHL7Dispatcher::acceptDFT(MHL7Msg& message, const MString& event)
{
  //cout << event << endl;
  MHL7Msg* ack = mFactory.produceACK(message);
  mHandler->sendHL7Message(*ack);
  delete ack;
  return 0;
}

// virtual
int
MHL7Dispatcher::acceptQBP(MHL7Msg& message, const MString& event)
{
  //cout << event << endl;
  MHL7Msg* rsp = mFactory.produceRSP(message);
  mHandler->sendHL7Message(*rsp);
  delete rsp;
  return 0;
}

// virtual
int
MHL7Dispatcher::acceptRSP(MHL7Msg& message, const MString& event)
{
  mAcknowledgementCode = message.getValue("MSA", 1, 0);
  //cout << event << endl;
  return 0;
}

int
MHL7Dispatcher::registerHandler (MHL7ProtocolHandlerLLP* handler)
{
  mHandler = handler;
  mListening = 1;
  return 0;
}

int
MHL7Dispatcher::close ()
{
  mListening=0;			// we can stop listening to reactor->handle_events
#if 0
  if (mHandler)
    mHandler->reset();		// Close the socket and unregister from the reactor
#endif
  return 0;
}

void
MHL7Dispatcher::destroy ()
{
  delete mStream;
  delete this;
}


void
MHL7Dispatcher::verbose(int verbose)
{
  mVerbose = verbose;
}

MString
MHL7Dispatcher::acknowledgementCode() const
{
  return mAcknowledgementCode;
}

