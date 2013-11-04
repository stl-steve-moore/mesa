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
#include "MAcceptor.hpp"


static char rcsid[] = "$Id: MAcceptor.cpp,v 1.13 2007/04/09 16:02:05 smm Exp $";

MAcceptor::MAcceptor() :
 mListenSocket(0),
 mSkipRemoteLookup(false)
{
}

MAcceptor::MAcceptor(const MAcceptor& cpy) :
 mListenSocket(cpy.mListenSocket),
 mSkipRemoteLookup(cpy.mSkipRemoteLookup)
{
}

MAcceptor::~MAcceptor()
{
}

void
MAcceptor::printOn(ostream& s) const
{
  s << "MAcceptor";
}

void
MAcceptor::streamIn(istream& s)
{
  //s >> this->member;
}

// Non boiler-plate methods to follow

int
MAcceptor::registerPort(int port)
{
#ifdef _WIN32
  WSADATA wsaData;
  ::memset(&wsaData, 0, sizeof(wsaData));
  int status = WSAStartup(MAKEWORD(1, 1), &wsaData);
  if (status != 0) {
    cout << "Failed to initialize WSAStartup" << endl;
    ::exit(1);
  }
#endif

  mListenSocket = ::socket(AF_INET, SOCK_STREAM, 0);
  if (mListenSocket == CTN_BAD_SOCKET) {
    mListenSocket = 0;
    ::perror("Trying to initialize listen socket");
    return -1;
  }

  int reuse = 1;
  reuse = 1;
  if (::setsockopt(mListenSocket, SOL_SOCKET, SO_REUSEADDR,
	(char *)&reuse, sizeof(reuse)) < 0) {
    mListenSocket = 0;
    ::perror("Trying to set socket option");
    return -1;

  }

  struct sockaddr_in server;
  server.sin_family = AF_INET;
  server.sin_addr.s_addr = INADDR_ANY;
  server.sin_port = (u_short)htons(port);
  if (::bind(mListenSocket,
	(struct sockaddr*)&server, sizeof(server)) != 0) {
#ifdef _WIN32
    ::closesocket(mListenSocket);
#else
    ::close(mListenSocket);
#endif
    mListenSocket = 0;
    ::perror("Trying to bind socket");
    return -1;
  }

  struct linger sockarg;

  sockarg.l_onoff = 0;
  if (::setsockopt(mListenSocket,
	SOL_SOCKET, SO_LINGER, (char*)&sockarg, sizeof(sockarg)) < 0) {
#ifdef _WIN32
    ::closesocket(mListenSocket);
#else
    ::close(mListenSocket);
#endif
    mListenSocket = 0;
    ::perror("Trying to set socket options");
    return -1;
  }

  ::listen(mListenSocket, 10);

  return 0;
}

int
MAcceptor::acceptConnection(CTN_SOCKET& s, int timeout)
{
  MString tmp;
  mSkipRemoteLookup = true;
  int r = this->acceptConnection(s, tmp, timeout);
  mSkipRemoteLookup = false;
  return r;
}

int
MAcceptor::acceptConnection(CTN_SOCKET& s, MString& remoteHost, int timeout)
{
  if (mListenSocket <= 0)
    return -1;

  fd_set fdset;
  int connected = 0;
  remoteHost = "";

  if (timeout >= 0) {
    FD_ZERO(&fdset);
    FD_SET(mListenSocket, &fdset);
    struct timeval t;
    t.tv_sec = timeout;
    t.tv_usec = 0;
    int nfound = ::select(mListenSocket+1, &fdset, NULL, NULL, &t);
    if (nfound != 0) {
      if (FD_ISSET(mListenSocket, &fdset)) {
	connected++;
      }
    }
  }

  if (connected || (timeout < 0)) {
    struct sockaddr from;

#ifdef MESA_USE_SOCKLEN_T
    socklen_t len = sizeof(from);
#else
    int len = sizeof(from);
#endif
    ::memset(&from, 0, len);
    s = -1;
    do {
      s = ::accept(mListenSocket, &from, &len);
    } while (s == -1 && errno == EINTR);

    struct linger sockarg;
    sockarg.l_onoff = 0;
    if (::setsockopt(s, SOL_SOCKET, SO_LINGER, (char*)&sockarg, sizeof(sockarg)) < 0) {
      s = -1;
      ::perror("Trying to set socket option: SO_LINGER");
      return -1;
    }
    int reuse = 1;
    if (::setsockopt(s, SOL_SOCKET, SO_REUSEADDR, (char*)&reuse, sizeof(reuse)) < 0) {
      s = -1;
      ::perror("Trying to set socket option: SO_REUSEADDR");
      return -1;
    }
    if (mSkipRemoteLookup == false)
      this->lookupRemoteHost(&from, remoteHost);
  } else {
    s = -1;
    return 1;
  }
  return 0;
}

int
MAcceptor::bindUDPListener(CTN_SOCKET& s, int port)
{
#ifdef _WIN32
  WSADATA wsaData;
  ::memset(&wsaData, 0, sizeof(wsaData));
  WSAStartup(MAKEWORD(1, 1), &wsaData);
  int nOption = SO_SYNCHRONOUS_NONALERT;
  ::setsockopt(INVALID_SOCKET, SOL_SOCKET, SO_OPENTYPE,
		   (char *) &nOption, sizeof(int));
#endif

  s = ::socket(AF_INET, SOCK_DGRAM, 0);
  if (s == CTN_BAD_SOCKET) {
    ::perror("Trying to initialize listen socket");
    return -1;
  }

  struct sockaddr_in server;
  ::memset(&server, 0, sizeof(server));
  server.sin_family = AF_INET;
  server.sin_addr.s_addr = INADDR_ANY;
  server.sin_port = (u_short)htons(port);
  int status = ::bind(s, (struct sockaddr*)&server, sizeof(server));
  if (status < 0) {
#ifdef _WIN32
    ::perror("");
    ::closesocket(s);
#else
    ::close(s);
#endif
    s = 0;
    ::perror("Trying to bind socket");
    return -1;
  }
  return 0;
}

// Private methods beneath this point

void
MAcceptor::lookupRemoteHost(struct sockaddr *from, MString& remoteHost)
{
  struct hostent *remote;

  remote = ::gethostbyaddr(& from->sa_data[2], 4, 2);
  if (remote == NULL) {
    char buf[32];
    ::sprintf(buf, "%-d.%-d.%-d.%-d",
		((int) from->sa_data[2]) & 0xff,
		((int) from->sa_data[3]) & 0xff,
		((int) from->sa_data[4]) & 0xff,
		((int) from->sa_data[5]) & 0xff);
    remoteHost = buf;
  } else {
    remoteHost = remote->h_name;
  }
}
