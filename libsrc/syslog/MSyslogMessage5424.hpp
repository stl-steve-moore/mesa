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

// $Id: MSyslogMessage5424.hpp,v 1.3 2007/04/05 20:36:16 smm Exp $ $Author: smm $ $Revision: 1.3 $ $Date: 2007/04/05 20:36:16 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MSyslogMessage5424.hpp
//
//  = AUTHOR
//	Steve Moore
//
//  = COPYRIGHT
//	Copyright HIMSS, RSNA, Washington University: 2002
//
// ====================
//
//  = VERSION
//	$Revision: 1.3 $
//
//  = DATE RELEASED
//	$Date: 2007/04/05 20:36:16 $
//
//  = COMMENTS

#ifndef MSyslogMessage5424ISIN
#define MSyslogMessage5424ISIN

//#include <iostream>
//#include <string>

#include "MDateTime.hpp"

using namespace std;

class MSyslogMessage5424
// = TITLE
//	MSyslogMessage5424 -
//
// = DESCRIPTION

{
public:
  // = The standard methods in this framework.

  MSyslogMessage5424();
  ///< Default constructor

  MSyslogMessage5424(const MSyslogMessage5424& cpy);
  ///< Copy constructor

  virtual ~MSyslogMessage5424();
  ///< Destructor

  virtual void printOn(ostream& s) const;
  /**<\brief This method is used in conjunction with the streaming operator <<
  	     to print the current state of MSyslogMessage5424 */

  virtual void streamIn(istream& s);
  /**<\brief This method is used in conjuction with the streaming operator >>
	     to read the current state of MSyslogMessage5424. */
  
  // = Class specific methods.

  MSyslogMessage5424(int facility, int severity, int version,
	const MString& message,
	const MString& timeStamp = "",
	const MString& hostName = "",
	const MString& appName = "",
	const MString& procID = "",
	const MString& msgID  = "",
	bool flagUTF8 = true);

  // Constructor with arguments

  void facility(int facility);

  int facility( ) const;

  void severity(int facility);

  int severity( ) const;

  int message(char* message, unsigned long length);
  int messageReference(unsigned char* message, unsigned long length);
  int message(const MString& message);

  char* copyOfMessage(unsigned long& length) const;

  const unsigned char* referenceToMessage(unsigned long& length) const; 

  void timeStamp(const MString& timeStamp);

  MString timeStamp( ) const;

  void hostName(const MString& hostName);

  MString hostName( ) const;

  MString appName( ) const;

  MString processID ( ) const;

  MString messageID ( ) const;

  int headerLength() const;

  int exportHeader(char* buffer,
	int bufferLength,
	int& exportedLength);

  char* exportHeader(int& exportedLength);

  int trailerLength();

  int exportTrailer(char* buffer,
	int bufferLength,
	int& exportedLength);

  char* exportTrailer(int& exportedLength);

  int messageSize() const;

  int exportMessage(char* buffer,
	int bufferLength,
	int& exportedLength);

protected:

private:
  int mFacility;
  int mSeverity;
  MString mTimeStamp;
  MString mHostName;

  int mVersion;
  MString mAppName;
  MString mProcID;
  MString mMsgID;
  bool mUTF8Flag;

  unsigned char* mMessage;
  unsigned long mMessageSize;
  bool mOwnMessage;

  int textLength(unsigned long val) const;
  void removeCurrentMessage();
  void computeTimeStamp();
  void getHostName();
};

inline ostream& operator<< (ostream& s, const MSyslogMessage5424& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MSyslogMessage5424& c) {
  c.streamIn(s);
  return s;
}

#endif
