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

// $Id: MSchedule.hpp,v 1.9 2006/06/29 16:08:31 bhasselfeld Exp $ $Author: bhasselfeld $ $Revision: 1.9 $ $Date: 2006/06/29 16:08:31 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MSchedule.hpp
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
//	$Revision: 1.9 $
//
//  = DATE RELEASED
//	$Date: 2006/06/29 16:08:31 $
//
//  = COMMENTS
//

#ifndef MScheduleISIN
#define MScheduleISIN

#include <iostream>
#include <string>
#include "MDomainObject.hpp"

using namespace std;

class MSchedule : public MDomainObject
// = TITLE
///	A domain object with scheduling information.
//
// = DESCRIPTION
/**	This class is an MDomainObject which holds the scheduling relationship
	between procedures described by an HL7 Universal Service ID
	and DICOM Scheduled Procedure Step IDs and Scheduled Procedure
	Step Descriptions. */

{
public:
  // = The standard methods in this framework.

  MSchedule();
  ///< Default constructor

  MSchedule(const MSchedule& cpy);

  virtual ~MSchedule();

  virtual void printOn(ostream& s) const;
  /**<\brief This method is used in conjunction with the streaming operator <<
  	     to print the current state of MSchedule. */

  virtual void streamIn(istream& s);
  /**<\brief This method is used in conjunction with the streaming operator >>
  	     to read the current state of MSchedule. */

  // = Class specific methods.

  MSchedule(const MString& universalServiceID,
	    const MString& spdIndex,
	    const MString& sPSDescscription);
  ///< This constructor takes the three values and copies them into the internal state of the object.

  void import(MDomainObject& o);
  /**<\brief method imports the key-value pairs from an MDomainObject <{o}>
   	     and copies those values into the internal state of this object. */

  MString universalServiceID() const;
  ///< Return a copy of the Universal Service ID.

  MString spsIndex() const;
  ///< Return a copy of the Scheduled Procedure Step Index.

  MString sPSDescription() const;
  ///< Return a copy of the Scheduled Procedure Step Description.

  void universalServiceID(const MString& s);
  ///< Set the Universal Service ID to the value passed in <{s}>.

  void spsIndex(const MString& s);
  ///< Set the Scheduled Procedure Step Index to the value passed in <{s}>.

  void sPSDescription(const MString& s);
  ///< Set the Scheduled Procedure Step Description to the value passed in <{s}>.

private:
  MString mUniversalServiceID;
  MString mSPSIndex;
  MString mSPSDescription;
};

inline ostream& operator<< (ostream& s, const MSchedule& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MSchedule& c) {
  c.streamIn(s);
  return s;
}

#endif
