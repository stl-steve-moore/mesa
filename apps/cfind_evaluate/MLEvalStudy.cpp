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
#include "MLEvalStudy.hpp"
#include "MDICOMWrapper.hpp"
#include "MPatientStudy.hpp"
#include "MSeries.hpp"
#include "MSOPInstance.hpp"
#include "MDICOMDomainXlate.hpp"

#include <iomanip>

#if 0
MLEvalStudy::MLEvalStudy()
{
}
#endif

MLEvalStudy::MLEvalStudy(const MLEvalStudy& cpy) :
  MLCFindEval(cpy)
{
}

MLEvalStudy::~MLEvalStudy()
{
}

void
MLEvalStudy::printOn(ostream& s) const
{
  s << "MLEvalStudy";
}

void
MLEvalStudy::streamIn(istream& s)
{
  //s >> this->member;
}

// Non-boiler plate methods to follow


MLEvalStudy::MLEvalStudy(MDICOMWrapper& testData) :
  MLCFindEval(testData)
{
}

int
MLEvalStudy::run()
{
  MString level = mTestData.getString(DCM_IDQUERYLEVEL);

  if (level == "PATIENT")
    return 1;
  else if (level == "STUDY")
    return this->evalStudyLevel();
  else if (level == "SERIES")
    return this->evalSeriesLevel();
  else if (level == "IMAGE")
    return this->evalInstanceLevel();
  else
    return 1;
}

int
MLEvalStudy::evalStudyLevel()
{
  TAG_LABEL seriesAttributes[] = {
	{ 0x00080060, "Modality" },
	{ 0x00200011, "Series Number"},
	{ 0x0020000E, "Series Instance UID"},
	{ 0x00201209, "Number of Series Related Instance"},
	{ 0x00400253, "Performed Procedure Step ID"},
	{ 0x00081111, "Referenced Study Component Sequence"},
	{ 0x00400275, "Request Attribute Sequence"},
	{ 0x00400244, "Performed Procedure Step Start Date"},
	{ 0x00400245, "Performed Procedure Step Start Time"}
  };

  int rtnValue = 0;

  rtnValue |= this->testForUnwantedKeys("SERIES",
			seriesAttributes, (int)DIM_OF(seriesAttributes));

  TAG_LABEL instanceLevelAttributes[] = {
	{ 0x00200013, "Instance Number" },
	{ 0x00200022, "Overlay Number" },
	{ 0x00200024, "Curve Number" },
	{ 0x00200026, "LUT Number" },
	{ 0x00080018, "SOP Instance UID"},
	{ 0x00080016, "SOP Class UID"},
	{ 0x00280010, "Rows"},
	{ 0x00280011, "Columns"},
	{ 0x00280100, "Bits Allocated"},
	{ 0x00280008, "Number of Frames"}
  };

  rtnValue |= this->testForUnwantedKeys("SOP INSTANCE",
			instanceLevelAttributes,
			(int)DIM_OF(instanceLevelAttributes));

  return rtnValue;
}

int
MLEvalStudy::evalSeriesLevel()
{
  int rtnValue = 0;

  if (this->testForUniqueKeyStudyLevel() != 0)
    rtnValue = 1;

  TAG_LABEL instanceLevelAttributes[] = {
	{ 0x00200013, "Instance Number" },
	{ 0x00200022, "Overlay Number" },
	{ 0x00200024, "Curve Number" },
	{ 0x00200026, "LUT Number" },
	{ 0x00080018, "SOP Instance UID"},
	{ 0x00080016, "SOP Class UID"},
	{ 0x00280010, "Rows"},
	{ 0x00280011, "Columns"},
	{ 0x00280100, "Bits Allocated"},
	{ 0x00280008, "Number of Frames"}
  };

  rtnValue |= this->testForUnwantedKeys("SOP INSTANCE",
			instanceLevelAttributes,
			(int)DIM_OF(instanceLevelAttributes));

  return rtnValue;
}

int
MLEvalStudy::evalInstanceLevel()
{
  int rtnStatus = 0;

  if (this->testForUniqueKeyStudyLevel() != 0)
    rtnStatus = 1;

  if (this->testForUniqueKeySeriesLevel() != 0)
    rtnStatus = 1;

  if (this->testInstanceLevelKeys() != 0)
    rtnStatus = 1;

  return rtnStatus;
}

int
MLEvalStudy::testForUniqueKeyStudyLevel()
{
  if (mVerbose) {
    cout << "Testing Study Level attributes of C-Find." << endl;
    cout << "Expect to find only Study Instance UID." << endl;
  }

  int rtnStatus = 0;

  MString s = mTestData.getString(DCM_RELSTUDYINSTANCEUID);
  if (s == "") {
    cout << "Study level unique key (Study Instance UID) is of 0-length." << endl;
    rtnStatus = 1;
  } else if (mVerbose) {
    cout << "Study Instance UID found and has value: " << s << endl;
  }

  DCM_TAG tags[] = {
	0x00080020,		// Study Date
	0x00080030,		// Study Time
	0x00080050,		// Accession Number
	0x00100010,		// Patient Name
	0x00100020,		// Patient ID
	0x00200010,		// Study ID
	0x00080061,		// Modalities in Study
	0x00080090,		// Referring Physician's Name
	0x00081030,		// Study Description
	0x00081032,		// Procedure Code Sequence
	0x00081060,		// Name of Phys Reading Study
	0x00081110,		// Referenced Study Sequence
	0x00081120,		// Referenced Patient Sequence
	0x00100030,		// Patient's Birth Date
	0x00100032,		// Patient's Birth Time
	0x00100040,		// Patient's Sex
	0x00101000,		// Other Patient IDs
	0x00101001,		// Other Patient Names
	0x00101010,		// Patient's Age
	0x00101020,		// Patient's Size
	0x00101030,		// Patient's Weight
	0x00102160,		// Ethnic Group,
	0x00102180,		// Occupation
	0x001021B0,		// Additional Patient History
	0x00104000,		// Patient Coments
	0x00201070,		// Other Study Numbers
	0x00201200,		// Number of Patient Related Studies
	0x00201202,		// Number of Patient Related Series
	0x00201204,		// Number of Patient Related Instances
	0x00201206,		// Number of Study Related Series
	0x00201208,		// Number of Study Related Instances
	0
  };

  int idx = 0;
  for (idx = 0; tags[idx] != 0; idx++) {
    DCM_TAG t = tags[idx];

    if (mTestData.attributePresent(t)) {
      MString v  = mTestData.getString(t);
      cout << "Study level attribute: "
	   << hex << setw(8) << setfill('0') << t
	   << dec
	   << " has value <" << v << ">"
	   << " and should not be present." << endl;
      rtnStatus = 1;
    }
  }
  return rtnStatus;
}

int
MLEvalStudy::testForUniqueKeySeriesLevel()
{
  if (mVerbose) {
    cout << "Testing Series Level attributes of C-Find." << endl;
    cout << "Expect to find only Series Instance UID." << endl;
  }

  int rtnStatus = 0;

  MString s = mTestData.getString(DCM_RELSERIESINSTANCEUID);
  if (s == "") {
    cout << "Series level unique key (Series Instance UID) is of 0-length." << endl;
    rtnStatus = 1;
  } else if (mVerbose) {
    cout << "Series UID found and has value: " << s << endl;
  }

  DCM_TAG tags[] = {
	0x00080060,		// Modality
	0x00200011,		// Series Number
	0x00201209,		// Number of Series Related Instances
	0x00400253,		// Performed Procedure Step ID
	0x00081111,		// Referenced Study Component Sequence
	0x00400275,		// Request Attribute Sequence
	0x00400244,		// Performed Procedure Step Start Date
	0x00400245,		// Performed Procedure Step Start Time
	0
  };

  int idx = 0;
  for (idx = 0; tags[idx] != 0; idx++) {
    DCM_TAG t = tags[idx];

    if (mTestData.attributePresent(t)) {
      MString v  = mTestData.getString(t);
      cout << "Series level attribute: "
	   << hex << setw(8) << setfill('0') << t
	   << dec
	   << " has value <" << v << ">"
	   << " and should not be present." << endl;
      rtnStatus = 1;
    }
  }
  return rtnStatus;
}

int
MLEvalStudy::testInstanceLevelKeys()
{
  if (mVerbose) {
    cout << "Testing Instance Level attributes of C-Find." << endl;
    cout << "Expect to find SOP Instance UID and possibly other keys." << endl;
  }

  int rtnStatus = 0;

  if (!mTestData.attributePresent(DCM_IDSOPINSTANCEUID)) {
    cout << "You need to provide a query or return key for (0008 0018) SOP Instance UID."
	 << endl;
    rtnStatus = 1;
  }


  return rtnStatus;
}

int
MLEvalStudy::testForUnwantedKeys(const MString& level,
			TAG_LABEL* tagLabel, int length)
{
  if (mVerbose) {
    cout << "Testing for unwanted keys at the "
	 << level << " level" << endl;
  }

  int idx;
  int rtnValue = 0;

  for (idx = 0; idx < length; idx++) {
    U16 uGroup = DCM_TAG_GROUP(tagLabel[idx].tag);
    U16 uElement = DCM_TAG_ELEMENT(tagLabel[idx].tag);
    if (mVerbose)
      cout << " Looking for attribute "
	   << setw(4) << setfill('0') << hex << uGroup << " "
	   << setw(4) << setfill('0') << hex << uElement << " "
	   << tagLabel[idx].label << endl;

    if (mTestData.attributePresent(tagLabel[idx].tag)) {
      cout << " Found unwanted attribute at "
	   << level << " level "
	   << setw(4) << setfill('0') << hex << uGroup << " "
	   << setw(4) << setfill('0') << hex << uElement << " "
	   << tagLabel[idx].label << endl;
      rtnValue = 1;
    }
  }
  return rtnValue;
} 
