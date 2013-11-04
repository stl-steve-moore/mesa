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
#include "MDBVisit.hpp"
#include "MVisit.hpp"
#include "ctn_api.h"

MDBVisit::MDBVisit()
{
}

MDBVisit::MDBVisit(const MDBVisit& cpy)
{
}

MDBVisit::~MDBVisit()
{
}

void
MDBVisit::printOn(ostream& s) const
{
  s << "MDBVisit";
}

void
MDBVisit::streamIn(istream& s)
{
  //s >> this->member;
}

// Non-boilerplate methods follow

MDBVisit::MDBVisit(const string& databaseName)
{
  this->open(databaseName, "visit");
}

typedef struct {
  char visitNumber[21];
  char patientID[21];
  char issuer[21];
  char patientClass[21];
  char patientLocation[81];
  char attendingDoctor[61];
  char admitDate[13];
  char admitTime[13];
} VISIT_STRUCT;

MDBVisit::insert(const MVisit& visit)
{
  VISIT_STRUCT v;
  TBL_FIELD f[] = {
    { "visnum", TBL_STRING, sizeof(v.visitNumber), sizeof(v.visitNumber), 0,
      v.visitNumber},
    { "patid", TBL_STRING, sizeof(v.patientID), sizeof(v.patientID), 0,
      v.patientID},
    { "issuer", TBL_STRING, sizeof(v.issuer), sizeof(v.issuer), 0,
      v.issuer},
    { "patCla", TBL_STRING, sizeof(v.patientClass), sizeof(v.patientClass), 0,
      v.patientClass},
    { "asspatloc", TBL_STRING, sizeof(v.patientLocation), sizeof(v.patientLocation), 0,
      v.patientLocation},
    { "attdoc", TBL_STRING, sizeof(v.attendingDoctor), sizeof(v.attendingDoctor), 0,
      v.attendingDoctor},
    { "admdat", TBL_STRING, sizeof(v.admitDate), sizeof(v.admitDate), 0,
      v.admitDate},
    { "admtim", TBL_STRING, sizeof(v.admitTime), sizeof(v.admitTime), 0,
      v.admitTime},
    { 0, TBL_STRING, 0, 0, 0, 0 }
  };

  this->safeExport(visit.visitNumber(), v.visitNumber, sizeof(v.visitNumber));
  this->safeExport(visit.patientID(), v.patientID, sizeof(v.patientID));
  this->safeExport(visit.issuerOfPatientID(), v.issuer, sizeof(v.issuer));
  this->safeExport(visit.patientClass(), v.patientClass, sizeof(v.patientClass));
  this->safeExport(visit.assignedPatientLocation(), v.patientLocation, 
                   sizeof(v.patientLocation));
  this->safeExport(visit.attendingDoctor(), v.attendingDoctor, 
                   sizeof(v.attendingDoctor));
  this->safeExport(visit.admitDate(), v.admitDate, sizeof(v.admitDate));
  this->safeExport(visit.admitTime(), v.admitTime, sizeof(v.admitTime));
  this->insertRow(f);
}
