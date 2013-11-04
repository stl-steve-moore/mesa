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

// $Id: MDBOrderFiller.hpp,v 1.27 2008/03/02 03:57:37 smm Exp $ $Author: smm $ $Revision: 1.27 $ $Date: 2008/03/02 03:57:37 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MDBOrderFiller.hpp
//
//  = AUTHOR
//	Phil DiCorpo
//
//  = COPYRIGHT
//	Copyright HIMSS, RSNA, Washington University: 1999, 2000
//
// ====================
//
//  = VERSION
//	$Revision: 1.27 $
//
//  = DATE RELEASED
//	$Date: 2008/03/02 03:57:37 $
//
//  = COMMENTS

#ifndef MDBOrderFillerISIN
#define MDBOrderFillerISIN

#include <iostream>
#include <string>
#include "MDBOrderFillerBase.hpp"
#include "MDBInterface.hpp"
#include "MMWL.hpp"
#include "MIdentifier.hpp"

using namespace std;

#include "MString.hpp"
#include "MDomainObject.hpp"
#include "MPatient.hpp"
#include "MVisit.hpp"
#include "MFillerOrder.hpp"
#include "MPlacerOrder.hpp"
#include "MOrder.hpp"
#include "MDBInterface.hpp"
#include "MDBOFClient.hpp"

class MDBOrderFiller : public MDBOrderFillerBase
// = TITLE
///	Interface to a relational database for an Order Filler.
//
// = DESCRIPTION
/**	This class provides operations on a relational database that are
	of use to an Order Filler(as defined in the IHE Technical Framework).
	Users of this class should open the database by calling the
	constructor with a database name or by using the default constructor
	and the openDatabase method.  Once the database is open, any
	other method may be invoked. */

{

public:

  // = The standard methods in this framework.
  MDBOrderFiller();
  ///< Default constructor

  MDBOrderFiller(const MDBOrderFiller& cpy);

  virtual ~MDBOrderFiller();

  virtual void printOn(ostream& s) const;
  /**<\brief This method is used in conjunction with the streaming operator <<
  to print the current state of MDBOrderFiller. */

  virtual void streamIn(istream& s);
  
  // = Class specific methods.  Methods return 0 on success and -1 on failure.

  MDBOrderFiller(const MString& databaseName);
  ///< This constructor creates the object and opens a link to the database named by <{databaseName}>.

  int openDatabase( const MString& databaseName);
  /**<\brief This method should be used in conjunction with the default constructor. 
             It opens the database named by <{databaseName}>. */

  int admitRegisterPatient(const MPatient& patient, const MVisit& visit);
  ///< A patient has been admitted as an in-patient or registered as an outpatient.  T
  /**< The <{visit}> argument defines the registration mode. Update our tables accordingly. */

  int preRegisterPatient(const MPatient& patient, const MVisit& visit);
  ///< A patient has been pre registered.
  /**< The <{visit}> argument defines the registration mode.
   Update our tables accordingly. */

  int updateADTInfo(const MPatient& patient);
  ///< Invoke this method to update the registration information of an existing patient.  
  /**< In the argument list, <{patient}> contains the attributes to be udpated. */

  int updateADTInfo(const MPatient& patient, const MVisit& visit);
  ///< Invoke this method to update the registration and visit information of an existing patient.  
  /**< In the argument list,
   <{patient}> and <{visit}> contain the attributes to be udpated
   in the database. */

  int transferPatient(const MVisit& visit);
  ///< Patient has been transferred.  Update our records with new location described in the <{visit}> argument.

  int mergePatient(const MPatient& patient, const MString& issuer);

  int enterOrder(const MFillerOrder& order);
  ///< An order is placed if patient record exists.  
  /**< Enter the order information
   into the database.  In the argument list, the <{order}> variable contains
   the order information to be entered in the database. */

  int enterOrder(const MPlacerOrder& order);
  ///< An order is placed if patient record exists.  
  /**< Enter the order information
   into the database.  In the argument list, the <{order}> variable contains
   the order informatin to be entered in the database. */

  int updatePlacerOrderNumber(const MFillerOrder& order);
  ///< This method is called to update the Placer Order Number.  
  /**< This typically
   happens when the Filler places the original order and the Placer responds
   with the Placer Order Number.  The <{order}> variable contains information
   to identify the original order and the new Placer Order Number. */

  int updateOrder(const MFillerOrder& order);
  ///< Update all fields in the Order database corresponding to the order passed in <{order}>.  
  /**< This method requires that a patient record exist in the database before the update is performed. */

  int cancelOrder(const MFillerOrder& order);
  ///< Cancel the order in the database corresponding to the data in <{order}>.
  /**< This implementation deletes the order record.  It should probably keep
   the record and mark it as canceled. */

  int getOrder(MPatient& patient, MPlacerOrder& order);
  ///< Retrieve a Placer Order from the database.  
  /**< Search on the patient ID in the <{patient}> and the Placer Order Number in <{order}>.  Retrieve
   the order and write it into the caller's <{order}> variable. */

  int getOrder(MPatient& patient, MFillerOrder& order);
  ///< Retrieve a Filler Order from the database.  
  /**< Search on the patient ID
   in the <{patient}> and the Placer Order Number and Filler Order Number
   in <{order}>.  Retrieve the order and write it into the
   caller's <{order}> variable. */

  int queryModalityWorkList(const MMWL& mwl, MDBOFClient& client);
  ///< Query for Modality Worklist items.  
  /**< The caller's <{MWL}> variable provides
   the search criteria.  For each record found in the database, invoke
   <{selectCallback}> method on the caller's <{client}> object. */

  int addToVector(const MMWL& mwl);
  ///< This method is public for use in callback functions.  It add one MMWL record to an internal vector.

  int queryUnifiedWorkList(const MUPS& ups, MDBOFClient& client);
  ///< Query for Unified Worklist
  /**< The caller's <{UPS}> variable provides
   the search criteria.  For each record found in the database, invoke
   <{selectCallback}> method on the caller's <{client}> object. */

  int addToVector(const MUPS& ups);
  ///< This method is public for use in callback functions.  It add one MMWL record to an internal vector.


  MString newStudyInstanceUID() const;
  ///< Create a new DICOM Study Instance UID and return for caller to use.

private:
  MDBInterface* mDBInterface;
  MMWLVector mMWLVector;
  MUPSVector mUPSVector;
  MIdentifier mIdentifier;

  // following functions check to see if at least one record exists
  // in the table
  int recordExists(const MPatient& patient);
  int recordExists(const MVisit& visit);
  int recordExists(const MFillerOrder& order);
  int recordExists(const MPlacerOrder& order);
  int recordExists(const MOrder& order);

  // following functions add a record to a table, for placer order,
  // use addOrder() function and not addRecord() even though MFillerOrder
  // will qualify as an MDomainObject.
  int addRecord(const MDomainObject& domainObject);
  int addRecord(const MPatient& patient);
  int addOrder(const MFillerOrder& order);
  int addOrder(const MPlacerOrder& order);

  // following functions delete records from the table
  int deleteRecord(const MPatient& patient);
  int deleteRecord(const MVisit& visit);
  int deleteRecord(const MFillerOrder& order);
  int deleteRecord(const MPlacerOrder& order);
  int deleteRecord(const MOrder& order);

  // following functions update records in the table
  int updateRecord(const MPatient& patient);
  int updateRecord(const MVisit& visit);
  int updateRecord(const MFillerOrder& order);
  int updateRecord(const MPlacerOrder& order);
  int updateRecord(const MOrder& order);
  int updateRecord(const MMWL& mwl);

  // use the following functions to set search criteria on different tables
  void setCriteria(const MPatient& patient, MCriteriaVector& cv);
  void setCriteria(const MVisit& Visit, MCriteriaVector& cv);
  void setCriteria(const MFillerOrder& order, MCriteriaVector& cv);
  void setCriteria(const MPlacerOrder& order, MCriteriaVector& cv);
  void setCriteria(const MOrder& order, MCriteriaVector& cv);
  void setCriteria(const MMWL& mwl, MCriteriaVector& cv);

  // use the following function to set update values for a given table
  void setCriteria(const MDomainObject& domainObject, MUpdateVector& uv);

};

inline ostream& operator<< (ostream& s, const MDBOrderFiller& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MDBOrderFiller& c) {
  c.streamIn(s);
  return s;
}

#endif
