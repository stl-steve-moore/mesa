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

// $Id: MHL7Handler.hpp,v 1.19 2006/06/29 16:08:32 bhasselfeld Exp $ $Author: bhasselfeld $ $Revision: 1.19 $ $Date: 2006/06/29 16:08:32 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MHL7Handler.hpp
//
//  = AUTHOR
//	F. David Sacerdoti
//
//  = COPYRIGHT
//	Copyright HIMSS, RSNA, Washington University: 1999, 2000
//
// ====================
//
//  = VERSION
//	$Revision: 1.19 $
//
//  = DATE RELEASED
//	$Date: 2006/06/29 16:08:32 $
//
//  = COMMENTS
//	The Mesa HL7 Handler base class. Specific HL7 lower layer protocols
// will be derived from this class.

#ifndef MHL7HandlerISIN
#define MHL7HandlerISIN

#include "ace/Svc_Handler.h"
#include "ace/SOCK_Stream.h"
#include "MHL7Messenger.hpp"

#define FRAMESIZE 32768
///< The initial size of an HL7 frame. Can grow as necessary.

using namespace std;

class MString;

class MHL7Handler : public ACE_Svc_Handler <ACE_SOCK_STREAM, ACE_NULL_SYNCH>
// = TITLE
///	MESA HL7 Handler base class
//
// = DESCRIPTION
/**	This defines a base class for MESA HL7 handlers.  The job of a handler
	is to frame and de-frame messages according to a specific HL7
	lower layer protocol (LLP).  Handlers which implement specific LLPs
	will inherit from this class and implement the appropriate framing
	and de-framing mechanisms.  Handlers use MHL7Messengers to turn
	HL7 streams into our HL7 objects. */

{
public:
  // = The standard methods in this framework.

  MHL7Handler(MHL7Messenger& messenger);
  ///< Default constructor

  MHL7Handler(const MHL7Handler& cpy);

  virtual ~MHL7Handler();

  virtual void printOn(ostream& s) const;
  /**<\brief This method is used in conjunction with the streaming operator <<
   to print the current state of MHL7Handler. */

  virtual void streamIn(istream& s);
  /**<\brief This method is used in conjunction with the streaming operator >>
   to read the current state of MHL7Handler. */

  // = Class specific methods.

  int open (ACE_Reactor * reactor);
  /**<\brief This method is called by an acceptor when the Reactor/acceptor receive
   a connection request from a network peer.  This method prepares the
   object to communicate and registers with the Reactor for data. */

  int open (ACE_INET_Addr & address, ACE_Reactor * reactor);
  /**<\brief Start a socket connection and register the Handler with the reactor.
   In the argument list, <{address}> specifies the host name/IP address
   and port number for the socket connection. */

  int reset ();
  /**<\brief Handler closes Socket and unregisters itself from the reactor,
   but does not to delete itself. */

  int close (u_long flags = 0);
  /**<\brief Handler closes Socket and unregisters itself from the reactor,
   and deletes itself. */

  int handle_close (ACE_HANDLE handle,
                    ACE_Reactor_Mask mask);
  /**<\brief Called by the reactor when a connection is ended.
   It deletes the current handler object. */

  virtual MHL7Handler* clone (MHL7Messenger& messenger) = 0;
  /**<\brief Classes that derive from MHL7Handler must implement the <{clone}> method.
   The derived classes should produce a new derived object and should
   also clone the <{messenger}>. */

  virtual int handle_output (const char * stream, int length) = 0; 
  /**<\brief Classes that derive from MHL7Handler must implement the <{handle_output}>
   method.  When a user wants to send an HL7 stream to a peer, it invokes
   this method with the data in the buffer <{stream}>.  <{length}> defines
   the number of bytes to transmit.  The derived class should provide the
   proper framing information and send the entire package to the peer
   application. */

  virtual int sendSlowly (const char* stream, int length);
  /**<\brief Virtual. Sends messages in fragments to test worst case
   network conditions.  Derived classes may implement this method and
   provide proper framing of the message. */

  MString getPeerName();
  ///< Returns the name of the connected client.

  void verbose(int verbose);
  /**<\brief Tell this class to have verbose output if <{verbose}> is 1 and not if
   <{verbose}> is 0. */

  void captureInputStream(int flag);
  ///< Tell this class to capture the input stream (binary) if <{flag}> is 1.

 protected:
  int mVerbose;
  int mCaptureInputStream;

  virtual int handle_input (ACE_HANDLE) = 0;
  ///< Pure Virtual. Called by the reactor to deframe a new message.
  ACE_HANDLE get_handle (void) const;
  ///< Used by the reactor to register handle_input()
  void destroy (void);
  /**<\brief Safer destructor. With it only ourselves, our derivates, and our
  friends can delete us. */

 protected:
  MHL7Messenger& mMessenger;
  ///< The messenger object which will accept HL7 message streams.
  char *mStream;
  ///< Growable stream buffer for building HL7 streams from frames
  char *mFrame;
  ///< Growable frame buffer for building outgoing messages
  int mStreamSize;
  ///< Stream buffer length
  int mStreamIndex;
  ///< Cursor for Stream. Helps decode partially recieved streams.
};

inline ostream& operator<< (ostream& s, const MHL7Handler& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MHL7Handler& c) {
  c.streamIn(s);
  return s;
}

#endif /* MHL7HandlerISIN */
