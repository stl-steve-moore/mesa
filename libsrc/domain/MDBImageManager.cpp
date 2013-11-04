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
#include "MDBImageManager.hpp"

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

#include "MLogClient.hpp"

//#include "MDBInterface.hpp"

MDBImageManager::MDBImageManager() :
  mDBInterface(0),
  mDBName("")
{
}

MDBImageManager::MDBImageManager(const MDBImageManager& cpy)
{
  if (mDBInterface)
    delete mDBInterface;
}

MDBImageManager::~MDBImageManager()
{
}

void
MDBImageManager::printOn(ostream& s) const
{
  s << "MDBImageManager";
}

void
MDBImageManager::streamIn(istream& s)
{
  //s >> this->member;
}

// Now, the non-boiler plate methods will follow.

MDBImageManager::MDBImageManager(const string& databaseName) :
  mDBName(databaseName),
  mDBInterface(0)
{
  if (databaseName != "")
    mDBInterface = new MDBInterface(databaseName);
}

int
MDBImageManager::initialize()
{
//  if (mDBInterface == 0)
//    return -1;

  return 0;
}

int
MDBImageManager::initialize(const MString& databaseName)
{
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_VERBOSE,
		"<no peer>", "MDBImageManager::initialize",
		__LINE__,
		"Enter method, database Name: ", databaseName);

    if (mDBInterface != 0) {
    if (databaseName == mDBName)
      return 0;

    logClient.logTimeStamp(MLogClient::MLOG_ERROR,
	MString("MDBImageManager::initialize existing DB name differs from new initialization request, exiting with error (") +
        mDBName + ":" + databaseName + ")" );

    return -1;
  }

  mDBName = databaseName;
  if (databaseName != "")
    mDBInterface = new MDBInterface();

  if (mDBInterface->initialize(mDBName) != 0) {
    logClient.log(MLogClient::MLOG_ERROR,
		"<no peer>", "MDBImageManager::initialize",
		__LINE__,
		"Unable to initialize database: ", databaseName);
    return 1;
  }

  logClient.log(MLogClient::MLOG_VERBOSE,
		"<no peer>", "MDBImageManager::initialize",
		__LINE__,
		"Exit method");
  return 0;
}

int
MDBImageManager::admitRegisterPatient(const MPatient& patient,
				     const MVisit& visit)
{
  // first do sanity check
  if (!mDBInterface)
    return 0;

  if (patient.mapEmpty())
    return -1;

  if (recordExists(patient))
    updateRecord(patient);
  else
    addRecord(patient);

  if (visit.mapEmpty())
    return -1;

  if (recordExists(visit))
    updateRecord(visit);
  else
    addRecord(visit);

  return 0;
}

int
MDBImageManager::preRegisterPatient(const MPatient& patient,
				     const MVisit& visit)
{
  return this->admitRegisterPatient(patient, visit);
}
int
MDBImageManager::updateADTInfo(const MPatient& patient)
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
MDBImageManager::updateADTInfo(const MPatient& patient, const MVisit& visit)
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
MDBImageManager::transferPatient(const MVisit& visit)
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
MDBImageManager::mergePatient(const MPatient& patient)
{
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_VERBOSE,
		"<no peer>", "MDBImageManager::mergePatient",
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
MDBImageManager::enterOrder(const MPatient& patient, const MPlacerOrder& order)
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
  
  // finished with MPatient
  return 0;
}

int
MDBImageManager::enterSOPInstance(const MPatient& patient,
				  const MStudy& study,
				  const MSeries& series,
				  const MSOPInstance& sopInstance)
{
  if (mDBInterface == 0)
    return 0;

  this->enter(patient);

  this->enter(study);

  this->enter(series, study);

  this->enter(sopInstance, study, series);
  
  return 0;
}

int
MDBImageManager::queryDICOMPatientRoot(const MPatient& patient,
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
MDBImageManager::queryDICOMStudyRoot(const MPatientStudy& patientStudy,
				     const MSeries& series,
				     const MSOPInstance& sopInstance,
				     const MString& startLevel,
				     const MString& stopLevel,
				     MDBIMClient& client)
{
  MLogClient logClient;
  char tmp[1024] = "";
  strstream x(tmp, sizeof(tmp)-1);
  x << "MDBImageManager::queryDICOMStudyRoot enter method"
	<< " Start " << startLevel
	<< " Stop " << stopLevel << '\0';
  logClient.logTimeStamp(MLogClient::MLOG_VERBOSE, tmp);

  if (mDBInterface == 0) {
    logClient.logTimeStamp(MLogClient::MLOG_VERBOSE,
	"MDBImageManager::queryDICOMStudyRoot no database connection; return w/o query");
    return 0;
  }

  this->clearVectors();
  MPatientStudyVector patientStudyVector;
  MSeriesVector seriesVector;
  MSOPInstanceVector sopInstanceVector;

  if (startLevel == "STUDY") {
    this->fillPatientStudyVector(patientStudy, patientStudyVector);
    strstream x(tmp, sizeof(tmp)-1);
    x << " Patient/Study matching studies vector length = "
	<< patientStudyVector.size() << '\0';
    logClient.logTimeStamp(MLogClient::MLOG_VERBOSE, tmp);

  } else {
    MPatientStudy p;
    patientStudyVector.push_back(p);
    strstream x(tmp, sizeof(tmp)-1);
    x << " Patient/Study start level is " << startLevel
	<< " assume all studies match" << '\0';
    logClient.logTimeStamp(MLogClient::MLOG_VERBOSE, tmp);
  }
  this->fixModalitiesInStudy(patientStudyVector);

  if (stopLevel == "STUDY") {
    for (MPatientStudyVector::iterator pIter = patientStudyVector.begin();
	 pIter != patientStudyVector.end();
	 pIter++) {
      MSeries s2;
      MSOPInstance s3;
      client.selectCallback(*pIter, s2, s3);
    }

    logClient.log(MLogClient::MLOG_VERBOSE,
	"MDBImageManager::queryDICOMStudyRoot exit method, stop at STUDY");
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
    strstream x(tmp, sizeof(tmp)-1);
    x << " Patient/Study matching series vector length = "
	<< seriesVector.size() << '\0';
    logClient.logTimeStamp(MLogClient::MLOG_VERBOSE, tmp);
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
    logClient.log(MLogClient::MLOG_VERBOSE,
	"MDBImageManager::queryDICOMStudyRoot exit method, stop at SERIES");
    return 0;
  }



  // We must be stopping at the IMAGE Level

  for (MSeriesVector::iterator seriesIterator = seriesVector.begin();
	 seriesIterator != seriesVector.end();
	 seriesIterator++) {
    this->fillSOPInstanceVector(*seriesIterator, sopInstance,
				sopInstanceVector);
    strstream x(tmp, sizeof(tmp)-1);
    x << " Patient/Study matching instance vector length = "
	<< sopInstanceVector.size() << '\0';
    logClient.logTimeStamp(MLogClient::MLOG_VERBOSE, tmp);
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
    logClient.log(MLogClient::MLOG_VERBOSE,
	"MDBImageManager::queryDICOMStudyRoot exit method, stop at IMAGE");
    return 0;
  }

  // We should never get here
  logClient.log(MLogClient::MLOG_ERROR,
	"MDBImageManager::queryDICOMStudyRoot exit at end of method; this is a programming error of some kind; please log a bug report");
  return -1;
}



int
MDBImageManager::selectSOPInstance(const MSOPInstance& sopInstance,
				   MSOPInstanceVector& v)
{
  if (mDBInterface == 0)
    return 0;

  this->fillSOPInstanceVector(sopInstance, v);

  return 0;
}

int
MDBImageManager::selectSOPInstance(const MSOPInstance& pattern,
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
MDBImageManager::selectSOPInstance(MSOPInstanceVector& v)
{
  if (mDBInterface == 0)
    return 0;

  this->fillSOPInstanceVector(v);

  return 0;
}

int
MDBImageManager::enterStorageCommitmentItem(const MStorageCommitItem& item)
{
  if (mDBInterface == 0)
    return 0;

  mDBInterface->insert(item);

  return 0;
}

int
MDBImageManager::selectStorageCommitItem(const MStorageCommitItem& item,
					 MStorageCommitItemVector& v)
{
  if (mDBInterface == 0)
    return 0;

  this->fillStorageCommitVector(item, v);

  return 0;
}

int
MDBImageManager::selectStorageCommitItem(const MStorageCommitItem& pattern,
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
MDBImageManager::storageCommitmentStatus(MStorageCommitItem& item)
{
  return 0;
}

int
MDBImageManager::selectDICOMApp(const MString& aeTitle, MDICOMApp& app)
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
MDBImageManager::queryWorkOrder(MDBIMClient& client, int status)
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
MDBImageManager::deleteWorkOrder(const MString& orderNumber)
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
MDBImageManager::updateWorkOrderStatus(const MWorkOrder& workOrder, const MString& status)
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
MDBImageManager::setWorkOrderComplete(const MWorkOrder& workOrder, const MString& status)
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
MDBImageManager::recordExists(const MPatient& patient)
{
  if (patient.mapEmpty())
    return 0;

  MPatient p;
  MCriteriaVector cv;

  setCriteria(patient, cv);

  return mDBInterface->select(p, cv, NULL);
}

int
MDBImageManager::recordExists(const MVisit& visit)
{
  if (visit.mapEmpty())
    return 0;

  MVisit v;
  MCriteriaVector cv;

  setCriteria(visit, cv);

  return mDBInterface->select(v, cv, NULL);
}

int
MDBImageManager::recordExists(const MFillerOrder& order)
{
  if (order.mapEmpty())
    return 0;

  MFillerOrder fo;
  MCriteriaVector cv;
  
  setCriteria(order, cv);

  return mDBInterface->select(fo, cv, NULL);
}

int
MDBImageManager::recordExists(const MPlacerOrder& order)
{
  if (order.mapEmpty())
    return 0;

  MPlacerOrder po;
  MCriteriaVector cv;
  
  setCriteria(order, cv);

  return mDBInterface->select(po, cv, NULL);
}

int
MDBImageManager::recordExists(const MOrder& order)
{
  if (order.mapEmpty())
    return 0;

  MOrder o;
  MCriteriaVector cv;
  
  setCriteria(order, cv);

  return mDBInterface->select(o, cv, NULL);
}


void
MDBImageManager::setCriteria(const MPatient& patient, MCriteriaVector& cv)
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
MDBImageManager::setCriteria(const MStudy& study, MCriteriaVector& cv)
{
  MCriteria c;
  
  c.attribute = "stuinsuid";
  c.oper      = TBL_EQUAL;
  c.value     = study.studyInstanceUID();
  cv.push_back(c);
}

void
MDBImageManager::setCriteria(const MVisit& visit, MCriteriaVector& cv)
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
MDBImageManager::setCriteria(const MPlacerOrder& order, MCriteriaVector& cv)
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
MDBImageManager::setCriteria(const MFillerOrder& order, MCriteriaVector& cv)
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
MDBImageManager::setCriteria(const MOrder& order, MCriteriaVector& cv)
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
MDBImageManager::setCriteria(const MDomainObject& domainObject,
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

void
MDBImageManager::addRecord(const MDomainObject& domainObject)
{
  if (mDBInterface == 0)
    return;

  mDBInterface->insert(domainObject);
}

void
MDBImageManager::updateRecord(const MPatient& patient)
{
  if (mDBInterface == 0)
    return;

  MCriteriaVector cv;
  MUpdateVector   uv;

  setCriteria(patient, cv);
  setCriteria(patient, uv);

  mDBInterface->update(patient, cv, uv);
}

void
MDBImageManager::updateRecord(const MStudy& study)
{
  if (mDBInterface == 0)
    return;

  MCriteriaVector cv;
  MUpdateVector   uv;

  setCriteria(study, cv);
  setCriteria(study, uv);

  mDBInterface->update(study, cv, uv);
}

void
MDBImageManager::updateRecord(const MVisit& visit)
{
  if (mDBInterface == 0)
    return;

  MCriteriaVector cv;
  MUpdateVector   uv;

  setCriteria(visit, cv);
  setCriteria(visit, uv);

  mDBInterface->update(visit, cv, uv);
}

void
MDBImageManager::updateRecord(const MFillerOrder& order)
{
  if (mDBInterface == 0)
    return;

  MCriteriaVector cv;
  MUpdateVector   uv;

  setCriteria(order, cv);
  setCriteria(order, uv);

  mDBInterface->update(order, cv, uv);

  for (int inx = 0; inx < order.numOrders(); inx++)
    updateRecord(order.order(inx));
}

void
MDBImageManager::updateRecord(const MPlacerOrder& order)
{
  if (mDBInterface == 0)
    return;

  MCriteriaVector cv;
  MUpdateVector   uv;
  MPlacerOrder    localOrder(order);

  setCriteria(localOrder, cv);
  setCriteria(localOrder, uv);

  mDBInterface->update(localOrder, cv, uv);

  for (int inx = 0; inx < localOrder.numOrders(); inx++)
    updateRecord(localOrder.order(inx));
}

void
MDBImageManager::updateRecord(const MOrder& order)
{
  if (mDBInterface == 0)
    return;

  MCriteriaVector cv;
  MUpdateVector   uv;

  setCriteria(order, cv);
  setCriteria(order, uv);

  mDBInterface->update(order, cv, uv);
}



int
MDBImageManager::enter(const MPatient& patient)
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
  if (mDBInterface->select(p, cv, NULL)) {  // Patient is already present
    ;
  }
  else // add a new patient
    mDBInterface->insert(patient);
  
  return 0;
}

int
MDBImageManager::enter(const MStudy& study)
{
       // first do sanity check
  if (!mDBInterface)
    return 0;

  if (study.mapEmpty())
    return 0;

  // check if study already exists
  MCriteriaVector cv;
  MCriteria c;
  
  c.attribute = "stuinsuid";
  c.oper      = TBL_EQUAL;
  c.value     = study.studyInstanceUID();
  cv.push_back(c);

  MStudy s;
  if (mDBInterface->select(s, cv, NULL)) {  // Study is already present
    ;
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
MDBImageManager::enter(const MSeries& series, const MStudy& study)
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
MDBImageManager::enter(const MSOPInstance& sopInstance,
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
MDBImageManager::incrementSeriesCount(const MStudy& study) {
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
MDBImageManager::incrementSOPInstanceCount(const MStudy& study) {
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
MDBImageManager::incrementSOPInstanceCount(const MSeries& series) {
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
MDBImageManager::updateModalitiesInStudy(const MStudy& study,
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

void
patientCallback(MDomainObject& domainObj, void* ctx)
{
  MDBImageManager* mgr = (MDBImageManager*)ctx;

  MPatient p;
  p.import(domainObj);

  mgr->addToVector(p);
}

void
studyCallback(MDomainObject& domainObj, void* ctx)
{
  MDBImageManager* mgr = (MDBImageManager*)ctx;

  MStudy s;
  s.import(domainObj);

  mgr->addToVector(s);
}

void
seriesCallback(MDomainObject& domainObj, void* ctx)
{
  MDBImageManager* mgr = (MDBImageManager*)ctx;

  MSeries s;
  s.import(domainObj);

  mgr->addToVector(s);
}

void
patientStudyCallback(MDomainObject& domainObj, void* ctx)
{
  MPatientStudyVector* v = (MPatientStudyVector*)ctx;

  MPatientStudy p;
  p.import(domainObj);

  (*v).push_back(p);
}

void
workOrderCallback(MDomainObject& domainObj, void* ctx)
{
  MWorkOrderVector* v = (MWorkOrderVector*)ctx;

  MWorkOrder p;
  p.import(domainObj);

  (*v).push_back(p);
}

int
MDBImageManager::addToVector(const MPatient& patient)
{
  mPatientVector.push_back(patient);

  return 0;
}

int
MDBImageManager::addToVector(const MStudy& study)
{
  mStudyVector.push_back(study);

  return 0;
}

int
MDBImageManager::addToVector(const MSeries& series)
{
  mSeriesVector.push_back(series);

  return 0;
}

int
MDBImageManager::fillPatientVector(const MPatient& patient, MPatientVector& v)
{
  char* searchCriteria[] = {
    "patid",
    "nam",
    "datbir",
    "sex"
  };

  int i;
  MCriteriaVector criteria;

  const MDomainMap& m = patient.map();
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
  MPatient p;
  mDBInterface->select(p, criteria, patientCallback, this);
  MPatientVector::iterator patientIterator = mPatientVector.begin();
  for (; patientIterator != mPatientVector.end(); patientIterator++)
    v.push_back(*patientIterator);

  return 0;
}

int
MDBImageManager::fillStudyVector(const MPatient& patient,
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
MDBImageManager::fillStudyVector(const MStudy& study, MStudyVector& v)
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
MDBImageManager::fillSeriesVector(const MStudy& study,
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
MDBImageManager::fillPatientStudyVector(const MPatientStudy& patientStudy,
					MPatientStudyVector& v)
{

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
MDBImageManager::fillSeriesVector(const MPatientStudy& study,
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

void
sopInstanceCallback(MDomainObject& domainObj, void* ctx)
{
  MSOPInstanceVector* v = (MSOPInstanceVector*)ctx;

  MSOPInstance sopInstance;

  sopInstance.import(domainObj);

  (*v).push_back(sopInstance);
}

int
MDBImageManager::fillSOPInstanceVector(const MSOPInstance& sopInstance,
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
MDBImageManager::fillSOPInstanceVector(const MSeries& series,
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
MDBImageManager::fillSOPInstanceVector(MSOPInstanceVector& v)
{
  MCriteriaVector criteria;

  MSOPInstance pattern;

  mDBInterface->select(pattern, criteria, sopInstanceCallback, &v);
  return 0;
}


void
MDBImageManager::clearVectors(void)
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

void
storageCommitCallback(MDomainObject& domainObj, void* ctx)
{
  MStorageCommitItemVector* v = (MStorageCommitItemVector*)ctx;

  MStorageCommitItem sci;

  sci.import(domainObj);

  (*v).push_back(sci);
}

int
MDBImageManager::fillStorageCommitVector(const MStorageCommitItem& item,
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
MDBImageManager::queryAllWorkOrders(MDBIMClient& client)
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
MDBImageManager::queryNewWorkOrders(MDBIMClient& client)
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
MDBImageManager::fillWorkOrderVector(const MWorkOrder& item,
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
MDBImageManager::fixModalitiesInStudy(MPatientStudyVector& v)
{
  for (MPatientStudyVector::iterator i = v.begin(); i != v.end(); i++) {
    MString x = (*i).modalitiesInStudy();
    x.substitute('+', '\\');
    (*i).modalitiesInStudy(x);
  }
}

void
MDBImageManager::fixModalitiesInStudy(MStudyVector& v)
{
  for (MStudyVector::iterator i = v.begin(); i != v.end(); i++) {
    MString x = (*i).modalitiesInStudy();
    x.substitute('+', '\\');
    (*i).modalitiesInStudy(x);
  }
}


