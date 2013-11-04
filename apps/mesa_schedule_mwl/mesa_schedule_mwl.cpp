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
#include "MLogClient.hpp"

using namespace std;

static bool verbose;

static void usage()
{
  char msg[] =
"Usage: mesa_schedule_mwl [-n perf.phys.name] -m modality [-p procedure] [-r]  [-s <scheduled station name>] \n"
"\t[-D column value] -t AETitle [-c column value] [-v] database \n "
"\n"
"  -m    Set modality value; required switch; no default \n"
"  -n    Set Performing Physician Name; default is empty string \n"
"  -p    If set, schedule this specific procedure only \n"
"  -r    Repeat flag; reschedule even those procedures marked DONE \n"
"  -s    Set Scheduled Station Name; default is station 1 \n"
"  -t    Set AE Title for MWL entry; required switch; no default \n"
"  -v    Verbose flag.  \n"
"  -D    Insert the given value into given column.  General purpose flag which may be \n"
"        repeated."
"  -c    Select only those entries whose value matches in the given column\n"
"\n"
"  database   Name of database to use";

  cerr << msg << endl;
  ::exit(1);
}

typedef vector<MPlacerOrder> placerOrderVector;
typedef vector<MOrder> orderVector;
typedef vector<MActionItem> actionItemVector;
typedef vector<MSchedule> SCHEDULEVector;

typedef struct {
  MDBInterface* dbInterface;
  placerOrderVector ov;
  orderVector orderv;
  actionItemVector av;
  SCHEDULEVector scheduleVector;
  MMWL mwl;
  MOrder order;
} st_dbInterface;

void orderSelectCallback(MDomainObject& o, void* ctx)
{
  orderVector* v = (orderVector*)ctx;
  MOrder order;
  order.import(o);
  v->push_back(order);
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

  if (isdigit(physName[0])) {
    char *c = physName;
    while ((*c != '^') && (*c != '\0'))
      c++;

    if (*c == '^')
      c++;

    referringPhysician = c;
  }
}

static int
fillRequestedProcedureModule(MMWL& mwlEntry, const MOrder& o,
		MDBInterface& db)
{
  MIdentifier id;
  MString studyInsUID = id.dicomUID(MIdentifier::MUID_STUDY, db);
  mwlEntry.studyInstanceUID(studyInsUID);
  mwlEntry.referencedStudySOPClass(DICOM_SOPCLASSDETACHEDSTUDYMGMT);
  mwlEntry.referencedStudySOPInstance(studyInsUID);

  MString reqProID = id.mesaID(MIdentifier::MID_REQUESTEDPROCEDURE, db);
  mwlEntry.requestedProcedureID(reqProID);

  MString placerOrderNumber = o.placerOrderNumber();
  mwlEntry.placerOrderNumber(placerOrderNumber);

  MString fillerOrderNumber = o.fillerOrderNumber();
  mwlEntry.fillerOrderNumber(fillerOrderNumber);
  mwlEntry.accessionNumber(fillerOrderNumber.getToken('^',0));

  MString quantityTiming = o.quantityTiming().getToken('^',5);
  mwlEntry.quantityTiming(quantityTiming);

  mwlEntry.eventReason("");
  mwlEntry.requestedDateTime("");

  MString specimenSource = o.specimenSource();
  mwlEntry.specimenSource(specimenSource);

  MString orderingProvider = o.orderingProvider();
  stripPhysicianID(orderingProvider);
  mwlEntry.orderingProvider(orderingProvider);

  MString universalServiceID = o.universalServiceID();
  mwlEntry.requestedProcedureDescription(universalServiceID.getToken('^', 1));

  mwlEntry.requestedProcedureCodeSeq("");
  mwlEntry.occurrenceNumber("");
  mwlEntry.appointmentTimingQuantity("");

  MString orderUID = o.orderUID();
  mwlEntry.orderUID(orderUID);

  return 0;
}

static int
fillRequestedProcedureCodeItem(MMWL& mwlEntry, const MOrder& o,
		MDBInterface& db)
{
  MString universalServiceID = o.universalServiceID();
  mwlEntry.codeValue(universalServiceID.getToken('^', 0));
  mwlEntry.codeMeaning(universalServiceID.getToken('^', 1));
  mwlEntry.codeSchemeDesignator(universalServiceID.getToken('^', 2));
  return 0;
}

static void callbackMScheduleSelect(MDomainObject& o, void* ctx)
{
  MSchedule s;
  s.import(o);

  MSchedule* sPtr = (MSchedule*)ctx;
  sPtr->spsIndex(s.spsIndex());
  sPtr->sPSDescription(s.sPSDescription());
  return;
}

static int
mapUniversalServiceIDtoScheduleObject(MSchedule& scheduleObject,
	const MString universalServiceID, MDBInterface& db)
{
  MCriteriaVector cv;
  MCriteria c;

  c.attribute = "uniserid";
  c.oper = TBL_EQUAL;
  c.value = universalServiceID;
  cv.push_back(c);

  MSchedule s;
  db.select(s, cv, callbackMScheduleSelect, &s);
  scheduleObject.import(s);
  return 0;
}

static int
fillSPSModule(MMWL& mwlEntry, const MOrder& o,
		MDBInterface& db)
{
  MIdentifier id;
  MString spsID = id.mesaID(MIdentifier::MID_SPSID, db);
  mwlEntry.scheduledProcedureStepID(spsID);

  MSchedule scheduleObject;
  MString universalServiceID = o.universalServiceID();
  if (mapUniversalServiceIDtoScheduleObject(scheduleObject,
	universalServiceID, db) != 0) {
    return 1;
  }
  mwlEntry.spsIndex(scheduleObject.spsIndex());

  mwlEntry.scheduledAETitle("MODALITY1");	// This default gets fixed later

  // Fill in start date time from today;
  char currentDate[DICOM_DA_LENGTH+1];
  char currentTime[DICOM_TM_LENGTH+1];
  UTL_GetDicomDate(currentDate);
  UTL_GetDicomTime(currentTime);
  currentTime[6] = '\0';
  mwlEntry.sPSStartDate(currentDate);
  mwlEntry.sPSStartTime(currentTime);

  mwlEntry.modality("MR");			// This default gets fixed later

  mwlEntry.scheduledPerformingPhysicianName("");

  mwlEntry.sPSDescription(scheduleObject.sPSDescription());
  mwlEntry.sPSLocation("");
  mwlEntry.preMedication("");
  mwlEntry.requestedContrastAgent("");
  mwlEntry.scheduledStationName("station1");	// This assumption gets fixed later
  mwlEntry.sPSStatus("");
  MString requestingPhysician = o.orderingProvider();
  stripPhysicianID(requestingPhysician);
  mwlEntry.requestingPhysicianName(requestingPhysician);
  MString referringPhysician = o.referringDoctor();
  stripPhysicianID(referringPhysician);
  mwlEntry.referringPhysicianName(referringPhysician);
  return 0;
}

static void callbackMPatientSelect(MDomainObject& o, void* ctx)
{
  MPatient* p = (MPatient*) ctx;
  p->import(o);

  return;
}
 
static int
fillPatientFromPatientID(MPatient& patient,
	const MString& patientID, MDBInterface& db)
{
  MPatient p;
  MCriteriaVector cv;
  MCriteria c;

  c.attribute = "patid";
  c.oper = TBL_EQUAL;
  c.value = patientID;
  cv.push_back(c);

  db.select(p, cv, callbackMPatientSelect, &p);
  patient.import(p);
  return 0;
}
 
static void callbackMPlacerOrderSelect(MDomainObject& o, void* ctx)
{
  MPlacerOrder* p = (MPlacerOrder*) ctx;
  p->import(o);

  return;
}

static int
fillPlacerOrderFromOrder(MPlacerOrder& placerOrder,
	const MOrder& order, MDBInterface& db)
{
  MCriteriaVector cv;
  MCriteria c;

  c.attribute = "plaordnum";
  c.oper = TBL_EQUAL;
  c.value = order.placerOrderNumber();
  cv.push_back(c);

  MPlacerOrder p;
  db.select(p, cv, callbackMPlacerOrderSelect, &p);
  placerOrder.import(p);
  return 0;
}

static void callbackMVisitSelect(MDomainObject& o, void* ctx)
{
  MVisit* v = (MVisit*) ctx;
  v->import(o);

  return;
}


static int
fillVisitFromOrder(MVisit& visit,
	const MOrder& order, MDBInterface& db)
{
  MPlacerOrder placerOrder;
  fillPlacerOrderFromOrder(placerOrder, order, db);

  MVisit v;
  MCriteria c;
  MCriteriaVector cv;
  c.attribute = "patid";
  c.oper = TBL_EQUAL;
  c.value = placerOrder.patientID();
  cv.push_back(c);

  db.select(v, cv, callbackMVisitSelect, &v);
  visit.import(v);
  return 0;
}

static int
fillPatientModule(MMWL& mwlEntry, const MOrder& o,
		MDBInterface& db)
{
  MPlacerOrder placerOrder;
  if (fillPlacerOrderFromOrder(placerOrder, o, db) != 0) {
    return 1;
  }
  MString patientID = placerOrder.patientID();
  MPatient p;
  if (fillPatientFromPatientID(p, patientID, db) != 0) {
    return 1;
  }
  mwlEntry.patientID(p.patientID());
  mwlEntry.issuerOfPatientID(p.issuerOfPatientID());
  mwlEntry.patientID2(p.patientID2());
  mwlEntry.issuerOfPatientID2(p.issuerOfPatientID2());
  mwlEntry.patientName(p.patientName());
  mwlEntry.patientSex(p.patientSex());
  mwlEntry.dateOfBirth(p.dateOfBirth());

  return 0;
}

static int
fillPatientMedicalModule(MMWL& mwlEntry, const MOrder& o,
		MDBInterface& db)
{
  mwlEntry.pregnancyStatus("4");	// Hard code status for unknown
  return 0;
}

static int
fillVisitIdentification(MMWL& mwlEntry, const MOrder& o,
		MDBInterface& db)
{
  MVisit v;
  fillVisitFromOrder(v, o, db);
  mwlEntry.admissionID(v.visitNumber());
  return 0;
}

static int
fillVisitStatus(MMWL& mwlEntry, const MOrder& o,
		MDBInterface& db)
{
  MVisit v;
  fillVisitFromOrder(v, o, db);
  mwlEntry.currentPatientLocation(v.assignedPatientLocation());
  return 0;
}

static int
fillNamedAttributes(MMWL& mwlEntry, MStringMap& m)
{
  MStringMap::iterator it = m.begin();
  while (it != m.end()) {
    MString key = (*it).first;
    MString val = (*it).second;
    mwlEntry.insert(key, val);
    it++;
  }
  return 0;
}

static int
insertMWLEntry(const MMWL& mwl, MDBInterface& db)
{
  int status;
  status = db.insert(mwl);
  return status;
}


static int
scheduleOneOrder(MDBInterface& db, const MOrder& o, MStringMap& m)
{
  int status;
  MLogClient logClient;
  MStringMap::iterator it = m.begin();
  while (it != m.end()) {
    MString nam = (*it).first;
    MString val = (*it).second;
    if (verbose) 
        cout << nam << ":" << val << endl;
    it++;
  }

  MMWL mwlEntry;
  status = fillRequestedProcedureModule(mwlEntry, o, db);
  if (status != 0) {
    cerr << "Failed in fillRequestedProcedureModule" << endl;
    return 1;
  }

  status = fillRequestedProcedureCodeItem(mwlEntry, o, db);
  if (status != 0) {
    cerr << "Failed in fillRequestedProcedureCodeItem" << endl;
    return 1;
  }

  status = fillSPSModule(mwlEntry, o, db);
  if (status != 0) {
    cerr << "Failed in fillSPSModule" << endl;
    return 1;
  }

  status = fillPatientModule(mwlEntry, o, db);
  if (status != 0) {
    cerr << "Failed in fillPatientModule" << endl;
    return 1;
  }

  status = fillPatientMedicalModule(mwlEntry, o, db);
  if (status != 0) {
    cerr << "Failed in fillPatientMedicalModule" << endl;
    return 1;
  }

  status = fillVisitIdentification(mwlEntry, o, db);
  if (status != 0) {
    cerr << "Failed in fillVisitIdentification" << endl;
    return 1;
  }

  status = fillVisitStatus(mwlEntry, o, db);
  if (status != 0) {
    cerr << "Failed in fillVisitStatus" << endl;
    return 1;
  }

  status = fillNamedAttributes(mwlEntry, m);
  if (status != 0) {
    cerr << "Failed in fillNamedAttributes" << endl;
    return 1;
  }

  MMWL m1;
  m1.import(mwlEntry);

  if (verbose) {
      cout << "\nmwlEntry:" << endl;
      cout << mwlEntry << endl;
      cout << "\nml:" << endl;
      cout << m1       << endl;
  }

  status = insertMWLEntry(mwlEntry, db);
  if (status != 0) {
    cerr << "Failed in insertMWLEntry" << endl;
    return 1;
  }

  return 0;
}


int main(int argc, char** argv)
{
  st_dbInterface db;
  bool repeatFlag = false;
  db.mwl.scheduledStationName("station1");
  MString orderCriteriaColumn = "";
  MString orderCriteriaValue  = "";
  MString columnName  = "";
  MStringMap mwlParameters;
  verbose = false;
  char stationName[20];

   while (--argc > 0 && (*++argv)[0] == '-') {
    switch(*(argv[0] + 1)) {
    case 'c':
      argc--; argv++;
      if (argc < 2)
	usage();
      orderCriteriaColumn = *argv;
      argc--; argv++;
      orderCriteriaValue = *argv;
      break;
    case 'D':
      argc--; argv++;
      if (argc < 2)
	usage();
      columnName = *argv;
      argc--; argv++;
      mwlParameters[columnName] = *argv;
      break;
    case 'm':
      argc--; argv++;
      if (argc < 1)
	usage();
      mwlParameters["mod"] = *argv;
      break;
    case 'n':
      argc--; argv++;
      if (argc < 1)
	usage();
      mwlParameters["schperphynam"] = *argv;
      break;
    case 'r':
      repeatFlag = true;
      break;
    case 's':
      argc--; argv++;
      if (argc < 1)
	usage();
      if (::strlen(*argv) > 16) {
	::strncpy(stationName, *argv, 16);
	stationName[16] = '\0';
	mwlParameters["schstanam"] = stationName;
      } else {
	mwlParameters["schstanam"] = *argv;
      }
      break;
    case 't':
      argc--; argv++;
      if (argc < 1)
	usage();
      mwlParameters["schaet"] = *argv;
      break;
    case 'v':
      verbose = true;
      break;
    default:
      break;
    }
  }

  if (argc < 1)
    usage();

  //scheduling will be done in the specified database
  db.dbInterface = new MDBInterface(*argv);
  
  MOrder order;
  MCriteriaVector cv;
  MCriteria c;

  //get all Placer Orders with mesaStatus of "REQUESTED"
  if (!repeatFlag) {
    c.attribute = "messta";
    c.oper = TBL_EQUAL;
    c.value = "REQUESTED";
    cv.push_back(c);
  }
  if (orderCriteriaColumn != "") {
    c.attribute = orderCriteriaColumn;
    c.oper = TBL_EQUAL;
    c.value = orderCriteriaValue;
    cv.push_back(c);
  }

  //query for all the existing orders that need to be scheduled
  orderVector v;
  db.dbInterface->select(order, cv, orderSelectCallback, &v);
  int vectorLength = v.size();
  if (verbose) 
      cout << endl << "Scheduling " << vectorLength << " orders ...." << endl;

  int i = 0;
  for(i = 0; i < vectorLength; i++) {
    MOrder o = v[i];
    if (verbose) cout << o << endl;
  }

  int status;
  for(i = 0; i < vectorLength; i++) {
    MOrder o = v[i];
    MIdentifier id;
    MString fillerOrderNumber = id.mesaID(MIdentifier::MID_FILLERORDERNUMBER, *db.dbInterface);
    o.fillerOrderNumber(fillerOrderNumber);
    status = scheduleOneOrder(*db.dbInterface, o, mwlParameters);
    if (status != 0) {
      cout << "Unable to schedule MWL entries for order: " << o << endl;
      return 1;
    }
  }
  delete db.dbInterface;
  return 0;
}
