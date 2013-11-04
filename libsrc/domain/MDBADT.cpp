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
#include "MDBADT.hpp"
#include "MPatient.hpp"
#include "MVisit.hpp"
#include "MDBInterface.hpp"
#include "MLogClient.hpp"


MDBADT::MDBADT()
{
}

MDBADT::MDBADT(const MDBADT& cpy) : mDBInterface(cpy.mDBInterface)
{
}

MDBADT::~MDBADT()
{
  if (mDBInterface)
    delete mDBInterface;
}

void
MDBADT::printOn(ostream& s) const
{
  s << "MDBADT";
}

void
MDBADT::streamIn(istream& s)
{
  //s >> this->member;
}

// Now, the non-boiler plate methods will follow.

MDBADT::MDBADT(const string& databaseName)
{
  mDBInterface = new MDBInterface(databaseName);
}

int
MDBADT::admitRegisterPatient(const MPatient& patient, const MVisit& visit)
{
    // first do sanity check
  if (!mDBInterface)
    return 0;

  if (patient.mapEmpty())
    return 0;

  // check if patient already exists
  MCriteriaVector cv;
  MCriteria c;
  
  c.attribute = "patid";
  c.oper      = TBL_EQUAL;
  c.value     = patient.patientID();
  cv.push_back(c);

  c.attribute = "issuer";
  c.oper      = TBL_EQUAL;
  c.value     = patient.issuerOfPatientID();
  cv.push_back(c);

  MPatient p;

  if (mDBInterface->select(p, cv, NULL))
  {
    // patient already present, update the entry
    MUpdate u;
    MUpdateVector uv;
    const MDomainMap& m = patient.map();
    for (MDomainMap::const_iterator i = m.begin(); i != m.end(); i++)
    {
      u.attribute = (*i).first;
      u.func      = TBL_SET;
      u.value     = (*i).second;
      uv.push_back(u);
    }
    
    mDBInterface->update(patient, cv, uv);
  } //endif
  else // add a new patient
    mDBInterface->insert(patient);

  // Now deal with the visit object.  Assume that patient id in visit object may not be the same
  c.attribute = "patid";
  c.oper      = TBL_EQUAL;
  c.value     = visit.patientID();
  cv.push_back(c);

  c.attribute = "issuer";
  c.oper      = TBL_EQUAL;
  c.value     = visit.issuerOfPatientID();
  cv.push_back(c);

  c.attribute = "visnum";
  c.oper      = TBL_EQUAL;
  c.value     = visit.visitNumber();
  cv.push_back(c);

  MVisit v;

  if (mDBInterface->select(v, cv, NULL))
  {
    // visit already present, update the entry
    MUpdate u;
    MUpdateVector uv;
    const MDomainMap& m = visit.map();
    for (MDomainMap::const_iterator i = m.begin(); i != m.end(); i++)
    {
      u.attribute = (*i).first;
      u.func      = TBL_SET;
      u.value     = (*i).second;
      uv.push_back(u);
    }
    
    mDBInterface->update(visit, cv, uv);
  } //endif
  else // add a new visit
    mDBInterface->insert(visit);
}


int
MDBADT::updatePatient(MPatient& patient)
{
  // first do sanity check
  if (!mDBInterface)
    return 0;

  if (patient.mapEmpty())
    return 0;

  // check if patient already exists
  MCriteriaVector cv;
  MCriteria c;
  
  c.attribute = "patid";
  c.oper      = TBL_EQUAL;
  c.value     = patient.patientID();
  cv.push_back(c);

  c.attribute = "issuer";
  c.oper      = TBL_EQUAL;
  c.value     = patient.issuerOfPatientID();
  cv.push_back(c);

  MPatient p;

  if (mDBInterface->select(p, cv, NULL))
  {
    // patient already present, update the entry
    MUpdate u;
    MUpdateVector uv;
    const MDomainMap& m = patient.map();
    for (MDomainMap::const_iterator i = m.begin(); i != m.end(); i++)
    {
      u.attribute = (*i).first;
      u.func      = TBL_SET;
      u.value     = (*i).second;
      uv.push_back(u);
    }
    
    mDBInterface->update(patient, cv, uv);
  } //endif
  else 
    return 0;
}
