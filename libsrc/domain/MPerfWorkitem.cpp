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
#include "MPerfWorkitem.hpp"

MPerfWorkitem::MPerfWorkitem()
{
  tableName("perfworkitem");
  insert("codval");
  insert("codschdes");
  insert("codmea");
  insert("workitemkey");
}

MPerfWorkitem::MPerfWorkitem(const MPerfWorkitem& cpy) :
  mCodeValue(cpy.mCodeValue),
  mCodeMeaning(cpy.mCodeMeaning),
  mCodeSchemeDesignator(cpy.mCodeSchemeDesignator),
  mWorkitemkey(cpy.mWorkitemkey)
{
  tableName("perfworkitem");
  insert("codval", cpy.mCodeValue);
  insert("codmea", cpy.mCodeMeaning);
  insert("codschdes", cpy.mCodeSchemeDesignator);
  insert("workitemkey", cpy.mWorkitemkey);
}

MPerfWorkitem::~MPerfWorkitem()
{
}

void
MPerfWorkitem::printOn(ostream& s) const
{
  s << "MPerfWorkitem:"
    << mCodeValue  << ":"
    << mCodeMeaning << ":"
    << mWorkitemkey << ":"
    << mCodeSchemeDesignator << "\n";
}

MPerfWorkitem::MPerfWorkitem(
           const MString& codeValue,
           const MString& codeMeaning, const MString& codeSchemeDesignator,
           const MString& workitemkey
           ) :
  mCodeValue(codeValue),
  mCodeMeaning(codeMeaning),
  mCodeSchemeDesignator(codeSchemeDesignator),
  mWorkitemkey(workitemkey)
{
  tableName("perfworkitem");
  insert("codval", codeValue);
  insert("codmea", codeMeaning);
  insert("codschdes", codeSchemeDesignator);
  insert("workitemkey", workitemkey);
}

MPerfWorkitem::MPerfWorkitem(
           MString& s,
           const MString& workitemkey
           ) :
  mWorkitemkey(workitemkey)
{
  MString emptyString;

  tableName("perfworkitem");
  mCodeValue = s.getToken('^', 0);
  insert("codval", mCodeValue);
  if( s.tokenExists('^', 1)) mCodeSchemeDesignator = s.getToken('^',1);
  insert("codschdes", mCodeSchemeDesignator);
  if( s.tokenExists('^', 2)) mCodeMeaning = s.getToken('^',2);
  insert("codmea", mCodeMeaning);
  insert("workitemkey",mWorkitemkey);
}

MString
MPerfWorkitem::codeValue() const
{
  return mCodeValue;
}

MString
MPerfWorkitem::codeMeaning() const
{
  return mCodeMeaning;
}

MString
MPerfWorkitem::codeSchemeDesignator() const
{
  return mCodeSchemeDesignator;
}

MString
MPerfWorkitem::workitemkey() const
{
  return mWorkitemkey;
}

void
MPerfWorkitem::codeValue(const MString& s)
{
  mCodeValue = s;
  remove("codval");
  insert("codval", s);
}

void
MPerfWorkitem::codeMeaning(const MString& s)
{
  mCodeMeaning = s;
  remove("codmea");
  insert("codmea", s);
}

void
MPerfWorkitem::codeSchemeDesignator(const MString& s)
{
  mCodeSchemeDesignator = s;
  remove("codschdes");
  insert("codschdes", s);
}

void
MPerfWorkitem::workitemkey(const MString& s)
{
  mWorkitemkey = s;
  remove("workitemkey");
  insert("workitemkey", s);
}

void
MPerfWorkitem::streamIn(istream& s)
{
  //s >> this->member;
}

void MPerfWorkitem::import(const MDomainObject& o)
{
  codeValue(o.value("codval"));
  codeMeaning(o.value("codmea"));
  codeSchemeDesignator(o.value("codschdes"));
  workitemkey(o.value("workitemkey"));
}
