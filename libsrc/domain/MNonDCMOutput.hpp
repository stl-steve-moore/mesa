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

// $Id: MNonDCMOutput.hpp,v 1.2 2006/06/29 16:08:31 bhasselfeld Exp $ $Author: bhasselfeld $ $Revision: 1.2 $ $Date: 2006/06/29 16:08:31 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MNonDCMOutput.hpp
//
//  = AUTHOR
//	David Maffitt
//
//  = COPYRIGHT
//	Copyright HIMSS, RSNA, Washington University: 2002
//
// ====================
//
//  = VERSION
//	$Revision: 1.2 $
//
//  = DATE RELEASED
//	$Date: 2006/06/29 16:08:31 $
//
//  = COMMENTS
//

#ifndef MNonDCMOutputISIN
#define MNonDCMOutputISIN

#include <iostream>
#include <string>
#include <vector>
#include "MDomainObject.hpp"
#include "MDBInterface.hpp"

using namespace std;

class MNonDCMOutput;
typedef vector < MNonDCMOutput > MNonDCMOutputVector;

class MNonDCMOutput : public MDomainObject
// = TITLE
///	a domain object which corresponds to Non-DICOM Output code sequence items.
//
// = DESCRIPTION
//	Describe the class and how to use it
{
public:
  // = The standard methods in this framework.
  MNonDCMOutput();
  ///< Default constructor
  MNonDCMOutput(const MNonDCMOutput& cpy);
  virtual ~MNonDCMOutput();
  virtual void printOn(ostream& s) const;
  /**<\brief This method is used in conjunction with the streaming operator <<
  	     to print the current state of MNonDCMOutput */

  MNonDCMOutput(
       const MString& codeValue,
       const MString& codeMeaning,
       const MString& codeSchemeDesignator,
       const MString& workitemkey
       );

  /**\brief constructor from string with '^' separated values for 
  	    value, schemedesignator, and meaning. */
  MNonDCMOutput( MString& s, const MString& key);

  virtual void streamIn(istream& s);
  
  // = Class specific methods.

  MString codeValue() const;
  MString codeMeaning() const;
  MString codeSchemeDesignator() const;
  MString workitemkey() const;

  void codeValue(const MString& s);
  void codeMeaning(const MString& s);
  void codeSchemeDesignator(const MString& s);
  void workitemkey(const MString& s);

  void import(const MDomainObject& o);

  // Alter the database with these values.
  void update( MDBInterface &db);
  void dbinsert( MDBInterface *db);
  void dbremove( MDBInterface *db);

private:
  MString mCodeValue;
  MString mCodeMeaning;
  MString mCodeSchemeDesignator;
  MString mWorkitemkey;
};

inline ostream& operator<< (ostream& s, const MNonDCMOutput& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MNonDCMOutput& c) {
  c.streamIn(s);
  return s;
}

#endif
