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

#include "MSeries.hpp"
#include <strstream>

MSeries::MSeries() :
  mStudyInstanceUID(""),
  mSeriesInstanceUID(""),
  mModality(""),
  mSeriesNumber(""),
  mProtocolName(""),
  mSeriesDescription(""),
  mSeriesDate(""),
  mNumberSeriesRelatedInstances(""),
  mTimeLastModified("")
{
  tableName("series");
  this->fillMap();
}

MSeries::MSeries(const MSeries& cpy) :
  mStudyInstanceUID(cpy.mStudyInstanceUID),
  mSeriesInstanceUID(cpy.mSeriesInstanceUID),
  mModality(cpy.mModality),
  mSeriesNumber(cpy.mSeriesNumber),
  mProtocolName(cpy.mProtocolName),
  mSeriesDescription(cpy.mSeriesDescription),
  mSeriesDate(cpy.mSeriesDate),
  mNumberSeriesRelatedInstances(cpy.mNumberSeriesRelatedInstances),
  mTimeLastModified(cpy.mTimeLastModified)
{
  tableName("series");
  this->fillMap();
}

MSeries::~MSeries()
{
}

void
MSeries::printOn(ostream& s) const
{
  s << "Series:"
    << mStudyInstanceUID << ":"
    << mSeriesInstanceUID << ":"
    << mModality << ":"
    << mSeriesNumber << ":"
    << mProtocolName << ":"
    << mSeriesDescription << ":"
    << mSeriesDate << ":"
    << mNumberSeriesRelatedInstances << ":"
    << mTimeLastModified;
}

void
MSeries::streamIn(istream& s)
{
  s >> mStudyInstanceUID;
}

MSeries::MSeries(const MString& studyInstanceUID,
		 const MString& seriesInstanceUID,
                 const MString& modality, const MString& seriesNumber,
                 const MString& protocolName,
 		 const MString& seriesDescription,
		 const MString& seriesDate,
		 const MString& numberSeriesRelatedInstances) :
  mStudyInstanceUID(studyInstanceUID),
  mSeriesInstanceUID(seriesInstanceUID),
  mModality(modality),
  mSeriesNumber(seriesNumber),
  mProtocolName(protocolName),
  mSeriesDescription(seriesDescription),
  mSeriesDate(seriesDate),
  mNumberSeriesRelatedInstances(numberSeriesRelatedInstances),
  mTimeLastModified("")
{
  tableName("series");
  this->fillMap();
}

MString
MSeries::studyInstanceUID() const
{
  return mStudyInstanceUID;
}

MString
MSeries::seriesInstanceUID() const
{
  return mSeriesInstanceUID;
}

MString
MSeries::modality() const
{
  return mModality;
}

MString
MSeries::seriesNumber() const
{
  return mSeriesNumber;
}

MString
MSeries::protocolName() const
{
  return mProtocolName;
}

MString
MSeries::seriesDescription() const
{
  return mSeriesDescription;
}

MString
MSeries::seriesDate() const
{
  return mSeriesDate;
}

MString
MSeries::numberSeriesRelatedInstances() const
{
  return mNumberSeriesRelatedInstances;
}

MString
MSeries::timeSeriesLastModified() const
{
  return mTimeLastModified;
}

int
MSeries::numberRequestAttributes() const
{
  return mRequestAttributeVector.size();
}

MRequestAttribute
MSeries::requestAttribute(int index)
{
  return mRequestAttributeVector[index];
}

void
MSeries::studyInstanceUID(const MString& s)
{
  mStudyInstanceUID = s;
  insert("stuinsuid", s);
}

void
MSeries::seriesInstanceUID(const MString& s)
{
  mSeriesInstanceUID = s;
  insert("serinsuid", s);
}

void
MSeries::modality(const MString& s)
{
  mModality = s;
  insert("mod", s);
}

void
MSeries::seriesNumber(const MString& s)
{
  mSeriesNumber = s;
  insert("sernum", s);
}

void
MSeries::protocolName(const MString& s)
{
  mProtocolName = s;
  insert("pronam", s);
}

void
MSeries::seriesDescription(const MString& s)
{
  mSeriesDescription = s;
  insert("serdes", s);
}

void
MSeries::seriesDate(const MString& s)
{
  mSeriesDate = s;
  insert("serdat", s);
}

void
MSeries::numberSeriesRelatedInstances(const MString& s)
{
  mNumberSeriesRelatedInstances = s;
  insert("numins", s);
}

void
MSeries::numberSeriesRelatedInstances(int c)
{
  char tmp[16];
  strstream x(tmp, 15);
  x << c << '\0';
  this->numberSeriesRelatedInstances(tmp);
}

void
MSeries::timeSeriesLastModified(const MString& s)
{
  mTimeLastModified = s;
  insert("lastmod", s);
}

void
MSeries::addRequestAttribute(const MRequestAttribute& s)
{
  mRequestAttributeVector.push_back(s);
}

void
MSeries::import(const MDomainObject& o)
{
  studyInstanceUID(o.value("stuinsuid"));
  seriesInstanceUID(o.value("serinsuid"));
  modality(o.value("mod"));
  seriesNumber(o.value("sernum"));
  protocolName(o.value("pronam"));
  seriesDescription(o.value("serdes"));
  seriesDate(o.value("serdate"));
  numberSeriesRelatedInstances(o.value("numins"));
  timeSeriesLastModified(o.value("lastmod"));
}


// Private methods below here

void
MSeries::fillMap()
{
  insert("stuinsuid", mStudyInstanceUID);
  insert("serinsuid", mSeriesInstanceUID);
  insert("mod", mModality);
  insert("sernum", mSeriesNumber);
  insert("pronam", mProtocolName);
  insert("serdes", mSeriesDescription);
  insert("serdat", mSeriesDate);
  insert("numins", mNumberSeriesRelatedInstances);
  insert("lastmod", mTimeLastModified);
}
