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

// $Id: MHL7ProtocolHandlerLLP.hpp,v 1.5 2006/06/29 16:08:32 bhasselfeld Exp $ $Author: bhasselfeld $ $Revision: 1.5 $ $Date: 2006/06/29 16:08:32 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MHL7ProtocolHandlerLLP.hpp
//
//  = AUTHOR
//
//  = COPYRIGHT
//	Copyright HIMSS, RSNA, Washington University: 1999, 2000
//
// ====================
//
//  = VERSION
//	$Revision: 1.5 $
//
//  = DATE RELEASED
//	$Date: 2006/06/29 16:08:32 $
//
//  = COMMENTS

#ifndef MHL7ProtocolHandlerLLPISIN
#define MHL7ProtocolHandlerLLPISIN

#define FRAMESIZE 1024*1024
///< The initial size of an HL7 frame. Can grow as necessary.

using namespace std;

class MString;
class MNetworkProxy;
class MHL7Msg;
class MHL7Dispatcher;

class MHL7ProtocolHandlerLLP
// = TITLE
//
// = DESCRIPTION

{
public:
  // = The standard methods in this framework.

  MHL7ProtocolHandlerLLP(MNetworkProxy* proxy);
  ///< Default constructor

  MHL7ProtocolHandlerLLP(const MHL7ProtocolHandlerLLP& cpy);

  virtual ~MHL7ProtocolHandlerLLP();

  virtual void printOn(ostream& s) const;
  /**<\brief This method is used in conjunction with the streaming operator <<
   to print the current state of MHL7ProtocolHandlerLLP. */

  virtual void streamIn(istream& s);
  /**<\brief This method is used in conjunction with the streaming operator >>
   to read the current state of MHL7ProtocolHandlerLLP. */

  // = Class specific methods.
  int sendHL7Message(MHL7Msg& msg);

  MNetworkProxy* getNetworkProxy();

  int registerDispatcher(MHL7Dispatcher* dispatcher);

  int handleInput();

  void captureInputStream(bool flag, const MString& captureFileName = "");

 protected:
  MNetworkProxy* mProxy;
  MHL7Dispatcher* mDispatcher;

 protected:
  char *mStream;
  ///< Growable stream buffer for building HL7 streams from frames

  char *mFrame;
  ///< Growable frame buffer for building outgoing messages

  int mStreamSize;
  ///< Stream buffer length

  int mStreamIndex;
  // Cursor for Stream. Helps decode partially recieved streams.

  bool mCaptureInputStream;
  MString mCaptureFileName;

 private:
  int mInFrame;
  int mEndBlock;
};

inline ostream& operator<< (ostream& s, const MHL7ProtocolHandlerLLP& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MHL7ProtocolHandlerLLP& c) {
  c.streamIn(s);
  return s;
}

#endif /* MHL7ProtocolHandlerLLPISIN */
