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
#include "MLDispatch.hpp"
#include "MHL7Factory.hpp"
#include "MHL7Msg.hpp"
#include "MHL7DomainXlate.hpp"

#include "MLogClient.hpp"
#include "MFileOperations.hpp"

#if 0
MLDispatch::MLDispatch()
{
}
#endif

MLDispatch::MLDispatch(const MLDispatch& cpy) :
 MHL7Dispatcher(cpy.mFactory)
{
}

MLDispatch::~MLDispatch ()
{
}

void
MLDispatch::printOn(ostream& s) const
{
  s << "MLDispatch" << endl;
}

void
MLDispatch::streamIn(istream& s)
{
  //s >> this->member;
}

// Non-boiler plate methods follow below

MLDispatch::MLDispatch(MHL7Factory& factory) :
  MHL7Dispatcher(factory),
  mMessageNumber(1000),
  mTransactionComplete(false),
  mOutputPath(""),
  mReceivedAck(false)
{
}


// virtual
int
MLDispatch::acceptACK(MHL7Msg& message, const MString& event)
{
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_CONVERSATION,
		"peer",
		"MLDispatch::acceptACK",
		__LINE__,
		MString("Accepting ACK event ")+event);
  mTransactionComplete = true;
  mAcknowledgementCode = message.getValue("MSA", 1, 0);
  mReceivedAck = true;

  return 0;  
}

//virtuals
int
MLDispatch::acceptORR(MHL7Msg& message, const MString& event)
{
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_CONVERSATION,
		"peer",
		"MLDispatch::acceptORR",
		__LINE__,
		MString("Accepting ORR event ")+event);
  mTransactionComplete = true;
  mAcknowledgementCode = message.getValue("MSA", 1, 0);
  mReceivedAck = true;

  return 0;  
}

int
MLDispatch::acceptRSP(MHL7Msg& message, const MString& event)
{
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_CONVERSATION,
		"peer",
		"MLDispatch::acceptACK",
		__LINE__,
		MString("Accepting ACK event ")+event);
  mAcknowledgementCode = message.getValue("MSA", 1, 0);
  mReceivedAck = true;
  return 0;  
}

void
MLDispatch::setOutputPath(const MString& path)
{
  mOutputPath = path;
}

void
MLDispatch::setTransactionComplete(bool flag)
{
  mTransactionComplete = flag;
}

bool
MLDispatch::transactionComplete( ) const
{
  return mTransactionComplete;
}

void
MLDispatch::receivedAckMessage(bool flag)
{
  mReceivedAck = flag;
}

bool
MLDispatch::receivedAckMessage( ) const
{
  return mReceivedAck;
}

void
MLDispatch::registerHL7Message(MHL7Msg* message)
{
}


// Private methods below here

void
MLDispatch::storeMessage(MHL7Msg& message)
{
  char buf[1024];
  strstream s (buf, sizeof(buf));
  if (mOutputPath == "") {
    s << "./" << mMessageNumber << ".hl7" << '\0';
  } else {
    s << mOutputPath << "/" << mMessageNumber << ".hl7" << '\0';
  }

  mMessageNumber++;
  message.saveAs(buf);
}


