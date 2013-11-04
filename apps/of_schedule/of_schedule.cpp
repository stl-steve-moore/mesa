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
#include "MVisit.hpp"
#include "MFillerOrder.hpp"
#include "MCodeItem.hpp"
#include "MSchedule.hpp"
#include "MActionItem.hpp"
#include "MIdentifier.hpp"
#include "MMWL.hpp"
#include "MCharsetEncoder.hpp"

#include <fstream>

using namespace std;

static void usage()
{
  char msg[] = "\
Usage: of_schedule [-n perf.phys.name] -m modality [-p procedure] [-r]  [-s <scheduled station name>] [-t AETitle] database \n\
\n\
  -m    Set modality value; required switch; no default \n\
  -n    Set Performing Physician Name; default is empty string \n\
  -p    If set, schedule this specific procedure only \n\
  -r    Repeat flag; reschedule even those procedures marked DONE \n\
  -s    Set Scheduled Station Name; default is station1 \n\
  -t    Set AE Title for MWL entry; required switch; no default \n\
\n\
  database   Name of database to use";

  cerr << msg << endl;
  exit(1);
}

typedef vector<MPlacerOrder> placerOrderVector;
typedef vector<MOrder> orderVector;
//typedef vector<MString> spsVector;
typedef vector<MActionItem> actionItemVector;
typedef vector<MSchedule> SCHEDULEVector;

typedef struct {
  MDBInterface *dbInterface;
  placerOrderVector ov;
  orderVector orderv;
  actionItemVector av;
  //MStringVector sv;
  SCHEDULEVector scheduleVector;
  MMWL mwl;
  MOrder order;
} st_dbInterface;
MString characterEncoding = "";
MString spsLocation = "";

static void updateMWLCharacterEncoding(MMWL& mwl)
{
  if (characterEncoding != "ISO2022JP") {
    return;
  }

  MMWL mwlEUCJP(mwl);
  char* updateNamesMWL[] = { "nam", "ordpro", "schperphynam", "reqphynam", "refphynam" };
  int idx;
  char valueEUCHL7[1024] = "";
  char valueEUCDICOM[1024] = "";
  MCharsetEncoder e;
  for (idx = 0; idx < 1; idx++) {
    MString s = mwl.value(updateNamesMWL[idx]);
    s.safeExport(valueEUCHL7, sizeof(valueEUCHL7));
    int inputLength = ::strlen(valueEUCHL7);
    int outputLength = 0;
    e.xlateHL7DICOMEUCJP(valueEUCDICOM, outputLength, 1024,
	valueEUCHL7, inputLength, "EUCJP");
    valueEUCDICOM[outputLength] = '\0';
    mwlEUCJP.insert(updateNamesMWL[idx], valueEUCDICOM);
  }
  mwl.import(mwlEUCJP);
}

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

cout << s << endl;

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

  db->mwl.pregnancyStatus("4"); // Hard code unknown status
}

void
scheduleVisit(MDomainObject& o, void* ctx)
{
  st_dbInterface * db= (st_dbInterface*)ctx;
  MVisit v;
  v.import(o);

  //copy the Visit information to the Modality Work List
  db->mwl.admissionID(v.visitNumber());
  db->mwl.currentPatientLocation(v.assignedPatientLocation());
}

static void stripPhysicianID(MString& referringPhysician)
{
  char physName[1024];
  referringPhysician.safeExport(physName, sizeof(physName));

  if (physName[0] == '^' || isdigit(physName[0])) {
    char *c = physName;
    while ((*c != '^') && (*c != '\0'))
      c++;

    if (*c == '^')
      c++;

    referringPhysician = c;
  }
}

static void swapNamePrefixSuffix(MString& name)
{
  MString nameComponents[10];
  int idx = 1;
  for (idx = 0; idx < 10; idx++) {
    nameComponents[idx] = "";
    if (name.tokenExists('^', idx)) {
      nameComponents[idx] = name.getToken('^', idx);
    }
  }

  name = nameComponents[0] + '^' +
	nameComponents[1] + '^' +
	nameComponents[2] + '^' +
	nameComponents[4] + '^' +
	nameComponents[3];
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
  db.dbInterface->select(order, cv, getSpecificOrder, &db);
  
  MUpdateVector uv;
  MUpdate u;
  u.attribute = "messta";
  u.func = TBL_SET;
  u.value = "DONE";
  uv.push_back(u);
  db.dbInterface->update(order, cv, uv);

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
    cout << "Placer Orders: "<< db.dbInterface->select(po, cv1, queuePlacerOrder, &db) << endl;

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
      MString f = id.mesaID(MIdentifier::MID_FILLERORDERNUMBER, *db.dbInterface);
      cout << "Generated Filler Order Number:" << f << endl;
      fillerOrder.fillerOrderNumber(f);
    }
    db.mwl.placerOrderNumber(fillerOrder.placerOrderNumber());
    db.mwl.fillerOrderNumber(fillerOrder.fillerOrderNumber());
    db.mwl.accessionNumber((fillerOrder.fillerOrderNumber()).getToken('^',0));

    //query for patient information
    {
      MPatient p;
      MCriteriaVector cv2;
      c.attribute = "patid";
      c.oper = TBL_EQUAL;
      c.value = requestedOrders.patientID();
      cv2.push_back(c);

      //get the required Patient attributes
      db.dbInterface->select(p, cv2, schedulePatient, &db);
    }

    // Now pick up any visit information
    {
      MVisit v;
      MCriteria c3;
      MCriteriaVector cv3;
      c3.attribute = "patid";
      c3.oper = TBL_EQUAL;
      c3.value = requestedOrders.patientID();
      cv3.push_back(c3);

      db.dbInterface->select(v, cv3, scheduleVisit, &db);
    }

    //get the Requested Procedure level data
    //and generate a study instance uid
    MIdentifier id2;
    MString studyInsUID = id2.dicomUID(MIdentifier::MUID_STUDY, *db.dbInterface);
    //MString conceptualStudyUID = id2.dicomUID(MIdentifier::MUID_STUDY, db.dbInterface);
    MString conceptualStudyUID = studyInsUID;
    MString reqProID = id2.mesaID(MIdentifier::MID_REQUESTEDPROCEDURE, *db.dbInterface);
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
    db.dbInterface->select(s, cv3, scheduleSPS, &db);

    //we have one last thing to do, and that's add scheduled
    //orders to our Filler Order object
    int spsSize = db.scheduleVector.size();
    for(int x = 0; x < spsSize; x++){
       updateMWLScheduleInfo(db.mwl, db.scheduleVector.back(),
			     *db.dbInterface);
       // Modify MWL entry for multi-byte character sets
       updateMWLCharacterEncoding(db.mwl);
       db.dbInterface->insert(db.mwl);

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
       db.dbInterface->select(ai, cv4, queueActionItem, &db);
       int avSize = db.av.size();
       MString referringPhysician = "";
       MString requestingPhysician = "";
       if (avSize > 0) {
	 referringPhysician = db.orderv.back().referringDoctor();
	 requestingPhysician = db.orderv.back().orderingProvider();
       }
       stripPhysicianID(referringPhysician);
       swapNamePrefixSuffix(referringPhysician);
       stripPhysicianID(requestingPhysician);
       swapNamePrefixSuffix(requestingPhysician);

       db.mwl.requestingPhysicianName(requestingPhysician);
       db.mwl.referringPhysicianName(referringPhysician);
       MIdentifier identifierInterface;
       MString spsID = identifierInterface.mesaID(MIdentifier::MID_SPSID,
						  *db.dbInterface);
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
  db.dbInterface->insert(fillerOrder);
  for(int w = 0; w < fillerOrder.numOrders(); w++)
    db.dbInterface->insert(fillerOrder.order(w));
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
    case 'c':
      argc--; argv++;
      if (argc < 1)
	usage();
      characterEncoding = *argv;
      break;
    case 'l':
      argc--; argv++;
      if (argc < 1)
	usage();
      db.mwl.sPSLocation(MString(*argv));
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
    case 't':
      argc--; argv++;
      if (argc < 1)
	usage();
      db.mwl.scheduledAETitle(MString(*argv));
      break;
    default:
      break;
    }
  }
  if (argc < 1)
    usage();

  //scheduling will be done in the specified database
  db.dbInterface = new MDBInterface(*argv);
  
  //schedule a specific procedure,
  //if one is specified with the -p flag
  if(procedure != ""){
    scheduleSpecificProcedure(db, procedure, repeatFlag);
    return 0;
  }

  MPlacerOrder order;
  MCriteriaVector cv;

  //get all Placer Orders with mesaStatus of "REQUESTED"
  if(!repeatFlag){
    MCriteria c;
    c.attribute = "messta";
    c.oper = TBL_EQUAL;
    c.value = "REQUESTED";
    cv.push_back(c);
  }

  //query for all the existing orders that need to be scheduled
  db.dbInterface->select(order, cv, queuePlacerOrder, &db);

  //Query for scheduling information
  //to create Scheduled Procedure Steps for each order
  //in every returned Placer Order
  int ovSize = db.ov.size();
  cout << endl << "Scheduling " << ovSize << " Placer Orders ...." << endl;
  for(int i = 0; i < ovSize; i++){
    
    //change the MESA status of the placer order we're about
    //to schedule
    MCriteriaVector criteriav;
    MCriteria criteria;
    criteria.attribute = "plaordnum";
    criteria.oper = TBL_EQUAL;
    criteria.value = (db.ov.back()).placerOrderNumber();
    criteriav.push_back(criteria);
    MUpdateVector uv;
    MUpdate u;
    u.attribute = "messta";
    u.func = TBL_SET;
    u.value = "DONE";
    uv.push_back(u);
    db.dbInterface->update(db.ov.back(), criteriav, uv);

    //first we need to queue all the REQUESTED orders
    //for the Placer Order to be scheduled
    MOrder o;
    MCriteria c0;
    MCriteriaVector cv0;
    c0.attribute = "plaordnum";
    c0.oper = TBL_EQUAL;
    c0.value = (db.ov.back()).placerOrderNumber();
    cv0.push_back(c0);
    c0.attribute = "messta";
    c0.oper = TBL_NOT_EQUAL;
    c0.value = "SCHEDULED";
    cv0.push_back(c0);
    if(!repeatFlag){
      c0.attribute = "messta";
      c0.oper = TBL_EQUAL;
      c0.value = "REQUESTED";
      cv0.push_back(c0);
    }
    int retOrders = db.dbInterface->select(o, cv0, queueOrder, &db);

    //change MESA status to DONE for orders serviced
    MUpdateVector uv0;
    u.attribute = "messta";
    u.func = TBL_SET;
    u.value = "DONE";
    uv0.push_back(u);
    db.dbInterface->update(o, cv0, uv0);
    
    cout << retOrders << "  orders to be scheduled for this Placer Order: " << 
	 (db.ov.back()).placerOrderNumber() << endl;

    //requestedOrders will be the Placer Order to be scheduled
    MPlacerOrder requestedOrders = db.ov.back();

    //Create a corresponding Filler Order and query for
    //a new FillerOrderNumber using MIdentifier

    //first check to see if fillerOrder already exists from
    //a previous of_schedule using the -p flag
    MFillerOrder fillerOrder;
    MCriteriaVector cv1;
    c0.attribute = "plaordnum";
    c0.value = requestedOrders.placerOrderNumber();
    c0.oper = TBL_EQUAL;
    cv1.push_back(c0);
    int fillerOrderExists = db.dbInterface->select(fillerOrder, cv1, checkFillerOrder, &fillerOrder);
    if(!fillerOrderExists || repeatFlag){
      fillerOrder.patientID(requestedOrders.patientID());
      fillerOrder.issuerOfPatientID(requestedOrders.issuerOfPatientID());
      fillerOrder.placerOrderNumber(requestedOrders.placerOrderNumber());
      if((db.ov.back()).fillerOrderNumber() != "")
	fillerOrder.fillerOrderNumber((db.ov.back()).fillerOrderNumber());
      else{
	MIdentifier id;
	MString f = id.mesaID(MIdentifier::MID_FILLERORDERNUMBER, *db.dbInterface);
	cout << "Generated Filler Order Number:" << f << endl;
	fillerOrder.fillerOrderNumber(f);
      }
    }
    db.mwl.placerOrderNumber(fillerOrder.placerOrderNumber());
    db.mwl.fillerOrderNumber(fillerOrder.fillerOrderNumber());
    db.mwl.accessionNumber((fillerOrder.fillerOrderNumber()).getToken('^',0));

    int numOrders = (db.ov.back()).numOrders();

    for(int k=0; k < numOrders; k++){
      //keep track of what order we're scheduling within the given
      //Placer Order
      db.order = requestedOrders.order(k);
      MString referringPhysician = db.order.referringDoctor();
      stripPhysicianID(referringPhysician);
      swapNamePrefixSuffix(referringPhysician);
      db.mwl.referringPhysicianName(referringPhysician);

      MString requestingPhysician = db.order.orderingProvider();
      stripPhysicianID(requestingPhysician);
      swapNamePrefixSuffix(requestingPhysician);
      db.mwl.requestingPhysicianName(requestingPhysician);
      
      //get the required Patient attributes
      {
	MPatient p;
	MCriteriaVector cv2;
	MCriteria c2;

	c2.attribute = "patid";
	c2.oper = TBL_EQUAL;
	c2.value = requestedOrders.patientID();
	cv2.push_back(c2);

	db.dbInterface->select(p, cv2, schedulePatient, &db);
      }

      // Now pick up any visit information
      {
	MVisit v;
	MCriteria c3;
	MCriteriaVector cv3;
	c3.attribute = "patid";
	c3.oper = TBL_EQUAL;
	c3.value = requestedOrders.patientID();
	cv3.push_back(c3);

	db.dbInterface->select(v, cv3, scheduleVisit, &db);
      }

      //get the Requested Procedure level data
      //and generate a study instance uid
      MIdentifier id2;
      MString studyInsUID = id2.dicomUID(MIdentifier::MUID_STUDY, *db.dbInterface);
      //MString conceptualStudyUID = id2.dicomUID(MIdentifier::MUID_STUDY, db.dbInterface);
      MString conceptualStudyUID = studyInsUID;
      MString reqProID = id2.mesaID(MIdentifier::MID_REQUESTEDPROCEDURE, *db.dbInterface);
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
      db.dbInterface->select(s, cv3, scheduleSPS, &db);

      //we have one last thing to do, and that's add scheduled
      //orders to our Filler Order object
      int spsSize = db.scheduleVector.size();
      for(int x = 0; x < spsSize; x++){
	updateMWLScheduleInfo(db.mwl, db.scheduleVector.back(),
			      *db.dbInterface);
	// Modify MWL entry for multi-byte character sets
	updateMWLCharacterEncoding(db.mwl);
	db.dbInterface->insert(db.mwl);

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
	db.dbInterface->select(ai, cv4, queueActionItem, &db);
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
      db.dbInterface->insert(fillerOrder);
    for(int w = 0; w < fillerOrder.numOrders(); w++)
      db.dbInterface->insert(fillerOrder.order(w));
    db.ov.pop_back();
  }
  delete db.dbInterface;
return 0;
}
