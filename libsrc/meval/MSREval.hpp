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

// $Id: MSREval.hpp,v 1.7 2006/06/29 16:08:32 bhasselfeld Exp $ $Author: bhasselfeld $ $Revision: 1.7 $ $Date: 2006/06/29 16:08:32 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MSREval.hpp
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
//	$Revision: 1.7 $
//
//  = DATE RELEASED
//	$Date: 2006/06/29 16:08:32 $
//
//  = COMMENTS
//	

#ifndef MSREvalISIN
#define MSREvalISIN

//#include <iostream>
//#include <string>
#include <vector>
//#include "ctn_api.h"
//#include "MLogClient.hpp"

using namespace std;

class MSRWrapper;
class MSRContentItem;

class MSREval
// = TITLE
///	This class is used to evaluate SR objects
//
// = DESCRIPTION
//
{
typedef struct {
  int idx;
  char requirement;
  char comment[512];
} CONTENT_ITEM_REQUIREMENT;
typedef vector < CONTENT_ITEM_REQUIREMENT > MSREvalRequirementVector;

public:
  // = The standard methods in this framework.

  /// Default constructor.
  MSREval();

  MSREval(const MSREval& cpy);
  ///< Copy constructor

  virtual ~MSREval();
  ///< Destructor.

  virtual void printOn(ostream& s) const;
  /**<\brief This method is used in conjunction with the streaming operator <<
  	     to print the current state of MSREval. */

  virtual void streamIn(istream& s);
  /**<\brief This method is used in conjunction with the streaming operator >>
  	     to read the current state of MSREval. */

  // = Class specific methods.

  void verbose(bool flag);
  ///< Turn verbose mode on/off according to the value in {<flag}>.

  void setTestObject(MSRWrapper* w);
  void setPatternObject(MSRWrapper* w);
  void readContentItemRequirements(const MString& fileName);

  
  /** Evaluation methods use a common return value.
   Return value of 0 means the evaluation completed successfully
   Return value > 0 means there were errors in the object but
   you can run other tests.
   Return value of < 0 means there are fatal errors and you should
   not continue. */
  int evalTemplateIdentification(const MString& templateString) const;
  int evalTemplate(const MString& templateString) const;
  int evalPredecessorDocumentSequence() const;
  int evalSRDocumentContentModule() const;
  /**<\brief This method performs evaluation of the general structure
  	     and requirements of the SR Document Content Module. */

  int compareContentItems( );
  int compareRequiredContentItems( );
  int compareOptionalContentItems( );
  int dumpExtraContentItems( );
  int compareContentItems(MSRContentItem* patternItem,
			  MSRContentItem* testItem);


protected:
  MSRWrapper* mTestWrapper;
  MSRWrapper* mPatternWrapper;
  bool mVerbose;

private:
  MSREvalRequirementVector mRequirementVector;
  int textCompare(const MString& textPattern,
		  const MString& textTest,
		  const MString& label) const;
  int testContinuityOfContent(MSRContentItem *testItem, int level) const;
};

inline ostream& operator<< (ostream& s, const MSREval& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MSREval& c) {
  c.streamIn(s);
  return s;
}

#endif
