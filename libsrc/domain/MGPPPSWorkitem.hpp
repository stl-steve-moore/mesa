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

// $Id: MGPPPSWorkitem.hpp,v 1.2 2006/06/29 16:08:30 bhasselfeld Exp $ $Author: bhasselfeld $ $Revision: 1.2 $ $Date: 2006/06/29 16:08:30 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MGPPPSWorkitem.hpp
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
//	$Revision: 1.2 $
//
//  = DATE RELEASED
//	$Date: 2006/06/29 16:08:30 $
//
//  = COMMENTS
//

#ifndef MGPPPSWorkitemISIN
#define MGPPPSWorkitemISIN

#include <iostream>
#include "MDomainObject.hpp"
#include "MDBInterface.hpp"

using namespace std;

class MGPPPSWorkitem : public MDomainObject
// = TITLE
///	A domain object which corresponds to one entry in a DICOM General Purpose Performed Procedure Step Workitem.
//
// = DESCRIPTION
/**	This class is a container for attributes which define a DICOM
	General Purpose performed procedure step Workitem.
	It inherits from <{MDomainObject}> 
	and supports the ability to get and set values with specific methods.
	Because this class is just a container, it performs no validation tests. */

{
public:
  // = The standard methods in this framework.

  MGPPPSWorkitem();
  ///< Default constructor

  MGPPPSWorkitem(const MGPPPSWorkitem& cpy);

  virtual ~MGPPPSWorkitem();

  virtual void printOn(ostream& s) const;
  /**<\brief This method is used in conjunction with the streaming operator <<
  	     to print the current state of MGPPPSWorkitem. */

  virtual void streamIn(istream& s);
  /**<\brief This method is used in conjunction with the streaming operator >>
 	     to read the current state of MGPPPSWorkitem. */

  MGPPPSWorkitem(
       const MString& sopinsuid,
       const MString& status,
       const MString& procedureStepID,
       const MString& startDate,
       const MString& startTime,
       const MString& endDate,
       const MString& endTime,
       const MString& description,
       const MString& patientID,
       const MString& patientName,
       const MString& patientBirthDate,
       const MString& patientSex,
       const MString& requestedProcAccessionNum,
       const MString& requestedProcID,
       const MString& requestedProcDesc,
       const MString& requestedProcCodevalue,
       const MString& requestedProcCodemeaning,
       const MString& requestedProcCodescheme);
  /**<\brief This constructor takes a number of attributes which are defined for
  	     a GP Workitem and copies them into the internal state of
  	     this object. */

  
  // = Class specific methods.

  //  Return copies of attributes.
  MString SOPInstanceUID() const;
  MString status() const;
  MString procedureStepID() const;
  MString startDate() const;
  MString startTime() const;
  MString endDate() const;
  MString endTime() const;
  MString description() const;
  MString patientID() const;
  MString patientName() const;
  MString patientBirthDate() const;
  MString patientSex() const;
  MString requestedProcAccessionNum() const;
  MString requestedProcID() const;
  MString requestedProcDesc() const;
  MString requestedProcCodevalue() const;
  MString requestedProcCodemeaning() const;
  MString requestedProcCodescheme() const;


  //  Set attributes.
  void SOPInstanceUID(const MString& s);
  void status(const MString& s);
  void procedureStepID(const MString& s);
  void startDate(const MString& s);
  void startTime(const MString& s);
  void endDate(const MString& s);
  void endTime(const MString& s);
  void description(const MString& s);
  void patientID(const MString& s);
  void patientName(const MString& s);
  void patientBirthDate(const MString& s);
  void patientSex(const MString& s);
  void requestedProcAccessionNum(const MString& s);
  void requestedProcID(const MString& s);
  void requestedProcDesc(const MString& s);
  void requestedProcCodevalue(const MString& s);
  void requestedProcCodemeaning(const MString& s);
  void requestedProcCodescheme(const MString& s);


  void import(const MDomainObject& o);
  ///< Import the key-value pairs from the MDomainObject <{o}> and set the appropriate values in this object.

  void update( MDBInterface *db);
  ///< Update the database with these values.

private:
  MString mSOPInstanceUID;
  MString mStatus;
  MString mProcedureStepID;
  MString mStartDate;
  MString mStartTime;
  MString mEndDate;
  MString mEndTime;
  MString mDescription;
  MString mPatientID;
  MString mPatientName;
  MString mPatientBirthDate;
  MString mPatientSex;
  MString mRequestedProcAccessionNum;
  MString mRequestedProcID;
  MString mRequestedProcDesc;
  MString mRequestedProcCodevalue;
  MString mRequestedProcCodemeaning;
  MString mRequestedProcCodescheme;
};

typedef vector< MGPPPSWorkitem > MGPPPSWorkitemVector;

inline ostream& operator<< (ostream& s, const MGPPPSWorkitem& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MGPPPSWorkitem& c) {
  c.streamIn(s);
  return s;
}

#endif
