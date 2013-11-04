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

// $Id: MHL7LLPHandler.hpp,v 1.9 2006/06/29 16:08:32 bhasselfeld Exp $ $Author: bhasselfeld $ $Revision: 1.9 $ $Date: 2006/06/29 16:08:32 $ $State: Exp $
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
//	$Revision: 1.9 $
//
//  = DATE RELEASED
//	$Date: 2006/06/29 16:08:32 $
//
//  = COMMENTTEXT
//	The handler for HL7 messages in MESA.
// Receives HL7 messages from the ACE reactor and passes
// them to the acceptStream method of a Messenger object.

// Terms:
//   FRAME:  an HL7 message with the framing flags on either end of it.
//   STREAM: an complete HL7 message without the framing flags.
//           An unstructured stream of chars.

#ifndef MHL7LLPHandlerISIN
#define MHL7LLPHandlerISIN

#include "MHL7Handler.hpp"

#define FRAMESIZE 32768
// The initial size of an HL7 frame. Can grow as necessary.

//=using namespace std;

class MHL7LLPHandler : public MHL7Handler
// = TITLE
///	The HL7 LLP message handler in MESA. Derived from MHL7Handler.
//
// = DESCRIPTION
/**	Recieves HL7 message frames from clients (via the ACE reactor)
	deframes them using the HL7 LLP protocol, and passes them to
	the MHL7Messenger. */
{
public:
  // = The standard methods in this framework.

  ~MHL7LLPHandler();

  void printOn(ostream& s) const;

  void streamIn(istream& s);
  
  // = Class specific methods.

  MHL7LLPHandler(MHL7Messenger& messenger);
  /**<\brief Construct a handler with a reference to the <{messenger}> object.
   This constructor keeps a copy of the reference to the <{messenger}>.
   The <{messenger}> is used to accept a stream of de-framed HL7 data. */

  virtual MHL7Handler* clone (MHL7Messenger& messenger);
  /**<\brief Creates a new LLP Handler copy and returns the clone to the caller.
   The <{messenger}> reference is passed to the constructor for
   <{MHL7LLPHandler}> during the clone operation. */

  int handle_output (const char * stream, int length); 
  /**<\brief Adds framing flags and sends an HL7 frame over the network.  <{stream}>
   contains an HL7 stream of data of <{length}> bytes. */

  int sendSlowly (const char* stream, int length);
  /**<\brief A debugging aid to test network operations.  This method adds framing
   flags and sends the data in <{stream}> to a peer in small pieces.
   <{length}> defines the size of the HL7 stream to transmit. */

 protected:
  int handle_input (ACE_HANDLE);
  ///< Called by the reactor to deframe a new message.  

 private:
  int mInFrame;
  // State variable for deframing machine
  int mEndBlock;
  // State variable for deframing machine

};

inline ostream& operator<< (ostream& s, const MHL7LLPHandler& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MHL7LLPHandler& c) {
  c.streamIn(s);
  return s;
}

#endif /* MHL7LLPHandlerISIN */
