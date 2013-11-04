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
#include <fstream>
#include "MESA.hpp"

#include "MHL7ProtocolHandlerLLP.hpp"
#include "MLDispatchOrderPlacerJapanese.hpp"
#include "MHL7Factory.hpp"
#include "MHL7Msg.hpp"
#include "MHL7DomainXlate.hpp"

#include "MPatient.hpp"
#include "MVisit.hpp"
#include "MPlacerOrder.hpp"
#include "MDBOrderPlacerJapanese.hpp"
#include "MLogClient.hpp"
#include "MFileOperations.hpp"
#include "MHL7MessageControlID.hpp"

extern int gMsgNumber;

MLDispatchOrderPlacerJapanese::MLDispatchOrderPlacerJapanese(const MLDispatchOrderPlacerJapanese& cpy) :
  MHL7Dispatcher(cpy.mFactory),
  mDatabase(cpy.mDatabase),
  mLogDir(cpy.mLogDir),
  mStorageDir(cpy.mStorageDir),
  mAnalysisMode(cpy.mAnalysisMode),
  mShutdownFlag(cpy.mShutdownFlag)
{
}

MLDispatchOrderPlacerJapanese::~MLDispatchOrderPlacerJapanese ()
{
}

void
MLDispatchOrderPlacerJapanese::printOn(ostream& s) const
{
  s << "MLDispatchOrderPlacerJapanese" << endl;
}

void
MLDispatchOrderPlacerJapanese::streamIn(istream& s)
{
  //s >> this->member;
}

// Non-boiler plate methods follow below

MLDispatchOrderPlacerJapanese::MLDispatchOrderPlacerJapanese(MHL7Factory& factory, MDBOrderPlacerJapanese* database,
                         const MString& outputQueue,
                         const MString& startEntityID,
                         const MString& defaultApplID,
			 const MString& logDir,
			 const MString& storageDir,
			 bool analysisMode,
			 int& shutdownFlag) :
  MHL7Dispatcher(factory),
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

// virtual
int
MLDispatchOrderPlacerJapanese::acceptADT(MHL7Msg& message, const MString& event)
{
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_CONVERSATION,
		"peer",
		"MLDispatchOrderPlacerJapanese::acceptADT",
		__LINE__,
		MString("Accepting ADT event ")+event);

  MString charSet = message.getValue("MSH", 18, 0);
  MString charSetRep1 = "";
  MString charSetRep2 = "";
  if (charSet.tokenExists('~', 0)) {
    charSetRep1 = charSet.getToken('~', 0);
  }
  if (charSet.tokenExists('~', 1)) {
    charSetRep2 = charSet.getToken('~', 1);
  }

  if (charSetRep1 != "ISO IR6") {
    logClient.log(MLogClient::MLOG_ERROR,
		"peer",
		"MLDispatchOrderPlacerJapanese::acceptADT",
		__LINE__,
		MString("Wrong value in MSH.18 (Character set)") + charSet);
    MHL7Dispatcher::acceptMessageApplicationError(message, event, "AE", "207");
    return 0;
  } else if (charSetRep2 != "ISO IR87") {
    logClient.log(MLogClient::MLOG_ERROR,
		"peer",
		"MLDispatchOrderPlacerJapanese::acceptADT",
		__LINE__,
		MString("Wrong value in MSH.18 (Character set)") + charSet);
    MHL7Dispatcher::acceptMessageApplicationError(message, event, "AE", "207");
    return 0;
  }

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
  logClient.log(MLogClient::MLOG_VERBOSE,
		"peer",
		"MLDispatchOrderPlacerJapanese::acceptADT",
		__LINE__,
		MString("Patient is: ")+patientString);

  processInfo( event, patient, visit);

  // Let the base class see the ADT; it will generate the ACK
  MHL7Dispatcher::acceptADT(message, event);

  return 0;  
}

// virtual
int
MLDispatchOrderPlacerJapanese::acceptORM(MHL7Msg& message, const MString& event)
{
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_CONVERSATION,
		"peer",
		"MLDispatchOrderPlacerJapanese::acceptORM",
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
		"peer",
		"MLDispatchOrderPlacerJapanese::acceptORM",
		__LINE__,
		MString("Patient is: ")+patientString);
  for (int inx = 0; inx < placerOrder.numOrders(); inx++) {
    MOrder& order = placerOrder.order(inx);
    MString orderTxt = order.placerOrderNumber() + ":" +
	order.fillerOrderNumber() + ":" +
	order.orderControl() + ":" +
	order.universalServiceID();
    logClient.log(MLogClient::MLOG_CONVERSATION,
		  "peer",
		  "MLDispatchOrderPlacerJapanese::acceptORM",
		  __LINE__,
		  MString("Order Information: ")+orderTxt);
  }

  // send order control information down
  processInfo(message, event, patient, placerOrder);


  // Let the base class see the ORM; it will generate the ACK
  MHL7Dispatcher::acceptORM(message, event);

  return 0;  
}

// virtual
int
MLDispatchOrderPlacerJapanese::acceptORR(MHL7Msg& message, const MString& event)
{
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_CONVERSATION,
		"peer",
		"MLDispatchOrderPlacerJapanese::acceptORR",
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

  // Let the base class see the ORR; it will generate the ACK
  MHL7Dispatcher::acceptORR(message, event);

  return 0;  
}

// virtual
int
MLDispatchOrderPlacerJapanese::acceptXXX(MHL7Msg& message, const MString& event)
{
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_CONVERSATION,
		"peer",
		"MLDispatchOrderPlacerJapanese::acceptXXX",
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

// virtual
int
MLDispatchOrderPlacerJapanese::acceptORU(MHL7Msg& message, const MString& event)
{
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_CONVERSATION,
		"peer",
		"MLDispatchOrderPlacerJapanese::acceptORU",
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
  logClient.log(MLogClient::MLOG_VERBOSE,
		"peer",
		"MLDispatchOrderPlacerJapanese::acceptORU",
		__LINE__,
		MString("Patient is: ")+patientString);
#if 0
  for (int inx = 0; inx < placerOrder.numOrders(); inx++) {
    MOrder& order = placerOrder.order(inx);
    MString orderTxt = order.placerOrderNumber() + ":" +
	order.fillerOrderNumber() + ":" +
	order.orderControl() + ":" +
	order.universalServiceID();
    logClient.log(MLogClient::MLOG_VERBOSE,
		  "peer",
		  "MLDispatchOrderPlacerJapanese::acceptORM",
		  __LINE__,
		  MString("Order Information: ")+orderTxt);
  }

  // send order control information down
  processInfo(message, event, patient, placerOrder);
#endif

  // Let the base class see the ORU; it will generate the ACK
  MHL7Dispatcher::acceptORU(message, event);

  return 0;  
}

void
MLDispatchOrderPlacerJapanese::logHL7Stream(const char* txt, int len)
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
		    "MLDispatchOrderPlacerJapanese::logHL7Stream", __LINE__, x);
    }
    ofstream f(storageFile, ios::out | ios::binary);
    f.write(txt, len);
  }
}

void
MLDispatchOrderPlacerJapanese::processInfo(const MString& event, const MPatient& patient, const MVisit& visit)
{
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_VERBOSE,
		"peer",
		"MLDispatchOrderPlacerJapanese::processInfo",
		__LINE__,
		MString("Processing ADT event ")+event);

  if (event == "A01") 
    mDatabase->admitRegisterPatient(patient, visit);
  else if (event == "A02")
    mDatabase->transferPatient(visit);
  else if (event == "A03")
    ;
  else if (event == "A04")
    mDatabase->admitRegisterPatient(patient, visit);
  else if (event == "A05")
    mDatabase->preRegisterPatient(patient, visit);
  else if (event == "A08")
    mDatabase->updateADTInfo(patient, visit);
  else if (event == "A40")
    mDatabase->mergePatient(patient, "ADT1");
  else
    processError("ADT", event, "");
}

void
MLDispatchOrderPlacerJapanese::processInfo(MHL7Msg& message, const MString& event,
                         const MPatient& patient,
                         const MPlacerOrder& placerOrder)
{
  MString orderControl = message.getValue("ORC", 1, 1);

  MLogClient logClient;
  logClient.log(MLogClient::MLOG_VERBOSE,
		"peer",
		"MLDispatchOrderPlacerJapanese::processInfo",
		__LINE__,
		MString("Processing event ")+event+MString(" with Order Control ")+orderControl);

  // There can be only two possibilities of trigger events:
  // O01: Order Message and O02: Order Response
  if (orderControl == "NW")  // new order request
  {
    // should not really receive it
    if (event == "O01") {
      mDatabase->enterOrder(placerOrder);
      // send an OK response
    } else {
      orderError(event, orderControl);
    }
  } else if (orderControl == "OK") {  // order accepted OK
    if (event == "O02") {
      MPatient p(patient);
      MPlacerOrder po(placerOrder);
      // check to see if this order exists in our database
      if (!mDatabase->getOrder(p, po)) {
	logClient.log(MLogClient::MLOG_ERROR,
		"peer",
		"MLDispatchOrderPlacerJapanese::processInfo",
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
      if (!mDatabase->getOrder(p, po)) {
        // update order with order control code "UA"
        mDatabase->updateOrder(placerOrder);
	logClient.log(MLogClient::MLOG_ERROR,
		"peer",
		"MLDispatchOrderPlacerJapanese::processInfo",
		__LINE__,
		MString("Server did not accept order: ")+placerOrder.placerOrderNumber() +
		 MString(" for patient: ") + patient.patientID());
      } else {
	logClient.log(MLogClient::MLOG_ERROR,
		"peer",
		"MLDispatchOrderPlacerJapanese::processInfo",
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
      if (!mDatabase->getOrder(p, po)) {
        mDatabase->cancelOrder(placerOrder);
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
      mDatabase->cancelOrder(placerOrder);
    else
      orderError(event, orderControl);
  } else if (orderControl == "CR") {  // order cancelled as requested
    // Filler cancelled the order.  Now delete it from the database
    if (event == "O02") {
      mDatabase->cancelOrder(placerOrder);
    } else {
      orderError(event, orderControl);
    }
  } else if (orderControl == "UC") { // unable to cancel
    if (event == "O02") {
      MPatient p(patient);
      MPlacerOrder po(placerOrder);
      // check to see if this order exists in our database
      if (!mDatabase->getOrder(p, po)) {
        // update order with order control "UC"
        mDatabase->updateOrder(placerOrder);
	logClient.log(MLogClient::MLOG_ERROR,
		"peer",
		"MLDispatchOrderPlacerJapanese::processInfo",
		__LINE__,
		MString("Server did not cancel order: ")+placerOrder.placerOrderNumber() +
		 MString(" for patient: ") + patient.patientID());
      } else {
	logClient.log(MLogClient::MLOG_ERROR,
		"peer",
		"MLDispatchOrderPlacerJapanese::processInfo",
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
		"peer",
		"MLDispatchOrderPlacerJapanese::processInfo",
		__LINE__,
		MString("Order Control (DC) not supported"));

    orderError(event, orderControl);
  } else if (orderControl == "OD") { // order discontinued
    logClient.log(MLogClient::MLOG_ERROR,
		"peer",
		"MLDispatchOrderPlacerJapanese::processInfo",
		__LINE__,
		MString("Order Control (OD) not supported"));

    orderError(event, orderControl);
  } else if (orderControl == "UD") { // unable to discontinue
    logClient.log(MLogClient::MLOG_ERROR,
		"peer",
		"MLDispatchOrderPlacerJapanese::processInfo",
		__LINE__,
		MString("Order Control (UD) not supported"));
    orderError(event, orderControl);
  } else if (orderControl == "OD") { // discontinued as requested
    logClient.log(MLogClient::MLOG_ERROR,
		"peer",
		"MLDispatchOrderPlacerJapanese::processInfo",
		__LINE__,
		MString("Order Control (OD) not supported"));

    orderError(event, orderControl);
  } else if (orderControl == "PA") { // parent order
    logClient.log(MLogClient::MLOG_ERROR,
		"peer",
		"MLDispatchOrderPlacerJapanese::processInfo",
		__LINE__,
		MString("Order Control (PA) not supported"));

    orderError(event, orderControl);
  } else if (orderControl == "CH") { // child order
    logClient.log(MLogClient::MLOG_ERROR,
		"peer",
		"MLDispatchOrderPlacerJapanese::processInfo",
		__LINE__,
		MString("Order Control (CH) not supported"));

    orderError(event, orderControl);
  } else if (orderControl == "SC") { // status changed
    // update order.  Since it is a notification, no response needed
    if (event == "O01")  {
      mDatabase->updateOrder(placerOrder);
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
      mDatabase->enterOrder(po);
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
      mDatabase->updateOrder(placerOrder);
    } else {
      orderError(event, orderControl);
    }
  } else {
    orderError(event, orderControl);
    logClient.log(MLogClient::MLOG_ERROR,
		"peer",
		"MLDispatchOrderPlacerJapanese::processInfo",
		__LINE__,
		MString("Order Control ") + orderControl + MString(" not supported"));
  }
}

void
MLDispatchOrderPlacerJapanese::sendORR(MHL7Msg& ormMsg, const MString& orderControl,
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

//this->sendHL7Message(*orrMsg);
  delete orrMsg;
}

void
MLDispatchOrderPlacerJapanese::orderError(const MString& event, const MString& orderControl)
{
  MString additionalInfo("Order Control: ");
  additionalInfo += orderControl;
  
  processError("ORM", event, additionalInfo);
}

void
MLDispatchOrderPlacerJapanese::processError(const MString& msgType, const MString& event, const MString& additionalInfo)
{
  MString error("(Messenger) Unknown Values HL7 Message \nMessage Type: "+msgType+" Trigger Event: "+event+" "+additionalInfo);

  MLogClient logClient;
  logClient.log(MLogClient::MLOG_ERROR,
		"peer",
		"MLDispatchOrderPlacerJapanese::processError",
		__LINE__,
		error);
}

MString
MLDispatchOrderPlacerJapanese::getNewPlacerOrderNumber()
{
  MString rtnValue = mDatabase->newPlacerOrderNumber();
  if (mApplicationID.size() > 0) {
    rtnValue += MString("^") + mApplicationID;
  }
  return rtnValue;
}

void
MLDispatchOrderPlacerJapanese::clearExistingMessages()
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
		"MLDispatchOrderPlacerJapanese::clearMessages", __LINE__, txt);

  for (idx = 0; idx < count; idx++) {
    MString s = f.fileName(idx);
    if (s == ".") continue;
    if (s == "..") continue;
    f.unlink(mStorageDir, s);
  }
}

