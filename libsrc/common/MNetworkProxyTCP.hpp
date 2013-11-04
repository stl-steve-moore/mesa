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

// $Id: MNetworkProxyTCP.hpp,v 1.1 2002/07/23 18:43:15 smm Exp $ $Author: smm $ $Revision: 1.1 $ $Date: 2002/07/23 18:43:15 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MNetworkProxyTCP.hpp
//
//  = AUTHOR
//	Steve Moore
//
//  = COPYRIGHT
//	Copyright HIMSS, RSNA, Washington University: 1999, 2000
//
// ====================
//
//  = VERSION
//	$Revision: 1.1 $
//
//  = DATE RELEASED
//	$Date: 2002/07/23 18:43:15 $
//
//  = COMMENTS

#ifndef MNetworkProxyTCPISIN
#define MNetworkProxyTCPISIN

#include "MNetworkProxy.hpp"
#include "MAcceptor.hpp"

using namespace std;

class MNetworkProxyTCP : public MNetworkProxy
// = TITLE
//	MNetworkProxyTCP
//
// = DESCRIPTION
//
{
public:
  // = The standard methods in this framework.

  MNetworkProxyTCP();
  // Default constructor

  MNetworkProxyTCP(const MNetworkProxyTCP& cpy);
  // Copy constructor.

  virtual ~MNetworkProxyTCP();
  // Destructor.

  virtual void printOn(ostream& s) const;
  // This method is used in conjunction with the streaming operator <<
  // to print the current state of MNetworkProxyTCP

  virtual void streamIn(istream& s);
  // This method is used in conjunction with the streaming operator >>
  // to read the current state of MNetworkProxyTCP

  virtual int initializeClient(const MString& paramList);
  virtual int initializeServer(const MString& paramList);

  virtual int connect(const MString& host, int port);
  virtual int registerPort(int port);
  virtual int acceptConnection(MString& remoteHost, int timeout);

  virtual int writeBytes(const void* buf, int toWrite);
  virtual int readBytes(void* buf, int toRead);
  virtual int readUpToNBytes(void* buf, int toRead);
  virtual int readExactlyNBytes(void* buf, int toRead);

  virtual int close( );

  CTN_SOCKET getSocket();

protected:

private:
  MAcceptor mAcceptor;
  CTN_SOCKET mSocket;
};

inline ostream& operator<< (ostream& s, const MNetworkProxyTCP& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MNetworkProxyTCP& c) {
  c.streamIn(s);
  return s;
}

#endif
