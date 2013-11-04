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

// $Id: MInputInfo.hpp,v 1.3 2006/06/29 16:08:31 bhasselfeld Exp $ $Author: bhasselfeld $ $Revision: 1.3 $ $Date: 2006/06/29 16:08:31 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MInputInfo.hpp
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
//	$Revision: 1.3 $
//
//  = DATE RELEASED
//	$Date: 2006/06/29 16:08:31 $
//
//  = COMMENTS
//

#ifndef MInputInfoISIN
#define MInputInfoISIN

#include <iostream>
#include <string>
#include <vector>
#include "MDomainObject.hpp"
#include "MDBInterface.hpp"

using namespace std;

class MInputInfo;
typedef vector< MInputInfo > MInputInfoVector;

class MInputInfo : public MDomainObject
// = TITLE
///	A domain object which corresponds to Output Information Sequence items.
//
// = DESCRIPTION

{
public:
  // = The standard methods in this framework.

  MInputInfo();
  ///< Default constructor

  MInputInfo(const MInputInfo& cpy);

  virtual ~MInputInfo();

  virtual void printOn(ostream& s) const;
  /**<\brief This method is used in conjunction with the streaming operator <<
  	     to print the current state of MInputInfo. */

  virtual void streamIn(istream& s);
  /**< This method is used in conjunction with the streaming operator >>
       to read the current state of MInputInfo. */

  MInputInfo(
       const MString& studyInstanceUID,
       const MString& seriesInstanceUID,
       const MString& retrieveAETitle,
       const MString& SOPClassUID,
       const MString& SOPInstanceUID,
       const MString& workitemkey);
  /**<\brief This constructor takes a number of attributes which are defined for
  	     a input info item and copies them into the internal state of
   	     this object. */

  
  // = Class specific methods.

  /// test this object for matching contents
  bool equals( MInputInfo& ii);

  //  Return copies of attributes.
  MString SOPInstanceUID() const;
  MString SOPClassUID() const;
  MString studyInstanceUID() const;
  MString seriesInstanceUID() const;
  MString retrieveAETitle() const;
  MString workitemkey() const;


  //  Set attributes.
  void SOPInstanceUID(const MString& s);
  void SOPClassUID(const MString& s);
  void studyInstanceUID(const MString& s);
  void seriesInstanceUID(const MString& s);
  void retrieveAETitle(const MString& s);
  void workitemkey(const MString& s);


  void import(const MDomainObject& o);
  /**<\brief Import the key-value pairs from the MDomainObject <{o}> and set the
  	     appropriate values in this object. */

  // Alter the database with these values.
  void update( MDBInterface &db);
  void dbremove( MDBInterface *db);
  void dbinsert( MDBInterface *db);

private:
  MString mSOPInstanceUID;
  MString mSOPClassUID;
  MString mStudyInstanceUID;
  MString mSeriesInstanceUID;
  MString mRetrieveAETitle;
  MString mWorkitemkey;
};

inline ostream& operator<< (ostream& s, const MInputInfo& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MInputInfo& c) {
  c.streamIn(s);
  return s;
}

#endif
