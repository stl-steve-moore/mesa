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

/* File: MHL7Acceptor.cpp

Implementation file for MHL7Acceptor class.

This whole class can be made automatically from the ACE_SOCK_ACCEPTOR
template. The difference here is that a MHL7Messanger object is used in
construction, and passed to the Handler.

Comments are from Schmidt's ACE tutorial 001:
http://www.cs.wustl.edu/~schmidt/ACE_wrappers/docs/tutorials/001/page03.html

FDS 5/1999

*/

#include "ace/ACE.h"
#include "MESA.hpp"
#include "MHL7Acceptor.hpp"

MHL7Acceptor::MHL7Acceptor (MHL7Messenger &M, MHL7Handler& H) :
  mMessenger (M),
  mHandler(H)
{
}

#if 0
MHL7Acceptor::MHL7Acceptor (MHL7Factory& F, MDBInterface& DB) :
  mFactory(F),
  mDBInterface(DB)
{
}
#endif

MHL7Acceptor::~MHL7Acceptor ()
{
}

void
MHL7Acceptor::printOn(ostream& s) const
{
  s << "Mesa HL7 Ace Acceptor";
}

void
MHL7Acceptor::streamIn(istream& s)
{
  //s >> this->member;
}

ACE_HANDLE
MHL7Acceptor::get_handle (void) const
{
  return this->mPeer_acceptor.get_handle ();
}

int
MHL7Acceptor::open (const ACE_INET_Addr &address, ACE_Reactor *reactor)
{

  if (this->mPeer_acceptor.open (address, 1) == -1) 
    return -1;

  mReactor = reactor;

  return reactor->register_handler (this,
				 ACE_Event_Handler::ACCEPT_MASK);
}

int
MHL7Acceptor::handle_input (ACE_HANDLE handle)
{
  ACE_UNUSED_ARG (handle);
  
  // Create a new Handler/Messenger object pair for connection
  MHL7Messenger* messenger = mMessenger.clone();
  MHL7Handler* handler = mHandler.clone(*messenger);
  //MHL7LLPHandler* handler = new MHL7LLPHandler(mMessenger);
  //MOPMessenger* messenger = new MOPMessenger(mFactory, mDBInterface);
  //MHL7LLPHandler* handler = new MHL7LLPHandler(messenger);

  if (this->mPeer_acceptor.accept (handler->peer()) == -1)
    ACE_ERROR_RETURN ((LM_ERROR,
		       "%p",
		       "accept failed"),
		      -1);

  if (handler->open (mReactor) == -1) {
    handler->close();
  }
  return 0;
}
