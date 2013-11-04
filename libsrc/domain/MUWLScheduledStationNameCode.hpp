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

// $Id: MUWLScheduledStationNameCode.hpp,v 1.1 2008/03/19 20:45:30 smm Exp $ $Author: smm $ $Revision: 1.1 $ $Date: 2008/03/19 20:45:30 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MUWLScheduledStationNameCode.hpp
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
//	$Revision: 1.1 $
//
//  = DATE RELEASED
//	$Date: 2008/03/19 20:45:30 $
//
//  = COMMENTTEXT
//	Comments

#ifndef MUWLScheduledStationNameCodeISIN
#define MUWLScheduledStationNameCodeISIN

#include <iostream>
#include <string>
#include <vector>

#include "MDomainObject.hpp"

using namespace std;

class MUWLScheduledStationNameCode;
typedef vector < MUWLScheduledStationNameCode > MUWLScheduledStationNameCodeVector;

class MUWLScheduledStationNameCode : public MDomainObject
// = MUWLScheduledStationNameCode
///	A domain object which corresponds to a DICOM action item.
//
// = DESCRIPTION
/**	This class is a container for attributes which define a DICOM
	action item.  It inherits from <{MDomainObject}> and supports the
	ability to get and set values with specific methods.  Because this
	class is just a container, it performs no validation tests. */
{
public:
  // = The standard methods in this framework.

  MUWLScheduledStationNameCode();
  ///< Default constructor

  MUWLScheduledStationNameCode(const MUWLScheduledStationNameCode& cpy);

  virtual ~MUWLScheduledStationNameCode();

  virtual void printOn(ostream& s) const;
  /**<\brief This method is used in conjunction with the streaming operator <<
   to print the current state of MUWLScheduledStationNameCode. */

  virtual void streamIn(istream& s);
  /**<\brief This method is used in conjunction with the streaming operator >>
     to read the current state of MUWLScheduledStationNameCode. */
  
  // = Class specific methods.

  MUWLScheduledStationNameCode(const MString& codeValue,
       const MString& codeSchemeDesignator,
       const MString& codeMeaning,
       const MString& uwlIndex
       );
  ///< Constructor which takes all of the attributes in an action item.
  /**< Variable names in the constructor should be self explanatory.
   All values are copied directly into the internal state of the action
   item object. */

  void import(const MDomainObject& o);
  ///< This method imports the key/value pairs from an existing domain object <{o}> into this MUWLScheduledStationNameCode.

  //MString scheduledProcedureStepID() const;
  // Return a copy of the Scheduled Procedure Step ID.

  MString uwlIndex() const;
  ///< Return a copy of the UWL Index.

  MString codeValue() const;
  ///< Return a copy of the Code Value.

  MString codeMeaning() const;
  ///< Return a copy of the Code Meaning.

  MString codeSchemeDesignator() const;
  ///< Return a copy of the Code Scheme Designator.

  void uwlIndex(const MString& s);
  ///< Set the UWL Index according to the value in <{s}>.

  void codeValue(const MString& s);
  ///< Set the Code Value according to the value in <{s}>.

  void codeMeaning(const MString& s);
  ///< Set the Code Meaning according to the value in <{s}>.

  void codeSchemeDesignator(const MString& s);
  ///< Set the Code Scheme Designator according to the value in <{s}>.

private:
//  MString mUWLIndex;
//  MString mCodeValue;
//  MString mCodeMeaning;
//  MString mCodeSchemeDesignator;
};

inline ostream& operator<< (ostream& s, const MUWLScheduledStationNameCode& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MUWLScheduledStationNameCode& c) {
  c.streamIn(s);
  return s;
}

#endif
