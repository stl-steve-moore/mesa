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

// send_hl7

#define HL7SIZE 8192

#include "ctn_os.h"
#include <strstream>
#include "MESA.hpp"
#include "MHL7Factory.hpp"
#include "MHL7Msg.hpp"
#include "MHL7MessageControlID.hpp"
#include "MFileOperations.hpp"
#include "MNetworkProxyTCP.hpp"
#include "MHL7ProtocolHandlerLLP.hpp"
#include "MHL7Reactor.hpp"
#include "MHL7Dispatcher.hpp"
#include "MLogClient.hpp"

#include "MLDispatchQuery.hpp"
#include "MLDispatchQueryContinue.hpp"

static void usage()
{
  char msg[] = "\
Usage: [-b <base>] [-d <definition>] [-i] [-l log] [-n <prefix>] [-t <int>] [-q] [-Q]  host port file [file...] \n\
\n\
  -b  Set base directory for HL7 parsing rules \n\
  -c  Capture ACK message \n\
  -d  Set suffix for HL7 parsing rules \n\
  -i  Interactive mode for sending messages \n\
  -l  Set log level (default = 0) \n\
  -n  Set a prefix for Control Message IDs \n\
  -t  Set the number of times to send the designated file\n\
  -q  Enable query mode (expect an ACK and then a response\n\
  -Q  Enable query mode with continuation; multiple responses\n\
\n\
  host  Host name or IP address of remote system \n\
  port  TCP/IP port number of server application \n\
  file  One or more files to transmit";

  cerr << msg << endl;
  exit(1);
}

int main (int argc, char **argv)
{
  int newMessageControlID = 0;
  MString controlIDPrefix("");
  char path[256];
  MFileOperations f;
  bool captureAck = false;
  MString captureFileName = "";
  bool queryMode = false;
  bool continuationMode = false;
  int sendIterations = 1;

  f.expandPath(path, "MESA_TARGET", "runtime/");
  MString hl7Base(path);

  f.expandPath(path, "MESA_TARGET", "logs");
  MString logDir(path);

  MString hl7Definition(".ihe");
  MLogClient::LOGLEVEL logLevel = MLogClient::MLOG_WARN;
  int l1 = 0;

  MString proxyType = "TCP";

  while (--argc > 0 && (*++argv)[0] == '-') {
    switch(*(argv[0] + 1)) {
    case 'b':
      argc--; argv++;
      if (argc < 1)
	usage();
      hl7Base = MString(*argv) + "/";
      break;
    case 'c':
      captureAck = true;
      break;
    case 'C':
      argc--; argv++;
      if (argc < 1)
	usage();
      captureAck = true;
      captureFileName = *argv;
      break;
    case 'd':
      argc--; argv++;
      if (argc < 1)
	usage();
      hl7Definition = MString(".") + *argv;
      break;
    case 'l':
      argc--; argv++;
      if (argc < 1)
	usage();
      if (sscanf(*argv, "%d", &l1) != 1)
	 usage();
      logLevel = (MLogClient::LOGLEVEL)l1;
      break;
    case 'n':
      argc--; argv++;
      if (argc < 1)
	usage();
      controlIDPrefix = *argv;
      newMessageControlID = 1;
      break;
    case 't':
      argc--; argv++;
      if (argc < 1)
	usage();
      sendIterations = atoi(*argv);
      break;
    case 'q':
      queryMode = true;
      break;
    case 'Q':
      queryMode = true;
      continuationMode = true;
      break;
    case 's':
      proxyType = "TCP";
      break;
    default:
      cout << "Unrecognized option: " << (*++argv) << endl;
      break;
    }
  }

  if (argc < 3)
    usage();

  MLogClient logClient;
  if (logLevel != MLogClient::MLOG_NONE) {
    logClient.initialize(logLevel, logDir + "/send_hl7.log");

    logClient.log(MLogClient::MLOG_ERROR,
	"<no peer>", "send_hl7<main>", __LINE__,
	"Begin send HL7 application");
    char tmp[256];
    strstream s (tmp, sizeof(tmp));
    s << "Command line arguments: "
      << argv[0] << " "
      << argv[1] << " "
      << argv[2] << '\0';
    logClient.log(MLogClient::MLOG_VERBOSE,
	"<no peer>", "send_hl7<main>", __LINE__,
	tmp);
  }

  MHL7Factory factory(hl7Base, hl7Definition);

  MNetworkProxy* networkProxy = 0;
  if (proxyType == "TCP") {
    networkProxy = new MNetworkProxyTCP;
  } else {
    logClient.log(MLogClient::MLOG_ERROR,
	"<no peer>", "send_hl7<main>", __LINE__,
	"Unrecognized proxy type: ", proxyType);
    return 1;
  }

  MHL7ProtocolHandlerLLP *llpHandler = new MHL7ProtocolHandlerLLP(networkProxy);
  MLDispatch* dispatcher;
  if (continuationMode) {
    dispatcher = new MLDispatchQueryContinue(factory);
    dispatcher->setOutputPath(captureFileName);
  } else if (queryMode) {
    dispatcher = new MLDispatchQuery(factory);
    dispatcher->setOutputPath(captureFileName);
  } else {
    dispatcher = new MLDispatch(factory);
  }
  dispatcher->registerHandler(llpHandler);
  llpHandler->registerDispatcher(dispatcher);
  llpHandler->captureInputStream(captureAck, "");
  dispatcher->setTransactionComplete(false);

  char* dest = argv[0];
  int port = atoi(argv[1]);

  if (networkProxy->connect(dest, port) != 0) {
    cout << "Unable to connect to: " << dest << ":" << port << endl;
    return 1;
  }

  argc -= 2;
  argv += 2;

  while (argc > 0 || sendIterations > 0) {

    MHL7Msg*  msg = factory.readFromFile(*argv);
    if (msg == 0) {
      cout << "Unable to create HL7 message from: " << *argv << endl;
      return 1;
    }
    if (newMessageControlID) {
      MString id(controlIDPrefix);
      MHL7MessageControlID c;
      id += c.controlID();

      char* p = id.strData();
      msg->firstSegment();
      msg->setValue(10, 0, p);
      delete [] p;
    }

    if (llpHandler->sendHL7Message(*msg) != 0) {
      cout << "(Send HL7) Could not send message\n";
      delete msg;
      return 1;
    }

    MHL7Reactor reactor;

    reactor.registerHandler(llpHandler);
    dispatcher->registerHL7Message(msg);

    bool transactionComplete = dispatcher->transactionComplete();
    while (!transactionComplete) {
      int status = reactor.processRequests(1);
      if (status != 0) {
	transactionComplete = true;
      }
      transactionComplete = dispatcher->transactionComplete();
    }

    delete msg;

    MString ackCode = dispatcher->acknowledgementCode();
    if (queryMode == true) {
      if (dispatcher->receivedAckMessage()) {
	logClient.log(MLogClient::MLOG_ERROR,
	  "<no peer>", "send_hl7<main>", __LINE__,
	  "Received an ACK message in query mode; this is an unexpected failure");
	return 100;
      }
    } else {
      if (ackCode != "AA") {
	logClient.log(MLogClient::MLOG_WARN,
	  "<no peer>", "send_hl7<main>", __LINE__,
	  MString("Did not receive AA acknowledgement code; Acknowledgement Code is: ") + ackCode);
	  cout << "Acknowledgment Code is: " << ackCode << endl;
	return 100;
      }
    }

    argc -= 1;
    sendIterations--;
    delete dispatcher;
    if (continuationMode) {
    	dispatcher = new MLDispatchQueryContinue(factory);
	dispatcher->setOutputPath(captureFileName);
    } else if (queryMode) {
   	dispatcher = new MLDispatchQuery(factory);
	dispatcher->setOutputPath(captureFileName);
    } else {
	dispatcher = new MLDispatch(factory);
    }
    dispatcher->registerHandler(llpHandler);
    llpHandler->registerDispatcher(dispatcher);
    llpHandler->captureInputStream(captureAck, "");
    dispatcher->setTransactionComplete(false);
    
    }
  delete dispatcher;
  return 0;
}
