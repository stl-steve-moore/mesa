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
#include "MLDispatchChargeProcessor.hpp"
#include "MHL7Factory.hpp"
#include "MHL7Msg.hpp"
#include "MHL7DomainXlate.hpp"
#include "MPatient.hpp"
#include "MVisit.hpp"
#include "MPlacerOrder.hpp"
#include "MLogClient.hpp"
#include "MFileOperations.hpp"

extern int gMsgNumber;

MLDispatchChargeProcessor::MLDispatchChargeProcessor(const MLDispatchChargeProcessor& cpy) :
  MHL7Dispatcher(cpy.mFactory),
  mAnalysisMode(cpy.mAnalysisMode),
  mLogDir(cpy.mLogDir),
  mStorageDir(cpy.mStorageDir),
  mShutdownFlag(cpy.mShutdownFlag)
{
}

MLDispatchChargeProcessor::~MLDispatchChargeProcessor ()
{
}

void
MLDispatchChargeProcessor::printOn(ostream& s) const
{
  s << "MLDispatchChargeProcessor" << endl;
}

void
MLDispatchChargeProcessor::streamIn(istream& s)
{
  //s >> this->member;
}

// Non-boiler plate methods follow below

MLDispatchChargeProcessor::MLDispatchChargeProcessor(MHL7Factory& factory,
			 const MString& logDir, const MString& storageDir,
			 bool analysisMode, int& shutdownFlag) :
  MHL7Dispatcher(factory),
  mLogDir(logDir),
  mStorageDir(storageDir),
  mAnalysisMode(analysisMode),
  mShutdownFlag(shutdownFlag)
{
}

void
MLDispatchChargeProcessor::logHL7Stream(const char* txt, int len)
{
  if (mAnalysisMode) {
    char storageDir[1024];
    char logFile[1024];
    mStorageDir.safeExport(storageDir, sizeof(storageDir));
    sprintf(logFile, "%s/%d.hl7", storageDir, ++gMsgNumber);
    {
      MLogClient logClient;
      char x[512];
      sprintf(x, "Writing input HL7 Stream of length %d to: %s",
                len, logFile);
      logClient.log(MLogClient::MLOG_VERBOSE,
                    "",
                    "MLDispatchChargeProcessor::logHL7Stream", __LINE__, x);
    }
    ofstream f(logFile, ios::out | ios::binary);
    f.write(txt, len);
  }
}


// virtual
int
MLDispatchChargeProcessor::acceptADT(MHL7Msg& message, const MString& event)
{
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_CONVERSATION,
		"",
		"MLDispatchChargeProcessor::acceptADT",
		__LINE__,
		MString("Accepting ADT event ")+event);

  MHL7DomainXlate xLate;
  MPatient patient;
  MVisit visit;

  xLate.translateHL7(message, patient);
  xLate.translateHL7(message, visit);

  MString patientString = patient.patientID() + ":" +
		patient.issuerOfPatientID() + ":" +
		patient.patientName();
  logClient.log(MLogClient::MLOG_VERBOSE,
		"",
		"MLDispatchChargeProcessor::acceptADT",
		__LINE__,
		MString("Patient is: ")+patientString);

  processInfo( event, patient, visit);

  MHL7Dispatcher::acceptADT(message, event);

  return 0;  
}

// virtual
int
MLDispatchChargeProcessor::acceptORM(MHL7Msg& message, const MString& event)
{
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_CONVERSATION,
		"",
		"MLDispatchChargeProcessor::acceptORM",
		__LINE__,
		MString("Accepting ORM event ")+event);

  MHL7DomainXlate xLate;
  MPatient patient;
  MPlacerOrder placerOrder;

  xLate.translateHL7(message, patient);
  cout << patient << endl;


  MString patientString = patient.patientID() + ":" +
		patient.issuerOfPatientID() + ":" +
		patient.patientName();
  logClient.log(MLogClient::MLOG_VERBOSE,
		"",
		"MLDispatchChargeProcessor::acceptORM",
		__LINE__,
		MString("Patient is: ")+patientString);

  //there will eventually be some additional control expressions
  //that will call the appropriate db method based on event
  //mDatabase->enterOrder(patient, placerOrder);

  MHL7Dispatcher::acceptORM(message, event);

  return 0;  
}

// virtual
int
MLDispatchChargeProcessor::acceptBAR(MHL7Msg& message, const MString& event)
{
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_CONVERSATION,
		"",
		"MLDispatchChargeProcessor::acceptBAR",
		__LINE__,
		MString("Accepting BAR event ")+event);

  MHL7DomainXlate xLate;
  MPatient patient;
  MPlacerOrder placerOrder;

  xLate.translateHL7(message, patient);

  MString patientString = patient.patientID() + ":" +
		patient.issuerOfPatientID() + ":" +
		patient.patientName();
  logClient.log(MLogClient::MLOG_VERBOSE,
		"",
		"MLDispatchChargeProcessor::acceptORM",
		__LINE__,
		MString("Patient is: ")+patientString);

  //there will eventually be some additional control expressions
  //that will call the appropriate db method based on event

  MHL7Dispatcher::acceptORM(message, event);

  return 0;  
}

//virtual
int
MLDispatchChargeProcessor::acceptXXX(MHL7Msg& message, const MString& event)
{
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_CONVERSATION,
		"",
		"MLDispatchChargeProcessor::acceptXXX",
		__LINE__,
		MString("Accepting XXX event ")+event);


  MHL7Dispatcher::acceptXXX(message, event);

  if (event == "KIL")
    mShutdownFlag = 1;
  else if (event == "RST") {
    gMsgNumber = 1000;
    this->clearExistingMessages();
  }
  return 0;
}


// Private methods below here
void
MLDispatchChargeProcessor::processInfo(const MString& event, const MPatient& patient,
			 const MVisit& visit)
{
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_VERBOSE,
		"",
		"MLDispatchChargeProcessor::processInfo",
		__LINE__,
		MString("Processing ADT event ")+event);

  cout << "Image Manager processing ADT event: " << event << endl;

#if 0
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
    mDatabase->mergePatient(patient);
#endif
}

void
MLDispatchChargeProcessor::clearExistingMessages()
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
		"",
		"MLDispatchChargeProcessor::clearMessages", __LINE__, txt);

  for (idx = 0; idx < count; idx++) {
    MString s = f.fileName(idx);
    if (s == ".") continue;
    if (s == "..") continue;
    f.unlink(mStorageDir, s);
  }
}
