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

#include "ace/OS.h"
#include "MESA.hpp"
#include "MString.hpp"

#include "MHL7Handler.hpp"
#include "MHL7Acceptor.hpp"
#include "ace/SOCK_Connector.h"

static char rcsid[] = "$Id: MHL7Handler.cpp,v 1.20 2000/12/20 21:14:49 smm Exp $";

/* Default Handler constructor.

Makes memory buffers to frame and deframe HL7 messages in. A frame is an HL7 message
with frame flags on it, and a stream is one without them.

*/

MHL7Handler::MHL7Handler (MHL7Messenger& messenger) :
  mVerbose(0),
  mCaptureInputStream(0),
  mMessenger(messenger),
  mStreamIndex(0),
  mStreamSize(FRAMESIZE)
{
  if (! (mStream = new char[FRAMESIZE]))
           ACE_ERROR ((LM_ERROR,
                           "(%P|%t) Cannot allocate stream buffer memory\n"));
  if (! (mFrame = new char[FRAMESIZE]))
           ACE_ERROR ((LM_ERROR,
                           "(%P|%t) Cannot allocate frame buffer memory\n"));
}

MHL7Handler::~MHL7Handler (void)
{
}

MHL7Handler::MHL7Handler (const MHL7Handler& cpy) :
  mVerbose(cpy.mVerbose),
  mCaptureInputStream(cpy.mCaptureInputStream),
  mMessenger(cpy.mMessenger),
  mStreamIndex(cpy.mStreamIndex),
  mStreamSize(cpy.mStreamSize)
{
  if (! (mStream = new char[mStreamSize]))
           ACE_ERROR ((LM_ERROR,
                           "(%P|%t) Cannot allocate stream buffer memory\n"));
  if (! (mFrame = new char[FRAMESIZE]))
           ACE_ERROR ((LM_ERROR,
                           "(%P|%t) Cannot allocate frame buffer memory\n"));
}

void 
MHL7Handler::destroy (void) 
{
    this->reactor()->remove_handler (this,
			     ACE_Event_Handler::READ_MASK |
			     ACE_Event_Handler::DONT_CALL);
    delete mStream;
    delete mFrame;
    delete this;
}

void
MHL7Handler::printOn(ostream& s) const
{
  s << "Mesa HL7 Handler";
}

void
MHL7Handler::streamIn(istream& s)
{
  //s >> this->member;
}

ACE_HANDLE
MHL7Handler::get_handle (void) const
{
  return this->peer().get_handle ();
}

MString
MHL7Handler::getPeerName()
{
  MString peerName("not connected");

  ACE_INET_Addr RemoteAddress;
  if (this->peer().get_remote_addr(RemoteAddress) != -1)
    peerName = RemoteAddress.get_host_name();
  return peerName;
}  

/* Client Handler open(Reactor) method. 

This method is called by the
acceptor's Handle_Input() method when a new client
connection comes in.

*/
int 
MHL7Handler::open (ACE_Reactor *reactor) 
{
  this->reactor (reactor);

  ACE_INET_Addr RemoteAddress;
  if (this->peer().get_remote_addr(RemoteAddress) == -1)
    return -1;

  if (mVerbose)
    cout << "MHL7Handler new connection from "
	 << RemoteAddress.get_host_name()
	 << endl;

  //Single threaded (reactor driven) Handler:
   if (this->reactor()->register_handler (this,
                                  ACE_Event_Handler::READ_MASK) == -1)
        ACE_ERROR_RETURN ((LM_ERROR,
                           "(%P|%t) cannot register with reactor\n"),
                          -1);

   //Open the Messenger
   mMessenger.open (this);

   return 0;
}

/* Client Handler open(Address, Reactor) method. 

Used to initiate a connection with a remote server.
Starts a Socket connection to "address" , and registers the Handler
with the reactor. When the server responds, the handle_input method will be called.

*/
int 
MHL7Handler::open (ACE_INET_Addr& address, ACE_Reactor *reactor) 
{
  if (mVerbose) {
    ACE_TCHAR addr[1024];
    address.addr_to_string(addr, sizeof(addr));
    cout << "MHL7Handler::open about to connect to " << addr << endl;
  }

  this->reactor (reactor);

  ACE_SOCK_Connector connector;

  if (connector.connect(this->peer(), address) == -1)
        ACE_ERROR_RETURN ((LM_ERROR,
                           "(%P|%t) Cannot connect with server\n"),
                          -1);    

  if (mVerbose) {
    cout << "MHL7Handler::open TCP connection established."
	 << endl;
  }

  //Single threaded (reactor driven) Handler:
   if (this->reactor()->register_handler (this,
                                  ACE_Event_Handler::READ_MASK) == -1)
        ACE_ERROR_RETURN ((LM_ERROR,
                           "(%P|%t) cannot register with reactor\n"),
                          -1);

   /* Opening the Messenger will register ourselves with it. 
      That will create a strong Messenger/Handler connection for servicing a socket.
   */
   mMessenger.open (this);

   return 0;
}

int
MHL7Handler::reset ()
{
    this->reactor()->remove_handler (this,
			     ACE_Event_Handler::READ_MASK |
			     ACE_Event_Handler::DONT_CALL);
    this->peer().close();  
    return 0;
}

int
MHL7Handler::close(u_long flags)
{
  if (mVerbose == -1) {
    char x[1024];
    cout << "MHL7Handler::close closing socket connection." << endl;
    cout << "Hit <ENTER> to close the connection.";
    cin.getline(x, sizeof(x));
  } else if (mVerbose)
    cout << "MHL7Handler::close closing socket connection." << endl;

  ACE_UNUSED_ARG (flags);
  this->destroy();
  return 0;
}

int
MHL7Handler::handle_close (ACE_HANDLE handle,
			 ACE_Reactor_Mask mask)
{
  ACE_UNUSED_ARG (handle);
  ACE_UNUSED_ARG (mask);

  mMessenger.destroy();
  delete mStream;
  delete mFrame;
  delete this;
  return 0;
}

int
MHL7Handler::sendSlowly (const char* stream, int length)
{
  cerr << "(MH7Handler sendSlowly) SendSlowly is a debugging method that needs to\
be implemented in a derived Handler class if needed.\n See the implementation in\
MHL7LLPHandler for details.\n";
  return 0;
}

void
MHL7Handler::verbose(int verbose)
{
  mVerbose = verbose;
}

void
MHL7Handler::captureInputStream(int flag)
{
  mCaptureInputStream = flag;
}
