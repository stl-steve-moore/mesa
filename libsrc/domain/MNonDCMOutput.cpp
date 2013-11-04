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
#include "MNonDCMOutput.hpp"

MNonDCMOutput::MNonDCMOutput()
{
  tableName("nondcmoutput");
  insert("codval");
  insert("codschdes");
  insert("codmea");
  insert("workitemkey");
}

MNonDCMOutput::MNonDCMOutput(const MNonDCMOutput& cpy) :
  mCodeValue(cpy.mCodeValue),
  mCodeMeaning(cpy.mCodeMeaning),
  mCodeSchemeDesignator(cpy.mCodeSchemeDesignator),
  mWorkitemkey(cpy.mWorkitemkey)
{
  tableName("nondcmoutput");
  insert("codval", cpy.mCodeValue);
  insert("codmea", cpy.mCodeMeaning);
  insert("codschdes", cpy.mCodeSchemeDesignator);
  insert("workitemkey", cpy.mWorkitemkey);
}

MNonDCMOutput::~MNonDCMOutput()
{
}

void
MNonDCMOutput::printOn(ostream& s) const
{
  s << "MNonDCMOutput:"
    << mCodeValue  << ":"
    << mCodeMeaning << ":"
    << mWorkitemkey << ":"
    << mCodeSchemeDesignator << "\n";
}

MNonDCMOutput::MNonDCMOutput(
           const MString& codeValue,
           const MString& codeMeaning, const MString& codeSchemeDesignator,
           const MString& workitemkey
           ) :
  mCodeValue(codeValue),
  mCodeMeaning(codeMeaning),
  mCodeSchemeDesignator(codeSchemeDesignator),
  mWorkitemkey(workitemkey)
{
  tableName("nondcmoutput");
  insert("codval", codeValue);
  insert("codmea", codeMeaning);
  insert("codschdes", codeSchemeDesignator);
  insert("workitemkey", workitemkey);
}

MNonDCMOutput::MNonDCMOutput(
           MString& s,
           const MString& workitemkey
           ) :
  mWorkitemkey(workitemkey)
{
  MString emptyString;

  tableName("nondcmoutput");
  mCodeValue = s.getToken('^', 0);
  insert("codval", mCodeValue);
  if( s.tokenExists('^', 1)) mCodeSchemeDesignator = s.getToken('^',1);
  insert("codschdes", mCodeSchemeDesignator);
  if( s.tokenExists('^', 2)) mCodeMeaning = s.getToken('^',2);
  insert("codmea", mCodeMeaning);
  insert("workitemkey",mWorkitemkey);
}

MString
MNonDCMOutput::codeValue() const
{
  return mCodeValue;
}

MString
MNonDCMOutput::codeMeaning() const
{
  return mCodeMeaning;
}

MString
MNonDCMOutput::codeSchemeDesignator() const
{
  return mCodeSchemeDesignator;
}

MString
MNonDCMOutput::workitemkey() const
{
  return mWorkitemkey;
}

void
MNonDCMOutput::codeValue(const MString& s)
{
  mCodeValue = s;
  remove("codval");
  insert("codval", s);
}

void
MNonDCMOutput::codeMeaning(const MString& s)
{
  mCodeMeaning = s;
  remove("codmea");
  insert("codmea", s);
}

void
MNonDCMOutput::codeSchemeDesignator(const MString& s)
{
  mCodeSchemeDesignator = s;
  remove("codschdes");
  insert("codschdes", s);
}

void
MNonDCMOutput::workitemkey(const MString& s)
{
  mWorkitemkey = s;
  remove("workitemkey");
  insert("workitemkey", s);
}

void
MNonDCMOutput::streamIn(istream& s)
{
  //s >> this->member;
}

void MNonDCMOutput::import(const MDomainObject& o)
{
  codeValue(o.value("codval"));
  codeMeaning(o.value("codmea"));
  codeSchemeDesignator(o.value("codschdes"));
  workitemkey(o.value("workitemkey"));
}

void MNonDCMOutput::update( MDBInterface &db) {

  MCriteriaVector cv;
  MCriteria c;
  c.attribute = "workitemkey";
  c.oper      = TBL_EQUAL;
  c.value     = mWorkitemkey;
  cv.push_back(c);

  MUpdateVector   uv;
  MUpdate         u1;
  u1.attribute = "codval";
  u1.func      = TBL_SET;
  u1.value     = mCodeValue;
  uv.push_back(u1);
  MUpdate         u2;
  u2.attribute = "codmea";
  u2.func      = TBL_SET;
  u2.value     = mCodeMeaning;
  uv.push_back(u2);
  MUpdate         u3;
  u3.attribute = "codschdes";
  u3.func      = TBL_SET;
  u3.value     = mCodeSchemeDesignator;
  uv.push_back(u3);

  db.update( *this, cv, uv);
}

void MNonDCMOutput::dbremove( MDBInterface *db)
{
  MCriteriaVector cv;
  MCriteria c;
  c.attribute = "workitemkey";
  c.oper      = TBL_EQUAL;
  c.value     = mWorkitemkey;
  cv.push_back(c);

  db->remove( *this, cv);
}

void MNonDCMOutput::dbinsert( MDBInterface *db)
{
  db->insert( *this);
}

