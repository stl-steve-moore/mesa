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

// $Id: MDBOrderPlacerJapanese.hpp,v 1.2 2006/06/29 16:08:30 bhasselfeld Exp $ $Author: bhasselfeld $ $Revision: 1.2 $ $Date: 2006/06/29 16:08:30 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MDBOrderPlacerJapanese.hpp
//
//  = AUTHOR
//	Saeed Akbani
//
//  = COPYRIGHT
//	Copyright HIMSS, RSNA, Washington University: 1999, 2000
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

#ifndef MDBOrderPlacerJapaneseISIN
#define MDBOrderPlacerJapaneseISIN

#include <iostream>
#include <string>
#include "MDBInterface.hpp"
#include "MIdentifier.hpp"

using namespace std;

#include "MString.hpp"
#include "MDomainObject.hpp"
#include "MPatient.hpp"
#include "MVisit.hpp"
#include "MOrder.hpp"
#include "MPlacerOrder.hpp"
#include "MFillerOrder.hpp"
#include "MDBInterface.hpp"

class MDBOrderPlacerJapanese
// = TITLE
///	Interface to a relational database for an Order Placer.
//
// = DESCRIPTION
/**	This class provides operations on a relational database that are
	of use to an Order Placer (as defined in the IHE Technical Framework).
	Users of this class should open the database by calling the
	constructor with a database name or by using the default constructor
	and the openDatabase method.  Once the database is open, any
	other method may be invoked. */
{
public:

  // = The standard methods in this framework.

  MDBOrderPlacerJapanese();
  ///< Default constructor

  MDBOrderPlacerJapanese(const MDBOrderPlacerJapanese& cpy);

  virtual ~MDBOrderPlacerJapanese();

  virtual void printOn(ostream& s) const;
  /**<\brief This method is used in conjunction with the streaming operator <<
   to print the current state of MDBOrderPlacer. */

  virtual void streamIn(istream& s);
  
  // = Class specific methods.  Methods return 0 for success and -1 for failure.

  MDBOrderPlacerJapanese(const MString& databaseName);
  /**<\brief Construct an object and initialize a session with the database named
             in <{databaseName}>. */

  int openDatabase( const MString& databaseName);
  /**<\brief Open the database passed in the caller's <{databaseName}> argument.
  	     This method does not validate the tables in the database. */

  int admitRegisterPatient(const MPatient& patient, const MVisit& visit);
  ///< A patient has been admitted as an in-patient or registered as an outpatient.  
  /**< The visit argument defines the registration mode. Update our tables accordingly. */

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
  ///< Patient has been transferred.  
  /**< Update our records with new location described in the visit argument. */

  int mergePatient(const MPatient& patient, const MString& issuer);

  int enterOrder(const MPlacerOrder& order);
  //< An order is placed if patient record exists.  Enter the order information into the database.

  int enterOrder(const MFillerOrder& order);
  ///< An order is placed if patient record exists.  Enter the order information into the database.

  int updateOrder(const MPlacerOrder& order);
  ///< Update all fields in the Order database corresponding to the order passed in <{order}>.  
  /**< This method requires that a patient record exist in the database before the update is performed. */

  int cancelOrder(const MPlacerOrder& order);
  ///< Cancel the order in the database corresponding to the data in <{order}>.
  /**< This implementation deletes the order record.  It should probably keep
       the record and mark it as canceled. */

  int getOrder(MPatient& patient, MPlacerOrder& order);
  ///< Retrieve a Filler Order from the database.  
  /**< Search on the patient ID in the <{patient}> and the Placer Order Number
       in <{order}>.  Retrieve the order and write it into the
       caller's <{order}> variable. */

  // int newPlacerOrderNumber(MString& placerOrderNumber);
  // Create a new Placer Order Number and return it in the caller's
  // <{placerOrderNumber}> variabale.

  MString newPatientID() const;
  ///< Create a new Patient ID and return it to the caller.

  MString newPlacerOrderNumber() const;
  ///< Create a new Patient ID and return it to the caller.

private:
  MDBInterface* mDBInterface;
  MIdentifier mIdentifier;

  // following functions check to see if at least one record exists
  // in the table
  int recordExists(const MPatient& patient);
  int recordExists(const MVisit& visit);
  int recordExists(const MPlacerOrder& order);
  int recordExists(const MFillerOrder& order);
  int recordExists(const MOrder& order);

  // following functions add a record to a table, for placer order, use
  // addOrder() function and not addRecord() even though MFillerOrder
  // will qualify as an MDomainObject.
  void addRecord(const MDomainObject& domainObject);
  void addOrder(const MPlacerOrder& order);
  void addOrder(const MFillerOrder& order);

  // following functions delete records from the table
  void deleteRecord(const MPatient& patient);
  void deleteRecord(const MVisit& visit);
  void deleteRecord(const MPlacerOrder& order);
  void deleteRecord(const MFillerOrder& order);
  void deleteRecord(const MOrder& order);

  // following functions update records in the table
  void updateRecord(const MPatient& patient);
  void updateRecord(const MVisit& visit);
  void updateRecord(const MPlacerOrder& order);
  void updateRecord(const MFillerOrder& order);
  void updateRecord(const MOrder& order);

  // use the following functions to set search criteria on different tables
  void setCriteria(const MPatient& patient, MCriteriaVector& cv);
  void setCriteria(const MVisit& Visit, MCriteriaVector& cv);
  void setCriteria(const MPlacerOrder& order, MCriteriaVector& cv);
  void setCriteria(const MFillerOrder& order, MCriteriaVector& cv);
  void setCriteria(const MOrder& order, MCriteriaVector& cv);

  // use the following function to set update values for a given table
  void setCriteria(const MDomainObject& domainObject, MUpdateVector& uv);

};

static void placerOrderCallback(MDomainObject& o, void* ctx);
static void newOrderCallback(MDomainObject& o, void* ctx);

inline ostream& operator<< (ostream& s, const MDBOrderPlacerJapanese& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MDBOrderPlacerJapanese& c) {
  c.streamIn(s);
  return s;
}

#endif
