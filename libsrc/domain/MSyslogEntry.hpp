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

// $Id: MSyslogEntry.hpp,v 1.2 2006/06/29 16:08:32 bhasselfeld Exp $ $Author: bhasselfeld $ $Revision: 1.2 $ $Date: 2006/06/29 16:08:32 $ $State: Exp $
// ======================
// = FILENAME
//	MSyslogEntry.hpp
//
// = AUTHOR
//	Steve Moore
//
//  = COPYRIGHT
//	Copyright HIMSS, RSNA, Washington University: 1999, 2000
// ====================
//
//  = VERSION
//	$Revision: 1.2 $
//
//  = DATE RELEASED
//	$Date: 2006/06/29 16:08:32 $
//
//  = COMMENTS
//
#ifndef MSyslogEntryISIN
#define MSyslogEntryISIN

#include <iostream>
#include "MDomainObject.hpp"

class MSyslogEntry;
typedef vector < MSyslogEntry > MSyslogEntryVector;

using namespace std;

// = TITLE
///	A domain object which represents a syslog entry
//
// = DESCRIPTION
/**	This class is a container for attributes which define a syslog entry.
	It inherits from <{MDomainObject}> and supports the
	ability to get and set values with specific methods.  Because this
	class is just a container, it performs no validation tests. */

class MSyslogEntry : public MDomainObject
{
public:
  // The standard methods in this framework.

  MSyslogEntry();
  ///< Default constructor.

  MSyslogEntry(const MSyslogEntry& syslogEntry);

  ~MSyslogEntry();

  virtual void printOn(ostream& s) const;

  virtual void streamIn(istream& s);

  // Class specific methods.

  MSyslogEntry(const MString& facility, const MString& severity,
	const MString& timeStamp, const MString& dateStamp,
	const MString& dateTime,
	const MString& host, const MString& message,
	const MString& identifier);
  ///< This constructor takes all of the attributes which are managed by this class.

  void import(const MDomainObject& o);
  /**<\brief This method imports the key-value pairs which are in the domain object
  	     <{o}>.  These values are used to overwrite any existing values in
  	     the MSyslogEntry object. */

  // Get methods whose names match attribute names.
  MString facility() const;
  MString severity() const;
  MString timeStamp() const;
  MString dateStamp() const;
  MString dateTime() const;
  MString host() const;
  MString message() const;
  MString identifier() const;

  // Set methods whose names match attribute names.
  void facility(const MString& s);
  void severity(const MString& s);
  void timeStamp(const MString& s);
  void dateStamp(const MString& s);
  void dateTime(const MString& s);
  void host(const MString& s);
  void message(const MString& s);
  void identifier(const MString& s);

private:
  
  MString mFacility;
  MString mSeverity;
  MString mTimeStamp;
  MString mDateStamp;
  MString mDateTime;
  MString mHost;
  MString mMessage;
  MString mIdentifier;

  void fillMap();

};

inline ostream& operator<< (ostream& s, const MSyslogEntry& syslogEntry) {
	  syslogEntry.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MSyslogEntry& syslogEntry) {
  syslogEntry.streamIn(s);
  return s;
}

#endif
