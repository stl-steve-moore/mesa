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

// $Id: MActionItem.hpp,v 1.9 2006/06/29 16:08:29 bhasselfeld Exp $ $Author: bhasselfeld $ $Revision: 1.9 $ $Date: 2006/06/29 16:08:29 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MActionItem.hpp
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
//	$Date: 2006/06/29 16:08:29 $
//
//  = COMMENTTEXT
//	Comments

#ifndef MActionItemISIN
#define MActionItemISIN

#include <iostream>
#include <string>
#include <vector>

#include "MDomainObject.hpp"

using namespace std;

class MActionItem;
typedef vector < MActionItem > MActionItemVector;

class MActionItem : public MDomainObject
// = MActionItem
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

  MActionItem();
  ///< Default constructor

  MActionItem(const MActionItem& cpy);

  virtual ~MActionItem();

  virtual void printOn(ostream& s) const;
  /**<\brief This method is used in conjunction with the streaming operator <<
   to print the current state of MActionItem. */

  virtual void streamIn(istream& s);
  /**<\brief This method is used in conjunction with the streaming operator >>
     to read the current state of MActionItem. */
  
  // = Class specific methods.

  MActionItem(const MString& codeValue,
       const MString& codeSchemeDesignator,
       const MString& codeMeaning,
       //const MString& studyInstanceUID,
       const MString& spsIndex
       );
  ///< Constructor which takes all of the attributes in an action item.
  /**< Variable names in the constructor should be self explanatory.
   All values are copied directly into the internal state of the action
   item object. */

  void import(const MDomainObject& o);
  ///< This method imports the key/value pairs from an existing domain object <{o}> into this MActionItem.

  //MString scheduledProcedureStepID() const;
  // Return a copy of the Scheduled Procedure Step ID.

  MString spsIndex() const;
  ///< Return a copy of the SPS Index.

  MString codeValue() const;
  ///< Return a copy of the Code Value.

  MString codeMeaning() const;
  ///< Return a copy of the Code Meaning.

  MString codeSchemeDesignator() const;
  ///< Return a copy of the Code Scheme Designator.

  //MString studyInstanceUID() const;
  // Return a copy of the Study Instance UID.

  //void scheduledProcedureStepID(const MString& s);
  // Set the Scheduled Procedure Step ID according to the value in <{s}>.

  void spsIndex(const MString& s);
  ///< Set the SPS Index according to the value in <{s}>.

  void codeValue(const MString& s);
  ///< Set the Code Value according to the value in <{s}>.

  void codeMeaning(const MString& s);
  ///< Set the Code Meaning according to the value in <{s}>.

  void codeSchemeDesignator(const MString& s);
  ///< Set the Code Scheme Designator according to the value in <{s}>.

  //void studyInstanceUID(const MString& s);
  // Set the Study Instance UID according to the value in <{s}>.

private:
  //MString mScheduledProcedureStepID;
  MString mSPSIndex;
  MString mCodeValue;
  MString mCodeMeaning;
  MString mCodeSchemeDesignator;
  //MString mStudyInstanceUID;
};

inline ostream& operator<< (ostream& s, const MActionItem& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MActionItem& c) {
  c.streamIn(s);
  return s;
}

#endif
