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

/* File: MHL7LLPHandler.cpp

The method definitions for the class MHL7LLPHandler derived from MHL7Handler.
Based on Schmidt's ACE tutorial 005:
http://www.cs.wustl.edu/~schmidt/ACE_wrappers/docs/tutorials/005/page05.html

FDS 5/1999

*/

#include "ace/OS.h"
#include "MESA.hpp"
#include "MHL7LLPHandler.hpp"
#include "MHL7Acceptor.hpp"
#include "MLogClient.hpp"

#ifdef _WIN32
#include "winbase.h"
#endif


MHL7LLPHandler::MHL7LLPHandler (MHL7Messenger& messenger) :
  MHL7Handler(messenger),
  mInFrame(0),
  mEndBlock(0)
{
}

MHL7LLPHandler::~MHL7LLPHandler (void)
{
}

MHL7Handler*
MHL7LLPHandler::clone (MHL7Messenger& messenger) 
{
  MHL7LLPHandler* clone = new MHL7LLPHandler (messenger);
  if (mVerbose)
    clone->verbose(1);

  return clone;
}


void
MHL7LLPHandler::printOn(ostream& s) const
{
  s << "Mesa HL7 LLP Handler";
}

void
MHL7LLPHandler::streamIn(istream& s)
{
  //s >> this->member;
}

/* "handle_input" is the method called by the reactor to accept
incoming messages from the client. This one uses the LLP protocol
to deframe messages.
 
The ACE Reactor will buffer incoming messages so none will be lost
even if the "acceptStream" task takes a long time to complete.
 
If we recieve a message which is zero bytes long, that's a signal that
the client has disconnected. Handle_input() will then exit with a -1
and its handle_close method will be called by the reactor.

 */     
int 
MHL7LLPHandler::handle_input (ACE_HANDLE handle)
{
  ACE_UNUSED_ARG (handle);
  char buffer[FRAMESIZE];
  int bytecount;
  int rtnStatus = 0;

  bytecount = this->peer().recv (buffer, FRAMESIZE);
  if (bytecount >= 0)
    buffer[bytecount] = '\0';

  char txt[1024];
  MLogClient logClient;
  sprintf(txt, "Received fragment of length: %d", bytecount);

  logClient.log(MLogClient::MLOG_VERBOSE,
		this->getPeerName(),
                "MHL7LLPHandler::handle_input",
                __LINE__,
		txt);

  if (mCaptureInputStream) {
    ofstream f("hl7stream.xxx", ios::app | ios::binary);
    f.write(buffer, bytecount);
  }

  switch (bytecount) {
  case -1:
    logClient.log(MLogClient::MLOG_ERROR,
		this->getPeerName(),
                "MHL7LLPHandler::handle_input",
                __LINE__,
		"Error reading from input socket");
    return -1;
  case 0:
    logClient.log(MLogClient::MLOG_CONVERSATION,
		this->getPeerName(),
                "MHL7LLPHandler::handle_input",
                __LINE__,
		"Closing connection with client");
    return -1;

  default:
    {		      // HL7 LLP Deframing machine: <0x0b>---frame data---<0x1c><0x0d>
      for (int i=0; i<bytecount; i++) {
	if (!mInFrame) {
	  {
	    int c = buffer[i];
	    sprintf(txt, "MHL7LLP looking to start frame with 0x0b: %02x", c);

	    logClient.log(MLogClient::MLOG_VERBOSE,
			  this->getPeerName(),
			  "MHL7LLPHandler::handle_input",
			  __LINE__,
			  txt);
	  }
	  if (buffer[i] == 0x0b) {
	    mInFrame = 1;
	  }
	}
	else  {
	  if (buffer[i] == 0x0b) { // found a start flag in middle of frame
	    logClient.log(MLogClient::MLOG_VERBOSE,
			  this->getPeerName(),
			  "MHL7LLPHandler::handle_input",
			  __LINE__,
			  "MHL7LLP Found another 0x0b in a frame; resetting");

	    mStreamIndex=0;
	    mInFrame=1;
	    continue;
	  }
	  if (buffer[i] ==  0x1c) {
	    sprintf(txt,
		    "MHL7LLP Found 0x1c; nearing the end of a frame (%d/%d)",
		    i, bytecount);
	    logClient.log(MLogClient::MLOG_VERBOSE,
			  this->getPeerName(),
			  "MHL7LLPHandler::handle_input",
			  __LINE__,
			  txt);

	    mEndBlock=1;
	    continue;
	  }
	  if (mEndBlock && buffer[i] == 0x0d) {
	    sprintf(txt,
		    "MHL7LLP Found 0x0d; time to push the frame upstream (%d/%d)",
		    i, bytecount);

	    logClient.log(MLogClient::MLOG_VERBOSE,
			  this->getPeerName(),
			  "MHL7LLPHandler::handle_input",
			  __LINE__,
			  txt);

	    // Found the end of the HL7 frame, send up the stream
	    mStream[mStreamIndex] = '\0';
	    if (mMessenger.acceptStream ((const char *) mStream,
		    mStreamIndex) != 0) {
	      logClient.log(MLogClient::MLOG_VERBOSE,
			  this->getPeerName(),
			  "MHL7LLPHandler::handle_input",
			  __LINE__,
			  "Messenger returned status to end connection");

	      rtnStatus = -1;
	    }
	    mInFrame = 0;
	    mStreamIndex=0;
	  }
	  else {	// We are inside the frame.
	    if (mEndBlock) mEndBlock=0;
	    if ( mStreamIndex >= mStreamSize ) {
	      // Need to allocate more memory for stream buffer
	      if (! (mStream = (char *) realloc (mStream, mStreamSize *= 2)) ) {
		logClient.log(MLogClient::MLOG_VERBOSE,
			this->getPeerName(),
			"MHL7LLPHandler::handle_input",
			__LINE__,
			"Could not grow HL7 stream buffer");
		return -1;
	      }
	    }

	    mStream[mStreamIndex++] = buffer[i];
	  }
	}
      }
      // Finished examining HL7stream
    }
  }
  logClient.log(MLogClient::MLOG_VERBOSE,
		this->getPeerName(),
		"MHL7LLPHandler::handle_input",
		__LINE__,
		"MHL7LLP Finished examining this fragment");

  return rtnStatus;
}

/* Handle_output 
Takes an HL7 stream of characters, and frames it with the HL7 LLP framing flags.
It then uses the SOCKET from peer() to send the message
*/
int
MHL7LLPHandler::handle_output (const char* stream, int length)
{
  int i,j=0;
  // Add HL7 framing flags to stream. Use mFrame to build frame.
  mFrame[j++] = 0x0b;
  for (i=0; i<length; i++) {
    mFrame[j++] = stream[i];
  }
  mFrame[j++] = 0x1c;
  mFrame[j++] = 0x0d;
  mFrame[j] = '\0';

#if 0  
  if (mVerbose == -1) {
    char x[1024];
    cout << "MHL7LLPHandler::handle_output: About to send framed HL7 message ("
	 << j << " bytes)" << endl;
    cout << "0x0b <msg> 0x1c 0x0d" << endl;
    cout << "Hit <ENTER> to send the message ";
    cin.getline(x, sizeof(x));
  } else if (mVerbose != 0) {
    cout << "MHL7LLPHandler::handle_output: About to send framed HL7 message ("
	 << j << " bytes)" << endl;
  }
#endif

  char txtBuf[128];
  sprintf(txtBuf, "About to send framed HL7 message of size: %d", j);
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_VERBOSE,
		this->getPeerName(),
		"MHL7LLPHandler::handle_output",
		__LINE__,
		txtBuf);

  //Send framed HL7 message
  if (this->peer().send_n (mFrame, j) == -1) {
    logClient.log(MLogClient::MLOG_ERROR,
		this->getPeerName(),
		"MHL7LLPHandler::handle_output",
		__LINE__,
		"send to peer failed");
    return -1;
  }
  return 0;
}

int
MHL7LLPHandler::sendSlowly (const char* stream, int length)
{
  int i,j=0;
  int half = length / 2;
  // Send half the frame, wait 1s, send other half of frame. Used to test deframing machines.
  mFrame[j++] = 0x0b;
  for (i=0; i<half; i++) {
    mFrame[j++] = stream[i];
  }
  mFrame[j] = '\0';
  //Send first half of framed HL7 message
  MLogClient logClient;
  if (this->peer().send_n (mFrame, j) == -1) {
    logClient.log(MLogClient::MLOG_ERROR,
		this->getPeerName(),
		"MHL7LLPHandler::sendSlowly",
		__LINE__,
		"send to peer failed");
    return -1;
  }

#ifdef _WIN32
  ::Sleep(1000);
#else
  sleep(1);
#endif

  j=0;
  //int otherhalf = length - half;
  for (i=half; i<length; i++) {
    mFrame[j++] = stream[i];
  }
  
  mFrame[j++] = 0x1c;
  mFrame[j++] = 0x0d;
  mFrame[j] = '\0';
  
  //Send second half of framed HL7 message
  if (this->peer().send_n (mFrame, j) == -1) {
    logClient.log(MLogClient::MLOG_ERROR,
		this->getPeerName(),
		"MHL7LLPHandler::sendSlowly",
		__LINE__,
		"send to peer failed");
    return -1;
  }

  return 0;
}
