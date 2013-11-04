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
#include "MSyslogMessage5424.hpp"
#include "MSyslogClient.hpp"
#include "MFileOperations.hpp"

using namespace std;

static void usage()
{
  char msg[] = "\
Usage: [-c] [-f fac] [-m mode] [-s sev] [-v] test_number host port arg\n\
\n\
  -c     arg is the payload to send \n\
  -f     Set facility in message; default is 10 \n\
  -m     Set mode for syslog client class; default is 0 \n\
  -s     Set severity in message; default is 0 \n\
  -v     Verbose mode \n\
\n\
  host   Host name of system with syslog server \n\
  port   UDP port of syslog server \n\
  arg    Payload or path to file containing message payload ";

  cerr << msg << endl;
  ::exit(1);
}

static void dump_header(MSyslogMessage5424& m)
{
  char txt[1024] = "";
  int bufferLength = 0;
  int exportedLength = 0;

  bufferLength = 1023;
  m.exportHeader(txt, bufferLength, exportedLength);
  txt[exportedLength] = '\0';
  cout << exportedLength << " Header: @:" << txt << ":@" << endl;

}

static void dump_header_payload(MSyslogMessage5424& m)
{
  dump_header(m);
  char txt[16384] = "";
  int bufferLength = 16383;
  int exportedLength = 0;

  m.exportMessage(txt, bufferLength, exportedLength);
  txt[exportedLength] = '\0';
  cout << exportedLength << " Message: @:" << txt << ":@" << endl;
}

static void dump_total_message(MSyslogMessage5424& m)
{
  char txt[16384] = "";
  int bufferLength = 16383;
  int exportedLength = 0;

  m.exportHeader(txt, bufferLength, exportedLength);
  txt[exportedLength] = '\0';
  cout <<  txt;

  bufferLength = 16383;
  m.exportMessage(txt, bufferLength, exportedLength);
  txt[exportedLength] = '\0';
  cout << txt;
}

static int test0(int argc, char** argv)
{
  int facility = 1;
  int severity = 2;
  int version  = 0;
//  MString tag = "3";
  MString message = "<xml>payload</xml>";
  MString timeStamp = "";
  MString hostName  = "";
  MString appName = "app-name";
  MString procID  = "proc-id";
  MString msgID   = "msg-id";

  MSyslogMessage5424 *m = new MSyslogMessage5424(facility, severity, version, message, timeStamp, hostName,
	appName, procID, msgID);
  dump_header(*m);
  delete m;

  version = 12;
  m = new MSyslogMessage5424(facility, severity, version, message, timeStamp, hostName,
	appName, procID, msgID);
  dump_header(*m);
  delete m;

  version = 321;
  m = new MSyslogMessage5424(facility, severity, version, message, timeStamp, hostName,
	appName, procID, msgID);
  dump_header(*m);
  delete m;

  version = 1000;
  m = new MSyslogMessage5424(facility, severity, version, message, timeStamp, hostName,
	appName, procID, msgID);
  dump_header(*m);
  delete m;

  version = 0;
  appName = "";
  m = new MSyslogMessage5424(facility, severity, version, message, timeStamp, hostName,
	appName, procID, msgID);
  dump_header(*m);
  delete m;

  appName = "app";
  procID = "";
  m = new MSyslogMessage5424(facility, severity, version, message, timeStamp, hostName,
	appName, procID, msgID);
  dump_header(*m);

  appName = "app";
  procID = "process";
  msgID = "";
  m = new MSyslogMessage5424(facility, severity, version, message, timeStamp, hostName,
	appName, procID, msgID);
  dump_header(*m);

  appName = "";
  procID = "";
  msgID = "";
  m = new MSyslogMessage5424(facility, severity, version, message, timeStamp, hostName,
	appName, procID, msgID);
  dump_header(*m);

  return 0;
}

static int test1(int argc, char** argv)
{
  int facility = 1;
  int severity = 2;
  int version  = 0;
//  MString tag = "3";
  MString message = "<xml>payload</xml>";
  MString timeStamp = "";
  MString hostName  = "";
  MString appName = "app-name";
  MString procID  = "proc-id";
  MString msgID   = "msg-id";
  bool flagUTF8 = true;

  MSyslogMessage5424 *m = new MSyslogMessage5424(facility, severity, version, message, timeStamp, hostName,
	appName, procID, msgID, flagUTF8);
  dump_header_payload(*m);
  delete m;

#if 0
  version = 12;
  m = new MSyslogMessage5424(facility, severity, version, message, timeStamp, hostName,
	appName, procID, msgID);
  dump_header(*m);
  delete m;

  version = 321;
  m = new MSyslogMessage5424(facility, severity, version, message, timeStamp, hostName,
	appName, procID, msgID);
  dump_header(*m);
  delete m;

  version = 1000;
  m = new MSyslogMessage5424(facility, severity, version, message, timeStamp, hostName,
	appName, procID, msgID);
  dump_header(*m);
  delete m;

  version = 0;
  appName = "";
  m = new MSyslogMessage5424(facility, severity, version, message, timeStamp, hostName,
	appName, procID, msgID);
  dump_header(*m);
  delete m;

  appName = "app";
  procID = "";
  m = new MSyslogMessage5424(facility, severity, version, message, timeStamp, hostName,
	appName, procID, msgID);
  dump_header(*m);

  appName = "app";
  procID = "process";
  msgID = "";
  m = new MSyslogMessage5424(facility, severity, version, message, timeStamp, hostName,
	appName, procID, msgID);
  dump_header(*m);

  appName = "";
  procID = "";
  msgID = "";
  m = new MSyslogMessage5424(facility, severity, version, message, timeStamp, hostName,
	appName, procID, msgID);
  dump_header(*m);
#endif

  return 0;
}

static int test2(int argc, char** argv)
{
  int facility = 10;
  int severity = 5;
  int version  = 0;

  MString message = "<xml>payload</xml>";
  MString timeStamp = "";
  MString hostName  = "";
  MString appName = "Spartacus";
  MString procID  = "777";
  MString msgID   = "PDQIN";
  bool flagUTF8 = true;

  MSyslogMessage5424 *m = new MSyslogMessage5424(facility, severity, version, message, timeStamp, hostName,
	appName, procID, msgID, flagUTF8);
  dump_total_message(*m);
  delete m;

  return 0;
}

static int test3(int argc, char** argv)
{
  int facility = 10;
  int severity = 4;
  int version  = 0;

  MString message = "<xml>payload</xml>";
  MString timeStamp = "";
  MString hostName  = "";
  MString appName = "Spartacus";
  MString procID  = "777";
  MString msgID   = "PDQIN";
  bool flagUTF8 = true;

  MSyslogMessage5424 *m = new MSyslogMessage5424(facility, severity, version, message, timeStamp, hostName,
	appName, procID, msgID, flagUTF8);
  dump_total_message(*m);
  delete m;

  return 0;
}

static int test4(int argc, char** argv)
{
  int facility = 10;
  int severity = 5;
  int version  = 0;

  MString message = "<xml>payload</xml>";
  MString timeStamp = "";
  MString hostName  = "";
  MString appName = "Spartacus";
  MString procID  = "777";
  MString msgID   = "PDQIN";
  bool flagUTF8 = false;

  MSyslogMessage5424 *m = new MSyslogMessage5424(facility, severity, version, message, timeStamp, hostName,
	appName, procID, msgID, flagUTF8);
  dump_total_message(*m);
  delete m;

  return 0;
}




int main(int argc, char** argv)
{
  int facility = 10;
  int severity = 0;
  int mode = 0;
  bool verbose = false;
  bool isCommand = false;
  MString tmp;
  MString tag = "";

  while (--argc > 0 && (*++argv)[0] == '-') {
    switch(*(argv[0] + 1)) {
    case 'c':
      isCommand = true;
      break;
    case 'f':
      if (argc < 1)
	usage();
      argc--; argv++;
      tmp = *argv;
      facility = tmp.intData();
      break;
    case 'm':
      if (argc < 1)
	usage();
      argc--; argv++;
      tmp = *argv;
      mode = tmp.intData();
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

    default:
      break;
    }
  }

  if (argc < 1)
    usage();

  tmp = argv[0];
  int testNumber = tmp.intData();
  int rtn = 1;

  switch (testNumber) {
    case 0:
      rtn = test0(argc, argv);
      break;
    case 1:
      rtn = test1(argc, argv);
      break;
    case 2:
      rtn = test2(argc, argv);
      break;
    case 3:
      rtn = test3(argc, argv);
      break;
    case 4:
      rtn = test4(argc, argv);
      break;
    default:
      cout << "Undefined test: " << argv[0] << endl;
      break;
  }

#if 0
  char* syslogHost = argv[0];
  tmp = argv[1];
  int syslogPort = tmp.intData();

  MSyslogClient c;
  c.setTestMode(mode);

  int status = c.open(syslogHost, syslogPort);
  if (status != 0) {
    cout << "Unable to connect to server" << endl;
    return 1;
  }

  char* txt;
  if (isCommand) {
    txt = argv[2];
  } else {
    char* path = argv[2];
    MFileOperations f;
    txt = f.readAllText(path);
    if (txt == 0) {
      cout << "Unable to read XML text from: " << path << endl;
      return 1;
    }
  }

  MSyslogMessage5424 m(facility, severity, tag, txt);
  if (!isCommand)
    delete []txt;

  status = c.sendMessage(m);
  if (status != 0) {
    cout << "Unable to send message to server" << endl;
    return 1;
  }

#endif
  return 0;
}
