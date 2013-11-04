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

// File: syslog_extract.cpp

#include "ctn_os.h"
#include <fstream>

#include "MESA.hpp"

#include "MLogClient.hpp"
#include "MSyslogMessage.hpp"
#include "MFileOperations.hpp"
#include "MDBSyslogManager.hpp"
#include "MSyslogEntry.hpp"

using namespace std;

static void usage()
{
  char msg[] = "\
Usage: [serial]\n\
\n\
  serial Serial number of message to extract; if omitted, all messages";

  cerr << msg << endl;
  ::exit(1);
}

#if 0
static int
processUDPPackets(CTN_SOCKET s, char* logPath, const MString& syslogDBName)
{
  MLogClient logClient;
  struct sockaddr client_addr;
  char buffer[2048];
  int bytesRead;
  socklen_t length;
  MSyslogFactory factory;
  char fileLastLog[1024];
  char fileLastXML[1024];

  ::sprintf(fileLastLog, "%s/last_log.txt", logPath);
  ::sprintf(fileLastXML, "%s/last_log.xml", logPath);

  MDBSyslogManager* mgr = 0;
  if (syslogDBName != "") {
    mgr = new MDBSyslogManager;
    if (mgr == 0) {
	logClient.log(MLogClient::MLOG_ERROR, "no peer",
		"processUDPPackets", __LINE__,
		"unable to allocate new Syslog Manager");
      return 1;
    }
    if (mgr->initialize(syslogDBName) != 0) {
	logClient.log(MLogClient::MLOG_ERROR, "no peer",
		"processUDPPackets", __LINE__,
		"unable to initialize Syslog database: ", syslogDBName);
      return 1;
    }
  }

  MSyslogDomainXlate xlate;

  while(1) {
    length = sizeof(client_addr);
    memset(&client_addr, 0, length);

    bytesRead = ::recvfrom(s, buffer, sizeof(buffer),
		0, &client_addr, &length);
    if (bytesRead < 0) {
      ::perror("Reading datagram");
      ::exit(1);
    }
    buffer[bytesRead] = '\0';

    ofstream o(fileLastLog);
    o << buffer;

    char remoteNode[512];
    struct hostent* hp = 0;
    hp = ::gethostbyaddr(&client_addr.sa_data[2], 4, 2);
    if (hp == 0) {
      ::sprintf(remoteNode, "%-d.%-d.%-d.%-d",
		((int) client_addr.sa_data[2]) & 0xff,
		((int) client_addr.sa_data[3]) & 0xff,
		((int) client_addr.sa_data[4]) & 0xff,
		((int) client_addr.sa_data[5]) & 0xff);
    } else {
      ::strcpy(remoteNode, hp->h_name);
    }

    cout << "Remote node: " << remoteNode << endl;
    cout << buffer << endl;

    MSyslogMessage* m = factory.produceMessage(buffer, bytesRead);
    if (m == 0) {
      cout << "Could not produce message from buffer" << endl;
    } else {
      cout << *m << endl;
    }
    unsigned long messageLength = 0;
    const char* ref = m->referenceToMessage(messageLength);
    if (::strncmp(ref, "SHUTDOWN", messageLength) == 0) {
      delete m;
      break;
    }

    ofstream xmlFile(fileLastXML);
    xmlFile << ref;

    if (mgr != 0) {
      MSyslogEntry entry;
      if (xlate.translateSyslog(*m, entry) == 0) {
	logClient.log(MLogClient::MLOG_ERROR, remoteNode,
		"processUDPPackets", __LINE__,
		"about to enter new entry");
	mgr->enterRecord(entry);
      }
    }
    delete m;
  }
  return 0;
}
#endif

int main(int argc, char** argv)
{ 
  bool verbose = false;
  MString syslogDBName("syslog");
  MFileOperations f;
  char path[256];

  f.expandPath(path, "MESA_TARGET", "logs");
  MString logDir(path);
  MLogClient::LOGLEVEL logLevel = MLogClient::MLOG_ERROR;
 
  while (--argc > 0 && (*++argv)[0] == '-') {
    int l1 = 0;
    switch(*(argv[0] + 1)) {
    case 'd':
      argc--; argv++;
      if (argc < 1)
	usage();
      syslogDBName = *argv;
      break;

    case 'l':
      argc--; argv++;
      if (argc < 1)
	usage();
      if (::scanf(*argv, "%d", &l1) != 1)
	usage();
      logLevel = (MLogClient::LOGLEVEL)l1;
      break;

    case 'v':
      verbose = true;
      break;

    default:
      break;
    }
  }

  char logPath[1024];
  if (f.expandPath(logPath, "MESA_TARGET", "logs/syslog") != 0) {
    cout << "Unable to expand path for $MESA_TARGET/logs" << endl;
    return 1;
  }

  if (f.createDirectory(logPath) != 0) {
    cout << "Unable to create directory: " << logPath << endl;
    return 1;
  }

  MDBSyslogManager* mgr = 0;
  mgr = new MDBSyslogManager;
  if (mgr == 0) {
    cout << "Unable to allocate new Syslog Manager" << endl;
    return 1;
  }
  if (mgr->initialize(syslogDBName) != 0) {
    cout << "Unable to initialize Syslog database: " << syslogDBName << endl;
    return 1;
  }

  MSyslogEntryVector v;
  MSyslogEntry e;
  if (argc > 0) {
    e.identifier(*argv);
  }

  int status = mgr->selectRecord(e, v);

  MSyslogEntryVector::iterator it = v.begin();
  for (; it != v.end(); it++) {
    cout << endl;
    cout << *it << endl;
    MString fullPath = logDir + "/syslog/" + (*it).identifier() + ".xml";

    const char* p = fullPath.strData();

    ofstream x(p);
    x << (*it).message();
  }

  return 0;
}
