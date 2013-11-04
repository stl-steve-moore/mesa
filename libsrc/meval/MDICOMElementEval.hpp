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

// $Id: MDICOMElementEval.hpp,v 1.3 2006/06/29 16:08:32 bhasselfeld Exp $ $Author: bhasselfeld $ $Revision: 1.3 $ $Date: 2006/06/29 16:08:32 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MDICOMElementEval.hpp
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
//	$Revision: 1.3 $
//
//  = DATE RELEASED
//	$Date: 2006/06/29 16:08:32 $
//
//  = COMMENTS
//	

#ifndef MDICOMElementEvalISIN
#define MDICOMElementEvalISIN

#include "ctn_api.h"
#include "MLogClient.hpp"

using namespace std;

class MDICOMWrapper;


class MDICOMElementEval
// = TITLE
///	This class is used to evaluate DICOM Composite objects
//
// = DESCRIPTION
//
{
typedef struct {
  char* label;
  DCM_TAG tag;
} ATTRIBUTE;

public:
  // = The standard methods in this framework.

  /// Default constructor.
  MDICOMElementEval();

  MDICOMElementEval(const MDICOMElementEval& cpy);
  ///< Copy constructor

  virtual ~MDICOMElementEval();
  ///< Destructor.

  virtual void printOn(ostream& s) const;
  /**<\brief This method is used in conjunction with the streaming operator <<
             to print the current state of MDICOMElementEval. */

  virtual void streamIn(istream& s);
  /**<\brief This method is used in conjunction with the streaming operator >>
  	     to read the current state of MDICOMElementEval. */

  // = Class specific methods.

  void verbose(bool flag);
  ///< Turn verbose mode on/off according to the value in {<flag}>.

  void setTestObject(MDICOMWrapper* w);
  void setPatternObject(MDICOMWrapper* w);


  /** Evaluation methods use a common return value.
      Return value of 0 means the evaluation completed successfully
      Return value > 0 means there were errors in the object but
      you can run other tests.
      Return value of < 0 means there are fatal errors and you should
      not continue. */
  int evalElement(int level, MDICOMWrapper& wTest, MDICOMWrapper& wGoldStandard, DCM_TAG tag,
		const MString& language = "");

protected:
  bool mVerbose;

private:
  int evaluateString(const MString& label, int level,
	MDICOMWrapper& wTest, MDICOMWrapper& wGoldStandard, DCM_ELEMENT* e,
	const MString& language) const;
  int evaluatePN(const MString& label, int level,
	const MString& sTest, const MString& Gold,
	const MString& language) const;
  void dumpCharInHex(const MString& stest, const MString& sStd,
	const MString& language) const;
};

inline ostream& operator<< (ostream& s, const MDICOMElementEval& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MDICOMElementEval& c) {
  c.streamIn(s);
  return s;
}

#endif
