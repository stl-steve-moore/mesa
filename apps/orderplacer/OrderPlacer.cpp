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

/* File: OrderPlacer.cpp

IHE Mesa server: OrderPlacer

5/1999 FDS

*/

#include "MHL7Acceptor.hpp"
#include "MHL7Factory.hpp"
#include "MHL7Messenger.hpp"
#include "MOPMessenger.hpp"
#include "MDBInterface.hpp"
#include "MESA.hpp"

static const u_short PORT = 3000;

static sig_atomic_t finished=0;
extern "C" void signalAction (int)
{
  finished = 1;
}

using namespace std;

int main(int argc, char** argv)
{ 
  ACE_Reactor reactor;
  MHL7Factory factory("", ".v22");
  MDBInterface OrderPlacerDB ("adt");
  MOPMessenger messenger (factory, OrderPlacerDB);
  MHL7LLPHandler handler (messenger);
  //MHL7Acceptor acceptor (factory, OrderPlacerDB);
  MHL7Acceptor acceptor (messenger, handler);
 
  //Setup signal handler
  ACE_Sig_Action action ((ACE_SignalHandler) signalAction, 
		     SIGINT);
  if (acceptor.open (ACE_INET_Addr(PORT),
			   &reactor) == -1)
    ACE_ERROR_RETURN ((LM_ERROR,
		       "%p\n",
		       " open"),
		      -1);
  ACE_DEBUG ((LM_DEBUG,
	      "(%P|%t) Firing up the OrderPlacer server, port %d\n", 
	      PORT));  

  // Tell reactor to listen for messages:
  while (!finished)
    reactor.handle_events();

  //We have been closed by a ^C signal.
  ACE_DEBUG ((LM_DEBUG,
	      "(%P|%t) Shutting down the OrderPlacer server\n"));

  return 0;
}
