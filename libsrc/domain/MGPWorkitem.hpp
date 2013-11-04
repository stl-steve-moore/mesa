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

// $Id: MGPWorkitem.hpp,v 1.2 2002/07/17 19:51:36 drm Exp $ $Author: drm $ $Revision: 1.2 $ $Date: 2002/07/17 19:51:36 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MGPWorkitem.hpp
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
//	$Date: 2002/07/17 19:51:36 $
//
//  = COMMENTS
//

#ifndef MGPWorkitemISIN
#define MGPWorkitemISIN

#include <iostream>
#include "MDomainObject.hpp"

using namespace std;

class MGPWorkitem : public MDomainObject
// = TITLE
//	A domain object which corresponds to one entry in a DICOM
//	General Purpose Workitem.
//
// = DESCRIPTION
//	This class is a container for attributes which define a DICOM
//	General Purpose Workitem, either a GP scheduled procedure stpe
//	or a GP performed procedure step. It inherits from <{MDomainObject}> 
//	and supports the ability to get and set values with specific methods.
//	Because this class is just a container, it performs no validation tests.

{
public:
  // = The standard methods in this framework.

  MGPWorkitem();
  // Default constructor

  MGPWorkitem(const MGPWorkitem& cpy);

  virtual ~MGPWorkitem();

  virtual void printOn(ostream& s) const;
  // This method is used in conjunction with the streaming operator <<
  // to print the current state of MGPWorkitem.

  virtual void streamIn(istream& s);
  // This method is used in conjunction with the streaming operator >>
  // to read the current state of MGPWorkitem.

  MGPWorkitem(const MString& SOPInstanceUID,
       const MString& SOPClassUID,
       const MString& status,
       const MString& inputAvailabilityFlag,
       const MString& priority,
       const MString& procedureStepID,
       const MString& startDateTime,
       const MString& endDateTime,
       const MString& resultStudyInstanceUID,
       const MString& multipleCopiesFlag,
       const MString& description,
       const MString& patientID,
       const MString& patientName,
       const MString& patientBirthDate,
       const MString& patientSex,
       const MString& workItemCodeValue,
       const MString& workItemCodeScheme,
       const MString& workItemCodeMeaning,
       const MString& requestedProcAccessionNum,
       const MString& requestedProcID,
       const MString& requestedProcDesc,
       const MString& requestedProcCodevalue,
       const MString& requestedProcCodemeaning,
       const MString& requestedProcCodescheme,
       const MString& requestingPhysician, 
       const MString& transactionUID);
  // This constructor takes a number of attributes which are defined for
  // a GP Workitem and copies them into the internal state of
  // this object.

  
  // = Class specific methods.

  //  Return copies of attributes.
  MString SOPInstanceUID() const;
  MString SOPClassUID() const;
  MString status() const;
  MString inputAvailabilityFlag() const;
  MString priority() const;
  MString procedureStepID() const;
  MString startDateTime() const;
  MString endDateTime() const;
  MString resultStudyInstanceUID() const;
  MString inputStudyInstanceUID() const;
  MString multipleCopiesFlag() const;
  MString description() const;
  MString patientID() const;
  MString patientName() const;
  MString patientBirthDate() const;
  MString patientSex() const;
  MString workItemCodeValue() const;
  MString workItemCodeScheme() const;
  MString workItemCodeMeaning() const;
  MString requestedProcAccessionNum() const;
  MString requestedProcID() const;
  MString requestedProcDesc() const;
  MString requestedProcCodevalue() const;
  MString requestedProcCodemeaning() const;
  MString requestedProcCodescheme() const;
  MString requestingPhysician() const;
  MString transactionUID() const;


  //  Set attributes.
  void SOPInstanceUID(const MString& s);
  void SOPClassUID(const MString& s);
  void status(const MString& s);
  void inputAvailabilityFlag(const MString& s);
  void priority(const MString& s);
  void procedureStepID(const MString& s);
  void startDateTime(const MString& s);
  void endDateTime(const MString& s);
  void resultStudyInstanceUID(const MString& s);
  void inputStudyInstanceUID(const MString& s);
  void multipleCopiesFlag(const MString& s);
  void description(const MString& s);
  void patientID(const MString& s);
  void patientName(const MString& s);
  void patientBirthDate(const MString& s);
  void patientSex(const MString& s);
  void workItemCodeValue(const MString& s);
  void workItemCodeScheme(const MString& s);
  void workItemCodeMeaning(const MString& s);
  void requestedProcAccessionNum(const MString& s);
  void requestedProcID(const MString& s);
  void requestedProcDesc(const MString& s);
  void requestedProcCodevalue(const MString& s);
  void requestedProcCodemeaning(const MString& s);
  void requestedProcCodescheme(const MString& s);
  void requestingPhysician(const MString& s);
  void transactionUID(const MString& s);


  void import(const MDomainObject& o);
  // Import the key-value pairs from the MDomainObject <{o}> and set the
  // appropriate values in this object.

private:
  MString mSOPInstanceUID;
  MString mSOPClassUID;
  MString mStatus;
  MString mInputAvailabilityFlag;
  MString mPriority;
  MString mProcedureStepID;
  MString mStartDateTime;
  MString mEndDateTime;
  MString mResultStudyInstanceUID;
  MString mInputStudyInstanceUID;
  MString mMultipleCopiesFlag;
  MString mDescription;
  MString mPatientID;
  MString mPatientName;
  MString mPatientBirthDate;
  MString mPatientSex;
  MString mWorkItemCodeValue;
  MString mWorkItemCodeScheme;
  MString mWorkItemCodeMeaning;
  MString mRequestedProcAccessionNum;
  MString mRequestedProcID;
  MString mRequestedProcDesc;
  MString mRequestedProcCodevalue;
  MString mRequestedProcCodemeaning;
  MString mRequestedProcCodescheme;
  MString mRequestingPhysician;
  MString mTransactionUID;
};

typedef vector< MGPWorkitem > MGPWorkitemVector;

inline ostream& operator<< (ostream& s, const MGPWorkitem& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MGPWorkitem& c) {
  c.streamIn(s);
  return s;
}

#endif
