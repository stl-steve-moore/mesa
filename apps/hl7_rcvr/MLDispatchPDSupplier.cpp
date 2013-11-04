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

#include "ctn_os.h"
#include <strstream>

#include "MESA.hpp"
#include "MHL7ProtocolHandlerLLP.hpp"
#include "MLDispatchPDSupplier.hpp"
#include "MHL7Factory.hpp"
#include "MHL7Msg.hpp"
#include "MHL7DomainXlate.hpp"

#include "MPatient.hpp"
#include "MVisit.hpp"
#include "MPlacerOrder.hpp"
#include "MFillerOrder.hpp"
#include "MDBPDSupplier.hpp"
#include "MLogClient.hpp"
#include "MFileOperations.hpp"

extern int gMsgNumber;

#if 0
MLDispatchPDSupplier::MLDispatchPDSupplier()
{
}
#endif

MLDispatchPDSupplier::MLDispatchPDSupplier(const MLDispatchPDSupplier& cpy) :
  MHL7Dispatcher(cpy.mFactory),
  mDatabase(cpy.mDatabase),
  mAnalysisMode(cpy.mAnalysisMode),
  mLogDir(cpy.mLogDir),
  mStorageDir(cpy.mStorageDir),
  mShutdownFlag(cpy.mShutdownFlag)
{
}

MLDispatchPDSupplier::~MLDispatchPDSupplier ()
{
}

void
MLDispatchPDSupplier::printOn(ostream& s) const
{
  s << "MLDispatchPDSupplier" << endl;
}

void
MLDispatchPDSupplier::streamIn(istream& s)
{
  //s >> this->member;
}

// Non-boiler plate methods follow below

MLDispatchPDSupplier::MLDispatchPDSupplier(MHL7Factory& factory, MDBPDSupplier* database,
			 const MString& logDir, const MString& storageDir,
			 bool analysisMode, int& shutdownFlag) :
  MHL7Dispatcher(factory),
  mDatabase(database),
  mLogDir(logDir),
  mStorageDir(storageDir),
  mAnalysisMode(analysisMode),
  mShutdownFlag(shutdownFlag)
{
}

// virtual
int
MLDispatchPDSupplier::acceptACK(MHL7Msg& message, const MString& event)
{
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_CONVERSATION,
		"peer",
		"MLDispatchPDSupplier::acceptACK",
		__LINE__,
		MString("Accepting ACK event ")+event);

  MHL7Msg* rsp = mFactory.produceRSPK22Baseline(message);

  bool done = false;
  MPatientVector::iterator p = mPatientVector.begin();

  while (!mPatientVector.empty() && !done) {
    MStringMap m;
    p = mPatientVector.begin();
    MString x = (*p).patientID() + "^^^" + (*p).issuerOfPatientID();
    if ((*p).identifierType() != "") {
      x += "^" + (*p).identifierType();
    }
    m["pid3"] = x;
    m["pid5"] = (*p).patientName();
    m["pid7"] = (*p).dateOfBirth();
    m["pid8"] = (*p).patientSex();
    m["pid11"] = (*p).address();
    mFactory.appendRSPK22PatientIdentification(*rsp, m);
    mPatientVector.erase(p);
    if (1) {
      char buf[32];
      strstream s (buf, sizeof(buf));
      s << mContinuationCounter << '\0';
      mContinuationCounter++;
      if (!mPatientVector.empty() ) {
	mFactory.appendContinuationText(*rsp, buf);
      }
      mHandler->sendHL7Message(*rsp);
      delete rsp;
      done = true;
    }
  }

  return 0;  
}


// virtual
int
MLDispatchPDSupplier::acceptADT(MHL7Msg& message, const MString& event)
{
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_CONVERSATION,
		"peer",
		"MLDispatchPDSupplier::acceptADT",
		__LINE__,
		MString("Accepting ADT event ")+event);

  MHL7DomainXlate xLate;
  MPatient patient;
  MVisit   visit;

  xLate.issuer1("ADT1");
  xLate.issuer2("OP1");
  xLate.translateHL7(message, patient);
  xLate.translateHL7(message, visit);

  MString patientString = patient.patientID() + ":" +
		patient.issuerOfPatientID() + ":" +
		patient.patientName();
  logClient.log(MLogClient::MLOG_VERBOSE,
		"peer",
		"MLDispatchPDSupplier::acceptADT",
		__LINE__,
		MString("Patient is: ")+patientString);

  processInfo( event, patient, visit);


  // Let the base class see the ADT; it will generate the ACK
  MHL7Dispatcher::acceptADT(message, event);

  return 0;  
}

//virtual
int
MLDispatchPDSupplier::acceptXXX(MHL7Msg& message, const MString& event)
{
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_CONVERSATION,
		"peer",
		"MLDispatchPDSupplier::acceptXXX",
		__LINE__,
		MString("Accepting XXX event ")+event);

  // Let the base class see the XXX; it will generate the ACK
  MHL7Dispatcher::acceptXXX(message, event);

  if (event == "KIL")
    mShutdownFlag = 1;
  else if (event == "RST") {
    gMsgNumber = 1000;
    this->clearExistingMessages();
  }
  return 0;
}

//virtual
int
MLDispatchPDSupplier::acceptQBP(MHL7Msg& message, const MString& event)
{
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_CONVERSATION,
		"peer",
		"MLDispatchPDSupplier::acceptQBP",
		__LINE__,
		MString("Accepting QBP event ")+event);

  if (event == "Q22") {
    return this->acceptQBPQ22(message, event);
  }

  MString queryName	= message.getValue("QPD", 1, 0);
  MString queryTag	= message.getValue("QPD", 2, 0);
  MString personID	= message.getValue("QPD", 3, 1);
  MString personIDIssuer= message.getValue("QPD", 3, 4);
  logClient.logTimeStamp(MLogClient::MLOG_ERROR, "PD Supplier: Query Parameters from inbound query");
  logClient.logTimeStamp(MLogClient::MLOG_ERROR, "Event:      " + event);
  logClient.logTimeStamp(MLogClient::MLOG_ERROR, "Query Name: " + queryName);
  logClient.logTimeStamp(MLogClient::MLOG_ERROR, "Query Tag:  " + queryTag);
  logClient.logTimeStamp(MLogClient::MLOG_ERROR, "Person ID:  " + personID);
  logClient.logTimeStamp(MLogClient::MLOG_ERROR, "PID Issuer: " + personIDIssuer);
  logClient.logTimeStamp(MLogClient::MLOG_ERROR, "Kill server, unrecognized query");
  ::exit(1);

  // We will never get here, but this satisfies the compiler.
  return 0;
}

// Private methods begin here
int
MLDispatchPDSupplier::acceptQBPQ22(MHL7Msg& message, const MString& event)
{
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_CONVERSATION,
		"peer",
		"MLDispatchPDSupplier::acceptQBPQ22",
		__LINE__,
		MString("Accepting QBP event ")+event);

  logClient.logTimeStamp(MLogClient::MLOG_CONVERSATION,
	"Storing query in file: " + mStorageDir + "/query.hl7");

  message.saveAs(mStorageDir + "/query.hl7");
  MString queryName = message.getValue("QPD", 1, 0);
  MString queryTag  = message.getValue("QPD", 2, 0);
  MString demographicsQuery  = message.getValue("QPD", 3, 0);
  MString quantityLimitedRequest = message.getValue("RCP", 2, 1);
  MString q = message.getValue("RCP", 2, 0);
  if (quantityLimitedRequest == "") {
    mResponseLimit = 1000;
  } else {
    mResponseLimit = quantityLimitedRequest.intData();
  }
  MString continuationPointer = "";
  MString s = message.firstSegment();
  while (s != "" && continuationPointer == "") {
    if (s == "DSC") {
      continuationPointer = message.getValue(1, 0);
    } else {
      s = message.nextSegment();
    }
  }
  logClient.logTimeStamp(MLogClient::MLOG_CONVERSATION,
	MString("Continuation pointer in query: <") + continuationPointer + ">");

  int status = 0;

  if (continuationPointer == "") {	// This is an original query
    mContinuationCounter = 1000;

//  cout << "Q: " << q << ":" << quantityLimitedRequest << ":" << mContinuationCounter << endl;

    logClient.logTimeStamp(MLogClient::MLOG_VERBOSE, "Query Name:  " + queryName);
    logClient.logTimeStamp(MLogClient::MLOG_VERBOSE, "Query Tag:   " + queryTag);
    logClient.logTimeStamp(MLogClient::MLOG_VERBOSE, "Demog Query: " + demographicsQuery);

    MPatient patient;
    MHL7DomainXlate xLate;

    status = xLate.translatePDQQPD3(demographicsQuery, patient);
    //cout << patient << endl;

    this->clearPatientVector();
    status = mDatabase->demographicsQueryLookup(mPatientVector, patient);
  } else {
    logClient.logTimeStamp(MLogClient::MLOG_VERBOSE, MString("Server received a continuation pointer, so we will pick up the query response from that point: ") + continuationPointer);
    int recvdContinuationPtr = continuationPointer.intData();
    if (recvdContinuationPtr != (mContinuationCounter - 1)) {
      char tmp[1024];
      strstream z(tmp, sizeof(tmp));
      z << "Continuation pointer sent by peer (" << continuationPointer << ")"
	<< " is not the expected value by this system ("
	<< mContinuationCounter - 1 << ")" << '\0';
      logClient.logTimeStamp(MLogClient::MLOG_ERROR, tmp);
      ::exit(1);
      // The exit is pretty drastic, but it will force the peer to investigate.
    }
  }

  MPatientVector::iterator p = mPatientVector.begin();
// Moore 2005.09.15 Remove debug output
//  for (; p != mPatientVector.end(); p++) {
//    MString patientName = (*p).patientName();
//    cout << "Patient Name: " << patientName << endl;
//  }

// Moore 2005.09.15 Remove the intermediate ACK message
// This is per changes in the ITI TF, Version 2. 15-Aug-2005.
//  MHL7Msg* ack = mFactory.produceACK(message);
//  mHandler->sendHL7Message(*ack);
//  delete ack;


  MHL7Msg* rsp = mFactory.produceRSPK22Baseline(message);
  if (mPatientVector.empty()) {
    rsp->setValue("QAK", 2, 0, "NF");
    mHandler->sendHL7Message(*rsp);
    delete rsp;
    return 0;
  }

  bool done = false;
  int responseCount = 1;
  rsp->setValue("QAK", 2, 0, "OK");
  while (!mPatientVector.empty() && !done) {
    MStringMap m;
    p = mPatientVector.begin();
    MString patientText = MString("Next patient in the PDQ response: ") + (*p).patientID() + ":" + (*p).patientName();
    logClient.logTimeStamp(MLogClient::MLOG_VERBOSE, patientText);
    MString x = (*p).patientID() + "^^^" + (*p).issuerOfPatientID();
    if ((*p).identifierType() != "") {
      x += "^" + (*p).identifierType();
    }
    m["pid3"] = x;
    m["pid5"] = (*p).patientName();
    m["pid7"] = (*p).dateOfBirth();
    m["pid8"] = (*p).patientSex();
    m["pid11"] = (*p).address();
    mFactory.appendRSPK22PatientIdentification(*rsp, m);
    mPatientVector.erase(p);
    if (responseCount >= mResponseLimit) {
      char buf[32];
      strstream s (buf, sizeof(buf));
      s << mContinuationCounter << '\0';
      mContinuationCounter++;
      if (!mPatientVector.empty() ) {
	mFactory.appendContinuationText(*rsp, buf);
      }
      mHandler->sendHL7Message(*rsp);
      delete rsp;
      rsp = 0;
      done = true;
    }
    responseCount++;
  }
  // Check to see if the response count triggered a response
  // by exceeding the response limit set by the client. If not,
  // then we owe them that response now.

  if (!done) {
    char buf[32];
    strstream s (buf, sizeof(buf));
    s << mContinuationCounter << '\0';
    mContinuationCounter++;
    if (!mPatientVector.empty() ) {
      mFactory.appendContinuationText(*rsp, buf);
    }
    mHandler->sendHL7Message(*rsp);
    delete rsp;
    rsp = 0;
    done = true;
  }

//  Debug information we don't need for production.
//  p = mPatientVector.begin();
//  for (; p != mPatientVector.end(); p++) {
//    MString patientName = (*p).patientName();
//    cout << ">>Patient Name: " << patientName << endl;
//  }

#if 0
  if (status == 2) {		// We did not recognize the domain
    this->updateRSPMessageUnknownIssuer(rsp);
  } else {
    this->updateRSPMessage(rsp, personID, personIDIssuer, v);
  }
#endif

  return status;
}


void
MLDispatchPDSupplier::logHL7Stream(const char* txt, int len)
{
  if (mAnalysisMode) {
    char storageDir[1024];
    char storageFile[1024];
    mStorageDir.safeExport(storageDir, sizeof(storageDir));
    sprintf(storageFile, "%s/%d.hl7", storageDir, ++gMsgNumber);
    {
      MLogClient logClient;
      char x[512];
      sprintf(x, "Writing input HL7 Stream of length %d to: %s",
		len, storageFile);
      logClient.log(MLogClient::MLOG_VERBOSE,
		    "peer",
		    "MLDispatchPDSupplier::logHL7Stream", __LINE__, x);
    }
    ofstream f(storageFile, ios::out | ios::binary);
    f.write(txt, len);
  }
}


void
MLDispatchPDSupplier::processInfo(const MString& event, const MPatient& patient,
			 const MVisit& visit)
{
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_VERBOSE,
		"peer",
		"MLDispatchPDSupplier::processInfo",
		__LINE__,
		MString("Processing ADT event ")+event);

  if (event == "A01") 
    mDatabase->admitRegisterPatient(patient, visit);
  else if (event == "A02")
    mDatabase->transferPatient(visit);
  else if (event == "A04")
    mDatabase->admitRegisterPatient(patient, visit);
  else if (event == "A05")
    mDatabase->preRegisterPatient(patient, visit);
  else if (event == "A08")
    mDatabase->updateADTInfo(patient);
  else if (event == "A40")
    mDatabase->mergePatient(patient, "ADT1");
  else
    processError("ADT", event, "");
}

void
MLDispatchPDSupplier::processError(const MString& msgType, const MString& event, const MString& additionalInfo)
{
  MString error("(Messenger) Unknown Values HL7 Message \nMessage Type: "+msgType+" Trigger Event: "+event+" "+additionalInfo);

  MLogClient logClient;
  logClient.log(MLogClient::MLOG_VERBOSE,
		"",
		"MLDispatchPDSupplier::processError",
		__LINE__,
		error);
}

void
MLDispatchPDSupplier::clearExistingMessages()
{
  MFileOperations f;

  int rslt = f.scanDirectory(mStorageDir);
  if (rslt != 0)
    return;

  int count = f.filesInDirectory();
  int idx = 0;
  MLogClient logClient;

  char txt[512], dirName[512];
  mStorageDir.safeExport(dirName, sizeof(dirName));

  ::sprintf(txt, "Deleting files in directory: %s", dirName);
  logClient.log(MLogClient::MLOG_VERBOSE,
		"peer",
		"MLDispatchPDSupplier::clearMessages", __LINE__, txt);

  for (idx = 0; idx < count; idx++) {
    MString s = f.fileName(idx);
    if (s == ".") continue;
    if (s == "..") continue;
    f.unlink(mStorageDir, s);
  }
}

int
MLDispatchPDSupplier::updateRSPMessage(MHL7Msg* rsp,
	const MString& personID, const MString& personIDIssuer,
	MPatientVector& v)
{
  int status = 0;
  int count = v.size();
  if (count == 0) {		// We did not find this request in this domain
    rsp->setValue("MSA", 1, 0, "AE");
    rsp->setValue("QAK", 2, 0, "AE");
    MString s = rsp->firstSegment();
    while (s != "MSA" && s != "") {
      s = rsp->nextSegment();
    }
    if (s == "") {
      status = 1;
    } else {
      rsp->insertSegment("ERR");
      rsp->setValue("ERR", 1, 1, "QPD");
      rsp->setValue("ERR", 1, 3, "3.1");
      rsp->setValue("ERR", 1, 4, "204");
      MPatientVector::iterator p = v.begin();
    }
  } else if (count == 1) {	// Then we only matched an entry in the known domain
    rsp->setValue("QAK", 2, 0, "NF");
  } else {
    rsp->setValue("QAK", 2, 0, "OK");
    MString s = rsp->firstSegment();
    while (s != "QPD" && s != "") {
      s = rsp->nextSegment();
    }
    if (s == "") {
      status = 1;
    } else {
      rsp->insertSegment("PID");
      rsp->setValue("PID", 5, 0, " ");
      MPatientVector::iterator p = v.begin();
      for (; p != v.end(); p++) {
	MString xrPatID = (*p).patientID();
	MString xrIssuer = (*p).issuerOfPatientID();
	MString xrIdentifierType = (*p).identifierType();
	if (xrPatID != personID || xrIssuer !=  personIDIssuer) {
	  rsp->setValue("PID", 3, 1, xrPatID);
	  rsp->setValue("PID", 3, 4, xrIssuer);
	  if (xrIdentifierType != "") {
	    rsp->setValue("PID", 3, 5, xrIdentifierType);
	  }
	}
      }
    }
  }
  return status;
}

int
MLDispatchPDSupplier::updateRSPMessageUnknownIssuer(MHL7Msg* rsp)
{
  int status = 0;
  {
    rsp->setValue("MSA", 1, 0, "AE");
    rsp->setValue("QAK", 2, 0, "AE");
    MString s = rsp->firstSegment();
    while (s != "MSA" && s != "") {
      s = rsp->nextSegment();
    }
    if (s == "") {
      status = 1;
    } else {
      rsp->insertSegment("ERR");
      rsp->setValue("ERR", 1, 1, "QPD");
      rsp->setValue("ERR", 1, 3, "3.4");
      rsp->setValue("ERR", 1, 4, "204");
    }
  }
  return status;
}

void
MLDispatchPDSupplier::clearPatientVector()
{
  while (!mPatientVector.empty()) {
    mPatientVector.pop_back();
  }
}
