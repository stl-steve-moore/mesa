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

#include "MSOPInstance.hpp"

MSOPInstance::MSOPInstance() :
  mSeriesInstanceUID(""),
  mClassUID(""),
  mInstanceUID(""),
  mInstanceNumber(""),
  mRows(""),
  mColumns(""),
  mBitsAllocated(""),
  mNumberOfFrames(""),
  mPresentationLabel(""),
  mPresentationDescription(""),
  mPresentationCreationDate(""),
  mPresentationCreationTime(""),
  mPresentationCreatorsName(""),
  mCompletionFlag(""),
  mVerificationFlag(""),
  mContentDate(""),
  mContentTime(""),
  mObservationDateTime(""),
  mConceptNameCodeValue(""),
  mConceptNameCodeScheme(""),
  mConceptNameCodeVersion(""),
  mConceptNameCodeMeaning(""),
  mFileName(""),
  mDocTitle("")
{
  tableName("sopins");
  this->fillMap();
}

MSOPInstance::MSOPInstance(const MSOPInstance& cpy) :
  mSeriesInstanceUID(cpy.mSeriesInstanceUID),
  mClassUID(cpy.mClassUID),
  mInstanceUID(cpy.mInstanceUID),
  mInstanceNumber(cpy.mInstanceNumber),
  mRows(cpy.mRows),
  mColumns(cpy.mColumns),
  mBitsAllocated(cpy.mBitsAllocated),
  mNumberOfFrames(cpy.mNumberOfFrames),
  mPresentationLabel(cpy.mPresentationLabel),
  mPresentationDescription(cpy.mPresentationDescription),
  mPresentationCreationDate(cpy.mPresentationCreationDate),
  mPresentationCreationTime(cpy.mPresentationCreationTime),
  mPresentationCreatorsName(cpy.mPresentationCreatorsName),
  mCompletionFlag(cpy.mCompletionFlag),
  mVerificationFlag(cpy.mVerificationFlag),
  mContentDate(cpy.mContentDate),
  mContentTime(cpy.mContentTime),
  mObservationDateTime(cpy.mObservationDateTime),
  mConceptNameCodeValue(cpy.mConceptNameCodeValue),
  mConceptNameCodeScheme(cpy.mConceptNameCodeScheme),
  mConceptNameCodeVersion(cpy.mConceptNameCodeVersion),
  mConceptNameCodeMeaning(cpy.mConceptNameCodeMeaning),

  mFileName(cpy.mFileName),
  mDocTitle(cpy.mDocTitle)
{
  tableName("sopins");
  this->fillMap();
}

MSOPInstance::~MSOPInstance()
{
}

void
MSOPInstance::printOn(ostream& s) const
{
  s << "Image:"
    << mSeriesInstanceUID << ":"
    << mClassUID << ":"
    << mInstanceUID << ":"
    << mInstanceNumber << ":"
    << mFileName;
}

void
MSOPInstance::streamIn(istream& s)
{
  s >> mInstanceUID;
}

MSOPInstance::MSOPInstance(const MString& seriesInstanceUID,
			   const MString& classUID,
			   const MString& instanceUID,
			   const MString& instanceNumber,
			   const MString& fileName) :
  mSeriesInstanceUID(seriesInstanceUID),
  mClassUID(classUID),
  mInstanceUID(instanceUID),
  mInstanceNumber(instanceNumber),
  mRows("0"),
  mColumns("0"),
  mBitsAllocated("0"),
  mNumberOfFrames("0"),
  mPresentationLabel(""),
  mPresentationDescription(""),
  mPresentationCreationDate(""),
  mPresentationCreationTime(""),
  mPresentationCreatorsName(""),
  mCompletionFlag(""),
  mVerificationFlag(""),
  mContentDate(""),
  mContentTime(""),
  mObservationDateTime(""),
  mConceptNameCodeValue(""),
  mConceptNameCodeScheme(""),
  mConceptNameCodeVersion(""),
  mConceptNameCodeMeaning(""),
  mDocTitle(""),
  mFileName(fileName)
{
  tableName("sopins");
  this->fillMap();
}

MString
MSOPInstance::seriesInstanceUID() const
{
  return mSeriesInstanceUID;
}

MString
MSOPInstance::classUID() const
{
  return mClassUID;
}

MString
MSOPInstance::instanceUID() const
{
  return mInstanceUID;
}

MString
MSOPInstance::instanceNumber() const
{
  return mInstanceNumber;
}

MString
MSOPInstance::fileName() const
{
  return mFileName;
}

MString
MSOPInstance::documentTitle() const
{
  return mDocTitle;
}

void
MSOPInstance::seriesInstanceUID(const MString& s)
{
  mSeriesInstanceUID = s;
  insert("serinsuid", s);
}

void
MSOPInstance::classUID(const MString& s)
{
  mClassUID = s;
  insert("clauid", s);
}

void
MSOPInstance::instanceUID(const MString& s)
{
  mInstanceUID = s;
  insert("insuid", s);
}

void
MSOPInstance::instanceNumber(const MString& s)
{
  mInstanceNumber = s;
  insert("imanum", s);
}

void MSOPInstance::rows(const MString& s)
{
  mRows = s;
  insert("row", s);
}

void MSOPInstance::columns(const MString& s)
{
  mColumns = s;
  insert("col", s);
}

void MSOPInstance::bitsAllocated(const MString& s)
{
  mBitsAllocated = s;
  insert("bitall", s);
}

void MSOPInstance::numberOfFrames(const MString& s)
{
  mNumberOfFrames = s;
  insert("numfrm", s);
}

void MSOPInstance::presentationLabel(const MString& s)
{
  mPresentationLabel = s;
  insert("prelbl", s);
}

void MSOPInstance::presentationDescription(const MString& s)
{
  mPresentationDescription = s;
  insert("predes", s);
}

void MSOPInstance::presentationCreationDate(const MString& s)
{
  mPresentationCreationDate = s;
  insert("precredat", s);
}

void MSOPInstance::presentationCreationTime(const MString& s)
{
  mPresentationCreationTime = s;
  insert("precretim", s);
}

void MSOPInstance::presentationCreatorsName(const MString& s)
{
  mPresentationCreatorsName = s;
  insert("precrenam", s);
}

void
MSOPInstance::completionFlag(const MString& s)
{
  mCompletionFlag = s;
  insert("comflg", s);
}

void
MSOPInstance::verificationFlag(const MString& s)
{
  mVerificationFlag = s;
  insert("verflg", s);
}

void
MSOPInstance::contentDate(const MString& s)
{
  mContentDate = s;
  insert("condat", s);
}

void
MSOPInstance::contentTime(const MString& s)
{
  mContentTime = s;
  insert("contim", s);
}

void
MSOPInstance::observationDateTime(const MString& s)
{
  mObservationDateTime = s;
  insert("obsdattim", s);
}

void
MSOPInstance::conceptNameCodeValue(const MString& s)
{
  mConceptNameCodeValue = s;
  insert("conceptval", s);
}

void
MSOPInstance::conceptNameCodeScheme(const MString& s)
{
  mConceptNameCodeScheme = s;
  insert("conceptschm", s);
}

void
MSOPInstance::conceptNameCodeVersion(const MString& s)
{
  mConceptNameCodeVersion = s;
  insert("conceptvers", s);
}

void
MSOPInstance::conceptNameCodeMeaning(const MString& s)
{
  mConceptNameCodeMeaning = s;
  insert("conceptmean", s);
}

void
MSOPInstance::fileName(const MString& s)
{
  mFileName = s;
  insert("filnam", s);
}

void
MSOPInstance::documentTitle(const MString& s)
{
  mDocTitle = s;
  insert("doctitle", s);
}

void
MSOPInstance::import(MDomainObject& o)
{
  seriesInstanceUID(o.value("serinsuid"));
  classUID(o.value("clauid"));
  instanceUID(o.value("insuid"));
  instanceNumber(o.value("imanum"));
  rows(o.value("row"));
  columns(o.value("col"));
  bitsAllocated(o.value("bitall"));
  numberOfFrames(o.value("numfrm"));
  presentationLabel(o.value("prelbl"));
  presentationDescription(o.value("predes"));
  presentationCreationDate(o.value("precredat"));
  presentationCreationTime(o.value("precretim"));
  presentationCreatorsName(o.value("precrenam"));
  completionFlag(o.value("comflg"));
  verificationFlag(o.value("verflg"));
  contentDate(o.value("condat"));
  contentTime(o.value("contim"));
  observationDateTime(o.value("obsdattim"));

  conceptNameCodeValue(o.value("conceptval"));
  conceptNameCodeScheme(o.value("conceptschm"));
  conceptNameCodeVersion(o.value("conceptvers"));
  conceptNameCodeMeaning(o.value("conceptmean"));

  fileName(o.value("filnam"));
  documentTitle(o.value("doctitle"));
}

// Private methods defined below

void
MSOPInstance::fillMap( )
{
  insert("serinsuid", mSeriesInstanceUID);
  insert("clauid", mClassUID);
  insert("insuid", mInstanceUID);
  insert("imanum", mInstanceNumber);
  insert("row", mRows);
  insert("col", mColumns);
  insert("bitall", mBitsAllocated);
  insert("numfrm", mNumberOfFrames);
  insert("prelbl", mPresentationLabel);
  insert("predes", mPresentationDescription);
  insert("precredat", mPresentationCreationDate);
  insert("precretim", mPresentationCreationTime);
  insert("precrenam", mPresentationCreatorsName);

  insert("comflg", mCompletionFlag);
  insert("verflg", mVerificationFlag);
  insert("condat", mContentDate);
  insert("contim", mContentTime);
  insert("obsdattim", mObservationDateTime);

  insert("conceptval", mConceptNameCodeValue);
  insert("conceptschm", mConceptNameCodeScheme);
  insert("conceptvers", mConceptNameCodeVersion);
  insert("conceptmean", mConceptNameCodeMeaning);

  insert("filnam", mFileName);
  insert("doctitle", mDocTitle);
}
