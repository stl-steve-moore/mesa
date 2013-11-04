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

// File: im_hl7.cpp

#include "ctn_os.h"
#include "MESA.hpp"
#include "MHL7ProtocolHandlerLLP.hpp"
#include "MHL7Factory.hpp"
#include "MHL7Reactor.hpp"
#include "MHL7Dispatcher.hpp"
#include "MLDispatchChargeProcessor.hpp"
#include "MLDispatchImgMgr.hpp"
#include "MLDispatchImgMgrJapanese.hpp"
#include "MLDispatchOrderFiller.hpp"
#include "MLDispatchOrderFillerJapanese.hpp"
#include "MLDispatchOrderPlacer.hpp"
#include "MLDispatchOrderPlacerJapanese.hpp"
#include "MLDispatchReportMgr.hpp"
#include "MLDispatchReportMgrJapanese.hpp"
#include "MLDispatchXRefMgr.hpp"
#include "MLDispatchPDSupplier.hpp"

#include "MDBImageManager.hpp"
#include "MDBImageManagerJapanese.hpp"
#include "MDBOrderFiller.hpp"
#include "MDBOrderFillerJapanese.hpp"
#include "MDBOrderPlacer.hpp"
#include "MDBOrderPlacerJapanese.hpp"
#include "MDBXRefMgr.hpp"
#include "MDBPDSupplier.hpp"

#include "MAcceptor.hpp"
#include "MNetworkProxyTCP.hpp"
#include "MLogClient.hpp"
#include "MFileOperations.hpp"

int gMsgNumber=1000;

static sig_atomic_t finished=0;
extern "C" void signalAction (int)
{
  finished = 1;
}

using namespace std;

static void usage()
{
  char msg[] = "\
Usage: hl7_rcvr [-b base] [-d def] [-l level] [-M type] [-s dir] [-z db] port\n\
  -b   Set base directory for HL7 parsing rules; default is $MESA_TARGET/runtime\n\
  -d   Set suffix for HL7 parsing rules; default is ihe\n\
  -l   Set log level (0-4, default is 0: none) \n\
  -l   Set manager type (CP, IM, OF, OP, RM, XR, default is IM) \n\
  -s   Set the local directory; default is $MESA_TARGET/logs \n\
  -z   Set databasename; default is imgmgr \n\
\n\
  port TCP/IP port used to accept connections";

  cerr << msg << endl;
  ::exit(1);
}

static int
runConnection(MHL7Dispatcher* dispatcher, MNetworkProxy* networkProxy)
{
  MLogClient logClient;
  MHL7ProtocolHandlerLLP* llpHandler = new MHL7ProtocolHandlerLLP(networkProxy);
  dispatcher->registerHandler(llpHandler);
  llpHandler->registerDispatcher(dispatcher);

  MHL7Reactor reactor;
  reactor.registerHandler(llpHandler);

  bool done = false;
  int status = 0;
  while (!done) {
    status = reactor.processRequests(0);
    done = true;
    if (status == 0) {
      logClient.log(MLogClient::MLOG_VERBOSE,
	"HL7 Reactor finished processing events normally");
    } else if (status == 1) {
      logClient.log(MLogClient::MLOG_VERBOSE,
	"HL7 Reactor finished processing events: socket closed");
    } else {
      logClient.log(MLogClient::MLOG_WARN,
	"HL7 Reactor finished processing events with some anomaly");
    }
  }

  return 0;
}

MDBImageManager*
openImgMgr(const MString& dbName)
{
  MDBImageManager* m = new MDBImageManager(dbName);
  if (m == 0) {
    MLogClient logClient;
    logClient.log(MLogClient::MLOG_ERROR,
                  "<no peer>", "hl7_server::openImgMgr", __LINE__,
                  "Unable to create new MDBImageManager");
    ::exit(1);
  }
  return m;
}

MDBImageManagerJapanese*
openImgMgrJapanese(const MString& dbName)
{
  MDBImageManagerJapanese* m = new MDBImageManagerJapanese(dbName);
  if (m == 0) {
    MLogClient logClient;
    logClient.log(MLogClient::MLOG_ERROR,
                  "<no peer>", "hl7_server::openImgMgrJapanese", __LINE__,
                  "Unable to create new MDBImageManagerJapanese");
    ::exit(1);
  }
  return m;
}

MDBOrderFiller*
openOrderFiller(const MString& dbName)
{
  MDBOrderFiller* m = new MDBOrderFiller(dbName);
  if (m == 0) {
    MLogClient logClient;
    logClient.log(MLogClient::MLOG_ERROR,
                  "<no peer>", "hl7_server::openOrderFiller", __LINE__,
                  "Unable to create new MDBOrderFiller");
    ::exit(1);
  }
  return m;
}

MDBOrderFillerJapanese*
openOrderFillerJapanese(const MString& dbName)
{
  MDBOrderFillerJapanese* m = new MDBOrderFillerJapanese(dbName);
  if (m == 0) {
    MLogClient logClient;
    logClient.log(MLogClient::MLOG_ERROR,
                  "<no peer>", "hl7_server::openOrderFillerJapanese", __LINE__,
                  "Unable to create new MDBOrderFillerJapanese");
    ::exit(1);
  }
  return m;
}

MDBOrderPlacer*
openOrderPlacer(const MString& dbName)
{
  MDBOrderPlacer* m = new MDBOrderPlacer(dbName);
  if (m == 0) {
    MLogClient logClient;
    logClient.log(MLogClient::MLOG_ERROR,
                  "<no peer>", "hl7_server::openOrderPlacer", __LINE__,
                  "Unable to create new MDBOrderPlacer");
    ::exit(1);
  }
  return m;
}

MDBOrderPlacerJapanese*
openOrderPlacerJapanese(const MString& dbName)
{
  MDBOrderPlacerJapanese* m = new MDBOrderPlacerJapanese(dbName);
  if (m == 0) {
    MLogClient logClient;
    logClient.log(MLogClient::MLOG_ERROR,
                  "<no peer>", "hl7_server::openOrderPlacerJapanese", __LINE__,
                  "Unable to create new MDBOrderPlacerJapanese");
    ::exit(1);
  }
  return m;
}

MDBXRefMgr*
openXRefMgr(const MString& dbName)
{
  MDBXRefMgr* m = new MDBXRefMgr(dbName);
  if (m == 0) {
    MLogClient logClient;
    logClient.log(MLogClient::MLOG_ERROR,
                  "<no peer>", "hl7_server::openXRefMgr", __LINE__,
                  "Unable to create new MDBXRefMgr");
    ::exit(1);
  }
  return m;
}

MDBPDSupplier*
openPDSupplier(const MString& dbName)
{
  MDBPDSupplier* m = new MDBPDSupplier(dbName);
  if (m == 0) {
    MLogClient logClient;
    logClient.log(MLogClient::MLOG_ERROR,
                  "<no peer>", "hl7_server::openPDSupplier", __LINE__,
                  "Unable to create new MDBPDSupplier");
    ::exit(1);
  }
  return m;
}

MHL7Dispatcher*
buildDispatcherRM(MHL7Factory& factory, MDBImageManager* dbImgMgr, bool analysisMode, int& shutdownFlag)
{
  MFileOperations f;
  char path[256];

  f.expandPath(path, "MESA_TARGET", "logs");
  MString logDir(path);
  f.expandPath(path, "MESA_STORAGE", "rpt_manager/hl7");
  MString storageDir(path);

  f.createDirectory(logDir);
  f.createDirectory(storageDir);

  MLDispatchReportMgr* mgr = new MLDispatchReportMgr(factory, dbImgMgr, logDir, storageDir,
					analysisMode, shutdownFlag);
  if (mgr == 0) {
    MLogClient logClient;
    logClient.log(MLogClient::MLOG_ERROR,
                  "<no peer>", "hl7_server::buildDispatcher", __LINE__,
                  "Unable to create new Report Manager Dispatcher");
    ::exit(1);
  }

  return mgr;
}

MHL7Dispatcher*
buildDispatcherRMJ(MHL7Factory& factory, MDBImageManagerJapanese* dbImgMgr,
	bool analysisMode, int& shutdownFlag)
{
  MFileOperations f;
  char path[256];

  f.expandPath(path, "MESA_TARGET", "logs");
  MString logDir(path);
  f.expandPath(path, "MESA_STORAGE", "imgmgr/hl7");
  MString storageDir(path);

  f.createDirectory(logDir);
  f.createDirectory(storageDir);

  MLDispatchReportMgrJapanese* mgr = new MLDispatchReportMgrJapanese(
	factory, dbImgMgr, logDir, storageDir, analysisMode, shutdownFlag);
  if (mgr == 0) {
    MLogClient logClient;
    logClient.log(MLogClient::MLOG_ERROR,
                  "<no peer>", "hl7_server::buildDispatcher", __LINE__,
                  "Unable to create new Report Manager Japanese Dispatcher");
    ::exit(1);
  }

  return mgr;
}

MHL7Dispatcher*
buildDispatcherIM(MHL7Factory& factory, MDBImageManager* dbImgMgr, bool analysisMode, int& shutdownFlag)
{
  MFileOperations f;
  char path[256];

  f.expandPath(path, "MESA_TARGET", "logs");
  MString logDir(path);
  f.expandPath(path, "MESA_STORAGE", "imgmgr/hl7");
  MString storageDir(path);

  f.createDirectory(logDir);
  f.createDirectory(storageDir);

  MLDispatchImgMgr* mgr = new MLDispatchImgMgr(factory, dbImgMgr, logDir, storageDir,
					analysisMode, shutdownFlag);
  if (mgr == 0) {
    MLogClient logClient;
    logClient.log(MLogClient::MLOG_ERROR,
                  "<no peer>", "hl7_server::buildDispatcher", __LINE__,
                  "Unable to create new Image Manager Dispatcher");
    ::exit(1);
  }

  return mgr;
}

MHL7Dispatcher*
buildDispatcherIMJ(MHL7Factory& factory, MDBImageManagerJapanese* dbImgMgr, bool analysisMode, int& shutdownFlag)
{
  MFileOperations f;
  char path[256];

  f.expandPath(path, "MESA_TARGET", "logs");
  MString logDir(path);
  f.expandPath(path, "MESA_STORAGE", "imgmgr/hl7");
  MString storageDir(path);

  f.createDirectory(logDir);
  f.createDirectory(storageDir);

  MLDispatchImgMgrJapanese* mgr = new MLDispatchImgMgrJapanese(factory, dbImgMgr,
	logDir, storageDir, analysisMode, shutdownFlag);
  if (mgr == 0) {
    MLogClient logClient;
    logClient.log(MLogClient::MLOG_ERROR,
                  "<no peer>", "hl7_server::buildDispatcherJapanese", __LINE__,
                  "Unable to create new Image Manager Dispatcher Japanese");
    ::exit(1);
  }

  return mgr;
}

MHL7Dispatcher*
buildDispatcherOF(MHL7Factory& factory, MDBOrderFiller* dbOF, bool analysisMode, int& shutdownFlag)
{
  MFileOperations f;
  char path[256];

  f.expandPath(path, "MESA_TARGET", "logs");
  MString logDir(path);
  f.expandPath(path, "MESA_STORAGE", "ordfil");
  MString storageDir(path);

  f.createDirectory(logDir);
  f.createDirectory(storageDir);

  MLDispatchOrderFiller* mgr = new MLDispatchOrderFiller(factory, dbOF, logDir, storageDir,
					analysisMode, shutdownFlag);
  if (mgr == 0) {
    MLogClient logClient;
    logClient.log(MLogClient::MLOG_ERROR,
                  "<no peer>", "hl7_server:buildDispatcher", __LINE__,
                  "Unable to create new Order Filler Dispatcher");
    ::exit(1);
  }

  return mgr;
}

MHL7Dispatcher*
buildDispatcherPMI(MHL7Factory& factory, MDBOrderFiller* dbOF, bool analysisMode, int& shutdownFlag)
{
  MFileOperations f;
  char path[256];

  f.expandPath(path, "MESA_TARGET", "logs");
  MString logDir(path);
  f.expandPath(path, "MESA_STORAGE", "pmi/hl7");
  MString storageDir(path);

  f.createDirectory(logDir);
  f.createDirectory(storageDir);

  MLDispatchOrderFiller* mgr = new MLDispatchOrderFiller(factory, dbOF, logDir, storageDir,
					analysisMode, shutdownFlag);
  if (mgr == 0) {
    MLogClient logClient;
    logClient.log(MLogClient::MLOG_ERROR,
                  "<no peer>", "hl7_server:buildDispatcher", __LINE__,
                  "Unable to create new Order Filler Dispatcher");
    ::exit(1);
  }

  return mgr;
}

MHL7Dispatcher*
buildDispatcherOFJ(MHL7Factory& factory, MDBOrderFillerJapanese* dbOFJapanese,
	bool analysisMode, int& shutdownFlag)
{
  MFileOperations f;
  char path[256];

  f.expandPath(path, "MESA_TARGET", "logs");
  MString logDir(path);
  f.expandPath(path, "MESA_STORAGE", "ordfil");
  MString storageDir(path);

  f.createDirectory(logDir);
  f.createDirectory(storageDir);

  MLDispatchOrderFillerJapanese* mgr = new MLDispatchOrderFillerJapanese(factory, dbOFJapanese,
		logDir, storageDir, analysisMode, shutdownFlag);
  if (mgr == 0) {
    MLogClient logClient;
    logClient.log(MLogClient::MLOG_ERROR,
                  "<no peer>", "hl7_server:buildDispatcher", __LINE__,
                  "Unable to create new Order Filler Dispatcher Japanese");
    ::exit(1);
  }

  return mgr;
}

MHL7Dispatcher*
buildDispatcherOP(MHL7Factory& factory, MDBOrderPlacer* dbOP,
	const MString& outputQueue, const MString& startEntityID,
	const MString& defaultApplID,
	bool analysisMode, int& shutdownFlag)
{
  MFileOperations f;
  char path[256];

  f.expandPath(path, "MESA_TARGET", "logs");
  MString logDir(path);
  f.expandPath(path, "MESA_STORAGE", "ordplc");
  MString storageDir(path);

  f.createDirectory(logDir);
  f.createDirectory(storageDir);

  MLDispatchOrderPlacer * mgr = new MLDispatchOrderPlacer(factory, dbOP,
					outputQueue, startEntityID, defaultApplID,
					logDir, storageDir,
					analysisMode, shutdownFlag);
  if (mgr == 0) {
    MLogClient logClient;
    logClient.log(MLogClient::MLOG_ERROR,
                  "<no peer>", "hl7_server::buildDispatcher", __LINE__,
                  "Unable to create new Order Placer Dispatcher");
    ::exit(1);
  }

  return mgr;
}

MHL7Dispatcher*
buildDispatcherOPJ(MHL7Factory& factory, MDBOrderPlacerJapanese* dbOP,
	const MString& outputQueue, const MString& startEntityID,
	const MString& defaultApplID,
	bool analysisMode, int& shutdownFlag)
{
  MFileOperations f;
  char path[256];

  f.expandPath(path, "MESA_TARGET", "logs");
  MString logDir(path);
  f.expandPath(path, "MESA_STORAGE", "ordplc");
  MString storageDir(path);

  f.createDirectory(logDir);
  f.createDirectory(storageDir);

  MLDispatchOrderPlacerJapanese * mgr = new MLDispatchOrderPlacerJapanese(
					factory, dbOP,
					outputQueue, startEntityID, defaultApplID,
					logDir, storageDir,
					analysisMode, shutdownFlag);
  if (mgr == 0) {
    MLogClient logClient;
    logClient.log(MLogClient::MLOG_ERROR,
                  "<no peer>", "hl7_server::buildDispatcherJapanese", __LINE__,
                  "Unable to create new Order Placer DispatcherJapanese");
    ::exit(1);
  }

  return mgr;
}

MHL7Dispatcher*
buildDispatcherCP(MHL7Factory& factory, bool analysisMode, int& shutdownFlag)
{
  MFileOperations f;
  char path[256];

  f.expandPath(path, "MESA_TARGET", "logs");
  MString logDir(path);
  f.expandPath(path, "MESA_STORAGE", "chgp/hl7");
  MString storageDir(path);

  f.createDirectory(logDir);
  f.createDirectory(storageDir);

  MLDispatchChargeProcessor* mgr = new MLDispatchChargeProcessor(factory, logDir, storageDir,
					analysisMode, shutdownFlag);
  if (mgr == 0) {
    MLogClient logClient;
    logClient.log(MLogClient::MLOG_ERROR,
                  "<no peer>", "hl7_server::buildDispatcher", __LINE__,
                  "Unable to create new Charge Processor Dispatcher");
    ::exit(1);
  }

  return mgr;
}


MHL7Dispatcher*
buildDispatcherXR(MHL7Factory& factory, MDBXRefMgr* dbXR, bool analysisMode, int& shutdownFlag)
{
  MFileOperations f;
  char path[256];

  f.expandPath(path, "MESA_TARGET", "logs");
  MString logDir(path);
  f.expandPath(path, "MESA_STORAGE", "xref/hl7");
  MString storageDir(path);

  f.createDirectory(logDir);
  f.createDirectory(storageDir);

  MLDispatchXRefMgr* mgr = new MLDispatchXRefMgr(factory, dbXR, logDir, storageDir,
					analysisMode, shutdownFlag);
  if (mgr == 0) {
    MLogClient logClient;
    logClient.log(MLogClient::MLOG_ERROR,
                  "<no peer>", "hl7_server:buildDispatcherXR", __LINE__,
                  "Unable to create new XRef Manager Dispatcher");
    ::exit(1);
  }

  return mgr;
}

MHL7Dispatcher*
buildDispatcherPDS(MHL7Factory& factory, MDBPDSupplier* dbPDS, bool analysisMode, int& shutdownFlag)
{
  MFileOperations f;
  char path[256];

  f.expandPath(path, "MESA_TARGET", "logs");
  MString logDir(path);
  f.expandPath(path, "MESA_STORAGE", "pd_supplier/hl7");
  MString storageDir(path);

  f.createDirectory(logDir);
  f.createDirectory(storageDir);

  MLDispatchPDSupplier* mgr = new MLDispatchPDSupplier(factory, dbPDS, logDir, storageDir,
					analysisMode, shutdownFlag);
  if (mgr == 0) {
    MLogClient logClient;
    logClient.log(MLogClient::MLOG_ERROR,
                  "<no peer>", "hl7_server:buildDispatcherPDS", __LINE__,
                  "Unable to create new PD Supplier Dispatcher");
    ::exit(1);
  }

  return mgr;
}


int main(int argc, char** argv)
{ 
  MLogClient logClient;
  bool analysisMode = true;
  MFileOperations f;
  char path[256];

  f.expandPath(path, "MESA_TARGET", "runtime");
  MString hl7Base(path);
  hl7Base += "/";

  f.expandPath(path, "MESA_TARGET", "logs");
  MString logDir(path);

  MString hl7Definition(".ihe");
  MLogClient::LOGLEVEL logLevel = MLogClient::MLOG_ERROR;
  int l1 = 0;

  MString randomsFile = "";
  MString keyFile = "";
  MString certificateFile = "";
  MString peerCertificateList = "";
  MString ciphers = "NULL-SHA";

  MString proxyType = "TCP";            // Assume normal mode
  MString managerType = "IM";		// Assume Image Manager type
  MString databaseName("imgmgr");	// Assume Image Manager database

  MString returnMsgQueue("ORC");
  MString startEntityID("00000");
  MString defaultApplID("MESA_ORDPLC");

  while (--argc > 0 && (*++argv)[0] == '-') {
    switch(*(argv[0] + 1)) {
 
    case 'b':
      argc--; argv++;
      if (argc < 1)
	usage();
      hl7Base = MString(*argv) + "/";
      break;

    case 'C':
      argc--;
      argv++;
      if (argc <= 0)
        usage();
      certificateFile = *argv;
      break;

    case 'd':
      argc--; argv++;
      if (argc < 1)
	usage();
      hl7Definition = MString(".") + *argv;
      break;

    case 'K':
      argc--;
      argv++;
      if (argc <= 0)
        usage();
      keyFile = *argv;
      break;

    case 'l':
      argc--;
      argv++;
      if (argc < 1)
        usage();
      if (sscanf(*argv, "%d", &l1) != 1)
        usage();
      logLevel = (MLogClient::LOGLEVEL)l1;
      break;

    case 'M':
      argc--;
      argv++;
      if (argc <= 0)
        usage();
      managerType = *argv;
      break;

    case 'P':
      argc--;
      argv++;
      if (argc <= 0)
        usage();
      peerCertificateList = *argv;
      break;

    case 'R':
      argc--;
      argv++;
      if (argc <= 0)
        usage();
      randomsFile = *argv;
      break;

    case 's':
      argc--; argv++;
      if (argc < 1)
	usage();
      logDir = MString(*argv) + "/";
      break;

    case 'S':
      proxyType = "TCP";
      break;

    case 'z':
      argc--; argv++;
      if (argc < 1)
	usage();
      databaseName = MString(*argv);
      break;

    case 'Z':
      argc--;
      argv++;
      if (argc <= 0)
        usage();
      ciphers = *argv;
      break;
  
    default:
      break;
    }
  }
  if (argc < 1)
    usage();

  MFileOperations fileOperations;
  fileOperations.createDirectory(logDir);

  if (logLevel != MLogClient::MLOG_NONE) {
    MLogClient logClient;
    MString logFile = "hl7_rcvr.log";
    if (managerType == "CP") {
      logFile = "cp_hl7ps.log";
    } else if (managerType == "IM") {
      logFile = "im_hl7ps.log";
    } else if (managerType == "IMJ") {
      logFile = "im_hl7ps.log";
    } else if (managerType == "OF") {
      logFile = "of_hl7ps.log";
    } else if (managerType == "OFJ") {
      logFile = "of_hl7ps.log";
    } else if (managerType == "OP") {
      logFile = "op_hl7ps.log";
    } else if (managerType == "OPJ") {
      logFile = "op_hl7ps.log";
    } else if (managerType == "RM" || managerType == "RMJ") {
      logFile = "rm_hl7ps.log";
    } else if (managerType == "XR") {
      logFile = "xr_hl7ps.log";
    } else if (managerType == "PDS") {
      logFile = "pds_hl7ps.log";
    } else if (managerType == "PMI") {
      logFile = "pmi_hl7ps.log";
    } else {
      cout << "hl7_rcvr: Unrecognized manager type: " << managerType << endl;
      return 1;
    }

    logClient.initialize(logLevel, logDir + "/" + logFile);

    logClient.log(MLogClient::MLOG_ERROR,
                  "<no peer>", "im_hl7ps<main>", __LINE__,
                  "Begin server process");
    cerr << "hl7_rcvr logging messages at level "
         << logLevel
         << " to "
         << logDir + "/" + logFile
         << endl;
  }

  MHL7Reactor reactor;
  MHL7Factory factory(hl7Base, hl7Definition);

  MNetworkProxy* networkProxy = 0;
  if (proxyType == "TCP") {
    networkProxy = new MNetworkProxyTCP;
  } else {
    cout << "Unrecognized proxy type: " << proxyType << endl;
    return 1;
  }

  int port = atoi(*argv);
  if (networkProxy->registerPort(port) != 0) {
    logClient.log(MLogClient::MLOG_ERROR, "",
	"hl7_rcvr::main", __LINE__,
	"Unable to register TCP listening port");
    return 1;
  }

  int status = 0;
  bool done = false;

  int shutdownFlag = 0;
  MHL7Dispatcher* dispatcher;
  MDBImageManager* dbImgMgr = 0;
  MDBImageManagerJapanese* dbImgMgrJapanese = 0;
  MDBOrderFiller * dbOrderFiller = 0;
  MDBOrderFillerJapanese * dbOrderFillerJapanese = 0;
  MDBOrderPlacer * dbOrderPlacer = 0;
  MDBOrderPlacerJapanese* dbOrderPlacerJapanese = 0;
  MDBXRefMgr* dbXRefMgr = 0;
  MDBPDSupplier* dbPDSupplier = 0;

  if (managerType == "IM") {
    dbImgMgr = openImgMgr(databaseName);
    dispatcher = buildDispatcherIM(factory, dbImgMgr, analysisMode, shutdownFlag);
  } else if (managerType == "IMJ") {
    dbImgMgrJapanese = openImgMgrJapanese(databaseName);
    dispatcher = buildDispatcherIMJ(factory, dbImgMgrJapanese, analysisMode, shutdownFlag);
  } else if (managerType == "OF") {
    dbOrderFiller = openOrderFiller(databaseName);
    dispatcher = buildDispatcherOF(factory, dbOrderFiller, analysisMode, shutdownFlag);
  } else if (managerType == "OFJ") {
    dbOrderFillerJapanese = openOrderFillerJapanese(databaseName);
    dispatcher = buildDispatcherOFJ(factory, dbOrderFillerJapanese, analysisMode, shutdownFlag);
  } else if (managerType == "OP") {
    dbOrderPlacer = openOrderPlacer(databaseName);
    dispatcher = buildDispatcherOP(factory, dbOrderPlacer,
	hl7Base+returnMsgQueue, startEntityID, defaultApplID,
	analysisMode, shutdownFlag);
  } else if (managerType == "OPJ") {
    dbOrderPlacerJapanese = openOrderPlacerJapanese(databaseName);
    dispatcher = buildDispatcherOPJ(factory, dbOrderPlacerJapanese,
	hl7Base+returnMsgQueue, startEntityID, defaultApplID,
	analysisMode, shutdownFlag);
  } else if (managerType == "CP") {
    dispatcher = buildDispatcherCP(factory, analysisMode, shutdownFlag);
  } else if (managerType == "RM") {
    dbImgMgr = openImgMgr(databaseName);
    dispatcher = buildDispatcherRM(factory, dbImgMgr, analysisMode, shutdownFlag);
  } else if (managerType == "RMJ") {
    dbImgMgrJapanese = openImgMgrJapanese(databaseName);
    dispatcher = buildDispatcherRMJ(factory, dbImgMgrJapanese, analysisMode, shutdownFlag);
  } else if (managerType == "XR") {
    dbXRefMgr = openXRefMgr(databaseName);
    dispatcher = buildDispatcherXR(factory, dbXRefMgr, analysisMode, shutdownFlag);
  } else if (managerType == "PDS") {
    dbPDSupplier = openPDSupplier(databaseName);
    dispatcher = buildDispatcherPDS(factory, dbPDSupplier, analysisMode, shutdownFlag);
  } else if (managerType == "PMI") {
    dbOrderFiller = openOrderFiller(databaseName);
    dispatcher = buildDispatcherPMI(factory, dbOrderFiller, analysisMode, shutdownFlag);
  } else {
    logClient.log(MLogClient::MLOG_ERROR, "",
	"hl7_rcvr::main", __LINE__,
	MString("Unrecognized manager type: ") + managerType);
    return 1;
  }

  while (!done) {
    MString remoteHost = "";
    status = networkProxy->acceptConnection(remoteHost, -1);
    if (status != 0) {
      logClient.log(MLogClient::MLOG_ERROR,
	"Unable to accept connection in hl7_rcvr");
      return 1;
    }
    runConnection(dispatcher, networkProxy);
    if (shutdownFlag)
      done = true;
  }
  delete dispatcher;
  delete dbImgMgr;
  delete dbImgMgrJapanese;
  delete dbOrderFiller;
  delete dbOrderFillerJapanese;
  delete dbOrderPlacer;
  delete dbOrderPlacerJapanese;
  delete dbXRefMgr;
  delete dbPDSupplier;

  return 0;
}
