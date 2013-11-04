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

#include "ctn_api.h"

#include <strstream>

#include "MSyslogDomainXlate.hpp"

#include "MSyslogEntry.hpp"
#include "MSyslogMessage.hpp"

MSyslogDomainXlate::MSyslogDomainXlate()
{
}

MSyslogDomainXlate::MSyslogDomainXlate(const MSyslogDomainXlate& cpy)
{
}

MSyslogDomainXlate::~MSyslogDomainXlate()
{
}

void
MSyslogDomainXlate::printOn(ostream& s) const
{
  s << "MSyslogDomainXlate";
}

void
MSyslogDomainXlate::streamIn(istream& s)
{
  //s >> this->member;
}

// Non-boilerplate methods to follow

int
MSyslogDomainXlate::translateSyslog(MSyslogMessage& msg,
		MSyslogEntry& entry) const
{
  char buf[32];

  strstream x(buf, sizeof(buf));
  x << msg.facility() << '\0';
  entry.facility(buf);

  strstream y(buf, sizeof(buf));
  y << msg.severity() << '\0';
  entry.severity(buf);

  entry.host(msg.hostName());

  unsigned long l = 0;
  const char* m = (const char*)msg.referenceToMessage(l);	// Repair the cast
  entry.message(m);

  msg.timeStamp().safeExport(buf, sizeof(buf));

  struct tm tmStruct;
  ::memset(&tmStruct, 0, sizeof(tmStruct));

  // These messages don't have current year, so we
  // parse accordingly and assume this year. This scheme
  // blows up around new year (or for any messages that
  // have been archived over a new year boundary

  cout << buf << endl;
  this->parseTime(buf, &tmStruct);

  //::strptime(buf, "%b %d %T", &tmStruct);

  char dateBuffer[24];

  ::UTL_GetDicomDate(dateBuffer);

  ::sprintf(dateBuffer+4, "%02d%02d",
	tmStruct.tm_mon + 1,
	tmStruct.tm_mday);
  entry.dateStamp(dateBuffer);

  char timeBuffer[12];
  ::sprintf(timeBuffer, "%02d%02d%02d",
	tmStruct.tm_hour,
	tmStruct.tm_min,
	tmStruct.tm_sec);
  entry.timeStamp(timeBuffer);

  ::strcat(dateBuffer, timeBuffer);
  entry.dateTime(dateBuffer);
  return 0;
}

int
MSyslogDomainXlate::translateSyslog(MSyslogEntry& entry,
		MSyslogMessage& msg) const
{
  int tmp;
  tmp = (entry.facility()).intData();
  msg.facility(tmp);

  tmp = (entry.severity()).intData();
  msg.severity(tmp);

  msg.hostName(entry.host());

  return 0;
}

// Private methods defined below this point


int
MSyslogDomainXlate::parseTime(const char* buf, struct tm* tmStruct) const
{
  char month[12];
  int dd = 0;
  int hh = 0;
  int mm = 0;
  int ss = 0;

  memset(tmStruct, 0, sizeof(*tmStruct));
  ::sscanf(buf, "%s %d %d:%d:%d",
	month, &dd, &hh, &mm, &ss);

  int i = 0;
  month[11] = '\0';
  for (i = 0; i < 12 && month[i] != '\0'; i++) {
    month[i] = toupper(month[i]);
  }

  char *months[] = { "JAN", "FEB", "MAR", "APR", "MAY", "JUN",
		     "JUL", "AUG", "SEP", "OCT", "NOV", "DEC" };

  for (i = 0; i < 12; i++) {
    if (::strncmp(month, months[i], 3) == 0) {
      tmStruct->tm_mon = i;
      break;
    }
  }

  tmStruct->tm_mday = dd;
  tmStruct->tm_hour = hh;
  tmStruct->tm_min  = mm;
  tmStruct->tm_sec  = ss;

  return 0;
}

