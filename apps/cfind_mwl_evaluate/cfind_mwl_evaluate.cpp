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

static char rcsid[] = "$Revision: 1.15 $ $RCSfile: cfind_mwl_evaluate.cpp,v $";

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
//#ifdef GCCSUNOS
//#include <sys/types.h>
//#endif
#include "MESA.hpp"
#include "ctn_api.h"
#include "MDICOMWrapper.hpp"
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


bool attributeMatchName(MDICOMWrapper& wTest, MDICOMWrapper& wStd,
			DCM_TAG tag, int level)
{
  if (level >= 3) {
    U16 g = DCM_TAG_GROUP(tag);
    U16 e = DCM_TAG_ELEMENT(tag);

    cout << "CTX: Test for equivalence of PN attribute: "
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
  bool rtnValue = true;		// Assume success
  int idx = 0;
  MString componentTest;
  MString componentStd;
  while (sStd.tokenExists('^', idx)) {
    componentStd = sStd.getToken('^', idx);
    if (sTest.tokenExists('^', idx)) {
      componentTest = sTest.getToken('^', idx);
    } else {
      componentTest = "No value at this position";
    }
    if (componentTest != componentStd) {
      rtnValue = false;
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
      cout << "ERR: Component " << idx + 1
	   << " MESA<" << componentStd << ">"
	   << " Test<" << componentStd << ">"
	   << endl;
    }
    idx += 1;
  }
#if 0
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
#endif
  return rtnValue;
}

bool attributeMatchName(MDICOMWrapper& wTest, MDICOMWrapper& wStd,
			DCM_TAG tag, int level, const MString& language)
{

  if (language == "") {
    return attributeMatchName(wTest, wStd, tag, level);
  }

  // Repair, need to add code for a better test for Japanese and
  // other character sets.
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
  bool rtnValue = true;		// Assume success
  int idx = 0;
  MString componentTest;
  MString componentStd;
  while (sStd.tokenExists('^', idx)) {
    componentStd = sStd.getToken('^', idx);
    if (sTest.tokenExists('^', idx)) {
      componentTest = sTest.getToken('^', idx);
    } else {
      componentTest = "No value at this position";
    }
    if (componentTest != componentStd) {
      rtnValue = false;
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
      cout << "ERR: Component " << idx + 1
	   << " MESA<" << componentStd << ">"
	   << " Test<" << componentStd << ">"
	   << endl;
    }
    idx += 1;
  }
  return rtnValue;
}

static void dumpCharInHex(const MString& sTest, const MString& sStd,
	const MString& language) {
  char sTestBuffer[512];
  char sStdBuffer[512];
  sTest.safeExport(sTestBuffer, sizeof(sTestBuffer));
  sStd.safeExport( sStdBuffer,  sizeof(sStdBuffer));
  CHR_ENCODING code = CHR_ISO2022JP;
  if (language != "Japanese") {
    cout << "WARN: Request to evaluate string with unsupported language: " << language << endl;
    return;
  }
  int lTest = ::strlen(sTestBuffer);
  int lStd  = ::strlen(sStdBuffer);
  CHR_ITERATOR_CONTEXT ctxTest;
  CHR_ITERATOR_CONTEXT ctxStd;
  ::memset(&ctxTest, 0, sizeof(ctxTest));
  ::memset(&ctxStd,  0, sizeof(ctxStd));
  ::CHR_IterateBegin(sTestBuffer, lTest, code, &ctxTest);
  ::CHR_IterateBegin(sStdBuffer,  lStd,  code, &ctxStd);

  lTest = 1;
  lStd  = 1;
  cout << hex;
  do {
    unsigned char bufferTest[5] = "";
    unsigned char bufferStd[5] = "";
    CHR_CHARACTER charSetTest = CHR_ASCII;
    CHR_CHARACTER charSetStd = CHR_ASCII;
    CHR_NextCharacter(&ctxTest, &charSetTest, bufferTest, &lTest);
    CHR_NextCharacter(&ctxStd,  &charSetStd, bufferStd,  &lStd);
    int j = 0;
    cout << "CTX: " << '(';
    U16 u;
    for (j = 0; j < lTest; j++) {
      u = bufferTest[j] & 0xff;
      cout << setw(2) << setfill('0') << u;
      if (j != (lTest - 1)) {
	cout << ' ';
      }
    }
    cout << ':';
    if (charSetTest == CHR_ASCII && lTest == 1) {
      cout << bufferTest[0] << ':';
    }
    cout << charSetTest << ") (";
    for (j = 0; j < lStd; j++) {
      u = bufferStd[j] & 0xff;
      cout << setw(2) << setfill('0') << u;
      if (j != (lStd - 1)) {
	cout << ' ';
      }
    }
    cout << ':';
    if (charSetStd == CHR_ASCII && lStd == 1) {
      cout << bufferStd[0] << ':';
    }
    cout << charSetStd << ')' << endl;
  } while ((lTest != 0) && (lStd != 0));
  cout << dec << endl;
}

bool attributeMatch(MDICOMWrapper& wTest, MDICOMWrapper& wStd,
			DCM_TAG tag, int level, const MString& language)
{
  if (language == "") {
    return attributeMatch(wTest, wStd, tag, level);
  }

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
    dumpCharInHex(sTest, sStd, language);
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
    cout << "CTX: Test Requested Procedure" << endl;

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
    if (!attributeMatchName(wrapperTest, wrapperStd, t2[idx], level)) {
      rtnStatus = 1;
    }
  }

  return rtnStatus;
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
  if (!attributeMatch(wrapperTest, wrapperStd, 0x00380010, level))
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
  // Comment out until we get the MESA MWL server to provide this attribute
#if 0
  if (!attributeMatch(wrapperTest, wrapperStd, 0x00380300, verbose))
    rtnStatus = 1;
#endif

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
			MDICOMWrapper& wrapperStd, int level,
			const MString& language)
{
  if (level >= 3)
    cout << "CTX: Test Patient Identification" << endl;

  int rtnStatus = 0;
  DCM_TAG t1[] = {
	0x00100010,	// Patient Name
  };

  int idx = 0;
  for (idx = 0; idx < (int)DIM_OF(t1); idx++) {
    if (!attributeMatchName(wrapperTest, wrapperStd, t1[idx], level, language)) {
      rtnStatus = 1;
    }
  }

  DCM_TAG t2[] = {
	0x00100020	// Patient ID
  };
  for (idx = 0; idx < (int)DIM_OF(t1); idx++) {
    if (!attributeMatch(wrapperTest, wrapperStd, t1[idx], level, language)) {
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
    cout << "CTX: Test Patient Demographic" << endl;

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
evaluatePatientMedical(MDICOMWrapper& wrapperTest,
		MDICOMWrapper& wrapperStd, int level)
{
  if (level >= 3)
    cout << "CTX: Test Patient Medical" << endl;

  return 0;
}


static void
usageerror()
{
    char msg[] = "\
Usage: cfind_mwl_evaluate [-l level] [-L language] [-v] <test file> <master file> \n\
\n\
    -l              Log level (1-4) \n\
    -L              Language of messages to be evaluated (Japanese) \n\
    -v              Verbose mode\n\
\n\
    <test file>     File to be tested\n\
    <master file>   File considered to be \"gold standard\" ";

    cout << msg << endl;
    ::exit(1);
}

int main(int argc, char **argv)
{
  CONDITION cond;
  int rtnStatus = 0;
  int level = 1;		// Level 1 is errors only
  char* language = "";		// Language of message for evaluation

  while (--argc > 0 && (*++argv)[0] == '-') {
    switch (*(argv[0] + 1)) {
    case 'l':
      argc--; argv++;
      if (argc < 1)
	usageerror();
      level = atoi(*argv);
      break;
    case 'L':
      argc--; argv++;
      if (argc < 1)
	usageerror();
      language = *argv;
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

  if (evaluatePatientIdentification(wrapperTest, wrapperStd, level, language) != 0)
    rtnStatus = 1;

  if (evaluatePatientDemographic(wrapperTest, wrapperStd, level) != 0)
    rtnStatus = 1;

  if (evaluatePatientMedical(wrapperTest, wrapperStd, level) != 0)
    rtnStatus = 1;

  return rtnStatus;
}

