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

// $Id: MDBOrderFillerBase.hpp,v 1.3 2008/03/02 03:57:58 smm Exp $ $Author: smm $ $Revision: 1.3 $ $Date: 2008/03/02 03:57:58 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MDBOrderFillerBase.hpp
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
//	$Revision: 1.3 $
//
//  = DATE RELEASED
//	$Date: 2008/03/02 03:57:58 $
//
//  = COMMENTS

#ifndef MDBOrderFillerBaseISIN
#define MDBOrderFillerBaseISIN

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
#include "MFillerOrder.hpp"
#include "MPlacerOrder.hpp"
#include "MOrder.hpp"
#include "MDBInterface.hpp"
#include "MDBOFClient.hpp"

class MDBOrderFillerBase
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
  MDBOrderFillerBase();
  ///< Default constructor

  MDBOrderFillerBase(const MDBOrderFillerBase& cpy);

  virtual ~MDBOrderFillerBase();

  virtual void printOn(ostream& s) const;
  /**<\brief This method is used in conjunction with the streaming operator <<
             to print the current state of MDBOrderFillerBase. */

  virtual void streamIn(istream& s);
  
  // = Class specific methods.  Methods return 0 on success and -1 on failure.

  virtual int openDatabase( const MString& databaseName) = 0;
  /**<\brief This method should be used in conjunction with the default constructor.
             It opens the database named by <{databaseName}>. */

  virtual int admitRegisterPatient(const MPatient& patient, const MVisit& visit) = 0;
  ///< A patient has been admitted as an in-patient or registered as an outpatient.  
  /**< The <{visit}> argument defines the registration mode.
       Update our tables accordingly. */

  virtual int preRegisterPatient(const MPatient& patient, const MVisit& visit) = 0;
  ///< A patient has been pre registered.
  /**< The <{visit}> argument defines the registration mode.
       Update our tables accordingly. */

  virtual int updateADTInfo(const MPatient& patient) = 0;
  ///< Invoke this method to update the registration information of an existing patient.  
  /**< In the argument list,
       <{patient}> contains the attributes to be udpated. */

  virtual int updateADTInfo(const MPatient& patient, const MVisit& visit) = 0;
  ///< Invoke this method to update the registration and visit information of an existing patient.
  /**< In the argument list, <{patient}> and <{visit}> contain the attributes to be udpated
       in the database. */

  virtual int transferPatient(const MVisit& visit) = 0;
  ///< Patient has been transferred.  Update our records with new location described in the <{visit}> argument.

  virtual int mergePatient(const MPatient& patient, const MString& issuer) = 0;

  virtual int enterOrder(const MFillerOrder& order) = 0;
  ///< An order is placed if patient record exists.  
  /**< Enter the order information into the database.  In the argument list, the <{order}> variable contains
       the order information to be entered in the database. */

  virtual int enterOrder(const MPlacerOrder& order) = 0;
  ///< An order is placed if patient record exists.  
  /**< Enter the order information into the database.  In the argument list, the <{order}> variable contains
       the order informatin to be entered in the database. */

  virtual int updatePlacerOrderNumber(const MFillerOrder& order) = 0;
  ///< This method is called to update the Placer Order Number.  
  /**< This typically happens when the Filler places the original order and the Placer responds
       with the Placer Order Number.  The <{order}> variable contains information
       to identify the original order and the new Placer Order Number. */

  virtual int updateOrder(const MFillerOrder& order) = 0;
  ///< Update all fields in the Order database corresponding to the order passed in <{order}>.  
  /**< This method requires that a patient record exist in the database before the update is performed. */

  virtual int cancelOrder(const MFillerOrder& order) = 0;
  ///< Cancel the order in the database corresponding to the data in <{order}>.
  /**< This implementation deletes the order record.  It should probably keep
       the record and mark it as canceled. */

  virtual int getOrder(MPatient& patient, MPlacerOrder& order) = 0;
  ///< Retrieve a Placer Order from the database.  
  /**< Search on the patient ID in the <{patient}> and the Placer Order Number in <{order}>.  Retrieve
       the order and write it into the caller's <{order}> variable. */

  virtual int getOrder(MPatient& patient, MFillerOrder& order) = 0;
  ///< Retrieve a Filler Order from the database.  
  /**< Search on the patient ID in the <{patient}> and the Placer Order Number and Filler Order Number
       in <{order}>.  Retrieve the order and write it into the
       caller's <{order}> variable. */

  virtual int queryModalityWorkList(const MMWL& mwl, MDBOFClient& client) = 0;
  ///< Query for Modality Worklist items.  The caller's <{MWL}> variable provides the search criteria.  
  /**< For each record found in the database, invoke <{selectCallback}> method on the caller's <{client}> object. */

  virtual int queryUnifiedWorkList(const MUPS& ups, MDBOFClient& client) = 0;
  ///< Query for Unified Worklist items.  The caller's <{UPS}> variable provides the search criteria.  
  /**< For each record found in the database, invoke <{selectCallback}> method on the caller's <{client}> object. */

  virtual int addToVector(const MMWL& mwl) = 0;
  ///< This method is public for use in callback functions.  It adds one MMWL record to an internal vector.
  virtual int addToVector(const MUPS& ups) = 0;
  ///< This method is public for use in callback functions.  It adds one MMWL record to an internal vector.

  virtual MString newStudyInstanceUID() const = 0;
  ///< Create a new DICOM Study Instance UID and return for caller to use.

private:

};

inline ostream& operator<< (ostream& s, const MDBOrderFillerBase& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MDBOrderFillerBase& c) {
  c.streamIn(s);
  return s;
}

#endif
