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
#include "MHL7IDXFactory.hpp"
#include "MHL7Reactor.hpp"
#include "MHL7Dispatcher.hpp"
#include "MMessageCollector.hpp"

#include "MDBHL7Notification.hpp"

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
Usage: hl7_msg_server [-b base] [-d def] [-l level] [-M type] [-s dir] [-z db] port\n\
  -b   Set base directory for HL7 parsing rules; default is $MESA_TARGET/runtime\n\
  -d   Set suffix for HL7 parsing rules; default is ihe\n\
  -l   Set log level (0-4, default is 0: none) \n\
  -M   Set manager type (default is MSG) \n\
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

MDBHL7Notification*
openMSG(const MString& dbName)
{
  MDBHL7Notification* m = new MDBHL7Notification(dbName);
  if (m == 0) {
    MLogClient logClient;
    logClient.log(MLogClient::MLOG_ERROR,
                  "<no peer>", "hl7_server::openMSG", __LINE__,
                  "Unable to create new MDBHL7Notification");
    ::exit(1);
  }
  return m;
}

MHL7Dispatcher*
buildMMessageCollector(MHL7Factory& factory, MDBHL7Notification * dbHL7Notification,
		     bool analysisMode, int& shutdownFlag)
{
  MFileOperations f;
  char path[256];

  f.expandPath(path, "MESA_TARGET", "logs");
  MString logDir(path);
  f.expandPath(path, "MESA_STORAGE", "mars");
  MString storageDir(path);

  f.createDirectory(logDir);
  f.createDirectory(storageDir);

  MMessageCollector* msg_collector = new MMessageCollector(factory, dbHL7Notification, 
					     logDir, storageDir, analysisMode, shutdownFlag);
  if (msg_collector == 0) {
    MLogClient logClient;
    logClient.log(MLogClient::MLOG_ERROR,
                  "<no peer>", "hl7_server:buildDispatcher", __LINE__,
                  "Unable to create new MMessageCollector Dispatcher");
    ::exit(1);
  }

  return msg_collector;
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
  MLogClient::LOGLEVEL logLevel = MLogClient::MLOG_NONE;
  int l1 = 0;

  MString randomsFile = "";
  MString keyFile = "";
  MString certificateFile = "";
  MString peerCertificateList = "";
  MString ciphers = "NULL-SHA";

  MString proxyType = "TCP";            // Assume normal mode
  MString managerType = "MSG";		// Assume MSG type
  MString databaseName("mars");		// Assume mars database

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
    MString logFile = "hl7_msg_server.log";
    if (managerType == "MSG") {
      logFile = "msg_hl7ps.log";
    } else {
      cout << "hl7_msg_server: Unrecognized manager type: " << managerType << endl;
      return 1;
    }

    logClient.initialize(logLevel, logDir + "/" + logFile);

    logClient.log(MLogClient::MLOG_ERROR,
                  "<no peer>", "im_hl7ps<main>", __LINE__,
                  "Begin server process");
    cerr << "hl7_msg_server logging messages at level "
         << logLevel
         << " to "
         << logDir + "/" + logFile
         << endl;
  }

  MHL7Reactor reactor;
  MHL7IDXFactory factory(hl7Base, hl7Definition);

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
	"hl7_msg_server::main", __LINE__,
	"Unable to register TCP listening port");
    return 1;
  }

  int status = 0;
  bool done = false;

  int shutdownFlag = 0;
  MHL7Dispatcher* dispatcher;
  MDBHL7Notification* dbHL7Notification = 0;

  if (managerType == "MSG") {
    dbHL7Notification = openMSG(databaseName);
    dispatcher = buildMMessageCollector(factory, dbHL7Notification, analysisMode, shutdownFlag);
  } else {
    logClient.log(MLogClient::MLOG_ERROR, "",
	"hl7_msg_server::main", __LINE__,
	MString("Unrecognized manager type: ") + managerType);
    return 1;
  }

  while (!done) {
    MString remoteHost = "";
    status = networkProxy->acceptConnection(remoteHost, -1);
    if (status != 0) {
      logClient.log(MLogClient::MLOG_ERROR,
	"Unable to accept connection in hl7_msg_server");
      return 1;
    }
    runConnection(dispatcher, networkProxy);
    if (shutdownFlag)
      done = true;
  }
  delete dispatcher;
  delete dbHL7Notification;

  return 0;
}
