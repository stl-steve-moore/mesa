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

// $Id: MHL7Compare.hpp,v 1.12 2006/06/29 16:08:32 bhasselfeld Exp $ $Author: bhasselfeld $ $Revision: 1.12 $ $Date: 2006/06/29 16:08:32 $ $State: Exp $
//
// ====================
//  = FILENAME
//	HL7Compare.hpp
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
//	$Revision: 1.12 $
//
//  = DATE RELEASED
//	$Date: 2006/06/29 16:08:32 $
//
//  = COMMENTS
//

#ifndef MHL7CompareISIN
#define MHL7CompareISIN

#include <iostream>
#include <fstream>
#include <cstdlib>
#include <string>
//#include <stl>
#include <map>

#include "hl7_api.h"

using namespace std;

typedef struct
{
  int     fldNum;
  MString existValue;
  MString newValue;
  MString comment;
} DIFF;
///< struct

typedef multimap <MString, DIFF, less <MString> > MDiff;

typedef struct
{
  int     fldNum;
  int     compNum;
  int     subCompNum;
} FIELD_INFO;
///< struct

typedef multimap <MString, FIELD_INFO, less <MString> > MSegmentInfo;

class MHL7Compare
// = TITLE
///	This class is used to compare HL7 messages to see if they have 
//	the same content.
//
// = DESCRIPTION
/**	This class takes an HL7 message and compares that to an existing
	HL7 "gold standard" message. */
{
public:
  // = The standard methods in this framework.

  MHL7Compare();
  ///< Default constructor

  MHL7Compare(const MHL7Compare& cpy);

  virtual ~MHL7Compare();

  virtual void printOn(ostream& s) const;
  /**<\brief This method is used in conjunction with the streaming operator <<
   to print the current state of MHL7Compare. */

  virtual void streamIn(istream& s);
  /**<\brief This method is used in conjunction with the streaming operator >>
   to read the current state of MHL7Compare. */
  
  // = Class specific methods.

  MHL7Compare(const MString& hl7Base, const MString& hl7Definition);
  /**<\brief For this constructor, <{hl7Base}> is the name of the directory
   containing the HL7 definition files.  <{hl7Definition}> is the
   file extension that identifies which definition files to use. */

  MHL7Compare(const MString& hl7Base, const MString& hl7Definition,
	      const MString& fileName);
  /**<\brief For this constructor, <{hl7Base}> is the name of the directory
   containing the HL7 definition files.  <{hl7Definition}> is the
   file extension that identifies which definition files to use.
   <{fileName}> is the name of a mask file which indicates which
   attributes to compare. */

  int compare(const MString& existFile, const MString& newFile, int logLevel = 1);
  /**<\brief Compares <{existFile}> with <{newFile}>,
   both containing the same HL7 message.
  MHL7Compare(HL7MSG* const existMsg, HL7MSG* const newMsg); */

  int compare(HL7MSG* const existMsg, HL7MSG* const newMsg, int logLevel = 1);
  ///< Compares two HL7 messages, <{newMsg}> with <{existMsg}>.

  int count();
  ///< Returns the number of differences encountered during a compare.

  MDiff& getDiff(); 
  /**<\brief Returns a reference to the internal map of differences that we
   maintain during a comparison. */

private:
  bool mLogLevel;
  MString mBase;
  MString mDefinition;
  int  mCount; // keeps a running count of number of differences found
  HL7FLVR *mFlavorExist;
  HL7FLVR *mFlavorNew;
  HL7MSG *mMsgExist;
  HL7MSG *mMsgNew;
  MDiff mDiff; // keeps track of all the differences
  MSegmentInfo mSegInfo;

  void compareHL7();
  void compareFields(const MString& segName);
  int compareComponents(const MString& segName, const MString& fldExist, const MString& fldNew);
  void compareMesgHeaders();
  void compareEVNs();
  int getFirstSegment(HL7MSG* mMsg, MString& segName);
  int getNextSegment(HL7MSG* mMsg, MString& segName);
  int findSegment(HL7MSG* mMsg, const MString& segName);

  void initializeFormat(const MString& fileName);
  void compareFieldValues(const MString& segment, int fldNum, int compNum, int subCompNum);

};

inline ostream& operator<< (ostream& s, const MHL7Compare& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MHL7Compare& c) {
  c.streamIn(s);
  return s;
};

#endif
