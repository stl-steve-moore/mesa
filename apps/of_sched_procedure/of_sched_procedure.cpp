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

#include <fstream>

using namespace std;

static void usage()
{
  char msg[] = "\
Usage: of_sched_procedure -t <AETitle> -m <modality> [-s scheduled station name] [-p <procedure>] [-n <perf.phys.name>] [-r] <database>";

  cerr << msg << endl;
  exit(1);
}

typedef vector<MPlacerOrder> placerOrderVector;
typedef vector<MOrder> orderVector;
//typedef vector<MString> spsVector;
typedef vector<MActionItem> actionItemVector;
typedef vector<MSchedule> SCHEDULEVector;

typedef struct {
  MDBInterface dbInterface;
  placerOrderVector ov;
  orderVector orderv;
  actionItemVector av;
  //MStringVector sv;
  SCHEDULEVector scheduleVector;
  MMWL mwl;
  MOrder order;
} st_dbInterface;
  

MString mapQuantityTiming(MString& s)
{
  if(s=="S")
    return "STAT";
  if(s=="R")
    return "ROUTINE";
  if(s=="T")
    return "MEDIUM";
  if(s=="A" || s=="P" || s=="C")
    return "HIGH";
  else
    return "";
}

void scheduleSPS(MDomainObject& o, void* ctx)
{
  st_dbInterface * db= (st_dbInterface*)ctx;
  MSchedule s;
  s.import(o);

  db->scheduleVector.push_back(s);

#if 0
  db->sv.push_back(s.spsIndex());
  char currentDate[DICOM_DA_LENGTH+1];
  char currentTime[DICOM_TM_LENGTH+1];
  UTL_GetDicomDate(currentDate);
  UTL_GetDicomTime(currentTime);
  currentTime[6] = '\0';
  db->mwl.sPSStartDate(currentDate);
  db->mwl.sPSStartTime(currentTime);

#if 1
  db->mwl.spsIndex(s.spsIndex());
//  MIdentifier identifierInterface;
//  MString spsID = identifierInterface.mesaID(MIdentifier::MID_SPSID,
//					     db->dbInterface);
//  db->mwl.scheduledProcedureStepID(spsID);
#else
  db->mwl.scheduledProcedureStepID(s.scheduledProcedureStepID());
#endif

  db->mwl.sPSDescription(s.sPSDescription());
  db->dbInterface.insert(db->mwl);
#endif
}

static void
updateMWLScheduleInfo(MMWL& mwl, const MSchedule schedule,
		      MDBInterface& dbInterface)
{
  char currentDate[DICOM_DA_LENGTH+1];
  char currentTime[DICOM_TM_LENGTH+1];
  UTL_GetDicomDate(currentDate);
  UTL_GetDicomTime(currentTime);
  currentTime[6] = '\0';
  mwl.sPSStartDate(currentDate);
  mwl.sPSStartTime(currentTime);

  mwl.spsIndex(schedule.spsIndex());
  MIdentifier identifierInterface;
  MString spsID = identifierInterface.mesaID(MIdentifier::MID_SPSID,
					     dbInterface);
  mwl.scheduledProcedureStepID(spsID);

  mwl.sPSDescription(schedule.sPSDescription());
}

void queueActionItem(MDomainObject& o, void* ctx)
{
  st_dbInterface * db = (st_dbInterface*)ctx;
  MActionItem ai;
  ai.import(o);
  db->av.push_back(ai);

cout << "queueActionItem " << ai << endl;
}

void queueOrder(MDomainObject& o, void* ctx)
{
  st_dbInterface * db = (st_dbInterface*)ctx;
  MOrder order;
  order.import(o);
  (db->ov.back()).add(order);
}

void getSpecificOrder(MDomainObject& o, void* ctx)
{
  st_dbInterface * db = (st_dbInterface*)ctx;
  MOrder order;
  order.import(o);
  db->orderv.push_back(order);
}

void queuePlacerOrder(MDomainObject& o, void* ctx)
{
  st_dbInterface * db = (st_dbInterface*)ctx;
  MPlacerOrder order;
  order.import(o);
  db->ov.push_back(order);
}

void checkFillerOrder(MDomainObject& o, void* ctx)
{
  MFillerOrder * fillerOrder = (MFillerOrder*)ctx;
  fillerOrder->import(o);
}

void
retPatientID(MDomainObject& o, void* ctx)
{
  st_dbInterface * db= (st_dbInterface*)ctx;
  MFillerOrder f;
  f.import(o);

  db->mwl.patientID(f.patientID());
}

void
schedulePatient(MDomainObject& o, void* ctx)
{
  st_dbInterface * db= (st_dbInterface*)ctx;
  MPatient p;
  p.import(o);

  //copy the Patient information to the Modality Work List
  db->mwl.patientID(p.patientID());
  db->mwl.issuerOfPatientID(p.issuerOfPatientID());
  db->mwl.patientID2(p.patientID2());
  db->mwl.issuerOfPatientID2(p.issuerOfPatientID2());
  db->mwl.patientName(p.patientName());
  db->mwl.patientSex(p.patientSex());
  db->mwl.dateOfBirth(p.dateOfBirth());
}

static void stripPhysicianID(MString& referringPhysician)
{
  char physName[1024];
  referringPhysician.safeExport(physName, sizeof(physName));

  if (isdigit(physName[0])) {
    char *c = physName;
    while ((*c != '^') && (*c != '\0'))
      c++;

    if (*c == '^')
      c++;

    referringPhysician = c;
  }
}

static void
scheduleSpecificProcedure(st_dbInterface& db, MString& procedure, bool& repeatFlag)
{
  MString queryUniSerID = procedure + "^%";
  MOrder order;
  MCriteriaVector cv;
  MCriteria c;
  c.attribute = "uniserid";
  c.oper = TBL_LIKE;
  c.value = queryUniSerID;
  cv.push_back(c);
  c.attribute = "messta";
  c.oper = TBL_NOT_EQUAL;
  c.value = "SCHEDULED";
  cv.push_back(c);
  if(!repeatFlag){
    c.attribute = "messta";
    c.oper = TBL_EQUAL;
    c.value = "REQUESTED";
    cv.push_back(c);
  }
  db.dbInterface.select(order, cv, getSpecificOrder, &db);
  
  MUpdateVector uv;
  MUpdate u;
  u.attribute = "messta";
  u.func = TBL_SET;
  u.value = "DONE";
  uv.push_back(u);
  db.dbInterface.update(order, cv, uv);

  int numOfOrders = db.orderv.size();
  for(int i=0; i<numOfOrders; i++){
    MPlacerOrder po;
    MCriteriaVector cv1;
    if(!repeatFlag){
      c.attribute = "messta";
      c.oper = TBL_EQUAL;
      c.value = "REQUESTED";
      cv1.push_back(c);
    }
    c.attribute = "plaordnum";
    c.oper = TBL_EQUAL;
    c.value = (db.orderv.back()).placerOrderNumber();
    cv1.push_back(c);
    //the following should only return one placer order
    cout << "Placer Orders: "<< db.dbInterface.select(po, cv1, queuePlacerOrder, &db) << endl;

    //create a corresponding Filler Order and query for
    //a new FillerOrderNumber using MIdentifier
    MPlacerOrder requestedOrders = db.ov.back();
    MFillerOrder fillerOrder;
    fillerOrder.patientID(requestedOrders.patientID());
    fillerOrder.issuerOfPatientID(requestedOrders.issuerOfPatientID());
    fillerOrder.placerOrderNumber(requestedOrders.placerOrderNumber());
    if((db.ov.back()).fillerOrderNumber() != "")
      fillerOrder.fillerOrderNumber((db.ov.back()).fillerOrderNumber());
    else{
      MIdentifier id;
      MString f = id.mesaID(MIdentifier::MID_FILLERORDERNUMBER, db.dbInterface);
      cout << "Generated Filler Order Number:" << f << endl;
      fillerOrder.fillerOrderNumber(f);
    }
    db.mwl.fillerOrderNumber(fillerOrder.fillerOrderNumber());
    db.mwl.accessionNumber((fillerOrder.fillerOrderNumber()).getToken('^',0));

    //query for patient information
    MPatient p;
    MCriteriaVector cv2;
    c.attribute = "patid";
    c.oper = TBL_EQUAL;
    c.value = requestedOrders.patientID();
    cv2.push_back(c);

    //get the required Patient attributes
    db.dbInterface.select(p, cv2, schedulePatient, &db);

    //get the Requested Procedure level data
    //and generate a study instance uid
    MIdentifier id2;
    MString studyInsUID = id2.dicomUID(MIdentifier::MUID_STUDY, db.dbInterface);
    MString conceptualStudyUID = id2.dicomUID(MIdentifier::MUID_STUDY, db.dbInterface);
    MString reqProID = id2.mesaID(MIdentifier::MID_REQUESTEDPROCEDURE, db.dbInterface);
    db.mwl.requestedProcedureID(reqProID);
    db.mwl.orderUID((db.orderv.back()).orderUID());
    db.mwl.studyInstanceUID(studyInsUID);
    db.mwl.referencedStudySOPClass(DICOM_SOPCLASSDETACHEDSTUDYMGMT);
    db.mwl.referencedStudySOPInstance(conceptualStudyUID);
    MString s1 = ((db.orderv.back()).quantityTiming()).getToken('^',5);
    db.mwl.quantityTiming(s1);

#if 0
    db.mwl.quantityTiming(mapQuantityTiming(((db.orderv.back()).quantityTiming()).getToken('^',5)));
#endif
    MString siteModifier = ((db.orderv.back()).specimenSource()).getToken('^',4);
    db.mwl.requestedProcedureDescription(((db.orderv.back()).universalServiceID()).getToken('^',1) +" "+ siteModifier);
  
    //create a Requested Procedure Code Item
    //this implementation assumes a 1 to 1 relationship with Requested Procedure
    db.mwl.codeValue(((db.orderv.back()).universalServiceID()).getToken('^',0));
    db.mwl.codeMeaning(((db.orderv.back()).universalServiceID()).getToken('^',1));
    db.mwl.codeSchemeDesignator(((db.orderv.back()).universalServiceID()).getToken('^',2));

    MSchedule s;
    MCriteriaVector cv3;

    c.attribute = "uniserid";
    c.oper = TBL_LIKE;
    c.value = ((db.orderv.back()).universalServiceID()).getToken('^',0) + "^%";
    cv3.push_back(c);

    //now we'll actually schedule the given order,
    //MSchedule does this based on Universal Service ID
    db.dbInterface.select(s, cv3, scheduleSPS, &db);

    //we have one last thing to do, and that's add scheduled
    //orders to our Filler Order object
    int spsSize = db.scheduleVector.size();
    for(int x = 0; x < spsSize; x++){
       updateMWLScheduleInfo(db.mwl, db.scheduleVector.back(),
			     db.dbInterface);
       db.dbInterface.insert(db.mwl);

       MCriteriaVector cv4;
       c.attribute = "spsindex";
       c.oper = TBL_EQUAL;
       c.value = (db.scheduleVector.back()).spsIndex();
       cv4.push_back(c);
       //the following criteria will eventually be included
       //c.attribute = "stuinsuid";
       //c.oper = TBL_EQUAL;
       //c.value = db.mwl.studyInstanceUID();
       //cv4.push_back(c);
	
       MActionItem ai;
       db.dbInterface.select(ai, cv4, queueActionItem, &db);
       int avSize = db.av.size();
       MString referringPhysician;
       if (avSize > 0)
	 db.orderv.back().referringDoctor();
       stripPhysicianID(referringPhysician);
       db.mwl.referringPhysicianName(referringPhysician);
       MIdentifier identifierInterface;
       MString spsID = identifierInterface.mesaID(MIdentifier::MID_SPSID,
						  db.dbInterface);
       db.mwl.scheduledProcedureStepID(spsID);

       //get universalServiceID to be scheduled
       MString universalServiceID = (db.orderv.back()).universalServiceID();
       for(int n = 0; n < avSize; n++){
	 (db.orderv.back()).mesaStatus("SCHEDULED");
	 (db.orderv.back()).universalServiceID(universalServiceID + "^" + (db.av.back()).codeValue()
				      + "^" + (db.av.back()).codeMeaning() + "^"
				      + (db.av.back()).codeSchemeDesignator());
	 (db.orderv.back()).fillerOrderNumber(fillerOrder.fillerOrderNumber());
	 fillerOrder.add(db.orderv.back());
	 db.av.pop_back();
       } 
       db.scheduleVector.pop_back();
    }
  
  db.ov.pop_back();
  db.orderv.pop_back();

  //insert Filler Order
  db.dbInterface.insert(fillerOrder);
  for(int w = 0; w < fillerOrder.numOrders(); w++)
    db.dbInterface.insert(fillerOrder.order(w));
  }
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
scheduleProcedures(MMWL& mwl, st_dbInterface& db,
		   const MString& requestedProcedure)
{
  MSchedule s;
  MCriteriaVector cv3;
  MCriteria c3;

  c3.attribute = "uniserid";
  c3.oper = TBL_LIKE;
  c3.value = requestedProcedure + "^%";
  cv3.push_back(c3);

  db.dbInterface.select(s, cv3, scheduleSPS, &db);

  int spsSize = db.scheduleVector.size();
  for(int x = 0; x < spsSize; x++){
    MString x = db.scheduleVector.back().universalServiceID();
    db.mwl.requestedProcedureDescription(x.getToken('^', 1));

    db.mwl.codeValue(x.getToken('^',0));
    db.mwl.codeMeaning(x.getToken('^',1));
    db.mwl.codeSchemeDesignator(x.getToken('^',2));

    updateMWLScheduleInfo(db.mwl, db.scheduleVector.back(),
			  db.dbInterface);

    db.dbInterface.insert(db.mwl);
    db.scheduleVector.pop_back();
  }
}


int main(int argc, char** argv)
{ 
  
  st_dbInterface db;
  MString procedure = "";
  bool repeatFlag = false;
  db.mwl.scheduledStationName("station1");

  while (--argc > 0 && (*++argv)[0] == '-') {
    switch(*(argv[0] + 1)) {
    case 't':
      argc--; argv++;
      if (argc < 1)
	usage();
      db.mwl.scheduledAETitle(MString(*argv));
      break;
    case 'm':
      argc--; argv++;
      if (argc < 1)
	usage();
      db.mwl.modality(MString(*argv));
      break;
    case 'n':
      argc--; argv++;
      if (argc < 1)
	usage();
      db.mwl.scheduledPerformingPhysicianName(MString(*argv));
      break;
    case 'p':
      argc--; argv++;
      if (argc < 1)
	usage();
      procedure = *argv;
      break;
    case 'r':
      repeatFlag = true;
      break;
    case 's':
      argc--; argv++;
      if (argc < 1)
	usage();
      db.mwl.scheduledStationName(MString(*argv));
      break;
    default:
      break;
    }
  }
  if (argc < 3)
    usage();

  //scheduling will be done in the specified database
  db.dbInterface = MDBInterface(*argv);
  argv++;

  fillMWL(db.mwl, *argv);
  argv++;

  MString requestedProcedure(*argv);

  fillIdentifiers(db.mwl, db.dbInterface);

  //cout << db.mwl << endl;

  scheduleProcedures(db.mwl, db,
		     requestedProcedure);

  return 0;
}

#if 0

    db.mwl.fillerOrderNumber(fillerOrder.fillerOrderNumber());
    db.mwl.accessionNumber((fillerOrder.fillerOrderNumber()).getToken('^',0));

    MPatient p;
    MCriteriaVector cv2;
    MCriteria c2;
    
    c2.attribute = "patid";
    c2.oper = TBL_EQUAL;
    c2.value = requestedOrders.patientID();
    cv2.push_back(c2);

    int numOrders = (db.ov.back()).numOrders();

    for(int k=0; k < numOrders; k++){
      //keep track of what order we're scheduling within the given
      //Placer Order
      db.order = requestedOrders.order(k);
      MString referringPhysician = db.order.referringDoctor();
      stripPhysicianID(referringPhysician);
      db.mwl.referringPhysicianName(referringPhysician);
      
      //get the required Patient attributes
      db.dbInterface.select(p, cv2, schedulePatient, &db);

      //get the Requested Procedure level data
      //and generate a study instance uid
      MIdentifier id2;
      MString studyInsUID = id2.dicomUID(MIdentifier::MUID_STUDY, db.dbInterface);
      MString conceptualStudyUID = id2.dicomUID(MIdentifier::MUID_STUDY, db.dbInterface);
      MString reqProID = id2.mesaID(MIdentifier::MID_REQUESTEDPROCEDURE, db.dbInterface);
      db.mwl.requestedProcedureID(reqProID);
      db.mwl.orderUID(db.order.orderUID());
      db.mwl.studyInstanceUID(studyInsUID);
      db.mwl.referencedStudySOPClass(DICOM_SOPCLASSDETACHEDSTUDYMGMT);
      db.mwl.referencedStudySOPInstance(conceptualStudyUID);
      MString s2 = (db.order.quantityTiming()).getToken('^',5);
      db.mwl.quantityTiming(s2);
#if 0
      db.mwl.quantityTiming(mapQuantityTiming((db.order.quantityTiming()).getToken('^',5)));
#endif

      MString siteModifier = (db.order.specimenSource()).getToken('^',4);
      db.mwl.requestedProcedureDescription((db.order.universalServiceID()).getToken('^',1) +" "+ siteModifier);
  
      //create a Requested Procedure Code Item
      //this implementation assumes a 1 to 1 relationship with Requested Procedure
      db.mwl.codeValue((db.order.universalServiceID()).getToken('^',0));
      db.mwl.codeMeaning((db.order.universalServiceID()).getToken('^',1));
      db.mwl.codeSchemeDesignator((db.order.universalServiceID()).getToken('^',2));

      MSchedule s;
      MCriteriaVector cv3;
      MCriteria c3;

      c3.attribute = "uniserid";
      c3.oper = TBL_EQUAL;
      c3.value = db.order.universalServiceID();
      cv3.push_back(c3);

      //now we'll actually schedule the given order,
      //MSchedule does this based on Universal Service ID
      db.dbInterface.select(s, cv3, scheduleSPS, &db);

      //we have one last thing to do, and that's add scheduled
      //orders to our Filler Order object
      int spsSize = db.scheduleVector.size();
      for(int x = 0; x < spsSize; x++){
	updateMWLScheduleInfo(db.mwl, db.scheduleVector.back(),
			      db.dbInterface);
	db.dbInterface.insert(db.mwl);

	MCriteriaVector cv4;
	MCriteria c4;
	MCriteria c5;

cout << "Index = " << x << " sps index " << (db.scheduleVector.back()).spsIndex() << endl;

	c4.attribute = "spsindex";
	c4.oper = TBL_EQUAL;
	c4.value = (db.scheduleVector.back()).spsIndex();
	cv4.push_back(c4);
	//the following criteria will eventually be included
	//c5.attribute = "stuinsuid";
        //c5.oper = TBL_EQUAL;
        //c5.value = db.mwl.studyInstanceUID();
        //cv4.push_back(c5);
	
	MActionItem ai;
	db.dbInterface.select(ai, cv4, queueActionItem, &db);
	int avSize = db.av.size();
	//get universalServiceID to be scheduled
	MString universalServiceID = db.order.universalServiceID();
	for(int n = 0; n < avSize; n++){
	  db.order.mesaStatus("SCHEDULED");
	  db.order.universalServiceID(universalServiceID + "^" + (db.av.back()).codeValue()
				      + "^" + (db.av.back()).codeMeaning() + "^"
				      + (db.av.back()).codeSchemeDesignator());
	  db.order.fillerOrderNumber(fillerOrder.fillerOrderNumber());
	  fillerOrder.add(db.order);
	  db.av.pop_back();
	} 
	db.scheduleVector.pop_back();
      }
    }
    //handle the next Placer Order and insert Filler Order
    if(!fillerOrderExists)
      db.dbInterface.insert(fillerOrder);
    for(int w = 0; w < fillerOrder.numOrders(); w++)
      db.dbInterface.insert(fillerOrder.order(w));
    db.ov.pop_back();
  }
return 0;
}
#endif
