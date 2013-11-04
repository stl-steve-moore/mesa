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

#include <strstream>

#include "ctn_os.h"
#include "MESA.hpp"
#include "MDICOMProxyTCP.hpp"
#include "MAcceptor.hpp"
#include "MConnector.hpp"
#include "MLogClient.hpp"

MDICOMProxyTCP::MDICOMProxyTCP() :
 mSocket(-1),
 mListenPort(0),
 mAcceptor(0)
{
}

MDICOMProxyTCP::MDICOMProxyTCP(const MDICOMProxyTCP& cpy) :
 mSocket(cpy.mSocket),
 mListenPort(cpy.mListenPort),
 mAcceptor(cpy.mAcceptor)
{
}

MDICOMProxyTCP::~MDICOMProxyTCP()
{
  if (mSocket < 0)
    return;

#ifdef _WIN32
  closesocket(mSocket);
#else
  ::close(mSocket);
#endif
}

void
MDICOMProxyTCP::printOn(ostream& s) const
{
  s << "MDICOMProxyTCP";
}

void
MDICOMProxyTCP::streamIn(istream& s)
{
  //s >> this->member;
}

// Non-boilerplate methods follow.

int
MDICOMProxyTCP::initializeClient(const MString& parameter)
{
  return 0;
}

int
MDICOMProxyTCP::connect(const MString& host, int port)
{
#ifndef _WIN32
  ::signal(SIGPIPE, SIG_IGN);
#endif

  MConnector c;

  if (c.connectTCP(host, port, mSocket) != 0) {
    return 1;
  }
  return 0;
}

int
MDICOMProxyTCP::connect(const MString& host, const MString& port)
{
  int p = port.intData();
  return this->connect(host, p);
}

int
MDICOMProxyTCP::registerPort(int port)
{
  MLogClient l;
  char buf[512];
  strstream s(buf, sizeof(buf));

  if (mListenPort != 0) {
    s << "MDICOMProxyTCP::registerPort already has a port registered: " << mListenPort << '\0';
    l.log(MLogClient::MLOG_ERROR, buf);
    return 1;
  }

  mAcceptor = new MAcceptor;
  if (mAcceptor == 0) {
    l.log(MLogClient::MLOG_ERROR,
	"MDICOMProxyTCP::registerPort unable to create new MAcceptor");
    return 1;
  }

  if (mAcceptor->registerPort(port) != 0) {
    l.log(MLogClient::MLOG_ERROR,
	"MDICOMProxyTCP::registerPort port registration failed");
    return 1;
  }
  mListenPort = port;
#ifndef _WIN32
  ::signal(SIGPIPE, SIG_IGN);
#endif
  return 0;
}

int
MDICOMProxyTCP::registerPort(int port, const MString& parameter)
{
  return this->registerPort(port);
}

int
MDICOMProxyTCP::acceptConnection(int timeout)
{
  MLogClient l;

  if (mAcceptor == 0) {
    l.log(MLogClient::MLOG_ERROR,
	"MDICOMProxyTCP::acceptConnection no port was registered");
    return 1;
  }

  if (mAcceptor->acceptConnection(mSocket, timeout) != 0) {
    l.log(MLogClient::MLOG_ERROR,
	"MDICOMProxyTCP::acceptConnection unable to accept connection");
    return 1;
  }
  return 0;
}



static int
writeTCP(void* proxyContext, const void* buf, int nbyte);
static int
readTCP(void* proxyContext, void* buf, int nbyte);
static int
networkDataAvailable(void* proxyContext, int timeout);
static int
closeTCP(void* proxyContext);

int
MDICOMProxyTCP::configure(DUL_PROXY* p)
{
  p->writeFunction = writeTCP;
  p->readFunction = readTCP;
  p->pollFunction = networkDataAvailable;
  p->closeFunction = closeTCP;
  p->proxyContext = &mSocket;

  return 0;
}

// Static functions below this point. These are the
// proxy functions for carrying out the network I/O.

static int
writeTCP(void* proxyContext, const void* buf, int nbyte)
{
  int bytesWritten;
  int totalBytes = 0;
  CTN_SOCKET *fd;

  fd = (CTN_SOCKET*)proxyContext;

  char* p = (char*)buf;

  while (nbyte > 0) {
#ifdef _WIN32
    bytesWritten = send(*fd, p, nbyte, 0);
#else
    bytesWritten = write(*fd, p, nbyte);
#endif
    if (bytesWritten == -1 && errno == EINTR)
      continue;

    if (bytesWritten < 0)
      return -1;

    p += bytesWritten;
    nbyte -= bytesWritten;
    totalBytes += bytesWritten;
  }
  return totalBytes;
}

static int
readTCP(void* proxyContext, void* buf, int nbyte)
{
  int bytesRead;
  int totalBytes = 0;
  CTN_SOCKET *fd;
  int done = 0;

  fd = (CTN_SOCKET*)proxyContext;
  char* p = (char *)buf;

  while (!done) {
#ifdef _WIN32
    bytesRead = recv(*fd, p, nbyte, 0);
#else
    bytesRead = read(*fd, p, nbyte);
#endif
    if (bytesRead == -1 && errno == EINTR)
      continue;

    if (bytesRead < 0)
      return -1;

    done = 1;
  }

  return bytesRead;
}

static int
networkDataAvailable(void* proxyContext, int timeout)
{
  struct timeval t;
  fd_set fdset;
  int nfound;

  CTN_SOCKET s;
  s = *((CTN_SOCKET*)proxyContext);

  FD_ZERO(&fdset);
  FD_SET(s, &fdset);
  t.tv_sec = timeout;
  t.tv_usec = 0;
  nfound = select(s + 1, &fdset, NULL, NULL, &t);
  if (nfound <= 0)
    return 0;
  else {
    if (FD_ISSET(s, &fdset))
      return 1;
    else			/* This one should not really happen */
      return 0;
  }
}

static int
closeTCP(void* proxyContext)
{
  CTN_SOCKET* p;

  p = (CTN_SOCKET*)proxyContext;

#ifdef _WIN32
  (void) closesocket(*p);
#else
  (void) close(*p);
#endif

  return 0;
}
