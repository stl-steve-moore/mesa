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

// $Id: MLogClient.hpp,v 1.15 2006/06/29 16:08:28 bhasselfeld Exp $ $Author: bhasselfeld $ $Revision: 1.15 $ $Date: 2006/06/29 16:08:28 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MLogClient.hpp
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
//	$Revision: 1.15 $
//
//  = DATE RELEASED
//	$Date: 2006/06/29 16:08:28 $
//
//  = COMMENTS

#ifndef MLogClientISIN
#define MLogClientISIN

#include <iostream>
#include <fstream>
#include <string>

using namespace std;

class MLogClient
// = TITLE
///	Accept and store logging messages in a logging system.
//
// = DESCRIPTION
/**	This class provides the client interface to a logging system
	for applications.  Applications will typically log high-level
	or low-level events depending on the application and desires
	of the user. */
{
public:
  // = The standard methods in this framework.

  MLogClient();
  ///< Default constructor

  MLogClient(const MLogClient& cpy);
  ///< Copy constructor.

  virtual ~MLogClient();
  ///< Destructor.

  virtual void printOn(ostream& s) const;
  /**<\brief This method is used in conjunction with the streaming operator <<
   to print the current state of MLogClient */

  virtual void streamIn(istream& s);
  /**<\brief This method is used in conjunction with the streaming operator >>
   to read the current state of MLogClient */
  
  // = Class specific methods.
  typedef enum { MLOG_NONE = 0, MLOG_ERROR, MLOG_WARN, MLOG_CONVERSATION, MLOG_VERBOSE }
  LOGLEVEL;

  int initialize(LOGLEVEL level, const MString& fileName);

  ///< This method initializes the logging system and configures it for output to a file.  
  /**< The caller specifies the amount of information to
   log through the <{level}> argument and the name of the file to record
   the information in the <{fileName}> argument.
   0 is returned on success.
   -1 is returned on failure (unable to open log file). */

  int initialize(LOGLEVEL level,
		 int port = 2050, const MString& host = "localhost");

  /**<\brief This method initializes the logging system and configures it for
   output to a server.  This method is a place-holder and is not implemented. */

  void logLevel(LOGLEVEL level);

  ///< Change the current logging level.

  int log (LOGLEVEL level,
	   const MString& peer,
	   const MString& location,
	   int lineNumber,
	   const MString& message,
	   const MString& message2 = "");

  ///< This method logs several parameters.
  /**< The <{peer}> argument is a string that defines some application with
   which you are communicating.  Format of <{peer}> is unspecified.
   The <{location}> argument defines the location in the source code
   of the log message.  This is typically a class and method name.
   The <{lineNumber}> is the line in the source code where the message
   is logged.
   The <{message}> is the user generated message to be logged.
   The caller indicates the severity of the message through <{level}>.
   Messages which are less severe than the current log level are ignored.
   0 is returned on success.
   -1 is returned on failure (unable to log, initialization never invoked). */

  int log (LOGLEVEL level,
	   const MString& message);

  ///< This method logs one <{message}> to the logging system.
  /**< The caller indicates the severity of the message through <{level}>.
   Messages which are less severe than the current log level are ignored.
   0 is returned on success.
   -1 is returned on failure (unable to log, initialization never invoked). */

  int log (LOGLEVEL level,
	   const char* message);
  ///< This method logs one <{message}> to the logging system.
  /**< The caller indicates the severity of the message through <{level}>.
   Messages which are less severe than the current log level are ignored.
   This signature is included to reduce conversions from char* to MString.
   0 is returned on success.
   -1 is returned on failure (unable to log, initialization never invoked). */

  int log (LOGLEVEL level,
	   const char c);
  ///< This method logs one character <{c}> to the logging system.
  /** The caller indicates the severity of the message through <{level}>.
   Messages which are less severe than the current log level are ignored. */

  int log (LOGLEVEL level,
	   int length,
	   const char* message);
  ///< This method logs message to the logging system. 
  /**< This is intended to dump ASCII messages received from a peer; they are logged with
   no further decoration.
   The caller indicates the severity of the message through <{level}>.
   Messages which are less severe than the current log level are ignored.
   The number of characters to dump are specified through <{length}>. */

  int logCTNErrorStack(LOGLEVEL level, const MString& modifier);
  ///< This method walks through the CTN error stack and logs all of the error messages on the stack. 
  /**< A common LOGLEVEL is passed in the <{level}> argument.
   The <{modifier}> argument is a common string to be appended to each CTN
   error message. */

  int logTimeStamp (LOGLEVEL level,
	   const MString& message);

  ///< This method logs one <{message}> to the logging system and includes a time stamp in the log file.
  /**< The caller indicates the severity of the message through <{level}>.
   Messages which are less severe than the current log level are ignored.
   0 is returned on success.
   -1 is returned on failure (unable to log, initialization never invoked). */

  void truncate();
  ///< Truncate the existing log file.

  void close();

  ///< Close the logging system.

private:
  static LOGLEVEL mLevel;
  //static ofstream mStream;
  //static int mPort;
  static char* mLogFileName;
};

inline ostream& operator<< (ostream& s, const MLogClient& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MLogClient& c) {
  c.streamIn(s);
  return s;
}

#endif
