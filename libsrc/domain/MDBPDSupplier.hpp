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

// $Id: MDBPDSupplier.hpp,v 1.3 2006/06/30 03:30:10 smm Exp $ $Author: smm $ $Revision: 1.3 $ $Date: 2006/06/30 03:30:10 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MDBPDSupplier.hpp
//
//  = AUTHOR
//	Steve Moore
//
//  = COPYRIGHT
//	Copyright HIMSS, RSNA, Washington University: 2003
//
// ====================
//
//  = VERSION
//	$Revision: 1.3 $
//
//  = DATE RELEASED
//	$Date: 2006/06/30 03:30:10 $
//
//  = COMMENTS

#ifndef MDBPDSupplierISIN
#define MDBPDSupplierISIN

#include <iostream>
#include <string>
#include "MDBInterface.hpp"
#include "MMWL.hpp"
#include "MIdentifier.hpp"

using namespace std;

#include "MString.hpp"
#include "MDomainObject.hpp"
#include "MPatient.hpp"
#include "MVisit.hpp"
#include "MIssuer.hpp"
#include "MDBInterface.hpp"

class MDBPDSupplier
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
  MDBPDSupplier();
  // Default constructor

  MDBPDSupplier(const MDBPDSupplier& cpy);

  virtual ~MDBPDSupplier();

  virtual void printOn(ostream& s) const;
  /**<\brief This method is used in conjunction with the streaming operator <<
             to print the current state of MDBPDSupplier. */

  virtual void streamIn(istream& s);
  
  // = Class specific methods.  Methods return 0 on success and -1 on failure.

  MDBPDSupplier(const MString& databaseName);
  ///< This constructor creates the object and opens a link to the database named by <{databaseName}>.

  int openDatabase( const MString& databaseName);
  /**<\brief This method should be used in conjunction with the default constructor. 
             It opens the database named by <{databaseName}>. */

  int admitRegisterPatient(const MPatient& patient, const MVisit& visit);
  ///< A patient has been admitted as an in-patient or registered as an outpatient.  
  /**< The <{visit}> argument defines the registration mode. Update our tables accordingly.*/

  int preRegisterPatient(const MPatient& patient, const MVisit& visit);
  ///< A patient has been pre registered. 
  /**< The <{visit}> argument defines the registration mode. Update our tables accordingly. */

  int updateADTInfo(const MPatient& patient);
  ///< Invoke this method to update the registration information of an existing patient.  
  /**< In the argument list, <{patient}> contains the attributes to be udpated. */

  int updateADTInfo(const MPatient& patient, const MVisit& visit);
  ///< Invoke this method to update the registration and visit information of an existing patient.  
  /**< In the argument list, <{patient}> and <{visit}> contain the attributes to be udpated
       in the database. */

  int transferPatient(const MVisit& visit);
  ///< Patient has been transferred.  Update our records with new location described in the <{visit}> argument.

  int mergePatient(const MPatient& patient, const MString& issuer);

  int crossReferenceLookup(MPatientVector& v, const MString& patientID,
	const MString& issuer);

  int demographicsQueryLookup(MPatientVector& v, const MPatient& patient);

private:
  MDBInterface* mDBInterface;
  MMWLVector mMWLVector;
  MIdentifier mIdentifier;

  // following functions check to see if at least one record exists
  // in the table
  int recordExists(const MPatient& patient);
  int recordExists(const MVisit& visit);
  int recordExists(const MIssuer& issuer);

  // following functions add a record to a table, for placer order,
  // use addOrder() function and not addRecord() even though MFillerOrder
  // will qualify as an MDomainObject.
  int addRecord(const MDomainObject& domainObject);
  int addRecord(const MPatient& patient);

  // following functions delete records from the table
  int deleteRecord(const MPatient& patient);
  int deleteRecord(const MVisit& visit);

  // following functions update records in the table
  int updateRecord(const MPatient& patient);
  int updateRecord(const MVisit& visit);

  // use the following functions to set search criteria on different tables
  void setCriteria(const MPatient& patient, MCriteriaVector& cv);
  void setCriteria(const MVisit& visit, MCriteriaVector& cv);
  void setCriteria(const MIssuer& issuer, MCriteriaVector& cv);

  // use the following function to set update values for a given table
  void setCriteria(const MDomainObject& domainObject, MUpdateVector& uv);

};

inline ostream& operator<< (ostream& s, const MDBPDSupplier& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MDBPDSupplier& c) {
  c.streamIn(s);
  return s;
}

#endif
