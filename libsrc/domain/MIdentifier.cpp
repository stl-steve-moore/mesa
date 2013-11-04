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
#include "MIdentifier.hpp"
#include "MDomainObject.hpp"
#include "MDBInterface.hpp"


static char rcsid[] = "$Id: MIdentifier.cpp,v 1.15 2004/08/06 14:34:25 ssurul01 Exp $";

MIdentifier::MIdentifier()
{
}

MIdentifier::MIdentifier(const MIdentifier& cpy)
{
}

MIdentifier::~MIdentifier()
{
}

void
MIdentifier::printOn(ostream& s) const
{
  s << "MIdentifier";
}

void
MIdentifier::streamIn(istream& s)
{
  //s >> this->member;
}

// Non-boiler plate methods to follow;

typedef struct {
  MIdentifier::MUID_TYPE t;
  char* idnam;
} UID_MAP;

MString
MIdentifier::dicomUID(MUID_TYPE t, MDBInterface& dbInterface) const
{
  UID_MAP m[] =  {
    { MUID_PATIENT, "uid_patient" },
    { MUID_VISIT, "uid_visit" },
    { MUID_STUDY, "uid_study" },
    { MUID_SERIES, "uid_series" },
    { MUID_SOPINSTANCE, "uid_sopinstance" },
    { MUID_TRANSACTION, "uid_transaction" },
    { MUID_PPS, "uid_pps" },
    { MUID_GPSPS, "uid_gpsps" },
    { MUID_GPPPS, "uid_gppps" }
  };

  int i;
  MString identifierName;

  for (i = 0; i < (int)DIM_OF(m); i++) {
    if (m[i].t == t) {
      identifierName = m[i].idnam;
      break;
    }
  }

  MCriteriaVector v;
  //MCriteria c = { "idnam", TBL_EQUAL, identifierName };
  MCriteria c;
  c.attribute = "idnam";
  c.oper = TBL_EQUAL;
  c.value = identifierName;
  v.push_back(c);

  MDomainObject domainID;
  domainID.tableName("identifiers");
  domainID.insert("idnam");
  domainID.insert("prefix");
  domainID.insert("nextval");

  dbInterface.select(domainID, v, NULL);

  MString r(domainID.value("prefix"));
  r += domainID.value("nextval");

  //MUpdate u = { "nextval", TBL_INCREMENT, "" };
  MUpdate u;
  u.attribute = "nextval";
  u.func = TBL_INCREMENT;
  u.value = "";
  MUpdateVector updateVector;
  updateVector.push_back(u);
  dbInterface.update(domainID, v, updateVector);

  return r;
}

typedef struct {
  MIdentifier::MID_TYPE t;
  char* idnam;
} ID_MAP;

MString
MIdentifier::mesaID(MID_TYPE t, MDBInterface& dbInterface) const
{
  ID_MAP m[] =  {
    { MID_PATIENT, "patient_id" },
    { MID_PLACERORDERNUMBER, "placer_order_num" },
    { MID_FILLERORDERNUMBER, "filler_order_num" },
    { MID_REQUESTEDPROCEDURE, "reqpro_id" },
    { MID_SPSID, "sps_id"},
    { MID_PPSID, "pps_id"},
    { MID_STUDYID, "study_id"},
    { MID_VISITNUMBER, "visit"},
    { MID_ACCOUNTNUMBER, "account"},
    { MID_MESSAGECONTROLID, "message_control_id"},
    { MID_FILLERAPPOINTMENTID, "filler_appoint_id"}

  };


  int i;
  MString identifierName;

  for (i = 0; i < (sizeof(m)/sizeof(m[0])); i++) {
    if (m[i].t == t) {
      identifierName = m[i].idnam;
      break;
    }
  }

  MCriteriaVector v;
  //MCriteria c = { "idnam", TBL_EQUAL, identifierName };
  MCriteria c;
  c.attribute = "idnam";
  c.oper = TBL_EQUAL;
  c.value = identifierName;

  v.push_back(c);

  MDomainObject domainID;
  domainID.tableName("identifiers");
  domainID.insert("idnam");
  domainID.insert("prefix");
  domainID.insert("nextval");

  dbInterface.select(domainID, v, NULL);

  MString r(domainID.value("prefix"));
  r += domainID.value("nextval");

  MUpdate u;
  MUpdateVector uv;
  u.attribute = "nextval";
  u.func      = TBL_INCREMENT;
  uv.push_back(u);
  dbInterface.update(domainID, v, uv);

  return r;
}

