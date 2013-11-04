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

// $Id: MAcceptor.hpp,v 1.3 2006/06/29 16:08:28 bhasselfeld Exp $ $Author: bhasselfeld $ $Revision: 1.3 $ $Date: 2006/06/29 16:08:28 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MAcceptor.hpp
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
//	$Revision: 1.3 $
//
//  = DATE RELEASED
//	$Date: 2006/06/29 16:08:28 $
//
//  = COMMENTS

#ifndef MAcceptorISIN
#define MAcceptorISIN
#include "ctn_os.h"

using namespace std;

class MAcceptor
// = TITLE
//	MAcceptor
//
// = DESCRIPTION
//
{
public:
  // = The standard methods in this framework.

  MAcceptor();
  ///< Default constructor

  MAcceptor(const MAcceptor& cpy);
  ///< Copy constructor.

  virtual ~MAcceptor();
  ///< Destructor.

  virtual void printOn(ostream& s) const;
  /**<\brief This method is used in conjunction with the streaming operator <<
   to print the current state of MAcceptor */

  virtual void streamIn(istream& s);
  /**<\brief This method is used in conjunction with the streaming operator >>
   to read the current state of MAcceptor */
  
  int registerPort(int port);

  int acceptConnection(CTN_SOCKET& s, int timeout = 0);

  int acceptConnection(CTN_SOCKET& s, MString& remoteHost, int timeout = 0);

  int bindUDPListener(CTN_SOCKET& s, int port);


private:
  CTN_SOCKET mListenSocket;
  bool mSkipRemoteLookup;
  void lookupRemoteHost(struct sockaddr *from, MString& remoteHost);

};

inline ostream& operator<< (ostream& s, const MAcceptor& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MAcceptor& c) {
  c.streamIn(s);
  return s;
}

#endif
