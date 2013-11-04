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

// $Id: MDICOMAttribute.hpp,v 1.2 2006/06/29 16:08:29 bhasselfeld Exp $ $Author: bhasselfeld $ $Revision: 1.2 $ $Date: 2006/06/29 16:08:29 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MDICOMAttribute.hpp
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
//	$Revision: 1.2 $
//
//  = DATE RELEASED
//	$Date: 2006/06/29 16:08:29 $
//
//  = COMMENTS
//	Should eventually be replaced by a full C++ implementation.

#ifndef MDICOMAttributeISIN
#define MDICOMAttributeISIN

#include <iostream>
#include <string>
#include "ctn_api.h"

using namespace std;

class MDICOMAttribute;
typedef vector < MDICOMAttribute > MDICOMAttributeVector;

class MDICOMAttribute
// = TITLE
//	MDICOMAttribute - 
//
// = DESCRIPTION

{
public:
  // = The standard methods in this framework.

  /// Default constructor.
  MDICOMAttribute();

  MDICOMAttribute(const MDICOMAttribute& cpy);
  ///< Copy constructor

  virtual ~MDICOMAttribute();
  ///< Destructor.

  virtual void printOn(ostream& s) const;
  /**<\brief This method is used in conjunction with the streaming operator <<
  to print the current state of MDICOMAttribute. */

  virtual void streamIn(istream& s);
  /**<\brief This method is used in conjunction with the streaming operator >>
   to read the current state of MDICOMAttribute. */

  // = Class specific methods.

  MDICOMAttribute (DCM_TAG tag, const MString& description, const MString& value);

  DCM_TAG getTag() const;

  MString getDescription() const;

  MString getValueString() const;


protected:
  DCM_TAG mTag;
  MString mDescription;
  MString mValue;

private:
};

inline ostream& operator<< (ostream& s, const MDICOMAttribute& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MDICOMAttribute& c) {
  c.streamIn(s);
  return s;
}

#endif
