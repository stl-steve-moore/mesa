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

// $Id: MQRObjects.hpp,v 1.6 2006/06/29 16:08:31 bhasselfeld Exp $ $Author: bhasselfeld $ $Revision: 1.6 $ $Date: 2006/06/29 16:08:31 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MQRObjects.hpp
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
//	$Revision: 1.6 $
//
//  = DATE RELEASED
//	$Date: 2006/06/29 16:08:31 $
//
//  = COMMENTS
//

#ifndef MQRObjectsISIN
#define MQRObjectsISIN

#include <iostream>
#include <string>

#include "MPatient.hpp"
#include "MStudy.hpp"
#include "MSeries.hpp"
#include "MSOPInstance.hpp"
#include "MPatientStudy.hpp"

class MQRObjects;
typedef vector < MQRObjects > MQRObjectsVector;

using namespace std;

class MQRObjects
// = TITLE
///	A container for domain objects for use in DICOM query/retrieve operations.
//
// = DESCRIPTION
/**	This class serves as a container for other domain objects which
	are used in DICOM hierarchical queries.  It manages the other
	objects, but does not know what attributes are stored in those
	other objects. */

{
public:
  // = The standard methods in this framework.

  MQRObjects(const MQRObjects& cpy);

  virtual ~MQRObjects();

  virtual void printOn(ostream& s) const;
  /**<\brief This method is used in conjunction with the streaming operator <<
       	     to print the current state of MQRObjects. */

  virtual void streamIn(istream& s);
  /**<\brief This method is used in conjunction with the streaming operator >>
  	     to read the current state of MQRObjects. */
  
  // = Class specific methods.
  MQRObjects(const MPatient& patient, const MStudy& study,
	     const MSeries& series, const MSOPInstance& sopInstance);
  /**<\brief This constructor takes four domain objects which constitute
  	     this class.  Copy each domain object into the internal state of
   	     this object. */

  MQRObjects(const MPatientStudy& patientStudy,
	     const MSeries& series, const MSOPInstance& sopInstance);
  ///< This constructor takes three domain objects to be managed.  
  /**< This would be used in the context of Study Root queries (where the patient
       and study levels are joined. */

  MPatient patient();
  ///< Return a copy of the MPatient object managed by this class.

  MStudy study();
  ///< Return a copy of the MStudy object managed by this class.

  MSeries series();
  ///< Return a copy of the MSeries object managed by this class.

  MSOPInstance sopInstance();
  ///< Return a copy of the MSOPInstance object managed by this class.

  MPatientStudy patientStudy();
  ///< Return a copy of the MPatientStudy object managed by this class.

private:
  MPatient mPatient;
  MStudy mStudy;
  MSeries mSeries;
  MSOPInstance mSOPInstance;
  MPatientStudy mPatientStudy;
};

inline ostream& operator<< (ostream& s, const MQRObjects& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MQRObjects& c) {
  c.streamIn(s);
  return s;
}

#endif
