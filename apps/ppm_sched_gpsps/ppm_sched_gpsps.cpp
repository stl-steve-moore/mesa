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

// 
#include "MESA.hpp"
#include "MDomainObject.hpp"
#include "MDBInterface.hpp"
#include "MOrder.hpp"
#include "MPlacerOrder.hpp"
#include "MPatient.hpp"
#include "MFillerOrder.hpp"
#include "MCodeItem.hpp"
#include "MSchedule.hpp"
#include "MActionItem.hpp"
#include "MIdentifier.hpp"
#include "MMWL.hpp"
#include "ctn_api.h"
#include "MGPWorkitemObject.hpp"
#include "MStationName.hpp"
#include "MStudy.hpp"
#include "MSeries.hpp"
#include "MSOPInstance.hpp"

#include <fstream>

using namespace std;

static void usage()
{
  char msg[] = "Usage: ppm_sched_gpsps [-p <procedure>] [-o <placerOrderNum>] <ppwf_database> <gpspsfile>";

  cerr << msg << endl;
  exit(1);
}

typedef vector<MOrder> orderVector;

typedef struct {
  MDBInterface ordfil_dbInterface;
  MDBInterface imgmgr_dbInterface;
  MDBInterface ppwf_dbInterface;
  orderVector orderv;
  //MMWL mwl;
  //MOrder order;
  MGPWorkitemObject wio;
} st_dbInterface;
  

void getSpecificOrder(MDomainObject& o, void* ctx)
{
  st_dbInterface * db = (st_dbInterface*)ctx;
  MOrder order;
  order.import(o);
  db->orderv.push_back(order);
}

void
getMWL( MDomainObject& o, void* ctx)
{
  MMWL *mwl = (MMWL *)ctx;
  (*mwl).import(o);
}

void
getStudy( MDomainObject& o, void* ctx)
{
  MStudy *study = (MStudy *)ctx;
  (*study).import(o);
}

void
getSeries( MDomainObject& o, void* ctx)
{
  MSeries *series = (MSeries *)ctx;
  (*series).import(o);
}

void
getSOPins( MDomainObject& o, void* ctx)
{
  MSOPInstanceVector *sopv = (MSOPInstanceVector *)ctx;
  MSOPInstance sop;
  sop.import(o);
  (*sopv).push_back(sop);
}

// assumes that the workitemObject's SOP Instance UID has been initialized
// prior to calling this function.
static void
fillGPWorkitemObject(MGPWorkitemObject& wio, const char* fileName)
{
  MStringMap m;

  ifstream f(fileName);
  if (f == 0) {
    cerr << "Could not open GPWorkitemObject description: " << fileName << endl;
    ::exit(1);
  }

  char buf[1024];
  while (f.getline(buf, sizeof(buf))) {
    MString l(buf);
    if ((buf[0] == '#') || (buf[0] == '\n'))
      continue;
    MString t1 = l.getToken('\t', 0);
    MString t2 = l.getToken('\t', 1);
    m[t1] = t2;
  }

  MString workitemkey = wio.workitem().SOPInstanceUID();
  MDomainObject domainObj;
  MStringMap::iterator it = m.begin();
  for (; it != m.end(); it++) {
    MString key = (*it).first;
    //if( key.compare("stationname",0) == 0) {
    if( key == "stationname") {
       MString value = (*it).second;
       int i = 0;
       while( value.tokenExists(',',i)) {
          MString tok = value.getToken(',', i);
          MStationName sn(tok, workitemkey);
          wio.addStationName(sn);
          i++;
       }
    }
    //else if( key.compare("stationclass",0) == 0) {
    else if( key == "stationclass") {
       MString value = (*it).second;
       int i = 0;
       while( value.tokenExists(',',i)) {
          MString tok = value.getToken(',', i);
          MStationClass sc(tok, workitemkey);
          wio.addStationClass(sc);
          i++;
       }
    }
    else if( key == "schedWorkitemCode") {
       MString value = (*it).second;
       MGPWorkitem wi = wio.workitem();
       wi.workItemCodeValue(value.getToken('^',0));
       wi.workItemCodeScheme(value.getToken('^',1));
       wi.workItemCodeMeaning(value.getToken('^',2));
       wio.workitem(wi);
    }
    else if( key == "startdatetime") {
       MString value = (*it).second;
       wio.startDateTime(value);
    }
  }

#if 0
  MDomainObject domainObj;
  MStringMap::iterator it = m.begin();
  for (; it != m.end(); it++) {
    MString key = (*it).first;
    MString value = (*it).second;
    domainObj.insert(key, value);
  }
  wio.import(domainObj);
#endif
}

static void
fillMWL(MMWL& mwl, const char* fileName)
{
  MStringMap m;

  ifstream f(fileName);
  if (f == 0) {
    cerr << "Could not open MWL description: " << fileName << endl;
    ::exit(1);
  }

  char buf[1024];
  while (f.getline(buf, sizeof(buf))) {
    MString l(buf);
    if ((buf[0] == '#') || (buf[0] == '\n'))
      continue;
    MString t1 = l.getToken('\t', 0);
    MString t2 = l.getToken('\t', 1);
    m[t1] = t2;
  }

  MDomainObject domainObj;
  MStringMap::iterator it = m.begin();
  for (; it != m.end(); it++) {
    MString key = (*it).first;
    MString value = (*it).second;
    domainObj.insert(key, value);
  }
  mwl.import(domainObj);
}

static void
fillIdentifiers(MGPWorkitem& wi, MDBInterface& dbInterface)
{
  MIdentifier identifier;

  MString s;

  wi.SOPClassUID( DICOM_SOPGPSPS);
  
  s = identifier.dicomUID(MIdentifier::MUID_GPSPS, dbInterface);
  wi.SOPInstanceUID(s);

  s = identifier.mesaID(MIdentifier::MID_SPSID, dbInterface);
  wi.procedureStepID(s);
}

static void
fillIdentifiers(MGPWorkitemObject& wio, MDBInterface& dbInterface)
{
  MIdentifier identifier;

  MString s;

  s = identifier.dicomUID(MIdentifier::MUID_GPSPS, dbInterface);
  wio.SOPInstanceUID(s);

  MGPWorkitem wi = wio.workitem();
  wi.SOPClassUID( DICOM_SOPGPSPS);
  
  //s = identifier.mesaID(MIdentifier::MID_SPSID, dbInterface);
  s = identifier.mesaID(MIdentifier::MID_REQUESTEDPROCEDURE, dbInterface);
  wi.procedureStepID(s);

  wio.workitem(wi);

}

static void
fillIdentifiers(MMWL& mwl, MDBInterface& dbInterface)
{
  MIdentifier identifier;

  MString s;

  s = identifier.dicomUID(MIdentifier::MUID_STUDY, dbInterface);
  mwl.studyInstanceUID(s);

  s = identifier.dicomUID(MIdentifier::MUID_STUDY, dbInterface);
  mwl.referencedStudySOPInstance(s);

  mwl.referencedStudySOPClass(DICOM_SOPCLASSDETACHEDSTUDYMGMT);

  s = identifier.mesaID(MIdentifier::MID_REQUESTEDPROCEDURE, dbInterface);
  mwl.requestedProcedureID(s);

  s = identifier.mesaID(MIdentifier::MID_FILLERORDERNUMBER, dbInterface);
  mwl.fillerOrderNumber(s);
  mwl.accessionNumber(s);

  char today[20];
  ::UTL_GetDicomDate(today);
  s = today;
  mwl.requestedDateTime(s + "1300");

}

static void
fillInputInfo(MGPWorkitem& wi, MDBInterface& dbInterface, 
                MInputInfoVector& iiv)
{
  // select Study with this accession number.
  MStudy study;
  MCriteriaVector cv_study;
  MCriteria c;
  c.attribute = "accnum";
  c.oper = TBL_EQUAL;
  c.value = wi.requestedProcAccessionNum();
  cv_study.push_back(c);
  dbInterface.select( study, cv_study, getStudy, &study);

  // select series with study's instance uid.
  MSeries series;
  MCriteriaVector cv_series;
  c.attribute = "stuinsuid";
  c.oper = TBL_EQUAL;
  c.value = study.studyInstanceUID();
  cv_series.push_back(c);
  dbInterface.select( series, cv_series, getSeries, &series);

  // select sop instances from the series.
  MSOPInstanceVector sopv;
  MSOPInstance sop;
  MCriteriaVector cv_sop;
  c.attribute = "serinsuid";
  c.oper = TBL_EQUAL;
  c.value = series.seriesInstanceUID();
  cv_sop.push_back(c);
  dbInterface.select( sop, cv_sop, getSOPins, &sopv);

  int nImgs = sopv.size();
cout << nImgs << " images found\n";
  MSOPInstanceVector::const_iterator it = sopv.begin();
  for (; it != sopv.end(); it++) {
    sop = *it;
    MInputInfo info;
    info.SOPInstanceUID(sop.instanceUID() );
    info.SOPClassUID(sop.classUID() );
    info.studyInstanceUID(series.studyInstanceUID() );
    info.seriesInstanceUID(series.seriesInstanceUID() );
    info.workitemkey(wi.SOPInstanceUID());
    iiv.push_back(info);
  }

}

static void
schedulePostProcProcedure(st_dbInterface& db, MString& plaOrdNum,
        MString& procedure)
{
  MString queryUniSerID = plaOrdNum + "%";
  MOrder order;
  MCriteriaVector cv;
  MCriteria c;
  c.attribute = "plaordnum";
  c.oper = TBL_LIKE;
  c.value = queryUniSerID;
  cv.push_back(c);
  c.attribute = "messta";
  c.oper = TBL_EQUAL;
  c.value = "SCHEDULED";
  cv.push_back(c);

  db.ordfil_dbInterface.select(order, cv, getSpecificOrder, &db);
  
  MUpdateVector uv;
  MUpdate u;
  u.attribute = "messta";
  u.func = TBL_SET;
  u.value = "DONE";
  uv.push_back(u);
//  db.dbInterface.update(order, cv, uv);

  int nOrders = db.orderv.size();
//cout << nOrders << " orders found\n";
  MOrderVector::const_iterator it = db.orderv.begin();
  for (; it != db.orderv.end(); it++) {
    MOrder order = *it;
    MString filordnum = order.fillerOrderNumber();

    // select MWL with this filordnum.
    MMWL mwl;
    MCriteriaVector cv_mwl;
    MCriteria c_mwl;
    c_mwl.attribute = "filordnum";
    c_mwl.oper = TBL_EQUAL;
    c_mwl.value = filordnum;
    cv_mwl.push_back(c_mwl);
    db.ordfil_dbInterface.select( mwl, cv_mwl, getMWL, &mwl);

//cout << mwl;

    fillIdentifiers(db.wio, db.ordfil_dbInterface);

    // get a copy of wio's wi.
    MGPWorkitem wi = db.wio.workitem();

    // definitely don't want this for RWF, but do we want to put the procedure
    // code here for PWF?  I don't think so....
    //wi.workItemCodeValue(procedure.getToken('^',0));
    //wi.workItemCodeScheme(procedure.getToken('^',1));
    //wi.workItemCodeMeaning(procedure.getToken('^',2));

    wi.requestedProcID(mwl.requestedProcedureID());
    wi.requestedProcAccessionNum(mwl.accessionNumber());
    wi.requestedProcDesc(mwl.requestedProcedureDescription());
    wi.requestedProcCodevalue(mwl.codeValue());
    wi.requestedProcCodemeaning(mwl.codeMeaning());
    wi.requestedProcCodescheme(mwl.codeSchemeDesignator());
    wi.requestingPhysician(mwl.requestingPhysicianName());

    wi.patientName(mwl.patientName());
    wi.patientID(mwl.patientID());
    wi.patientBirthDate(mwl.dateOfBirth());
    wi.patientSex(mwl.patientSex());

    wi.status("SCHEDULED");
    wi.inputAvailabilityFlag("COMPLETE");
    wi.priority("LOW");
    wi.inputStudyInstanceUID(mwl.studyInstanceUID());
    wi.resultStudyInstanceUID(mwl.studyInstanceUID());

    // update wio's wi
    db.wio.workitem(wi);

    MInputInfoVector iiv;
    wi = db.wio.workitem();
    fillInputInfo(wi, db.imgmgr_dbInterface, iiv);
    db.wio.inputInfoVector(iiv);

//cout << "\n\n";
//cout << db.wio;

    db.wio.insert(db.ppwf_dbInterface);
  }

}

int main(int argc, char** argv)
{ 
  
  st_dbInterface db;

  // create a default code scheme.
  MString plaOrdNum; // identifies orders to which this procedure is scheduled.
  MString procedure; // code val^scheme^meaning of proc being scheduled.
  char* idFile = 0; // file to record SOPinstanceUIDs of created GPSPSs

  while (--argc > 0 && (*++argv)[0] == '-') {
    switch(*(argv[0] + 1)) {
    case 'o':
      argc--; argv++;
      if (argc < 1)
	usage();
      plaOrdNum = MString(*argv);
      break;
    case 'p':
      argc--; argv++;
      if (argc < 1)
	usage();
      procedure = MString(*argv);
      break;
    case 'i':
      argc--; argv++;
      if (argc < 1)
	usage();
      idFile = *argv;
      break;
    default:
      break;
    }
  }
  if (argc < 1)
    usage();

  //scheduling will be done in the specified database
  db.ppwf_dbInterface = MDBInterface(*argv);
  db.ordfil_dbInterface = MDBInterface("ordfil");
  db.imgmgr_dbInterface = MDBInterface("imgmgr");
  argv++;

  fillGPWorkitemObject(db.wio, *argv);

  schedulePostProcProcedure( db, plaOrdNum, procedure);

  return 0;
}

