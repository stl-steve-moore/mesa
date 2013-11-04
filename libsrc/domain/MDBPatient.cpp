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
#include "MDBPatient.hpp"
#include "MPatient.hpp"
#include "ctn_api.h"

MDBPatient::MDBPatient()
{
}

MDBPatient::MDBPatient(const MDBPatient& cpy)
{
}

MDBPatient::~MDBPatient()
{
}

void
MDBPatient::printOn(ostream& s) const
{
  s << "MDBPatient";
}

void
MDBPatient::streamIn(istream& s)
{
  //s >> this->member;
}

// Non-boilerplate methods follow

MDBPatient::MDBPatient(const MString& databaseName)
{
  this->open(databaseName, "patient");
}

typedef struct {
  char patientID[21];
  char issuer[21];
  char patientID2[21];
  char issuer2[21];
  char patientName[21];
  char dateOfBirth[9];
  char patientSex[5];
} PATIENT_STRUCT;

void
MDBPatient::insert(const MPatient& patient)
{
  PATIENT_STRUCT p;
  TBL_FIELD f[] = {
    { "patid", TBL_STRING, sizeof(p.patientID), sizeof(p.patientID), 0,
      p.patientID},
    { "issuer", TBL_STRING, sizeof(p.issuer), sizeof(p.issuer), 0,
      p.issuer},
    { "patid2", TBL_STRING, sizeof(p.patientID2), sizeof(p.patientID2), 0,
      p.patientID2},
    { "issuer2", TBL_STRING, sizeof(p.issuer2), sizeof(p.issuer2), 0,
      p.issuer2},
    { "nam", TBL_STRING, sizeof(p.patientName), sizeof(p.patientName), 0,
      p.patientName},
    { "datbir", TBL_STRING, sizeof(p.dateOfBirth), sizeof(p.dateOfBirth), 0,
      p.dateOfBirth},
    { "sex", TBL_STRING, sizeof(p.patientSex), sizeof(p.patientSex), 0,
      p.patientSex},
    { 0, TBL_STRING, 0, 0, 0, 0 }
  };

  this->safeExport(patient.patientID(), p.patientID, sizeof(p.patientID));
  this->safeExport(patient.issuerOfPatientID(), p.issuer, sizeof(p.issuer));
  this->safeExport(patient.patientID2(), p.patientID2, sizeof(p.patientID2));
  this->safeExport(patient.issuerOfPatientID2(), p.issuer2, sizeof(p.issuer2));
  this->safeExport(patient.patientName(), p.patientName, sizeof(p.patientName));
  this->safeExport(patient.dateOfBirth(), p.dateOfBirth, sizeof(p.dateOfBirth));
  this->safeExport(patient.patientSex(), p.patientSex, sizeof(p.patientSex));
  this->safeExport(patient.patientName(), p.patientName, sizeof(p.patientName));
  this->insertRow(f);
}
