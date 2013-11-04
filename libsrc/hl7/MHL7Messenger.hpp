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

// $Id: MHL7Messenger.hpp,v 1.28 2006/06/29 16:08:32 bhasselfeld Exp $ $Author: bhasselfeld $ $Revision: 1.28 $ $Date: 2006/06/29 16:08:32 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MHL7Messenger.hpp
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
//	$Revision: 1.28 $
//
//  = DATE RELEASED
//	$Date: 2006/06/29 16:08:32 $
//
//  = COMMENTS
//	The MHL7Messanger recieves an HL7 message from the Handler
//	and parses it into an MHL7Msg object. 

#ifndef MHL7MessengerISIN
#define MHL7MessengerISIN

#define STREAMSIZE 32768
///< The size of the largest HL7 stream. Currently, It Cannot Grow.

using namespace std;

class MString;
class MHL7Factory;
class MHL7Msg;
class MHL7Handler;

class MHL7Messenger
// = TITLE
///	MESA HL7 Messenger base class
//
// = DESCRIPTION
/**	Accepts HL7 messages and passes them to Applications via
      the "acceptHL7Message" method interface.
      This class will be extended by Mesa servers. */

{
 friend class MHL7Handler;
 public:
  // = The standard methods in this framework.

  MHL7Messenger(MHL7Factory& factory);
  ///< Construct a messenger with a reference to an HL7 Factory.

  MHL7Messenger(const MHL7Messenger& cpy);

  virtual ~MHL7Messenger();

  virtual void printOn(ostream& s) const;
  /**<\brief This method is used in conjunction with the streaming operator <<
   to print the current state of MHL7Messenger. */

  virtual void streamIn(istream& s);
  /**<\brief This method is used in conjunction with the streaming operator >>
   to read the current state of MHL7Messenger. */

  // = Class specific methods.

  virtual MHL7Messenger* clone();
  ///< Virtual. Creates a new Messenger copy. 
  /** Derived classes need to implement this method and copy their
   state during the clone operation.  The owner of the new <{MHL7Messenger}>
   will need to destroy the object with <{delete}>. */

  int open (MHL7Handler*  handler);
  /**<\brief Registers a <{handler}> with this messenger.  The handler accepts TCP/IP
   streams and forwards a complete HL7 message stream to this messenger. */

  int notFinished() { return mListening; }
  ///< Accessor for mListening, used in client's loop conditions.

  int close ();
  ///< Cleans up after messenger is finished. 

  int acceptStream (const char* txt, int len);
  /**<\brief Receive this stream of characters which constitute a complete HL7 Message.
   The stream of characters is passed in <{txt}>.  <{len}> carries the
   number of bytes in the message.  All framing characters are removed. */

  virtual void logHL7Stream(const char* txt, int len);
  /**<\brief Provide a mechanism for logging the stream of bytes which was
   received as an HL7 message.  This allows a real handler to override
   this method and log the stream as desired.
   The stream of characters is passed in <{txt}>.  <{len}> carries the
   number of bytes in the message.  All framing characters are removed. */

  virtual int acceptHL7Message(MHL7Msg& message);
  ///< This method receives deframed HL7 messages from network.
  /** The <{message}> type is determined and a a more specific accept method
   is invoked.  A class could override this method to get the feed
   of all messages in one central method. */

  int sendHL7Message(MHL7Msg& message);
  ///< Sends an HL7 <{message}> over network via the Handler.

  int sendSlowly (MHL7Msg& message);
  ///< Used for stressing the hl7 system. Sends an HL7 <{message}> in fragments.

  virtual int acceptADT(MHL7Msg& message, const MString& event);
  ///< Receive this ADT message. event is the ADT event type (MSH 9.2).
  ///<  Users should implement this method to receive ADT messages. 

  virtual int acceptORM(MHL7Msg& message, const MString& event);
  ///< Receive this ORM message. event is the ORM event type (MSH 9.2).
  ///<  Users should implement this method to receive ROM messages

  virtual int acceptORR(MHL7Msg& message, const MString& event);
  ///< Receive this ORR message. event is the ORR event type (MSH 9.2). 
  ///< Users should implement this method to receive ORM messages

  virtual int acceptACK(MHL7Msg& message, const MString& event);
  ///< Receive this ACK message. event is the ACK event type (MSH 9.2).
  ///< Users should implement this method to receive ACK messages

  virtual int acceptXXX(MHL7Msg& message, const MString& event);
  ///< Receive this XXX message. event is the XXX event type (MSH 9.2).
  ///< Users should implement this method to receive XXX messages

  virtual int acceptORU(MHL7Msg& message, const MString& event);
  ///< Receive this ORU message. event is the ORU event type (MSH 9.2).
  ///< Users should implement this method to receive ORU messages

  virtual int acceptBAR(MHL7Msg& message, const MString& event);
  ///< Receive this BAR message. event is the BAR event type (MSH 9.2).
  ///< Users should implement this method to receive BAR messages

  virtual int acceptDFT(MHL7Msg& message, const MString& event);
  ///< Receive this DFT message. event is the DFT event type (MSH 9.2).
  ///< Users should implement this method to receive DFT messages

  void verbose(int verbose);
  ///< Turn verbose mode on (<{verbose}> = 1) or off (<{verbose}> = 0).

protected:
  int mVerbose;

  void destroy();
  ///< Safer destructor which only ourselves, our friends, and derivatives can use.

protected:
  MHL7Factory& mFactory;
  ///< The factory to create new objects
  MHL7Handler* mHandler;
  ///< The HL7 message handler used to send messages with
  int mListening;
  ///< Boolean. Tells if we have finished listening for messages (0) or are still expecting some (1).
  char* mStream;
  ///< Stream buffer to construct HL7 streams
  int mStreamSize;
  ///< Stream buffer length
};

inline ostream& operator<< (ostream& s, const MHL7Messenger& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MHL7Messenger& c) {
  c.streamIn(s);
  return s;
}

#endif /* MHL7MessengerISIN */
