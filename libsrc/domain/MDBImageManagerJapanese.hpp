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

// $Id: MDBImageManagerJapanese.hpp,v 1.4 2006/06/29 16:08:29 bhasselfeld Exp $ $Author: bhasselfeld $ $Revision: 1.4 $ $Date: 2006/06/29 16:08:29 $ $State: Exp $
//
// ====================
//
//  = FILENAME
//	MDBImageManagerJapanese.hpp
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
//	$Revision: 1.4 $
//
//  = DATE RELEASED
//	$Date: 2006/06/29 16:08:29 $
//
//  = COMMENTS
//

#ifndef MDBImageManagerJapaneseISIN
#define MDBImageManagerJapaneseISIN

#include "MDBImageManager.hpp"

//#include <iostream>
//#include <string>

//#include "MDBInterface.hpp"
//#include "MPatient.hpp"
//#include "MStudy.hpp"
//#include "MSeries.hpp"
//#include "MSOPInstance.hpp"
//#include "MPatientStudy.hpp"
//#include "MWorkOrder.hpp"
//#include "MStorageCommitItem.hpp"

using namespace std;

#include "MDBInterface.hpp"
#include "MPlacerOrder.hpp"
#include "MVisit.hpp"
#include "MFillerOrder.hpp"
#include "MPlacerOrder.hpp"
#include "MOrder.hpp"
#include "MDBIMClient.hpp"
#include "MDICOMApp.hpp"

class MDBImageManagerJapanese : public MDBImageManager
// = TITLE
///	Database interface for an Image Manager.
//
// = DESCRIPTION
/**	This class provides an abstraction to a (relational) database
	for an Image Manager.  The methods define typical operations for
	an Image Manager (which correspond closely to transactions defined
	in the IHE Technical Framework). */

{
public:
  // = The standard methods in this framework.
  MDBImageManagerJapanese();
  ///< Default constructor

  MDBImageManagerJapanese(const MDBImageManagerJapanese& cpy);

  virtual ~MDBImageManagerJapanese();

  virtual void printOn(ostream& s) const;
  /**<\brief This method is used in conjunction with the streaming operator <<
   to print the current state of MDBImageManagerJapanese. */

  virtual void streamIn(istream& s);
  /**<\brief This method is used in conjunction with the streaming operator >>
   to read the current state of MDBImageManagerJapanese. */

  // = Class specific methods.  All methods return 0 on success and -1 on
  // failure unless otherwise noted.

  MDBImageManagerJapanese(const string& databaseName);
  ///< Construct an ImageManager DB interface for the database whose name is in <{databaseName}>.  
  /**< This constructor does not perform consistency
   checks on the database.  That is, it does not test to make
   sure that all tables are present in the database. */

  int initialize();
  ///< Initialize the Image Manager.  Open the database and prepare to run.

  int initialize(const MString& databaseName);
  ///< Initialize the Image Manager.  Open the database named in <{databaseName}> and prepare to run.

  int admitRegisterPatient(const MPatient& patient, const MVisit& visit);
  /**<\brief A patient has been admitted as an in-patient or registered as an
   outpatient.  */
  /** The <{visit}> argument defines the registration mode.
   Update our tables accordingly. */

  int preRegisterPatient(const MPatient& patient, const MVisit& visit);
  ///< A patient has been pre registered.
  /**< The <{visit}> argument defines the registration mode.
   Update our tables accordingly. */

  int updateADTInfo(const MPatient& patient);
  ///< Invoke this method to update the registration information of an existing patient.  
  /**< In the argument list, <{patient}> contains the attributes to be udpated.*/

  int updateADTInfo(const MPatient& patient, const MVisit& visit);
  ///< Invoke this method to update the registration and visit information of an existing patient.  
  /**< In the argument list,
   <{patient}> and <{visit}> contain the attributes to be udpated
   in the database. */

  int transferPatient(const MVisit& visit);
  ///< Patient has been transferred.  
  /**< Update our records with new location
   described in the <{visit}> argument. */

  int mergePatient(const MPatient& patient);

  int enterOrder(const MPatient& patient, const MPlacerOrder& order);
  ///> An order is placed for this patient.  
  ///>Enter the order information into the database.

  virtual int enterSOPInstance(const MPatient& patient, const MStudy& study,
		       const MSeries& series, const MSOPInstance& sopInstance);
  ///> A new SOP Instance is inserted into the database.  
  ///>Check for existing objects in the database and only insert values into tables that need them.

  int queryDICOMPatientRoot(const MPatient& patient, const MStudy& study,
			    const MSeries& series,
			    const MSOPInstance& sopInstance,
			    const MString& startLevel,
			    const MString& stopLevel,
			    MDBIMClient& client);
  ///< Query using the DICOM Patient Root model.  
  /**< Caller passes query criteria
   through the <{patient}>, <{study}>, <{series}> and <{sopInstance}> variables.
   The variable <{stopLevel}> corresponds directly to the DICOM Query Level
   attribute.  The caller can direct the query to start at any level in
   the model with the <{startLevel}> variable.  The <{dbCallback}> method on
   <{client}> is invoked for every record that matches. */

  int queryDICOMStudyRoot(const MPatientStudy& patientStudy,
			  const MSeries& series,
			  const MSOPInstance& sopInstance,
			  const MString& startLevel, const MString& stopLevel,
			  MDBIMClient& client);
  ///< Query using the DICOM Study Root model.  
  /**< Caller passes query criteria
   through the <{patientStudy}>, <{series}> and <{sopInstance}> variables.
   The variable <{stopLevel}> corresponds directly to the DICOM Query Level
   attribute.  The caller can direct the query to start at any level in
   the model with the <{startLevel}> variable.  The <{dbCallback}> method on
   <{client}> is invoked for every record that matches. */

  int selectSOPInstance(const MSOPInstance& sopInstance,
			MSOPInstanceVector& v);
  ///< Query for SOP Instances only.  
  /**< Caller passes query criteria through the
   <{sopInstance}> variable.  The method queries for all records matching the
   criteria designated in <{sopInstance}> and fills the vector <{v}> with the
   results. */

  int selectSOPInstance(const MSOPInstance& pattern,
			MSOPInstance& target);
  ///< Query for a single SOP instance using the criteria passed in <{pattern}>.
  /**< If the SOP Instance is found in the database, the method fills in the
   attributes in the <{target}> variable. */

  int selectSOPInstance(MSOPInstanceVector& v);
  ///< Query for all SOP Instances only.  
  ///< The method queries for all SOP Instances and fills the vector <{v}> with the results.

  int enterStorageCommitmentItem(const MStorageCommitItem& item);
  ///< Insert one Store Commitment Item in Storage Commitment table.

  int selectStorageCommitItem(const MStorageCommitItem& item,
			      MStorageCommitItemVector& v);
  ///< Query for Storage Commitment items from the Storage Commitment table.
  /**< The attributes in <{item}> are used as
   search criteria.  All records which match are placed in the caller's
   vector, <{v}>. */

  int selectStorageCommitItem(const MStorageCommitItem& pattern,
			      MStorageCommitItem& target);
  ///< Query for a single Storage Commitment item.  
  /**<  The attributes of the variable<{pattern}> are used as the criteria for the select.  If a single record
   matches the select criteria, it is written into the caller's <{target}> variable. */

  int storageCommitmentStatus(MStorageCommitItem& item);
  ///< This method is a placeholder.  It is not implemented.

  int selectDICOMApp(const MString& aeTitle, MDICOMApp& app);
  ///< Query by DICOM Application Entity title for one DICOM application.
  /**< In the argument list, <{aeTitle}> contains the DICOM AE title to
   search against.  If the application is found in the database, the
   attributes are placed in <{app}>. */

  int addToVector(const MPatient& patient);
  ///< This method is only public so that it may be invoked from a callback.
  /**< During the select process in the methods above, add one patient record
   to the internal vector of patient records. */

  int addToVector(const MStudy& study);
  ///< This method is only public so that it may be invoked from a callback.
  /**< During the select process in the methods above, add one study record
   to the internal vector of study records. */

  int addToVector(const MSeries& series);
  ///< This method is only public so that it may be invoked from a callback.
  /**< During the select process in the methods above, add one series record
   to the internal vector of series records. */

  int queryWorkOrder(MDBIMClient& client, int status = -1);

  int deleteWorkOrder(const MString& orderNumber);

  int updateWorkOrderStatus(const MWorkOrder& workOrder, const MString& status);

  int setWorkOrderComplete(const MWorkOrder& workOrder, const MString& status);

protected:
  MDBInterface* mDBInterface;

  /// use to set update values for a given table
  void setCriteria(const MDomainObject& domainObject, MUpdateVector& uv);

  int fillSeriesVector(const MPatientStudy& study, const MSeries& series,
		       MSeriesVector& v);

  void incrementSOPInstanceCount(const MSeries& series);

  int fillPatientStudyVector(const MPatientStudy& patientStudy,
			     MPatientStudyVector& v);

  int queryNewWorkOrders(MDBIMClient& client);
  int queryAllWorkOrders(MDBIMClient& client);

private:
  MString mDBName;
  MPatientVector mPatientVector;
  MStudyVector mStudyVector;
  MSeriesVector mSeriesVector;

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
  int addOrder(const MFillerOrder& order);
  int addOrder(const MPlacerOrder& order);

  // following functions update records in the table
  int updateRecord(const MPatient& patient);
  int updateRecord(const MStudy& study);
  int updateRecord(const MVisit& visit);
  int updateRecord(const MFillerOrder& order);
  int updateRecord(const MPlacerOrder& order);
  int updateRecord(const MOrder& order);

  // use the following functions to set search criteria on different tables
  void setCriteria(const MPatient& patient, MCriteriaVector& cv);
  void setCriteria(const MStudy& study, MCriteriaVector& cv);
  void setCriteria(const MVisit& Visit, MCriteriaVector& cv);
  void setCriteria(const MFillerOrder& order, MCriteriaVector& cv);
  void setCriteria(const MPlacerOrder& order, MCriteriaVector& cv);
  void setCriteria(const MOrder& order, MCriteriaVector& cv);

  int enter(const MPatient& patient);

  int enter(const MStudy& study);

  int enter(const MSeries& series,
	    const MStudy& study);

  int enter(const MSOPInstance& sopInstance,
	    const MStudy& study,
	    const MSeries& series);

  void incrementSeriesCount(const MStudy& study);
  void incrementSOPInstanceCount(const MStudy& study);
  void updateModalitiesInStudy(const MStudy& study, const MString& modality);

  int fillPatientVector(const MPatient& patient, MPatientVector& v);

  int fillStudyVector(const MPatient& patient, const MStudy& study,
		      MStudyVector& v);

  int fillStudyVector(const MStudy& study, MStudyVector& v);

  int fillSeriesVector(const MStudy& study, const MSeries& series,
		       MSeriesVector& v);

  int fillSOPInstanceVector(const MSeries&, const MSOPInstance& sopInstance,
			    MSOPInstanceVector& v);

  int fillSOPInstanceVector(const MSOPInstance& sopInstance,
			    MSOPInstanceVector& v);

  int fillSOPInstanceVector(MSOPInstanceVector& v);

  void clearVectors(void);

  int fillStorageCommitVector(const MStorageCommitItem& item,
			      MStorageCommitItemVector& v);

  int fillWorkOrderVector(const MWorkOrder& workOrder, MWorkOrderVector& v);

  void fixModalitiesInStudy(MPatientStudyVector& v);
  void fixModalitiesInStudy(MStudyVector& v);

  int mapFromEUCToISO(MPatientStudy& patientStudy);
  int mapISOToEUCJP(MStudy& study);
  int mapISOToEUCJP(MPatient& patient);


  //callback(const MDomainObject& domainObject);

};

inline ostream& operator<< (ostream& s, const MDBImageManagerJapanese& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MDBImageManagerJapanese& c) {
  c.streamIn(s);
  return s;
}

#endif
