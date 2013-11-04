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
#include "MSyslogMessage.hpp"

#include <strstream>

static char rcsid[] = "$Id: MSyslogMessage.cpp,v 1.5 2007/04/05 20:36:16 smm Exp $";

#define ASCII_CR 0x0d
#define ASCII_LF 0x0a

MSyslogMessage::MSyslogMessage() :
  mFacility(0),
  mSeverity(0),
  mMessage(0),
  mTag(""),
  mMessageSize(0),
  mOwnMessage(false)
{
}

MSyslogMessage::MSyslogMessage(const MSyslogMessage& cpy) :
  mFacility(cpy.mFacility),
  mSeverity(cpy.mSeverity),
  mTag(cpy.mTag),
  mMessage(0),
  mMessageSize(0),
  mOwnMessage(cpy.mOwnMessage)
{
}

MSyslogMessage::~MSyslogMessage()
{
  this->removeCurrentMessage();
}

void
MSyslogMessage::printOn(ostream& s) const
{
  s << "MSyslogMessage"
	<< " f: " << mFacility
	<< " s: " << mSeverity
	<< " t: " << mTimeStamp
	<< " T: " << mTag
	<< " h: " << mHostName;
  if (mMessageSize > 0) {
    unsigned char* p = mMessage;
    int count = mMessageSize;
    s << " m: ";
    while(count-- > 0)
      s << *p++;
  }
}

void
MSyslogMessage::streamIn(istream& s)
{
  //s >> this->member;
}

// Non boiler plate methods follow

MSyslogMessage::MSyslogMessage(int facility, int severity,
	const MString& tag,
	const MString& message,
	const MString& timeStamp,
	const MString& hostName) :
  mFacility(facility),
  mSeverity(severity),
  mTag(tag),
  mTimeStamp(timeStamp),
  mHostName(hostName),
  mOwnMessage(false)
{
  if (message == "") {
    mMessage = 0;
    mMessageSize = 0;
  } else {
    mMessageSize = message.length();
    mMessage = new unsigned char[mMessageSize+1];
    ::memcpy(mMessage, message.strData(), mMessageSize);
    mMessage[mMessageSize] = '\0';
//    mMessage = message.strData();
    mOwnMessage = true;
  }
  if (mTimeStamp == "")
    this->computeTimeStamp();
  if (mHostName == "")
    this->getHostName();
}

void
MSyslogMessage::facility(int facility)
{
  mFacility = facility;
}

int
MSyslogMessage::facility( ) const
{
  return mFacility;
}

void
MSyslogMessage::severity(int severity)
{
  mSeverity = severity;
}

int
MSyslogMessage::severity( ) const
{
  return mSeverity;
}

int
MSyslogMessage::message(char* message, unsigned long length)
{
  this->removeCurrentMessage();

  mMessage = new unsigned char[length+1];
  if (mMessage == 0)
    return -1;

  ::memcpy(mMessage, message, length);
  mMessage[length] = '\0';
  mMessageSize = length;
  mOwnMessage = true;

  return 0;
}

int
MSyslogMessage::messageReference(char* message, unsigned long length)
{
  this->removeCurrentMessage();

  mMessage = (unsigned char*)message;
  if (mMessage == 0)
    return -1;

  mMessageSize = length;
  mOwnMessage = false;

  return 0;
}

char*
MSyslogMessage::copyOfMessage(unsigned long& length) const
{
  if (mMessageSize == 0) {
    length = 0;
    return 0;
  }

  char* c = new char[mMessageSize+1];
  if (c == 0) {
    length = 0;
    return 0;
  }

  ::memcpy(c, mMessage, mMessageSize);
  mMessage[mMessageSize] = '\0';
  length = mMessageSize;
  return c;
}

const unsigned char*
MSyslogMessage::referenceToMessage(unsigned long& length) const
{
  if (mMessageSize == 0) {
    length = 0;
    return 0;
  }

  length = mMessageSize;
  return mMessage;
}

void
MSyslogMessage::timeStamp(const MString& timeStamp)
{
  mTimeStamp = timeStamp;
}

MString
MSyslogMessage::timeStamp( ) const
{
  return mTimeStamp;
}

void
MSyslogMessage::hostName(const MString& hostName)
{
  mHostName = hostName;
}

MString
MSyslogMessage::hostName( ) const
{
  return mHostName;
}



int
MSyslogMessage::headerLength()
{
  int priority = mFacility << 3 | (mSeverity & 0x7);

  int l = 2				// <> brackets
	+ this->textLength(priority)
	+ mTimeStamp.size()
	+ 1				// Space delimiter
	+ mHostName.size();

  if (mTag != "") {
    l += 1 + mTag.size();
  }

  return l;
}

int
MSyslogMessage::exportHeader(char* buffer,
	int bufferLength,
	int& exportedLength)
{
  unsigned long computedLength = this->headerLength();

  if (computedLength >= bufferLength)
    return -1;

  strstream s(buffer, bufferLength);

  int priority = mFacility << 3 | (mSeverity & 0x7);
  s	<< '<' << priority << '>'
	<< mTimeStamp << ' '
	<< mHostName
	<< '\0';
  exportedLength = ::strlen(buffer);

  return 0;
}

char*
MSyslogMessage::exportHeader(int& exportedLength)
{
  int l = this->headerLength() + 1;

  char* h = new char[l];
#if 0
  if (h == 0)
    return 0;

  int status = this->exportHeader(h, l, exportedLength);

  if (status != 0) {
    delete[] h;
    h = 0;
    exportedLength = 0;
  }
#endif

  return h;
}

int
MSyslogMessage::trailerLength()
{
  return 0;
}


int
MSyslogMessage::exportTrailer(char* buffer,
	int bufferLength,
	int& exportedLength)
{
  return 0;
}

char*
MSyslogMessage::exportTrailer(int& exportedLength)
{
  exportedLength = 0;
  return 0;
}

int
MSyslogMessage::exportMessage(char* buffer,
        int bufferLength,
        int& exportedLength)
{
  int totalLength = mMessageSize;
  if (mTag != "") {
    totalLength += 1 + mTag.size();
  }

  if (totalLength>= bufferLength)
    return -1;

  int idx = 0;
  if (mTag != "") {
    mTag.safeExport(buffer, bufferLength);
    idx = mTag.size();
    buffer[idx] = ' ';
    idx++;
  }

  ::memcpy(buffer+idx, mMessage, mMessageSize);
  buffer[mMessageSize+idx] = '\0';

  exportedLength = totalLength;

  return 0;
}

// Private methods are defined below.

int
MSyslogMessage::textLength(unsigned long val) const
{
  unsigned long tbl[] =
	{ 10, 100, 1000, 10000, 100000, 1000000,
	  10000000, 100000000, 1000000000 /*5000000000*/ };

  int i = 0;
  for (i = 0; i < 10; i++) {
    if (val < tbl[i])
      return i+1;
  }

  return 10;
}

void
MSyslogMessage::removeCurrentMessage()
{
  if (mMessage == 0)
    return;

  if (mOwnMessage)
    delete[] mMessage;

  mOwnMessage = false;
  mMessageSize = 0;
}

void
MSyslogMessage::computeTimeStamp()
{
  time_t t;

  ::time(&t);

  char *x = ::ctime(&t);
  char tmp[32];
  strcpy(tmp, x+4);	// Skip the day at the front of the string
  tmp[15] = '\0';
  mTimeStamp = tmp;
}


void
MSyslogMessage::getHostName()
{

#ifdef _WIN32
  char hostName[1024];
  int status = ::gethostname(hostName, sizeof(hostName));
  if (status == 0) {
    mHostName = hostName;
  } else {
    mHostName = "hostname";
  }
#else
  struct utsname b;
  if (::uname(&b) < 0) {
    mHostName = "hostname";
    return;
  }

  mHostName = b.nodename;
#endif
}
