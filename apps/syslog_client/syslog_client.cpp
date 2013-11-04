//
//        Copyright (C) 2002, HIMSS, RSNA and Washington University
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

// File: syslog_server.cpp

#include <iostream>
#include <string>

#include "MESA.hpp"
#include "MSyslogMessage.hpp"
#include "MSyslogMessage5424.hpp"
#include "MSyslogClient.hpp"
#include "MFileOperations.hpp"
#include "MLogClient.hpp"

using namespace std;

static void usage()
{
  char msg[] = "\
Usage: [-a app] [-c] [-C cert] [-f fac] [-K key] [-M msgID] [-m mode] [-p procID] [-P peerlist] [-r rfc] [-R randoms] [-s sev] [-v] [-Z ciphers] host port arg\n\
\n\
  -a     Set appName; default is Spartacus\n\
  -c     arg is the payload to send \n\
  -f     Set facility in message; default is 10 \n\
  -M     Set message ID; default is PDQIN\n\
  -m     Set mode for syslog client class; default is 0 \n\
  -p     Set processID; default is 777\n\
  -r     Format message according to RFC\n\
  -s     Set severity in message; default is 0 \n\
  -v     Verbose mode \n\
\n\
  host   Host name of system with syslog server \n\
  port   UDP port of syslog server \n\
  arg    Payload or path to file containing message payload ";

  cerr << msg << endl;
  ::exit(1);
}

int main(int argc, char** argv)
{
  int facility = 10;
  int severity = 5;
  int mode = 0;
  bool verbose = false;
  bool isCommand = false;
  MString tmp;
  MString tag = "";
  MString appName = "Spartacus";
  MString procID  = "777";
  MString msgID   = "PDQIN";
  MString timeStamp = "";
  MString hostName  = "";
  bool flagUTF8 = true;

  int rfcType = 0;
  MString xmitRFC = "3164";
  MString randomsFile = "";
  MString keyFile = "";
  MString certificateFile = "";
  MString peerCertificateList = "";
  MString ciphers = "NULL-SHA";
  MLogClient::LOGLEVEL logLevel = MLogClient::MLOG_NONE;
  char* challenge = "NA2010";


  while (--argc > 0 && (*++argv)[0] == '-') {
    switch(*(argv[0] + 1)) {
    case 'a':
      if (argc < 1)
	usage();
      argc--; argv++;
      appName = *argv;
      break;
    case 'c':
      isCommand = true;
      break;
    case 'C':
      argc--;
      argv++;
      if (argc <= 0)
        usage();
      certificateFile = *argv;
      break;

    case 'f':
      if (argc < 1)
	usage();
      argc--; argv++;
      tmp = *argv;
      facility = tmp.intData();
      break;
    case 'j':
      argc--;
      argv++;
      if (argc <= 0)
        usage();
      challenge = *argv;
      break;
    case 'K':
      argc--;
      argv++;
      if (argc <= 0)
        usage();
      keyFile = *argv;
      break;
    case 'l':
      if (argc < 1)
	usage();
      argc--; argv++;
      tmp = *argv;
      logLevel = (MLogClient::LOGLEVEL)tmp.intData();
      break;
    case 'M':
      if (argc < 1)
	usage();
      argc--; argv++;
      msgID = *argv;
      break;
    case 'm':
      if (argc < 1)
	usage();
      argc--; argv++;
      tmp = *argv;
      mode = tmp.intData();
      break;
    case 'p':
      if (argc < 1)
	usage();
      argc--; argv++;
      procID = *argv;
      break;
    case 'P':
      argc--;
      argv++;
      if (argc <= 0)
        usage();
      peerCertificateList = *argv;
      break;
    case 'r':
      if (argc < 1)
	usage();
      argc--; argv++;
      tmp = *argv;
      rfcType = tmp.intData();
      break;

    case 'R':
      argc--;
      argv++;
      if (argc <= 0)
        usage();
      randomsFile = *argv;
      break;

    case 's':
      if (argc < 1)
	usage();
      argc--; argv++;
      tmp = *argv;
      severity = tmp.intData();
      break;
    case 't':
      if (argc < 1)
	usage();
      argc--; argv++;
      tag = *argv;
      break;
 
    case 'v':
      verbose = true;
      break;
    case 'x':
      if (argc < 1)
	usage();
      argc--; argv++;
      xmitRFC = *argv;
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

  if (argc < 3)
    usage();

  MFileOperations f;
  char logPath[1024];
  if (f.expandPath(logPath, "MESA_TARGET", "logs") != 0) {
    cout << "Unable to expand path for $MESA_TARGET/logs" << endl;
    return 1;
  }

  if (f.createDirectory(logPath) != 0) {
    cout << "Unable to create directory: " << logPath << endl;
  }

  MString logDir(logPath);
  MLogClient logClient;
  MString logName = "";
  if (logLevel != MLogClient::MLOG_NONE) {
    logName = logDir + "/syslog_client.log";
    logClient.initialize(logLevel, logName);
  }

  char* syslogHost = argv[0];
  tmp = argv[1];
  int syslogPort = tmp.intData();
  logClient.logTimeStamp(MLogClient::MLOG_VERBOSE, MString("Syslog Host ") + syslogHost);
  logClient.logTimeStamp(MLogClient::MLOG_VERBOSE, MString("Syslog Port ") + tmp);
  
  MSyslogClient c;
  c.setTestMode(mode);

  MString proxyParams = "" +
	randomsFile + ","
	+ keyFile + ","
	+ certificateFile + ","
	+ peerCertificateList + ","
	+ ciphers + ","
	+ challenge;

  int status = 0;

  if (xmitRFC == "TCP") {
    status = c.openTCP(syslogHost, syslogPort);
  } else if (xmitRFC == "3164") {
    status = c.open(syslogHost, syslogPort);
  } else if (xmitRFC == "5426") {
    status = c.open(syslogHost, syslogPort);
    logClient.logTimeStamp(MLogClient::MLOG_VERBOSE, MString("Finished opening RFC 5426 connection to: ") + syslogHost);
#ifdef RFC5425
  } else if (xmitRFC == "5425") {
    status = c.openTLS(syslogHost, syslogPort, proxyParams);
#endif
  } else {
    cout << "Unrecognized transport: " << xmitRFC << endl;
    return 1;
  }
  if (status != 0) {
    cout << "Unable to connect to server: " << syslogHost << ":" << syslogPort
	 << endl;
    return 1;
  }

  char* txt;

  if (isCommand) {
    txt = argv[2];
  } else {
    char* path = argv[2];
    txt = f.readAllText(path);
    if (txt == 0) {
      cout << "Unable to read XML text from: " << path << endl;
      return 1;
    }
  }

  if (rfcType == 0) {
    MSyslogMessage m(facility, severity, tag, txt);
    if (!isCommand)
      delete []txt;

    status = c.sendMessage(m);
    if (status != 0) {
      cout << "Unable to send message to server" << endl;
      return 1;
    }
  } else if (rfcType == 5424) {
    int version = 1;

    MSyslogMessage5424 m5424(facility, severity, version, txt, timeStamp,
	hostName, appName, procID, msgID, flagUTF8);
    if (!isCommand)
      delete []txt;

    if (xmitRFC == "TCP") {
      status = c.sendMessageTCP(m5424);
#ifdef RFC5425
    } else if (xmitRFC == "5425") {
      status = c.sendMessageTLS(m5424);
#endif
    } else if (xmitRFC == "5426") {
      status = c.sendMessage(m5424);
    } else {
      status = c.sendMessage(m5424);
    }
    if (status != 0) {
      cout << "Unable to send message to server" << endl;
      return 1;
    }

  }

  return 0;
}
