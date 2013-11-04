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
#include <strstream>

#include "MESA.hpp"
#include "MHL7ProtocolHandlerLLP.hpp"
#include "MLDispatchQueryContinue.hpp"
#include "MHL7Factory.hpp"
#include "MHL7Msg.hpp"
#include "MHL7DomainXlate.hpp"

#include "MLogClient.hpp"
#include "MFileOperations.hpp"

#if 0
MLDispatchQueryContinue::MLDispatchQueryContinue()
{
}
#endif

MLDispatchQueryContinue::MLDispatchQueryContinue(const MLDispatchQueryContinue& cpy) :
 MLDispatch(cpy.mFactory),
 mQueryMessage(0),
 mOriginalMessageControlID(""),
 mControlIDIndex(1)
{
}

MLDispatchQueryContinue::~MLDispatchQueryContinue ()
{
}

void
MLDispatchQueryContinue::printOn(ostream& s) const
{
  s << "MLDispatchQueryContinue" << endl;
}

void
MLDispatchQueryContinue::streamIn(istream& s)
{
  //s >> this->member;
}

// Non-boiler plate methods follow below

MLDispatchQueryContinue::MLDispatchQueryContinue(MHL7Factory& factory) :
  MLDispatch(factory),
 mQueryMessage(0),
 mOriginalMessageControlID(""),
 mControlIDIndex(1)
{
}


// virtual
int
MLDispatchQueryContinue::acceptACK(MHL7Msg& message, const MString& event)
{
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_CONVERSATION,
		"peer",
		"MLDispatchQueryContinue::acceptACK",
		__LINE__,
		MString("Accepting ACK event ")+event);
  mAcknowledgementCode = message.getValue("MSA", 1, 0);
  this->receivedAckMessage(true);

  this->storeMessage(message);

  logClient.logTimeStamp(MLogClient::MLOG_ERROR,
	"MLDisplatchQueryContinue::acceptACK received an ACK while expecting different messages (RSP); this is most likely an error");

  return 0;  
}

int
MLDispatchQueryContinue::acceptRSP(MHL7Msg& message, const MString& event)
{
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_CONVERSATION,
		"peer",
		"MLDispatchQueryContinue::acceptACK",
		__LINE__,
		MString("Accepting ACK event ")+event);
//  cout << "RSP RSP RSP" << endl;
  this->storeMessage(message);

  MString s = message.firstSegment();
  MString continuationPointer = "";
  while (s != "" && continuationPointer == "") {
    if (s == "DSC") {
      continuationPointer = message.getValue(1, 0);
    }
    s = message.nextSegment();
  }

  if (continuationPointer == "") {
    logClient.logTimeStamp(MLogClient::MLOG_CONVERSATION,
	"Continuation pointer is empty; assume this is the last response");
    // Then, this is the last of the responses and there is nothing
    // else to see.
    mTransactionComplete = true;
//    MHL7Msg* ack = mFactory.produceACK(message);
//    ack->setValue("MSH", 14, 0, continuationPointer);
//    mHandler->sendHL7Message(*ack);
//    delete ack;
  } else {
    logClient.logTimeStamp(MLogClient::MLOG_CONVERSATION,
	MString("Peer returned continuation pointer: <")
	+ continuationPointer
	+ ">; send them another copy of the query with modified MSH-10");

    // Generate and set a new Message Control ID
    char buf[256] = "";
    strstream ss(buf, sizeof(buf));
    ss << mOriginalMessageControlID << mControlIDIndex << '\0';
    mControlIDIndex++;
    mQueryMessage->setValue("MSH", 10, 0, buf);

    // Now set the Continuation Pointer in the query we
    // will resend
    s = "";
    s = mQueryMessage->firstSegment();
    bool foundSegment = false;
    while (s != "" && !foundSegment) {
      if (s == "DSC") {
	mQueryMessage->setValue(1, 0, continuationPointer);
	mQueryMessage->setValue(2, 0, "I");
        foundSegment = true;
      }
      s = mQueryMessage->nextSegment();
    }
    if (!foundSegment) {
      mQueryMessage->insertSegment("DSC");
      mQueryMessage->setValue(1, 0, continuationPointer);
      mQueryMessage->setValue(2, 0, "I");
    }
    mHandler->sendHL7Message(*mQueryMessage);
  }

  logClient.log(MLogClient::MLOG_CONVERSATION,
		"peer",
		"MLDispatchQueryContinue::acceptACK",
		__LINE__,
		"Exit method");
  return 0;  
}

//void
//MLDispatchQueryContinue::setOutputPath(const MString& path)
//{
//  mOutputPath = path;
//}

// Private methods below here

#if 0
void
MLDispatchQueryContinue::storeMessage(MHL7Msg& message)
{
  char buf[1024];
  strstream s (buf, sizeof(buf));
  if (mOutputPath == "") {
    s << "./" << mMessageNumber << '\0';
  } else {
    s << mOutputPath << "/" << mMessageNumber << '\0';
  }

  mMessageNumber++;
  message.saveAs(buf);
}
#endif


void
MLDispatchQueryContinue::registerHL7Message(MHL7Msg* message)
{
  mQueryMessage = message;
  mOriginalMessageControlID = message->getValue("MSH", 10, 0);
}

