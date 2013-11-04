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

// $Id: MPatient.hpp,v 1.18 2007/03/19 14:37:17 smm Exp $ $Author: smm $ $Revision: 1.18 $ $Date: 2007/03/19 14:37:17 $ $State: Exp $
// ======================
// = FILENAME
//	MPatient.hpp
//
// = AUTHOR
//	Steve Moore
//
//  = COPYRIGHT
//	Copyright HIMSS, RSNA, Washington University: 1999, 2000
// ====================
//
//  = VERSION
//	$Revision: 1.18 $
//
//  = DATE RELEASED
//	$Date: 2007/03/19 14:37:17 $
//
//  = COMMENTS
//
#ifndef MPatientISIN
#define MPatientISIN

#include <iostream>
#include "MDomainObject.hpp"

class MPatient;
typedef vector < MPatient > MPatientVector;

using namespace std;

// = TITLE
///	A domain object which represents a patient.
//
// = DESCRIPTION
/**	This class is a container for attributes which define a patient.
	It inherits from <{MDomainObject}> and supports the
	ability to get and set values with specific methods.  Because this
	class is just a container, it performs no validation tests. */

class MPatient : public MDomainObject
{
public:
  // The standard methods in this framework.

  MPatient();
  ///< Default constructor.

  MPatient(const MPatient& patient);

  ~MPatient();

  virtual void printOn(ostream& s) const;

  virtual void streamIn(istream& s);

  // Class specific methods.

  MPatient(const MString& patientID, const MString& issuerOfPatientID,
	  const MString& identifierType,
          const MString& patientID2, const MString& issuerOfPatientID2,
	  const MString& patientName, const MString& dateOfBirth,
	  const MString& patientSex, const MString& address,
	  const MString& xRefKey,    const MString& patientAccountNumber,
	  const MString& patientRace);
  ///< This constructor takes all of the attributes which are managed by this class.

  void import(const MDomainObject& o);
  ///< This method imports the key-value pairs which are in the domain object <{o}>.  
  /**< These values are used to overwrite any existing values in the MPatient object. */

  // Get methods whose names match attribute names.
  MString patientID() const;
  MString issuerOfPatientID() const;
  MString identifierType() const;
  MString patientID2() const;
  MString issuerOfPatientID2() const;
  MString patientName() const;
  MString dateOfBirth() const;
  MString patientSex() const;
  MString priorIDList() const;
  MString priorID(const MString& issuer) const;
  MString address() const;
  MString xRefKey() const;
  MString patientAccountNumber() const;
  MString patientRace() const;

  // Set methods whose names match attribute names.
  void patientID(const MString& s);
  void issuerOfPatientID(const MString& s);
  void identifierType(const MString& s);
  void patientID2(const MString& s);
  void issuerOfPatientID2(const MString& s);
  void patientName(const MString& s);
  void dateOfBirth(const MString& s);
  void patientSex(const MString& s);
  void priorIDList(const MString& s);
  void address(const MString& address);
  void xRefKey(const MString& xRefKey);
  void patientAccountNumber(const MString& patientAccountNumber);
  void patientRace(const MString& patientRace);

private:
  
  MString mPatientID;
  MString mIssuerOfPatientID;
  MString mIdentifierType;
  MString mPatientID2;
  MString mIssuerOfPatientID2;
  MString mPatientName;
  MString mDateOfBirth;
  MString mPatientSex;
  MString mPriorIDList;
  MString mAddress;
  MString mXRefKey;
  MString mPatientAccountNumber;
  MString mPatientRace;

  void fillMap();

};

inline ostream& operator<< (ostream& s, const MPatient& patient) {
	  patient.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MPatient& patient) {
  patient.streamIn(s);
  return s;
}

#endif
