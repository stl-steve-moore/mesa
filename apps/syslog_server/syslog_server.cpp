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

#include "ctn_os.h"
#include <fstream>
#include <iostream>
#include <iomanip>


#include "MESA.hpp"

#include "MAcceptor.hpp"
#include "MSyslogMessage.hpp"
#include "MSyslogMessage5424.hpp"
#include "MSyslogFactory.hpp"
#include "MFileOperations.hpp"
#include "MDBSyslogManager.hpp"
#include "MLogClient.hpp"
#include "MSyslogDomainXlate.hpp"
#include "MSyslogEntry.hpp"
#include "MNetworkProxy.hpp"
#include "MNetworkProxyTCP.hpp"
#ifdef RFC5425
#include "MNetworkProxyTLS.hpp"
#endif

using namespace std;

static void logNewConnection(MLogClient& logClient, const MString& remoteHost, const MString& ciphers);
static void logCloseConnection(MLogClient& logClient, const MString& remoteHost);

static void usage()
{
  char msg[] = "\
Usage: [-C cert] [-d db] [-K key] [-l level] [-P peer] [-R randoms] [-r rfc] [-v] [-x rfc] [-Z ciphers]  port\n\
\n\
  -C   File containing certificate for this application\n\
  -d   Set database name to store messages; default is syslog \n\
  -K   File containing private key for this application\n\
  -l   Set loglevel (0-4); default is 1 (error) \n\
  -P   File with list of peer certificates (might just be CA certificate\n\
  -R   File containing random numbers to initialze toolkit\n\
  -r   Receive messages formatted according to RFC (e.g., 5424)\n\
  -x   Use RFC as transmission mode (0, 5425, 5426)\n\
  -v   Enable verbose mode \n\
  -Z   List of ciphers (A:B:C)\n\
\n\
  port UDP port number of server";

  cerr << msg << endl;
  ::exit(1);
}

static void
detectAndDumpBOM(const unsigned char* payload)
{
  MLogClient logClient;

  bool bom = true;
  if (payload[0] != 0xef) bom = false;
  if (payload[1] != 0xbb) bom = false;
  if (payload[2] != 0xbf) bom = false;

  MString bomString = "BOM Detected: TRUE";
  if (!bom) { bomString = "BOM Detected: FALSE"; }
  logClient.logTimeStamp(MLogClient::MLOG_WARN, bomString);

  char txt[256] = "";
  char txt2[256] = "";
  strstream x(txt,  sizeof txt);
  strstream y(txt2, sizeof txt2);
  x << "Beginning of payload: ";
  y << "Beginning of payload: ";

  int idx = 0;
  for (idx = 0; idx < 20; idx++) {
    unsigned short b = (unsigned short)*payload; payload++;
    x << hex << setw(2) << setfill('0') << b << ' ' << dec;
    if (b < 0x20 || b > 0x7e) {
       y << ".  " ;
    } else {
       y << (char)b << "  ";
    }
  }
  x << '\0';
  y << '\0';
  logClient.logTimeStamp(MLogClient::MLOG_WARN, txt);
  logClient.logTimeStamp(MLogClient::MLOG_WARN, txt2);

}


static void
dumpToFolder(const char* logPath, const char* remoteNode, const char* transport, const unsigned char* buffer, const unsigned char* payload)
{
  MLogClient logClient;
  char date[20] = "";
  char time[30] = "";
  ::UTL_GetDicomDate(date);
  ::UTL_GetDicomTime(time);
  time[6] = '\0';
  MFileOperations f;

  char hostFolder[1024] = "";
  ::sprintf(hostFolder, "%s/%s", logPath, remoteNode);
  f.createDirectory(logPath);
  f.createDirectory(hostFolder);

  {
    char fileName[1024] = "";
    ::sprintf(fileName, "%s/%s_%s_%s_packet.txt", hostFolder, date, time, transport);
    ofstream thisMessage(fileName, ios_base::trunc);
    thisMessage << buffer;
    thisMessage.close();
  }
  {
    char fileName[1024] = "";
    ::sprintf(fileName, "%s/%s_%s_%s_payload.txt", hostFolder, date, time, transport);
    ofstream thisMessage(fileName, ios_base::trunc);
    thisMessage << payload;
    thisMessage.close();
  }
  {
    char fileName[1024] = "";
    ::sprintf(fileName, "%s/last_log.txt", logPath);
    ofstream thisMessage(fileName, ios_base::trunc);
    thisMessage << buffer;
    thisMessage.close();
  }
  bool bom = true;
  if (payload[0] != 0xef) bom = false;
  if (payload[1] != 0xbb) bom = false;
  if (payload[2] != 0xbf) bom = false;

  const unsigned char* p = payload;
  if (bom) p += 3;

  {
    char fileName[1024] = "";
    ::sprintf(fileName, "%s/%s_%s_%s_payload.xml", hostFolder, date, time, transport);
    ofstream thisMessage(fileName, ios_base::trunc);
    thisMessage << p;
    thisMessage.close();
    if (!bom) {
      logClient.logTimeStamp(MLogClient::MLOG_WARN, "Expected to find BOM at the front of this payload, but did not");
      logClient.logTimeStamp(MLogClient::MLOG_WARN, MString("Please inspect the file: ") + fileName);
    }
  }
  {
    char fileName[1024] = "";
    ::sprintf(fileName, "%s/last_log.xml", logPath);
    ofstream thisMessage(fileName, ios_base::trunc);
    thisMessage << p;
    thisMessage.close();
  }
}

static int
processUDPPackets(CTN_SOCKET s, char* logPath, const MString& syslogDBName, int rfcType)
{
  MLogClient logClient;
  struct sockaddr client_addr;
  unsigned char buffer[32768];
  int bytesRead;
#ifdef MESA_USE_SOCKLEN_T
  socklen_t length;
#else
  int length;
#endif
  MSyslogFactory factory;
  char fileLastLog[32768];
  char fileLastXML[32768];

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

    bytesRead = ::recvfrom(s, (char*)buffer, sizeof(buffer),
		0, &client_addr, &length);
    if (bytesRead < 0) {
      logClient.log(MLogClient::MLOG_ERROR, "",
		"processUDPPackets", __LINE__,
		MString("unable to receive packet from socket"));
      ::perror("Reading datagram");
      continue;
    }
    buffer[bytesRead] = '\0';

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
    logClient.log(MLogClient::MLOG_CONVERSATION, remoteNode,
		"processUDPPackets", __LINE__,
		"syslog buffer is: ", (const char*)buffer);

    //cout << "Remote node: " << remoteNode << endl;
    //cout << buffer << endl;

    if (rfcType == 5424) {
      MSyslogMessage5424* m = factory.produceMessage5424(buffer, bytesRead);
      if (m == 0) {
        logClient.log(MLogClient::MLOG_ERROR, remoteNode,
		"processUDPPackets", __LINE__,
		"unable to parse the syslog stream in current packet;",
		" most likely cause is a header that confused our parser");
        continue;
      } else {
        //cout << *m << endl;
      }
      unsigned long messageLength = 0;
      const unsigned char* ref = m->referenceToMessage(messageLength);
      if (::strncmp((const char*)ref, "<SHUTDOWN/>", messageLength) == 0) {
        delete m;
        break;
      }
      if (::strncmp((const char*)(ref+3), "<SHUTDOWN/>", messageLength-3) == 0) {
        delete m;
        break;
      }

      detectAndDumpBOM(ref);

      dumpToFolder(logPath,
	remoteNode,
	"5426",
	buffer,
	ref);
//dumpToFolder(const char* logPath, const char* remoteNode, char* transport, const char* buffer, const unsigned char* payload)

#if 0
      if (mgr != 0) {
        MSyslogEntry entry;
        if (xlate.translateSyslog(*m, entry) == 0) {
	  logClient.log(MLogClient::MLOG_VERBOSE, remoteNode,
		"processUDPPackets", __LINE__,
		"about to enter new entry");
	  mgr->enterRecord(entry);
        }
      }
#endif
      delete m;
      logClient.log(MLogClient::MLOG_VERBOSE, remoteNode,
		"processUDPPackets", __LINE__,
		"Finished processing current packet");
    } else {
      MSyslogMessage* m = factory.produceMessage(buffer, bytesRead);
      if (m == 0) {
        logClient.log(MLogClient::MLOG_ERROR, remoteNode,
		"processUDPPackets", __LINE__,
		"unable to parse the syslog stream in current packet;",
		" most likely cause is a header that confused our parser");
        continue;
      } else {
        //cout << *m << endl;
      }
      unsigned long messageLength = 0;
      const unsigned char* ref = m->referenceToMessage(messageLength);
      if (::strncmp((const char*)ref, "<SHUTDOWN/>", messageLength) == 0) {
        delete m;
        break;
      }

      if (mgr != 0) {
        MSyslogEntry entry;
        if (xlate.translateSyslog(*m, entry) == 0) {
	  logClient.log(MLogClient::MLOG_VERBOSE, remoteNode,
		"processUDPPackets", __LINE__,
		"about to enter new entry");
	  mgr->enterRecord(entry);
        }
      }
      delete m;
      logClient.log(MLogClient::MLOG_VERBOSE, remoteNode,
		"processUDPPackets", __LINE__,
		"Finished processing current packet");
    }
  }
  return 0;
}

static int
processTCPPackets(MNetworkProxy& n, char* logPath, const MString& syslogDBName, int rfcType,
	const MString& ciphers)
{
  MLogClient logClient;
  struct sockaddr client_addr;
  char buffer[32768];
  int bytesRead;
#ifdef MESA_USE_SOCKLEN_T
  socklen_t length;
#else
  int length;
#endif
  MSyslogFactory factory;
//  char fileLastLog[32768];
//  char fileLastXML[32768];

//  ::sprintf(fileLastLog, "%s/last_log.txt", logPath);
//  ::sprintf(fileLastXML, "%s/last_log.xml", logPath);

  MDBSyslogManager* mgr = 0;
  if (syslogDBName != "") {
    mgr = new MDBSyslogManager;
    if (mgr == 0) {
	logClient.log(MLogClient::MLOG_ERROR, "no peer",
		"processTCPPackets", __LINE__,
		"unable to allocate new Syslog Manager");
      return 1;
    }
    if (mgr->initialize(syslogDBName) != 0) {
	logClient.log(MLogClient::MLOG_ERROR, "no peer",
		"processTCPPackets", __LINE__,
		"unable to initialize Syslog database: ", syslogDBName);
      return 1;
    }
  }

  MSyslogDomainXlate xlate;
  while (1) {
    MString remoteHost = "";
    if (n.acceptConnection(remoteHost, -1) != 0) {
      logClient.logTimeStamp(MLogClient::MLOG_ERROR, "Unable to receive TCP connection");
      return 1;
    }
    logNewConnection(logClient, remoteHost, ciphers);
    bool socketOpen = true;
    unsigned char buffer[16384] = "";
    char tmpBuffer[1024] = "";
    int ix = 0;
    int bytesRead = 0;
    int toRead = 0;
    logClient.logTimeStamp(MLogClient::MLOG_VERBOSE,
	"processTCPPackets: about to read bytes to find package length");
    while ((bytesRead = n.readExactlyNBytes(tmpBuffer+ix, 1)) > 0) {
      // This is all debugging stuff
      char txt[512] = "";
      strstream z(txt, sizeof txt);
      unsigned short b = (unsigned short)tmpBuffer[ix];
      z << "Byte: 0x" << hex << setw(2) << setfill('0') << b << '\0' << dec;
      logClient.log(MLogClient::MLOG_VERBOSE, txt);
      tmpBuffer[ix+1] = '\0';
      strstream y(txt, sizeof txt);
      y << "Current text for length of message: " << tmpBuffer << '\0';
      logClient.log(MLogClient::MLOG_VERBOSE, txt);

      // This is the real work, looking for the end of the length part of the message.
      if (tmpBuffer[ix] == ' ') {
	tmpBuffer[ix] = '\0';
	MString xx(tmpBuffer);
	toRead = xx.intData();
	break;
      }
      ix++;
    }
    if (bytesRead <= 0) {
      logClient.logTimeStamp(MLogClient::MLOG_ERROR, "Socket closed reading msg length");
      socketOpen = false;
      logCloseConnection(logClient, remoteHost);
      break;
    }
    ix = 0;
    while (socketOpen && (toRead > 0) &&((bytesRead = n.readUpToNBytes(buffer+ix, toRead))) > 0) {
      buffer[ix + bytesRead] = '\0';
      ix += bytesRead;
      toRead -= bytesRead;
    }
    if (bytesRead <= 0) {
      socketOpen = false;
      logCloseConnection(logClient, remoteHost);
    } else {

      char remoteNode[512]="";
      remoteHost.safeExport(remoteNode, sizeof remoteNode);

      logClient.log(MLogClient::MLOG_CONVERSATION, remoteNode,
		"processTCPPackets", __LINE__,
		"syslog buffer is: ->>", (const char*)buffer);

      if (rfcType == 5424) {
	MSyslogMessage5424* m = factory.produceMessage5424(buffer, bytesRead);
	if (m == 0) {
          logClient.log(MLogClient::MLOG_ERROR, remoteNode,
		"processTCPPackets", __LINE__,
		"unable to parse the syslog stream in current packet;",
		" most likely cause is a header that confused our parser");
	  continue;
	} else {
	  //cout << *m << endl;
	}
	unsigned long messageLength = 0;
	const unsigned char* ref = m->referenceToMessage(messageLength);
	if (::strncmp((const char*)ref, "<SHUTDOWN/>", messageLength) == 0) {
	  delete m;
	  break;
	}
	if (::strncmp((const char*)(ref+3), "<SHUTDOWN/>", messageLength-3) == 0) {
	  delete m;
	  break;
	}
        detectAndDumpBOM(ref);
	dumpToFolder(logPath, remoteNode, "5425", buffer, ref);

#if 0
	if (mgr != 0) {
	  MSyslogEntry entry;
	  if (xlate.translateSyslog(*m, entry) == 0) {
	    logClient.log(MLogClient::MLOG_VERBOSE, remoteNode,
		"processTCPPackets", __LINE__,
		"about to enter new entry");
	    mgr->enterRecord(entry);
	  }
	}
#endif
	delete m;
	logClient.log(MLogClient::MLOG_VERBOSE, remoteNode,
		"processTCPPackets", __LINE__,
		"Finished processing current packet");
      } else {
	MSyslogMessage* m = factory.produceMessage(buffer, bytesRead);
	if (m == 0) {
	  logClient.log(MLogClient::MLOG_ERROR, "remoteNode",
		"processTCPPackets", __LINE__,
		"unable to parse the syslog stream in current packet;",
		" most likely cause is a header that confused our parser");
	  continue;
	} else {
	  //cout << *m << endl;
	}
	unsigned long messageLength = 0;
	const unsigned char* ref = m->referenceToMessage(messageLength);
	if (::strncmp((const char*)ref, "<SHUTDOWN/>", messageLength) == 0) {
	  delete m;
	  break;
	}

	if (mgr != 0) {
	  MSyslogEntry entry;
	  if (xlate.translateSyslog(*m, entry) == 0) {
	  logClient.log(MLogClient::MLOG_VERBOSE, remoteNode,
		"processTCPPackets", __LINE__,
		"about to enter new entry");
	  mgr->enterRecord(entry);
	  }
	}
	delete m;
	logClient.log(MLogClient::MLOG_VERBOSE, remoteNode,
		"processTCPPackets", __LINE__,
		"Finished processing current packet");
        logCloseConnection(logClient, remoteHost);
      }
    }
  }

  return 0;
}

static int evalTimeStamp(const MString& timeStamp)
{
  int rtnStatus = 0;			// Assume success
  MLogClient logClient;
  char x[1024] = "";
  timeStamp.safeExport(x, (sizeof x)-1);
  char msg[2048] = "";
  char endOfString[] = "Reached end of time stamp; it must be incomplete";

  int yr = 0;
  char* p = x;
  while (isdigit(*p) && p != &x[4]) {
    yr = (yr * 10) + (*p - '0');
    p++;
  }
  if (p != &x[4]) {
    strstream z(msg, sizeof msg);
    z << "The YYYY component of the time stamp did not have 4 digits: " << x << '\0';
    logClient.log(MLogClient::MLOG_ERROR, msg);
    rtnStatus = 1;
  }
  if (yr < 1950 || yr > 2050) {
    strstream z(msg, sizeof msg);
    z << "Year not in expected range of 1950-2050: " << yr << '\0';
    logClient.log(MLogClient::MLOG_ERROR, msg);
    rtnStatus = 1;
  }

  if (*p == 0) { logClient.log(MLogClient::MLOG_ERROR,endOfString); return 1;}
  if (*p != '-') {
    strstream z(msg, sizeof msg);
    z << "Delimiter after YYYY shall be '-': " << p << '\0';
    logClient.log(MLogClient::MLOG_ERROR, msg);
    rtnStatus = 1;
  }
  p++;

  if (p[0] == 0 || p[1] == 0) { logClient.log(MLogClient::MLOG_ERROR,endOfString); return 1;}
  if (!isdigit(p[0]) && !isdigit(p[1])) {
    strstream z(msg, sizeof msg);
    z << "MM is not two digits as expected: " << p << '\0';
    logClient.log(MLogClient::MLOG_ERROR, msg);
    rtnStatus = 1;
  }
  int mm = (p[0]-'0')*10 + (p[1]-'0');
  if (mm < 1 || mm > 12) {
    strstream z(msg, sizeof msg);
    z << "Month not in expected range of 1-12: " << mm << '\0';
    logClient.log(MLogClient::MLOG_ERROR, msg);
    rtnStatus = 1;
  }
  p += 2;

  if (*p == 0) { logClient.log(MLogClient::MLOG_ERROR,endOfString); return 1;}
  if (*p != '-') {
    strstream z(msg, sizeof msg);
    z << "Delimiter after MM shall be '-': " << p << '\0';
    logClient.log(MLogClient::MLOG_ERROR, msg);
    rtnStatus = 1;
  }
  p++;

  if (p[0] == 0 || p[1] == 0) { logClient.log(MLogClient::MLOG_ERROR,endOfString); return 1;}
  if (!isdigit(p[0]) && !isdigit(p[1])) {
    strstream z(msg, sizeof msg);
    z << "DD is not two digits as expected: " << p << '\0';
    logClient.log(MLogClient::MLOG_ERROR, msg);
    rtnStatus = 1;
  }
  int dd = (p[0]-'0')*10 + (p[1]-'0');
  if (dd < 1 || dd > 31) {
    strstream z(msg, sizeof msg);
    z << "Date not in expected range of 1-31: " << dd << '\0';
    logClient.log(MLogClient::MLOG_ERROR, msg);
    rtnStatus = 1;
  }
  p += 2;

  if (*p == 0) { logClient.log(MLogClient::MLOG_ERROR,endOfString); return 1;}
  if (*p != 'T') {
    strstream z(msg, sizeof msg);
    z << "Delimiter after DD shall be 'T': " << p << '\0';
    logClient.log(MLogClient::MLOG_ERROR, msg);
    rtnStatus = 1;
  }
  p++;

  if (p[0] == 0 || p[1] == 0) { logClient.log(MLogClient::MLOG_ERROR,endOfString); return 1;}
  if (!isdigit(p[0]) && !isdigit(p[1])) {
    strstream z(msg, sizeof msg);
    z << "HH is not two digits as expected: " << p << '\0';
    logClient.log(MLogClient::MLOG_ERROR, msg);
    rtnStatus = 1;
  }
  int hh = (p[0]-'0')*10 + (p[1]-'0');
  if (hh < 0 || hh > 23) {
    strstream z(msg, sizeof msg);
    z << "Hour not in expected range of 0-23: " << hh << '\0';
    logClient.log(MLogClient::MLOG_ERROR, msg);
    rtnStatus = 1;
  }
  p += 2;

  if (*p == 0) { logClient.log(MLogClient::MLOG_ERROR,endOfString); return 1;}
  if (*p != ':') {
    strstream z(msg, sizeof msg);
    z << "Delimiter after HH shall be ':': " << p << '\0';
    logClient.log(MLogClient::MLOG_ERROR, msg);
    rtnStatus = 1;
  }
  p++;

  if (p[0] == 0 || p[1] == 0) { logClient.log(MLogClient::MLOG_ERROR,endOfString); return 1;}
  if (!isdigit(p[0]) && !isdigit(p[1])) {
    strstream z(msg, sizeof msg);
    z << "Minutes (MM) is not two digits as expected: " << p << '\0';
    logClient.log(MLogClient::MLOG_ERROR, msg);
    rtnStatus = 1;
  }
  int minutes = (p[0]-'0')*10 + (p[1]-'0');
  if (minutes < 0 || minutes > 59) {
    strstream z(msg, sizeof msg);
    z << "Minutes not in expected range of 0-59: " << minutes << '\0';
    logClient.log(MLogClient::MLOG_ERROR, msg);
    rtnStatus = 1;
  }
  p += 2;

  if (*p == 0) { logClient.log(MLogClient::MLOG_ERROR,endOfString); return 1;}
  if (*p != ':') {
    strstream z(msg, sizeof msg);
    z << "Delimiter after Minutes shall be ':': " << p << '\0';
    logClient.log(MLogClient::MLOG_ERROR, msg);
    rtnStatus = 1;
  }
  p++;

  if (p[0] == 0 || p[1] == 0) { logClient.log(MLogClient::MLOG_ERROR,endOfString); return 1;}
  if (!isdigit(p[0]) && !isdigit(p[1])) {
    strstream z(msg, sizeof msg);
    z << "Seconds (SS) is not two digits as expected: " << p << '\0';
    logClient.log(MLogClient::MLOG_ERROR, msg);
    rtnStatus = 1;
  }
  int seconds = (p[0]-'0')*10 + (p[1]-'0');
  if (seconds < 0 || seconds > 59) {
    strstream z(msg, sizeof msg);
    z << "Seconds not in expected range of 0-59: " << seconds << '\0';
    logClient.log(MLogClient::MLOG_ERROR, msg);
    rtnStatus = 1;
  }
  p += 2;

  if (*p == 0) {
    strstream z(msg, sizeof msg);
    z << "Reached end of seconds without fractional seconds or time offset; next character should be '.', 'Z', '+' or '-': " << p << '\0';
    logClient.log(MLogClient::MLOG_ERROR, msg);
    return 1;
  }
  if (*p == '.') {		// Then, fractional seconds
    p++;
    char *p1 = p;
    while (isdigit(*p) && p != &p1[6]) {
      p++;
    }
  }

  if (*p == 0) {
    strstream z(msg, sizeof msg);
    z << "Reached end of time stamp without offset; next character should be 'Z', '+' or '-': " << p << '\0';
    logClient.log(MLogClient::MLOG_ERROR, msg);
    rtnStatus = 1;
  } else if (*p == 'Z') {
    if (p[1] != '\0') {
      strstream z(msg, sizeof msg);
      z << "Found Z for time offset, but extra characters after 'Z': " << p << '\0';
      logClient.log(MLogClient::MLOG_ERROR, msg);
      rtnStatus = 1;
    }
  } else if (*p == '+' || *p == '-') {
    p++;

    if (p[0] == 0 || p[1] == 0) { logClient.log(MLogClient::MLOG_ERROR,endOfString); return 1;}
    if (!isdigit(p[0]) && !isdigit(p[1])) {
      strstream z(msg, sizeof msg);
      z << "HH in time offset is not two digits as expected: " << p << '\0';
      logClient.log(MLogClient::MLOG_ERROR, msg);
      rtnStatus = 1;
    }
    hh = (p[0]-'0')*10 + (p[1]-'0');
    if (hh < 0 || hh > 23) {
      strstream z(msg, sizeof msg);
      z << "Hour in time offset not in expected range of 0-23: " << hh << '\0';
      logClient.log(MLogClient::MLOG_ERROR, msg);
      rtnStatus = 1;
    }
    p += 2;

    if (*p == 0) { logClient.log(MLogClient::MLOG_ERROR,endOfString); return 1;}
    if (*p != ':') {
      strstream z(msg, sizeof msg);
      z << "Delimiter after HH in time offset shall be ':': " << p << '\0';
      logClient.log(MLogClient::MLOG_ERROR, msg);
      rtnStatus = 1;
    }
    p++;

    if (p[0] == 0 || p[1] == 0) { logClient.log(MLogClient::MLOG_ERROR,endOfString); return 1;}
    if (!isdigit(p[0]) && !isdigit(p[1])) {
      strstream z(msg, sizeof msg);
      z << "Minutes (MM) in time offset is not two digits as expected: " << p << '\0';
      logClient.log(MLogClient::MLOG_ERROR, msg);
      rtnStatus = 1;
    }
    minutes = (p[0]-'0')*10 + (p[1]-'0');
    if (minutes < 0 || minutes > 59) {
      strstream z(msg, sizeof msg);
      z << "Minutes in time offset not in expected range of 0-59: " << minutes << '\0';
      logClient.log(MLogClient::MLOG_ERROR, msg);
      rtnStatus = 1;
    }
    p += 2;

    if (*p != 0) {
      strstream z(msg, sizeof msg);
      z << "Found time offset +/-HH:MM, but extra characters after offset: " << p << '\0';
      logClient.log(MLogClient::MLOG_ERROR, msg);
      rtnStatus = 1;
    }
  } else {
    strstream z(msg, sizeof msg);
    z << "Improper time offset marker; should be 'Z', '+' or '-': " << p << '\0';
    logClient.log(MLogClient::MLOG_ERROR, msg);
    rtnStatus = 1;
  }

  return rtnStatus;
}

static int evalHostName(const MString& hostName)
{
  int rtnStatus = 0;			// Assume success
  MLogClient logClient;
  char x[1024] = "";
  hostName.safeExport(x, (sizeof x)-1);
  char msg[2048] = "";

  strstream z(msg, sizeof msg);
  z << "Evaluating hostname in audit message: " << hostName << '\0';
  logClient.log(MLogClient::MLOG_VERBOSE, msg);

  if (x[0] == '\0') {
    logClient.log(MLogClient::MLOG_ERROR, "Hostname field of message is empty; error");
    rtnStatus = 1;
  } else if (x[0] == '-' && x[1] != '\0') {
    strstream z1(msg, sizeof msg);
    z1 << "Hostname starts with NIL (-), but then has extra characters; error '" << x << "'\0";
    logClient.log(MLogClient::MLOG_VERBOSE, msg);
    rtnStatus = 1;
  }
  return rtnStatus;
}

static int evalAppName(const MString& appName)
{
  int rtnStatus = 0;			// Assume success
  MLogClient logClient;
  char x[1024] = "";
  appName.safeExport(x, (sizeof x)-1);
  char msg[2048] = "";

  strstream z(msg, sizeof msg);
  z << "Evaluating appname in audit message: " << appName << '\0';
  logClient.log(MLogClient::MLOG_VERBOSE, msg);

  if (x[0] == '\0') {
    logClient.log(MLogClient::MLOG_ERROR, "appName field of message is empty; error");
    rtnStatus = 1;
  } else if (x[0] == '-' && x[1] != '\0') {
    strstream z1(msg, sizeof msg);
    z1 << "appname starts with NIL (-), but then has extra characters; error '" << x << "'\0";
    logClient.log(MLogClient::MLOG_VERBOSE, msg);
    rtnStatus = 1;
  }
  return rtnStatus;
}

static int evalProcID(const MString& procID)
{
  int rtnStatus = 0;			// Assume success
  MLogClient logClient;
  char x[1024] = "";
  procID.safeExport(x, (sizeof x)-1);
  char msg[2048] = "";

  strstream z(msg, sizeof msg);
  z << "Evaluating procID in audit message: " << procID << '\0';
  logClient.log(MLogClient::MLOG_VERBOSE, msg);

  if (x[0] == '\0') {
    logClient.log(MLogClient::MLOG_ERROR, "procID field of message is empty; error");
    rtnStatus = 1;
  } else if (x[0] == '-' && x[1] != '\0') {
    strstream z1(msg, sizeof msg);
    z1 << "procID starts with NIL (-), but then has extra characters; error '" << x << "'\0";
    logClient.log(MLogClient::MLOG_VERBOSE, msg);
    rtnStatus = 1;
  }
  return rtnStatus;
}

static int evalMsgID(const MString& msgID)
{
  int rtnStatus = 0;			// Assume success
  MLogClient logClient;
  char x[1024] = "";
  msgID.safeExport(x, (sizeof x)-1);
  char msg[2048] = "";

  strstream z(msg, sizeof msg);
  z << "Evaluating msgID in audit message: " << msgID << '\0';
  logClient.log(MLogClient::MLOG_VERBOSE, msg);

  if (x[0] == '\0') {
    logClient.log(MLogClient::MLOG_ERROR, "msgID field of message is empty; error");
    rtnStatus = 1;
  } else if (x[0] == '-' && x[1] != '\0') {
    strstream z1(msg, sizeof msg);
    z1 << "msgID starts with NIL (-), but then has extra characters; error '" << x << "'\0";
    logClient.log(MLogClient::MLOG_VERBOSE, msg);
    rtnStatus = 1;
  }
  return rtnStatus;
}

static int evalMessage(const unsigned char* msg, unsigned long length)
{
  int rtnStatus = 0;			// Assume success
  MLogClient logClient;
  char buf[16834] = "";
  unsigned char copy[16384] = "";

  ::memcpy(copy, msg, length);
  copy[length] = '\0';

  strstream z(buf, sizeof buf);
  z << "Evaluating message audit message: " << copy << '\0';
  logClient.log(MLogClient::MLOG_VERBOSE, (const char*)msg);

  bool bom = true;
  if (copy[0] != 0xef) bom = false;
  if (copy[1] != 0xbb) bom = false;
  if (copy[2] != 0xbf) bom = false;

  char* p = (char*) copy;
  if (bom) {
    p += 3;
    logClient.log(MLogClient::MLOG_VERBOSE, "Found UTF-8 BOM is audit message");
  } else {
    strstream z1(buf, sizeof buf);
    z1 << "Did not find UTF-8 BOM at the start of this message: " << copy << '\0';
    logClient.log(MLogClient::MLOG_WARN, buf);
  }
/*
  if (strncmp(p, "<?xml", 5) != 0 && strncmp(p, "<?XML", 5) != 0) {
    strstream z1(buf, sizeof buf);
    z1 << "The audit message shll be an XML string that begins with <?xml or <?XML ... " << p << '\0';
    logClient.log(MLogClient::MLOG_WARN, buf);
    rtnStatus = 1;
  }
*/
  return rtnStatus;
}

static int processSyslogFile(const char* syslogFile)
{
  long fileLength = MFileOperations::fileLength(syslogFile);
  if (fileLength <= 0) {
    cout << "File does not exist: " << syslogFile << endl;
  }
  MSyslogFactory factory;
  char msg[2048] = "";

  ifstream x(syslogFile, ios::binary);
  char buffer[16384];
  x.read(buffer, fileLength);
  buffer[fileLength] = '\0';
  cout << buffer << endl;
  x.close();
  MLogClient logClient;

  MSyslogMessage5424* m = factory.produceMessage5424(buffer, fileLength);
  if (m == 0) {
    logClient.log(MLogClient::MLOG_ERROR,
	MString("Some type of parsing error. Could not parse according to RFC 5424: ") + syslogFile);
    return 1;
  }
  int rtnValue = 0;
  int facility = m->facility();
  int severity = m->severity();
  MString timeStamp = m->timeStamp();
  MString hostName  = m->hostName();
  MString appName   = m->appName();
  MString procID    = m->processID();
  MString msgID     = m->messageID();
  unsigned long messageLength = 0;
  const unsigned char* messageReference = m->referenceToMessage(messageLength);

//  cout << "Facility:   " << facility << endl;
//  cout << "Severity:   " << severity << endl;
//  cout << "Time Stamp: " << timeStamp << endl;
  if (facility != 10) {
    strstream z(msg, sizeof msg);
    z << "Facility should be 10; syslog message contains: " << facility << '\0';
    logClient.log(MLogClient::MLOG_ERROR, msg);
    rtnValue = 1;
  }
  if (severity != 4 && severity != 5) {
    strstream z(msg, sizeof msg);
    z << "Severity expected to be 4 or 5 (really 5); syslog message contains: " << severity << '\0';
    logClient.log(MLogClient::MLOG_ERROR, msg);
    rtnValue = 1;
  }
  rtnValue |= evalTimeStamp(timeStamp);
  rtnValue |= evalHostName(hostName);
  rtnValue |= evalAppName(appName);
  rtnValue |= evalProcID(procID);
  rtnValue |= evalMsgID(msgID);
  rtnValue |= evalMessage(messageReference, messageLength);
  delete m;
  return rtnValue;
}


static void
logTLSParameters(MLogClient& logClient, const MString& randomsFile, const MString& keyFile,
	const MString& certificateFile, const MString& peerCertificateList, const MString& ciphers)
{
  char txt[1024] = "";
  strstream a(txt, sizeof(txt));
  a << " Randoms file:          " << randomsFile << '\0';
  logClient.logTimeStamp(MLogClient::MLOG_ERROR, txt);

  strstream b(txt, sizeof(txt));
  b << " Key file:              " << keyFile << '\0';
  logClient.logTimeStamp(MLogClient::MLOG_ERROR, txt);

  strstream c(txt, sizeof(txt));
  c << " Certificate file:      " << certificateFile << '\0';
  logClient.logTimeStamp(MLogClient::MLOG_ERROR, txt);

  strstream d(txt, sizeof(txt));
  d << " Peer Certificate file: " << peerCertificateList << '\0';
  logClient.logTimeStamp(MLogClient::MLOG_ERROR, txt);

  strstream e(txt, sizeof(txt));
  e << " Ciphers:               " << ciphers << '\0';
  logClient.logTimeStamp(MLogClient::MLOG_ERROR, txt);
}

static void
logNewConnection(MLogClient& logClient, const MString& remoteHost, const MString& ciphers)
{
  char txt[1024] = "";
  strstream a(txt, sizeof(txt));
  a << "New network connection from host: " << remoteHost<< '\0';
  logClient.logTimeStamp(MLogClient::MLOG_ERROR, txt);

  strstream b(txt, sizeof(txt));
  b << " This server (MESA, not theirs) supports ciphers: " << ciphers << '\0';
  logClient.logTimeStamp(MLogClient::MLOG_ERROR, txt);
}

static void
logCloseConnection(MLogClient& logClient, const MString& remoteHost)
{
  char txt[1024] = "";
  strstream a(txt, sizeof(txt));
  a << "Remote host closed connection: " << remoteHost << '\0';
  logClient.logTimeStamp(MLogClient::MLOG_ERROR, txt);
}




int main(int argc, char** argv)
{ 
  bool verbose = false;
  MString syslogDBName("syslog");
  MFileOperations f;
  char path[256];
  int rfcType = 0;
  MString xmitRFC = "3164";
  MString randomsFile = "";
  MString keyFile = "";
  MString certificateFile = "";
  MString peerCertificateList = "";
  MString ciphers = "NULL-SHA";
  char* syslogFile = 0;
  char* challenge = "NA2010";


  f.expandPath(path, "MESA_TARGET", "logs");
  MString logDir(path);
  MLogClient::LOGLEVEL logLevel = MLogClient::MLOG_ERROR;
 
  while (--argc > 0 && (*++argv)[0] == '-') {
    int l1 = 0;
    switch(*(argv[0] + 1)) {
    case 'C':
      argc--; argv++;
      if (argc < 1)
	usage();
      certificateFile = *argv;
      break;
    case 'd':
      argc--; argv++;
      if (argc < 1)
	usage();
      syslogDBName = *argv;
      break;
    case 'f':
      argc--; argv++;
      if (argc < 1)
	usage();
      syslogFile = *argv;
      break;
    case 'j':
      argc--; argv++;
      if (argc < 1)
	usage();
      challenge = *argv;
      break;
    case 'K':
      argc--; argv++;
      if (argc < 1)
	usage();
      keyFile = *argv;
      break;

    case 'l':
      argc--; argv++;
      if (argc < 1)
	usage();
      if (::sscanf(*argv, "%d", &l1) != 1)
	usage();
      logLevel = (MLogClient::LOGLEVEL)l1;
      break;
    case 'P':
      argc--; argv++;
      if (argc < 1)
	usage();
      peerCertificateList = *argv;
      break;
    case 'R':
      argc--; argv++;
      if (argc < 1)
	usage();
      randomsFile = *argv;
      break;

    case 'r':
      argc--; argv++;
      if (argc < 1)
	usage();
      if (::sscanf(*argv, "%d", &l1) != 1)
	usage();
      rfcType = l1;
      break;

    case 'v':
      verbose = true;
      break;

    case 'x':
      argc--; argv++;
      if (argc < 1)
	usage();
      xmitRFC = *argv;
      break;

    case 'Z':
      argc--; argv++;
      if (argc < 1)
	usage();
      ciphers = *argv;
      break;

    default:
      break;
    }
  }

  MLogClient logClient;
  if (syslogFile != 0) {
    logClient.logLevel(MLogClient::MLOG_VERBOSE);
    return processSyslogFile(syslogFile);
  }


  if (argc < 1)
    usage();

  char logPath[1024];
  if (f.expandPath(logPath, "MESA_TARGET", "logs/syslog") != 0) {
    cout << "Unable to expand path for $MESA_TARGET/logs" << endl;
    return 1;
  }

  if (f.createDirectory(logPath) != 0) {
    cout << "Unable to create directory: " << logPath << endl;
    return 1;
  }

  if (logLevel != MLogClient::MLOG_NONE) {
    MString logName = logDir + "/syslog_server.log";
    if      (xmitRFC == "3164") logName = logDir + "/syslog_server_3164.log";
    else if (xmitRFC == "5425") logName = logDir + "/syslog_server_5425.log";
    else if (xmitRFC == "5426") logName = logDir + "/syslog_server_5426.log";
    else if (xmitRFC == "TCP")  logName = logDir + "/syslog_server_TCP.log";

    logClient.initialize(logLevel, logName);

    logClient.log(MLogClient::MLOG_VERBOSE,
                  "<no peer>", "syslog_server<main>", __LINE__,
                  "Begin server process");
    cerr << "syslog_server logging messages at level "
         << logLevel
         << " to "
         << logName
         << endl;
  }

  int port = atoi(*argv);
  MNetworkProxy* networkProxy = 0;

  MAcceptor acc;
  CTN_SOCKET s = 0;

  if (xmitRFC == "TCP") {
    networkProxy = new MNetworkProxyTCP;
    if (networkProxy->registerPort(port) != 0) {
      logClient.logTimeStamp(MLogClient::MLOG_ERROR, "Unable to initialize TCP listening port");
      return 1;
    }
    processTCPPackets(*networkProxy, logPath, syslogDBName, rfcType, "TCP-no ciphers");

  } else if (xmitRFC=="3164") {
    if (acc.bindUDPListener(s, port) != 0) {
      cout << "Unable to bind to UDP port: " << port << endl;
      return 1;
    }
    processUDPPackets(s, logPath, syslogDBName, rfcType);

  } else if (xmitRFC=="5426") {
    if (acc.bindUDPListener(s, port) != 0) {
      cout << "Unable to bind to UDP port: " << port << endl;
      return 1;
    }
    processUDPPackets(s, logPath, syslogDBName, rfcType);

  } else if (xmitRFC=="5425") {
#ifdef RFC5425
    MNetworkProxyTLS* proxyTLS = new MNetworkProxyTLS;
//    networkProxy = proxyTLS;
    MString proxyParams =
	randomsFile + ","
	+ keyFile + ","
	+ certificateFile + ","
	+ peerCertificateList + ","
	+ ciphers + ","
	+ challenge;
    logTLSParameters(logClient, randomsFile, keyFile, certificateFile, peerCertificateList, ciphers);
    if (proxyTLS->initializeServer(proxyParams) != 0) {
      logClient.logTimeStamp(MLogClient::MLOG_ERROR,
	MString("Unable to initialize TLS proxy class with params: ") + proxyParams);
      return 1;
    }
    if (proxyTLS->registerPort(port) != 0) {
      logClient.logTimeStamp(MLogClient::MLOG_ERROR, "Unable to initialize TCP/TLS listening port");
      return 1;
    }
    processTCPPackets(*proxyTLS, logPath, syslogDBName, rfcType, ciphers);
    delete proxyTLS;
#else
    cout << "syslog server not ready for RFC 5425" << endl;
    return 1;
#endif
  } else {
    cout << "Unrecognized transport specification: " << xmitRFC << endl;
    return 1;
  }

  return 0;
}
