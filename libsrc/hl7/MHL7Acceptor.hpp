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

// $Id: MHL7Acceptor.hpp,v 1.10 2006/06/29 16:08:32 bhasselfeld Exp $ $Author: bhasselfeld $ $Revision: 1.10 $ $Date: 2006/06/29 16:08:32 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MHL7Acceptor.hpp
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
//	$Revision: 1.10 $
//
//  = DATE RELEASED
//	$Date: 2006/06/29 16:08:32 $
//
//  = COMMENTS
// Another piece of the puzzle in the ACE structure. The acceptor does
// the work of letting clients connect to us. The MHL7Acceptor is constructed
// with a Messenger object which is passed to the Handler so that messages
// can be passed smoothly to the applications.

#ifndef MHL7AcceptorISIN
#define MHL7AcceptorISIN

#include "ace/Event_Handler.h"
#include "ace/SOCK_Acceptor.h"

#include "MHL7LLPHandler.hpp"

#include "MHL7Messenger.hpp"

class MHL7Factory;
class MDBInterface;

class MHL7Acceptor : public ACE_Event_Handler
// = TITLE
///	The HL7 ACE Acceptor for MESA
//
// = DESCRIPTION
/**	This class is part of the ACE Reactor/acceptor pattern.  This class
	is registered with the Reactor for incoming connections.  For a new
	network connection, the Reactor calls the <{handle_input}> method
	of this class.  That method registers the proper message handler
	with the Reactor for further network communication. */

{
 public:
  // = The standard methods in this framework.

  ~MHL7Acceptor ();

  virtual void printOn(ostream& s) const;

  virtual void streamIn(istream& s);

  // = Class specific methods.

  MHL7Acceptor (MHL7Messenger &messenger, MHL7Handler &handler);
  /**<\brief This method copies the references passed in the <{messenger}>
   and <{handler}> arguments.  When a new connection is received,
   the <{handler}> will be cloned and registered with the Reactor
   to handle input. */

  int open (const ACE_INET_Addr &addr, ACE_Reactor *reactor);
  /**<\brief This method is to register this acceptor with the ACE_Reactor
   <{reactor}>.  The caller specificies the listening information
   in the <{addr}> argument.  This method would normally be invoked
   before entering the Reactor loop. */

 private:
  ACE_HANDLE get_handle (void) const;
  // Used by the reactor to register the handle_input() callback
  virtual int handle_input (ACE_HANDLE);
  // This method is called when a client wants to connect to the server.
  // It creates a new Messenger/Handler pair to service the connection.

 private:
  ACE_SOCK_Acceptor mPeer_acceptor;
  ACE_Reactor *mReactor;
  MHL7Messenger& mMessenger; 
  // The messenger used to service a client connection.
  MHL7Handler& mHandler;
  // The handler used to service a client connection.

  //MHL7Factory& mFactory;
  // The factory used to create messengers
  //MDBInterface& mDBInterface;
  // The database interface used to create messengers
};

#endif /* MHL7AcceptorISIN */
 
