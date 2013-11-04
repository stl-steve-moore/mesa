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

#include "MESA.hpp"
#include "MHL7ProtocolHandlerLLP.hpp"
#include "MLDispatchXRefMgr.hpp"
#include "MHL7Factory.hpp"
#include "MHL7Msg.hpp"
#include "MHL7DomainXlate.hpp"

#include "MPatient.hpp"
#include "MVisit.hpp"
#include "MPlacerOrder.hpp"
#include "MFillerOrder.hpp"
#include "MDBXRefMgr.hpp"
#include "MLogClient.hpp"
#include "MFileOperations.hpp"

extern int gMsgNumber;

#if 0
MLDispatchXRefMgr::MLDispatchXRefMgr()
{
}
#endif

MLDispatchXRefMgr::MLDispatchXRefMgr(const MLDispatchXRefMgr& cpy) :
  MHL7Dispatcher(cpy.mFactory),
  mDatabase(cpy.mDatabase),
  mAnalysisMode(cpy.mAnalysisMode),
  mLogDir(cpy.mLogDir),
  mStorageDir(cpy.mStorageDir),
  mShutdownFlag(cpy.mShutdownFlag)
{
}

MLDispatchXRefMgr::~MLDispatchXRefMgr ()
{
}

void
MLDispatchXRefMgr::printOn(ostream& s) const
{
  s << "MLDispatchXRefMgr" << endl;
}

void
MLDispatchXRefMgr::streamIn(istream& s)
{
  //s >> this->member;
}

// Non-boiler plate methods follow below

MLDispatchXRefMgr::MLDispatchXRefMgr(MHL7Factory& factory, MDBXRefMgr* database,
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
MLDispatchXRefMgr::acceptADT(MHL7Msg& message, const MString& event)
{
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_CONVERSATION,
		"peer",
		"MLDispatchXRefMgr::acceptADT",
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
		"MLDispatchXRefMgr::acceptADT",
		__LINE__,
		MString("Patient is: ")+patientString);

  processInfo( event, patient, visit);


  // Let the base class see the ADT; it will generate the ACK
  MHL7Dispatcher::acceptADT(message, event);

  return 0;  
}

//virtual
int
MLDispatchXRefMgr::acceptXXX(MHL7Msg& message, const MString& event)
{
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_CONVERSATION,
		"peer",
		"MLDispatchXRefMgr::acceptXXX",
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
MLDispatchXRefMgr::acceptQBP(MHL7Msg& message, const MString& event)
{
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_CONVERSATION,
		"peer",
		"MLDispatchXRefMgr::acceptQBP",
		__LINE__,
		MString("Accepting QBP event ")+event);

  MString queryName = message.getValue("QPD", 1, 0);
  MString queryTag  = message.getValue("QPD", 2, 0);
  MString personID  = message.getValue("QPD", 3, 1);
  MString personIDIssuer  = message.getValue("QPD", 3, 4);

  logClient.logTimeStamp(MLogClient::MLOG_VERBOSE, "XRef Mgr: Query Parameters from inbound query");
  logClient.logTimeStamp(MLogClient::MLOG_VERBOSE, "Query Name: " + queryName);
  logClient.logTimeStamp(MLogClient::MLOG_VERBOSE, "Query Tag:  " + queryTag);
  logClient.logTimeStamp(MLogClient::MLOG_VERBOSE, "Person ID:  " + personID);
  logClient.logTimeStamp(MLogClient::MLOG_VERBOSE, "PID Issuer: " + personIDIssuer);


  int status = 0;
  MPatientVector v;
  status = mDatabase->crossReferenceLookup(v, personID, personIDIssuer);
#if 0
  if (status != 0) {
    return status;
  }
#endif
  MPatientVector::iterator p = v.begin();
  for (; p != v.end(); p++) {
    MString xrPatID = (*p).patientID();
    MString xrIssuer = (*p).issuerOfPatientID();
    MString identifierType = (*p).identifierType();
  }
  // Let the base class see the XXX; it will generate the ACK
  // Moore 2005.09.20 Remove the 3 lines below.
  // As of ITI TF 2.0, 2005.08.15, we use Immediate mode with no ACK
//  MHL7Msg* ack = mFactory.produceACK(message);
//  mHandler->sendHL7Message(*ack);
//  delete ack;

  MHL7Msg* rsp = mFactory.produceRSP(message);
  if (status == 2) {		// We did not recognize the domain
    this->updateRSPMessageUnknownIssuer(rsp);
  } else {
    this->updateRSPMessage(rsp, personID, personIDIssuer, v);
  }
  mHandler->sendHL7Message(*rsp);
  delete rsp;

  return status;
}


void
MLDispatchXRefMgr::logHL7Stream(const char* txt, int len)
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
		    "MLDispatchXRefMgr::logHL7Stream", __LINE__, x);
    }
    ofstream f(storageFile, ios::out | ios::binary);
    f.write(txt, len);
  }
}


void
MLDispatchXRefMgr::processInfo(const MString& event, const MPatient& patient,
			 const MVisit& visit)
{
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_VERBOSE,
		"peer",
		"MLDispatchXRefMgr::processInfo",
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
MLDispatchXRefMgr::processError(const MString& msgType, const MString& event, const MString& additionalInfo)
{
  MString error("(Messenger) Unknown Values HL7 Message \nMessage Type: "+msgType+" Trigger Event: "+event+" "+additionalInfo);

  MLogClient logClient;
  logClient.log(MLogClient::MLOG_VERBOSE,
		"",
		"MLDispatchXRefMgr::processError",
		__LINE__,
		error);
}

void
MLDispatchXRefMgr::clearExistingMessages()
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
		"MLDispatchXRefMgr::clearMessages", __LINE__, txt);

  for (idx = 0; idx < count; idx++) {
    MString s = f.fileName(idx);
    if (s == ".") continue;
    if (s == "..") continue;
    f.unlink(mStorageDir, s);
  }
}

int
MLDispatchXRefMgr::updateRSPMessage(MHL7Msg* rsp,
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
      rsp->setValue("ERR", 2, 1, "QPD");
      rsp->setValue("ERR", 2, 2, "1");
      rsp->setValue("ERR", 2, 3, "3");
      rsp->setValue("ERR", 2, 4, "1");
      rsp->setValue("ERR", 2, 5, "1");
      rsp->setValue("ERR", 3, 0, "204");
      rsp->setValue("ERR", 4, 0, "W");
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
	MString identifierType = (*p).identifierType();
	if (xrPatID != personID || xrIssuer !=  personIDIssuer) {
	  rsp->setValue("PID", 3, 1, xrPatID);
	  rsp->setValue("PID", 3, 4, xrIssuer);
	  rsp->setValue("PID", 3, 5, identifierType);
	}
      }
    }
  }
  return status;
}

int
MLDispatchXRefMgr::updateRSPMessageUnknownIssuer(MHL7Msg* rsp)
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
      rsp->setValue("ERR", 2, 1, "QPD");
      rsp->setValue("ERR", 2, 2, "1");
      rsp->setValue("ERR", 2, 3, "3");
      rsp->setValue("ERR", 2, 4, "1");
      rsp->setValue("ERR", 2, 5, "4");
      rsp->setValue("ERR", 3, 0, "204");
      rsp->setValue("ERR", 4, 0, "W");
    }
  }
  return status;
}
