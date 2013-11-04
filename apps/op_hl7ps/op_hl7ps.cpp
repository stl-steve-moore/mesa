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
#include "MESA.hpp"

#include "MDBOrderPlacer.hpp"
#include "MLogClient.hpp"
#include "MServerAgent.hpp"
#include "MFileOperations.hpp"

#include "MHL7Acceptor.hpp"
#include "MHL7Factory.hpp"
#include "MHL7LLPHandler.hpp"
#include "MLMessenger.hpp"
//#include "MAMessenger.hpp"


int gMsgNumber=1000;		// The number of messages recieved by this server,
				// used to create file names.

static sig_atomic_t finished=0;
extern "C" void signalAction (int)
{
  finished = 1;
}

using namespace std;

static void usage()
{
  char msg[] = "\
Usage: [-a] [-b base] [-d def] [-l <level>] [-s dir] [-v] [-w] [-z db] port\n\
  -a   Use analysis mode; capture and store HL7 messages in files \n\
  -b   Set base directory for HL7 parsing rules; default is $MESA_TARGET/runtime\n\
  -d   Set suffix for HL7 parsing rules; default is ihe \n\
  -l   Set log level (0 = no logging, 4 = verbose) \n\
  -s   Set directory for log files; default is $MESA_TARGET/logs \n\
  -v   Set verbose mode for HL7 message handler \n\
  -w   HL7 handler will capture HL7 stream in a file \n\
  -z   Choose database name other than default (ordplc)\n\n\
  port TCP/IP port number to use \n\n\
Env variables MESA_TARGET and MESA_STORAGE  must be set.";

  cerr << msg << endl;
  exit(1);

}

int main(int argc, char** argv)
{ 
  bool analysisMode = false;
  MFileOperations f;
  char path[256];

  f.expandPath(path, "MESA_TARGET", "logs");
  MString logDir(path);
  f.expandPath(path, "MESA_STORAGE", "ordplc");
  MString storageDir(path);
  f.expandPath(path, "MESA_TARGET", "runtime");
  strcat(path, "/");
  MString hl7Base(path);

  MString hl7Definition(".ihe");
  MString databaseName("ordplc");
  MString returnMsgQueue("ORC");
  MString startEntityID("00000");
  MString defaultApplID("MESA_ORDPLC");
  MLogClient::LOGLEVEL logLevel = MLogClient::MLOG_NONE;
  int verbose = 0;
  int capture = 0;

  while (--argc > 0 && (*++argv)[0] == '-') {
    int l1 = 0;
    switch(*(argv[0] + 1)) {
    case 'a':
      analysisMode = true;
      break;
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
    case 'l':
      argc--;
      argv++;
      if (argc < 1)
	usage();
      if (sscanf(*argv, "%d", &l1) != 1)
	usage();
      logLevel = (MLogClient::LOGLEVEL)l1;
      break;
    case 's':
      argc--; argv++;
      if (argc < 1)
	usage();
      logDir = MString(*argv) + "/";
      break;
    case 'v':
      verbose++;
      break;
    case 'w':
      capture++;
      break;
    case 'z':
      argc--; argv++;
      if (argc < 1)
	usage();
      databaseName = *argv;
      break;
    default:
      break;
    }
  }
  if (argc < 1)
    usage();

  f.createDirectory(logDir);
  f.createDirectory(storageDir);

  if (logLevel != MLogClient::MLOG_NONE) {

    MLogClient logClient;
    logClient.initialize(logLevel, logDir + "/op_hl7ps.log");

    logClient.log(MLogClient::MLOG_VERBOSE,
	          "<no peer>", "op_hl7ps<main>", __LINE__,
	          "Begin server process");
    cerr << "op_hl7ps logging messages at level "
	 << logLevel
	 << " to "
	 << logDir + "/op_hl7ps.log"
	 << endl;
  }

  int port = atoi(*argv);

  //Write PID file
  MServerAgent a("op_hl7ps");
  a.registerServerPID();

  ACE_Reactor reactor;
  MHL7Factory factory(hl7Base, hl7Definition);
  MDBOrderPlacer orderPlacerDB (databaseName);
  MLMessenger* messenger;
#if 0
  if (analysisMode)
    messenger = new MAMessenger(factory, orderPlacerDB, logDir);
  else
    messenger = new MLMessenger (factory, orderPlacerDB, hl7Base+returnMsgQueue,
                                 startEntityID, defaultApplID);
//  messenger = new MLMessenger (factory, orderPlacerDB);
#endif
  int shutdownFlag = 0;
  messenger = new MLMessenger (factory, orderPlacerDB, hl7Base+returnMsgQueue,
                                 startEntityID, defaultApplID,
				logDir, storageDir, analysisMode, shutdownFlag);

  MHL7LLPHandler handler (*messenger);
  MHL7Acceptor acceptor (*messenger, handler);
  if (verbose)
    handler.verbose(1);

  handler.captureInputStream(capture);

  //Setup signal handler
  ACE_Sig_Action action ((ACE_SignalHandler) signalAction, SIGINT);
  if (acceptor.open (ACE_INET_Addr(port), &reactor) == -1)
    ACE_ERROR_RETURN ((LM_ERROR,
		       "%p\n",
		       " open"),
		      -1);

  ACE_DEBUG ((LM_DEBUG,
	      "(%P|%t) Firing up the Order Placer personality server on port %d\n", 
	      port));
  // Tell reactor to listen for messages:

  while (!finished) {
    reactor.handle_events();
    if (shutdownFlag != 0)
      break;
  }

  //We have been closed by a ^C signal.

  ACE_DEBUG ((LM_DEBUG,
    "(%P|%t) Shutting down the Order Placer personality server\n"));

  
//   clock = time(0);
//   ctime_r(&clock, timeStr, 32);
//   pidfile.open(name, ios::app|ios::out);
//   pidfile << "Finished: " << timeStr;
//   pidfile.close();
  a.closeServerPID();

  delete messenger;
  return 0;
}
