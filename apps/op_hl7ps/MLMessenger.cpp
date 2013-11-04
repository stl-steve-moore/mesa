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

#include "ace/OS.h"
#include <fstream>
#include "MESA.hpp"

#include "MPatient.hpp"
#include "MVisit.hpp"
#include "MPlacerOrder.hpp"
#include "MDBOrderPlacer.hpp"
#include "MLogClient.hpp"
#include "MFileOperations.hpp"
#include "MHL7MessageControlID.hpp"

#include "MLMessenger.hpp"
#include "MHL7Msg.hpp"
#include "MHL7Factory.hpp"
#include "MHL7DomainXlate.hpp"
#include "MHL7Handler.hpp"


extern int gMsgNumber;

#if 0
MLMessenger::MLMessenger()
{
}
#endif

MLMessenger::MLMessenger(const MLMessenger& cpy) :
  MHL7Messenger(cpy.mFactory),
  mDatabase(cpy.mDatabase),
  mLogDir(cpy.mLogDir),
  mStorageDir(cpy.mStorageDir),
  mAnalysisMode(cpy.mAnalysisMode),
  mShutdownFlag(cpy.mShutdownFlag)
{
}

MLMessenger::~MLMessenger ()
{
}

MHL7Messenger*
MLMessenger::clone()
{
  MLMessenger* clone;

//clone = new MLMessenger(mFactory, mDatabase);
  clone = new MLMessenger(mFactory, mDatabase,
                          mOutputQueue, mCurrSelfGenEntityID, mApplicationID,
			  mLogDir, mStorageDir, mAnalysisMode, mShutdownFlag);
  return clone;
}

void
MLMessenger::printOn(ostream& s) const
{
  s << "MLMessenger" << endl;
}

void
MLMessenger::streamIn(istream& s)
{
  //s >> this->member;
}

// Non-boiler plate methods follow below
#if 0
MLMessenger::MLMessenger(MHL7Factory& factory, MDBOrderPlacer& database) :
  MHL7Messenger(factory),
  mDatabase(database)
{
}
#endif

MLMessenger::MLMessenger(MHL7Factory& factory, MDBOrderPlacer& database,
                         const MString& outputQueue,
                         const MString& startEntityID,
                         const MString& defaultApplID,
			 const MString& logDir,
			 const MString& storageDir,
			 bool analysisMode,
			 int& shutdownFlag) :
  MHL7Messenger(factory),
  mDatabase(database),
  mOutputQueue(outputQueue),
  mCurrSelfGenEntityID(startEntityID),
  mApplicationID(defaultApplID),
  mLogDir(logDir),
  mStorageDir(storageDir),
  mAnalysisMode(analysisMode),
  mShutdownFlag(shutdownFlag)
{
}

void
MLMessenger::analysisMode(bool analysisMode)
{
  mAnalysisMode = analysisMode;
}


// virtual
int
MLMessenger::acceptADT(MHL7Msg& message, const MString& event)
{
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_CONVERSATION,
		this->mHandler->getPeerName(),
		"MLMessenger::acceptADT",
		__LINE__,
		MString("Accepting ADT event ")+event);

  MHL7DomainXlate xLate;
  MPatient patient;
  MVisit   visit;

  xLate.issuer1("ADT1");
  xLate.issuer2("MPI");
  xLate.translateHL7(message, patient);
  xLate.translateHL7(message, visit);

  MString patientString = patient.patientID() + ":" +
		patient.issuerOfPatientID() + ":" +
		patient.patientName();
  logClient.log(MLogClient::MLOG_CONVERSATION,
		this->mHandler->getPeerName(),
		"MLMessenger::acceptADT",
		__LINE__,
		MString("Patient is: ")+patientString);

  processInfo( event, patient, visit);

  MHL7Msg* ack = mFactory.produceACK(message, "OP");
  this->sendHL7Message(*ack);
  delete ack;

  return 0;  
}

// virtual
int
MLMessenger::acceptORM(MHL7Msg& message, const MString& event)
{
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_CONVERSATION,
		this->mHandler->getPeerName(),
		"MLMessenger::acceptORM",
		__LINE__,
		MString("Accepting ORM event ")+event);

  MHL7DomainXlate xLate;
  MPatient patient;
  MVisit visit;
  MPlacerOrder placerOrder;

  xLate.issuer1("ADT1");
  xLate.issuer2("OF1");
  xLate.translateHL7(message, patient);
  xLate.translateHL7(message, visit);
  xLate.translateHL7(message, placerOrder);

  MString patientString = patient.patientID() + ":" +
		patient.issuerOfPatientID() + ":" +
		patient.patientName();
  logClient.log(MLogClient::MLOG_CONVERSATION,
		this->mHandler->getPeerName(),
		"MLMessenger::acceptORM",
		__LINE__,
		MString("Patient is: ")+patientString);
  for (int inx = 0; inx < placerOrder.numOrders(); inx++) {
    MOrder& order = placerOrder.order(inx);
    MString orderTxt = order.placerOrderNumber() + ":" +
	order.fillerOrderNumber() + ":" +
	order.orderControl() + ":" +
	order.universalServiceID();
    logClient.log(MLogClient::MLOG_CONVERSATION,
		  this->mHandler->getPeerName(),
		  "MLMessenger::acceptORM",
		  __LINE__,
		  MString("Order Information: ")+orderTxt);
  }

  // send order control information down
  processInfo(message, event, patient, placerOrder);

  MHL7Msg* ack = mFactory.produceACK(message, "OP");
  this->sendHL7Message(*ack);
  delete ack;

  return 0;  
}

// virtual
int
MLMessenger::acceptORR(MHL7Msg& message, const MString& event)
{
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_CONVERSATION,
		this->mHandler->getPeerName(),
		"MLMessenger::acceptORR",
		__LINE__,
		MString("Accepting ORR event ")+event);

  MHL7DomainXlate xLate;
  MPatient patient;
  MVisit visit;
  MPlacerOrder placerOrder;

  xLate.issuer1("ADT1");
  xLate.issuer2("OF1");
  xLate.translateHL7(message, patient);
  xLate.translateHL7(message, placerOrder);

  // send order control information down
  processInfo(message, event, patient, placerOrder);

  MHL7Msg* ack = mFactory.produceACK(message);
  this->sendHL7Message(*ack);
  delete ack;

  return 0;  
}

// virtual
int
MLMessenger::acceptXXX(MHL7Msg& message, const MString& event)
{
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_CONVERSATION,
		this->mHandler->getPeerName(),
		"MLMessenger::acceptXXX",
		__LINE__,
		MString("Accepting XXX event ")+event);

  MHL7Msg* ack = mFactory.produceACK(message);
  this->sendHL7Message(*ack);
  delete ack;

  if (event == "KIL")
    mShutdownFlag = 1;
  else if (event == "RST") {
    gMsgNumber = 1000;
    this->clearExistingMessages();
  }
  return 0;
}

// virtual
int
MLMessenger::acceptORU(MHL7Msg& message, const MString& event)
{
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_CONVERSATION,
		this->mHandler->getPeerName(),
		"MLMessenger::acceptORU",
		__LINE__,
		MString("Accepting ORU event ")+event);

  MHL7DomainXlate xLate;
  MPatient patient;
  MVisit visit;
  MPlacerOrder placerOrder;

  xLate.issuer1("ADT1");
  xLate.issuer2("OF1");
  xLate.translateHL7(message, patient);
//  xLate.translateHL7(message, visit);
//  xLate.translateHL7(message, placerOrder);

  MString patientString = patient.patientID() + ":" +
		patient.issuerOfPatientID() + ":" +
		patient.patientName();
  logClient.log(MLogClient::MLOG_CONVERSATION,
		this->mHandler->getPeerName(),
		"MLMessenger::acceptORU",
		__LINE__,
		MString("Patient is: ")+patientString);
#if 0
  for (int inx = 0; inx < placerOrder.numOrders(); inx++) {
    MOrder& order = placerOrder.order(inx);
    MString orderTxt = order.placerOrderNumber() + ":" +
	order.fillerOrderNumber() + ":" +
	order.orderControl() + ":" +
	order.universalServiceID();
    logClient.log(MLogClient::MLOG_CONVERSATION,
		  this->mHandler->getPeerName(),
		  "MLMessenger::acceptORM",
		  __LINE__,
		  MString("Order Information: ")+orderTxt);
  }

  // send order control information down
  processInfo(message, event, patient, placerOrder);
#endif

  MHL7Msg* ack = mFactory.produceACK(message, "OP");
  this->sendHL7Message(*ack);
  delete ack;

  return 0;  
}

void
MLMessenger::logHL7Stream(const char* txt, int len)
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
      logClient.log(MLogClient::MLOG_CONVERSATION,
		    this->mHandler->getPeerName(),
		    "MLMessenger::logHL7Stream", __LINE__, x);
    }
    ofstream f(storageFile, ios::out | ios::binary);
    f.write(txt, len);
  }
}

void
MLMessenger::processInfo(const MString& event, const MPatient& patient, const MVisit& visit)
{
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_CONVERSATION,
		this->mHandler->getPeerName(),
		"MLMessenger::processInfo",
		__LINE__,
		MString("Processing ADT event ")+event);

  if (event == "A01") 
    mDatabase.admitRegisterPatient(patient, visit);
  else if (event == "A02")
    mDatabase.transferPatient(visit);
  else if (event == "A03")
    ;
  else if (event == "A04")
    mDatabase.admitRegisterPatient(patient, visit);
  else if (event == "A05")
    mDatabase.preRegisterPatient(patient, visit);
  else if (event == "A08")
    mDatabase.updateADTInfo(patient, visit);
  else if (event == "A40")
    mDatabase.mergePatient(patient, "ADT1");
  else
    processError("ADT", event, "");
}

void
MLMessenger::processInfo(MHL7Msg& message, const MString& event,
                         const MPatient& patient,
                         const MPlacerOrder& placerOrder)
{
  MString orderControl = message.getValue("ORC", 1, 1);

  MLogClient logClient;
  logClient.log(MLogClient::MLOG_CONVERSATION,
		this->mHandler->getPeerName(),
		"MLMessenger::processInfo",
		__LINE__,
		MString("Processing event ")+event+MString(" with Order Control ")+orderControl);

  // There can be only two possibilities of trigger events:
  // O01: Order Message and O02: Order Response
  if (orderControl == "NW")  // new order request
  {
    // should not really receive it
    if (event == "O01") {
      mDatabase.enterOrder(placerOrder);
      // send an OK response
    } else {
      orderError(event, orderControl);
    }
  } else if (orderControl == "OK") {  // order accepted OK
    if (event == "O02") {
      MPatient p(patient);
      MPlacerOrder po(placerOrder);
      // check to see if this order exists in our database
      if (!mDatabase.getOrder(p, po)) {
	logClient.log(MLogClient::MLOG_ERROR,
		this->mHandler->getPeerName(),
		"MLMessenger::processInfo",
		__LINE__,
		MString("Order Number: ")+placerOrder.placerOrderNumber() +
		 MString(" for patient: ") + patient.patientID() + MString(" does not exist"));

        orderError(event, orderControl);
      }
    } else {
      orderError(event, orderControl);
    }
  } else if (orderControl == "UA") {  // unable to accept order
    if (event == "O02")  {
      MPatient p(patient);
      MPlacerOrder po(placerOrder);
      // check to see if this order exists in our database
      if (!mDatabase.getOrder(p, po)) {
        // update order with order control code "UA"
        mDatabase.updateOrder(placerOrder);
	logClient.log(MLogClient::MLOG_ERROR,
		this->mHandler->getPeerName(),
		"MLMessenger::processInfo",
		__LINE__,
		MString("Server did not accept order: ")+placerOrder.placerOrderNumber() +
		 MString(" for patient: ") + patient.patientID());
      } else {
	logClient.log(MLogClient::MLOG_ERROR,
		this->mHandler->getPeerName(),
		"MLMessenger::processInfo",
		__LINE__,
		MString("Order Number: ")+placerOrder.placerOrderNumber() +
		 MString(" for patient: ") + patient.patientID() + MString(" does not exist"));
        orderError(event, orderControl);
      }
    } else {
      orderError(event, orderControl);
    }
  } else if (orderControl == "CA") {  // cancel order request
    // should not really receive it
    // if the order exists, delete it from the database.
    if (event == "O01") {
      MPatient p(patient);
      MPlacerOrder po(placerOrder);
      if (!mDatabase.getOrder(p, po)) {
        mDatabase.cancelOrder(placerOrder);
        // generate response CR
      } else {
        // generate response UC
      }
    }
    else {
      orderError(event, orderControl);
    }
  } else if (orderControl == "OC") {  // order cancelled
    // Filler cancelled the order.  Delete it from the database
    // No reply needed
    if (event == "O01") 
      mDatabase.cancelOrder(placerOrder);
    else
      orderError(event, orderControl);
  } else if (orderControl == "CR") {  // order cancelled as requested
    // Filler cancelled the order.  Now delete it from the database
    if (event == "O02") {
      mDatabase.cancelOrder(placerOrder);
    } else {
      orderError(event, orderControl);
    }
  } else if (orderControl == "UC") { // unable to cancel
    if (event == "O02") {
      MPatient p(patient);
      MPlacerOrder po(placerOrder);
      // check to see if this order exists in our database
      if (!mDatabase.getOrder(p, po)) {
        // update order with order control "UC"
        mDatabase.updateOrder(placerOrder);
	logClient.log(MLogClient::MLOG_ERROR,
		this->mHandler->getPeerName(),
		"MLMessenger::processInfo",
		__LINE__,
		MString("Server did not cancel order: ")+placerOrder.placerOrderNumber() +
		 MString(" for patient: ") + patient.patientID());
      } else {
	logClient.log(MLogClient::MLOG_ERROR,
		this->mHandler->getPeerName(),
		"MLMessenger::processInfo",
		__LINE__,
		MString("Order Number: ")+placerOrder.placerOrderNumber() +
		 MString(" for patient: ") + patient.patientID() + MString(" does not exist"));
        orderError(event, orderControl);
      }
    } else {
      orderError(event, orderControl);
    }
  } else if (orderControl == "DC") { // discontinue order request
    logClient.log(MLogClient::MLOG_ERROR,
		this->mHandler->getPeerName(),
		"MLMessenger::processInfo",
		__LINE__,
		MString("Order Control (DC) not supported"));

    orderError(event, orderControl);
  } else if (orderControl == "OD") { // order discontinued
    logClient.log(MLogClient::MLOG_ERROR,
		this->mHandler->getPeerName(),
		"MLMessenger::processInfo",
		__LINE__,
		MString("Order Control (OD) not supported"));

    orderError(event, orderControl);
  } else if (orderControl == "UD") { // unable to discontinue
    logClient.log(MLogClient::MLOG_ERROR,
		this->mHandler->getPeerName(),
		"MLMessenger::processInfo",
		__LINE__,
		MString("Order Control (UD) not supported"));
    orderError(event, orderControl);
  } else if (orderControl == "OD") { // discontinued as requested
    logClient.log(MLogClient::MLOG_ERROR,
		this->mHandler->getPeerName(),
		"MLMessenger::processInfo",
		__LINE__,
		MString("Order Control (OD) not supported"));

    orderError(event, orderControl);
  } else if (orderControl == "PA") { // parent order
    logClient.log(MLogClient::MLOG_ERROR,
		this->mHandler->getPeerName(),
		"MLMessenger::processInfo",
		__LINE__,
		MString("Order Control (PA) not supported"));

    orderError(event, orderControl);
  } else if (orderControl == "CH") { // child order
    logClient.log(MLogClient::MLOG_ERROR,
		this->mHandler->getPeerName(),
		"MLMessenger::processInfo",
		__LINE__,
		MString("Order Control (CH) not supported"));

    orderError(event, orderControl);
  } else if (orderControl == "SC") { // status changed
    // update order.  Since it is a notification, no response needed
    if (event == "O01")  {
      mDatabase.updateOrder(placerOrder);
    } else {
      orderError(event, orderControl);
    }
  } else if (orderControl == "SN") {// send order number
    // Order Filler has entered a new order and assigned it an filler order num
    if (event == "O01") {
      // Assign a placer order number
      MString poNum = getNewPlacerOrderNumber();
      // store in the database
      MPlacerOrder po(placerOrder);
      po.placerOrderNumber(poNum);
      for (int i = po.numOrders()-1; i >= 0; i--) {
        MOrder o = po.order(i);
        o.orderControl("NA");
      }
      mDatabase.enterOrder(po);
      // send a response NA
#if 0
      char* cValue = poNum.strData();
      MString seg = message.firstSegment();
      while(seg != "") {
        if ((seg == "ORC") || (seg == "OBR"))
          message.setValue(2, 0, cValue);
        seg = message.nextSegment();
      }
      delete [] cValue;
#endif
      sendORR(message, "NA", poNum);
    } else {
      orderError(event, orderControl);
    }
  } else if (orderControl == "NA") { // number assigned
    // should not really receive it
    if (event == "O02") {
      // a new filler order number was assigned.  Update tables
      mDatabase.updateOrder(placerOrder);
    } else {
      orderError(event, orderControl);
    }
  } else {
    orderError(event, orderControl);
    logClient.log(MLogClient::MLOG_ERROR,
		this->mHandler->getPeerName(),
		"MLMessenger::processInfo",
		__LINE__,
		MString("Order Control ") + orderControl + MString(" not supported"));
  }
}

void
MLMessenger::sendORR(MHL7Msg& ormMsg, const MString& orderControl,
	const MString& placerOrderNumber)
{
  MHL7Msg* orrMsg = mFactory.produceORR(ormMsg, orderControl,
	placerOrderNumber);
  MHL7MessageControlID c;
  MString id = c.controlID();
  orrMsg->setValue("MSH", 10, 0, id);

  MFileOperations f;

  MString prefix = ormMsg.getValue("MSH",  3, 0);

  f.createDirectory( "MESA_STORAGE",
		MString("ordplc/") + prefix);

  MString path = f.uniqueFile("MESA_STORAGE",
	MString("ordplc/") + prefix, "hl7");

  orrMsg->saveAs(path);

#if 0
  char *fn = mOutputQueue.strData();
  ofstream f(fn, ios::app);
  delete [] fn;
  char wire[STREAMSIZE];
  memset(wire, 0, sizeof(wire));
  int len;
  orrMsg->exportToWire(wire, sizeof(wire), len);

  MLogClient logClient;
  logClient.log(MLogClient::MLOG_CONVERSATION,
		this->mHandler->getPeerName(),
		"MLMessenger::sendORR",
		__LINE__,
		MString("Writing Message: ") + MString(wire));

  f << wire << endl;
  f.close();
#endif
//this->sendHL7Message(*orrMsg);
  delete orrMsg;
}

void
MLMessenger::orderError(const MString& event, const MString& orderControl)
{
  MString additionalInfo("Order Control: ");
  additionalInfo += orderControl;
  
  processError("ORM", event, additionalInfo);
}

void
MLMessenger::processError(const MString& msgType, const MString& event, const MString& additionalInfo)
{
  MString error("(Messenger) Unknown Values HL7 Message \nMessage Type: "+msgType+" Trigger Event: "+event+" "+additionalInfo);

  MLogClient logClient;
  logClient.log(MLogClient::MLOG_ERROR,
		this->mHandler->getPeerName(),
		"MLMessenger::processError",
		__LINE__,
		error);
}

MString
MLMessenger::getNewPlacerOrderNumber()
{
  MString rtnValue = mDatabase.newPlacerOrderNumber();
  if (mApplicationID.size() > 0) {
    rtnValue += MString("^") + mApplicationID;
  }
  return rtnValue;
}

void
MLMessenger::clearExistingMessages()
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
		this->mHandler->getPeerName(),
		"MLMessenger::clearMessages", __LINE__, txt);

  for (idx = 0; idx < count; idx++) {
    MString s = f.fileName(idx);
    if (s == ".") continue;
    if (s == "..") continue;
    f.unlink(mStorageDir, s);
  }
}

