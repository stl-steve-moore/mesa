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
#include "MSyslogMessage5424.hpp"

#include <strstream>

static char rcsid[] = "$Id: MSyslogMessage5424.cpp,v 1.5 2007/04/05 20:36:16 smm Exp $";

#define ASCII_CR 0x0d
#define ASCII_LF 0x0a

MSyslogMessage5424::MSyslogMessage5424() :
  mFacility(0),
  mSeverity(0),
  mVersion(1),
  mMessage(0),
  mAppName("-"),
  mProcID("-"),
  mMsgID("-"),
  mMessageSize(0),
  mOwnMessage(false),
  mUTF8Flag(true)
{
}

MSyslogMessage5424::MSyslogMessage5424(const MSyslogMessage5424& cpy) :
  mFacility(cpy.mFacility),
  mSeverity(cpy.mSeverity),
  mVersion(cpy.mVersion),
  mMessage(0),
  mMessageSize(0),
  mOwnMessage(cpy.mOwnMessage)
{
}

MSyslogMessage5424::~MSyslogMessage5424()
{
  this->removeCurrentMessage();
}

void
MSyslogMessage5424::printOn(ostream& s) const
{
  s << "MSyslogMessage5424"
	<< " f: " << mFacility
	<< " s: " << mSeverity
	<< " v: " << mVersion
	<< " t: " << mTimeStamp
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
MSyslogMessage5424::streamIn(istream& s)
{
  //s >> this->member;
}

// Non boiler plate methods follow

MSyslogMessage5424::MSyslogMessage5424(int facility, int severity, int version,
	const MString& message,
	const MString& timeStamp,
	const MString& hostName,
	const MString& appName,
	const MString& procID,
	const MString& msgID,
	bool flagUTF8) :
  mFacility(facility),
  mSeverity(severity),
  mVersion(version),
  mTimeStamp(timeStamp),
  mHostName(hostName),
  mAppName(appName),
  mProcID(procID),
  mMsgID(msgID),
  mUTF8Flag(flagUTF8),
  mOwnMessage(false)
{
  if (version <= 0) {
    mVersion = 1;
  } else if (version > 999) {
    mVersion = 999;
  }

  if (message == "") {
    mMessage = 0;
    mUTF8Flag = true;
    mMessageSize = 3;		// BOM
  } else {
    mMessage = (unsigned char*)message.strData();
    mMessageSize = message.length();
    if (mUTF8Flag) mMessageSize += 3;
  }
  if (mTimeStamp == "") this->computeTimeStamp();
  if (mHostName  == "") this->getHostName();
  if (mAppName   == "") mAppName = "-";
  if (mProcID    == "") mProcID  = "-";
  if (mMsgID     == "") mMsgID   = "-";
}

void
MSyslogMessage5424::facility(int facility)
{
  mFacility = facility;
}

int
MSyslogMessage5424::facility( ) const
{
  return mFacility;
}

void
MSyslogMessage5424::severity(int severity)
{
  mSeverity = severity;
}

int
MSyslogMessage5424::severity( ) const
{
  return mSeverity;
}

int
MSyslogMessage5424::message(char* message, unsigned long length)
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
MSyslogMessage5424::messageReference(unsigned char* message, unsigned long length)
{
  this->removeCurrentMessage();

  mMessage = message;
  if (mMessage == 0)
    return -1;

  mMessageSize = length;
  mOwnMessage = false;

  return 0;
}

char*
MSyslogMessage5424::copyOfMessage(unsigned long& length) const
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
MSyslogMessage5424::referenceToMessage(unsigned long& length) const
{
  if (mMessageSize == 0) {
    length = 0;
    return 0;
  }

  length = mMessageSize;
  return mMessage;
}

void
MSyslogMessage5424::timeStamp(const MString& timeStamp)
{
  mTimeStamp = timeStamp;
}

MString
MSyslogMessage5424::timeStamp( ) const
{
  return mTimeStamp;
}

void
MSyslogMessage5424::hostName(const MString& hostName)
{
  mHostName = hostName;
}

MString
MSyslogMessage5424::hostName( ) const
{
  return mHostName;
}



MString
MSyslogMessage5424::appName( ) const
{
  return mAppName;
}

MString
MSyslogMessage5424::processID ( ) const
{
  return mProcID;
}

MString
MSyslogMessage5424::messageID ( ) const
{
  return mMsgID;
}

int
MSyslogMessage5424::headerLength() const
{
  int priority = mFacility << 3 | (mSeverity & 0x7);

  int l = 2                             // <> brackets
        + this->textLength(priority) +1	// priority + space delimiter
        + mTimeStamp.size() + 1         // time stamp + space delimiter
        + mHostName.size() + 1          // hostname + space delimiter
        + mAppName.size() + 1           // App Name + space delimiter
        + mProcID.size()  + 1           // Proc ID + space delimiter
        + mMsgID.size();

  if (mVersion < 10)       l += 1;
  else if (mVersion < 100) l += 2;
  else                     l += 3;

  return l;
}

int
MSyslogMessage5424::messageSize() const
{
//  cout << "header " << this->headerLength()
//	<< " message " << mMessageSize
//	<< " structured " << 3
//	<< endl;

  int len = this->headerLength() + mMessageSize;	// 3 is for the " - " we use for structured data
  if (mUTF8Flag) {
    len += 3;
//    cout << " utf8 3 chars" << endl;
  }
//  cout << "   total len: " << len << endl;

  return len;
}

int
MSyslogMessage5424::exportHeader(char* buffer,
	int bufferLength,
	int& exportedLength)
{
  unsigned long computedLength = this->headerLength();

  if (computedLength >= bufferLength)
    return -1;

  strstream s(buffer, bufferLength);

  int priority = mFacility << 3 | (mSeverity & 0x7);
  s     << '<' << priority << '>' << mVersion
        << ' ' << mTimeStamp
        << ' ' << mHostName
        << ' ' << mAppName
        << ' ' << mProcID
        << ' ' << mMsgID
        << '\0';

  exportedLength = ::strlen(buffer);

  return 0;
}

char*
MSyslogMessage5424::exportHeader(int& exportedLength)
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
MSyslogMessage5424::trailerLength()
{
  return 0;
}


int
MSyslogMessage5424::exportTrailer(char* buffer,
	int bufferLength,
	int& exportedLength)
{
  return 0;
}

char*
MSyslogMessage5424::exportTrailer(int& exportedLength)
{
  exportedLength = 0;
  return 0;
}

int
MSyslogMessage5424::exportMessage(char* buffer,
        int bufferLength,
        int& exportedLength)
{
  exportedLength = 0;
  if (mMessageSize + 3 >= bufferLength) {	// Allow for " -" for structured data and " " before payload
    return -1;
  }


  ::strcpy(buffer, " - ");			// This is the NILL Structured-Data
  buffer += 3;

  int toCopy = mMessageSize;
  if (mUTF8Flag) {
    *buffer++ = 0xEF;
    *buffer++ = 0xBB;
    *buffer++ = 0xBF;
    toCopy -= 3;
  }

  ::memcpy(buffer, mMessage, toCopy);
  buffer[mMessageSize] = '\0';

  exportedLength = mMessageSize + 3;

  return 0;
}

// Private methods are defined below.

int
MSyslogMessage5424::textLength(unsigned long val) const
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
MSyslogMessage5424::removeCurrentMessage()
{
  if (mMessage == 0)
    return;

  if (mOwnMessage)
    delete[] mMessage;

  mOwnMessage = false;
  mMessageSize = 0;
}

void
MSyslogMessage5424::computeTimeStamp()
{
  MDateTime dt;
  dt.formatRFC3339DateTime(mTimeStamp);
#if 0
  time_t t;

  ::time(&t);

  char *x = ::ctime(&t);
  char tmp[32];
  strcpy(tmp, x+4);	// Skip the day at the front of the string
  tmp[15] = '\0';
  mTimeStamp = tmp;
#endif
}


void
MSyslogMessage5424::getHostName()
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
