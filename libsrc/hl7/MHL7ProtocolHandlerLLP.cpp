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
#include "MNetworkProxy.hpp"
#include "MHL7Msg.hpp"
#include "MHL7Dispatcher.hpp"
#include "MLogClient.hpp"

#ifdef _WIN32
#include "winbase.h"
#endif


MHL7ProtocolHandlerLLP::MHL7ProtocolHandlerLLP (MNetworkProxy* proxy) :
  mProxy(proxy),
  mDispatcher(0),
  mCaptureInputStream(false),
  mStreamIndex(0),
  mStreamSize(FRAMESIZE),
  mInFrame(0),
  mEndBlock(0),
  mCaptureFileName("")
{
  mStream = new char[FRAMESIZE];
  if (mStream == 0) {
    cout << "Unable to allocate buffer in MHL7ProtocolHandlerLLP::constructor" << endl;
    ::exit(1);
  }
  ::memset(mStream, 0, FRAMESIZE);
}

MHL7ProtocolHandlerLLP::~MHL7ProtocolHandlerLLP (void)
{
  if (mStream != 0) {
    delete []mStream;
  }
}

void
MHL7ProtocolHandlerLLP::printOn(ostream& s) const
{
  s << "Mesa HL7 LLP Handler";
}

void
MHL7ProtocolHandlerLLP::streamIn(istream& s)
{
  //s >> this->member;
}

int
MHL7ProtocolHandlerLLP::sendHL7Message(MHL7Msg& msg)
{
  MLogClient logClient;
  int exportedLength = 0;
  char hl7Stream[1024*1024] = "";
  int j = 0;
  // Add HL7 framing flags to stream. Use mFrame to build frame.

  hl7Stream [j++] = 0x0b;

  msg.exportToWire(&hl7Stream[j], sizeof(hl7Stream)-j, exportedLength);
  if (exportedLength <= 0)
    return -1;

  j += exportedLength;

  hl7Stream[j++] = 0x1c;
  hl7Stream[j++] = 0x0d;
  hl7Stream[j] = '\0';

  char tmp[384];
  ::sprintf(tmp, "MHL7ProtocolHandlerLLP::send HL7Message About to write HL7 message of length %d to network", j);
  logClient.log(MLogClient::MLOG_VERBOSE, tmp);

  int rtnStatus = 0;
  if (mProxy->writeBytes(hl7Stream, j) != j) {
    rtnStatus = -1;
  }

  return rtnStatus;
}

MNetworkProxy*
MHL7ProtocolHandlerLLP::getNetworkProxy()
{
  return mProxy;
}

int
MHL7ProtocolHandlerLLP::registerDispatcher(MHL7Dispatcher* dispatcher)
{
  mDispatcher = dispatcher;
  return 0;
}

int 
MHL7ProtocolHandlerLLP::handleInput ()
{
  char buffer[FRAMESIZE];
  int bytecount;
  int rtnStatus = 0;		// Successful return, partial message received

  char txt[1024];
  MLogClient logClient;

  bytecount = mProxy->readUpToNBytes(buffer, FRAMESIZE);
  if (bytecount < 0) {
    ::sprintf(txt, "Network proxy returned byte count %d, socket probably closed", bytecount);
    logClient.log(MLogClient::MLOG_VERBOSE,
		"",
                "MHL7ProtocolHandlerLLP::handleInput",
                __LINE__,
		txt);
    return -1;
  }

  buffer[bytecount] = '\0';

  sprintf(txt, "Received fragment of length: %d", bytecount);

  logClient.log(MLogClient::MLOG_VERBOSE,
		"",
                "MHL7ProtocolHandlerLLP::handleInput",
                __LINE__,
		txt);

  int idx = 0;
//  for (idx = 0; idx < bytecount; idx++) {
//    logClient.log(MLogClient::MLOG_VERBOSE, buffer[idx]);
//  }
  // Dump the HL7 stream without any decoration.
  logClient.log(MLogClient::MLOG_VERBOSE, bytecount, buffer);
  logClient.log(MLogClient::MLOG_VERBOSE, '\n');

  logClient.log(MLogClient::MLOG_VERBOSE,
		"",
                "MHL7ProtocolHandlerLLP::handleInput",
                __LINE__,
		"Just dumped HL7 Stream");


  if (mCaptureInputStream) {
    char localFile[1024];
    if (mCaptureFileName != "") {
      mCaptureFileName.safeExport(localFile, sizeof(localFile));
    } else {
      ::strcpy(localFile, "hl7stream.xxx");
    }
    ofstream f(localFile, ios::app | ios::binary);
    f.write(buffer, bytecount);
  }

  switch (bytecount) {
  case -1:
    logClient.log(MLogClient::MLOG_ERROR,
		"",
                "MHL7ProtocolHandlerLLP::handleInput",
                __LINE__,
		"Error reading from input socket");
    return -1;
  case 0:
    logClient.log(MLogClient::MLOG_CONVERSATION,
		"",
                "MHL7ProtocolHandlerLLP::handleInput",
                __LINE__,
		"Closing connection with client");
    return -1;

  default:
    {		      // HL7 LLP Deframing machine: <0x0b>---frame data---<0x1c><0x0d>
      for (int i=0; i < bytecount; i++) {
	if (!mInFrame) {
	  {
	    int c = buffer[i];
	    sprintf(txt, "MHL7LLP looking to start frame with 0x0b: %02x", c);

	    logClient.log(MLogClient::MLOG_VERBOSE,
			  "",
			  "MHL7ProtocolHandlerLLP::handleInput",
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
			  "",
			  "MHL7ProtocolHandlerLLP::handleInput",
			  __LINE__,
			  "MHL7ProtocolHandlerLLP Found another 0x0b in a frame; resetting");

	    mStreamIndex=0;
	    mInFrame=1;
	    continue;
	  }
	  if (buffer[i] ==  0x1c) {
	    sprintf(txt,
		    "MHL7LLP Found 0x1c; nearing the end of a frame (%d/%d)",
		    i, bytecount);
	    logClient.log(MLogClient::MLOG_VERBOSE,
			  "",
			  "MHL7ProtocolHandlerLLP::handleInput",
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
			  "",
			  "MHL7ProtocolHandlerLLp::handleInput",
			  __LINE__,
			  txt);

	    // Found the end of the HL7 frame, send up the stream
	    mStream[mStreamIndex] = '\0';
	    if (mDispatcher->acceptStream ((const char *) mStream,
		    mStreamIndex) == 0) {
	      rtnStatus = 1;			// Processed one complete message
	    } else {
	      logClient.log(MLogClient::MLOG_VERBOSE,
			  "",
			  "MHL7ProtocolHandlerLLP::handleInput",
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
			"",
			"MHL7ProtocolHandlerLLP::handle_input",
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
		"",
		"MHL7ProtocolHandlerLLP::handleInput",
		__LINE__,
		"MHL7LLP Finished examining this fragment");

  return rtnStatus;
}

void
MHL7ProtocolHandlerLLP::captureInputStream(bool flag, const MString& fileName)
{
  mCaptureInputStream = flag;
  mCaptureFileName = fileName;
}


#if 0
int 
MHL7ProtocolHandlerLLP::handle_input (ACE_HANDLE handle)
{
  ACE_UNUSED_ARG (handle);
  char buffer[FRAMESIZE];
  int bytecount;
  int rtnStatus = 0;

  bytecount = this->peer().recv (buffer, FRAMESIZE);
  buffer[bytecount] = '\0';

  char txt[1024];
  MLogClient logClient;
  sprintf(txt, "Received fragment of length: %d", bytecount);

  logClient.log(MLogClient::MLOG_VERBOSE,
		this->getPeerName(),
                "MHLLLPHandler::handle_input",
                __LINE__,
		txt);

  if (mCaptureInputStream) {
    char localFile[1024];
    if (mCaptureFileName != "") {
      mCaptureFileName.safeExport(localFile, sizeof(localFile));
    } else {
      ::strcpy(localFile, "hl7stream.xxx");
    }
    ofstream f(localFile, ios::app | ios::binary);
    f.write(buffer, bytecount);
  }

  switch (bytecount) {
  case -1:
    logClient.log(MLogClient::MLOG_ERROR,
		this->getPeerName(),
                "MHLLLPHandler::handle_input",
                __LINE__,
		"Error reading from input socket");
    return -1;
  case 0:
    logClient.log(MLogClient::MLOG_CONVERSATION,
		this->getPeerName(),
                "MHLLLPHandler::handle_input",
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
			  "MHLLLPHandler::handle_input",
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
			  "MHLLLPHandler::handle_input",
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
			  "MHLLLPHandler::handle_input",
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
			  "MHLLLPHandler::handle_input",
			  __LINE__,
			  txt);

	    // Found the end of the HL7 frame, send up the stream
	    mStream[mStreamIndex] = '\0';
	    if (mDispatcher->acceptStream ((const char *) mStream,
		    mStreamIndex) != 0) {
	      logClient.log(MLogClient::MLOG_VERBOSE,
			  this->getPeerName(),
			  "MHLLLPHandler::handle_input",
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
			"MHLLLPHandler::handle_input",
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
		"MHLLLPHandler::handle_input",
		__LINE__,
		"MHL7LLP Finished examining this fragment");

  return rtnStatus;
}

/* Handle_output 
Takes an HL7 stream of characters, and frames it with the HL7 LLP framing flags.
It then uses the SOCKET from peer() to send the message
*/
int
MHL7ProtocolHandlerLLP::handle_output (const char* stream, int length)
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
    cout << "MHL7ProtocolHandlerLLP::handle_output: About to send framed HL7 message ("
	 << j << " bytes)" << endl;
    cout << "0x0b <msg> 0x1c 0x0d" << endl;
    cout << "Hit <ENTER> to send the message ";
    cin.getline(x, sizeof(x));
  } else if (mVerbose != 0) {
    cout << "MHL7ProtocolHandlerLLP::handle_output: About to send framed HL7 message ("
	 << j << " bytes)" << endl;
  }
#endif

  char txtBuf[128];
  sprintf(txtBuf, "About to send framed HL7 message of size: %d", j);
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_VERBOSE,
		this->getPeerName(),
		"MHLLLPHandler::handle_output",
		__LINE__,
		txtBuf);

  //Send framed HL7 message
  if (this->peer().send_n (mFrame, j) == -1) {
    logClient.log(MLogClient::MLOG_ERROR,
		this->getPeerName(),
		"MHLLLPHandler::handle_output",
		__LINE__,
		"send to peer failed");
    return -1;
  }
  return 0;
}

int
MHL7ProtocolHandlerLLP::sendSlowly (const char* stream, int length)
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
		"MHLLLPHandler::sendSlowly",
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
		"MHLLLPHandler::sendSlowly",
		__LINE__,
		"send to peer failed");
    return -1;
  }

  return 0;
}
#endif
