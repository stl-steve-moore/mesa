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

#include <strstream>
#include "MESA.hpp"
#include "MDBImageManagerJapanese.hpp"

#include "MPatient.hpp"
#include "MStudy.hpp"
#include "MSeries.hpp"
#include "MPatientStudy.hpp"
#include "MDICOMApp.hpp"
#include "MWorkOrder.hpp"
#include "MDBIMClient.hpp"

#include "MVisit.hpp"
#include "MOrder.hpp"
#include "MFillerOrder.hpp"
#include "MPlacerOrder.hpp"
#include "MCharsetEncoder.hpp"
#include "MLogClient.hpp"

//#include "MDBInterface.hpp"

MDBImageManagerJapanese::MDBImageManagerJapanese() :
  mDBInterface(0),
  mDBName("")
{
}

MDBImageManagerJapanese::MDBImageManagerJapanese(const MDBImageManagerJapanese& cpy)
{
  if (mDBInterface)
    delete mDBInterface;
}

MDBImageManagerJapanese::~MDBImageManagerJapanese()
{
}

void
MDBImageManagerJapanese::printOn(ostream& s) const
{
  s << "MDBImageManagerJapanese";
}

void
MDBImageManagerJapanese::streamIn(istream& s)
{
  //s >> this->member;
}

// Now, the non-boiler plate methods will follow.

MDBImageManagerJapanese::MDBImageManagerJapanese(const string& databaseName) :
  mDBName(databaseName),
  mDBInterface(0)
{
  if (databaseName != "")
    mDBInterface = new MDBInterface(databaseName);
}

int
MDBImageManagerJapanese::initialize()
{
//  if (mDBInterface == 0)
//    return -1;

  return 0;
}

int
MDBImageManagerJapanese::initialize(const MString& databaseName)
{
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_VERBOSE,
		"<no peer>", "MDBImageManagerJapanese::initialize",
		__LINE__,
		"Enter method; database name: ", databaseName);

  if (mDBInterface != 0) {
    if (databaseName == mDBName) {
      logClient.logTimeStamp(MLogClient::MLOG_VERBOSE,
	"MDBImageManagerJapanese::initialize already has a DB interface; exit method");
      return 0;
    }
    logClient.logTimeStamp(MLogClient::MLOG_ERROR,
	MString("MDBImageManagerJapanese::initialize existing DB name differs from new initialization request, exiting with error (") +
	mDBName + ":" + databaseName + ")" );

    return -1;
  }

  mDBName = databaseName;
  if (databaseName != "")
    mDBInterface = new MDBInterface();

  if (mDBInterface->initialize(mDBName) != 0) {
    MLogClient logClient;
    logClient.log(MLogClient::MLOG_ERROR,
		"<no peer>", "MDBImageManagerJapanese::initialize",
		__LINE__,
		"Unable to initialize database: ", databaseName);
    return 1;
  }

    logClient.log(MLogClient::MLOG_VERBOSE,
		"<no peer>", "MDBImageManagerJapanese::initialize",
		__LINE__,
		"Exit method");
  return 0;
}

int
MDBImageManagerJapanese::admitRegisterPatient(const MPatient& patient,
				     const MVisit& visit)
{
  MLogClient logClient;
  logClient.logTimeStamp(MLogClient::MLOG_VERBOSE,
	"MDBImageManagerJapanese::admitRegisterPatient enter method");

  // first do sanity check
  if (!mDBInterface) {
    logClient.logTimeStamp(MLogClient::MLOG_ERROR,
		"MDBImageManagerJapanese::admitRegisterPatient no DBInterface defined; programming or runtime error");

    return 0;
  }

  if (patient.mapEmpty()) {
    logClient.logTimeStamp(MLogClient::MLOG_VERBOSE,
		"MDBImageManagerJapanese::admitRegisterPatient exit method; no patient to register");

    return 1;
  }
  char pNameISO2022JP[1024];
  char pNameEUCJP[1024];
  int outputLength = 0;
  patient.patientName().safeExport(pNameISO2022JP, sizeof(pNameISO2022JP));
  MCharsetEncoder e;
  int status = 0;
  logClient.logTimeStamp(MLogClient::MLOG_VERBOSE,
	MString("Patient Name in ISO2022JP format: ") + pNameISO2022JP);

  status = e.xlate(pNameEUCJP, outputLength, (int)sizeof(pNameEUCJP),
	pNameISO2022JP, ::strlen(pNameISO2022JP),
	"ISO2022JP", "EUC_JP");
  if (status != 0) {
    logClient.logTimeStamp(MLogClient::MLOG_VERBOSE,
	"MDBImageManagerJapanese::admitRegisterPatient exit method, unable to translate from ISO2022JP to EUCJP");
    return 1;
  }

  pNameEUCJP[outputLength] = '\0';
  logClient.logTimeStamp(MLogClient::MLOG_VERBOSE,
        MString("Patient Name in EUC_JP format: ") + pNameEUCJP);

  MPatient p (patient);
  p.patientName(pNameEUCJP);

  status = this->recordExists(p);
  if (status < 0) {
    logClient.logTimeStamp(MLogClient::MLOG_ERROR,
		"MDBImageManagerJapanese::admitRegisterPatient; unable to determine if patient record exists");
  } else if (status != 0) {
    status = updateRecord(p);
  } else {
    status = addRecord(p);
  }

  if (visit.mapEmpty())
    return -1;

  if (recordExists(visit))
    updateRecord(visit);
  else
    addRecord(visit);

  return 0;
}

int
MDBImageManagerJapanese::preRegisterPatient(const MPatient& patient,
				     const MVisit& visit)
{
  return this->admitRegisterPatient(patient, visit);
}
int
MDBImageManagerJapanese::updateADTInfo(const MPatient& patient)
{
  // first do sanity check
  if (!mDBInterface)
    return 0;

  if (patient.mapEmpty())
    return -1;

  updateRecord(patient);

  return 0;
}

int
MDBImageManagerJapanese::updateADTInfo(const MPatient& patient, const MVisit& visit)
{
  // first do sanity check
  if (!mDBInterface)
    return 0;

  if (patient.mapEmpty())
    return -1;

  updateRecord(patient);

  if (visit.mapEmpty())
    return -1;

  updateRecord(visit);

  return 0;
}

int
MDBImageManagerJapanese::transferPatient(const MVisit& visit)
{
  // first do sanity check
  if (!mDBInterface)
    return 0;

  if (visit.mapEmpty())
    return -1;

  MPatient patient;

  patient.patientID(visit.patientID());
  patient.issuerOfPatientID(visit.issuerOfPatientID());

  if (!recordExists(patient))
    return 0;

  updateRecord(visit);

  return 0;
}

int
MDBImageManagerJapanese::mergePatient(const MPatient& patient)
{
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_VERBOSE,
		"<no peer>", "MDBImageManagerJapanese::mergePatient",
		__LINE__,
		"Enter method");

  if (mDBInterface == 0) {
    logClient.logTimeStamp(MLogClient::MLOG_WARN,
		    "Database was not initialized, return from method");
    return 0;
  }

  MCriteriaVector criteria;

  MString s = patient.priorIDList();
  MString priorID = s.getToken('^', 0);

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

  MStudy study;
  study.patientID(patient.patientID());

  char tmp[512];
  strstream xx(tmp, sizeof(tmp));
  xx << "About to update Study Table: "
	  << "Previous ID (" << priorID << "), "
	  << "New ID: (" << u.value << ")"
	  << '\0';
  logClient.logTimeStamp(MLogClient::MLOG_VERBOSE, tmp);

  mDBInterface->update(study, cv, updateVector);

  // Then delete from patient table.
  mDBInterface->remove(patient, cv);

  // Add the patient if it does not already exist
  this->enter(patient);

  return 0;
}

int
MDBImageManagerJapanese::enterOrder(const MPatient& patient, const MPlacerOrder& order)
{
  MLogClient logClient;
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

#if 0
  c.attribute = "issuer";
  c.oper      = TBL_EQUAL;
  c.value     = patient.issuerOfPatientID();
  cv.push_back(c);
#endif

  MPatient p;
  MPatient patientEUC(patient);
  this->mapISOToEUCJP(patientEUC);

  if (mDBInterface->select(p, cv, NULL))
  {
    // patient already present, update the entry
    MUpdate u;
    MUpdateVector uv;
    const MDomainMap& m = patientEUC.map();
    for (MDomainMap::const_iterator i = m.begin(); i != m.end(); i++)
    {
      u.attribute = (*i).first;
      u.func      = TBL_SET;
      u.value     = (*i).second;
      uv.push_back(u);
    }
    
     mDBInterface->update(patientEUC, cv, uv);
  } //endif
  else { // add a new patient
    mDBInterface->insert(patientEUC);
  }
  // finished with MPatient
  return 0;
}

int
MDBImageManagerJapanese::enterSOPInstance(const MPatient& patient,
				  const MStudy& study,
				  const MSeries& series,
				  const MSOPInstance& sopInstance)
{
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_VERBOSE, "",
                  "MDBImageManagerJapanese::enterSOPInstance", __LINE__,
		  "Enter method");
  if (mDBInterface == 0) {
    logClient.log(MLogClient::MLOG_VERBOSE,
	"MDBImageManagerJapanese::enterSOPInstance no DB connection; cannot enter SOP Instance");
    return 0;
  }

  this->enter(patient);

  MStudy studyEUCJP(study);
  this->mapISOToEUCJP(studyEUCJP);
  this->enter(studyEUCJP);

  this->enter(series, study);

  this->enter(sopInstance, study, series);
  
  logClient.log(MLogClient::MLOG_VERBOSE, "",
                  "MDBImageManagerJapanese::enterSOPInstance", __LINE__,
		  "Exit method");
  return 0;
}

int
MDBImageManagerJapanese::queryDICOMPatientRoot(const MPatient& patient,
				       const MStudy& study,
				       const MSeries& series,
				       const MSOPInstance& sopInstance,
				       const MString& startLevel,
				       const MString& stopLevel,
				       MDBIMClient& client)
{
  if (mDBInterface == 0)
    return 0;

  this->clearVectors();
  MPatientVector patientVector;
  MStudyVector studyVector;
  MSeriesVector seriesVector;
  MSOPInstanceVector sopInstanceVector;

  if (startLevel == "PATIENT")
    this->fillPatientVector(patient, patientVector);
  else {
    MPatient p;
    patientVector.push_back(p);
  }

  if (stopLevel == "PATIENT") {
    for (MPatientVector::iterator pIter = patientVector.begin();
	 pIter != patientVector.end();
	 pIter++) {
      MStudy s1;
      MSeries s2;
      MSOPInstance s3;
      client.selectCallback(*pIter, s1, s2, s3);
    }
    return 0;
  }

  for (MPatientVector::iterator pIterator = patientVector.begin();
	 pIterator != patientVector.end();
	 pIterator++) {
    this->fillStudyVector(*pIterator, study, studyVector);
  }

  if (stopLevel == "STUDY") {
    for (MPatientVector::iterator pIter = patientVector.begin();
       pIter != patientVector.end();
       pIter++) {
      for (MStudyVector::iterator studyIter = studyVector.begin();
	 studyIter != studyVector.end();
	 studyIter++) {
	if (((*pIter).patientID() == "") ||
	    ((*pIter).patientID() == (*studyIter).patientID()) ) {
	  MSeries x1;
	  MSOPInstance x2;
	  client.selectCallback(*pIter, *studyIter, x1, x2);
	}
      }
    }
    return 0;
  }

  for (MStudyVector::iterator studyIterator = studyVector.begin();
	 studyIterator != studyVector.end();
	 studyIterator++) {
    this->fillSeriesVector(*studyIterator, series, seriesVector);
  }

  if (stopLevel == "SERIES") {
    for (MPatientVector::iterator pIter = patientVector.begin();
       pIter != patientVector.end();
       pIter++) {
      for (MStudyVector::iterator studyIter = studyVector.begin();
	 studyIter != studyVector.end();
	 studyIter++) {
	if (((*pIter).patientID() == "") ||
	    ((*pIter).patientID() == (*studyIter).patientID()) ) {
	  for (MSeriesVector::iterator seriesIter = seriesVector.begin();
		seriesIter != seriesVector.end();
		seriesIter++) {
	    if ((*studyIter).studyInstanceUID() == (*seriesIter).studyInstanceUID()) {
	      MSOPInstance y2;
	      client.selectCallback(*pIter, *studyIter, *seriesIter, y2);
	    }
	  }
	}
      }
    }
    return 0;
  }

  // We must be stopping at the IMAGE Level

  for (MSeriesVector::iterator seriesIterator = seriesVector.begin();
	 seriesIterator != seriesVector.end();
	 seriesIterator++) {
    this->fillSOPInstanceVector(*seriesIterator, sopInstance,
				sopInstanceVector);
  }

  {
    for (MPatientVector::iterator pIter = patientVector.begin();
        pIter != patientVector.end();
        pIter++) {
      for (MStudyVector::iterator studyIter = studyVector.begin();
	  studyIter != studyVector.end();
	  studyIter++) {
	if ( ((*pIter).patientID() == (*studyIter).patientID()) ) {
	  for (MSeriesVector::iterator seriesIter = seriesVector.begin();
		seriesIter != seriesVector.end();
		seriesIter++) {
	    if ((*studyIter).studyInstanceUID() == (*seriesIter).studyInstanceUID()) {
               for (MSOPInstanceVector::iterator sIter = sopInstanceVector.begin();
                    sIter != sopInstanceVector.end();
                    sIter++) {
                 if ((*seriesIter).seriesInstanceUID() ==
                      (*sIter).seriesInstanceUID() ) {
                   client.selectCallback(*pIter, *studyIter, *seriesIter, *sIter);
                 }
               }
            }
          }
        }
      }
    }
    return 0;
  }

}


int
MDBImageManagerJapanese::queryDICOMStudyRoot(const MPatientStudy& patientStudy,
				     const MSeries& series,
				     const MSOPInstance& sopInstance,
				     const MString& startLevel,
				     const MString& stopLevel,
				     MDBIMClient& client)
{
  if (mDBInterface == 0)
    return 0;

  this->clearVectors();
  MPatientStudyVector patientStudyVector;
  MSeriesVector seriesVector;
  MSOPInstanceVector sopInstanceVector;

  if (startLevel == "STUDY")
    this->fillPatientStudyVector(patientStudy, patientStudyVector);
  else {
    MPatientStudy p;
    patientStudyVector.push_back(p);
  }
  this->fixModalitiesInStudy(patientStudyVector);

  if (stopLevel == "STUDY") {
    for (MPatientStudyVector::iterator pIter = patientStudyVector.begin();
	 pIter != patientStudyVector.end();
	 pIter++) {
      MSeries s2;
      MSOPInstance s3;
      this->mapFromEUCToISO(*pIter);
      client.selectCallback(*pIter, s2, s3);
    }
    return 0;
  }

#if 0
  for (MPatientVector::iterator pIterator = patientVector.begin();
	 pIterator != patientVector.end();
	 pIterator++) {
    this->fillStudyVector(*pIterator, study, studyVector);
  }

  if (stopLevel == "STUDY") {
    for (MPatientVector::iterator pIter = patientVector.begin();
       pIter != patientVector.end();
       pIter++) {
      for (MStudyVector::iterator studyIter = studyVector.begin();
	 studyIter != studyVector.end();
	 studyIter++) {
	if (((*pIter).patientID() == "") ||
	    ((*pIter).patientID() == (*studyIter).patientID()) ) {
	  MSeries x1;
	  MSOPInstance x2;
	  client.selectCallback(*pIter, *studyIter, x1, x2);
	}
      }
    }
    return 0;
  }
#endif

  for (MPatientStudyVector::iterator psIterator = patientStudyVector.begin();
	 psIterator != patientStudyVector.end();
	 psIterator++) {
    this->fillSeriesVector(*psIterator, series, seriesVector);
  }

  if (stopLevel == "SERIES") {
    for (MPatientStudyVector::iterator psIter = patientStudyVector.begin();
       psIter != patientStudyVector.end();
       psIter++) {
      for (MSeriesVector::iterator seriesIter = seriesVector.begin();
	   seriesIter != seriesVector.end();
	   seriesIter++) {
	if ((*psIter).studyInstanceUID() == (*seriesIter).studyInstanceUID()) {
	  MSOPInstance y2;
	  client.selectCallback(*psIter, *seriesIter, y2);
	}
      }
    }
    return 0;
  }



  // We must be stopping at the IMAGE Level

  for (MSeriesVector::iterator seriesIterator = seriesVector.begin();
	 seriesIterator != seriesVector.end();
	 seriesIterator++) {
    this->fillSOPInstanceVector(*seriesIterator, sopInstance,
				sopInstanceVector);
  }

  {
    for (MPatientStudyVector::iterator psIter = patientStudyVector.begin();
       psIter != patientStudyVector.end();
       psIter++) {
      for (MSeriesVector::iterator seriesIter = seriesVector.begin();
	   seriesIter != seriesVector.end();
	   seriesIter++) {
	if (((*psIter).studyInstanceUID() == "") ||
		((*psIter).studyInstanceUID() == (*seriesIter).studyInstanceUID())) {
	  for (MSOPInstanceVector::iterator sIter = sopInstanceVector.begin();
	       sIter != sopInstanceVector.end();
	       sIter++) {
	    if ((*seriesIter).seriesInstanceUID() ==
		 (*sIter).seriesInstanceUID() ) {
	      client.selectCallback(*psIter, *seriesIter, *sIter);
	    }
	  }
	}
      }
    }
    return 0;
  }

}



int
MDBImageManagerJapanese::selectSOPInstance(const MSOPInstance& sopInstance,
				   MSOPInstanceVector& v)
{
  if (mDBInterface == 0)
    return 0;

  this->fillSOPInstanceVector(sopInstance, v);

  return 0;
}

int
MDBImageManagerJapanese::selectSOPInstance(const MSOPInstance& pattern,
				   MSOPInstance& target)
{
  if (mDBInterface == 0)
    return 0;

  int rtn;

  MSOPInstanceVector v;
  this->fillSOPInstanceVector(pattern, v);

  rtn = v.size();
  if (rtn != 0) {
    target = v[0];
  }
  return rtn;
}

int
MDBImageManagerJapanese::selectSOPInstance(MSOPInstanceVector& v)
{
  if (mDBInterface == 0)
    return 0;

  this->fillSOPInstanceVector(v);

  return 0;
}

int
MDBImageManagerJapanese::enterStorageCommitmentItem(const MStorageCommitItem& item)
{
  if (mDBInterface == 0)
    return 0;

  mDBInterface->insert(item);

  return 0;
}

int
MDBImageManagerJapanese::selectStorageCommitItem(const MStorageCommitItem& item,
					 MStorageCommitItemVector& v)
{
  if (mDBInterface == 0)
    return 0;

  this->fillStorageCommitVector(item, v);

  return 0;
}

int
MDBImageManagerJapanese::selectStorageCommitItem(const MStorageCommitItem& pattern,
					 MStorageCommitItem& target)
{
  if (mDBInterface == 0)
    return 0;

  MStorageCommitItemVector v;

  this->fillStorageCommitVector(pattern, v);
  int count = v.size();

  if (count != 0)
    target = v[0];

  return count;
}


int
MDBImageManagerJapanese::storageCommitmentStatus(MStorageCommitItem& item)
{
  return 0;
}

int
MDBImageManagerJapanese::selectDICOMApp(const MString& aeTitle, MDICOMApp& app)
{
  if (mDBInterface == 0)
    return 1;

  MCriteriaVector criteria;

  MCriteria c;
  c.attribute = "aet";
  c.oper = TBL_EQUAL;
  c.value = aeTitle;
  criteria.push_back(c);

  MDICOMApp localApp;
  mDBInterface->select(localApp, criteria, NULL);
  app.import(localApp);
  if (app.host() == "")
    return 1;

  return 0;
}

int
MDBImageManagerJapanese::queryWorkOrder(MDBIMClient& client, int status)
{
  if (mDBInterface == 0)
    return -1;

  if (status == -1)
    return this->queryAllWorkOrders(client);
  else if (status == 0)
    return this->queryNewWorkOrders(client);

  return -1;
}

int
MDBImageManagerJapanese::deleteWorkOrder(const MString& orderNumber)
{
  MCriteria c;
  c.attribute = "ordnum";
  c.oper      = TBL_EQUAL;
  c.value     = orderNumber;

  MCriteriaVector cv;
  cv.push_back(c);

  MWorkOrder order;
  int status = mDBInterface->remove(order, cv);

  return status;
}

int
MDBImageManagerJapanese::updateWorkOrderStatus(const MWorkOrder& workOrder, const MString& status)
{
  MCriteria c;
  c.attribute = "ordnum";
  c.oper      = TBL_EQUAL;
  c.value     = workOrder.orderNumber();

  MCriteriaVector cv;
  cv.push_back(c);

  MUpdateVector   uv;
  MUpdate u;
  u.attribute = "status";
  u.func      = TBL_SET;
  u.value     = status;
  uv.push_back(u);

  MWorkOrder dummy;
  mDBInterface->update(dummy, cv, uv);

  return 0;
}

int
MDBImageManagerJapanese::setWorkOrderComplete(const MWorkOrder& workOrder, const MString& status)
{
  MCriteria c;
  c.attribute = "ordnum";
  c.oper      = TBL_EQUAL;
  c.value     = workOrder.orderNumber();

  MCriteriaVector cv;
  cv.push_back(c);

  MUpdateVector   uv;
  MUpdate u;
  u.attribute = "status";
  u.func      = TBL_SET;
  u.value     = status;
  uv.push_back(u);

  char theDate[32];
  char theTime[64];
  ::UTL_GetDicomDate(theDate);
  ::UTL_GetDicomTime(theTime);

  u.attribute = "datcom";
  u.func      = TBL_SET;
  u.value     = theDate;
  uv.push_back(u);

  u.attribute = "timcom";
  u.func      = TBL_SET;
  u.value     = theTime;
  uv.push_back(u);

  MWorkOrder dummy;
  mDBInterface->update(dummy, cv, uv);

  return 0;
}

// Below are private methods
int
MDBImageManagerJapanese::recordExists(const MPatient& patient)
{
  if (patient.mapEmpty())
    return 0;

  MPatient p;
  MCriteriaVector cv;

  setCriteria(patient, cv);

  return mDBInterface->select(p, cv, NULL);
}

int
MDBImageManagerJapanese::recordExists(const MVisit& visit)
{
  if (visit.mapEmpty())
    return 0;

  MVisit v;
  MCriteriaVector cv;

  setCriteria(visit, cv);

  return mDBInterface->select(v, cv, NULL);
}

int
MDBImageManagerJapanese::recordExists(const MFillerOrder& order)
{
  if (order.mapEmpty())
    return 0;

  MFillerOrder fo;
  MCriteriaVector cv;
  
  setCriteria(order, cv);

  return mDBInterface->select(fo, cv, NULL);
}

int
MDBImageManagerJapanese::recordExists(const MPlacerOrder& order)
{
  if (order.mapEmpty())
    return 0;

  MPlacerOrder po;
  MCriteriaVector cv;
  
  setCriteria(order, cv);

  return mDBInterface->select(po, cv, NULL);
}

int
MDBImageManagerJapanese::recordExists(const MOrder& order)
{
  if (order.mapEmpty())
    return 0;

  MOrder o;
  MCriteriaVector cv;
  
  setCriteria(order, cv);

  return mDBInterface->select(o, cv, NULL);
}


void
MDBImageManagerJapanese::setCriteria(const MPatient& patient, MCriteriaVector& cv)
{
  MCriteria c;
  
  c.attribute = "patid";
  c.oper      = TBL_EQUAL;
  c.value     = patient.patientID();
  cv.push_back(c);

#if 0
  MString issuer(patient.issuerOfPatientID());

  if (issuer.size())
  {
    c.attribute = "issuer";
    c.oper      = TBL_EQUAL;
    c.value     = patient.issuerOfPatientID();
    cv.push_back(c);
  }
#endif
}

void
MDBImageManagerJapanese::setCriteria(const MStudy& study, MCriteriaVector& cv)
{
  MCriteria c;
  
  c.attribute = "stuinsuid";
  c.oper      = TBL_EQUAL;
  c.value     = study.studyInstanceUID();
  cv.push_back(c);
}

void
MDBImageManagerJapanese::setCriteria(const MVisit& visit, MCriteriaVector& cv)
{
  MCriteria c;
  
  c.attribute = "patid";
  c.oper      = TBL_EQUAL;
  c.value     = visit.patientID();
  cv.push_back(c);

#if 0
  MString issuer(visit.issuerOfPatientID());

  if (issuer.size())
  {
    c.attribute = "issuer";
    c.oper      = TBL_EQUAL;
    c.value     = visit.issuerOfPatientID();
    cv.push_back(c);
  }
#endif

  c.attribute = "visnum";
  c.oper      = TBL_EQUAL;
  c.value     = visit.visitNumber();
  cv.push_back(c);
}

void
MDBImageManagerJapanese::setCriteria(const MPlacerOrder& order, MCriteriaVector& cv)
{
  MCriteria c;
  
  MString patientID(order.patientID());

  if (patientID.size())
  {
    c.attribute = "patid";
    c.oper      = TBL_EQUAL;
    c.value     = order.patientID();
    cv.push_back(c);
  }

#if 0
  MString issuer(order.issuerOfPatientID());

  if (issuer.size())
  {
    c.attribute = "issuer";
    c.oper      = TBL_EQUAL;
    c.value     = order.issuerOfPatientID();
    cv.push_back(c);
  }
#endif

  c.attribute = "plaordnum";
  c.oper      = TBL_EQUAL;
  c.value     = order.placerOrderNumber();
  cv.push_back(c);

}

void
MDBImageManagerJapanese::setCriteria(const MFillerOrder& order, MCriteriaVector& cv)
{
  MCriteria c;
  
  MString patientID(order.patientID());

  if (patientID.size())
  {
    c.attribute = "patid";
    c.oper      = TBL_EQUAL;
    c.value     = order.patientID();
    cv.push_back(c);
  }

#if 0
  MString issuer(order.issuerOfPatientID());

  if (issuer.size())
  {
    c.attribute = "issuer";
    c.oper      = TBL_EQUAL;
    c.value     = order.issuerOfPatientID();
    cv.push_back(c);
  }
#endif

  MString poNum(order.placerOrderNumber());

  if (poNum.size())
  {
    c.attribute = "plaordnum";
    c.oper      = TBL_EQUAL;
    c.value     = order.placerOrderNumber();
    cv.push_back(c);
  }

  c.attribute = "filordnum";
  c.oper      = TBL_EQUAL;
  c.value     = order.fillerOrderNumber();
  cv.push_back(c);

//  may include accession number also
/*
  MString accNum(order.accessionNumber());

  if (accNum.size())
  {
    c.attribute = "accnum";
    c.oper      = TBL_EQUAL;
    c.value     = order.accessionNumber();
    cv.push_back(c);
  }  */
}

void
MDBImageManagerJapanese::setCriteria(const MOrder& order, MCriteriaVector& cv)
{
  MCriteria c;
  
  MString poNum(order.placerOrderNumber());

  if (poNum.size())
  {
    c.attribute = "plaordnum";
    c.oper      = TBL_EQUAL;
    c.value     = order.placerOrderNumber();
    cv.push_back(c);
  }

  c.attribute = "filordnum";
  c.oper      = TBL_EQUAL;
  c.value     = order.fillerOrderNumber();
  cv.push_back(c);

  /* may be Universal Service ID also
  c.attribute = "uniserid";
  c.oper      = TBL_EQUAL;
  c.value     = order.universalServiceID();
  cv.push_back(c);
    */
}

void
MDBImageManagerJapanese::setCriteria(const MDomainObject& domainObject,
			     MUpdateVector& uv)
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

int
MDBImageManagerJapanese::addRecord(const MDomainObject& domainObject)
{
  if (mDBInterface == 0)
    return -1;

  int status = mDBInterface->insert(domainObject);
  return status;
}

int
MDBImageManagerJapanese::updateRecord(const MPatient& patient)
{
  if (mDBInterface == 0)
    return -1;

  MCriteriaVector cv;
  MUpdateVector   uv;

  setCriteria(patient, cv);
  setCriteria(patient, uv);

  int status = mDBInterface->update(patient, cv, uv);
  return status;
}

int
MDBImageManagerJapanese::updateRecord(const MStudy& study)
{
  if (mDBInterface == 0)
    return -1;

  MCriteriaVector cv;
  MUpdateVector   uv;

  setCriteria(study, cv);
  setCriteria(study, uv);

  int status = mDBInterface->update(study, cv, uv);
  return status;
}

int
MDBImageManagerJapanese::updateRecord(const MVisit& visit)
{
  if (mDBInterface == 0)
    return -1;

  MCriteriaVector cv;
  MUpdateVector   uv;

  setCriteria(visit, cv);
  setCriteria(visit, uv);

  int status = mDBInterface->update(visit, cv, uv);
  return status;
}

int
MDBImageManagerJapanese::updateRecord(const MFillerOrder& order)
{
  if (mDBInterface == 0)
    return -1;

  MCriteriaVector cv;
  MUpdateVector   uv;

  setCriteria(order, cv);
  setCriteria(order, uv);

  int status = mDBInterface->update(order, cv, uv);
  if (status != 0) {
    return status;
  }

  for (int inx = 0; inx < order.numOrders(); inx++) {
    status = updateRecord(order.order(inx));
    if (status != 0) {
      return status;
    }
  }
  return 0;
}

int
MDBImageManagerJapanese::updateRecord(const MPlacerOrder& order)
{
  if (mDBInterface == 0)
    return -1;

  MCriteriaVector cv;
  MUpdateVector   uv;
  MPlacerOrder    localOrder(order);

  setCriteria(localOrder, cv);
  setCriteria(localOrder, uv);

  int status = mDBInterface->update(localOrder, cv, uv);
  if (status != 0) {
    return status;
  }

  for (int inx = 0; inx < localOrder.numOrders(); inx++) {
    status = updateRecord(localOrder.order(inx));
    if (status != 0) {
      return status;
    }
  }
}

int
MDBImageManagerJapanese::updateRecord(const MOrder& order)
{
  if (mDBInterface == 0)
    return -1;

  MCriteriaVector cv;
  MUpdateVector   uv;

  setCriteria(order, cv);
  setCriteria(order, uv);

  int status = mDBInterface->update(order, cv, uv);
  return status;
}



int
MDBImageManagerJapanese::enter(const MPatient& patient)
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

#if 0
  c.attribute = "issuer";
  c.oper      = TBL_EQUAL;
  c.value     = patient.issuerOfPatientID();
  cv.push_back(c);
#endif

  MPatient p;
  MPatient patientEUC(patient);
  this->mapISOToEUCJP(patientEUC);
  if (mDBInterface->select(p, cv, NULL)) {  // Patient is already present
    ;
  }
  else // add a new patient
    mDBInterface->insert(patientEUC);
  
  return 0;
}

int
MDBImageManagerJapanese::enter(const MStudy& study)
{
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_VERBOSE, "",
                  "MDBImageManagerJapanese::enterStudy", __LINE__,
		  "Enter method");

       // first do sanity check
  if (!mDBInterface) {
    logClient.logTimeStamp(MLogClient::MLOG_ERROR,
                  "MDBImageManagerJapanese::enterStudy no DB Interface; cannot enter study");
    return 0;
  }

  if (study.mapEmpty()) {
    logClient.logTimeStamp(MLogClient::MLOG_ERROR,
                  "MDBImageManagerJapanese::enterStudy study object is empty; cannot enter study");
    return 0;
  }

  // check if study already exists
  MCriteriaVector cv;
  MCriteria c;
  
  c.attribute = "stuinsuid";
  c.oper      = TBL_EQUAL;
  c.value     = study.studyInstanceUID();
  cv.push_back(c);

  MStudy s;
  if (mDBInterface->select(s, cv, NULL)) {  // Study is already present
    logClient.logTimeStamp(MLogClient::MLOG_VERBOSE,
	MString("MDBImageManagerJapanese::enterStudy study object already exists: ")
		+ study.studyInstanceUID());
  } else { // add a new study
    // The values of numberStudyRelatedSeries and numberStudyRelatedInstances
    // may not be valid. Insure that they are.
    MStudy tmpStudy(study);
    MString n("0");
    tmpStudy.numberStudyRelatedSeries(n);
    tmpStudy.numberStudyRelatedInstances(n);
    mDBInterface->insert(tmpStudy);
  }
  return 0;
}

int
MDBImageManagerJapanese::enter(const MSeries& series, const MStudy& study)
{
       // first do sanity check
  if (!mDBInterface)
    return 0;

  if (series.mapEmpty())
    return 0;

  // check if series already exists
  MCriteriaVector cv;
  MCriteria c;
  
  c.attribute = "serinsuid";
  c.oper      = TBL_EQUAL;
  c.value     = series.seriesInstanceUID();
  cv.push_back(c);

  MSeries s;
  if (mDBInterface->select(s, cv, NULL)) {  // Series is already present
    ;
  } else { // add a new series
    // The value of numberSeriesRelatedInstances may not be valid. Insure
    // that it is.
    MSeries tmpSeries(series);
    MString n("0");
    tmpSeries.numberSeriesRelatedInstances(n);
    mDBInterface->insert(tmpSeries);
    this->incrementSeriesCount(study);
    MString modality = series.modality();
    this->updateModalitiesInStudy(study, modality);
  }
  return 0;
}

int
MDBImageManagerJapanese::enter(const MSOPInstance& sopInstance,
		       const MStudy& study,
		       const MSeries& series)
{
       // first do sanity check
  if (!mDBInterface)
    return 0;

  if (sopInstance.mapEmpty())
    return 0;

  // check if sopInstance already exists
  MCriteriaVector cv;
  MCriteria c;
  
  c.attribute = "insuid";
  c.oper      = TBL_EQUAL;
  c.value     = sopInstance.instanceUID();
  cv.push_back(c);

  MSOPInstance s;
  if (mDBInterface->select(s, cv, NULL)) {  // SOP Instance is already present
    ;
  }   else { // add a new SOP Instance
    mDBInterface->insert(sopInstance);
    this->incrementSOPInstanceCount(study);
    this->incrementSOPInstanceCount(series);
  }
  return 0;
}


void
MDBImageManagerJapanese::incrementSeriesCount(const MStudy& study) {
  MCriteria c;
  c.attribute = "stuinsuid";
  c.oper      = TBL_EQUAL;
  c.value     = study.studyInstanceUID();

  MCriteriaVector cv;
  cv.push_back(c);

  MUpdateVector updateVector;
  MUpdate u;

  u.attribute = "numser";
  u.func      = TBL_INCREMENT;
  u.value     = "";
  updateVector.push_back(u);

  mDBInterface->update(study, cv, updateVector);
}

void
MDBImageManagerJapanese::incrementSOPInstanceCount(const MStudy& study) {
  MCriteria c;
  c.attribute = "stuinsuid";
  c.oper      = TBL_EQUAL;
  c.value     = study.studyInstanceUID();

  MCriteriaVector cv;
  cv.push_back(c);

  MUpdateVector updateVector;
  MUpdate u;

  u.attribute = "numins";
  u.func      = TBL_INCREMENT;
  u.value     = "";
  updateVector.push_back(u);

  mDBInterface->update(study, cv, updateVector);
}

void
MDBImageManagerJapanese::incrementSOPInstanceCount(const MSeries& series) {
  MCriteria c;
  c.attribute = "serinsuid";
  c.oper      = TBL_EQUAL;
  c.value     = series.seriesInstanceUID();

  MCriteriaVector cv;
  cv.push_back(c);

  MUpdateVector updateVector;
  MUpdate u;

  u.attribute = "numins";
  u.func      = TBL_INCREMENT;
  u.value     = "";
  updateVector.push_back(u);

  mDBInterface->update(series, cv, updateVector);
}

void
MDBImageManagerJapanese::updateModalitiesInStudy(const MStudy& study,
					 const MString& modality)
{
  MStudyVector v;

  MString uid = study.studyInstanceUID();
  MStudy tempStudy;
  tempStudy.studyInstanceUID(uid);
  MStudyVector::iterator studyStart = mStudyVector.begin();
  MStudyVector::iterator studyEnd = mStudyVector.end();
  mStudyVector.erase(studyStart, studyEnd);
  this->fillStudyVector(tempStudy, v);
  if (v.size() != 1) {
    cerr << "Error when trying to select one MStudy object " << endl;
    cerr << "Study UID = " << uid << endl;
    cerr << "Count = " << v.size() << endl;
    return;
  }

  tempStudy = v[0];
  MString x = tempStudy.modalitiesInStudy();
  bool done = false;
  bool found = false;
  int index = 0;
  for (index = 0; !done; index++) {
    if (!x.tokenExists('+', index))
      break;
    MString s = x.getToken('+', index);
    if (s == modality) {
      found = true;
      done = true;
    }
  }
  if (!found) {
    if (x == "") {
      x = modality;
    } else {
      x = x + "+" + modality;
    }

    tempStudy.modalitiesInStudy(x);
    updateRecord(tempStudy);
  }
}

static void
patientCallback(MDomainObject& domainObj, void* ctx)
{
  MDBImageManagerJapanese* mgr = (MDBImageManagerJapanese*)ctx;

  MPatient p;
  p.import(domainObj);

  mgr->addToVector(p);
}

static void
studyCallback(MDomainObject& domainObj, void* ctx)
{
  MDBImageManagerJapanese* mgr = (MDBImageManagerJapanese*)ctx;

  MStudy s;
  s.import(domainObj);

  mgr->addToVector(s);
}

static void
seriesCallback(MDomainObject& domainObj, void* ctx)
{
  MDBImageManagerJapanese* mgr = (MDBImageManagerJapanese*)ctx;

  MSeries s;
  s.import(domainObj);

  mgr->addToVector(s);
}

static void
patientStudyCallback(MDomainObject& domainObj, void* ctx)
{
  MPatientStudyVector* v = (MPatientStudyVector*)ctx;

  MPatientStudy p;
  p.import(domainObj);

  (*v).push_back(p);
}

static void
workOrderCallback(MDomainObject& domainObj, void* ctx)
{
  MWorkOrderVector* v = (MWorkOrderVector*)ctx;

  MWorkOrder p;
  p.import(domainObj);

  (*v).push_back(p);
}

int
MDBImageManagerJapanese::addToVector(const MPatient& patient)
{
  mPatientVector.push_back(patient);

  return 0;
}

int
MDBImageManagerJapanese::addToVector(const MStudy& study)
{
  mStudyVector.push_back(study);

  return 0;
}

int
MDBImageManagerJapanese::addToVector(const MSeries& series)
{
  mSeriesVector.push_back(series);

  return 0;
}

int
MDBImageManagerJapanese::fillPatientVector(const MPatient& patient, MPatientVector& v)
{
  MLogClient logClient;
  char* searchCriteria[] = {
    "patid",
    "nam",
    "datbir",
    "sex"
  };

  int i;
  MCriteriaVector criteria;
  int status = 0;

  const MDomainMap& m = patient.map();
  for(i = 0; i < (int)DIM_OF(searchCriteria); i++) {
    MDomainMap::const_iterator iDomain = m.find(searchCriteria[i]);
    MString s = (*iDomain).second;

    //MString s = m[searchCriteria[i]];
    if (s != "") {
      char textISO2022JP[1024];
      char textEUCJP[1024];
      int outputLength = 0;
      s.safeExport(textISO2022JP, sizeof(textISO2022JP));
      MCharsetEncoder e;
      int status = 0;
      logClient.logTimeStamp(MLogClient::MLOG_VERBOSE,
	MString("Query Text   in ISO2022JP format: ") + textISO2022JP);

      status = e.xlate(textEUCJP, outputLength, (int)sizeof(textEUCJP),
	textISO2022JP, ::strlen(textISO2022JP),
	"ISO2022JP", "EUC_JP");
      if (status != 0) {
	logClient.logTimeStamp(MLogClient::MLOG_VERBOSE,
	"MDBImageManagerJapanese::fillPatientVector exit method, unable to translate from ISO2022JP to EUCJP");
	return 1;
      }

      textEUCJP[outputLength] = '\0';
      e.substituteCharacter(textEUCJP, strlen(textEUCJP),
	'*', '%', "EUCJP");
      logClient.logTimeStamp(MLogClient::MLOG_VERBOSE,
        MString("Query text   in EUC_JP format: ") + textEUCJP);
    }

    if (s != "") {
      TBL_OPERATOR oper = TBL_LIKE;
//      if (s.find("*") != string::npos) {
//	s.substitute('*', '%');
//	oper = TBL_LIKE;
//      }
      MCriteria c;
      c.attribute = searchCriteria[i];
      c.oper = oper;
      c.value = s;
      criteria.push_back(c);
    }
  }
  MPatient p;
  mDBInterface->select(p, criteria, patientCallback, this);
  MPatientVector::iterator patientIterator = mPatientVector.begin();
  for (; patientIterator != mPatientVector.end(); patientIterator++)
    v.push_back(*patientIterator);

  return 0;
}

int
MDBImageManagerJapanese::fillStudyVector(const MPatient& patient,
				 const MStudy& study, MStudyVector& v)
{
  char* searchCriteria[] = {
    "stuinsuid",
    // "studat",	// Removed so we can test separately for range
    "stutim",
    "accnum",
    "stuid",
    "modinstu"
  };

  int i;
  MCriteriaVector criteria;

  MString patientID = patient.patientID();
  if (patientID != "") {
    MCriteria p;
    p.attribute = "patid";
    p.oper = TBL_EQUAL;
    p.value = patientID;
    criteria.push_back(p);
  }
  MString studyDate = study.studyDate();
  if (studyDate != "") {
    if (studyDate.containsCharacter('-')) {
      MString lower = studyDate.getToken('-', 0);
      MString upper = studyDate.getToken('-', 1);
      if (lower != "") {
	MCriteria p;
	p.attribute = "studat";
	p.oper = TBL_GREATER_EQUAL;
	p.value = lower;
	criteria.push_back(p);
      }
      if (upper != "") {
	MCriteria p;
	p.attribute = "studat";
	p.oper = TBL_LESS_EQUAL;
	p.value = upper;
	criteria.push_back(p);
      }
    } else {
      MCriteria p;
      p.attribute = "studat";
      p.oper = TBL_EQUAL;
      p.value = studyDate;
      criteria.push_back(p);
    }
  }

  const MDomainMap& m = study.map();
  for(i = 0; i < (int)DIM_OF(searchCriteria); i++) {
    MDomainMap::const_iterator iDomain = m.find(searchCriteria[i]);
    MString s = (*iDomain).second;

    // MString s = m[searchCriteria[i]];
    if (s != "") {
      TBL_OPERATOR oper = TBL_EQUAL;
      if (s.find("*") != string::npos) {
	s.substitute('*', '%');
	oper = TBL_LIKE;
      }
      MCriteria c;
      c.attribute = searchCriteria[i];
      c.oper = oper;
      c.value = s;
      criteria.push_back(c);
    }
  }
  MStudy s;
  mDBInterface->select(s, criteria, studyCallback, this);
  MStudyVector::iterator studyIterator = mStudyVector.begin();
  for (; studyIterator != mStudyVector.end(); studyIterator++)
    v.push_back(*studyIterator);


  return 0;
}

int
MDBImageManagerJapanese::fillStudyVector(const MStudy& study, MStudyVector& v)
{
  char* searchCriteria[] = {
    "stuinsuid",
    // "studat",		// Comment out as we treat this for date range
    "stutim",
    "accnum",
    "stuid"
  };

  MCriteriaVector criteria;

  MString studyDate = study.studyDate();
  if (studyDate != "") {
    if (studyDate.containsCharacter('-')) {
      MString lower = studyDate.getToken('-', 0);
      MString upper = studyDate.getToken('-', 1);
      if (lower != "") {
	MCriteria p;
	p.attribute = "studat";
	p.oper = TBL_GREATER_EQUAL;
	p.value = lower;
	criteria.push_back(p);
      }
      if (upper != "") {
	MCriteria p;
	p.attribute = "studat";
	p.oper = TBL_LESS_EQUAL;
	p.value = upper;
	criteria.push_back(p);
      }
    } else {
      MCriteria p;
      p.attribute = "studat";
      p.oper = TBL_EQUAL;
      p.value = studyDate;
      criteria.push_back(p);
    }
  }


  int i;

  const MDomainMap& m = study.map();
  for(i = 0; i < (int)DIM_OF(searchCriteria); i++) {
    MDomainMap::const_iterator iDomain = m.find(searchCriteria[i]);
    if (iDomain == m.end())
      continue;

    MString s = (*iDomain).second;

    if (s != "") {
      TBL_OPERATOR oper = TBL_EQUAL;
      if (s.find("*") != string::npos) {
	s.substitute('*', '%');
	oper = TBL_LIKE;
      }
      MCriteria c;
      c.attribute = searchCriteria[i];
      c.oper = oper;
      c.value = s;
      criteria.push_back(c);
    }
  }
  MStudy s;
  mDBInterface->select(s, criteria, studyCallback, this);
  MStudyVector::iterator studyIterator = mStudyVector.begin();
  for (; studyIterator != mStudyVector.end(); studyIterator++)
    v.push_back(*studyIterator);

  return 0;
}

int
MDBImageManagerJapanese::fillSeriesVector(const MStudy& study,
				 const MSeries& series, MSeriesVector& v)
{
  char* searchCriteria[] = {
    "serinsuid",
    "mod",
    "sernum"
  };

  int i;
  MCriteriaVector criteria;

  MString studyInstanceUID = study.studyInstanceUID();
  if (studyInstanceUID != "") {
    MCriteria p;
    p.attribute = "stuinsuid";
    p.oper = TBL_EQUAL;
    p.value = studyInstanceUID;
    criteria.push_back(p);
  }

  const MDomainMap& m = series.map();
  for(i = 0; i < (int)DIM_OF(searchCriteria); i++) {
    MDomainMap::const_iterator iDomain = m.find(searchCriteria[i]);
    MString s = (*iDomain).second;

    //MString s = m[searchCriteria[i]];
    if (s != "") {
      TBL_OPERATOR oper = TBL_EQUAL;
      if (s.find("*") != string::npos) {
	s.substitute('*', '%');
	oper = TBL_LIKE;
      }
      MCriteria c;
      c.attribute = searchCriteria[i];
      c.oper = oper;
      c.value = s;
      criteria.push_back(c);
    }
  }
  MSeries s;
  mDBInterface->select(s, criteria, seriesCallback, this);
  MSeriesVector::iterator seriesIterator = mSeriesVector.begin();
  for (; seriesIterator != mSeriesVector.end(); seriesIterator++)
    v.push_back(*seriesIterator);

  return 0;
}

int
MDBImageManagerJapanese::fillPatientStudyVector(const MPatientStudy& patientStudy,
					MPatientStudyVector& v)
{
  MLogClient logClient;
  char* searchCriteria[] = {
    "patid",
    "nam",
    "datbir",
    "sex",
    "stuinsuid",
    // "studat",	// Comment this out; treat for date range
    "stutim",
    "accnum",
    "stuid",
    "modinstu"
  };

  int i;
  MCriteriaVector criteria;

  MString studyDate = patientStudy.studyDate();
  if (studyDate != "") {
    if (studyDate.containsCharacter('-')) {
      MString lower = studyDate.getToken('-', 0);
      MString upper = studyDate.getToken('-', 1);
      if (lower != "") {
	MCriteria p;
	p.attribute = "studat";
	p.oper = TBL_GREATER_EQUAL;
	p.value = lower;
	criteria.push_back(p);
      }
      if (upper != "") {
	MCriteria p;
	p.attribute = "studat";
	p.oper = TBL_LESS_EQUAL;
	p.value = upper;
	criteria.push_back(p);
      }
    } else {
      MCriteria p;
      p.attribute = "studat";
      p.oper = TBL_EQUAL;
      p.value = studyDate;
      criteria.push_back(p);
    }
  }


  const MDomainMap& m = patientStudy.map();
  for(i = 0; i < (int)DIM_OF(searchCriteria); i++) {
    MDomainMap::const_iterator iDomain = m.find(searchCriteria[i]);
    if (iDomain == m.end())   // added for testing -- does this need to be here?
      continue;
    MString s = (*iDomain).second;

    // MString s = m[searchCriteria[i]];

    if (s != "") {
      if ((*iDomain).first == "modinstu") {
	s = "*" + s + "*";
      }
      char textISO2022JP[1024];
      char textEUCJP[1024];
      int outputLength = 0;
      s.safeExport(textISO2022JP, sizeof(textISO2022JP));
      MCharsetEncoder e;
      int status = 0;
      logClient.logTimeStamp(MLogClient::MLOG_VERBOSE,
	MString("Query Text   in ISO2022JP format: ") + textISO2022JP);

      status = e.xlate(textEUCJP, outputLength, (int)sizeof(textEUCJP),
	textISO2022JP, ::strlen(textISO2022JP),
	"ISO2022JP", "EUC_JP");
      if (status != 0) {
	logClient.logTimeStamp(MLogClient::MLOG_VERBOSE,
	"MDBImageManagerJapanese::fillPatientStudyVector exit method, unable to translate from ISO2022JP to EUCJP");
	return 1;
      }

      textEUCJP[outputLength] = '\0';
      e.substituteCharacter(textEUCJP, strlen(textEUCJP),
	'*', '%', "EUCJP");
      logClient.logTimeStamp(MLogClient::MLOG_VERBOSE,
        MString("Query text   in EUC_JP format: ") + textEUCJP);

      TBL_OPERATOR oper = TBL_LIKE;
//      if (s.find("*") != string::npos) {
//	s.substitute('*', '%');
//	oper = TBL_LIKE;
//      }
      MCriteria c;
      c.attribute = searchCriteria[i];
      c.oper = oper;
      c.value = textEUCJP;
      criteria.push_back(c);
    }
  }
  MPatientStudy p;
  mDBInterface->select(p, criteria, patientStudyCallback, &v);
#if 0
  MPatientVector::iterator patientIterator = mPatientVector.begin();
  for (; patientIterator != mPatientVector.end(); patientIterator++)
    v.push_back(*patientIterator);
#endif

  return 0;
}

int
MDBImageManagerJapanese::fillSeriesVector(const MPatientStudy& study,
				     const MSeries& series, MSeriesVector& v)
{
  char* searchCriteria[] = {
    "serinsuid",
    "mod",
    "sernum"
  };

  int i;
  MCriteriaVector criteria;

  MString studyInstanceUID = study.studyInstanceUID();
  if (studyInstanceUID != "") {
    MCriteria p;
    p.attribute = "stuinsuid";
    p.oper = TBL_EQUAL;
    p.value = studyInstanceUID;
    criteria.push_back(p);
  }

  const MDomainMap& m = series.map();
  for(i = 0; i < (int)DIM_OF(searchCriteria); i++) {
    MDomainMap::const_iterator iDomain = m.find(searchCriteria[i]);
    MString s = (*iDomain).second;

    // MString s = m[searchCriteria[i]];
    if (s != "") {
      TBL_OPERATOR oper = TBL_EQUAL;
      if (s.find("*") != string::npos) {
	s.substitute('*', '%');
	oper = TBL_LIKE;
      }
      MCriteria c;
      c.attribute = searchCriteria[i];
      c.oper = oper;
      c.value = s;
      criteria.push_back(c);
    }
  }
  MSeries s;
  mDBInterface->select(s, criteria, seriesCallback, this);
  MSeriesVector::iterator seriesIterator = mSeriesVector.begin();
  for (; seriesIterator != mSeriesVector.end(); seriesIterator++)
    v.push_back(*seriesIterator);

  return 0;
}

static void
sopInstanceCallback(MDomainObject& domainObj, void* ctx)
{
  MSOPInstanceVector* v = (MSOPInstanceVector*)ctx;

  MSOPInstance sopInstance;

  sopInstance.import(domainObj);

  (*v).push_back(sopInstance);
}

int
MDBImageManagerJapanese::fillSOPInstanceVector(const MSOPInstance& sopInstance,
				       MSOPInstanceVector& v)
{
  MCriteriaVector criteria;

  MCriteria c;
  c.attribute = "insuid";
  c.oper = TBL_EQUAL;
  c.value = sopInstance.instanceUID();

  criteria.push_back(c);

  MSOPInstance pattern(sopInstance);

  mDBInterface->select(pattern, criteria, sopInstanceCallback, &v);
  return 0;
}

int
MDBImageManagerJapanese::fillSOPInstanceVector(const MSeries& series,
				       const MSOPInstance& sopInstance,
				       MSOPInstanceVector& v)
{
  MCriteriaVector criteria;
  MCriteria c;
  c.attribute = "serinsuid";
  c.oper      = TBL_EQUAL;
  c.value     = series.seriesInstanceUID();
  criteria.push_back(c);

  MSOPInstance pattern(sopInstance);
  pattern.seriesInstanceUID(series.seriesInstanceUID());

  char* searchCriteria[] = {
    "insuid",
    "clauid",
    "imanum"
  };

  const MDomainMap& m = sopInstance.map();
  int i;
  for(i = 0; i < (int)DIM_OF(searchCriteria); i++) {
    MDomainMap::const_iterator iDomain = m.find(searchCriteria[i]);
    MString s = (*iDomain).second;

    if (s != "") {
      TBL_OPERATOR oper = TBL_EQUAL;
      if (s.find("*") != string::npos) {
	s.substitute('*', '%');
	oper = TBL_LIKE;
      }
      MCriteria c;
      c.attribute = searchCriteria[i];
      c.oper = oper;
      c.value = s;
      criteria.push_back(c);
    }
  }

  mDBInterface->select(pattern, criteria, sopInstanceCallback, &v);
  return 0;
}

int
MDBImageManagerJapanese::fillSOPInstanceVector(MSOPInstanceVector& v)
{
  MCriteriaVector criteria;

  MSOPInstance pattern;

  mDBInterface->select(pattern, criteria, sopInstanceCallback, &v);
  return 0;
}


void
MDBImageManagerJapanese::clearVectors(void)
{
  MPatientVector::iterator pStart = mPatientVector.begin();
  MPatientVector::iterator pEnd = mPatientVector.end();
  mPatientVector.erase(pStart, pEnd);

  MStudyVector::iterator studyStart = mStudyVector.begin();
  MStudyVector::iterator studyEnd = mStudyVector.end();
  mStudyVector.erase(studyStart, studyEnd);

  MSeriesVector::iterator seriesStart = mSeriesVector.begin();
  MSeriesVector::iterator seriesEnd = mSeriesVector.end();
  mSeriesVector.erase(seriesStart, seriesEnd);
}

static void
storageCommitCallback(MDomainObject& domainObj, void* ctx)
{
  MStorageCommitItemVector* v = (MStorageCommitItemVector*)ctx;

  MStorageCommitItem sci;

  sci.import(domainObj);

  (*v).push_back(sci);
}

int
MDBImageManagerJapanese::fillStorageCommitVector(const MStorageCommitItem& item,
					 MStorageCommitItemVector& v)
{
  MStorageCommitItem sci;

  MCriteriaVector criteria;
  const MDomainMap& m = item.map();
  for (MDomainMap::const_iterator i = m.begin(); i != m.end(); i++) {
    if ((*i).second != "") {
      MCriteria c;
      c.attribute = (*i).first;
      c.oper      = TBL_EQUAL;
      c.value     = (*i).second;
      criteria.push_back(c);
    }
  }

  mDBInterface->select(sci, criteria, storageCommitCallback, &v);
  return 0;
}

int
MDBImageManagerJapanese::queryAllWorkOrders(MDBIMClient& client)
{
  MWorkOrderVector workOrderVector;

  MWorkOrder blankOrder;
  this->fillWorkOrderVector(blankOrder, workOrderVector);

  for (MWorkOrderVector::iterator pIter = workOrderVector.begin();
	 pIter != workOrderVector.end();
	 pIter++) {
      client.selectCallback(*pIter);
  }
  return 0;
}

int
MDBImageManagerJapanese::queryNewWorkOrders(MDBIMClient& client)
{
  MWorkOrderVector workOrderVector;

  MWorkOrder blankOrder;
  blankOrder.status("0");

  this->fillWorkOrderVector(blankOrder, workOrderVector);

  for (MWorkOrderVector::iterator pIter = workOrderVector.begin();
	 pIter != workOrderVector.end();
	 pIter++) {
      client.selectCallback(*pIter);
  }
  return 0;
}

int
MDBImageManagerJapanese::fillWorkOrderVector(const MWorkOrder& item,
					 MWorkOrderVector& v)
{
  MWorkOrder order;

  MCriteriaVector criteria;
  const MDomainMap& m = item.map();
  for (MDomainMap::const_iterator i = m.begin(); i != m.end(); i++) {
    if ((*i).second != "") {
      MCriteria c;
      c.attribute = (*i).first;
      c.oper      = TBL_EQUAL;
      c.value     = (*i).second;
      criteria.push_back(c);
    }
  }

  mDBInterface->select(order, criteria, workOrderCallback, &v);
  return 0;
}

void
MDBImageManagerJapanese::fixModalitiesInStudy(MPatientStudyVector& v)
{
  for (MPatientStudyVector::iterator i = v.begin(); i != v.end(); i++) {
    MString x = (*i).modalitiesInStudy();
    x.substitute('+', '\\');
    (*i).modalitiesInStudy(x);
  }
}

void
MDBImageManagerJapanese::fixModalitiesInStudy(MStudyVector& v)
{
  for (MStudyVector::iterator i = v.begin(); i != v.end(); i++) {
    MString x = (*i).modalitiesInStudy();
    x.substitute('+', '\\');
    (*i).modalitiesInStudy(x);
  }
}

int
MDBImageManagerJapanese::mapFromEUCToISO(MPatientStudy& patientStudy)
{
  MLogClient logClient;
  logClient.logTimeStamp(MLogClient::MLOG_VERBOSE,
                  "MDBImageManagerJapanese::mapFromEUCToISO enter method");


  char pNameISO2022JP[1024];
  char pNameEUCJP[1024];
  int outputLength = 0;
  patientStudy.patientName().safeExport(pNameEUCJP, sizeof(pNameEUCJP));
  MCharsetEncoder e;
  int status = 0;
  logClient.logTimeStamp(MLogClient::MLOG_VERBOSE,
        MString("Patient Name in EUCJPformat: ") + pNameEUCJP);

  status = e.xlate(pNameISO2022JP, outputLength, (int)sizeof(pNameISO2022JP),
        pNameEUCJP, ::strlen(pNameEUCJP),
        "EUC_JP", "ISO2022JP");
  if (status != 0) {
    logClient.logTimeStamp(MLogClient::MLOG_VERBOSE,
        "MDBImageManagerJapanese::mapFromEUCToISO exit method, unable to translate from EUCJP to ISO2022JP");
    return 1;
  }

  pNameISO2022JP[outputLength] = '\0';
  logClient.logTimeStamp(MLogClient::MLOG_VERBOSE,
        MString("Patient Name in ISO2022JP format: ") + pNameISO2022JP);

  patientStudy.patientName(pNameISO2022JP);
  return 0;
}

int
MDBImageManagerJapanese::mapISOToEUCJP(MStudy& study)
{
  char valueISO2022JP[1024];
  char valueEUCJP[1024];
  int outputLength = 0;
  MLogClient logClient;

  char* updateFieldsStudy[] = { "refphynam" };
  int idx = 0;
  MCharsetEncoder e;
  MStudy localStudy(study);
  for (idx = 0; idx < 1; idx++) {
    MString s = localStudy.value(updateFieldsStudy[idx]);
    s.safeExport(valueISO2022JP, sizeof(valueISO2022JP));
    int status = 0;
    logClient.logTimeStamp(MLogClient::MLOG_VERBOSE,
	MString(updateFieldsStudy[idx]) + MString(" in ISO2022JP format: ") + valueISO2022JP);

    status = e.xlate(valueEUCJP, outputLength, (int)sizeof(valueEUCJP),
	valueISO2022JP, ::strlen(valueISO2022JP),
	"ISO2022JP", "EUC_JP");
    if (status != 0) {
      logClient.logTimeStamp(MLogClient::MLOG_ERROR,
	"MDBImageManagerJapanese::mapISOtoEUCJP exit method, unable to translate from ISO2022JP to EUCJP");
      return 1;
    }

    valueEUCJP[outputLength] = '\0';
    logClient.logTimeStamp(MLogClient::MLOG_VERBOSE,
	MString(updateFieldsStudy[idx]) + MString(" in EUCJP format:     ") + valueEUCJP);

    localStudy.insert(updateFieldsStudy[idx], valueEUCJP);
  }
  study.import(localStudy);
}

int
MDBImageManagerJapanese::mapISOToEUCJP(MPatient& patient)
{
  char valueISO2022JP[1024];
  char valueEUCJP[1024];
  int outputLength = 0;
  MLogClient logClient;

  char* updateFieldsPatient[] = { "nam", "addr" };
  int idx = 0;
  MCharsetEncoder e;
  MPatient localPatient(patient);
  for (idx = 0; idx < 2; idx++) {
    MString s = localPatient.value(updateFieldsPatient[idx]);
    s.safeExport(valueISO2022JP, sizeof(valueISO2022JP));
    int status = 0;
    logClient.logTimeStamp(MLogClient::MLOG_VERBOSE,
	MString(updateFieldsPatient[idx]) + MString(" in ISO2022JP format: ") + valueISO2022JP);

    status = e.xlate(valueEUCJP, outputLength, (int)sizeof(valueEUCJP),
	valueISO2022JP, ::strlen(valueISO2022JP),
	"ISO2022JP", "EUC_JP");
    if (status != 0) {
      logClient.logTimeStamp(MLogClient::MLOG_ERROR,
	"MDBImageManagerJapanese::mapISOtoEUCJP exit method, unable to translate from ISO2022JP to EUCJP");
      return 1;
    }

    valueEUCJP[outputLength] = '\0';
    logClient.logTimeStamp(MLogClient::MLOG_VERBOSE,
	MString(updateFieldsPatient[idx]) + MString(" in EUCJP format:     ") + valueEUCJP);

    localPatient.insert(updateFieldsPatient[idx], valueEUCJP);
  }
  patient.import(localPatient);
}
