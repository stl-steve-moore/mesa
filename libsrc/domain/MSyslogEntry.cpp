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
#include "MSyslogEntry.hpp"
  
MSyslogEntry::MSyslogEntry()
{
  tableName("syslogentry");
  insert("facility");
  insert("severity");
  insert("timestamp");
  insert("datestamp");
  insert("host");
  insert("message");
  insert("identifier");
}

MSyslogEntry::MSyslogEntry(const MSyslogEntry& cpy) :
  mFacility(cpy.mFacility),
  mSeverity(cpy.mSeverity),
  mTimeStamp(cpy.mTimeStamp),
  mDateStamp(cpy.mDateStamp),
  mDateTime(cpy.mDateTime),
  mHost(cpy.mHost),
  mMessage(cpy.mMessage),
  mIdentifier(cpy.mIdentifier)
{
  tableName("syslogentry");
  this->fillMap();
}

MSyslogEntry::~MSyslogEntry()
{
}

void
MSyslogEntry::printOn(ostream& s) const
{
  s << mIdentifier << ":"
    << mFacility << ":"
    << mSeverity << ":"
    << mTimeStamp << ":"
    << mDateStamp << ":"
    << mDateTime << ":"
    << mHost << ":"
    << mMessage;
}

MSyslogEntry::MSyslogEntry(const MString& facility, const MString& severity,
	const MString& timeStamp, const MString& dateStamp,
	const MString& dateTime,
	const MString& host, const MString& message,
	const MString& identifier) :
	  mFacility(facility),
	  mSeverity(severity),
	  mTimeStamp(timeStamp),
	  mDateStamp(dateStamp),
	  mDateTime(dateTime),
	  mHost(host),
	  mMessage(message),
	  mIdentifier(identifier)
{
  tableName("syslogentry");
  this->fillMap();
}

void
MSyslogEntry::streamIn(istream& s)
{
  //s >> mFacility;
}

MString
MSyslogEntry::facility() const
{
  return mFacility;
}

MString
MSyslogEntry::severity() const
{
  return mSeverity;
}

MString
MSyslogEntry::timeStamp() const
{
  return mTimeStamp;
}

MString
MSyslogEntry::dateStamp() const
{
  return mDateStamp;
}

MString
MSyslogEntry::dateTime() const
{
  return mDateTime;
}

MString
MSyslogEntry::host() const
{
  return mHost;
}

MString
MSyslogEntry::message() const
{
  return mMessage;
}

MString
MSyslogEntry::identifier() const
{
  return mIdentifier;
}

void
MSyslogEntry::facility(const MString& s)
{
  mFacility = s;
  insert("facility", s);
}

void
MSyslogEntry::severity(const MString& s)
{
  mSeverity = s;
  insert("severity", s);
}

void
MSyslogEntry::timeStamp(const MString& s)
{
  mTimeStamp = s;
  insert("timestamp", s);
}

void
MSyslogEntry::dateStamp(const MString& s)
{
  mDateStamp = s;
  insert("datestamp", s);
}

void
MSyslogEntry::dateTime(const MString& s)
{
  mDateTime = s;
  insert("datetime", s);
}

void
MSyslogEntry::host(const MString& s)
{
  mHost = s;
  insert("host", s);
}

void
MSyslogEntry::message(const MString& s)
{
  mMessage = s;
  insert("message", s);
}

void
MSyslogEntry::identifier(const MString& s)
{
  mIdentifier = s;
  insert("identifier", s);
}

void MSyslogEntry::import(const MDomainObject& o)
{
  facility(o.value("facility"));
  severity(o.value("severity"));
  timeStamp(o.value("timestamp"));
  dateStamp(o.value("datestamp"));
  dateTime(o.value("datetime"));
  host(o.value("host"));
  message(o.value("message"));
  identifier(o.value("identifier"));
}

void
MSyslogEntry::fillMap()
{
  insert("facility", mFacility);
  insert("severity", mSeverity);
  insert("timestamp", mTimeStamp);
  insert("datestamp", mDateStamp);
  insert("datetime", mDateTime);
  insert("host", mHost);
  insert("message", mMessage);
  insert("identifier", mIdentifier);
}
