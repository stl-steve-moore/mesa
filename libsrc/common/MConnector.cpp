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

#include "ctn_os.h"

#include "MESA.hpp"
#include "MConnector.hpp"
#include "MLogClient.hpp"

#include <strstream>

static char rcsid[] = "$Id: MConnector.cpp,v 1.4 2002/04/24 20:02:00 smm Exp $";

MConnector::MConnector()
{
}

MConnector::MConnector(const MConnector& cpy)
{
}

MConnector::~MConnector()
{
}

void
MConnector::printOn(ostream& s) const
{
  s << "MConnector";
}

void
MConnector::streamIn(istream& s)
{
  //s >> this->member;
}

// Non boiler-plate methods to follow

int
MConnector::connectTCP(const MString& host, int port,
		       CTN_SOCKET& returnSocket)
{
#ifdef _WIN32
  WSADATA wsaData;
  WSAStartup(MAKEWORD(1, 1), &wsaData);
  int nOption = SO_SYNCHRONOUS_NONALERT;
  ::setsockopt(INVALID_SOCKET, SOL_SOCKET, SO_OPENTYPE,
		   (char *) &nOption, sizeof(int));
#endif

  returnSocket = socket(AF_INET, SOCK_STREAM, 0);
  if (returnSocket == CTN_BAD_SOCKET) {
    return 1;
  }

  struct sockaddr_in server;
  server.sin_family = AF_INET;
  char tmp[1024];
  host.safeExport(tmp, sizeof tmp);
  struct hostent* hp = ::gethostbyname(tmp);
  if (hp == NULL) {
    return 1;
  }
  (void)::memcpy(&server.sin_addr, hp->h_addr, (unsigned long)hp->h_length);
  server.sin_port = (u_short)htons(port);
  if (::connect(returnSocket, (struct sockaddr*)& server, sizeof(server)) < 0) {
#ifdef _WIN32
    ::closesocket(returnSocket);
#else
    ::close(returnSocket);
#endif
    returnSocket = 0;
    return 1;
  }
  return 0;
}

int
MConnector::connectUDP(const MString& host, int port,
		       CTN_SOCKET& returnSocket)
{

  MLogClient logClient;
#ifdef _WIN32
  WSADATA wsaData;
  WSAStartup(MAKEWORD(1, 1), &wsaData);
  int nOption = SO_SYNCHRONOUS_NONALERT;
  ::setsockopt(INVALID_SOCKET, SOL_SOCKET, SO_OPENTYPE,
		   (char *) &nOption, sizeof(int));
#endif

  returnSocket = socket(AF_INET, SOCK_DGRAM, 0);
  if (returnSocket == CTN_BAD_SOCKET) {
    return 1;
  }

  struct sockaddr_in server;
  server.sin_family = AF_INET;
  char tmp[1024]="";
  host.safeExport(tmp, sizeof tmp);
  struct hostent* hp = ::gethostbyname(tmp);
  if (hp == NULL) {
    return 1;
  }
  (void)::memcpy(&server.sin_addr, hp->h_addr, (unsigned long)hp->h_length);
  server.sin_port = (u_short)htons(port);
  if (::connect(returnSocket, (struct sockaddr*)& server, sizeof(server)) < 0) {
#ifdef _WIN32
    ::closesocket(returnSocket);
#else
    ::close(returnSocket);
#endif
    returnSocket = 0;
    return 1;
  }
  strstream x(tmp, sizeof(tmp));
  x << "MConnector::connectUDP(MLogClient:connectUDP " << host << ", " << port << ", internal socket " << returnSocket << '\0';
  logClient.log(MLogClient::MLOG_VERBOSE, tmp);
  return 0;
}


