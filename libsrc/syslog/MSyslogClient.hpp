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

// $Id: MSyslogClient.hpp,v 1.3 2006/06/29 16:08:33 bhasselfeld Exp $ $Author: bhasselfeld $ $Revision: 1.3 $ $Date: 2006/06/29 16:08:33 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MSyslogClient.hpp
//
//  = AUTHOR
//	Steve Moore
//
//  = COPYRIGHT
//	Copyright HIMSS, RSNA, Washington University: 2002
//
// ====================
//
//  = VERSION
//	$Revision: 1.3 $
//
//  = DATE RELEASED
//	$Date: 2006/06/29 16:08:33 $
//
//  = COMMENTS

#ifndef MSyslogClientISIN
#define MSyslogClientISIN

using namespace std;

#include "ctn_os.h"

class MSyslogMessage;
class MSyslogMessage5424;

#include "MNetworkProxy.hpp"

class MSyslogClient
// = TITLE
//	MSyslogClient -
//
// = DESCRIPTION

{
public:
  // = The standard methods in this framework.

  MSyslogClient();
  ///< Default constructor

  MSyslogClient(const MSyslogClient& cpy);
  ///< Copy constructor

  virtual ~MSyslogClient();
  ///< Destructor

  virtual void printOn(ostream& s) const;
  /**<\brief This method is used in conjunction with the streaming operator <<
  	     to print the current state of MSyslogClient */

  virtual void streamIn(istream& s);
  /**<\brief This method is used in conjuction with the streaming operator >>
  	     to read the current state of MSyslogClient. */
  
  // = Class specific methods.

  int open(const MString& host, int port = 514 );
  int openTCP(const MString& host, int port);
  int openTLS(const MString& host, int port, const MString& params);

  int sendMessage(MSyslogMessage& m);
  int sendMessage(MSyslogMessage5424& m);
  int sendMessageTCP(MSyslogMessage5424& m);
  int sendMessageTLS(MSyslogMessage5424& m);

  void setTestMode(int mode);

protected:

private:
  MNetworkProxy* mNetworkProxy;
  CTN_SOCKET mSocket;
  MString mServerName;
  int mServerPort;
  int mTestMode;
  bool mIsConnected;
};

inline ostream& operator<< (ostream& s, const MSyslogClient& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MSyslogClient& c) {
  c.streamIn(s);
  return s;
}

#endif
