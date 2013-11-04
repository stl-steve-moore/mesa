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
#include "MHL7Reactor.hpp"
#include "MHL7ProtocolHandlerLLP.hpp"
#include "MNetworkProxy.hpp"
#include "MLogClient.hpp"



MHL7Reactor::MHL7Reactor() :
  mHandler(0)
{
}

MHL7Reactor::MHL7Reactor(const MHL7Reactor& cpy) :
  mHandler(cpy.mHandler)
{
}

MHL7Reactor::~MHL7Reactor()
{
}

void
MHL7Reactor::printOn(ostream& s) const
{
  s << "MHL7Reactor";
}

void
MHL7Reactor::streamIn(istream& s)
{
  //s >> this->member;
}

// Non-boilerplate methods follow.

int
MHL7Reactor::registerHandler(MHL7ProtocolHandlerLLP* handler)
{
  mHandler = handler;
  return 0;
}

int
MHL7Reactor::processRequests(unsigned long count)
{
  MLogClient logClient;

  logClient.log(MLogClient::MLOG_VERBOSE,
	"MHL7Reactor::processRequests entered the method to process requests");

  if (mHandler == 0)
    return -1;

  MNetworkProxy* p = mHandler->getNetworkProxy();
  if (p == 0)
    return -1;

  CTN_SOCKET s = p->getSocket();
  if (s == -1)
    return -1;

  struct timeval t;
  int nfound;

  bool done = false;
  int status = 0;
  int returnValue = 0;
  {
    char tmp[256];
    strstream t(tmp, sizeof(tmp));
    t << "About to enter HL7 polling loop with socket number: " << s << '\0';
    logClient.logTimeStamp(MLogClient::MLOG_VERBOSE, tmp);
  }
  int loopCounter = 0;
  while (!done) {
    fd_set fdset;
    FD_ZERO(&fdset);
    FD_SET(s, &fdset);
    t.tv_sec = 1;		// second
    t.tv_usec = 0;

    if (loopCounter < 3) {
      logClient.logTimeStamp(MLogClient::MLOG_VERBOSE,
		"About to poll for socket activity");
      loopCounter++;
    } else if (loopCounter == 3) {
      logClient.logTimeStamp(MLogClient::MLOG_VERBOSE,
		"We have printed the polling message 3 times; contininue polling but stop verbose output");
      loopCounter++;
    } else {
      // We just don't want to print any more polling messages.
      // Nor do we want to increment the loop counter
    }
    nfound = select(s + 1, &fdset, NULL, NULL, &t);
    if (nfound > 0) {
      logClient.logTimeStamp(MLogClient::MLOG_VERBOSE,
	"System call select returned a value indicating socket activity");
      if (! FD_ISSET(s, &fdset)) {
      logClient.logTimeStamp(MLogClient::MLOG_ERROR,
	"In HL7 Reactor select loop, select indicated activity, but FD_ISSET did not");
      }
    }
    if ((nfound > 0) && (FD_ISSET(s, &fdset))) {
      loopCounter = 0;			// Reset the loop counter for the next go round
      logClient.logTimeStamp(MLogClient::MLOG_VERBOSE,
	"HL7 Reactor is about to invoke the handler->handleInput method");
      status = mHandler->handleInput();
      if (status == -1) {		// The socket is closed
	returnValue = 1;
	done = true;
      } else if (status == 0) {		// Partial message
      } else if (status == 1) {		// Complete message
        if (count != 0) {
	  count--;
	  if (count == 0)
	    done = true;
	  returnValue = 0;
	}
      } else {				// Illegal return value
	done = true;
	logClient.log(MLogClient::MLOG_ERROR,
		"Illegal return vaue from handler's handleInput method");
	returnValue = -2;
      }
    }
  }

  return returnValue;
}
