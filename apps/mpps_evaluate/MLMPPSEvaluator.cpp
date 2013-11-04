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

#include "MESA.hpp"
#include "MLMPPSEvaluator.hpp"
#include "MDICOMWrapper.hpp"
#include "MEval.hpp"
#include "MDICOMElementEval.hpp"
#include "ctn_api.h"

#include <iomanip>

#if 0
MLMPPSEvaluator::MLMPPSEvaluator()
{
}
#endif

MLMPPSEvaluator::MLMPPSEvaluator(const MLMPPSEvaluator& cpy) :
  mOutputLevel(cpy.mOutputLevel),
  mTestData(cpy.mTestData),
  mStandardData(cpy.mStandardData),
  mPerformedProtocolCodeFlag(cpy.mPerformedProtocolCodeFlag)
{
}

MLMPPSEvaluator::~MLMPPSEvaluator()
{
}

void
MLMPPSEvaluator::printOn(ostream& s) const
{
  s << "MLMPPSEvaluator";
}

void
MLMPPSEvaluator::streamIn(istream& s)
{
  //s >> this->member;
}

// Non-boiler plate methods to follow

MLMPPSEvaluator::MLMPPSEvaluator(MDICOMWrapper& testData,
				 MDICOMWrapper& standardData) :
  mTestData(testData),
  mStandardData(standardData)
{
}

void
MLMPPSEvaluator::outputLevel(int level)
{
  mOutputLevel = level;
}

void
MLMPPSEvaluator::language(const MString& language)
{
  mLanguage = language;
}



int
MLMPPSEvaluator::evalPPSRelationshipScheduled(
			const MString& dataSource,
			const MString& operation)
{
  int status = 1;

  if (operation == "NCREATE") {
    status = this->evalPPSRelationshipScheduledNCreate(dataSource);
  } else if (operation == "NSET") {
    status = this->evalPPSRelationshipScheduledNSet(dataSource);
  } else if (operation == "FINAL") {
    status = this->evalPPSRelationshipScheduledFinal(dataSource);
  } else {
    cerr << "In MLMPPSEvaluator::evalPPSRelationshipScheduled"
	 << endl
	 << " illegal operation to evaluate: " << operation
	 << endl;
    status = 1;
  }
  return status;
}

int
MLMPPSEvaluator::evalPPSRelationshipGroupCase(
			const MString& dataSource,
			const MString& operation)
{
  int status = 1;

  if (operation == "NCREATE") {
    status = this->evalPPSRelationshipGroupCaseNCreate(dataSource);
  } else if (operation == "NSET") {
    status = this->evalPPSRelationshipGroupCaseNSet(dataSource);
  } else if (operation == "FINAL") {
    status = this->evalPPSRelationshipGroupCaseFinal(dataSource);
  } else {
    cerr << "In MLMPPSEvaluator::evalPPSRelationshipGroupCase"
	 << endl
	 << " illegal operation to evaluate: " << operation
	 << endl;
    status = 1;
  }
  return status;
}

int
MLMPPSEvaluator::evalPPSInformationScheduled(
			const MString& dataSource,
			const MString& operation)
{
  int status = 1;

  if (operation == "NCREATE") {
    status = this->evalPPSInformationScheduledNCreate(dataSource);
  } else if (operation == "NSET") {
    status = this->evalPPSInformationScheduledNSet(dataSource);
  } else if (operation == "FINAL") {
    status = this->evalPPSInformationScheduledFinal(dataSource);
  } else {
    cerr << "In MLMPPSEvaluator::evalPPSInformationScheduled"
	 << endl
	 << " illegal operation to evaluate: " << operation
	 << endl;
    status = 1;
  }
  return status;
}

int
MLMPPSEvaluator::evalPPSImageAcqScheduled(
			const MString& dataSource,
			const MString& operation)
{
  int status = 1;

  if (operation == "NCREATE") {
    status = this->evalPPSImageAcqScheduledNCreate(dataSource);
  } else if (operation == "NSET") {
    status = this->evalPPSImageAcqScheduledNSet(dataSource);
  } else if (operation == "FINAL") {
    status = this->evalPPSImageAcqScheduledFinal(dataSource);
  } else {
    cerr << "In MLMPPSEvaluator::evalPPSImageAcqScheduled"
	 << endl
	 << " illegal operation to evaluate: " << operation
	 << endl;
    status = 1;
  }
  return status;
}

int
MLMPPSEvaluator::evalPPSRelationshipUnscheduled(
			const MString& dataSource,
			const MString& operation)
{
  int status = 1;

  if (operation == "NCREATE") {
    status = this->evalPPSRelationshipUnscheduledNCreate(dataSource);
  } else if (operation == "NSET") {
    status = this->evalPPSRelationshipUnscheduledNSet(dataSource);
  } else if (operation == "FINAL") {
    status = this->evalPPSRelationshipUnscheduledFinal(dataSource);
  } else {
    cerr << "In MLMPPSEvaluator::evalPPSRelationshipUnscheduled"
	 << endl
	 << " illegal operation to evaluate: " << operation
	 << endl;
    status = 1;
  }
  return status;
}

void
MLMPPSEvaluator::performedProtocolCodeFlag(bool flag)
{
  mPerformedProtocolCodeFlag = flag;
}

// Private methods below

int
MLMPPSEvaluator::evalPPSRelationshipScheduledNCreate(const MString& dataSource)
{
  return 0;
}

int
MLMPPSEvaluator::evalPPSRelationshipScheduledNSet(const MString& dataSource)
{
  return 0;
}

int
MLMPPSEvaluator::evalPPSRelationshipScheduledFinal(const MString& dataSource)
{
  // See PS 3.4, Table F.7.2-1
  U16 uGroup;
  U16 uElement;

  DCM_TAG tags[] = {	0x00100010,	// Patient Name
			0x00100020,	// Patient ID
			0x00100030,	// Patient's Birth Date
			0x00100040,	// Patient's Sex
			0};

  MDICOMElementEval evl;
  int rtnStatus = 0;
  int idx = 0;

  if (mOutputLevel >= 3) {
    cout << MESA_CONTEXT_TEXT
	 << " MPPS Relationship module (Scheduled case)" << endl;
  }

  for (idx = 0; tags[idx] != 0; idx++) {
    MString t = mTestData.getString(tags[idx]);	// The string from the test object
    MString s = mStandardData.getString(tags[idx]);  // The string from the gold std
    uGroup = DCM_TAG_GROUP(tags[idx]);		// The group number of the attribute
    uElement = DCM_TAG_ELEMENT(tags[idx]);	// The lement number of the attribute
    int eRtn = 0;				// Return value from element evaluation
    MString lang = (tags[idx] == 0x00100010) ? mLanguage : "";
    eRtn = evl.evalElement(mOutputLevel, mTestData, mStandardData, tags[idx], lang);
    if (eRtn < 0) {
      cout << MESA_ERROR_TEXT
	   << " MPPS mismatch in PPS Relationship "
	   << setw(4) << setfill ('0') << hex << uGroup << " "
	   << setw(4) << setfill ('0') << hex << uElement
	   << " (" << s << ":"
	   << t << ")" << endl;

      rtnStatus = 1;
    } else if ((eRtn > 0) && (mOutputLevel >= 2)) {
      cout << MESA_WARN_TEXT << " "
	   << setw(4) << setfill ('0') << hex << uGroup << " "
	   << setw(4) << setfill ('0') << hex << uElement
	   << " " << s;
      if (tags[idx] == 0x00100010){
	cout << endl << MESA_WARN_TEXT << " "
	     << setw(4) << setfill ('0') << hex << uGroup << " "
	     << setw(4) << setfill ('0') << hex << uElement;
      }
      cout << " " << t << endl;
    } else if (mOutputLevel >= 3) {
      cout << MESA_CONTEXT_TEXT << " "
	   << setw(4) << setfill ('0') << hex << uGroup << " "
	   << setw(4) << setfill ('0') << hex << uElement
	   << " STD  " << s;
      if (tags[idx] == 0x00100010){
	cout << endl << MESA_CONTEXT_TEXT << " "
	     << setw(4) << setfill ('0') << hex << uGroup << " "
	     << setw(4) << setfill ('0') << hex << uElement;
      }
      cout << " TEST " << t << endl;
    }
  }

  DCM_TAG scheduledStepAttributeSeqTags[] = {
		0x0020000D,		// Study Instance UID
		0x00080050,		// Accession Number
		0x00401001,		// Requested Procedure ID
		0x00321060,		// Requested Procedure Description,
		0x00400009,		// Scheduled Procedure Step ID
		0x00400007,		// Scheduled Procedure Step Description
		0
	};

  if (mOutputLevel >= 3) {
    cout << MESA_CONTEXT_TEXT << " "
	 << "Scheduled Step Attribute Sequence 0040 0270" << endl;
  }
  for (idx = 0; scheduledStepAttributeSeqTags[idx] != 0; idx++) {
    MString t = mTestData.getString(0x00400270,
		scheduledStepAttributeSeqTags[idx]);
    MString s = mStandardData.getString(0x00400270,
		scheduledStepAttributeSeqTags[idx]);
    uGroup = DCM_TAG_GROUP(scheduledStepAttributeSeqTags[idx]);
    uElement = DCM_TAG_ELEMENT(scheduledStepAttributeSeqTags[idx]);
    if (t != s) {
      cout << MESA_ERROR_TEXT
	   << " MPPS mismatch in PPS Relationship 0040 0270 "
	   << setw(4) << setfill ('0') << hex << uGroup << " "
	   << setw(4) << setfill ('0') << hex << uElement
	   << "(" << s << ":"
	   << t << ")" << endl;

      rtnStatus = 1;
    } else if (mOutputLevel >= 3) {
      cout << MESA_CONTEXT_TEXT << " "
	   << setfill ('0') << hex << uGroup << " "
	   << setw(4) << setfill ('0') << hex << uElement
	   << " " << s << " " << t << endl;
    }
  }

  return rtnStatus;
}

int
MLMPPSEvaluator::evalPPSRelationshipGroupCaseNCreate(const MString& dataSource)
{
  return 0;
}

int
MLMPPSEvaluator::evalPPSRelationshipGroupCaseNSet(const MString& dataSource)
{
  return 0;
}

int
MLMPPSEvaluator::evalPPSRelationshipGroupCaseFinal(const MString& dataSource)
{
  // See PS 3.4, Table F.7.2-1
  U16 uGroup;
  U16 uElement;

  DCM_TAG tags[] = {	0x00100010,	// Patient Name
			0x00100020,	// Patient ID
			0x00100030,	// Patient's Birth Date
			0x00100040,	// Patient's Sex
			0};

  int rtnStatus = 0;
  int idx = 0;

  for (idx = 0; tags[idx] != 0; idx++) {
    MString t = mTestData.getString(tags[idx]);
    MString s = mStandardData.getString(tags[idx]);
    uGroup = DCM_TAG_GROUP(tags[idx]);
    uElement = DCM_TAG_ELEMENT(tags[idx]);
    if (t != s) {
      cout << MESA_ERROR_TEXT
	   << " MPPS mismatch in PPS Relationship "
	   << setw(4) << setfill ('0') << hex << uGroup << " "
	   << setw(4) << setfill ('0') << hex << uElement
	   << " (" << s << ":"
	   << t << ")" << endl;

      rtnStatus = 1;
    } else if (mOutputLevel >= 3) {
      cout << MESA_CONTEXT_TEXT << " "
	   << setw(4) << setfill ('0') << hex << uGroup << " "
	   << setw(4) << setfill ('0') << hex << uElement
	   << " " << s << " " << t << endl;
    }
  }

  int countSPSStandard = 0;
  int countSPSTest = 0;
  MString sx = mStandardData.getString(0x00400270, 0x00400009, countSPSStandard + 1);
  while (sx != "") {
    countSPSStandard++;
    sx = mStandardData.getString(0x00400270, 0x00400009, countSPSStandard+1);
  }

  sx = mTestData.getString(0x00400270, 0x00400009, countSPSTest + 1);
  while (sx != "") {
    countSPSTest++;
    sx = mStandardData.getString(0x00400270, 0x00400009, countSPSTest + 1);
  }

  if (countSPSStandard != countSPSTest) {
     cout << MESA_ERROR_TEXT
	  << " MPPS mismatch in PPS Relationship 0040 0270 " << endl
	  << " Standard data has " << countSPSStandard << " SPS items" << endl
	  << " Test data has " << countSPSTest << " SPS items" << endl;
     return 1;
  }

  DCM_TAG scheduledStepAttributeSeqTags[] = {
		0x00080050,		// Accession Number
		0x00401001,		// Requested Procedure ID
		0x00321060,		// Requested Procedure Description,
		0x00400009,		// Scheduled Procedure Step ID
		0x00400007,		// Scheduled Procedure Step Description
		0
	};

  // We should add a test for 0020 000D Study Instance UID.
  // They are supposed to pick a Study Instance UID different
  // from what is in the MWL.

  int idxStandard = 0;
  int idxTest = 0;
  for (idxStandard = 0; idxStandard < countSPSStandard; idxStandard++) {
    MDICOMWrapper* wStandard = mStandardData.getSequenceWrapper(0x00400270, idxStandard+1);
    if (wStandard == 0) {
      cout << MESA_ERROR_TEXT
	   << " MPPS mismatch in PPS Relationship 0040 0270 " << endl
	   << " expected to find a sequence item in Standard Data at index: " << idxStandard+1 << endl
	   << " but found no item" << endl;
      return 1;
    }
    sx = wStandard->getString(0x00400009);
    MDICOMWrapper* wTest = this->matchingScheduledStep(wStandard, sx);

    if (wTest == 0) {
      cout << MESA_ERROR_TEXT
	   << " MPPS mismatch in PPS Relationship 0040 0270 " << endl
	   << " expected to find a sequence item in test data for " << sx
	   << " but found no item" << endl;
      return 1;

    }

    for (idx = 0; scheduledStepAttributeSeqTags[idx] != 0; idx++) {
      MString t = wTest->getString(scheduledStepAttributeSeqTags[idx]);
      MString s = wStandard->getString(scheduledStepAttributeSeqTags[idx]);
      uGroup = DCM_TAG_GROUP(scheduledStepAttributeSeqTags[idx]);
      uElement = DCM_TAG_ELEMENT(scheduledStepAttributeSeqTags[idx]);
      if (t != s) {
	cout << MESA_ERROR_TEXT
	    << " MPPS mismatch in PPS Relationship 0040 0270 "
	   << setw(4) << setfill ('0') << hex << uGroup << " "
	   << setw(4) << setfill ('0') << hex << uElement
	   << "(" << s << ":"
	   << t << ")" << endl;

        rtnStatus = 1;
      } else if (mOutputLevel >= 3) {
	cout << MESA_CONTEXT_TEXT << " "
	   << setw(4) << setfill ('0') << hex << uGroup << " "
	   << setw(4) << setfill ('0') << hex << uElement
	   << " " << s << " " << t << endl;
      }
    }

    delete wStandard;
    delete wTest;
  }

#if 0
  for (idx = 0; scheduledStepAttributeSeqTags[idx] != 0; idx++) {
    MString t = mTestData.getString(0x00400270,
		scheduledStepAttributeSeqTags[idx]);
    MString s = mStandardData.getString(0x00400270,
		scheduledStepAttributeSeqTags[idx]);
    uGroup = DCM_TAG_GROUP(scheduledStepAttributeSeqTags[idx]);
    uElement = DCM_TAG_ELEMENT(scheduledStepAttributeSeqTags[idx]);
    if (t != s) {
      cout << "MPPS mismatch in PPS Relationship 0040 0270 "
	   << setw(4) << setfill ('0') << hex << uGroup << " "
	   << setw(4) << setfill ('0') << hex << uElement
	   << "(" << s << ":"
	   << t << ")" << endl;

      rtnStatus = 1;
    } else if (mOutputLevel >= 3) {
      cout << setw(4) << setfill ('0') << hex << uGroup << " "
	   << setw(4) << setfill ('0') << hex << uElement
	   << " " << s << " " << t << endl;
    }
  }
#endif

  return rtnStatus;
}

int
MLMPPSEvaluator::evalPPSInformationScheduledNCreate(const MString& dataSource)
{
  return 0;
}

int
MLMPPSEvaluator::evalPPSInformationScheduledNSet(const MString& dataSource)
{
  return 0;
}

int
MLMPPSEvaluator::evalPPSInformationScheduledFinal(const MString& dataSource)
{
  // See PS 3.4, Table F.7.2-1

  DCM_TAG tags[] = {	0x00400252,	// PPS Status
			0};
  U16 uGroup;
  U16 uElement;

  int rtnStatus = 0;
  int idx = 0;
  for (idx = 0; tags[idx] != 0; idx++) {
    MString t = mTestData.getString(tags[idx]);
    MString s = mStandardData.getString(tags[idx]);
    uGroup = DCM_TAG_GROUP(tags[idx]);
    uElement = DCM_TAG_ELEMENT(tags[idx]);
    if (t != s) {
      cout << MESA_ERROR_TEXT
	   << " MPPS mismatch in PPS Information "
	   << setw(4) << setfill ('0') << hex << uGroup << " "
	   << setw(4) << setfill ('0') << hex << uElement
	   << " (" << s << ":"
	   << t << ")" << endl;

      rtnStatus = 1;
    } else if (mOutputLevel >= 3) {
      cout << MESA_CONTEXT_TEXT << " "
	   << setw(4) << setfill ('0') << hex << uGroup << " "
	   << setw(4) << setfill ('0') << hex << uElement
	   << " " << s << " " << t << endl;
    }
  }

  DCM_TAG procedureCodeSeqTags[] = {
		0x00080100,		// Code Value
		0x00080102,		// Coding Scheme Designator
		0x00080104,		// Code Meaning
		0
	};

  int iStandard;
  int iTest;

  iStandard = 1;
  bool foundMatch = false;
  MString pCode = mStandardData.getString(0x00081032, 0x00080100, iStandard);
  while (pCode != "") {
    if (mOutputLevel >= 3) {
      cout << "CTX: Searching for code for (0008 1032) (0008 0100) " << pCode << endl;
    }
    foundMatch = false;
    iTest = 1;
    MString tCode;
    tCode = mTestData.getString(0x00081032, 0x00080100, iTest);
    while (foundMatch == false && tCode != "") {
      if (mOutputLevel >= 3) {
	cout << "CTX: Code in test message for (0008 1032) (0008 0100) " << tCode << endl;
      }
      if (pCode == tCode) {
	foundMatch = true;
	MString s;
	MString t;
	for (idx = 0; procedureCodeSeqTags[idx] != 0; idx++) {
	  t = mTestData.getString(0x00081032, procedureCodeSeqTags[idx], iTest);
	  s = mStandardData.getString(0x00081032, procedureCodeSeqTags[idx], iStandard);
	  uGroup = DCM_TAG_GROUP(procedureCodeSeqTags[idx]);
	  uElement = DCM_TAG_ELEMENT(procedureCodeSeqTags[idx]);
	  if (t != s) {
	    cout << MESA_ERROR_TEXT
		<< " MPPS mismatch in PPS Information 0008 1032  "
		<< setw(4) << setfill ('0') << hex << uGroup << " "
		<< setw(4) << setfill ('0') << hex << uElement
		<< " (" << s << ":"
		<< t << ")" << endl;

	    rtnStatus = 1;
	  } else if (mOutputLevel >= 3) {
	    cout << MESA_CONTEXT_TEXT << " "
		<< "0008 1032 "
		<< setw(4) << setfill ('0') << hex << uGroup << " "
		<< setw(4) << setfill ('0') << hex << uElement
		<< " " << s << " " << t << endl;
	  }
	}
      } else {
	iTest++;
	tCode = mTestData.getString(0x00081032, 0x00080100, iTest);
      }
    }
    if (!foundMatch) {
      cout << "Found no matching code for (0008 1032) (0008 0100) " << pCode << endl;
      rtnStatus = 1;
    }
    iStandard++;
    pCode = mStandardData.getString(0x00081032, 0x00080100, iStandard);
  }


  return rtnStatus;
}

int
MLMPPSEvaluator::evalPPSImageAcqScheduledNCreate(const MString& dataSource)
{
  return 0;
}

int
MLMPPSEvaluator::evalPPSImageAcqScheduledNSet(const MString& dataSource)
{
  return 0;
}

int
MLMPPSEvaluator::evalPPSImageAcqScheduledFinal(const MString& dataSource)
{
  // See PS 3.4, Table F.7.2-1

  DCM_TAG tags[] = {	0x00080060,	// Modality
			//0x00200010,	// Study ID
			0};
  U16 uGroup;
  U16 uElement;

  int rtnStatus = 0;
  int idx = 0;
  for (idx = 0; tags[idx] != 0; idx++) {
    MString t = mTestData.getString(tags[idx]);
    MString s = mStandardData.getString(tags[idx]);
    uGroup = DCM_TAG_GROUP(tags[idx]);
    uElement = DCM_TAG_ELEMENT(tags[idx]);
    if (t != s) {
      cout << MESA_ERROR_TEXT
	   << " MPPS mismatch in PPS ImageAcq "
	   << setw(4) << setfill ('0') << hex << uGroup << " "
	   << setw(4) << setfill ('0') << hex << uElement
	   << " (" << s << ":"
	   << t << ")" << endl;

      rtnStatus = 1;
    } else if (mOutputLevel >= 3) {
      cout << MESA_CONTEXT_TEXT << " "
	   << setw(4) << setfill ('0') << hex << uGroup << " "
	   << setw(4) << setfill ('0') << hex << uElement
	   << " " << s << " " << t << endl;
    }
  }

  DCM_TAG tag = 0x00200010;
  MString tStudyID = mTestData.getString(tag);
  MString sStudyID = mStandardData.getString(tag);
  uGroup = DCM_TAG_GROUP(tag);
  uElement = DCM_TAG_ELEMENT(tag);
  if (tStudyID != sStudyID) {
    cout << MESA_WARN_TEXT
	 << " This is a warning only; Study ID is a recommended value, not required" << endl;
    cout << MESA_WARN_TEXT
	 << " MPPS mismatch in PPS ImageAcq "
	 << setw(4) << setfill ('0') << hex << uGroup << " "
	 << setw(4) << setfill ('0') << hex << uElement
	 << " (" << sStudyID << ":"
	 << tStudyID << ")" << endl;

    //rtnStatus = 1;	// This is not a failure, just a warning
  } else if (mOutputLevel >= 3) {
    cout << MESA_CONTEXT_TEXT << " "
	 << setw(4) << setfill ('0') << hex << uGroup << " "
	 << setw(4) << setfill ('0') << hex << uElement
	 << " " << sStudyID << " " << tStudyID << endl;
  }

  if (this->mPerformedProtocolCodeFlag == false) {
    cout << MESA_CONTEXT_TEXT << " "
         << "You have decided not to evaluate the Performed Protocol Code Sequence"
         << endl;
    return rtnStatus;
  }


  DCM_TAG performedAICodeSeqTags[] = {
		0x00080100,		// Code Value
		0x00080102,		// Coding Scheme Designator
		0x00080104,		// Code Meaning
		0
	};

  for (idx = 0; performedAICodeSeqTags[idx] != 0; idx++) {
    MString t = mTestData.getString(0x00400260, performedAICodeSeqTags[idx]);
    MString s = mStandardData.getString(0x00400260, performedAICodeSeqTags[idx]);
    uGroup = DCM_TAG_GROUP(performedAICodeSeqTags[idx]);
    uElement = DCM_TAG_ELEMENT(performedAICodeSeqTags[idx]);
    if (t != s) {
      cout << MESA_ERROR_TEXT
	   << " MPPS mismatch in PPS ImageAcq 0040 0260  "
	   << setw(4) << setfill ('0') << hex << uGroup << " "
	   << setw(4) << setfill ('0') << hex << uElement
	   << " (" << s << ":"
	   << t << ")" << endl;

      rtnStatus = 1;
    } else if (mOutputLevel >= 3) {
      cout << MESA_CONTEXT_TEXT << " "
	   << "0040 0260 "
	   << setw(4) << setfill ('0') << hex << uGroup << " "
	   << setw(4) << setfill ('0') << hex << uElement
	   << " " << s << " " << t << endl;
    }
  }

  return rtnStatus;
}

int
MLMPPSEvaluator::evalPPSRelationshipUnscheduledNCreate(const MString& dataSource)
{
  return 0;
}

int
MLMPPSEvaluator::evalPPSRelationshipUnscheduledNSet(const MString& dataSource)
{
  return 0;
}

int
MLMPPSEvaluator::evalPPSRelationshipUnscheduledFinal(const MString& dataSource)
{
  // See PS 3.4, Table F.7.2-1

  DCM_TAG tags[] = {	0x00100010,	// Patient Name
			0x00100020,	// Patient ID
			0x00100030,	// Patient's Birth Date
			0x00100040,	// Patient's Sex
			0};
  U16 uGroup;
  U16 uElement;

  int rtnStatus = 0;
  int idx = 0;
  for (idx = 0; tags[idx] != 0; idx++) {
    MString t = mTestData.getString(tags[idx]);
    MString s = mStandardData.getString(tags[idx]);
    uGroup = DCM_TAG_GROUP(tags[idx]);
    uElement = DCM_TAG_ELEMENT(tags[idx]);
    if (t != s) {
      cout << MESA_ERROR_TEXT
	   << " MPPS mismatch in PPS Relationship "
	   << setw(4) << setfill ('0') << hex << uGroup << " "
	   << setw(4) << setfill ('0') << hex << uElement
	   << " (" << s << ":"
	   << t << ")" << endl;

      rtnStatus = 1;
    } else if (mOutputLevel >= 3) {
      cout << MESA_CONTEXT_TEXT << " "
	   << setw(4) << setfill ('0') << hex << uGroup << " "
	   << setw(4) << setfill ('0') << hex << uElement
	   << " " << s << " " << t << endl;
    }
  }

  // For the unscheduled case, these attributes should be of zero length.
  // That means, we can test for them (0-length strings).

  DCM_TAG scheduledStepAttributeSeqTags[] = {
		0x00080050,		// Accession Number
		0x00401001,		// Requested Procedure ID
		0x00321060,		// Requested Procedure Description,
		0x00400009,		// Scheduled Procedure Step ID
		0x00400007,		// Scheduled Procedure Step Description
		0
	};

  for (idx = 0; scheduledStepAttributeSeqTags[idx] != 0; idx++) {
    MString t = mTestData.getString(0x00400270, scheduledStepAttributeSeqTags[idx]);
    MString s = mStandardData.getString(0x00400270, scheduledStepAttributeSeqTags[idx]);
    uGroup = DCM_TAG_GROUP(scheduledStepAttributeSeqTags[idx]);
    uElement = DCM_TAG_ELEMENT(scheduledStepAttributeSeqTags[idx]);
    if (t != s) {
      cout << MESA_ERROR_TEXT 
	   << " MPPS mismatch in PPS Relationship 00400270 "
	   << setw(4) << setfill ('0') << hex << uGroup << " "
	   << setw(4) << setfill ('0') << hex << uElement
	   << " (" << s << ":"
	   << t << ")" << endl;

      rtnStatus = 1;
    } else if (mOutputLevel >= 3) {
      cout << MESA_CONTEXT_TEXT << " "
	   << "0040 0270 "
	   << setw(4) << setfill ('0') << hex << uGroup << " "
	   << setw(4) << setfill ('0') << hex << uElement
	   << " " << s << " " << t << endl;
    }
  }

  return rtnStatus;
}

MDICOMWrapper*
MLMPPSEvaluator::matchingScheduledStep(MDICOMWrapper* wStandard,
	const MString& scheduledStepID)
{
  int idx = 0;

  if (mOutputLevel >= 3) {
    cout << MESA_CONTEXT_TEXT
	 << " Searching for SPS with SPS ID: " << scheduledStepID << endl;
  }

  MString sx = mTestData.getString(0x00400270, 0x00400009, idx+1);
  while (sx != "") {
    if (mOutputLevel >= 3) {
      cout << MESA_CONTEXT_TEXT
	   << "  Test data SPS ID: " << sx << endl;
    }
    if (sx == scheduledStepID) {
      MDICOMWrapper* w = mTestData.getSequenceWrapper(0x00400270, idx+1);
      return w;
    }
    idx++;
    sx = mTestData.getString(0x00400270, 0x00400009, idx+1);
  }

  if (mOutputLevel >= 3) {
    cout << MESA_CONTEXT_TEXT
	 << " Found no matching SPS for SPS ID: " << scheduledStepID << endl;
  }

  return 0;
}

int
MLMPPSEvaluator::countSequenceItems(MDICOMWrapper& w, DCM_TAG seqTag,
	DCM_TAG attrTag)
{
  int count = 0;

  MString s = w.getString(seqTag, attrTag, count+1);
  while (s != "") {
    count++;
    s = w.getString(seqTag, attrTag, count+1);
  }
  return count;
}

MDICOMWrapper*
MLMPPSEvaluator::findMatchingSequenceItem(
	const MString& keyString,
	MDICOMWrapper& w,
        DCM_TAG seqTag, DCM_TAG itemTag)
{
  int idx = 1;

  MString s = w.getString(seqTag, itemTag, idx);
  while (s != "") {
    //cout << "   ---" << s << "---" << endl;
    if (s == keyString) {
      MDICOMWrapper* rtnWrapper = w.getSequenceWrapper(seqTag, idx);
      return rtnWrapper;
    }
    idx++;
    s = w.getString(seqTag, itemTag, idx);
  }

  return 0;
}
