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

// $Id: MDBInterface.hpp,v 1.16 2006/06/29 16:08:30 bhasselfeld Exp $ $Author: bhasselfeld $ $Revision: 1.16 $ $Date: 2006/06/29 16:08:30 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MDBInterface.hpp
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
//	$Revision: 1.16 $
//
//  = DATE RELEASED
//	$Date: 2006/06/29 16:08:30 $
//
//  = COMMENTS

#ifndef MDBInterfaceISIN
#define MDBInterfaceISIN

#include <iostream>
#include <string>
#include "MDBBase.hpp"
#include "MDomainObject.hpp"


using namespace std;

typedef void(MDBINTERFACE_CALLBACK_FUNCTION)(MDomainObject& obj, void* ctx);

typedef struct
{
  MString      attribute;
  TBL_OPERATOR oper;
  MString      value;
}MCriteria;

typedef vector < MCriteria > MCriteriaVector;

typedef struct
{
  MString      attribute;
  TBL_FUNCTION func;
  MString      value;
}MUpdate;

typedef vector < MUpdate > MUpdateVector;

class MDBInterface : public MDBBase
// = TITLE
///	A database interface based on the CTN libraries.
//
// = DESCRIPTION
/**	This class implements the API defined by MDBBase and provides
	database support based on the MIR CTN libraries.  The initial
	implementation uses the PostgreSQL database. */
{
public:
  // = The standard methods in this framework.

  MDBInterface();
  ///< Default constructor

  MDBInterface(const MDBInterface& cpy);

  virtual ~MDBInterface();

  virtual void printOn(ostream& s) const;
  /**<\brief This method is used in conjunction with the streaming operator <<
   to print the current state of MDBInterface. */

  virtual void streamIn(istream& s);
  
  // = Class specific methods.  0 is returned on success; -1 on failure.

  MDBInterface(const MString& databaseName);
  ///< Construct a database interface for the database databaseName.

  int initialize(const MString& databaseName);
  ///< Open the database specified in the <{databaseName}>.

  int close();
  ///< Close the database.

  int insert(const MDomainObject& domainObject);
  ///< Insert a new record into the database.  The attribute and table name are conveyed in <{domainObject}>.

  int update(const MDomainObject& domainObject,
	     const MCriteriaVector& updateCriteria,
	     const MUpdateVector& upFields);
  ///< Update values in the database. 
  /**< Use attributes in <{updateCriteria>} to determine which
   record(s) is/are updated.  The <{domainObject}> defines which table
   is updated, and <{upFields}> specifies the fields in the table to be
   update. */

  long select(MDomainObject& domainObject,
	      const MCriteriaVector& selectCriteria, 
              MDBINTERFACE_CALLBACK_FUNCTION* callback);
  ///< Select records based on the criteria in <{selectCriteria}>.
  /**< The table to search is defined by the <{domainObject}>.
   The <{callback}> function is invoked for every record which is retrieved.
   If only one record desired, then send NULL for callback.
   The signature for the <{callback}> function is
   (MDomainObject& obj, void* ctx);
   In this case, ctx will be 0.
   This method returns the number of rows that matched the selection
   criteria, or -1 on failure. */

  long select(MDomainObject& domainObject,
	      const MCriteriaVector& selectCriteria,
	      MDBINTERFACE_CALLBACK_FUNCTION* callback,
	      void* callbackCtx);
  ///< Select records based on the criteria in <{selectCriteria}>.
  /**< The table to search is defined by the <{domainObject}>.
   The <{callback}> function is invoked for every record which is retrieved.
   If only one record desired, then send NULL for callback.
   The signature for the <{callback}> function is
   (MDomainObject& obj, void* ctx);
   In the callback <{ctx}> will take on the value <{callbackCtx}>.
   This method returns the number of rows that matched the selection
   criteria, or -1 on failure.
   This method returns the number of rows that matched the selection
   criteria, or -1 on failure. */

  long selectAll(MDomainObject& domainObject,
	         MDBINTERFACE_CALLBACK_FUNCTION* callback,
	         void* callbackCtx);
  ///< Select all records in a table regardles of search criteria.
  /**< The table to search is defined by the <{domainObject}>.
   The <{callback}> function is invoked for every record which is retrieved.
   If only one record desired, then send NULL for callback.
   The signature for the <{callback}> function is
   (MDomainObject& obj, void* ctx);
   In the callback <{ctx}> will take on the value <{callbackCtx}>.
   This method returns the number of rows that matched the selection
   criteria, or -1 on failure.
   This method returns the number of rows that matched the selection
   criteria, or -1 on failure. */

  int remove(const MDomainObject& domainObject,
	     const MCriteriaVector& deleteCriteria);
  ///< Delete the record(s) specfied by the criteria in <{deleteCriteria}>.
  /** The table to search is defined by the <{domainObject}>. */

  void domainObjPtr( MDomainObject* domainObjPtr );
  void callback( MDBINTERFACE_CALLBACK_FUNCTION* callbackPtr );
  MDomainObject* domainObjPtr();
  MDBINTERFACE_CALLBACK_FUNCTION* callback();
  void* callbackContext();

private:
  MDomainObject* mDomainObjPtr;
  MDBINTERFACE_CALLBACK_FUNCTION* mCallback;
  void* mCallbackContext;
  MString mDBName;
};

CONDITION processRow( TBL_FIELD* fieldList, long count, void *dbInterface );

inline ostream& operator<< (ostream& s, const MDBInterface& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MDBInterface& c) {
  c.streamIn(s);
  return s;
}

#endif






