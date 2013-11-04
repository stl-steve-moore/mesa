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

static char rcsid[] = "$Revision: 1.4 $ $RCSfile: cfind_gpsps_evaluate.cpp,v $";

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
//#ifdef GCCSUNOS
//#include <sys/types.h>
//#endif
#include "MESA.hpp"
#include "ctn_api.h"
#include "MDICOMWrapper.hpp"
#include "MDICOMDomainXlate.hpp"
#include "MInputInfo.hpp"
#include <iostream>
#include <iomanip>

bool attributePresent(MDICOMWrapper& w, DCM_TAG tag, int level)
{
  if (level >= 3) {
    U16 g = DCM_TAG_GROUP(tag);
    U16 e = DCM_TAG_ELEMENT(tag);

    cout << "CTX: Test for presence of attribute: "
	 << setw(4) << setfill('0') << hex << g << " "
	 << setw(4) << setfill('0') << e << " "<< dec;
  }

  MString s = w.getString(tag);
  if (level >= 3) {
    cout << "<" << s << ">" << endl;
  }

  if (s == "") {
    U16 g = DCM_TAG_GROUP(tag);
    U16 e = DCM_TAG_ELEMENT(tag);
    cout << "ERR: Attribute "
	 << hex
	 << setw(4) << setfill('0') << g << " "
	 << setw(4) << setfill('0') << e << dec
	 << " not present or 0-length." << endl;
    return false;

  } else {
    return true;
  }
}

bool attributePresent(MDICOMWrapper& w, DCM_TAG seqTag, DCM_TAG tag, int level)
{
  if (level >= 3) {
    U16 seqG = DCM_TAG_GROUP(seqTag);
    U16 seqE = DCM_TAG_ELEMENT(seqTag);
    U16 g = DCM_TAG_GROUP(tag);
    U16 e = DCM_TAG_ELEMENT(tag);

    cout << "CTX: Test for presence of attribute: "
	 << hex
	 << setw(4) << setfill('0') << seqG << " "
	 << setw(4) << setfill('0') << seqE << " "
	 << setw(4) << setfill('0') << g << " "
	 << setw(4) << setfill('0') << e << " "
	 << dec;
  }

  MString s = w.getString(seqTag, tag);
  if (level >= 3) {
    cout << "<" << s << ">" << endl;
  }
  if (s == "") {
    U16 seqG = DCM_TAG_GROUP(seqTag);
    U16 seqE = DCM_TAG_ELEMENT(seqTag);
    U16 g = DCM_TAG_GROUP(tag);
    U16 e = DCM_TAG_ELEMENT(tag);
    cout << "ERR: Attribute "
	 << hex
	 << setw(4) << setfill('0') << seqG << " "
	 << setw(4) << setfill('0') << seqE << " "
	 << setw(4) << setfill('0') << g << " "
	 << setw(4) << setfill('0') << e
	 << dec
	 << " not present or 0-length." << endl;
    return false;
  } else {
    return true;
  }
}

bool attributeMatch(MDICOMWrapper& wTest, MDICOMWrapper& wStd,
			DCM_TAG tag, int level)
{
  if (level >= 3) {
    U16 g = DCM_TAG_GROUP(tag);
    U16 e = DCM_TAG_ELEMENT(tag);

    cout << "CTX: Test for equivalence of attribute: "
	 << hex
	 << setw(4) << setfill('0') << g << " "
	 << setw(4) << setfill('0') << e << " "
	 << dec;
  }

  MString sTest = wTest.getString(tag);
  MString sStd = wStd.getString(tag);

  if (level >= 3) {
    cout << "<" << sTest << ">"
	 << " <" << sStd << ">"
	 << endl;
  }
  if (sTest != sStd) {
    U16 g = DCM_TAG_GROUP(tag);
    U16 e = DCM_TAG_ELEMENT(tag);
    cout << "ERR: Attribute "
	 << hex
	 << setw(4) << setfill('0') << g << " "
	 << setw(4) << setfill('0') << e
	 << dec
	 << " does not match <test> <std>." << endl;
    cout << "ERR: <" << sTest << ">"
	 << " <" << sStd << ">"
	 << endl;
    return false;
  } else {
    return true;
  }
}

bool attributeMatch(MString& sTest, MString& sStd, DCM_TAG tag,
			MString tagDescription, int level)
{
  if (level >= 3) {
    U16 g = DCM_TAG_GROUP(tag);
    U16 e = DCM_TAG_ELEMENT(tag);

    cout << "CTX: Test for equivalence of attribute: "
	 << hex
	 << setw(4) << setfill('0') << g << " "
	 << setw(4) << setfill('0') << e << " "
	 << dec;
    cout << " (" << tagDescription << ")";
  }

  if (level >= 3) {
    cout << "<" << sTest << ">"
	 << " <" << sStd << ">"
	 << endl;
  }
  if (sTest != sStd) {
    U16 g = DCM_TAG_GROUP(tag);
    U16 e = DCM_TAG_ELEMENT(tag);
    cout << "ERR: Attribute "
	 << hex
	 << setw(4) << setfill('0') << g << " "
	 << setw(4) << setfill('0') << e
	 << dec
	 << " does not match <test> <std>." << endl;
    cout << "ERR: <" << sTest << ">"
	 << " <" << sStd << ">"
	 << endl;
    return false;
  } else {
    return true;
  }
}

int hasMatch(MString& sStd, MStringVector& tstVec, DCM_TAG seqTag,
			MString seqTagDescription, DCM_TAG tag, int level)
{
  MString sTest = "";
  if (level >= 3) {
    U16 g = DCM_TAG_GROUP(seqTag);
    U16 e = DCM_TAG_ELEMENT(seqTag);

    cout << "CTX: Test for equivalence of attribute: "
	 << hex
	 << setw(4) << setfill('0') << g << " "
	 << setw(4) << setfill('0') << e << " "
	 << dec;
    cout << " (" << seqTagDescription << ")" << endl;
  }

  MStringVector::const_iterator it = tstVec.begin();
  for( int i = 0; it != tstVec.end(); it++, i++) {
    MString sTest = *it;
    if (sTest == sStd) {
      if (level >= 3) {
        cout << "CTX:  test: <" << sTest << ">"
	     << " std: <" << sStd << ">"
	     << endl;
      }
      return i;
    }
  }
  U16 g = DCM_TAG_GROUP(tag);
  U16 e = DCM_TAG_ELEMENT(tag);
  cout << "ERR: atch not found for Attribute "
       << hex
       << setw(4) << setfill('0') << g << " "
       << setw(4) << setfill('0') << e
       << dec
       << " does not match <std>." << endl;
  cout << "ERR: <" << sStd << ">"
       << endl;
  return -1;
}

bool hasMatch(MInputInfo& std_ii, MInputInfoVector& tst_iiv, int level)
{
  MInputInfoVector::const_iterator it = tst_iiv.begin();
  for( int i = 0; it != tst_iiv.end(); it++, i++) {
    MInputInfo tst_ii = *it;
    if( std_ii.equals(tst_ii)) {
      return true;
    }
  }
  return false;
}

void dumpInputInfo( MInputInfo& ii) {
  cout << "CTX:  Study Instance UID (0020,000D): " 
       << ii.studyInstanceUID() << endl;;
  cout << "CTX:  Series Instance UID (0008,1115) (0020,000E): " 
       << ii.seriesInstanceUID() << endl;;
  cout << "CTX:  Retrieve AE Title (0008,1115) (0008,0054): " 
       << ii.retrieveAETitle() << endl;;
  cout << "CTX:  Referenced SOP class UID (0008,1199) (0008,1150): " 
       << ii.SOPClassUID() << endl;;
  cout << "CTX:  Referenced SOP instance UID (0008,1199) (0008,1155): " 
       << ii.SOPInstanceUID() << endl;;
}

bool matchInputInfo(MDICOMWrapper& wTst, MDICOMWrapper& wStd,
		               int level)
{
  MDICOMDomainXlate xlate;
  MInputInfoVector tst_iiv, std_iiv;
  xlate.translateDICOM(wTst, tst_iiv);
  xlate.translateDICOM(wStd, std_iiv);

  cout << "CTX: Test for equivalence of Input Info Sequence Items (0040,4021)." << endl;
  MInputInfoVector::const_iterator it = std_iiv.begin();
  for( int i = 0; it != std_iiv.end(); it++, i++) {
    MInputInfo stdII = *it;
    if( hasMatch( stdII, tst_iiv, level) ) {
      if(level >= 3) {
        cout << "CTX: Successfully matched the Input Info Sequence Item:" << endl;
	dumpInputInfo( stdII);
      }
      continue;
    }
    else {
      cout << "ERR: Failed to find match for Input Info Sequence Item (0040,4021)" << endl;
      dumpInputInfo( stdII);
      return false;
    }
  }
  if(level >= 3) {
    cout << "CTX: The system under test has the following Input Info Sequence Items:" << endl;
    MInputInfoVector::const_iterator tst_it = tst_iiv.begin();
    for( int i = 0; tst_it != tst_iiv.end(); tst_it++, i++) {
      MInputInfo tstII = *tst_it;
      cout << "CTX:  Item " << i+1 << endl;
      dumpInputInfo( tstII);
    }
  }
  return true;
}

bool matchSchedStationNames(MDICOMWrapper& wTest, MDICOMWrapper& wStd,
		               int level)
{
  MStringVector testCodeValues = wTest.getStrings(0x00404025,0x00080100);
  MStringVector stdCodeValues  = wStd.getStrings(0x00404025,0x00080100);
  MString tstCodeDes;
  MString stdCodeDes;
  MString tstCodeMeaning;
  MString stdCodeMeaning;
  int matchIndx;

  cout << "CTX: Test Scheduled Station Name Code Sequence." << endl;

  MStringVector::const_iterator it = stdCodeValues.begin();
  for( int i = 0; it != stdCodeValues.end(); it++, i++) {
    MString stdValue = *it;
    matchIndx = hasMatch( stdValue, testCodeValues, 0x00404025, 
		    "Scheduled Station Name Code Sequence",0x00080100,level);
    if( matchIndx != -1) {
      tstCodeDes = wTest.getString(0x00404025,0x00080102,matchIndx+1);
      stdCodeDes = wStd.getString(0x00404025,0x00080102,i+1);
      if( !attributeMatch(tstCodeDes,stdCodeDes,0x00080102,"Code Designator",
			      level)) {
        return false;
      }
      tstCodeMeaning = wTest.getString(0x00404025,0x00080104,matchIndx+1);
      stdCodeMeaning = wStd.getString(0x00404025,0x00080104,i+1);
      if( !attributeMatch(tstCodeMeaning,stdCodeMeaning,0x00080104,
			      "Code Meaning", level)) {
        return false;
      }
    }
    else {
      return false;
    }
  }
  return true;
}

// This version currently ignores the Human Performer Code Sequence
// that may be in the Scheduled Human Performers Seq.
bool matchSchedHumanPerformers(MDICOMWrapper& wTest, MDICOMWrapper& wStd,
		               int level)
{
  MStringVector testHPNames = wTest.getStrings(0x00404034,0x00404037);
  MStringVector stdHPNames  = wStd.getStrings(0x00404034,0x00404037);
  MString tstCodeDes;
  MString stdCodeDes;
  MString tstCodeMeaning;
  MString stdCodeMeaning;
  int matchIndx;

  cout << "CTX: Test Scheduled Human Performers Sequence." << endl;

  MStringVector::const_iterator it = stdHPNames.begin();
  for( int i = 0; it != stdHPNames.end(); it++, i++) {
    MString stdName = *it;
    matchIndx = hasMatch(stdName, testHPNames, 0x00404034, 
		    "Scheduled Human Performers Sequence",0x00404037,level);
    if( matchIndx == -1) {
      return false;
    }
  }
  return true;
}

bool attributeMatch(MDICOMWrapper& wTest, MDICOMWrapper& wStd,
			DCM_TAG seqTag, DCM_TAG tag, int level)
{
  if (level >= 3) {
    U16 seqG = DCM_TAG_GROUP(seqTag);
    U16 seqE = DCM_TAG_ELEMENT(seqTag);
    U16 g = DCM_TAG_GROUP(tag);
    U16 e = DCM_TAG_ELEMENT(tag);

    cout << "CTX: Test for equivalence of attribute: "
	 << hex
	 << setw(4) << setfill('0') << seqG << " "
	 << setw(4) << setfill('0') << seqE << " "
	 << setw(4) << setfill('0') << g << " "
	 << setw(4) << setfill('0') << e << " "
	 << dec;
  }

  MString sTest = wTest.getString(seqTag, tag);
  MString sStd = wStd.getString(seqTag, tag);

  if (level >= 3) {
    cout << "<" << sTest << ">"
	 << " <" << sStd << ">"
	 << endl;
  }
  if (sTest != sStd) {
    U16 seqG = DCM_TAG_GROUP(seqTag);
    U16 seqE = DCM_TAG_ELEMENT(seqTag);
    U16 g = DCM_TAG_GROUP(tag);
    U16 e = DCM_TAG_ELEMENT(tag);
    cout << "ERR: Attribute "
	 << hex
	 << setw(4) << setfill('0') << seqG << " "
	 << setw(4) << setfill('0') << seqE << " "
	 << setw(4) << setfill('0') << g << " "
	 << setw(4) << setfill('0') << e
	 << dec
	 << " does not match <test> <std>." << endl;
    cout << "ERR: <" << sTest << ">"
	 << " <" << sStd << ">"
	 << endl;
    return false;
  } else {
    return true;
  }
}

static int
evaluateScheduledProcedureStep(MDICOMWrapper& wrapperTest,
				MDICOMWrapper& wrapperStd, int level)
{
  if (level >= 3)
    cout << "CTX: Test Scheduled Procedure Step" << endl;

  int rtnStatus = 0;
  DCM_TAG t1[] = {
	0x00400001,	// Scheduled Station AE title
	0x00080060	// Modality
  };

  int idx = 0;
  for (idx = 0; idx < (int)DIM_OF(t1); idx++) {
    if (!attributeMatch(wrapperTest, wrapperStd,
			0x00400100, t1[idx], level)) {
      rtnStatus = 1;
    }
  }

  DCM_TAG t2[] = {
	0x00400002,	// Scheduled Procedure Step Start Date
	0x00400003,	// Scheduled Procedure Step Start Time
	// 0x00400006,	// Scheduled Performing Physician's Name
	0x00400009,	// Scheduled Procedure Step ID
	0x00400007,	// Scheduled Procedure Step Description
  };
  for (idx = 0; idx < (int)DIM_OF(t2); idx++) {
    if (!attributePresent(wrapperTest, 0x00400100, t2[idx], level)) {
      rtnStatus = 1;
    }
  }

  DCM_OBJECT* objTest = wrapperTest.getNativeObject();
  DCM_OBJECT* objStd  = wrapperTest.getNativeObject();

  LST_HEAD* lstTest = 0;
  LST_HEAD* lstStd = 0;
  CONDITION cond;

  cond = ::DCM_GetSequenceList(&objTest, 0x00400100, &lstTest);
  cond = ::DCM_GetSequenceList(&objStd,  0x00400100, &lstStd);

  DCM_SEQUENCE_ITEM* itemTest = (DCM_SEQUENCE_ITEM*)::LST_Head(&lstTest);
  DCM_SEQUENCE_ITEM* itemStd  = (DCM_SEQUENCE_ITEM*)::LST_Head(&lstStd );

  MDICOMWrapper xTest(itemTest->object);
  MDICOMWrapper  xStd(itemStd->object);

  DCM_TAG t3[] = {
	0x00080100,		// Code Value
	0x00080102,		// Coding Scheme Designator
	0x00080104,		// Code Meaning
  };
  for (idx = 0; idx < (int)DIM_OF(t3); idx++) {
    if (!attributeMatch(xTest, xStd,
			0x00400008, t3[idx], level)) {
      rtnStatus = 1;
    }
  }

  return rtnStatus;
}

static int
evaluateRequestedProcedure(MDICOMWrapper& wrapperTest,
			MDICOMWrapper& wrapperStd,
			int level)
{
  if (level >= 3)
    cout << "Test Requested Procedure" << endl;

  int rtnStatus = 0;
  DCM_TAG t1[] = {
	0x00321060,	// Requested Procedure Description
	0x00401001,	// Requested Procedure ID
	0x0020000D	// Study Instance UID
  };

  int idx = 0;
  for (idx = 0; idx < (int)DIM_OF(t1); idx++) {
    if (!attributePresent(wrapperTest, t1[idx], level)) {
      rtnStatus = 1;
    }
  }

  DCM_TAG t2[] = {	// Requested Procedure Code Sequence
	0x00080100,	// Code Value
	0x00080102,	// Coding Scheme Designator
	0x00080104	// Code Meaning
  };

  for (idx = 0; idx < (int)DIM_OF(t2); idx++) {
    if (!attributeMatch(wrapperTest, wrapperStd,
			0x00321064, t2[idx], level)) {
      rtnStatus = 1;
    }
  }

  // Referenced Study Sequence: Referenced SOP Class UID
  if (!attributeMatch(wrapperTest, wrapperStd,
			0x00081110, 0x00081150, level)) {
    rtnStatus = 1;
  }

  // Referenced Study Sequence: Referenced SOP Instance UID
  if (!attributePresent(wrapperTest,
			0x00081110, 0x00081155, level)) {
    rtnStatus = 1;
  }

  return rtnStatus;
}

static int
evaluateImagingServiceRequest(MDICOMWrapper& wrapperTest,
			MDICOMWrapper& wrapperStd,
			int level)
{
  if (level >= 3)
    cout << "CTX: Test Imaging Service Request" << endl;

  int rtnStatus = 0;
  DCM_TAG t1[] = {
	0x00080050	// Accession Number
  };

  int idx = 0;
  for (idx = 0; idx < (int)DIM_OF(t1); idx++) {
    if (!attributePresent(wrapperTest, t1[idx], level)) {
      rtnStatus = 1;
    }
  }

  DCM_TAG t2[] = {
	0x00321032,	// Requesting Physician
	0x00080090	// Referring Physician's Name
  };

  for (idx = 0; idx < (int)DIM_OF(t2); idx++) {
    if (!attributeMatch(wrapperTest, wrapperStd, t2[idx], level)) {
      rtnStatus = 1;
    }
  }

  return 0;
}

static int
evaluateVisitIdentification(MDICOMWrapper& wrapperTest,
			MDICOMWrapper& wrapperStd,
			int level)
{
  if (level >= 3)
    cout << "CTX: Test Visit Identification" << endl;

  int rtnStatus = 0;

  // Admission ID
  if (!attributeMatch(wrapperTest, wrapperStd, 0x00380100, level))
    rtnStatus = 1;

  return rtnStatus;
}

static int
evaluateVisitStatus(MDICOMWrapper& wrapperTest, MDICOMWrapper& wrapperStd,
			int level)
{
  if (level >= 3)
    cout << "CTX: Test Visit Status" << endl;

  int rtnStatus = 0;

  // Current Patient Location
  if (!attributeMatch(wrapperTest, wrapperStd, 0x00380300, level))
    rtnStatus = 1;

  return rtnStatus;
}

static int
evaluateVisitRelationship(MDICOMWrapper& wrapperTest, MDICOMWrapper& wrapperStd,
			int level)
{
  if (level >= 3)
    cout << "CTX: Test Visit Relationship" << endl;

  int rtnStatus = 0;

  // Referenced Patient Sequence: Referenced SOP Class UID
#if 0
  if (!attributeMatch(wrapperTest, wrapperStd,
		0x00081120, 0x00081150, level)) {
    rtnStatus = 1;
  }

  // Referenced Patient Sequence: Referenced SOP Instance UID
  if (!attributePresent(wrapperTest,
		0x00081120, 0x00081155, level)) {
    rtnStatus = 1;
  }
#endif

  return rtnStatus;
}

static int
evaluatePatientIdentification(MDICOMWrapper& wrapperTest,
			MDICOMWrapper& wrapperStd, int level)
{
  if (level >= 3)
    cout << "Test Patient Identification" << endl;

  int rtnStatus = 0;
  DCM_TAG t1[] = {
	0x00100010,	// Patient Name
	0x00100020	// Patient ID
  };

  int idx = 0;
  for (idx = 0; idx < (int)DIM_OF(t1); idx++) {
    if (!attributeMatch(wrapperTest, wrapperStd, t1[idx], level)) {
      rtnStatus = 1;
    }
  }

  return rtnStatus;
}

static int
evaluatePatientDemographic(MDICOMWrapper& wrapperTest,
		MDICOMWrapper& wrapperStd, int level)
{
  if (level >= 3)
    cout << "Test Patient Demographic" << endl;

  int rtnStatus = 0;
  DCM_TAG t1[] = {
	0x00100030,	// Patient DOB
	0x00100040	// Patient Sex
  };

  int idx = 0;
  for (idx = 0; idx < (int)DIM_OF(t1); idx++) {
    if (!attributeMatch(wrapperTest, wrapperStd, t1[idx], level)) {
      rtnStatus = 1;
    }
  }

#if 0
  // Confidentiality constraint on patient data
  if (!attributePresent(wrapperTest, 0x00403001, level)) {
    rtnStatus = 1;
  }
#endif

  return rtnStatus;
}

static int
evaluateSOPCommon(MDICOMWrapper& wrapperTest,
		MDICOMWrapper& wrapperStd, int level)
{
  if (level >= 3)
    cout << "CTX: Test SOP Commmon" << endl;

  int rtnStatus = 0;
  DCM_TAG t1[] = {
	0x00080016,	// SOP Class UID
	0x00080018	// SOP Instance UID
  };

  int idx = 0;
  for (idx = 0; idx < (int)DIM_OF(t1); idx++) {
    if (!attributeMatch(wrapperTest, wrapperStd, t1[idx], level)) {
      rtnStatus = 1;
    }
  }

  return rtnStatus;
}

static int
evaluatePatientMedical(MDICOMWrapper& wrapperTest,
		MDICOMWrapper& wrapperStd, int level)
{
  if (level >= 3)
    cout << "CTX: Test Patient Medical" << endl;

  return 0;
}

static int
evaluateSPSRelationship(MDICOMWrapper& wrapperTest,
				MDICOMWrapper& wrapperStd, int level)
{
  if (level >= 3)
    cout << "CTX: Test Scheduled Procedure Step Relationship" << endl;

  int rtnStatus = 0;
  DCM_TAG t1[] = {
	0x0020000D,	// Study Instance UID of input
	0x00401001,	// Requested Procedure ID
	0x00321060,	// Requested Procedure Description
	0x00321032,	// Requesting Physician
	0x00080050	// Accession Number
  };

  int idx = 0;
  for (idx = 0; idx < (int)DIM_OF(t1); idx++) {
    if (!attributeMatch(wrapperTest, wrapperStd,
			0x0040a370, t1[idx], level)) {
      rtnStatus = 1;
    }
  }

  return rtnStatus;
}

static int
evaluateSPSInformation(MDICOMWrapper& wrapperTest,
				MDICOMWrapper& wrapperStd, int level)
{
  if (level >= 3)
    cout << "CTX: Test Scheduled Procedure Step Information" << endl;

  int rtnStatus = 0;
  DCM_TAG t1[] = {
	0x00404001,	// GPSPS Status
	0x00404020,	// Input Availability Flag
	0x00404005,	// SPS Start Date and Time
	// test the following for presence, not match
	//0x0020000D	// Study Instance UID
  };

  int idx = 0;
  for (idx = 0; idx < (int)DIM_OF(t1); idx++) {
    if (!attributeMatch(wrapperTest, wrapperStd, t1[idx], level)) {
      rtnStatus = 1;
    }
  }

  if (!attributePresent(wrapperTest, 0x0020000D, level)) {
    rtnStatus = 1;
  }

  DCM_TAG t2[] = {
	0x00080100,	// Code Value
	0x00080102,	// Coding Scheme Designator
	0x00080104	// Code Meaning
  };

  DCM_TAG t3[] = {
	0x00404037	// Human Performer's Name
  };

  // Scheduled Workitem Code Sequence
  for (idx = 0; idx < (int)DIM_OF(t2); idx++) {
    if (!attributeMatch(wrapperTest, wrapperStd,
			0x00404018, t2[idx], level)) {
      rtnStatus = 1;
    }
  }

  // Scheduled Station Name Code Sequence
  if( ! matchSchedStationNames( wrapperTest, wrapperStd, level)) {
    rtnStatus = 1;
  }

  // Scheduled Human Performers Sequence
  if( ! matchSchedHumanPerformers( wrapperTest, wrapperStd, level)) {
    rtnStatus = 1;
  }
  /*
  for (idx = 0; idx < (int)DIM_OF(t3); idx++) {
    if (!attributeMatch(wrapperTest, wrapperStd,
			0x00404034, t3[idx], level)) {
      rtnStatus = 1;
    }
  }
  */

  // Input Info Sequence
  if( ! matchInputInfo( wrapperTest, wrapperStd, level)) {
    rtnStatus = 1;
  }

  return rtnStatus;
}


static void
usageerror()
{
    char msg[] = "\
Usage: cfind_gpsps_evaluate [-l level] [-v] <test file> <master file> \n\
\n\
    -t              Log level (1-4) \n\
    -v              Verbose mode (log level = 3)\n\
\n\
    <test file>     File to be tested\n\
    <master file>   File considered to be \"gold standard\" ";

    cerr << msg << endl;
    ::exit(1);
}

int main(int argc, char **argv)
{
  CONDITION cond;
  int level = 1;		// Level 1 errors only
  int rtnStatus = 0;

  while (--argc > 0 && (*++argv)[0] == '-') {
    switch (*(argv[0] + 1)) {
    case 'l':
      argc--; argv++;
      if (argc < 1)
	usageerror();
      level = atoi(*argv);
      break;
    case 'v':
      level = 3;
      break;
    default:
      break;
    }
  }

  ::THR_Init();
  if (argc != 2)
    usageerror();

  MDICOMWrapper wrapperTest(*argv);
  argv++;
  MDICOMWrapper wrapperStd(*argv);

#if 0
  if (evaluateScheduledProcedureStep(wrapperTest, wrapperStd, level) != 0)
    rtnStatus = 1;

  if (evaluateRequestedProcedure(wrapperTest, wrapperStd, level) != 0)
    rtnStatus = 1;

  if (evaluateImagingServiceRequest(wrapperTest, wrapperStd, level) != 0)
    rtnStatus = 1;

  if (evaluateVisitIdentification(wrapperTest, wrapperStd, level) != 0)
    rtnStatus = 1;

  if (evaluateVisitStatus(wrapperTest, wrapperStd, level) != 0)
    rtnStatus = 1;

  if (evaluateVisitRelationship(wrapperTest, wrapperStd, level) != 0)
    rtnStatus = 1;
#endif

  if (evaluateSOPCommon(wrapperTest, wrapperStd, level) != 0)
    rtnStatus = 1;

  if (evaluateSPSInformation(wrapperTest, wrapperStd, level) != 0)
    rtnStatus = 1;

  if (evaluateSPSRelationship(wrapperTest, wrapperStd, level) != 0)
    rtnStatus = 1;

  if (evaluatePatientIdentification(wrapperTest, wrapperStd, level) != 0)
    rtnStatus = 1;

  if (evaluatePatientDemographic(wrapperTest, wrapperStd, level) != 0)
    rtnStatus = 1;

  if (evaluatePatientMedical(wrapperTest, wrapperStd, level) != 0)
    rtnStatus = 1;

  return rtnStatus;
}

