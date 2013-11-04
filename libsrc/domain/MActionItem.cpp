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
#include "MActionItem.hpp"

MActionItem::MActionItem()
{
  tableName("actionitem");
  insert("codval");
  insert("codschdes");
  insert("codmea");
  insert("spsindex");
}

MActionItem::MActionItem(const MActionItem& cpy) :
  mSPSIndex(cpy.mSPSIndex),
  mCodeValue(cpy.mCodeValue),
  mCodeMeaning(cpy.mCodeMeaning),
  mCodeSchemeDesignator(cpy.mCodeSchemeDesignator)
  //mStudyInstanceUID(cpy.mStudyInstanceUID)
{
  tableName("actionitem");
  insert("spsindex", cpy.mSPSIndex);
  insert("codval", cpy.mCodeValue);
  insert("codmea", cpy.mCodeMeaning);
  insert("codschdes", cpy.mCodeSchemeDesignator);
  //insert("stuinsuid", cpy.mStudyInstanceUID);
}

MActionItem::~MActionItem()
{
}

void
MActionItem::printOn(ostream& s) const
{
  s << "MActionItem:"
    //<< mScheduledProcedureStepID << ":"
    << mSPSIndex << ":"
    << mCodeValue  << ":"
    << mCodeMeaning << ":"
    << mCodeSchemeDesignator << ":";
    //<< mStudyInstanceUID;
}

MActionItem::MActionItem(const MString& spsIndex,
           const MString& codeValue,
           const MString& codeMeaning, const MString& codeSchemeDesignator) :
           //const MString& studyInstanceUID) :
  mSPSIndex(spsIndex),
  mCodeValue(codeValue),
  mCodeMeaning(codeMeaning),
  mCodeSchemeDesignator(codeSchemeDesignator)
  //mStudyInstanceUID(studyInstanceUID)
{
  tableName("actionitem");
  insert("spsindex", spsIndex);
  insert("codval", codeValue);
  insert("codmea", codeMeaning);
  insert("codschdes", codeSchemeDesignator);
  //insert("stuinsuid", studyInstanceUID);
}

void
MActionItem::streamIn(istream& s)
{
  //s >> this->member;
}

void
MActionItem::import(const MDomainObject& o)
{
  codeMeaning(o.value("codmea"));
  codeSchemeDesignator(o.value("codschdes"));
  codeValue(o.value("codval"));
  //studyInstanceUID(o.value("stuinsuid"));
  spsIndex(o.value("spsindex"));
}

MString
MActionItem::spsIndex() const
{
  return mSPSIndex;
}

MString
MActionItem::codeValue() const
{
  return mCodeValue;
}

MString
MActionItem::codeMeaning() const
{
  return mCodeMeaning;
}

MString
MActionItem::codeSchemeDesignator() const
{
  return mCodeSchemeDesignator;
}

//MString
//MActionItem::studyInstanceUID() const
//{
//  return mStudyInstanceUID;
//}

void
MActionItem::spsIndex(const MString& s)
{
  mSPSIndex = s;
  insert("spsindex", s);
}

void
MActionItem::codeValue(const MString& s)
{
  mCodeValue = s;
  insert("codval", s);
}

void
MActionItem::codeMeaning(const MString& s)
{
  mCodeMeaning = s;
  insert("codmea", s);
}

void
MActionItem::codeSchemeDesignator(const MString& s)
{
  mCodeSchemeDesignator = s;
  insert("codschdes", s);
}

//void
//MActionItem::studyInstanceUID(const MString& s)
//{
//  mStudyInstanceUID = s;
//  insert("stuinsuid", s);
//}
