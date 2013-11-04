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

#include "MDICOMDir.hpp"
  
MDICOMDir::MDICOMDir()
{
}

MDICOMDir::~MDICOMDir()
{
}

void
MDICOMDir::printOn(ostream& s) const
{
  s << "MDICOMDir";
}


void
MDICOMDir::streamIn(istream& s)
{
  //s >> mPatientID;
}

void
MDICOMDir::addPatient(const MPatient& patient)
{
  mPatientVector.push_back(patient);
}

int
MDICOMDir::patientCount() const
{
  return mPatientVector.size();
}

MPatient
MDICOMDir::getPatient(int index) const
{
  if (index < mPatientVector.size()) {
    return mPatientVector[index];
  } else {
    MPatient p;
    return p;
  }
}

#if 0
void MPatient::import(const MDomainObject& o)
{
  patientID(o.value("patid"));
  issuerOfPatientID(o.value("issuer"));
  patientID2(o.value("patid2"));
  issuerOfPatientID2(o.value("issuer2"));
  patientName(o.value("nam"));
  dateOfBirth(o.value("datbir"));
  patientSex(o.value("sex"));
  priorIDList(o.value("prioridlist"));
}

void
MPatient::fillMap()
{
  insert("patid", mPatientID);
  insert("issuer", mIssuerOfPatientID);
  insert("patid2", mPatientID2);
  insert("issuer2", mIssuerOfPatientID2);
  insert("nam", mPatientName);
  insert("datbir", mDateOfBirth);
  insert("sex", mPatientSex);
}
#endif
