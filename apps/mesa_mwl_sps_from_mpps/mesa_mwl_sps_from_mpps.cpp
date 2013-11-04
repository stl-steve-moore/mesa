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
#include "MDICOMWrapper.hpp"
#include "MLogClient.hpp"

using namespace std;

static bool verbose;

static void usage()
{
  char msg[] =
"Usage: mesa_mwl_sps_from_mpps [-n perf.phys.name] -m modality [-p procedure] [-r]  [-s <scheduled station name>] \n"
"\t[-D column value] -t AETitle [-c column value] [-u univ-service-id] [-v] database code-item mpps-file\n "
"\n"
"  -m    Set modality value; required switch; no default \n"
"  -n    Set Performing Physician Name; default is empty string \n"
"  -p    If set, schedule this specific procedure only \n"
"  -r    Repeat flag; reschedule even those procedures marked DONE \n"
"  -s    Set Scheduled Station Name; default is station 1 \n"
"  -t    Set AE Title for MWL entry; required switch; no default \n"
"  -u    Set value for universal service ID in MWL entry\n"
"  -v    Verbose flag.  \n"
"  -D    Insert the given value into given column.  General purpose flag \n"
"        which may be repeated.\n"
"  -c    Select only those entries from MWL table whose value matches in the given column\n"
"\n"
"  database   Name of database to use\n"
"  code-item  Protocol code item value for SPS\n"
"  mpps-file  File with MPPS final status\n";

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
modifyRequestedProcedureModule(MMWL& mwlEntry, MDBInterface& db, MDICOMWrapper& mppsWrapper)
{
  MString studyInstanceUID = mppsWrapper.getString(0x00400270, 0x0020000D);
  mwlEntry.studyInstanceUID(studyInstanceUID);

  mwlEntry.referencedStudySOPClass(DICOM_SOPCLASSDETACHEDSTUDYMGMT);
  mwlEntry.referencedStudySOPInstance(studyInstanceUID);

  mwlEntry.placerOrderNumber("");
  MIdentifier id;
  MString fillerOrderNumber = id.mesaID(MIdentifier::MID_FILLERORDERNUMBER, db);
  mwlEntry.fillerOrderNumber(fillerOrderNumber + "^MESA");
  mwlEntry.accessionNumber(fillerOrderNumber);

  mwlEntry.eventReason("");
  mwlEntry.requestedDateTime("");

  mwlEntry.orderingProvider("");
  mwlEntry.requestedProcedureDescription("");
  mwlEntry.requestedProcedureCodeSeq("");
  mwlEntry.occurrenceNumber("");
  mwlEntry.appointmentTimingQuantity("");
  mwlEntry.orderUID("");

  return 0;
}

static int
modifyRequestedProcedureCodeItem(MMWL& mwlEntry, MDBInterface& db, MStringMap& m)
{
  MString universalServiceID = m["uniserid"];
  mwlEntry.codeValue(universalServiceID.getToken('^', 0));
  mwlEntry.codeMeaning(universalServiceID.getToken('^', 1));
  mwlEntry.codeSchemeDesignator(universalServiceID.getToken('^', 2));
  return 0;
}

static int
modifySPSModule(MMWL& mwlEntry, const MString& protocolCodeItem,
		MDBInterface& db, MDICOMWrapper& mppsWrapper)
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
  mwlEntry.sPSLocation("");
  mwlEntry.preMedication("");
  mwlEntry.requestedContrastAgent("");
  //mwlEntry.scheduledStationName("station1");	// This assumption gets fixed later
  mwlEntry.sPSStatus("");
  mwlEntry.requestingPhysicianName("");
  mwlEntry.referringPhysicianName("");
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
modifyPatientModule(MMWL& mwlEntry, MDBInterface& db, MDICOMWrapper& mppsWrapper)
{
  MString patientID = mppsWrapper.getString(0x00100020);
  mwlEntry.patientID(patientID);

//  mwlEntry.issuerOfPatientID(p.issuerOfPatientID());
//  mwlEntry.patientID2(p.patientID2());
//  mwlEntry.issuerOfPatientID2(p.issuerOfPatientID2());
  MString patientName = mppsWrapper.getString(0x00100010);
  mwlEntry.patientName(patientName);

  MString dateOfBirth = mppsWrapper.getString(0x00100030);
  mwlEntry.dateOfBirth(dateOfBirth);

  MString patientSex = mppsWrapper.getString(0x00100040);
  mwlEntry.patientSex(patientSex);

  return 0;
}

static int
modifyPatientMedicalModule(MMWL& mwlEntry, MDBInterface& db, MDICOMWrapper& mppsWrapper)
{
  mwlEntry.pregnancyStatus("4");	// Hard code status for unknown
  return 0;
}

static int
modifyVisitIdentification(MMWL& mwlEntry, MDBInterface& db, MDICOMWrapper& mppsWrapper)
{
  mwlEntry.admissionID("");
  return 0;
}

static int
modifyVisitStatus(MMWL& mwlEntry, MDBInterface& db, MDICOMWrapper& mppsWrapper)
{
  mwlEntry.currentPatientLocation("");
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
addOneSPS(MDBInterface& db, const MString& protocolCodeItem,
	  MStringMap& m, MDICOMWrapper& mppsWrapper)
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

  status = modifyRequestedProcedureModule(mwlEntry, db, mppsWrapper);
  if (status != 0) {
    cerr << "Failed in modifyVisitStatus" << endl;
    return 1;
  }

  status = modifyRequestedProcedureCodeItem(mwlEntry, db, m);
  if (status != 0) {
    cerr << "Failed in modifyVisitStatus" << endl;
    return 1;
  }

  status = modifySPSModule(mwlEntry, protocolCodeItem, db, mppsWrapper);
  if (status != 0) {
    cerr << "Failed in modifySPSModule" << endl;
    return 1;
  }

  status = modifyPatientModule(mwlEntry, db, mppsWrapper);
  if (status != 0) {
    cerr << "Failed in modifyPatientModule" << endl;
    return 1;
  }

  status = modifyPatientMedicalModule(mwlEntry, db, mppsWrapper);
  if (status != 0) {
    cerr << "Failed in modifyPatientMedicalModule" << endl;
    return 1;
  }

  status = modifyVisitIdentification(mwlEntry, db, mppsWrapper);
  if (status != 0) {
    cerr << "Failed in modifyVisitIdentification" << endl;
    return 1;
  }

  status = modifyVisitStatus(mwlEntry, db, mppsWrapper);
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

  status = insertMWLEntry(m1, db);
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
    case 'u':
      argc--; argv++;
      if (argc < 1)
	usage();
      mwlParameters["uniserid"] = *argv;
      break;
    case 'v':
      verbose = true;
      break;
    default:
      break;
    }
  }

  if (argc < 3)
    usage();

  //scheduling will be done in the specified database
  db.dbInterface = MDBInterface(*argv);
  protocolCodeItem = argv[1];
  MDICOMWrapper mppsWrapper(argv[2]);

  int status = 0;
  status = addOneSPS(db.dbInterface, protocolCodeItem, mwlParameters, mppsWrapper);
  if (status != 0) {
    cout << "Unable to add (append) MWL entry based on MPPS item" << endl;
    return 1;
  }

  return 0;
}
