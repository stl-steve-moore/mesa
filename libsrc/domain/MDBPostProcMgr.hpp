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

// $Id: MDBPostProcMgr.hpp,v 1.6 2006/06/29 16:08:30 bhasselfeld Exp $ $Author: bhasselfeld $ $Revision: 1.6 $ $Date: 2006/06/29 16:08:30 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MDBPostProcMgr.hpp
//
//  = AUTHOR
//	David Maffitt
//
//  = COPYRIGHT
//	Copyright HIMSS, RSNA, Washington University: 1999, 2000
//
// ====================
//
//  = VERSION
//	$Revision: 1.6 $
//
//  = DATE RELEASED
//	$Date: 2006/06/29 16:08:30 $
//
//  = COMMENTS

#ifndef MDBPostProcMgrISIN
#define MDBPostProcMgrISIN

#include <iostream>
#include <string>
#include "MDBInterface.hpp"
#include "MGPWorkitemObject.hpp"
#include "MGPPPSObject.hpp"
#include "MIdentifier.hpp"

using namespace std;

#include "MDomainObject.hpp"
#include "MDBInterface.hpp"
#include "MDBPostProcMgrClient.hpp"

class MDBPostProcMgr
// = TITLE
///	Interface to a relational database for a Post Processing Manager.
//
// = DESCRIPTION
/**	This class provides operations on a relational database that are
	of use to a Post Processing Manager (as defined in the IHE Technical 
	Framework).
	Users of this class should open the database by calling the
	constructor with a database name or by using the default constructor
	and the openDatabase method.  Once the database is open, any
	other method may be invoked. */

{

public:

  // = The standard methods in this framework.
  MDBPostProcMgr();
  ///< Default constructor

  MDBPostProcMgr(const MDBPostProcMgr& cpy);

  virtual ~MDBPostProcMgr();

  virtual void printOn(ostream& s) const;
  /**<\brief This method is used in conjunction with the streaming operator <<
             to print the current state of MDBPostProcMgr. */

  virtual void streamIn(istream& s);
  
  // = Class specific methods.  Methods return 0 on success and -1 on failure.

  MDBPostProcMgr(const MString& databaseName);
  /**<\brief This constructor creates the object and opens a link to the database
  	     named by <{databaseName}>. */

  int openDatabase( const MString& databaseName);
  /**<\brief This method should be used in conjunction with the default constructor.
  // It opens the database named by <{databaseName}>. */

  int queryPostProcWorkList( MGPWorkitemObject& workitemObject, 
		MDBPostProcMgrClient& client);
  ///< Query for Post Processing Worklist items.
  /**< The caller's <{workitemObject}> variable provides
       the search criteria.  For each record found in the database, invoke
       <{selectCallback}> method on the caller's <{client}> object. */

  int addToVector(const MGPWorkitem& workitem);
  ///< This method is public for use in callback functions.  It add one MGPWorkitem record to an internal vector.

  int findPPS(
      const MString& instanceUID,
      MGPPPSObject *pps);

  void setPPS(
      MGPPPSObject& pps);

  int findWorkitem(
      const MString& instanceUID,
      MGPWorkitem *wi);

  void updateStatus(
      MGPWorkitem& result_wi,
      MGPWorkitem& msg_wi);

  void createPPS( MGPPPSObject & pps);

  //void updatePPS( MGPPPSObject & pps);

  MString PPSstatus( const MString& sopinsuid);
  void PPSstatus( const MString& sopinsuid, const MString& status);

private:
  MDBInterface* mDBInterface;
  MGPWorkitemVector mGPWorkitemVector;
  MIdentifier mIdentifier;

  MGPWorkitemObjectVector selectStationName(
      MGPWorkitemObject& wio,
      MGPWorkitemObjectVector& prev_wio);

  MGPWorkitemObjectVector selectStationClass(
      MGPWorkitemObject& wio,
      MGPWorkitemObjectVector& prev_wio);

  void fillInputInfo(
      MGPWorkitemObjectVector& prev_wio);

/*
  // following functions check to see if at least one record exists
  // in the table
  int recordExists(const MPatient& patient);
  int recordExists(const MVisit& visit);
  int recordExists(const MFillerOrder& order);
  int recordExists(const MPlacerOrder& order);
  int recordExists(const MOrder& order);
*/

  // following functions add a record to a table, for placer order,
  // use addOrder() function and not addRecord() even though MFillerOrder
  // will qualify as an MDomainObject.
  void addWorkitem(const MGPWorkitem& workitem);

  // following functions delete records from the table
  void deleteRecord(const MGPWorkitem& workitem);

  // following functions update records in the table
  void updateRecord(const MGPWorkitem& workitem);

  // use the following functions to set search criteria on different tables
  void setCriteria(const MGPWorkitem& workitem, MCriteriaVector& cv);

  // use the following function to set update values for a given table
  void setCriteria(const MDomainObject& domainObject, MUpdateVector& uv);

};

inline ostream& operator<< (ostream& s, const MDBPostProcMgr& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MDBPostProcMgr& c) {
  c.streamIn(s);
  return s;
}

#endif
