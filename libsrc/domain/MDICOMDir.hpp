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

// $Id: MDICOMDir.hpp,v 1.2 2006/06/29 16:08:30 bhasselfeld Exp $ $Author: bhasselfeld $ $Revision: 1.2 $ $Date: 2006/06/29 16:08:30 $ $State: Exp $
// ======================
// = FILENAME
//	MDICOMDir.hpp
//
// = AUTHOR
//	Steve Moore
//
//  = COPYRIGHT
//	Copyright HIMSS, RSNA, Washington University: 1999, 2000
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
#ifndef MDICOMDirSIN
#define MDICOMDirISIN

#include <iostream>
#include "MDomainObject.hpp"
#include "MPatient.hpp"


using namespace std;

// = TITLE
///	A domain object which represents a DICOMDIR object.
//
// = DESCRIPTION

class MDICOMDir : public MDomainObject
{
public:
  // The standard methods in this framework.

  MDICOMDir();
  ///< Default constructor.

  virtual ~MDICOMDir();

  virtual void printOn(ostream& s) const;

  virtual void streamIn(istream& s);

  // Class specific methods.

  //void import(const MDomainObject& o);
  // This method imports the key-value pairs which are in the domain object
  // <{o}>.  These values are used to overwrite any existing values in
  // the MPatient object.

  void addPatient(const MPatient& patient);

  int patientCount() const;

  MPatient getPatient(int index) const;

private:
  MPatientVector mPatientVector;
  
  void fillMap();

};

inline ostream& operator<< (ostream& s, const MDICOMDir& dir) {
	  dir.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MDICOMDir& dir) {
  dir.streamIn(s);
  return s;
}

#endif
