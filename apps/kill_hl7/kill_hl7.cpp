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

// kill_hl7

#define HL7SIZE 8192

#include "ctn_os.h"
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


static void usage()
{
  char msg[] = "\
Usage: [-b base] [-d def] [-e event] [-i] [-n prefix] [-v] host port \n\
\n\
  -b  Set base directory for HL7 parsing rules \n\
  -d  Set suffix for HL7 parsing rules \n\
  -e  Set the event code; default is KIL \n\
  -i  Interactive mode for sending messages \n\
  -n  Set a prefix for Control Message IDs \n\
  -v  Verbose mode \n\
\n\
  host  Host name or IP address of remote system \n\
  port  TCP/IP port number of server application";

  cerr << msg << endl;
  ::exit(1);
}

static
MHL7Msg* produceKillMsg(MHL7Factory& factory, const MString& killEvent) {

  MHL7Msg*  msg = factory.produce();

  msg->insertSegment("MSH");

  msg->setValue("MSH", 1, 0, "|");
  msg->setValue("MSH", 2, 0, "^~\\&");
  msg->setValue("MSH", 3, 0, "KILL_HL7");
  msg->setValue("MSH", 4, 0, "MESA");
  msg->setValue("MSH", 5, 0, "MESA_SERVER");
  msg->setValue("MSH", 6, 0, "MESA");
  MString msgType = MString("XXX^") + killEvent;
  msg->setValue("MSH", 9, 0, msgType);
  msg->setValue("MSH", 11, 0, "P");
  msg->setValue("MSH", 12, 0, "2.3.1");

  return msg;
}

int main (int argc, char **argv)
{
  int aceStatus=0;
  int newMessageControlID = 0;
  MString controlIDPrefix("");
  char path[256];
  MFileOperations f;

  f.expandPath(path, "MESA_TARGET", "runtime/");
  MString hl7Base(path);

  f.expandPath(path, "MESA_TARGET", "logs");
  MString logDir(path);

  MString hl7Definition(".ihe");
  MLogClient::LOGLEVEL logLevel = MLogClient::MLOG_NONE;
  int l1 = 0;

  MString proxyType = "TCP";
  MString eventType("KIL");

  while (--argc > 0 && (*++argv)[0] == '-') {
    switch(*(argv[0] + 1)) {
    case 'b':
      argc--; argv++;
      if (argc < 1)
	usage();
      hl7Base = MString(*argv) + "/";
      break;
    case 'd':
      argc--; argv++;
      if (argc < 1)
	usage();
      hl7Definition = MString(".") + *argv;
      break;
    case 'e':
      argc--; argv++;
      if (argc < 1)
	usage();
      eventType = *argv;
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
    }
  }

  if (argc < 2)
    usage();

  MLogClient logClient;
  if (logLevel != MLogClient::MLOG_NONE) {
    logClient.initialize(logLevel, logDir + "/send_hl7.log");

    logClient.log(MLogClient::MLOG_ERROR,
                  "<no peer>", "kill_hl7<main>", __LINE__,
                  "Begin kill HL7 application");
  }

  MHL7Factory factory(hl7Base, hl7Definition);

  MNetworkProxy* networkProxy = 0;
  if (proxyType == "TCP") {
    networkProxy = new MNetworkProxyTCP;
  } else {
    logClient.log(MLogClient::MLOG_ERROR,
		"<no peer>", "kill_hl7<main>", __LINE__,
		"Unrecognized proxy type: ", proxyType);
    return 1;
  }

  MHL7ProtocolHandlerLLP *llpHandler = new MHL7ProtocolHandlerLLP(networkProxy);
  MHL7Dispatcher dispatcher(factory);
  dispatcher.registerHandler(llpHandler);
  llpHandler->registerDispatcher(&dispatcher);

  char* dest = argv[0];
  int port = atoi(argv[1]);

  if (networkProxy->connect(dest, port) != 0) {
    cout << "Unable to connect to: " << dest << ":" << port << endl;
    return 1;
  }

  argc -= 2;
  argv += 2;

  MHL7Msg* msg = produceKillMsg(factory, eventType);

  {
    if (msg == 0) {
      cout << "Unable to create HL7 message from: " << eventType << endl;
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

    reactor.processRequests(1);

    delete msg;
    argc -= 1;
  }

  return 0;
}
