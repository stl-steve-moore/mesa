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

// $Id: MHL7Validator.hpp,v 1.11 2006/06/29 16:08:32 bhasselfeld Exp $ $Author: bhasselfeld $ $Revision: 1.11 $ $Date: 2006/06/29 16:08:32 $ $State: Exp $
//
// ====================
//  = FILENAME
//	HL7Validator.hpp
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
//	$Revision: 1.11 $
//
//  = DATE RELEASED
//	$Date: 2006/06/29 16:08:32 $
//
//  = COMMENTS
//

#ifndef MHL7ValidatorISIN
#define MHL7ValidatorISIN

#include <iostream>
#include <fstream>
#include <cstdlib>
#include <string>
#include <map>

#include "hl7_api.h"

using namespace std;

class MHL7Msg;

typedef enum
{
  ERROR_UNKNOWN,
  HL7MSG_NOT_AVAIL,
  INVALID_PARAMS,
  INVALID_PROC_ID,
  INVALID_VER_NUM,
  INVALID_FIELD,
  INVALID_SEGMENT,
  SEG_NOT_PRESENT,
  REQ_SEG_NOT_PRESENT,
  SEG_REP_NOT_ALWD,
  REQ_FLD_NOT_PRESENT,
  FLD_REP_NOT_ALWD,
  FLD_EXCEEDS_MAX_LEN
} ERROR_TYPE;
///< struct

typedef struct
{
  MString    segName;
  int        fldNum;
  int        compNum;
  int        subCompNum;
  ERROR_TYPE errorType;
} ERROR_INFO;
///< struct

typedef vector <MString> MPossVals;
typedef struct
{
  int     fldNum;
  int     compNum;
  int     subCompNum;
  MString format;
  MPossVals possVals;
} FIELD_INFO;
///< struct

typedef multimap <MString, FIELD_INFO, less <MString> > MSegmentInfo;

class MHL7Validator
// = TITLE
///	This class validates HL7 messages.
//
// = DESCRIPTION
/**	This class uses the HL7IMEXA library to manage HL7 messages and
	to validate those messages according to the rules and functions
	in HL7IMEXA. */
{
public:
  // = The standard methods in this framework.

  MHL7Validator();
  ///< Default constructor

  MHL7Validator(const MHL7Validator& cpy);

  virtual ~MHL7Validator();

  virtual void printOn(ostream& s) const;
  /**<\brief This method is used in conjunction with the streaming operator <<
     to print the current state of MHL7Validator. */

  virtual void streamIn(istream& s);
  /**<\brief This method is used in conjunction with the streaming operator >>
     to read the current state of MHL7Validator. */

  MHL7Validator(const MString& hl7Base, const MString& hl7Definition);
  /**<\brief For this constructor, <{hl7Base}> is the name of the directory
   containing the HL7 definition files.  <{hl7Definition}> is the
   file extension that identifies which definition files to use. */

  // = Class specific methods.

  //MHL7Validator(const MString& versionNumber, const MString& hl7Message);
  // This constructor reads the HL7 message to be validated from the
  // string <{hl7Message}>.  The argument <{versionNumber}> is used by
  // the HL7IMEXA toolkit to define which rules to apply.

  //MHL7Validator(const MString& versionNumber,
  //		const MString& filePath, const MString& fileName);
  // This constructor reads the HL7 message to be validated from the
  // file specified by the directory name in <{filePath}> and file name
  // in <{fileName}>.  The argument <{versionNumber}> is used by
  // the HL7IMEXA toolkit to define which rules to apply.

  //MHL7Validator(const MString& versionNumber, HL7FLVR *flavor, HL7MSG *hl7Msg);
  // This constructor takes an already created HL7IMEXA HL7 message to
  // perform validation.  The argument <{versionNumber}> is used by
  // the HL7IMEXA toolkit to define which rules to apply.
  // <{flavor}> and <{hl7Msg}> are created using the HL7IMEXA toolkit.
  // <{flavor}> is created by <{HL7Init}>.

  int validateProcessingID();
  /**<\brief Returns 1 if the message contains the proper Processing ID and 0 if
   not.  The validation processing ID defaults to 'P', but that can be
   changed by the user. */

  int validateHL7Message(MHL7Msg& msg, const MString& maskFile, ERROR_INFO& errInfo, int logLevel=1);


private:
  MString mBase;
  MString mDefinition;
  int  mCount; // keeps a running count of number of differences found
  int mLogLevel;

  //HL7FLVR *mFlavor;
  //HL7MSG  *mMsg;
  char    mProcessingID;  // P - Production, D - Debugging, T - Training
  MString mVersionNumber;

  MSegmentInfo mSegInfo;
  MStringVector mSegmentNames;

  void initializeErrorInfo(ERROR_INFO& errInfo);
  int initializeFormat(const MString& path);
  int checkFormat(MHL7Msg& msg, const MString& key, ERROR_INFO& errInfo);
  int checkFieldFormat(MHL7Msg& msg, const FIELD_INFO& fldInfo,
			const MString& segName, ERROR_INFO& errInfo);
  int verifyFormat(const MString& value, const MString& format);
  int verifyPossibleValues(const MString& value, const MPossVals& possVals); 

  int validateVersionNumber();
  int validateSegments(MHL7Msg& msg, ERROR_INFO& errInfo);  
// dont know how I am going to validate for the presence of Required Segments,
// repitition of segments where duplication is allowed.
  int validateFields(MHL7Msg& msg, ERROR_INFO& errInfo);
  int validateFields(const MString& segName, ERROR_INFO& errInfo);
  void processingID(char processingID);  // sets processing ID
  int getFirstSegment(MString& segName);  // gets first segment
  int getNextSegment(MString& segName);
};

inline ostream& operator<< (ostream& s, const MHL7Validator& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MHL7Validator& c) {
  c.streamIn(s);
  return s;
};

#endif
