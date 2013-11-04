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

#include "MESA.hpp"
#include "MLogClient.hpp"
#include "ctn_api.h"

static char rcsid[] = "$Id: MLogClient.cpp,v 1.19 2005/12/12 01:16:05 smm Exp $";

//ofstream MLogClient::mStream;
MLogClient::LOGLEVEL MLogClient::mLevel = MLogClient::MLOG_ERROR;
char* MLogClient::mLogFileName = 0;
//int MLogClient::mPort;

MLogClient::MLogClient()
{
}

MLogClient::MLogClient(const MLogClient& cpy)
{
}

MLogClient::~MLogClient()
{
}

void
MLogClient::printOn(ostream& s) const
{
  s << "MLogClient";
}

void
MLogClient::streamIn(istream& s)
{
  //s >> this->member;
}

// Non boiler-plate methods to follow

int
MLogClient::initialize(LOGLEVEL level, const MString& fileName)
{
  mLevel = level;
  if (mLogFileName != 0) {
    delete[] mLogFileName;
    mLogFileName = 0;
  }

  if (fileName != "") {
    mLogFileName = fileName.strData();
    //mStream.open(s, ios::app);
  }

  return 0;
}

int
MLogClient::initialize(LOGLEVEL level, int port, const MString& host)
{
  mLevel = level;
  return 0;
}

void
MLogClient::logLevel(LOGLEVEL level)
{
  mLevel = level;
}

int
MLogClient::log(LOGLEVEL level, const MString& peer, const MString& location,
		int lineNumber, const MString& message, const MString& message2)
{
  if ((level <= mLevel)) {
    char date[20];
    char time[30];
    ::UTL_GetDicomDate(date);
    ::UTL_GetDicomTime(time);
    time[6] = '\0';

    char* logCode = "";
    switch (level) {
      case MLogClient::MLOG_ERROR:
	logCode = "E: ";
	break;
      case MLogClient::MLOG_WARN:
	logCode = "W: ";
	break;
      case MLogClient::MLOG_CONVERSATION:
	logCode = "C: ";
	break;
      case MLogClient::MLOG_VERBOSE:
	logCode = "V: ";
	break;
    }

    ofstream o;
    if (mLogFileName != 0) {
      o.open(mLogFileName, ios::app);
      o << date << " " << time << " "
        << peer << ":" << location << ":" << lineNumber << endl << " ";

      if (message2 == "")
	o << logCode << message << endl;
      else
	o << logCode << message << " " << message2 << endl;

      o.flush();
      o.close();
    } else {
      cout << date << " " << time << " "
           << peer << ":" << location << ":" << lineNumber << endl << " ";
      if (message2 == "")
	cout << logCode << message << endl;
      else
	cout << logCode << message << " " << message2 << endl;
    }
  }

  return 0;
}

int
MLogClient::log(LOGLEVEL level, const MString& message)
{
  if ((level <= mLevel)) {

    char* logCode = "";
    switch (level) {
      case MLogClient::MLOG_ERROR:
	logCode = "E: ";
	break;
      case MLogClient::MLOG_WARN:
	logCode = "W: ";
	break;
      case MLogClient::MLOG_CONVERSATION:
	logCode = "C: ";
	break;
      case MLogClient::MLOG_VERBOSE:
	logCode = "V: ";
	break;
    }

    ofstream o;
    if (mLogFileName != 0) {
      o.open(mLogFileName, ios::app);
      o << logCode << message << endl;
      o.flush();
      o.close();
    } else {
      cout << logCode << message << endl;
    }
  }

  return 0;
}

int
MLogClient::log(LOGLEVEL level, const char* message)
{
  if ((level <= mLevel)) {
    ofstream o;
    if (mLogFileName != 0) {
      o.open(mLogFileName, ios::app);
      o << message << endl;
      o.flush();
      o.close();
    } else {
      cout << message << endl;
    }
  }

  return 0;
}

int
MLogClient::log(LOGLEVEL level, const char c)
{
  if ((level <= mLevel)) {
    ofstream o;
    if (mLogFileName != 0) {
      o.open(mLogFileName, ios::app);
      o << c;
      o.close();
    } else {
      cout << c;
    }
  }

  return 0;
}

int
MLogClient::log(LOGLEVEL level, int length, const char* message)
{
  if ((level <= mLevel)) {
    char buf[2049];
    int toDump;
    ofstream o;
    if (mLogFileName != 0) {
      o.open(mLogFileName, ios::app);
    }
    while (length > 0) {
      toDump = (length <= sizeof(buf)-1)? length : sizeof(buf)-1;
      ::strncpy(buf, message, toDump);
      buf[toDump] = '\0';
      if (mLogFileName != 0) {
	o << buf;
      } else {
	cout << buf;
      }
      length -= toDump;
      message += length;
    }
    if (mLogFileName != 0) {
      o.close();
    }
  }

  return 0;
}

int
MLogClient::logCTNErrorStack(LOGLEVEL level, const MString& modifier)
{
  CONDITION cond = 0;
  char txt[32];
  char ctnMsg[256];

  if (level > mLevel) {
    return 0;
  }

  if (mLogFileName != 0) {
    ofstream o;
    o.open(mLogFileName, ios::app);
    while(::COND_TopCondition(&cond, ctnMsg, sizeof ctnMsg) != COND_NORMAL) {
      ::sprintf(txt, "%8x ", cond);
      o << txt << ctnMsg << " : " << modifier << endl;
      (void) ::COND_PopCondition(FALSE);
    }
    o.flush();
    o.close();
  } else {
    while(::COND_TopCondition(&cond, ctnMsg, sizeof ctnMsg) != COND_NORMAL) {
      ::sprintf(txt, "%8x ", cond);
      cout << txt << ctnMsg << " : " << modifier << endl;
      (void) ::COND_PopCondition(FALSE);
    }
  }

  return 0;
}


int
MLogClient::logTimeStamp(LOGLEVEL level, const MString& message)
{
  if ((level <= mLevel)) {
    char date[20];
    char time[30];
    ::UTL_GetDicomDate(date);
    ::UTL_GetDicomTime(time);
    time[6] = '\0';

    ofstream o;
    if (mLogFileName != 0) {
      o.open(mLogFileName, ios::app);
      o << date << " " << time << " "
	<< message << endl;
      o.flush();
      o.close();
    } else {
      cout << date << " " << time << " " << message << endl;
    }
  }

  return 0;
}

void
MLogClient::truncate()
{
  ofstream o;
  if (mLogFileName != 0) {
    o.open(mLogFileName, ios::trunc);
    o.close();
  }
}

void
MLogClient::close()
{
  delete[] mLogFileName;
  mLogFileName = 0;
}
