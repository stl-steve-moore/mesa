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

// $Id: MDBSyslogManager.hpp,v 1.2 2006/06/29 16:08:30 bhasselfeld Exp $ $Author: bhasselfeld $ $Revision: 1.2 $ $Date: 2006/06/29 16:08:30 $ $State: Exp $
//
// ====================
//
//  = FILENAME
//	MDBSyslogManager.hpp
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
//	$Revision: 1.2 $
//
//  = DATE RELEASED
//	$Date: 2006/06/29 16:08:30 $
//
//  = COMMENTS
//

#ifndef MDBSyslogManagerISIN
#define MDBSyslogManagerISIN

//#include <iostream>
//#include <string>
#include "MDBInterface.hpp"
#include "MSyslogEntry.hpp"

using namespace std;

class MDBSyslogManager
// = TITLE
///	Database interface for Syslog Manager
//
// = DESCRIPTION

{
public:
  // = The standard methods in this framework.
  MDBSyslogManager();
  ///< Default constructor

  MDBSyslogManager(const MDBSyslogManager& cpy);

  virtual ~MDBSyslogManager();

  virtual void printOn(ostream& s) const;
  /**<\brief This method is used in conjunction with the streaming operator <<
             to print the current state of MDBSyslogManager. */

  virtual void streamIn(istream& s);
  /**<\brief This method is used in conjunction with the streaming operator >>
  	     to read the current state of MDBSyslogManager. */

  // = Class specific methods.  All methods return 0 on success and -1 on
  // failure unless otherwise noted.

  MDBSyslogManager(const string& databaseName);
  ///< Construct an SyslogManager DB interface for the database whose name is in <{databaseName}>.  
  /**< This constructor does not perform consistency checks on the database.  
       That is, it does not test to make sure that all tables are present in the database. */

  int initialize();
  ///< Initialize the Syslog Manager.  Open the database and prepare to run.

  int initialize(const MString& databaseName);
  ///< Initialize the Syslog Manager.  Open the database named in <{databaseName}> and prepare to run.

  int enterRecord(const MSyslogEntry& entry);

  int selectRecord(const MSyslogEntry& entry, MSyslogEntryVector &v);

protected:
  MDBInterface* mDBInterface;

private:
  MString mDBName;

};

inline ostream& operator<< (ostream& s, const MDBSyslogManager& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MDBSyslogManager& c) {
  c.streamIn(s);
  return s;
}

#endif
