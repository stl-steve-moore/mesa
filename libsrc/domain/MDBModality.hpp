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

// $Id: MDBModality.hpp,v 1.11 2006/06/29 16:08:30 bhasselfeld Exp $ $Author: bhasselfeld $ $Revision: 1.11 $ $Date: 2006/06/29 16:08:30 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MDBModality.hpp
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
//	$Revision: 1.11 $
//
//  = DATE RELEASED
//	$Date: 2006/06/29 16:08:30 $
//
//  = COMMENTS

#ifndef MDBModalityISIN
#define MDBModalityISIN

#include <iostream>
#include <string>

#include "MIdentifier.hpp"
#include "MDBInterface.hpp"

#include "MPatient.hpp"
#include "MVisit.hpp"

using namespace std;

class MDBModality
// = TITLE
///	Database functions that are used by a modality.
//
// = DESCRIPTION
/**	This class implements database methods that are useful for modalities
	as defined in the IHE Technical Framework.  Call the constructor
	with the name of a database or call the <{open}> method to open the
	database.  Once the database is open, you may call the DB methods. */

{
public:
  // = The standard methods in this framework.
  MDBModality();
  ///< Default constructor

  MDBModality(const MDBModality& cpy);

  virtual ~MDBModality();

  virtual void printOn(ostream& s) const;
  /**<\brief This method is used in conjunction with the streaming operator <<
   to print the current state of MDBModality. */

  virtual void streamIn(istream& s);
  
  // = Class specific methods.
  MDBModality(const string& databaseName);
  ///< Construct a Modality DB interface for the database whose name is in <{databaseName}>.  
  /**< This constructor does not perform consistency
   checks on the database.  That is, it does not test to make
   sure that all tables are present in the database. */

  void openDatabase( const MString& databaseName);
  ///< Open and maintain a link to the database named by <{databaseName}>.  
  /**< Call this method if you construct the object with the default constructor. */

  MString newStudyInstanceUID() const;
  ///< Create a new DICOM Study Instance UID and return for caller to use.

  MString newSeriesInstanceUID() const;
  ///< Create a new DICOM Series Instance UID and return for caller to use.

  MString newSOPInstanceUID() const;
  ///< Create a new DICOM SOP Instance UID and return for caller to use.

  MString newTransactionUID() const;
  ///< Create a new DICOM Transaction UID for use in Storage Commitment operations and return for the caller to use.

  MString newPPSUID() const;
  ///< Create a new DICOM Performed Procedure Step UID and return for the caller to use.

  MString newProcedureStepID() const;
  ///< This method probably does not belong as Procedure Step IDs are created at the Order Filler.

  MString newStudyID() const;
  ///< Create a new Study ID and return for the caller to use.

private:
  MDBInterface* mDBInterface;
  MIdentifier mIdentifier;

};

inline ostream& operator<< (ostream& s, const MDBModality& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MDBModality& c) {
  c.streamIn(s);
  return s;
}

#endif
