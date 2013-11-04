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

static char rcsid[] = "$Revision: 1.3 $ $RCSfile: evaluate_gppps.cpp,v $";

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
#include "MDICOMDomainXlate.hpp"
#include "MDomainObject.hpp"
#include "MOutputInfo.hpp"
#include "MReqSubsWorkitem.hpp"
#include "MNonDCMOutput.hpp"

bool attributePresent(MDICOMWrapper& w, DCM_TAG tag, bool verbose)
{
  if (verbose) {
    U16 g = DCM_TAG_GROUP(tag);
    U16 e = DCM_TAG_ELEMENT(tag);

    cout << " Test for presence of attribute: "
	 << setw(4) << setfill('0') << hex << g << " "
	 << setw(4) << setfill('0') << e << " "<< dec;
  }

  MString s = w.getString(tag);
  if (verbose) {
    cout << "<" << s << ">" << endl;
  }

  if (s == "") {
    U16 g = DCM_TAG_GROUP(tag);
    U16 e = DCM_TAG_ELEMENT(tag);
    cout << "Attribute "
	 << hex
	 << setw(4) << setfill('0') << g << " "
	 << setw(4) << setfill('0') << e << dec
	 << " not present or 0-length." << endl;
    return false;

  } else {
    return true;
  }
}

bool attributePresent(MDICOMWrapper& w, DCM_TAG seqTag, DCM_TAG tag, bool verbose)
{
  if (verbose) {
    U16 seqG = DCM_TAG_GROUP(seqTag);
    U16 seqE = DCM_TAG_ELEMENT(seqTag);
    U16 g = DCM_TAG_GROUP(tag);
    U16 e = DCM_TAG_ELEMENT(tag);

    cout << " Test for presence of attribute: "
	 << hex
	 << setw(4) << setfill('0') << seqG << " "
	 << setw(4) << setfill('0') << seqE << " "
	 << setw(4) << setfill('0') << g << " "
	 << setw(4) << setfill('0') << e << " "
	 << dec;
  }

  MString s = w.getString(seqTag, tag);
  if (verbose) {
    cout << "<" << s << ">" << endl;
  }
  if (s == "") {
    U16 seqG = DCM_TAG_GROUP(seqTag);
    U16 seqE = DCM_TAG_ELEMENT(seqTag);
    U16 g = DCM_TAG_GROUP(tag);
    U16 e = DCM_TAG_ELEMENT(tag);
    cout << "Attribute "
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
			DCM_TAG tag, bool verbose)
{
  if (verbose) {
    U16 g = DCM_TAG_GROUP(tag);
    U16 e = DCM_TAG_ELEMENT(tag);

    cout << " Test for equivalence of attribute: "
	 << hex
	 << setw(4) << setfill('0') << g << " "
	 << setw(4) << setfill('0') << e << " "
	 << dec;
  }

  MString sTest = wTest.getString(tag);
  MString sStd = wStd.getString(tag);

  if (verbose) {
    cout << "<" << sTest << ">"
	 << " <" << sStd << ">"
	 << endl;
  }
  if (sTest != sStd) {
    U16 g = DCM_TAG_GROUP(tag);
    U16 e = DCM_TAG_ELEMENT(tag);
    cout << "Attribute "
	 << hex
	 << setw(4) << setfill('0') << g << " "
	 << setw(4) << setfill('0') << e
	 << dec
	 << " does not match <test> <std>." << endl;
    cout << "<" << sTest << ">"
	 << " <" << sStd << ">"
	 << endl;
    return false;
  } else {
    return true;
  }
}

bool attributeMatch(MDICOMWrapper& wTest, MDICOMWrapper& wStd,
			DCM_TAG seqTag, DCM_TAG tag, bool verbose)
{
  if (verbose) {
    U16 seqG = DCM_TAG_GROUP(seqTag);
    U16 seqE = DCM_TAG_ELEMENT(seqTag);
    U16 g = DCM_TAG_GROUP(tag);
    U16 e = DCM_TAG_ELEMENT(tag);

    cout << " Test for equivalence of attribute: "
	 << hex
	 << setw(4) << setfill('0') << seqG << " "
	 << setw(4) << setfill('0') << seqE << " "
	 << setw(4) << setfill('0') << g << " "
	 << setw(4) << setfill('0') << e << " "
	 << dec;
  }

  MString sTest = wTest.getString(seqTag, tag);
  MString sStd = wStd.getString(seqTag, tag);

  if (verbose) {
    cout << "<" << sTest << ">"
	 << " <" << sStd << ">"
	 << endl;
  }
  if (sTest != sStd) {
    U16 seqG = DCM_TAG_GROUP(seqTag);
    U16 seqE = DCM_TAG_ELEMENT(seqTag);
    U16 g = DCM_TAG_GROUP(tag);
    U16 e = DCM_TAG_ELEMENT(tag);
    cout << "Attribute "
	 << hex
	 << setw(4) << setfill('0') << seqG << " "
	 << setw(4) << setfill('0') << seqE << " "
	 << setw(4) << setfill('0') << g << " "
	 << setw(4) << setfill('0') << e
	 << dec
	 << " does not match <test> <std>." << endl;
    cout << "<" << sTest << ">"
	 << " <" << sStd << ">"
	 << endl;
    return false;
  } else {
    return true;
  }
}

static int
evaluatePatientIdentification(MDICOMWrapper& wrapperTest,
			MDICOMWrapper& wrapperStd, bool verbose)
{
  if (verbose)
    cout << "Test Patient Identification" << endl;

  int rtnStatus = 0;
  DCM_TAG t1[] = {
	0x00100010,	// Patient Name
	0x00100020	// Patient ID
  };

  int idx = 0;
  for (idx = 0; idx < (int)DIM_OF(t1); idx++) {
    if (!attributeMatch(wrapperTest, wrapperStd, t1[idx], verbose)) {
      rtnStatus = 1;
    }
  }

  return rtnStatus;
}

static int
evaluatePatientDemographic(MDICOMWrapper& wrapperTest,
		MDICOMWrapper& wrapperStd, bool verbose)
{
  if (verbose)
    cout << "Test Patient Demographic" << endl;

  int rtnStatus = 0;
  DCM_TAG t1[] = {
	0x00100030,	// Patient DOB
	0x00100040	// Patient Sex
  };

  int idx = 0;
  for (idx = 0; idx < (int)DIM_OF(t1); idx++) {
    if (!attributeMatch(wrapperTest, wrapperStd, t1[idx], verbose)) {
      rtnStatus = 1;
    }
  }

#if 0
  // Confidentiality constraint on patient data
  if (!attributePresent(wrapperTest, 0x00403001, verbose)) {
    rtnStatus = 1;
  }
#endif

  return rtnStatus;
}

static int
evaluatePatientMedical(MDICOMWrapper& wrapperTest,
		MDICOMWrapper& wrapperStd, bool verbose)
{
  if (verbose)
    cout << "Test Patient Medical" << endl;

  return 0;
}

static int
evaluatePPSInformation(MDICOMWrapper& wrapperTest,
				MDICOMWrapper& wrapperStd, bool verbose)
{
  if (verbose)
    cout << "Test Scheduled Procedure Step Information" << endl;

  int rtnStatus = 0;
  DCM_TAG t1[] = {
	0x00400253,	// PPS ID
	0x00400244,	// PPS Start Date
	0x00400245,	// PPS Start Time
	0x00400250,	// PPS End Date
	0x00400251,	// PPS End Time
	0x00400254,	// PPS Description
	0x00404002	// PPS Status
  };

  int idx = 0;
  for (idx = 0; idx < (int)DIM_OF(t1); idx++) {
    if (!attributeMatch(wrapperTest, wrapperStd, t1[idx], verbose)) {
      rtnStatus = 1;
    }
  }

  return rtnStatus;
}

/*
 * This only handles single sequence item, could be multiple.
 */
static int
evaluateRefGPSPS(MDICOMWrapper& wTest,
                                MDICOMWrapper& wStd, bool verbose)
{
  if (verbose)
    cout << "Test Referenced GP-SPS" << endl;

  MDICOMWrapper *sps_test = wTest.getSequenceWrapper( 0x00404016, 1);
  MDICOMWrapper *sps_std  = wStd.getSequenceWrapper(  0x00404016, 1);

  if( sps_test == NULL ) {
     cout << "Missing Referenced GP-SPS Sequence in test object.\n";
     return 1;
  }
  if( sps_std == NULL) {
     cout << "Missing Referenced GP-SPS Sequence in standard object.\n";
     return 1;
  }
  int rtnStatus = 0;
  DCM_TAG t1[] = {
        0x00081150,      // Referenced SOP Class UID
        0x00081155,      // Referenced SOP Instance UID
        0x00404023,      // Referenced GP-SPS Transaction UID
  };

  int idx = 0;
  for (idx = 0; idx < (int)DIM_OF(t1); idx++) {
    if (!attributeMatch(*sps_test, *sps_std, t1[idx], verbose)) {
      rtnStatus = 1;
    }
  }

  return rtnStatus;
}

static int
evaluateActualHumanPerformer(MDICOMWrapper& wTest,
                                MDICOMWrapper& wStd, bool verbose)
{
  if (verbose)
    cout << "Test Actual Human Performer" << endl;

  MDICOMWrapper *ahps_test = wTest.getSequenceWrapper( 0x00404035, 1);
  MDICOMWrapper *ahps_std  = wStd.getSequenceWrapper(  0x00404035, 1);

  if( ahps_test == NULL ) {
     cout << "Missing Actual Human Performer Sequence in test object.\n";
     return 1;
  }
  if( ahps_std == NULL) {
     cout << "Missing Actual Human Performer Sequence in standard object.\n";
     return 1;
  }
  int rtnStatus = 0;
  DCM_TAG t1[] = {
        0x00080100,      // Code value
        0x00080102,      // Code Scheme Designator
        0x00080104,      // Code Meaning
  };

  int idx = 0;
  for (idx = 0; idx < (int)DIM_OF(t1); idx++) {
    if (!attributeMatch(*ahps_test, *ahps_std, 0x00404009, t1[idx], verbose)) {
      rtnStatus = 1;
    }
  }

  return rtnStatus;
}

static int
evaluatePerformedStationNameCodeSeq(MDICOMWrapper& wTest,
                                MDICOMWrapper& wStd, bool verbose)
{
  if (verbose)
    cout << "Test Performed Station Name Code Seq" << endl;

  int rtnStatus = 0;
  DCM_TAG t1[] = {
        0x00080100,      // Code value
        0x00080102,      // Code Scheme Designator
        0x00080104,      // Code Meaning
  };

  int idx = 0;
  for (idx = 0; idx < (int)DIM_OF(t1); idx++) {
    if (!attributeMatch(wTest, wStd, 0x00404028, t1[idx], verbose)) {
      rtnStatus = 1;
    }
  }

  return rtnStatus;
}

static int
evaluatePerformedStationClassCodeSeq(MDICOMWrapper& wTest,
                                MDICOMWrapper& wStd, bool verbose)
{
  if (verbose)
    cout << "Test Performed Station Class Code Seq" << endl;

  int rtnStatus = 0;
  DCM_TAG t1[] = {
        0x00080100,      // Code value
        0x00080102,      // Code Scheme Designator
        0x00080104,      // Code Meaning
  };

  int idx = 0;
  for (idx = 0; idx < (int)DIM_OF(t1); idx++) {
    if (!attributeMatch(wTest, wStd, 0x00404029, t1[idx], verbose)) {
      rtnStatus = 1;
    }
  }

  return rtnStatus;
}

static int
evaluatePerformedStationLocationCodeSeq(MDICOMWrapper& wTest,
                                MDICOMWrapper& wStd, bool verbose)
{
  if (verbose)
    cout << "Test Performed Station Location Code Seq" << endl;

  int rtnStatus = 0;
  DCM_TAG t1[] = {
        0x00080100,      // Code value
        0x00080102,      // Code Scheme Designator
        0x00080104,      // Code Meaning
  };

  int idx = 0;
  for (idx = 0; idx < (int)DIM_OF(t1); idx++) {
    if (!attributeMatch(wTest, wStd, 0x00404030, t1[idx], verbose)) {
      rtnStatus = 1;
    }
  }

  return rtnStatus;
}

/*
 * bug. This assumes only one value allowed in Perf Proc App Code Seq.
 * This seq is allowed zero to many.
 */
static int
evaluatePerformedProcessingAppCodeSeq(MDICOMWrapper& wTest,
                                MDICOMWrapper& wStd, bool verbose)
{
  if (verbose)
    cout << "Test Performed Processing Application Code Seq" << endl;

  int rtnStatus = 0;
  DCM_TAG t1[] = {
        0x00080100,      // Code value
        0x00080102,      // Code Scheme Designator
        0x00080104,      // Code Meaning
  };

  int idx = 0;
  for (idx = 0; idx < (int)DIM_OF(t1); idx++) {
    if (!attributeMatch(wTest, wStd, 0x00404007, t1[idx], verbose)) {
      rtnStatus = 1;
    }
  }

  return rtnStatus;
}

static int
evaluatePerformedWorkitemCodeSeq(MDICOMWrapper& wTest,
                                MDICOMWrapper& wStd, bool verbose)
{
  if (verbose)
    cout << "Test Performed Workitem Code Seq" << endl;

  int rtnStatus = 0;
  DCM_TAG t1[] = {
        0x00080100,      // Code value
        0x00080102,      // Code Scheme Designator
        0x00080104,      // Code Meaning
  };

  int idx = 0;
  for (idx = 0; idx < (int)DIM_OF(t1); idx++) {
    if (!attributeMatch(wTest, wStd, 0x00404019, t1[idx], verbose)) {
      rtnStatus = 1;
    }
  }

  return rtnStatus;
}

/*
 * Find an element in the vector with a SOPInstanceUID matching
 * the SOPInstanceUID in the reference object.
 * Return the matching test object if found or NULL if not.
 */
int matchSOPInstanceUID( 
      MOutputInfo& oi, MOutputInfoVector& testOIVec, MOutputInfo& matchoi)
{
  int rtnStatus = 0;
  MString refUID = oi.SOPInstanceUID();

  MOutputInfoVector::iterator objIt = testOIVec.begin();
  for (; objIt != testOIVec.end(); objIt++) {
    MOutputInfo testoi = (*objIt);
    MString testUID = testoi.SOPInstanceUID();
    if( refUID == testUID ) {
       matchoi = testoi;
       return 1;
    }
  }
  return 0;
}

/*
 * bug?  Does not assume the sequence items are in the same order.
 */
static int
evaluateOutputInfoSeq(MDICOMWrapper& wTest,
                                MDICOMWrapper& wStd, bool verbose)
{
  int rtnStatus = 0;
  if (verbose)
    cout << "Test Output Information Sequence" << endl;

  MDICOMDomainXlate xlate;
  MOutputInfoVector testInfoVec;
  MOutputInfoVector stdInfoVec;

  xlate.translateDICOM(wTest, testInfoVec);
  xlate.translateDICOM(wStd, stdInfoVec);

#if 0
  cout << "Output info vector size: " << testInfoVec.size() << "\n";
  MOutputInfoVector::iterator objIt = testInfoVec.begin();
  for (int nitem = 1; objIt != testInfoVec.end(); objIt++, nitem++) {
    cout << "Output Info Vector item " << nitem << "\n";
    MOutputInfo oi = (*objIt);
    cout << oi;
  }
#endif

  if( testInfoVec.size() != stdInfoVec.size()) {
    cout << "Test and Standard Output Info Sequences differ in number of items.\n";
    cout << "test object has " << testInfoVec.size() << " items\n";
    cout << "std  object has " << stdInfoVec.size() << " items\n";
    rtnStatus = 1;
  }

  MOutputInfoVector::iterator objIt = stdInfoVec.begin();
  for (; objIt != stdInfoVec.end(); objIt++) {
    MOutputInfo oi = (*objIt);
    MOutputInfo testoi;
    if( ! matchSOPInstanceUID( oi, testInfoVec, testoi)) {
       cout << "Failed to find Output Info item in test object with\n";
       cout << "SOP Instance UID matching MESA reference Output Info item.\n";
       cout << "Looking for MESA reference Output Info item...\n";
       cout << oi;
       if( verbose) {
          cout << "within the following sequence of Output Info items in the\n";
          cout << "test object...\n";
          MOutputInfoVector::iterator testobjIt = testInfoVec.begin();
          for(int nitem = 1;testobjIt != testInfoVec.end();testobjIt++,nitem++){
            cout << "Test Output Info Vector item " << nitem << "\n";
            cout << *testobjIt;
          }
       }
       rtnStatus = 1;
    }
    else {
       if( oi.studyInstanceUID() != testoi.studyInstanceUID()) {
          cout << "Output Info item Study Instance UIDs do not match.\n";
          cout << "Master value: " << oi.studyInstanceUID() << "\n";
          cout << "Test value: " << testoi.studyInstanceUID() << "\n";
          rtnStatus = 1;
       }
       if( oi.seriesInstanceUID() != testoi.seriesInstanceUID()) {
          cout << "Output Info item Series Instance UIDs do not match.\n";
          cout << "Master value: " << oi.seriesInstanceUID() << "\n";
          cout << "Test value: " << testoi.seriesInstanceUID() << "\n";
          rtnStatus = 1;
       }
       if( oi.SOPClassUID() != testoi.SOPClassUID()) {
          cout << "Output Info item SOP Class UIDs do not match.\n";
          cout << "Master value: " << oi.SOPClassUID() << "\n";
          cout << "Test value: " << testoi.SOPClassUID() << "\n";
          rtnStatus = 1;
       }
       if( oi.SOPInstanceUID() != testoi.SOPInstanceUID()) {
          cout << "Output Info item SOP Instance UIDs do not match.\n";
          cout << "Master value: " << oi.SOPInstanceUID() << "\n";
          cout << "Test value: " << testoi.SOPInstanceUID() << "\n";
          rtnStatus = 1;
       }
       if( verbose) {
          cout << "  Output Info items match.\n";
          cout << "  Study Instance UID: " << testoi.studyInstanceUID() << "\n";
          cout << "  Series Instance UID: " << testoi.seriesInstanceUID()<<"\n";
          cout << "  SOP class UID: " << testoi.SOPClassUID() << "\n";
          cout << "  SOP Instance UID: " << testoi.SOPInstanceUID() << "\n";
       }
    }
  }

  return rtnStatus;
}

/*
 * Test for matching Requested Subsequent Workitem Code Sequence items.
 * Find an element in the vector with a Code value matching
 * the Code value in the reference object.
 */
int matchValue( 
      MReqSubsWorkitem& refitem, MReqSubsWorkitemVector& testVec, 
      MReqSubsWorkitem& matchitem)
{
  int rtnStatus = 0;
  MString refValue = refitem.codeValue();

  MReqSubsWorkitemVector::iterator objIt = testVec.begin();
  for (; objIt != testVec.end(); objIt++) {
    MReqSubsWorkitem testitem = (*objIt);
    MString testValue = testitem.codeValue();
    if( refValue == testValue ) {
       matchitem = testitem;
       return 1;
    }
  }
  return 0;
}

static int
evaluateReqSubsequentWorkitemCodeSeq(MDICOMWrapper& wTest,
                                MDICOMWrapper& wStd, bool verbose)
{
  int rtnStatus = 0;
  if (verbose)
    cout << "Test Requested Subsequent Workitem Code Sequence" << endl;

  MDICOMDomainXlate xlate;
  MReqSubsWorkitemVector testVec;
  MReqSubsWorkitemVector stdVec;

  xlate.translateDICOM(wTest, testVec);
  xlate.translateDICOM(wStd, stdVec);

  if( testVec.size() != stdVec.size()) {
    cout << "Test and Standard Requested Subsequent Workitem Sequences differ in size.\n";
    cout << "test object has " << testVec.size() << " items\n";
    cout << "std  object has " << stdVec.size() << " items\n";
    rtnStatus = 1;
  }

  MReqSubsWorkitemVector::iterator objIt = stdVec.begin();
  for (; objIt != stdVec.end(); objIt++) {
    MReqSubsWorkitem refitem = (*objIt);
    MReqSubsWorkitem testitem;
    if( ! matchValue( refitem, testVec, testitem)) {
       cout << "Failed to find Requested Subsequent Workitem in test object\n";
       cout << "with code value matching MESA reference value.\n";
       cout << "Looking for MESA reference Requested Subsequent Workitem...\n";
       cout << refitem;
       if( verbose) {
          cout << "within the following sequence of Workitems in the\n";
          cout << "test object...\n";
          MReqSubsWorkitemVector::iterator testobjIt = testVec.begin();
          for(int nitem = 1; testobjIt != testVec.end(); testobjIt++, nitem++) {
            cout << "Test Requested Subsequent Workitem Vector item " << nitem << "\n";
            cout << *testobjIt;
          }
       }
       rtnStatus = 1;
    }
    else {
       if( refitem.codeValue() != testitem.codeValue()) {
          cout << "Requested Subsequent Workitem code values do not match.\n";
          cout << "Master value: " << refitem.codeValue() << "\n";
          cout << "Test value: " << testitem.codeValue() << "\n";
          rtnStatus = 1;
       }
       if( refitem.codeMeaning() != testitem.codeMeaning()) {
          cout << "Requested Subsequent Workitem code meanings do not match.\n";
          cout << "Master value: " << refitem.codeMeaning() << "\n";
          cout << "Test value: " << testitem.codeMeaning() << "\n";
          rtnStatus = 1;
       }
       if( refitem.codeSchemeDesignator() != testitem.codeSchemeDesignator()) {
          cout << "Requested Subsequent Workitem code schemes do not match.\n";
          cout << "Master value: " << refitem.codeSchemeDesignator() << "\n";
          cout << "Test value: " << testitem.codeSchemeDesignator() << "\n";
          rtnStatus = 1;
       }
       if( verbose) {
          cout << "  Requested Subsequent Workitem code items match.\n";
          cout << "  value: " << testitem.codeValue() << "\n";
          cout << "  scheme: " << testitem.codeSchemeDesignator() << "\n";
          cout << "  meaning: " << testitem.codeMeaning() << "\n";
       }
    }
  }

  return rtnStatus;
}

/*
 * Test for matching Non-DICOM Output Code Sequence items.
 * Find an element in the vector with a Code value matching
 * the Code value in the reference object.
 */
int matchValue( 
      MNonDCMOutput& refitem, MNonDCMOutputVector& testVec, 
      MNonDCMOutput& matchitem)
{
  int rtnStatus = 0;
  MString refValue = refitem.codeValue();

  MNonDCMOutputVector::iterator objIt = testVec.begin();
  for (; objIt != testVec.end(); objIt++) {
    MNonDCMOutput testitem = (*objIt);
    MString testValue = testitem.codeValue();
    if( refValue == testValue ) {
       matchitem = testitem;
       return 1;
    }
  }
  return 0;
}

static int
evaluateNonDICOMOutputCodeSeq(MDICOMWrapper& wTest,
                                MDICOMWrapper& wStd, bool verbose)
{
  int rtnStatus = 0;
  if (verbose)
    cout << "Test Non-DICOM Output Code Sequence" << endl;

  MDICOMDomainXlate xlate;
  MNonDCMOutputVector testVec;
  MNonDCMOutputVector stdVec;

  xlate.translateDICOM(wTest, testVec);
  xlate.translateDICOM(wStd, stdVec);

  if( testVec.size() != stdVec.size()) {
    cout << "Test and Standard Non-DICOM Output Code Sequences differ in size.\n";
    cout << "test object has " << testVec.size() << " items\n";
    cout << "std  object has " << stdVec.size() << " items\n";
    rtnStatus = 1;
  }

  MNonDCMOutputVector::iterator objIt = stdVec.begin();
  for (; objIt != stdVec.end(); objIt++) {
    MNonDCMOutput refitem = (*objIt);
    MNonDCMOutput testitem;
    if( ! matchValue( refitem, testVec, testitem)) {
       cout << "Failed to find Non-DICOM Output item in test object\n";
       cout << "with code value matching MESA reference value.\n";
       cout << "Looking for MESA reference Non-DICOM Output item...\n";
       cout << refitem;
       if( verbose) {
          cout << "within the following sequence of items in the\n";
          cout << "test object...\n";
          MNonDCMOutputVector::iterator testobjIt = testVec.begin();
          for(int nitem = 1; testobjIt != testVec.end(); testobjIt++, nitem++) {
            cout << "Test Non-DICOM Output Vector item " << nitem << "\n";
            cout << *testobjIt;
          }
       }
       rtnStatus = 1;
    }
    else {
       if( refitem.codeValue() != testitem.codeValue()) {
          cout << "Non-DICOM Output code values do not match.\n";
          cout << "Master value: " << refitem.codeValue() << "\n";
          cout << "Test value: " << testitem.codeValue() << "\n";
          rtnStatus = 1;
       }
       if( refitem.codeMeaning() != testitem.codeMeaning()) {
          cout << "Non-DICOM Output code meanings do not match.\n";
          cout << "Master value: " << refitem.codeMeaning() << "\n";
          cout << "Test value: " << testitem.codeMeaning() << "\n";
          rtnStatus = 1;
       }
       if( refitem.codeSchemeDesignator() != testitem.codeSchemeDesignator()) {
          cout << "Non-DICOM Output code schemes do not match.\n";
          cout << "Master value: " << refitem.codeSchemeDesignator() << "\n";
          cout << "Test value: " << testitem.codeSchemeDesignator() << "\n";
          rtnStatus = 1;
       }
       if( verbose) {
          cout << "  Non-DICOM Output code items match.\n";
          cout << "  value: " << testitem.codeValue() << "\n";
          cout << "  scheme: " << testitem.codeSchemeDesignator() << "\n";
          cout << "  meaning: " << testitem.codeMeaning() << "\n";
       }
    }
  }

  return rtnStatus;
}


static void
usageerror()
{
    char msg[] = "\
Usage: evaluate_gppps [-v] <test file> <master file> \n\
\n\
    -v              Verbose mode\n\
\n\
    <test file>     File to be tested\n\
    <master file>   File considered to be \"gold standard\" ";

    cerr << msg << endl;
    ::exit(1);
}

/*
 * Known problems:
 * 1. Missing evaluation for Referenced Request Sequence.
 * 2. Some 0..n item sequences are treated as single valued
 *    (Actual Human Performer Seq, others?)
 */
int main(int argc, char **argv)
{
  CONDITION cond;
  bool verbose = FALSE;
  int rtnStatus = 0;

  while (--argc > 0 && (*++argv)[0] == '-') {
    switch (*(argv[0] + 1)) {
    case 'v':
      verbose = true;
      break;
    default:
      break;
    }
  }

  ::THR_Init();
  if (argc != 2)
    usageerror();

  MDICOMWrapper wrapperTest;
  if( wrapperTest.open(*argv) != 0) {
     cout << "Input file for test object does not exist: " << *argv << endl;
     exit(1);
  }
  //MDICOMWrapper wrapperTest(*argv);

  argv++;
  MDICOMWrapper wrapperStd;
  if( wrapperStd.open(*argv) != 0) {
     cout << "Input file for standard object does not exist: " << *argv << endl;
     exit(1);
  }
  //MDICOMWrapper wrapperStd(*argv);

  // This is missing evaluation of Referenced Request Sequence.

  if (evaluatePatientIdentification(wrapperTest, wrapperStd, verbose) != 0)
    rtnStatus += 1;

  if (evaluatePatientDemographic(wrapperTest, wrapperStd, verbose) != 0)
    rtnStatus += 1;

  if (evaluatePatientMedical(wrapperTest, wrapperStd, verbose) != 0)
    rtnStatus += 1;

  if (evaluatePPSInformation(wrapperTest, wrapperStd, verbose) != 0)
    rtnStatus += 1;

  if (evaluateRefGPSPS(wrapperTest, wrapperStd, verbose) != 0)
    rtnStatus += 1;

  if (evaluateActualHumanPerformer(wrapperTest, wrapperStd, verbose) != 0)
    rtnStatus += 1;

  if (evaluatePerformedStationNameCodeSeq(wrapperTest,wrapperStd, verbose) != 0)
    rtnStatus += 1;

  if (evaluatePerformedStationClassCodeSeq(wrapperTest,wrapperStd,verbose) != 0)
    rtnStatus += 1;

  if (evaluatePerformedStationLocationCodeSeq(wrapperTest, wrapperStd, verbose) != 0)
    rtnStatus += 1;

  if (evaluatePerformedProcessingAppCodeSeq(wrapperTest, wrapperStd, verbose) != 0)
    rtnStatus += 1;

  if (evaluatePerformedWorkitemCodeSeq(wrapperTest, wrapperStd, verbose) != 0)
    rtnStatus += 1;

  if (evaluateOutputInfoSeq(wrapperTest, wrapperStd, verbose) != 0)
    rtnStatus += 1;

  if (evaluateReqSubsequentWorkitemCodeSeq(wrapperTest, wrapperStd, verbose) != 0)
    rtnStatus += 1;

  if (evaluateNonDICOMOutputCodeSeq(wrapperTest, wrapperStd, verbose) != 0)
    rtnStatus += 1;

  return rtnStatus;
}

