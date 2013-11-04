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
#include "MSchedule.hpp"

MSchedule::MSchedule()
{
  tableName("schedule");
  insert("spsindex");
  insert("uniserid");
  insert("spsdes");
}

MSchedule::MSchedule(const MSchedule& cpy) :
  mUniversalServiceID(cpy.mUniversalServiceID),
  mSPSIndex(cpy.mSPSIndex),
  mSPSDescription(cpy.mSPSDescription)
{
  tableName("schedule");
  insert("uniserid", cpy.mUniversalServiceID);
  insert("spsindex", cpy.mSPSIndex);
  insert("spsdes", cpy.mSPSDescription);
}

MSchedule::~MSchedule()
{
}

void
MSchedule::printOn(ostream& s) const
{
  s << "MSchedule:"
    << mUniversalServiceID << ":"
    << mSPSIndex << ":"
    << mSPSDescription << ":" ;
}

MSchedule::MSchedule(const MString& universalServiceID,
           const MString& spsIndex,
	   const MString& sPSDescription) :
  mUniversalServiceID(universalServiceID),
  mSPSIndex(spsIndex),
  mSPSDescription(sPSDescription)
{
  tableName("schedule");
  insert("uniserid", universalServiceID);
  insert("spsindex", spsIndex);
  insert("spsdes", sPSDescription);
}

MString
MSchedule::universalServiceID() const
{
  return mUniversalServiceID;
}

MString
MSchedule::spsIndex() const
{
  return mSPSIndex;
}

MString
MSchedule::sPSDescription() const
{
  return mSPSDescription;
}

void
MSchedule::universalServiceID(const MString& s)
{
  mUniversalServiceID = s;
  insert("uniserid", s);
}

void
MSchedule::spsIndex(const MString& s)
{
  mSPSIndex = s;
  insert("spsindex", s);
}

void
MSchedule::sPSDescription(const MString& s)
{
  mSPSDescription = s;
  insert("spsdes", s);
}


void
MSchedule::streamIn(istream& s)
{
  //s >> this->member;
}

void
MSchedule::import(MDomainObject& o)
{
  universalServiceID(o.value("uniserid"));
  sPSDescription(o.value("spsdes"));
  spsIndex(o.value("spsindex"));
}
