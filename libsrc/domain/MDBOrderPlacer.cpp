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
#include "MDBOrderPlacer.hpp"
#include "MPatient.hpp"
#include "MVisit.hpp"
#include "MPlacerOrder.hpp"
#include "MFillerOrder.hpp"

MDBOrderPlacer::MDBOrderPlacer() : mDBInterface(NULL)
{
}

MDBOrderPlacer::MDBOrderPlacer(const MDBOrderPlacer& cpy) : mDBInterface(cpy.mDBInterface)
{
}

MDBOrderPlacer::~MDBOrderPlacer()
{
  if (mDBInterface)
    delete mDBInterface;
}

void
MDBOrderPlacer::printOn(ostream& s) const
{
  s << "MDBOrderPlacer";
}

void
MDBOrderPlacer::streamIn(istream& s)
{
  //s >> this->member;
}

MDBOrderPlacer::MDBOrderPlacer(const MString& databaseName) :
  mDBInterface(0)
{
  if (databaseName != "")
    mDBInterface = new MDBInterface(databaseName);
}

int
MDBOrderPlacer::openDatabase(const MString& databaseName)
{
  if (mDBInterface)
    delete mDBInterface;

  if (databaseName != "")
    mDBInterface = new MDBInterface(databaseName);
  else
    mDBInterface = 0;

  return 0;
}

int
MDBOrderPlacer::admitRegisterPatient(const MPatient& patient,
				     const MVisit& visit)
{
  // first do sanity check
  if (!mDBInterface)
    return 1;

  if (patient.mapEmpty())
    return 0;

  if (recordExists(patient))
    updateRecord(patient);
  else
    addRecord(patient);

  if (visit.mapEmpty())
    return 0;

  if (recordExists(visit))
    updateRecord(visit);
  else
    addRecord(visit);

  return 1;
}

int
MDBOrderPlacer::preRegisterPatient(const MPatient& patient,
				     const MVisit& visit)
{
  return this->admitRegisterPatient(patient, visit);
}

int
MDBOrderPlacer::updateADTInfo(const MPatient& patient)
{
  // first do sanity check
  if (!mDBInterface)
    return 1;

  if (patient.mapEmpty())
    return 0;

  updateRecord(patient);

  return 1;
}

int
MDBOrderPlacer::updateADTInfo(const MPatient& patient, const MVisit& visit)
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

  return 1;
}

int
MDBOrderPlacer::transferPatient(const MVisit& visit)
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

  return 1;
}

int
MDBOrderPlacer::mergePatient(const MPatient& patient, const MString& issuer)
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

  MPlacerOrder placerOrder;
  placerOrder.patientID(patient.patientID());
  mDBInterface->update(placerOrder, cv, updateVector);

  MFillerOrder fillerOrder;
  fillerOrder.patientID(patient.patientID());
  mDBInterface->update(fillerOrder, cv, updateVector);

  // Then delete from patient table.
  mDBInterface->remove(patient, cv);

  // Add the patient if it does not already exist
  if (!recordExists(patient)) {
    addRecord(patient);
  }

  return 1;
}


int
MDBOrderPlacer::enterOrder(const MPlacerOrder& order)
{
  // first do sanity check
  if (!mDBInterface)
    return 1;

  if (order.mapEmpty())
    return 0;

  MPatient p;

  p.patientID(order.patientID());
  p.issuerOfPatientID(order.issuerOfPatientID());

  if (recordExists(p))
  {
    if (recordExists(order))
      updateRecord(order);
    else
      addOrder(order);
  }
  else
    return 0;

  return 1;
}

int
MDBOrderPlacer::enterOrder(const MFillerOrder& order)
{
  // first do sanity check
  if (!mDBInterface)
    return 1;

  if (order.mapEmpty())
    return 0;

  MPatient p;

  p.patientID(order.patientID());
  p.issuerOfPatientID(order.issuerOfPatientID());

  if (recordExists(p))
  {
    if (recordExists(order))
      updateRecord(order);
    else
      addOrder(order);
  }
  else
    return 0;

  return 1;
}

int
MDBOrderPlacer::updateOrder(const MPlacerOrder& order)
{
  // first do sanity check
  if (!mDBInterface)
    return 1;

  if (order.mapEmpty())
    return 0;

  MPatient p;

  p.patientID(order.patientID());
  p.issuerOfPatientID(order.issuerOfPatientID());

  if (recordExists(p)) {
    updateRecord(order);
    return 1;
  } else {
    return 0;
  }
}

int
MDBOrderPlacer::cancelOrder(const MPlacerOrder& order)
{
  //first do sanity check
  if (!mDBInterface)
    return 1;

  if (order.mapEmpty())
    return 0;

  deleteRecord(order);

  return 1;
}

int
MDBOrderPlacer::getOrder(MPatient& patient, MPlacerOrder& order)
{
  //first do sanity check
  if (!mDBInterface)
    return 1;

  if (order.mapEmpty())
    return 0;

  if (patient.mapEmpty())
  {
    // set patient ID and issuer in patient object from order object
    patient.patientID(order.patientID());
    patient.issuerOfPatientID(order.issuerOfPatientID());
  }
  else
  {
    if (patient.patientID() != order.patientID())
      return 0;
  }

  if (recordExists(patient))
  {
    MCriteriaVector cv;
    setCriteria(patient, cv);
    mDBInterface->select(patient, cv, NULL);
  }
  else
    return 0;

  if (recordExists(order))
  {
    MCriteriaVector cv;
    setCriteria(order, cv);
    mDBInterface->select(order, cv, NULL);
  }
  else
    return 0;

  // now get all the orders belonging to the order placer
  MOrder o;
  MCriteriaVector cv;
  
  // set criteria
  o.placerOrderNumber(order.placerOrderNumber());
  setCriteria(o, cv);

  int numOrders = mDBInterface->select(o, cv, placerOrderCallback, &order);
  // processPlacerOrder() function will be repeatedly called with order
  // domain object.  This function will insert each order found in the
  // placerOrder object

  if (numOrders != order.numOrders())
  {
    cout << "MDBOrderPlacer: Processing Error: " << endl;
    cout << "Number of Orders in the database: " << numOrders << endl;
    cout << "Number of Orders captured in the domain object: " \
         << order.numOrders() << endl;
  }

  return 1; 
}


MString
MDBOrderPlacer::newPlacerOrderNumber() const
{
  MString s;

  s = mIdentifier.mesaID(MIdentifier::MID_PLACERORDERNUMBER, *mDBInterface);

  return s;
}

#if 0
int
MDBOrderPlacer::newPlacerOrderNumber(MString& placerOrderNumber)
{
  //first do sanity check
  if (!mDBInterface)
    return 1;

  // get all the placer orders
  MPlacerOrder order;
  
  // extract entity ID (first component) from the placer order number
  char* poNum = placerOrderNumber.strData();
  char* applID = strchr(poNum, '^');
  char* entityID;
  if (applID)
  {
    entityID = new char[applID-poNum+1];
    memset(entityID, 0, applID-poNum+1);
    strncpy(entityID, poNum, applID-poNum);
    // if entity id is not a number, then cannot do it
    for (int i = 0; i < strlen(entityID); i++)
    {
      if (!isdigit(entityID[i]))
        return 0;
    }
  }
  else
  {
    entityID = new char[strlen(poNum)+1];
    strcpy(entityID, poNum);
  }

  long entityIDNum = atoi(entityID);

  mDBInterface->selectAll(order, newOrderCallback, &entityIDNum);

  // newOrderCallback() function will be repeatedly called with order
  // domain object.  This function will determine the new integer value of
  // the entity ID

  // entityIDNum is now the largest numeric entityID not found in the table
  char* tmpID = new char[strlen(entityID)+5];
  memset(tmpID, 0, sizeof(tmpID));

  sprintf(tmpID, "%d", entityIDNum);
  char* newID;
  if (applID)
  {
    newID = new char[strlen(entityID)+strlen(applID)+1];
    memset(newID, 0, sizeof(entityID));
  }
  else
  {
    newID = new char[strlen(entityID)+1];
    memset(newID, 0, sizeof(newID));
  }

  // fill in leading zeros
  for (int i = strlen(tmpID)-strlen(entityID); i > 0; i--)
    newID[i-1] = '0';

  strcat(newID, tmpID);

  placerOrderNumber = MString(newID);
  if (applID)
    placerOrderNumber += MString(applID);

  // cleanup
  delete [] poNum;
  delete [] entityID;
  delete [] tmpID;
  delete [] newID;

  return 1; 
}
#endif

// **********************************************************************************************
// FOLLOWING ARE PRIVATE FUNCTIONS ONLY MEANT TO BE USED BY THE CLASS MEMBER FUNCTIONS THEMSELVES
// **********************************************************************************************

int
MDBOrderPlacer::recordExists(const MPatient& patient)
{
  if (patient.mapEmpty())
    return 0;

  MPatient p;
  MCriteriaVector cv;

  setCriteria(patient, cv);

  return mDBInterface->select(p, cv, NULL);
}

int
MDBOrderPlacer::recordExists(const MVisit& visit)
{
  if (visit.mapEmpty())
    return 0;

  MVisit v;
  MCriteriaVector cv;

  setCriteria(visit, cv);

  return mDBInterface->select(v, cv, NULL);
}

int
MDBOrderPlacer::recordExists(const MPlacerOrder& order)
{
  if (order.mapEmpty())
    return 0;

  MPlacerOrder po;
  MCriteriaVector cv;
  
  setCriteria(order, cv);

  return mDBInterface->select(po, cv, NULL);
}

int
MDBOrderPlacer::recordExists(const MFillerOrder& order)
{
  if (order.mapEmpty())
    return 0;

  MFillerOrder fo;
  MCriteriaVector cv;
  
  setCriteria(order, cv);

  return mDBInterface->select(fo, cv, NULL);
}

int
MDBOrderPlacer::recordExists(const MOrder& order)
{
  if (order.mapEmpty())
    return 0;

  MOrder o;
  MCriteriaVector cv;
  
  setCriteria(order, cv);

  return mDBInterface->select(o, cv, NULL);
}

void
MDBOrderPlacer::addRecord(const MDomainObject& domainObject)
{
  mDBInterface->insert(domainObject);
}

void
MDBOrderPlacer::addOrder(const MPlacerOrder& order)
{
  MPlacerOrder localOrder(order);

  mDBInterface->insert(localOrder);

  for (int inx = 0; inx < localOrder.numOrders(); inx++)
    addRecord(localOrder.order(inx));
}

void
MDBOrderPlacer::addOrder(const MFillerOrder& order)
{
  mDBInterface->insert(order);

  for (int inx = 0; inx < order.numOrders(); inx++)
    addRecord(order.order(inx));
}

void
MDBOrderPlacer::deleteRecord(const MPatient& patient)
{
  MCriteriaVector cv;

  setCriteria(patient, cv);
  mDBInterface->remove(patient, cv);
}

void
MDBOrderPlacer::deleteRecord(const MVisit& visit)
{
  MCriteriaVector cv;

  setCriteria(visit, cv);
  mDBInterface->remove(visit, cv);
}

void
MDBOrderPlacer::deleteRecord(const MPlacerOrder& order)
{
  MCriteriaVector cv;
  MPlacerOrder localOrder(order);

  setCriteria(localOrder, cv);
  mDBInterface->remove(localOrder, cv);

  for (int inx = 0; inx < localOrder.numOrders(); inx++)
    deleteRecord(localOrder.order(inx));
}

void
MDBOrderPlacer::deleteRecord(const MFillerOrder& order)
{
  MCriteriaVector cv;

  setCriteria(order, cv);
  mDBInterface->remove(order, cv);

  for (int inx = 0; inx < order.numOrders(); inx++)
    deleteRecord(order.order(inx));
}

void
MDBOrderPlacer::deleteRecord(const MOrder& order)
{
  MCriteriaVector cv;

  setCriteria(order, cv);
  mDBInterface->remove(order, cv);
}

void
MDBOrderPlacer::updateRecord(const MPatient& patient)
{
  MCriteriaVector cv;
  MUpdateVector   uv;

  setCriteria(patient, cv);
  setCriteria(patient, uv);

  mDBInterface->update(patient, cv, uv);
}

void
MDBOrderPlacer::updateRecord(const MVisit& visit)
{
  MCriteriaVector cv;
  MUpdateVector   uv;

  setCriteria(visit, cv);
  setCriteria(visit, uv);

  mDBInterface->update(visit, cv, uv);
}

void
MDBOrderPlacer::updateRecord(const MPlacerOrder& order)
{
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
MDBOrderPlacer::updateRecord(const MFillerOrder& order)
{
  MCriteriaVector cv;
  MUpdateVector   uv;

  setCriteria(order, cv);
  setCriteria(order, uv);

  mDBInterface->update(order, cv, uv);

  for (int inx = 0; inx < order.numOrders(); inx++)
    updateRecord(order.order(inx));
}

void
MDBOrderPlacer::updateRecord(const MOrder& order)
{
  MCriteriaVector cv;
  MUpdateVector   uv;

  setCriteria(order, cv);
  setCriteria(order, uv);

  mDBInterface->update(order, cv, uv);
}

void
MDBOrderPlacer::setCriteria(const MPatient& patient, MCriteriaVector& cv)
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
MDBOrderPlacer::setCriteria(const MVisit& visit, MCriteriaVector& cv)
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
MDBOrderPlacer::setCriteria(const MPlacerOrder& order, MCriteriaVector& cv)
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

  MString issuer(order.issuerOfPatientID());

  if (issuer.size())
  {
    c.attribute = "issuer";
    c.oper      = TBL_EQUAL;
    c.value     = order.issuerOfPatientID();
    cv.push_back(c);
  }

  c.attribute = "plaordnum";
  c.oper      = TBL_EQUAL;
  c.value     = order.placerOrderNumber();
  cv.push_back(c);

}

void
MDBOrderPlacer::setCriteria(const MFillerOrder& order, MCriteriaVector& cv)
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

  MString issuer(order.issuerOfPatientID());

  if (issuer.size())
  {
    c.attribute = "issuer";
    c.oper      = TBL_EQUAL;
    c.value     = order.issuerOfPatientID();
    cv.push_back(c);
  }

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
MDBOrderPlacer::setCriteria(const MOrder& order, MCriteriaVector& cv)
{
  MCriteria c;
  
  c.attribute = "plaordnum";
  c.oper      = TBL_EQUAL;
  c.value     = order.placerOrderNumber();
  cv.push_back(c);

  MString foNum(order.fillerOrderNumber());

  if (foNum.size())
  {
    c.attribute = "filordnum";
    c.oper      = TBL_EQUAL;
    c.value     = order.fillerOrderNumber();
    cv.push_back(c);
  }

  /* may be Universal Service ID also
  c.attribute = "uniserid";
  c.oper      = TBL_EQUAL;
  c.value     = order.universalServiceID();
  cv.push_back(c);
    */
}

void
MDBOrderPlacer::setCriteria(const MDomainObject& domainObject, MUpdateVector& uv)
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

static void
placerOrderCallback(MDomainObject& o, void* ctx)
{
  MOrder ord;

  ord.import(o);
  MPlacerOrder* po = (MPlacerOrder*)ctx;
  if (po)
    po->add(ord);
}

static void
newOrderCallback(MDomainObject& o, void* ctx)
{
  MPlacerOrder order;

  order.import(o);
  long* newEntityID = (long*)ctx;

  MString placerOrderNumber = order.placerOrderNumber();
  char* poNum = placerOrderNumber.strData();
  char* applID = strchr(poNum, '^');
  char* entityID = new char[applID-poNum+1];
  memset(entityID, 0, applID-poNum+1);
  strncpy(entityID, poNum, applID-poNum);
  // if entity id is not a number, then cannot do comparison
  for (int i = 0; i < strlen(entityID); i++)
  {
    if (!isdigit(entityID[i]))
      return;
  }
  long entityIDNum = atoi(entityID);

  if (entityIDNum >= *newEntityID)
    *newEntityID = entityIDNum + 1;
}


MString
MDBOrderPlacer::newPatientID() const
{
  MString s;

  s = mIdentifier.mesaID(MIdentifier::MID_PATIENT, *mDBInterface);

  return s;
}
