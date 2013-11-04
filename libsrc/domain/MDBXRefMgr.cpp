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
#include "MDBXRefMgr.hpp"
#include "MPatient.hpp"
#include "MIssuer.hpp"
#include "MMWLObjects.hpp"
#include "MDBOFClient.hpp"
#include "MVisit.hpp"
#include "MLogClient.hpp"

MDBXRefMgr::MDBXRefMgr() : mDBInterface(NULL)
{
}

MDBXRefMgr::MDBXRefMgr(const MDBXRefMgr& cpy) : mDBInterface(cpy.mDBInterface)
{
}

MDBXRefMgr::~MDBXRefMgr()
{
  if (mDBInterface)
    delete mDBInterface;
}

void
MDBXRefMgr::printOn(ostream& s) const
{
  s << "MDBXRefMgr";
}

void
MDBXRefMgr::streamIn(istream& s)
{
  //s >> this->member;
}

MDBXRefMgr::MDBXRefMgr(const MString& databaseName)
{
  if (databaseName == "")
    mDBInterface = 0;
  else
    mDBInterface = new MDBInterface(databaseName);
}

int
MDBXRefMgr::openDatabase(const MString& databaseName)
{
  if (mDBInterface)
    delete mDBInterface;

  if (databaseName == "")
    mDBInterface = 0;
  else
    mDBInterface = new MDBInterface(databaseName);

  return 0;
}

int
MDBXRefMgr::admitRegisterPatient(const MPatient& inputPatient,
				     const MVisit& visit)
{
  MLogClient logClient;
  logClient.logTimeStamp(MLogClient::MLOG_VERBOSE,
		  "MDBXRefMgr::admitRegisterPatient enter method");

  // first do sanity check
  if (!mDBInterface) {
    logClient.logTimeStamp(MLogClient::MLOG_ERROR,
		    "MDBXRefMgr::admitRegisterPatient no DBInterface defined; programming or runtime error");
    return 1;
  }

  if (inputPatient.mapEmpty()) {
    logClient.logTimeStamp(MLogClient::MLOG_VERBOSE,
		    "MDBXRefMgr::admitRegisterPatient exit method; no patient to register");
    return 0;
  }

  // Make a copy of the domain object and remove the Cross Reference Key
  // We do not want to insert this into the database.
  MPatient patient(inputPatient);
  patient.remove("xrefkey");

  int status = 0;
  status = recordExists(patient);
  if (status < 0) {
    logClient.logTimeStamp(MLogClient::MLOG_ERROR,
		    "MDBXRefMgr::admitRegisterPatient; unable to determine if patient record exists");
  } else if (status != 0) {
    status = updateRecord(patient);
  } else {
    status = addRecord(patient);
  }

  if (status != 0) {
    logClient.logTimeStamp(MLogClient::MLOG_ERROR,
		    "MDBXRefMgr::admitRegisterPatient exit method; unable to update or add patient record");
    return status;
  }

  MIssuer issuer(patient.issuerOfPatientID());
  if (!recordExists(issuer)) {
    addRecord(issuer);
  }

  if (visit.mapEmpty())
    return 0;

  if (recordExists(visit))
    updateRecord(visit);
  else
    addRecord(visit);

  logClient.logTimeStamp(MLogClient::MLOG_VERBOSE,
		  "MDBXRefMgr::admitRegisterPatient exit method");
  return 0;
}

int
MDBXRefMgr::preRegisterPatient(const MPatient& patient,
				     const MVisit& visit)
{
  if (!mDBInterface)
    return 1;

  return this->admitRegisterPatient(patient, visit);
}
int
MDBXRefMgr::updateADTInfo(const MPatient& patient)
{
  // first do sanity check
  if (!mDBInterface)
    return 1;

  if (patient.mapEmpty())
    return 0;

  updateRecord(patient);
  return 0;
}

int
MDBXRefMgr::updateADTInfo(const MPatient& patient, const MVisit& visit)
{
  // first do sanity check
  if (!mDBInterface)
    return 1;

  if (patient.mapEmpty())
    return 0;

  updateRecord(patient);

  if (visit.mapEmpty())
    return 0;

  updateRecord(visit);
  return 0;
}

int
MDBXRefMgr::transferPatient(const MVisit& visit)
{
  // first do sanity check
  if (!mDBInterface)
    return 1;

  if (visit.mapEmpty())
    return 0;

  MPatient patient;

  patient.patientID(visit.patientID());
  patient.issuerOfPatientID(visit.issuerOfPatientID());

  if (!recordExists(patient))
    return 0;

  updateRecord(visit);
  return 0;
}

int
MDBXRefMgr::mergePatient(const MPatient& patient, const MString& issuer)
{
  if (!mDBInterface)
    return 1;

  MCriteriaVector criteria;

  MString priorID = patient.priorID(issuer);

  MCriteria c;
  c.attribute = "patid";
  c.oper      = TBL_EQUAL;
  c.value     = priorID;

  MCriteriaVector cv;
  cv.push_back(c);

  MUpdateVector updateVector;
  MUpdate u;

  u.attribute = "patid";
  u.func      = TBL_SET;
  u.value     = patient.patientID();
  updateVector.push_back(u);

  // Then delete from patient table.
  mDBInterface->remove(patient, cv);

  // Add the patient if it does not already exist
  if (!recordExists(patient)) {
    addRecord(patient);
  }

  return 0;
}

static void
singlePatientCallback(MDomainObject& domainObj, void*ctx)
{
  MPatient* p = (MPatient*) ctx;
  p->import(domainObj);
}

static void
multiPatientCallback(MDomainObject& domainObj, void*ctx)
{
  MPatient p;
  p.import(domainObj);
  cout << p << endl;

  MPatientVector* v = (MPatientVector*)ctx;
  (*v).push_back(p);
}

int
MDBXRefMgr::crossReferenceLookup(MPatientVector& v, const MString& patientID,
	const MString& issuer)

{
  if (!mDBInterface)
    return 1;

  MIssuer issuerObject(issuer);
  if (!recordExists(issuerObject)) {
    return 2;
  }

  // Clear output vector in case it has any data
  MPatientVector::iterator it = v.end();
  for (; it != v.begin(); it--) {
    v.pop_back();
  }

  MCriteriaVector cv;
  MCriteria c;
  c.attribute = "patid";
  c.oper      = TBL_EQUAL;
  c.value     = patientID;
  cv.push_back(c);

  c.attribute = "issuer";
  c.oper      = TBL_EQUAL;
  c.value     = issuer;
  cv.push_back(c);

  int status = 0;
  int rowCount = 0;
  MPatient p;
  MPatient returnedPatient;
  rowCount = mDBInterface->select(p, cv, singlePatientCallback, &returnedPatient);
  MString xRefKey = returnedPatient.xRefKey();
  cout << "XR: " << xRefKey << endl;

  if (rowCount == 1 && xRefKey == "") {
    v.push_back(returnedPatient);
  } else if (rowCount > 0 && xRefKey != "") {
    cout << "About to perform XRef lookup" << endl;
    MCriteriaVector cv1;
    c.attribute = "xrefkey";
    c.oper      = TBL_EQUAL;
    c.value     = xRefKey;
    cv1.push_back(c);
    rowCount = mDBInterface->select(p, cv1, multiPatientCallback, &v);
  }
  if (rowCount < 0) {
    status = 1;
  }

  return status;
}

// **********************************************************************************************
// FOLLOWING ARE PRIVATE FUNCTIONS ONLY MEANT TO BE USED BY THE CLASS MEMBER FUNCTIONS THEMSELVES
// **********************************************************************************************

int
MDBXRefMgr::recordExists(const MPatient& patient)
{
  if (patient.mapEmpty())
    return 0;

  MPatient p;
  MCriteriaVector cv;

  setCriteria(patient, cv);

  int status;
  status = mDBInterface->select(p, cv, NULL);
  if (status < 0) {
    // Maybe the table definition is not up to date.
    // Try a different table mapping
    int x = p.numAttributes();
    p.remove("addr");
    p.remove("xrefkey");
    MCriteriaVector cv1;
    setCriteria(patient, cv1);

    status = mDBInterface->select(p, cv1, NULL);
  }
  return status;
}

int
MDBXRefMgr::recordExists(const MVisit& visit)
{
  if (visit.mapEmpty())
    return 0;

  MVisit v;
  MCriteriaVector cv;

  setCriteria(visit, cv);

  return mDBInterface->select(v, cv, NULL);
}

int
MDBXRefMgr::recordExists(const MIssuer& issuer)
{
  if (issuer.mapEmpty())
    return 0;

  MIssuer i;
  MCriteriaVector cv;

  setCriteria(issuer, cv);

  return mDBInterface->select(i, cv, NULL);
}

int
MDBXRefMgr::addRecord(const MDomainObject& domainObject)
{
  MLogClient logClient;
  logClient.logTimeStamp(MLogClient::MLOG_VERBOSE,
	"MDBXRefMgr::addRecord(domainObj) enter method");
  int status = mDBInterface->insert(domainObject);
  if (status != 0) {
    logClient.logTimeStamp(MLogClient::MLOG_ERROR,
	"Could not insert patient record");
  }
  logClient.logTimeStamp(MLogClient::MLOG_VERBOSE,
	"MDBXRefMgr::addRecord(domainObj) exit method");
  return status;
}

int
MDBXRefMgr::addRecord(const MPatient& patient)
{
  MLogClient logClient;
  logClient.logTimeStamp(MLogClient::MLOG_VERBOSE,
	"MDBXRefMgr::addRecord(patient) enter method");

  int status = mDBInterface->insert(patient);
  if (status != 0) {
    logClient.logTimeStamp(MLogClient::MLOG_VERBOSE,
	"Could not insert patient record; about to remove addr and xrefkey");
    MPatient p (patient);
    p.remove("addr");
    p.remove("xrefkey");
    status = mDBInterface->insert(p);
    if (status == 0) {
      logClient.logTimeStamp(MLogClient::MLOG_VERBOSE,
	"Inserted Patient record w/o addr and xrefkey attributes");
    }
  }
  if (status != 0) {
    logClient.logTimeStamp(MLogClient::MLOG_ERROR,
	"Could not insert patient record");
  }
  logClient.logTimeStamp(MLogClient::MLOG_VERBOSE,
	"MDBXRefMgr::addRecord(patient) exit method");
  return status;
}

int
MDBXRefMgr::deleteRecord(const MPatient& patient)
{
  MCriteriaVector cv;

  setCriteria(patient, cv);
  int status = mDBInterface->remove(patient, cv);
  return status;
}

int
MDBXRefMgr::deleteRecord(const MVisit& visit)
{
  MCriteriaVector cv;

  setCriteria(visit, cv);
  int status = mDBInterface->remove(visit, cv);
  return status;
}

int
MDBXRefMgr::updateRecord(const MPatient& patient)
{
  MLogClient logClient;
  logClient.logTimeStamp(MLogClient::MLOG_VERBOSE,
	"MDBXRefMgr::updateRecord(patient) enter method");
  MCriteriaVector cv;
  MUpdateVector   uv;

  setCriteria(patient, cv);
  setCriteria(patient, uv);

  int status = mDBInterface->update(patient, cv, uv);
  if (status != 0) {
    logClient.logTimeStamp(MLogClient::MLOG_VERBOSE,
	"Could not update patient; trying w/o addr, xrefkey");
    MPatient p(patient);
    p.remove("addr");
    p.remove("xrefkey");
    MCriteriaVector cv1;
    MUpdateVector   uv1;
    setCriteria(p, cv1);
    setCriteria(p, uv1);
    status = mDBInterface->update(p, cv1, uv1);
    if (status == 0) {
      logClient.logTimeStamp(MLogClient::MLOG_VERBOSE,
	"Updated patient successfully w/o addr, xrefkey");
    }
  }
  if (status != 0) {
    logClient.logTimeStamp(MLogClient::MLOG_ERROR,
	"Unable to update patient record");
  }
  logClient.logTimeStamp(MLogClient::MLOG_VERBOSE,
	"MDBXRefMgr::updateRecord(patient) exit method");
  return status;
}

int
MDBXRefMgr::updateRecord(const MVisit& visit)
{
  MCriteriaVector cv;
  MUpdateVector   uv;

  setCriteria(visit, cv);
  setCriteria(visit, uv);

  int status = mDBInterface->update(visit, cv, uv);
  return status;
}

void
MDBXRefMgr::setCriteria(const MPatient& patient, MCriteriaVector& cv)
{
  MCriteria c;
  
  c.attribute = "patid";
  c.oper      = TBL_EQUAL;
  c.value     = patient.patientID();
  cv.push_back(c);

  MString issuer(patient.issuerOfPatientID());

  if (issuer.size())
  {
    c.attribute = "issuer";
    c.oper      = TBL_EQUAL;
    c.value     = patient.issuerOfPatientID();
    cv.push_back(c);
  }
}

void
MDBXRefMgr::setCriteria(const MVisit& visit, MCriteriaVector& cv)
{
  MCriteria c;
  
  c.attribute = "patid";
  c.oper      = TBL_EQUAL;
  c.value     = visit.patientID();
  cv.push_back(c);

  MString issuer(visit.issuerOfPatientID());

  if (issuer.size())
  {
    c.attribute = "issuer";
    c.oper      = TBL_EQUAL;
    c.value     = visit.issuerOfPatientID();
    cv.push_back(c);
  }

  c.attribute = "visnum";
  c.oper      = TBL_EQUAL;
  c.value     = visit.visitNumber();
  cv.push_back(c);
}

void
MDBXRefMgr::setCriteria(const MIssuer& issuer, MCriteriaVector& cv)
{
  MCriteria c;
  
  c.attribute = "issuer";
  c.oper      = TBL_EQUAL;
  c.value     = issuer.issuer();
  cv.push_back(c);
}

void
MDBXRefMgr::setCriteria(const MDomainObject& domainObject, MUpdateVector& uv)
{
  MUpdate u;
  MDomainMap m = domainObject.map();
  for (MDomainMap::iterator i = m.begin(); i != m.end(); i++)
  {
    u.attribute = (*i).first;
    u.func      = TBL_SET;
    u.value     = (*i).second;
    uv.push_back(u);
  }
}

