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

// $Id: MCharsetEncoder.hpp,v 1.4 2006/06/29 16:08:28 bhasselfeld Exp $ $Author: bhasselfeld $ $Revision: 1.4 $ $Date: 2006/06/29 16:08:28 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MCharsetEncoder.hpp
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
//	$Revision: 1.4 $
//
//  = DATE RELEASED
//	$Date: 2006/06/29 16:08:28 $
//
//  = COMMENTS

#ifndef MCharsetEncoderISIN
#define MCharsetEncoderISIN

#include <iostream>
#include <string>
#include "ctn_api.h"

using namespace std;

class MCharsetEncoder
// = TITLE
//	MCharsetEncoder - 
//
// = DESCRIPTION

{
public:
  // = The standard methods in this framework.

  MCharsetEncoder();
  ///< Default constructor

  MCharsetEncoder(const MCharsetEncoder& cpy);
  ///< Copy constructor

  virtual ~MCharsetEncoder();
  ///< Destructor

  virtual void printOn(ostream& s) const;
  /**<\brief This method is used in conjunction with the streaming operator <<
   to print the current state of MCharsetEncoder */

  virtual void streamIn(istream& s);
  /**<\brief This method is used in conjuction with the streaming operator >>
   to read the current state of MCharsetEncoder. */
  
  // = Class specific methods.

  int xlate(
	void* outString, int& outputLength, int maxOut,
	const void* inString, int inLength,
	const MString& inEncoding, const MString& outEncoding);
  ///< Translate from input string to output string.
  /**< Encoding names are:
    ISO2022JP
    EUC_JP */

  int xlateHL7DICOM(
	void* outString, int& outputLength, int maxOut,
	const void* inString, int inLength,
	const MString& encoding);
  ///< Translate from input string with HL7 escape sequences to output string with DICOM escape sequences.
  /**< Encoding names are:
      ISO2022JP */

  int xlateHL7DICOMEUCJP(
        void* outString, int& outputLength, int maxOut,
        const void* inString, int inLength,
        const MString& encoding);

  int substituteCharacter(
	void* charString, int length,
	const unsigned char inChar, const unsigned char outChar,
	const MString& encoding);
  ///< Find occurrences of a single character (inChar) and translate to the value specified in outChar.
  /**< Encoding names (encoding) are
  	EUCJP */

private:
  int xlateISO2022JP_EUCJP(
	void* outString, int& outputLength, int maxOut,
	const void* inString, int inLength);
  int xlateEUCJP_ISO2022JP(
	void* outString, int& outputLength, int maxOut,
	const void* inString, int inLength);
  int getNextHL7Character(unsigned char* output, int& outputCount, int& skipCount,
        CHR_CHARACTER currentMode, CHR_CHARACTER& newMode,
        const unsigned char* input, int inLength);
};

inline ostream& operator<< (ostream& s, const MCharsetEncoder& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MCharsetEncoder& c) {
  c.streamIn(s);
  return s;
}

#endif
