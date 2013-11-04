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
#include "MEval.hpp"
#include "MLEvalGroup3.hpp"
#include "MDICOMWrapper.hpp"

#include <iomanip>

#if 0
MLEvalGroup3::MLEvalGroup3()
{
}
#endif

MLEvalGroup3::MLEvalGroup3(const MLEvalGroup3& cpy) :
  MLMPPSEvaluator(cpy)
{
}

MLEvalGroup3::~MLEvalGroup3()
{
}

void
MLEvalGroup3::printOn(ostream& s) const
{
  s << "MLEvalGroup3";
}

void
MLEvalGroup3::streamIn(istream& s)
{
  //s >> this->member;
}

// Non-boiler plate methods to follow


MLEvalGroup3::MLEvalGroup3(MDICOMWrapper& testData,
			     MDICOMWrapper& standardData) :
  MLMPPSEvaluator(testData, standardData)
{
}

int
MLEvalGroup3::run(const MString& dataSource, const MString& operation)
{

  int status = 0;
  int finalStatus = 0;

  status = this->evalPPSRelationshipGroupCase(dataSource, operation);
  if (status != 0)
    finalStatus = status;

  status = this->evalPPSInformationScheduled(dataSource, operation);
  if (status != 0)
    finalStatus = status;

  status = this->evalPPSImageAcqScheduled(dataSource, operation);
  if (status != 0)
    finalStatus = status;

  return finalStatus;
}


// private methods below

int
MLEvalGroup3::evalPPSImageAcqScheduledFinal(const MString& dataSource)
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
      cout << setw(4) << setfill ('0') << hex << uGroup << " "
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

    //rtnStatus = 1;    // This is not a failure, just a warning
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

  int performedAICountTest = this->countSequenceItems(mTestData,
			0x00400260, 0x00080100);
  int performedAICountStandard = this->countSequenceItems(mStandardData,
			0x00400260, 0x00080100);


  if (performedAICountTest != performedAICountStandard) {
    cout << "MPPS mismatch in PPS ImageAcq 0040 0260  " << endl
	 << " Found " << performedAICountStandard
	 << " items in Performed Protocol Code Seq (Standard Data)" << endl
	 << " Found " << performedAICountTest
	 << " items in Performed Protocol Code Seq (Test Data)" << endl;
    rtnStatus = 1;
  }

  DCM_TAG performedAICodeSeqTags[] = {
		0x00080100,		// Code Value
		0x00080102,		// Coding Scheme Designator
		0x00080104,		// Code Meaning
		0
	};

  int itemIndex = 0;
  for (itemIndex = 0; itemIndex < performedAICountStandard; itemIndex++) {
    MDICOMWrapper* wStandard = mStandardData.getSequenceWrapper(0x00400260, itemIndex+1);
    MString sx = wStandard->getString(0x00080100);
    if (mOutputLevel >= 3) {
      cout << "MPPS 0040 0260 looking for code: " << sx << endl;
    }
    MDICOMWrapper* wTest = this->findMatchingSequenceItem(
	sx, mTestData, 0x00400260, 0x00080100);
    if (wTest == 0) {
      cout << MESA_ERROR_TEXT
	   << " MPPS mismatch in PPS ImageAcq 0040 0260  " << endl
	   << " No matching Code Item to match item in Standard Data "
	   << "<" << sx << "<" << endl;
      rtnStatus = 1;
    } else {
      for (idx = 0; performedAICodeSeqTags[idx] != 0; idx++) {
	MString t = wTest->getString(performedAICodeSeqTags[idx]);
	MString s = wStandard->getString(performedAICodeSeqTags[idx]);
	uGroup = DCM_TAG_GROUP(performedAICodeSeqTags[idx]);
	uElement = DCM_TAG_ELEMENT(performedAICodeSeqTags[idx]);
	if (t != s) {
	  cout  << MESA_ERROR_TEXT
		<< " MPPS mismatch in PPS ImageAcq 0040 0260  "
		<< setw(4) << setfill ('0') << hex << uGroup << " "
		<< setw(4) << setfill ('0') << hex << uElement
		<< " (" << s << ":"
		<< t << ")" << endl;

	  rtnStatus = 1;
	} else if (mOutputLevel >= 3) {
	  cout << "0040 0260 "
		<< setw(4) << setfill ('0') << hex << uGroup << " "
		<< setw(4) << setfill ('0') << hex << uElement
		<< " " << s << " " << t << endl;
	}
      }
    }

    delete wTest;
    delete wStandard;
  }

#if 0
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
      cout << "0040 0260 "
	   << setw(4) << setfill ('0') << hex << uGroup << " "
	   << setw(4) << setfill ('0') << hex << uElement
	   << " " << s << " " << t << endl;
    }
  }

  cout << "XXXXX" << endl;
#endif

  return rtnStatus;
}
