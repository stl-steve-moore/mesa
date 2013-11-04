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
#include "MCodeItem.hpp"

MCodeItem::MCodeItem()
{
  tableName("codeitem");
  insert("codval");
  insert("codschdes");
  insert("codmea");
  insert("reqproid");
}

MCodeItem::MCodeItem(const MCodeItem& cpy) :
  mCodeValue(cpy.mCodeValue),
  mCodeMeaning(cpy.mCodeMeaning),
  mCodeSchemeDesignator(cpy.mCodeSchemeDesignator)
{
  tableName("codeitem");
  insert("codval", cpy.mCodeValue);
  insert("codmea", cpy.mCodeMeaning);
  insert("codschdes", cpy.mCodeSchemeDesignator);
}

MCodeItem::~MCodeItem()
{
}

void
MCodeItem::printOn(ostream& s) const
{
  s << "MActionItem:"
    << mCodeValue  << ":"
    << mCodeMeaning << ":"
    << mCodeSchemeDesignator;
}

MCodeItem::MCodeItem(
           const MString& codeValue,
           const MString& codeMeaning, const MString& codeSchemeDesignator
           ) :
  mCodeValue(codeValue),
  mCodeMeaning(codeMeaning),
  mCodeSchemeDesignator(codeSchemeDesignator)
{
  tableName("codeitem");
  insert("codval", codeValue);
  insert("codmea", codeMeaning);
  insert("codschdes", codeSchemeDesignator);
}

MString
MCodeItem::codeValue() const
{
  return mCodeValue;
}

MString
MCodeItem::codeMeaning() const
{
  return mCodeMeaning;
}

MString
MCodeItem::codeSchemeDesignator() const
{
  return mCodeSchemeDesignator;
}

void
MCodeItem::codeValue(const MString& s)
{
  mCodeValue = s;
  insert("codval", s);
}

void
MCodeItem::codeMeaning(const MString& s)
{
  mCodeMeaning = s;
  insert("codmea", s);
}

void
MCodeItem::codeSchemeDesignator(const MString& s)
{
  mCodeSchemeDesignator = s;
  insert("codschdes", s);
}

void
MCodeItem::streamIn(istream& s)
{
  //s >> this->member;
}
