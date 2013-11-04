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

// $Id: MHL7Dispatcher.hpp,v 1.11 2006/08/07 15:01:20 smm Exp $ $Author: smm $ $Revision: 1.11 $ $Date: 2006/08/07 15:01:20 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MHL7Dispatcher.hpp
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
//	$Revision: 1.11 $
//
//  = DATE RELEASED
//	$Date: 2006/08/07 15:01:20 $
//
//  = COMMENTS
//	The MHL7Messanger recieves an HL7 message from the Handler
//	and parses it into an MHL7Msg object. 

#ifndef MHL7DispatcherISIN
#define MHL7DispatcherISIN

#define STREAMSIZE 32768
///< The size of the largest HL7 stream. Currently, It Cannot Grow.

using namespace std;

class MString;
class MHL7Factory;
class MHL7Msg;
class MHL7Handler;

class MHL7Dispatcher
// = TITLE
//
// = DESCRIPTION
/**\brief	Accepts HL7 messages and passes them to Applications via
    		the "acceptHL7Message" method interface.
	    	This class will be extended by Mesa servers.
*/
{
 friend class MHL7Handler;
 public:
  // = The standard methods in this framework.

  MHL7Dispatcher(MHL7Factory& factory);
  ///< Construct a messenger with a reference to an HL7 Factory.

  MHL7Dispatcher(const MHL7Dispatcher& cpy);

  virtual ~MHL7Dispatcher();

  virtual void printOn(ostream& s) const;
  /**<\brief This method is used in conjunction with the streaming operator <<
   to print the current state of MHL7Dispatcher. */

  virtual void streamIn(istream& s);
  /**<\brief This method is used in conjunction with the streaming operator >>
   to read the current state of MHL7Dispatcher. */

  // = Class specific methods.

  virtual MHL7Dispatcher* clone();

  int registerHandler(MHL7ProtocolHandlerLLP*  handler);

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
  /**<\brief This method receives deframed HL7 messages from network.
   The <{message}> type is determined and a a more specific accept method
   is invoked.  A class could override this method to get the feed
   of all messages in one central method. */

  int sendHL7Message(MHL7Msg& message);
  ///< Sends an HL7 <{message}> over network via the Handler.

  virtual int acceptMessageApplicationError(MHL7Msg& message,
	const MString& event, const MString& ackCode,
	const MString& errorCondition);

  virtual int acceptADT(MHL7Msg& message, const MString& event);
  /**<\brief Receive this ADT message.  <{event}> is the ADT event type (MSH 9.2).
   Users should implement this method to receive ADT messages. */

  virtual int acceptSIU(MHL7Msg& message, const MString& event);
  /**<\brief Receive this SIU message.  <{event}> is the SIU event type (MSH 9.2).
   Users should implement this method to receive SIU messages. */

  virtual int acceptORM(MHL7Msg& message, const MString& event);
  virtual int acceptORM(MHL7Msg& message, const MString& event, const bool produceORR);
  /**<\brief Receive this ORM message. <{event}> is the ORM event type (MSH 9.2).
   Users should implement this method to receive ROM messages */

  virtual int acceptORR(MHL7Msg& message, const MString& event);
  /**<\brief Receive this ORR message. <{event}> is the ORR event type (MSH 9.2).
   Users should implement this method to receive ORM messages */

  virtual int acceptACK(MHL7Msg& message, const MString& event);
  /**<\brief Receive this ACK message. <{event}> is the ACK event type (MSH 9.2).
   Users should implement this method to receive ACK messages */

  virtual int acceptXXX(MHL7Msg& message, const MString& event);
  /**<\brief Receive this XXX message. <{event}> is the XXX event type (MSH 9.2).
   Users should implement this method to receive XXX messages */

  virtual int acceptORU(MHL7Msg& message, const MString& event);
  /**<\brief Receive this ORU message. <{event}> is the ORU event type (MSH 9.2).
   Users should implement this method to receive ORU messages */

  virtual int acceptBAR(MHL7Msg& message, const MString& event);
  /**<\brief Receive this BAR message. <{event}> is the BAR event type (MSH 9.2).
   Users should implement this method to receive BAR messages */

  virtual int acceptDFT(MHL7Msg& message, const MString& event);
  /**<\brief Receive this DFT message. <{event}> is the DFT event type (MSH 9.2).
   Users should implement this method to receive DFT messages */

  virtual int acceptQBP(MHL7Msg& message, const MString& event);
  /**<\brief Receive this QBP message. <{event}> is the QBP event type (MSH 9.2).
   Users should implement this method to receive QBP messages */

  virtual int acceptRSP(MHL7Msg& message, const MString& event);
  /**<\brief Receive this RSP message. <{event}> is the RSP event type (MSH 9.2).
   Users should implement this method to receive RSP messages */

  void verbose(int verbose);
  ///< Turn verbose mode on (<{verbose}> = 1) or off (<{verbose}> = 0).

  MString acknowledgementCode() const;

protected:
  int mVerbose;

  void destroy();
  /**<\brief Safer destructor which only ourselves, our friends, and
   derivatives can use. */

protected:
  MHL7Factory& mFactory;
  ///< The factory to create new objects

  MHL7ProtocolHandlerLLP* mHandler;
  ///< The HL7 message handler used to send messages with

  int mListening;
  ///< Boolean. Tells if we have finished listening for messages (0) or are still expecting some (1).

  char* mStream;
  ///< Stream buffer to construct HL7 streams

  int mStreamSize;
  ///< Stream buffer length

  MString mAcknowledgementCode;
};

inline ostream& operator<< (ostream& s, const MHL7Dispatcher& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MHL7Dispatcher& c) {
  c.streamIn(s);
  return s;
}

#endif /* MHL7DispatcherISIN */
