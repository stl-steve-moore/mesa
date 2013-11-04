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
#include "MHL7DomainXlate.hpp"

#include "MHL7Msg.hpp"
#include "MDomainObject.hpp"
#include "MPatient.hpp"
#include "MVisit.hpp"
#include "MPlacerOrder.hpp"
#include "MFillerOrder.hpp"
#include "MOrder.hpp"
#include "MLogClient.hpp"

MHL7DomainXlate::MHL7DomainXlate() :
 mIssuer1("XXX"),
 mIssuer2("XXX")
{
}

MHL7DomainXlate::MHL7DomainXlate(const MHL7DomainXlate& cpy) :
 mIssuer1(cpy.mIssuer1),
 mIssuer2(cpy.mIssuer2)
{
}

MHL7DomainXlate::~MHL7DomainXlate()
{
}

void
MHL7DomainXlate::printOn(ostream& s) const
{
  s << "MHL7DomainXlate";
}

void
MHL7DomainXlate::streamIn(istream& s)
{
  //s >> this->member;
}

// Non-boilerplate methods to follow




int
MHL7DomainXlate::translateHL7(MHL7Msg& hl7, MPatient& patient) const
{
  HL7_MAP m[] = {
    { "patid",  "PID",  3, 1 },
    { "issuer", "PID",  3, 4 },
    { "identifier_type", "PID",  3, 5 },
//    { "patid2",  "PID",  3, 1 },
//    { "issuer2", "PID",  3, 4 },
    { "nam",     "PID",  5, 0 },
    { "datbir",     "PID",  7, 0 },
    { "sex",     "PID",  8, 0 },
    { "patrac",    "PID",  10, 0 },
    { "addr",    "PID",  11, 0 },
    { "pataccnum", "PID", 18, 1 },
    { "prioridlist", "MRG", 1, 0},
    { "", "", 0,0 }
  };
  HL7_MAP m1[] = {
    { "patid",  "PID",  3, 0 },
    { "", "", 0,0 }
  };

  MDomainObject domainObject;

  // Extract standard attributes
  this->translateHL7(hl7, m, domainObject);
  patient.import(domainObject);
  MString s = patient.dateOfBirth();
  patient.dateOfBirth(s.subString(0, 8));

#if 0
  // Pull patient ID out of the Patient ID list
  this->translateHL7(hl7, m1, domainObject);
  MString patientIDList = domainObject.value("patid");
  this->setPatientIDAttributes(patientIDList, patient);
#endif

#if 0
  if (patient.patientID() == "") {
    MString s;
    s = patient.patientID2();
    patient.patientID(s);
    s = patient.issuerOfPatientID2();
    patient.issuerOfPatientID(s);
  }
#endif

  return 0;
}

int
MHL7DomainXlate::translateDomain(const MPatient& patient, MHL7Msg& hl7)
{
  HL7_MAP m[] = {
    { "patid",  "PID",  2, 1 },
    { "issuer", "PID",  2, 4 },
    { "patid2",  "PID",  3, 1 },
    { "issuer2", "PID",  3, 4 },
    { "nam",     "PID",  5, 0 },
    { "datbir",     "PID",  7, 0 },
    { "sex",     "PID",  8, 0 },
    { "patrac",    "PID",  10, 0 },
    { "addr",    "PID",  11, 0 },
    { "pataccnum", "PID", 18, 1 },
    { "", "", 0,0 }
  };

  this->translateDomain(hl7, m, patient);

  return 0;
}

int
MHL7DomainXlate::translatePDQQPD3(const MString& s, MPatient& patient) const
{
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_VERBOSE,
	"","MHL7DomainXlate::translatepdQQPD3",
	__LINE__, "Enter method");
  MString queryString = s;
  int idx = 0;
  MString firstName = "";
  MString lastName = "";
  MString patientID = "";
  MString dateOfBirth = "";

  while (queryString.tokenExists('~', idx)) {
    MString x = queryString.getToken('~', idx);
//    cout << idx << ":" << x << endl;
    logClient.logTimeStamp(MLogClient::MLOG_VERBOSE,
	MString("Next token from query: ") + x);
    MString headerCharacter = x.subString(0, 1);
    if (headerCharacter != "@") {
      continue;
    }
    MString x1 = x.subString(1, 0);
    if (!x1.tokenExists('^', 1)) {
      continue;
    }
    MString fieldName = x1.getToken('^', 0);
    MString fieldValue= x1.getToken('^', 1);
    MString debugString = MString("Field Name: ") + fieldName
	+ " Field Value: " + fieldValue;

    logClient.logTimeStamp(MLogClient::MLOG_VERBOSE, debugString);
//    cout << "Field Name:  " << fieldName << endl;
//    cout << "Field Value: " << fieldValue << endl;
    idx++;
    if (fieldName == "PID.5.1.1") {
      lastName = fieldValue;
    } else if (fieldName == "PID.5.2") {
      firstName = fieldValue;
    } else if (fieldName == "PID.3.1") {
      patientID = fieldValue;
    } else if (fieldName == "PID.7.1") {
      dateOfBirth = fieldValue;
    }
  }
  if (lastName == "" && firstName == "") {
  } else if (firstName == "") {
    patient.patientName(lastName + MString("%"));
  } else if (lastName == "") {
    patient.patientName(MString("%^") + firstName);
  } else {
    patient.patientName(lastName + MString("%^") + firstName + MString("%"));
  }
  patient.patientID(patientID);
  patient.dateOfBirth(dateOfBirth);
  logClient.log(MLogClient::MLOG_VERBOSE,
	"","MHL7DomainXlate::translatepdQQPD3",
	__LINE__, "Exit method");
  return 0;
}

int
MHL7DomainXlate::translateHL7(MHL7Msg& hl7, MVisit& visit) const
{
  HL7_MAP m[] = {
    { "visnum",  "PV1",  19, 1 },
    { "patid",  "PID",  3, 1 },
    { "issuer", "PID",  3, 4 },
    { "patcla", "PV1",  2, 0 },
    { "asspatloc",  "PV1",  3, 0 },
    { "attdoc",     "PV1",  7, 0 },
    { "ambsta",     "PV1",  15, 0 },
    { "admdat",     "PV1",  44, 0 },
    { "admtim",     "PV1",  44, 0 },
    { "admdoc",     "PV1",  17, 0 },
    { "refdoc",     "PV1",   8, 0 },
    { "", "", 0,0 }
  };
  HL7_MAP m1[] = {
    { "patid",  "PID",  3, 0 },
    { "", "", 0,0 }
  };
  MDomainObject domainObject;

  this->translateHL7(hl7, m, domainObject);
  MString s = domainObject.value("admdat");
  domainObject.insert("admdat", s.subString(0, 8));
  domainObject.insert("admtim", s.subString(8, 8));

  visit.import(domainObject);

#if 0
  // Pull patient ID out of the Patient ID list
  this->translateHL7(hl7, m1, domainObject);
  MString patientIDList = domainObject.value("patid");
  MPatient patient;
  this->setPatientIDAttributes(patientIDList, patient);
  visit.patientID(patient.patientID());
  visit.issuerOfPatientID(patient.issuerOfPatientID());
#endif

  return 0;
}

int
MHL7DomainXlate::translateDomain(MHL7Msg& hl7, const MVisit& visit)
{
  HL7_MAP m[] = {
    { "visnum",  "PV1",  19, 1 },
    { "patid",  "PID",  2, 1 },
    { "issuer", "PID",  2, 4 },
    { "patcla", "PV1",  2, 0 },
    { "asspatloc",  "PV1",  3, 0 },
    { "attdoc",     "PV1",  7, 0 },
    { "ambsta",     "PV1",  15, 0 },
    { "admdat",     "PV1",  44, 0 },
    { "admtim",     "PV1",  44, 0 },
    { "", "", 0,0 }
  };

  this->translateDomain(hl7, m, visit);

  return 0;
}

int
MHL7DomainXlate::translateHL7(MHL7Msg& hl7, MPlacerOrder& placerOrder) const
{
  HL7_MAP m[] = {
    { "plaordnum",  "ORC",  2, 0 },
    { "filordnum", "ORC", 3, 0 },
    { "patid",  "PID",  3, 1 },
    { "issuer", "PID",  3, 4 },
    { "", "", 0,0 }
  };
  HL7_MAP m1[] = {
    { "patid",  "PID",  3, 0 },
    { "", "", 0,0 }
  };

  MDomainObject domainObject;

  this->translateHL7(hl7, m, domainObject);
  placerOrder.import(domainObject);

#if 0
  // Pull patient ID out of the Patient ID list
  this->translateHL7(hl7, m1, domainObject);
  MString patientIDList = domainObject.value("patid");
  MPatient patient;
  this->setPatientIDAttributes(patientIDList, patient);
  placerOrder.patientID(patient.patientID());
  placerOrder.issuerOfPatientID(patient.issuerOfPatientID());
#endif

  MString s = hl7.firstSegment();
  int numberOrders = 0;
  while (s != "") {
    if (s == "ORC")
      numberOrders++;

    s = hl7.nextSegment();
  }

  int index = 1;
  for (; index <= numberOrders; index++) {
    MOrder order;
    this->translateHL7(hl7, index, order);
    placerOrder.add(order);
  }

  return 0;
}

int
MHL7DomainXlate::translateDomain(MHL7Msg& hl7, const MPlacerOrder& placerOrder)
{
  HL7_MAP m[] = {
    { "plaordnum",  "ORC",  2, 0 },
    { "filordnum", "ORC", 3, 0 },
    { "patid",  "PID",  2, 1 },
    { "issuer", "PID",  2, 4 },
    { "", "", 0,0 }
  };

  this->translateDomain(hl7, m, placerOrder);

  int numberOrders = placerOrder.numOrders();

  for (int index = 1; index <= numberOrders; index++)
  {
    MPlacerOrder po(placerOrder);
    this->translateDomain(hl7, index, po.order(index-1));
  }

  return 0;
}

int
MHL7DomainXlate::translateHL7(MHL7Msg& hl7, MFillerOrder& fillerOrder) const
{
  HL7_MAP m[] = {
    { "plaordnum",  "ORC",  2, 0 },
    { "filordnum", "ORC", 3, 0 },
    { "accnum", "ORC", 3, 0 },
    { "patid",  "PID",  2, 1 },
    { "issuer", "PID",  2, 4 },
    { "", "", 0,0 }
  };

  MDomainObject domainObject;

  this->translateHL7(hl7, m, domainObject);
  fillerOrder.import(domainObject);

  MString s = hl7.firstSegment();
  int numberOrders = 0;
  while (s != "") {
    if (s == "ORC")
      numberOrders++;

    s = hl7.nextSegment();
  }

  int index = 1;
  for (; index <= numberOrders; index++) {
    MOrder order;
    this->translateHL7(hl7, index, order);
    fillerOrder.add(order);
  }

  return 0;
}

int
MHL7DomainXlate::translateDomain(MHL7Msg& hl7, const MFillerOrder& fillerOrder)
{
  HL7_MAP m[] = {
    { "plaordnum",  "ORC",  2, 0 },
    { "filordnum", "ORC", 3, 0 },
    { "accnum", "ORC", 3, 0 },
    { "patid",  "PID",  2, 1 },
    { "issuer", "PID",  2, 4 },
    { "", "", 0,0 }
  };

  this->translateDomain(hl7, m, fillerOrder);

  int numberOrders = fillerOrder.numOrders();

  for (int index = 1; index <= numberOrders; index++)
  {
    MFillerOrder fo(fillerOrder);
    this->translateDomain(hl7, index, fo.order(index-1));
  }

  return 0;
}

int
MHL7DomainXlate::translateHL7(MHL7Msg& hl7, MOrder& order) const
{
  HL7_MAP* m;

  orderMap(&m);
  MDomainObject domainObject;

  this->translateHL7(hl7, m, domainObject);
  order.import(domainObject);

  return 0;
}

int
MHL7DomainXlate::translateHL7(MHL7Msg& hl7, int index, MOrder& order) const
{
  HL7_MAP* m;

  orderMap(&m);
  MDomainObject domainObject;

  this->translateHL7(hl7, index, m, domainObject);
  order.import(domainObject);

  return 0;
}

int
MHL7DomainXlate::translateDomain(MHL7Msg& hl7, const MOrder& order)
{
  HL7_MAP* m;

  orderMap(&m);
  this->translateDomain(hl7, m, order);

  return 0;
}

int
MHL7DomainXlate::translateDomain(MHL7Msg& hl7, int index, const MOrder& order)
{
  HL7_MAP* m;

  orderMap(&m);
  this->translateDomain(hl7, index, m, order);

  return 0;
}

int
MHL7DomainXlate::translateHL7(MHL7Msg& hl7, HL7_MAP* m,
			      MDomainObject& o) const
{
  MString key;

  for (key = m->attribute; key != ""; key = (++m)->attribute) {
    MString v;
    v = hl7.getValue(m->segment,
		     m->field,
		     m->component);
    o.insert(key, v);
    //cout << key << ":" << v << endl;
  }
  return 0;
}

int
MHL7DomainXlate::translateHL7(MHL7Msg& hl7, int index, HL7_MAP* m,
			      MDomainObject& o) const
{
  MString key;

  for (key = m->attribute; key != ""; key = (++m)->attribute) {
    MString v;
    v = hl7.getValue(index,
		     m->segment,
		     m->field,
		     m->component);
    o.insert(key, v);
    //cout << key << ":" << v << endl;
  }
  return 0;
}

int
MHL7DomainXlate::translateDomain(MHL7Msg& hl7, HL7_MAP* m,
			         const MDomainObject& o)
{
  MString key;

  for (key = m->attribute; key != ""; key = (++m)->attribute) {
    MString v = o.value(key);
    char* val = v.strData(); 
    hl7.setValue(m->segment,
     		 m->field,
		 m->component,
                 val);
    delete [] val;
  }
  return 0;
}

int
MHL7DomainXlate::translateDomain(MHL7Msg& hl7, int index, HL7_MAP* m,
			         const MDomainObject& o)
{
  MString key;

  for (key = m->attribute; key != ""; key = (++m)->attribute) {
    MString v = o.value(key);
    char* val = v.strData(); 
    hl7.setValue(index,
	     	 m->segment,
		 m->field,
		 m->component,
                 val);
    delete [] val;
  }
  return 0;
}

void
MHL7DomainXlate::issuer1(const MString& issuer)
{
  mIssuer1 = issuer;
}

void
MHL7DomainXlate::issuer2(const MString& issuer)
{
  mIssuer2 = issuer;
}


void
MHL7DomainXlate::orderMap(HL7_MAP** mapArg) const
{
  static HL7_MAP m[] = {
    { "plaordnum",  "ORC",  2, 0 },
    { "filordnum", "ORC", 3, 0 },
    { "visnum", "PV1", 19, 0},
    { "ordcon", "ORC", 1, 0 },
    { "plagronum", "ORC", 4, 0 },
    { "ordsta", "ORC", 5, 0 },
    { "quatim", "ORC", 7, 0 },
    { "par", "ORC", 8, 0 },
    { "dattimtra", "ORC", 9, 0 },
    { "entby", "ORC", 10, 0 },
    { "ordpro", "ORC", 12, 0 },
    { "refdoc", "PV1", 8, 0 },
    { "ordeffdattim","ORC", 15, 0 },
    { "entorg", "ORC", 17, 0 },
    { "uniserid", "OBR", 4, 0 },
    { "spesou", "OBR", 15, 0 },
    { "ordcalphonum", "OBR", 17, 0 },
    { "traarrres", "OBR", 40, 0 },
    { "reaforstu", "OBR", 31, 0 },
    { "obsval", "OBX", 5, 0 },
    { "dancod", "OBR", 12, 0 },
    { "relcliinf", "OBR", 13, 0 },
    { "", "", 0,0 }
  };

  *mapArg = m;
}

#if 0
int
MHL7DomainXlate::setPatientIDAttributes(const MString& patientIDList,
					MPatient& patient) const
{
  MString s1;

  s1 = this->getPatientID(patientIDList, mIssuer1);

  patient.patientID(s1);
  patient.issuerOfPatientID(mIssuer1);

  s1 = this->getPatientID(patientIDList, mIssuer2);

  patient.patientID2(s1);
  patient.issuerOfPatientID2(mIssuer2);

  return 0;
}
#endif

#if 0
MString
MHL7DomainXlate::getPatientID(MString s, const MString& issuer) const
{
  int index = 0;

  for (index = 0; ; index++) {
    if (s.tokenExists('~', index)) {
      MString x = s.getToken('~', index);
      MString y = x.getToken('^', 3);
      if (issuer == y) {
	MString z = x.getToken('^', 0);
	return z;
      }
    } else {
      cerr << "Could not find patient ID for issuer: " << issuer << endl;
      return "";
    }
  }
}
#endif
