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
#include "MUWLScheduledStationNameCode.hpp"

MUWLScheduledStationNameCode::MUWLScheduledStationNameCode()
{
  tableName("uwlschedstationnamecode");
  insert("codval");
  insert("codschdes");
  insert("codmea");
  insert("uwlindex");
}

MUWLScheduledStationNameCode::MUWLScheduledStationNameCode(const MUWLScheduledStationNameCode& cpy)
{
  tableName("uwlschedstationnamecode");
  insert("uwlindex", cpy.value("uwlindex"));
  insert("codval", cpy.value("codval"));
  insert("codmea", cpy.value("codmea"));
  insert("codschdes", cpy.value("codschdes"));
}

MUWLScheduledStationNameCode::~MUWLScheduledStationNameCode()
{
}

void
MUWLScheduledStationNameCode::printOn(ostream& s) const
{
  s << "MUWLScheduledStationNameCode:"
    //<< mScheduledProcedureStepID << ":"
    << this->value("uwlindex") << ":"
    << this->value("codval") << ":"
    << this->value("codmea") << ":"
    << this->value ("codschdes") << ":";
}

MUWLScheduledStationNameCode::MUWLScheduledStationNameCode(const MString& uwlIndex,
           const MString& codeValue,
           const MString& codeMeaning, const MString& codeSchemeDesignator)
{
  tableName("uwlschedstationnamecode");
  insert("uwlindex", uwlIndex);
  insert("codval", codeValue);
  insert("codmea", codeMeaning);
  insert("codschdes", codeSchemeDesignator);
}

void
MUWLScheduledStationNameCode::streamIn(istream& s)
{
  //s >> this->member;
}

void
MUWLScheduledStationNameCode::import(const MDomainObject& o)
{
  codeMeaning(o.value("codmea"));
  codeSchemeDesignator(o.value("codschdes"));
  codeValue(o.value("codval"));
  uwlIndex(o.value("uwlindex"));
}

MString
MUWLScheduledStationNameCode::uwlIndex() const
{
  return this->value("uwlindex");
}

MString
MUWLScheduledStationNameCode::codeValue() const
{
  return this->value("codval");
}

MString
MUWLScheduledStationNameCode::codeMeaning() const
{
  return this->value("codmea");
}

MString
MUWLScheduledStationNameCode::codeSchemeDesignator() const
{
  return this->value("codschdes");
}

void
MUWLScheduledStationNameCode::uwlIndex(const MString& s)
{
  insert("uwlindex", s);
}

void
MUWLScheduledStationNameCode::codeValue(const MString& s)
{
  insert("codval", s);
}

void
MUWLScheduledStationNameCode::codeMeaning(const MString& s)
{
  insert("codmea", s);
}

void
MUWLScheduledStationNameCode::codeSchemeDesignator(const MString& s)
{
  insert("codschdes", s);
}

