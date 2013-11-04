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

// $Id: MLMPPSEvaluator.hpp,v 1.9 2005/09/16 19:52:38 smm Exp $ $Author: smm $ $Revision: 1.9 $ $Date: 2005/09/16 19:52:38 $ $State: Exp $
//
// ====================
//  = LIBRARY
//	xxx
//
//  = FILENAME
//	MLQuery.hpp
//
//  = AUTHOR
//	Author Name
//
//  = COPYRIGHT
//	Copyright Washington University, 1999
//
// ====================
//
//  = VERSION
//	$Revision: 1.9 $
//
//  = DATE RELEASED
//	$Date: 2005/09/16 19:52:38 $
//
//  = COMMENTTEXT
//	Comments

#ifndef MLMPPSEvaluatorISIN
#define MLMPPSEvaluatorISIN

#include <iostream>
#include <string>

#include "MESA.hpp"
#include "MDICOMWrapper.hpp"
#include "ctn_api.h"

using namespace std;

class MDICOMWrapper;

class MLMPPSEvaluator
// = TITLE
//	Short title/description
//
// = DESCRIPTION
//	Describe the class and how to use it
{
public:
  // = The standard methods in this framework.
  //MLMPPSEvaluator();
  // Default constructor
  MLMPPSEvaluator(const MLMPPSEvaluator& cpy);
  virtual ~MLMPPSEvaluator();
  virtual void printOn(ostream& s) const;
  // This method is used in conjunction with the streaming operator <<
  // to print the current state of MLMPPSEvaluator

  virtual void streamIn(istream& s);

  MLMPPSEvaluator(MDICOMWrapper& testData, MDICOMWrapper& mStandardData);

  void outputLevel(int level);
  void language(const MString& language);

  virtual int run(const MString& dataSource, const MString& operation) = 0;

  virtual int evalPPSRelationshipScheduled(
		const MString& dataSource,
		const MString& operation);

  virtual int evalPPSRelationshipGroupCase(
		const MString& dataSource,
		const MString& operation);

  virtual int evalPPSInformationScheduled(
		const MString& dataSource,
		const MString& operation);

  virtual int evalPPSImageAcqScheduled(
		const MString& dataSource,
		const MString& operation);

  virtual int evalPPSRelationshipUnscheduled(
		const MString& dataSource,
		const MString& operation);

  void performedProtocolCodeFlag(bool flag);

protected:
  int mOutputLevel;
  MString mLanguage;
  MDICOMWrapper& mTestData;
  MDICOMWrapper& mStandardData;
  bool mPerformedProtocolCodeFlag;

  int evalPPSRelationshipScheduledNCreate(const MString& dataSource);
  int evalPPSRelationshipScheduledNSet(const MString& dataSource);
  int evalPPSRelationshipScheduledFinal(const MString& dataSource);

  int evalPPSRelationshipGroupCaseNCreate(const MString& dataSource);
  int evalPPSRelationshipGroupCaseNSet(const MString& dataSource);
  int evalPPSRelationshipGroupCaseFinal(const MString& dataSource);

  int evalPPSInformationScheduledNCreate(const MString& dataSource);
  int evalPPSInformationScheduledNSet(const MString& dataSource);
  int evalPPSInformationScheduledFinal(const MString& dataSource);

  virtual int evalPPSImageAcqScheduledNCreate(const MString& dataSource);
  virtual int evalPPSImageAcqScheduledNSet(const MString& dataSource);
  virtual int evalPPSImageAcqScheduledFinal(const MString& dataSource);

  int evalPPSRelationshipUnscheduledNCreate(const MString& dataSource);
  int evalPPSRelationshipUnscheduledNSet(const MString& dataSource);
  int evalPPSRelationshipUnscheduledFinal(const MString& dataSource);

  int countSequenceItems(MDICOMWrapper& w, DCM_TAG seqTag, DCM_TAG attrTag);
  MDICOMWrapper* findMatchingSequenceItem(
	const MString& keyString,
	MDICOMWrapper& w,
        DCM_TAG seqTag, DCM_TAG itemTag);


protected:

private:

  MDICOMWrapper* matchingScheduledStep(MDICOMWrapper* wStandard,
        const MString& scheduledStepID);

};

inline ostream& operator<< (ostream& s, const MLMPPSEvaluator& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MLMPPSEvaluator& c) {
  c.streamIn(s);
  return s;
}

#endif
