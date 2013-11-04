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
#include <strstream>

#include "MESA.hpp"
#include "MNetworkProxyTCP.hpp"
#include "MConnector.hpp"
#include "MLogClient.hpp"


static char rcsid[] = "$Id: MNetworkProxyTCP.cpp,v 1.5 2006/07/30 02:24:57 smm Exp $";

MNetworkProxyTCP::MNetworkProxyTCP() :
  mSocket(-1)
{
}

MNetworkProxyTCP::MNetworkProxyTCP(const MNetworkProxyTCP& cpy) :
  mAcceptor(cpy.mAcceptor),
  mSocket(cpy.mSocket)
{
}

MNetworkProxyTCP::~MNetworkProxyTCP()
{
  this->close();
}

void
MNetworkProxyTCP::printOn(ostream& s) const
{
  s << "MNetworkProxyTCP";
}

void
MNetworkProxyTCP::streamIn(istream& s)
{
  //s >> this->member;
}

// Non boiler-plate methods to follow

int
MNetworkProxyTCP::initializeClient(const MString& paramList)
{
  return 0;
}

int
MNetworkProxyTCP::initializeServer(const MString& paramList)
{
  return 0;
}

int
MNetworkProxyTCP::connect(const MString& host, int port)
{
  MConnector c;

  int status = c.connectTCP(host, port, mSocket);
  if (status != 0) {
    mSocket = -1;
  }
  return status;
}

int
MNetworkProxyTCP::registerPort(int port)
{
  int status;
  status = mAcceptor.registerPort(port);
  return status;
}

int
MNetworkProxyTCP::acceptConnection(MString& remoteHost, int timeout)
{
  mSocket = 0;
  int status = 0;
  status = mAcceptor.acceptConnection(mSocket, remoteHost, timeout);
  return status;
}

int
MNetworkProxyTCP::writeBytes(const void* buf, int toWrite)
{
  unsigned char* p = (unsigned char*)buf;
  int bytesWritten = 0;
  int totalBytes = 0;
//  MLogClient logClient;
//  logClient.logTimeStamp(MLogClient::MLOG_VERBOSE,
//	"MNetworkProxyTCP::writeBytes enter method");

  while (toWrite > 0) {
//  {
//    char tmp[256];
//    strstream t(tmp, sizeof(tmp));
//    t << "About to write " << toWrite << " bytes on socket: " << mSocket << '\0';
//    logClient.logTimeStamp(MLogClient::MLOG_VERBOSE, tmp);
//  }

#ifdef _WIN32
    bytesWritten = ::send(mSocket, (char *)p, toWrite, 0);
#else
    bytesWritten = ::write(mSocket, p, toWrite);
#endif
//    logClient.logTimeStamp(MLogClient::MLOG_VERBOSE, "Returned from ::send or ::write");
    if (bytesWritten == -1 && errno == EINTR)
      continue;

    if (bytesWritten < 0)
      return -1;

    p += bytesWritten;
    toWrite -= bytesWritten;
    totalBytes += bytesWritten;
  }

//  logClient.logTimeStamp(MLogClient::MLOG_VERBOSE,
//	"MNetworkProxyTCP::writeBytes exit method");
  return totalBytes;
}

int
MNetworkProxyTCP::readBytes(void* buf, int toRead)
{
  size_t bytesRead = 0;
  size_t totalBytes = 0;
  int done = 0;

  while (!done) {
#ifdef _WIN32
    bytesRead = ::recv(mSocket, (char*)buf, toRead, 0);
#else
    bytesRead = ::read(mSocket, buf, toRead);
#endif
    if (bytesRead == -1 && errno == EINTR)
      continue;

    if (bytesRead < 0)
      return -1;

    done = 1;
  }

  return bytesRead;
}

int
MNetworkProxyTCP::readUpToNBytes(void* buf, int toRead)
{
  size_t bytesRead = 0;
  size_t totalBytes = 0;
  int done = 0;

  while (!done) {
#ifdef _WIN32
    bytesRead = ::recv(mSocket, (char*)buf, toRead, 0);
#else
    bytesRead = ::read(mSocket, buf, toRead);
#endif
    if (bytesRead == -1 && errno == EINTR)
      continue;

    if (bytesRead < 0)
      return -1;

    done = 1;
  }

  return bytesRead;
}

int
MNetworkProxyTCP::readExactlyNBytes(void* buf, int toRead)
{
  size_t bytesRead = 0;
  size_t totalBytes = 0;
  int done = 0;

  while (!done) {
#ifdef _WIN32
    bytesRead = ::recv(mSocket, (char*)buf, toRead, 0);
#else
    bytesRead = ::read(mSocket, buf, toRead);
#endif
    if (bytesRead == -1 && errno == EINTR)
      continue;

    if (bytesRead < 0) {
      totalBytes = -1;
      done = 1;
    } else  {
      totalBytes += bytesRead;
      toRead -= bytesRead;
      if (toRead <= 0) done = 1;
    }
  }

  return totalBytes;
}


int
MNetworkProxyTCP::close()
{
  if (mSocket > 0)
    ::close(mSocket);
  mSocket = -1;

  return 0;
}

CTN_SOCKET
MNetworkProxyTCP::getSocket()
{
  return mSocket;
}
