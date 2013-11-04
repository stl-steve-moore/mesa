// = TITLE
//	A dispatcher to handle received HL7 messages.
//
// = DESCRIPTION
//	This class is a dispatcher which accepts HL7 messages and saves them to a unique file path
//	It then processes the message, storing the filepath into a table: hl7_file_index
//	It inherits from <{MHL7Dispatcher}> 

#include <stdlib.h>
#include "ctn_os.h"
#include "fstream"

#include "MESA.hpp"
#include "MHL7ProtocolHandlerLLP.hpp"
#include "MMessageCollector.hpp"
#include "MHL7Factory.hpp"
#include "MHL7Msg.hpp"
#include "MHL7DomainXlate.hpp"

#include "MPatient.hpp"
#include "MVisit.hpp"
#include "MPlacerOrder.hpp"
#include "MFillerOrder.hpp"
#include "MDBHL7Notification.hpp"
#include "MLogClient.hpp"
#include "MFileOperations.hpp"

extern int gMsgNumber;

#if 0
MMessageCollector::MMessageCollector()
{
}
#endif

MMessageCollector::MMessageCollector(const MMessageCollector& cpy) :
  MHL7Dispatcher(cpy.mFactory),
  mDatabase(cpy.mDatabase),
  mAnalysisMode(cpy.mAnalysisMode),
  mLogDir(cpy.mLogDir),
  mStorageDir(cpy.mStorageDir),
  mShutdownFlag(cpy.mShutdownFlag)
{
}

MMessageCollector::~MMessageCollector ()
{
}

void
MMessageCollector::printOn(ostream& s) const
{
  s << "MMessageCollector" << endl;
}

void
MMessageCollector::streamIn(istream& s)
{
  //s >> this->member;
}

// Non-boiler plate methods follow below

MMessageCollector::MMessageCollector(MHL7Factory& factory, MDBHL7Notification* database,
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
MMessageCollector::acceptADT(MHL7Msg& message, const MString& event)
{
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_CONVERSATION,
		"peer",
		"MMessageCollector::acceptADT",
		__LINE__,
		MString("Accepting ADT event ")+event);

  MHL7DomainXlate xLate;
  MPatient patient;
  MVisit   visit;

  xLate.translateHL7(message, patient);
  xLate.translateHL7(message, visit);

  MString patientString = patient.patientID() + ":" +
		patient.issuerOfPatientID() + ":" +
		patient.patientName();

  logClient.log(MLogClient::MLOG_VERBOSE,
		"peer",
		"MMessageCollector::acceptADT",
		__LINE__,
		MString("Patient is: ")+patientString);

  MFileOperations m;
  MString file_path = m.uniqueFile("MESA_STORAGE","mars", "hl7"); 
  message.saveAs(file_path);

  processInfo(message, file_path, event);


  // Let the base class see the ADT; it will generate the ACK
  MHL7Dispatcher::acceptADT(message, event);

  return 0;  
}


//virtual
int
MMessageCollector::acceptORM(MHL7Msg& message, const MString& event)
{
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_CONVERSATION,
		"peer",
		"MMessageCollector::acceptORM",
		__LINE__,
		MString("Accepting ORM event ")+event);

  MHL7DomainXlate xLate;
  MPatient patient;
  MVisit visit;
  MPlacerOrder placerOrder;
  MFillerOrder fillerOrder;

  xLate.translateHL7(message, patient);
  xLate.translateHL7(message, visit);
  xLate.translateHL7(message, placerOrder);

  MString patientString = patient.patientID() + ":" +
		patient.issuerOfPatientID() + ":" +
		patient.patientName();
  logClient.log(MLogClient::MLOG_VERBOSE,
		"peer",
		"MMessageCollector::acceptORM",
		__LINE__,
		MString("Patient is: ")+patientString);

  for (int inx = 0; inx < placerOrder.numOrders(); inx++) {
    MOrder& order = placerOrder.order(inx);
    MString orderTxt = order.placerOrderNumber() + ":" +
	order.fillerOrderNumber() + ":" +
	order.orderControl() + ":" +
	order.universalServiceID();
    logClient.log(MLogClient::MLOG_VERBOSE,
		  "peer",
		  "MMessageCollector::acceptORM",
		  __LINE__,
		  MString("Order Informaition: ")+orderTxt);
  }

  MFileOperations m;
  MString file_path = m.uniqueFile("MESA_STORAGE","mars", "hl7"); 
  message.saveAs(file_path);

  processInfo(message, file_path, event);

  // Let the base class see the ORM; it will generate the ORR
  MHL7Dispatcher::acceptORM(message, event, true);

  return 0;  
}

//virtual
int
MMessageCollector::acceptORU(MHL7Msg& message, const MString& event)
{
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_CONVERSATION,
		"peer",
		"MMessageCollector::acceptORU",
		__LINE__,
		MString("Accepting ORU event ")+event);

  MHL7DomainXlate xLate;
  MPatient patient;
  MVisit visit;
  MPlacerOrder placerOrder;

  xLate.translateHL7(message, patient);
//  xLate.translateHL7(message, visit);
//  xLate.translateHL7(message, placerOrder);

  MString patientString = patient.patientID() + ":" +
		patient.issuerOfPatientID() + ":" +
		patient.patientName();
  logClient.log(MLogClient::MLOG_VERBOSE,
		"peer",
		"MMessageCollector::acceptORU",
		__LINE__,
		MString("Patient is: ")+patientString);

  MFileOperations m;
  MString file_path = m.uniqueFile("MESA_STORAGE","mars", "hl7"); 
  message.saveAs(file_path);

  processInfo(message, file_path, event);

  // Let the base class see the ORU; it will generate the ACK
  MHL7Dispatcher::acceptORU(message, event);

  return 0;  
}




//virtual
int
MMessageCollector::acceptORR(MHL7Msg& message, const MString& event)
{
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_CONVERSATION,
		"peer",
		"MMessageCollector::acceptORR",
		__LINE__,
		MString("Accepting ORR event ")+event);
  
  MHL7DomainXlate xLate;
  MPatient patient;
  MPlacerOrder placerOrder;
  MFillerOrder fillerOrder;

  xLate.translateHL7(message, patient);
  xLate.translateHL7(message, fillerOrder);
  xLate.translateHL7(message, placerOrder);

  MString patientString = patient.patientID() + ":" +
		patient.issuerOfPatientID() + ":" +
		patient.patientName();
  logClient.log(MLogClient::MLOG_VERBOSE,
		"peer",
		"MMessageCollector::acceptORR",
		__LINE__,
		MString("Patient is: ")+patientString);

  MString orderControl = message.getValue("ORC", 1, 1);

  MFileOperations m;
  MString file_path = m.uniqueFile("MESA_STORAGE","mars", "hl7"); 
  message.saveAs(file_path);

  processInfo(message, file_path, event);

  // Let the base class see the ORR; it will generate the ACK
  MHL7Dispatcher::acceptORR(message, event);

  return 0;
}


/******************************************************
CODE TO RECEIVE OTHER TYPES OF MESSAGES
*******************************************************/

void
MMessageCollector::logHL7Stream(const char* txt, int len)
{
  /*if (mAnalysisMode) {
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
		    "MMessageCollector::logHL7Stream", __LINE__, x);
    }

  }*/
}


void
MMessageCollector::processInfo(const MHL7Msg& message , const MString& file_path, const MString& event)
{
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_VERBOSE,
		"peer",
		"MMessageCollector::processInfo",
		__LINE__,
		MString("Processing ADT event "+event));
  
  
  MString status = "in progress";
  mDatabase->enterMessage(file_path,"now",status);
  

}

