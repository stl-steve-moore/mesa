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
#include "MLDispatchQueryDiscontinue.hpp"
#include "MHL7Factory.hpp"
#include "MHL7Msg.hpp"
#include "MHL7DomainXlate.hpp"

#include "MLogClient.hpp"
#include "MFileOperations.hpp"

#if 0
MLDispatchQueryDiscontinue::MLDispatchQueryDiscontinue()
{
}
#endif

MLDispatchQueryDiscontinue::MLDispatchQueryDiscontinue(const MLDispatchQueryDiscontinue& cpy) :
 MLDispatch(cpy.mFactory)
{
}

MLDispatchQueryDiscontinue::~MLDispatchQueryDiscontinue ()
{
}

void
MLDispatchQueryDiscontinue::printOn(ostream& s) const
{
  s << "MLDispatchQueryDiscontinue" << endl;
}

void
MLDispatchQueryDiscontinue::streamIn(istream& s)
{
  //s >> this->member;
}

// Non-boiler plate methods follow below

MLDispatchQueryDiscontinue::MLDispatchQueryDiscontinue(MHL7Factory& factory) :
  MLDispatch(factory)
{
}


// virtual
int
MLDispatchQueryDiscontinue::acceptACK(MHL7Msg& message, const MString& event)
{
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_CONVERSATION,
		"peer",
		"MLDispatchQueryDiscontinue::acceptACK",
		__LINE__,
		MString("Accepting ACK event ")+event);
  mAcknowledgementCode = message.getValue("MSA", 1, 0);
  this->receivedAckMessage(true);

  this->storeMessage(message);
  return 0;  
}

int
MLDispatchQueryDiscontinue::acceptRSP(MHL7Msg& message, const MString& event)
{
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_CONVERSATION,
		"peer",
		"MLDispatchQueryDiscontinue::acceptACK",
		__LINE__,
		MString("Accepting ACK event ")+event);
//  cout << "RSP RSP RSP" << endl;
  this->storeMessage(message);
  MString s = message.firstSegment();
  MString discontinueFlag = "";
  while (s != "" && discontinueFlag == "") {
    if (s == "DSC") {
      discontinueFlag = message.getValue(1, 0);
    }
    s = message.nextSegment();
  }
  cout << "Discontinue: " << discontinueFlag << endl;
  MHL7Msg* ack = mFactory.produceACK(message);
  if (discontinueFlag == "") {
    mTransactionComplete = true;
  } else {
    ack->setValue("MSH", 14, 0, discontinueFlag);
  }
  mHandler->sendHL7Message(*ack);
  delete ack;

  return 0;  
}

//void
//MLDispatchQueryDiscontinue::setOutputPath(const MString& path)
//{
//  mOutputPath = path;
//}

// Private methods below here

#if 0
void
MLDispatchQueryDiscontinue::storeMessage(MHL7Msg& message)
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


