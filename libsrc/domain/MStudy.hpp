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

// $Id: MStudy.hpp,v 1.9 2006/06/29 16:08:32 bhasselfeld Exp $ $Author: bhasselfeld $ $Revision: 1.9 $ $Date: 2006/06/29 16:08:32 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MStudy.hpp
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
//	$Revision: 1.9 $
//
//  = DATE RELEASED
//	$Date: 2006/06/29 16:08:32 $
//
//  = COMMENTS
//

#ifndef MStudyISIN
#define MStudyISIN

#include <iostream>
#include "MDomainObject.hpp"

class MStudy;
typedef vector < MStudy > MStudyVector;

using namespace std;

class MStudy : public MDomainObject
// = TITLE
///	A domain object that corresponds to a DICOM study object.
//
// = DESCRIPTION
/**	This class is a container for attributes which define a DICOM
	study.  It inherits from <{MDomainObject}> and supports the
	ability to get and set values with specific methods.  Because this
	class is just a container, it performs no validation tests.	*/
{
public:
  // = The standard methods in this framework.

  MStudy();
  ///< Default constructor

  MStudy(const MStudy& cpy);

  ~MStudy();

  virtual void printOn(ostream& s) const;
  /**<\brief This method is used in conjunction with the streaming operator <<
  	     to print the current state of MStudy. */

  virtual void streamIn(istream& s);
  /**<\brief This method is used in conjunction with the streaming operator >>
  	     to read the current state of MStudy. */

  // = Class specific methods.

  MStudy(const MString& patientID,
	 const MString& studyInstanceUID,
	 const MString& conceptualStudyUID,
	 const MString& studyID,
	 const MString& studyDate,
	 const MString& studyTime,
	 const MString& accessionNumber,
	 const MString& referringPhysicianName,
	 const MString& studyDescription,
	 const MString& patientAge,
	 const MString& patientSize);
  /**<\brief This constructor takes a variable for each attribute managed by this
  	     class.  The value of each variable is copied into the internal state
  	     managed by this object. */

  void import(const MDomainObject& o);
  ///< This method imports the key-value pairs from the MDomainObject <{o}>.
  /**< The values are copied from <{o}> and stored in the internal state
       maintained by this object.  */

  // A number of get methods that return values.  Use the method name
  // as a guide to the attribute.
  MString patientID() const;
  MString studyInstanceUID() const;
  MString conceptualStudyUID() const;
  MString studyID() const;
  MString studyDate() const;
  MString studyTime() const;
  MString accessionNumber() const;
  MString referringPhysicianName() const;
  MString studyDescription() const;
  MString patientAge() const;
  MString patientSize() const;
  MString patientSex() const;

  MString modalitiesInStudy() const;
  MString numberStudyRelatedSeries() const;
  MString numberStudyRelatedInstances() const;

  // A number of set methods that set one attribute value.  Use the method
  // name as a guide to the attribute.
  void patientID(const MString& s);
  void studyInstanceUID(const MString& s);
  void conceptualStudyUID(const MString& s);
  void studyID(const MString& s);
  void studyDate(const MString& s);
  void studyTime(const MString& s);
  void accessionNumber(const MString& s);
  void referringPhysicianName(const MString& s);
  void studyDescription(const MString& s);
  void patientAge(const MString& s);
  void modalitiesInStudy(const MString& s);
  void patientSize(const MString& s);
  void patientSex(const MString& s);

  void numberStudyRelatedSeries(const MString& s);
  void numberStudyRelatedInstances(const MString& s);

private:
  MString mPatientID;
  MString mStudyInstanceUID;
  MString mConceptualStudyUID;
  MString mStudyID;
  MString mStudyDate;
  MString mStudyTime;
  MString mAccessionNumber;
  MString mReferringPhysicianName;
  MString mStudyDescription;
  MString mPatientAge;
  MString mPatientSize;
  MString mModalitiesInStudy;
  MString mNumberStudyRelatedSeries;
  MString mNumberStudyRelatedInstances;
};

inline ostream& operator<< (ostream& s, const MStudy& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MStudy& c) {
  c.streamIn(s);
  return s;
}

#endif
