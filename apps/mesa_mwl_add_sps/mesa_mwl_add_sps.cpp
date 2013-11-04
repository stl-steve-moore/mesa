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
"Usage: mesa_mwl_add_sps [-n perf.phys.name] -m modality [-p procedure] [-r]  [-s <scheduled station name>] \n"
"\t[-D column value] -t AETitle [-c column value] [-v] database code-item \n "
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
"  -c    Select only those entries from MWL table whose value matches in the given column\n"
"\n"
"  database   Name of database to use\n"
"  code-item  Protocol code item value for SPS\n";

  cerr << msg << endl;
  ::exit(1);
}

typedef vector<MPlacerOrder> placerOrderVector;
typedef vector<MMWL> mwlVector;
typedef vector<MActionItem> actionItemVector;
typedef vector<MSchedule> SCHEDULEVector;

typedef struct {
  MDBInterface dbInterface;
  placerOrderVector ov;
  mwlVector mwlv;
  actionItemVector av;
  SCHEDULEVector scheduleVector;
  MMWL mwl;
  MOrder order;
} st_dbInterface;

void mwlSelectCallback(MDomainObject& m, void* ctx)
{
  mwlVector* v = (mwlVector*)ctx;
  MMWL mwl;
  mwl.import(m);
  v->push_back(mwl);
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

static void callbackActionItem(MDomainObject& o, void* ctx)
{
  MActionItem* aPtr = (MActionItem*)ctx;
  aPtr->import(o);
  return;
}

static int
mapProtocolCodeItemToSPSIndex(MString& spsIndex,
	const MString& protocolCodeValue, MDBInterface& db)
{
  MCriteriaVector cv;
  MCriteria c;
  MActionItem ai;

  c.attribute = "codval";
  c.oper = TBL_EQUAL;
  c.value = protocolCodeValue;
  cv.push_back(c);

  MActionItem localActionItem;

  db.select(localActionItem, cv, callbackActionItem, &localActionItem);
  spsIndex = localActionItem.spsIndex();
  return 0;
}


static void callbackSchedule(MDomainObject& o, void* ctx)
{
  MSchedule* ptr = (MSchedule*)ctx;
  ptr->import(o);
  MString x = ptr->sPSDescription();
  cout << "sps description: " << x << endl;
  return;
}

static int
mapSPSIndexToSPSDescription(MString& spsDescription,
	const MString& spsIndex, MDBInterface& db)
{
  MCriteriaVector cv;
  MCriteria c;
  MActionItem ai;

  c.attribute = "spsindex";
  c.oper = TBL_EQUAL;
  c.value = spsIndex;
  cv.push_back(c);

  MSchedule localSchedule;

  db.select(localSchedule, cv, callbackSchedule, &localSchedule);
  spsDescription = localSchedule.sPSDescription();
  return 0;
}

static int
modifySPSModule(MMWL& mwlEntry, const MString& protocolCodeItem,
		MDBInterface& db)
{
  MIdentifier id;
  MString spsID = id.mesaID(MIdentifier::MID_SPSID, db);
  mwlEntry.scheduledProcedureStepID(spsID);

  MString spsIndex;
  if (mapProtocolCodeItemToSPSIndex(spsIndex, protocolCodeItem, db) != 0) {
    return 1;
  }
  MString spsDescription;
  if (mapSPSIndexToSPSDescription(spsDescription, spsIndex, db) != 0) {
    return 1;
  }

  mwlEntry.spsIndex(spsIndex);

  mwlEntry.scheduledAETitle("SCHEDULEDAE");	// This default gets fixed later

  // Fill in start date time from today;
  char currentDate[DICOM_DA_LENGTH+1];
  char currentTime[DICOM_TM_LENGTH+1];
  UTL_GetDicomDate(currentDate);
  UTL_GetDicomTime(currentTime);
  currentTime[6] = '\0';
  mwlEntry.sPSStartDate(currentDate);
  mwlEntry.sPSStartTime(currentTime);

  mwlEntry.modality("XX");			// This default gets fixed later

  //mwlEntry.scheduledPerformingPhysicianName("");

  mwlEntry.sPSDescription(spsDescription);
  //mwlEntry.sPSLocation("");
  //mwlEntry.preMedication("");
  //mwlEntry.requestedContrastAgent("");
  //mwlEntry.scheduledStationName("station1");	// This assumption gets fixed later
  mwlEntry.sPSStatus("");
  //MString requestingPhysician = o.orderingProvider();
  //stripPhysicianID(requestingPhysician);
  //mwlEntry.requestingPhysicianName(requestingPhysician);
  //MString referringPhysician = o.referringDoctor();
  //stripPhysicianID(referringPhysician);
  //mwlEntry.referringPhysicianName(referringPhysician);
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
modifyPatientModule(MMWL& mwlEntry, MDBInterface& db)
{
//  mwlEntry.patientID(p.patientID());
//  mwlEntry.issuerOfPatientID(p.issuerOfPatientID());
//  mwlEntry.patientID2(p.patientID2());
//  mwlEntry.issuerOfPatientID2(p.issuerOfPatientID2());
//  mwlEntry.patientName(p.patientName());
//  mwlEntry.patientSex(p.patientSex());
//  mwlEntry.dateOfBirth(p.dateOfBirth());

  return 0;
}

static int
modifyPatientMedicalModule(MMWL& mwlEntry, MDBInterface& db)
{
  //mwlEntry.pregnancyStatus("4");	// Hard code status for unknown
  return 0;
}

static int
modifyVisitIdentification(MMWL& mwlEntry, MDBInterface& db)
{
  //MVisit v;
  //fillVisitFromOrder(v, o, db);
  //mwlEntry.admissionID(v.visitNumber());
  return 0;
}

static int
modifyVisitStatus(MMWL& mwlEntry, MDBInterface& db)
{
  //MVisit v;
  //fillVisitFromOrder(v, o, db);
  //mwlEntry.currentPatientLocation(v.assignedPatientLocation());
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
addOneSPS(MDBInterface& db, const MMWL& mwl, const MString& protocolCodeItem,
	  MStringMap& m)
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

  MMWL mwlEntry(mwl);

  status = modifySPSModule(mwlEntry, protocolCodeItem, db);
  if (status != 0) {
    cerr << "Failed in modifySPSModule" << endl;
    return 1;
  }

  status = modifyPatientModule(mwlEntry, db);
  if (status != 0) {
    cerr << "Failed in modifyPatientModule" << endl;
    return 1;
  }

  status = modifyPatientMedicalModule(mwlEntry, db);
  if (status != 0) {
    cerr << "Failed in modifyPatientMedicalModule" << endl;
    return 1;
  }

  status = modifyVisitIdentification(mwlEntry, db);
  if (status != 0) {
    cerr << "Failed in modifyVisitIdentification" << endl;
    return 1;
  }

  status = modifyVisitStatus(mwlEntry, db);
  if (status != 0) {
    cerr << "Failed in modifyVisitStatus" << endl;
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
  MMWL mwlQueryObject;
  MCriteriaVector cv;
  MCriteria c;
  MString protocolCodeItem;

   while (--argc > 0 && (*++argv)[0] == '-') {
    switch(*(argv[0] + 1)) {
    case 'c':
      argc--; argv++;
      if (argc < 2)
	usage();
      
      c.attribute = *argv;
      argc--; argv++;
      c.oper = TBL_EQUAL;
      c.value = *argv;
      cv.push_back(c);
      break;

    case 'D':
      argc--; argv++;
      if (argc < 2)
	usage();
      columnName = *argv;
      argc--; argv++;
      mwlParameters[columnName] = *argv;
      break;
    case 'l':
      argc--; argv++;
      if (argc < 1)
	usage();
      mwlParameters["spsloc"] = *argv;
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

    case 's':
      argc--; argv++;
      if (argc < 1)
	usage();
      mwlParameters["schstanam"] = *argv;
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

  if (argc < 2)
    usage();

  //scheduling will be done in the specified database
  db.dbInterface = MDBInterface(*argv);
  protocolCodeItem = argv[1];

  // Search the existing MWL table. We are going to append
  // to existing entries.

  //query for all the existing orders that need to be scheduled
  mwlVector v;
  db.dbInterface.select(mwlQueryObject, cv, mwlSelectCallback, &v);
  int vectorLength = v.size();
  if (verbose) 
      cout << endl << "Scheduling " << vectorLength << " orders ...." << endl;

  if (vectorLength != 1) {
    cout << "mesa_mwl_add_sps expected to find one matching MWL item; found "
	    << vectorLength << endl;
    return 1;
  }
  int i = 0;
  for(i = 0; i < vectorLength; i++) {
    MMWL m = v[i];
    if (verbose) cout << m << endl;
  }

  int status;
  for(i = 0; i < vectorLength; i++) {
    MMWL m = v[i];
    status = addOneSPS(db.dbInterface, m, protocolCodeItem, mwlParameters);
    if (status != 0) {
      cout << "Unable to add (append) MWL entry for item: " << m << endl;
      return 1;
    }
  }

  return 0;
}
