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

#include "MDICOMFileMeta.hpp"

MDICOMFileMeta::MDICOMFileMeta()
{
  tableName("dicomfilemeta");
  insert("mediasopclassuid");
  insert("mediasopinsuid");
  insert("xfersyntuid");
  insert("impclassuid");
  insert("impversname");
  insert("sourceaetitle");
  insert("privinfocrtuid");
}

MDICOMFileMeta::MDICOMFileMeta(const MDICOMFileMeta& cpy)
{
  tableName("dicomfilemeta");
  mMap = cpy.mMap;
  mDBAttributes = cpy.mDBAttributes;
}

MDICOMFileMeta::~MDICOMFileMeta()
{
}

void
MDICOMFileMeta::printOn(ostream& s) const
{
  s << "MDICOMFileMeta";
}

void
MDICOMFileMeta::streamIn(istream& s)
{
  //s >> mStudyInstanceUID;
}


MString
MDICOMFileMeta::mediaStorageSOPClassUID() const
{
  return this->value("mediasopclassuid");
}

MString
MDICOMFileMeta::mediaStorageSOPInstanceUID() const
{
  return this->value("mediasopinsuid");
}

MString
MDICOMFileMeta::transferSyntaxUID() const
{
  return this->value("xfersyntuid");
}

MString
MDICOMFileMeta::implementationClassUID() const
{
  return this->value("impclassuid");
}

MString
MDICOMFileMeta::implementationVersionName() const
{
  return this->value("impversname");
}

MString
MDICOMFileMeta::sourceApplicationEntityTitle() const
{
  return this->value("sourceaetitle");
}

MString
MDICOMFileMeta::privateInformationCreatorUID() const
{
  return this->value("privinfocrtuid");
}

// The "set" operations are defined below

void
MDICOMFileMeta::mediaStorageSOPClassUID(const MString& s)
{
  insert("mediasopclassuid", s);
}

void
MDICOMFileMeta::mediaStorageSOPInstanceUID(const MString& s)
{
  insert("mediasopinsuid", s);
}

void
MDICOMFileMeta::transferSyntaxUID(const MString& s)
{
  insert("xfersyntuid", s);
}

void
MDICOMFileMeta::implementationClassUID(const MString& s)
{
  insert("impclassuid", s);
}

void
MDICOMFileMeta::implementationVersionName(const MString& s)
{
  insert("impversname", s);
}

void
MDICOMFileMeta::sourceApplicationEntityTitle(const MString& s)
{
  insert("sourceaetitle", s);
}

void
MDICOMFileMeta::privateInformationCreatorUID(const MString& s)
{
  insert("privinfocrtuid", s);
}

void
MDICOMFileMeta::import(const MDomainObject& o)
{
  mediaStorageSOPClassUID(o.value("mediasopclassuid"));
  mediaStorageSOPInstanceUID(o.value("mediasopinsuid"));
  transferSyntaxUID(o.value("xfersyntuid"));
  implementationClassUID(o.value("impclassuid"));
  implementationVersionName(o.value("impversname"));
  sourceApplicationEntityTitle(o.value("sourceaetitle"));
  privateInformationCreatorUID(o.value("privinfocrtuid"));
}

