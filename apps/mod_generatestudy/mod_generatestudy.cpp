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

static char rcsid[] = "$Revision: 1.60 $ $RCSfile: mod_generatestudy.cpp,v $";

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

//#ifdef _MSC_VER
//#include <io.h>
//#include <winsock.h>
//#else
//#include <unistd.h>
//#include <sys/file.h>
//#endif
//#include <sys/types.h>
//#include <sys/stat.h>

#include "MESA.hpp"
#include "ctn_api.h"
#include "MDBInterface.hpp"
#include "MDBModality.hpp"
#include "MMWL.hpp"
#include "MDICOMWrapper.hpp"
#include "MCompositeObjectFactory.hpp"
#include "MPPSAssistant.hpp"

#include "MFileOperations.hpp"

typedef vector < MString > MStringVector;
typedef set < MString > MStringSet;
typedef map < MString, MString, less<MString> > MStringMap;
typedef multimap < MString, MString, less<MString> > MStringMultiMap;

static void usageerror();

static void findExistingSeries(MStringVector& v,
			       MStringSet& s)
{
  MFileOperations f;
  for (MStringVector::iterator vi = v.begin();
       vi != v.end();
       vi++) {
    if (f.isDirectory(*vi))
      continue;

    MDICOMWrapper w(*vi);

    MString series = w.getString(DCM_RELSERIESINSTANCEUID);
    s.insert(series);
  }
}

static MString
getPatientID(const char* patfileName)
{
  if (patfileName == 0) {
    cout << "patfileName is NULL in getPatientID" << endl;
    exit(1);
  }

  MDICOMWrapper w(patfileName);
  MString s = w.getString(DCM_PATID);

  return s;
}

static void checkParams(const char* patientID,
			const char* mwlDirectory,
			const char* imageDirectory,
			const char* targetDirectory)
{
  if (patientID == 0) {
     cout << "This program requires the -p flag for a patient ID" << endl;
     exit(1);
  }
  if (imageDirectory == 0) {
     cout << "This program requires the -i flag for Image directory" << endl;
     exit(1);
  }
  if (targetDirectory == 0) {
     cout << "This program requires the -t flag for target directory" << endl;
     exit(1);
  }
}

MString
getMatchingMWL(const MString& patientID,
	       const MString& actionItemCode,
	       const MString& mwlDirectory)
{
  char directory[1024];
  MFileOperations f;
  char tmp[1024];

  mwlDirectory.safeExport(directory, sizeof(directory));
  int index = 0;

  cout << "Directory: " << mwlDirectory << endl;

  f.scanDirectory(mwlDirectory);
  int count = f.filesInDirectory();

  for (index = 0; index < count; index++) {
    MString fileName = mwlDirectory + MString("/") + f.fileName(index);
    if (f.isDirectory(fileName))
      continue;

    MDICOMWrapper mwl(fileName);
    MString x = mwl.getString(DCM_PATID);
    x.safeExport(tmp, sizeof(tmp));

    MString pid = mwl.getString(DCM_PATID);
    cout << fileName << ":" << pid << ":" << patientID << ":" << endl;
    if (mwl.getString(DCM_PATID) != patientID) {
      cout << "MWL Patient ID does not match" << endl;
      cout << "Expected patient ID: <" << patientID << "> Worklist PID <" << x << "> filename: " << fileName << endl;
      continue;
    }

    DCM_OBJECT* obj = mwl.getNativeObject();
    LST_HEAD* l1 = 0;
    CONDITION cond = ::DCM_GetSequenceList(&obj,
					   DCM_PRCSCHEDULEDPROCSTEPSEQ,
					   &l1);
    if (cond != DCM_NORMAL) {
      cout << "Could not get 0040 0100 Scheduled Procedure Step Seq from MWL"
	   << endl;
      cout << fileName << endl;
      ::COND_DumpConditions();
      exit(1);
    }

    DCM_SEQUENCE_ITEM* sqItem = (DCM_SEQUENCE_ITEM*) ::LST_Head(&l1);
    if (sqItem == 0) {
      cout << "Could not get 0040 0100 Scheduled Procedure Step Seq from MWL"
	   << endl;
      cout << fileName << endl;
      ::COND_DumpConditions();
      exit(1);
    }

    MDICOMWrapper w1(sqItem->object);
    MString codeString;

    int index = 1;
    while ((codeString = w1.getString(DCM_PRCSCHEDULEDACTIONITEMCODESEQ,
				       DCM_IDCODEVALUE,
				       index++)) != "") {
      codeString.safeExport(tmp, sizeof(tmp));
      cout << "Expected protocol code item: <" << actionItemCode << "> Worklist code item <" << codeString << "> filename: " << fileName << endl;
      if (codeString == actionItemCode) {
	return fileName;
      } else {
	cout << "mod_generate_study rejected MWL response (file name:expected code:code in MWL) "
	<< fileName << ":" << actionItemCode << ":" << codeString << endl;
      }
    }
  }

  cout << "getMatchingMWL:: no patient ID/code items in MWL matched expected values." << endl;
  return "";
}

typedef struct {
  DCM_TAG t1;
  DCM_TAG t2;
} TAG_PAIR;

typedef struct {
  DCM_TAG t1;
  char txt[1024];
} TAG_TEXT;

static void
addPPSInformationNCreate(MDICOMWrapper& mwlWrapper,
			 MDICOMWrapper& ncreateWrapper,
			 MDBModality& modalityDB,
			 int useProcedureCode)
{
  MString s;

  s = modalityDB.newProcedureStepID();
  ncreateWrapper.setString(DCM_PRCPPSID, s);

  TAG_PAIR t0[] = {
    { DCM_PRCSCHEDULEDSTATIONAETITLE, DCM_PRCPERFORMEDSTATIONAET },
    { DCM_PRCSCHEDULEDSTATIONNAME, DCM_PRCPERFORMEDSTATIONNAME },
    { 0, 0 }
  };

  int i = 0;
  for (i = 0; t0[i].t1 != 0; i++) {
    s = mwlWrapper.getString(DCM_PRCSCHEDULEDPROCSTEPSEQ, t0[i].t1);
    ncreateWrapper.setString(t0[i].t2, s);
  }

  TAG_TEXT t1[] = {
    { DCM_PRCPERFORMEDLOCATION, "" },
    { DCM_PRCPPSSTARTDATE, "" },
    { DCM_PRCPPSSTARTTIME, "" },
    { DCM_PRCPPSSTATUS, "" },
    { DCM_PRCPPSDESCRIPTION, "" },
    { DCM_PRCPPTYPEDESCRIPTION, "" },
    { DCM_PRCPPSENDDATE, "" },
    { DCM_PRCPPSENDTIME, "" },
    { 0, 0 }
  };

  ::UTL_GetDicomDate(t1[1].txt);
  ::UTL_GetDicomTime(t1[2].txt); t1[2].txt[6] = '\0';
  ::strcpy(t1[3].txt, "IN PROGRESS");

  for (i = 0; t1[i].t1 != 0; i++) {
    ncreateWrapper.setString(t1[i].t1, t1[i].txt);
  }

  DCM_TAG t2[] = { DCM_IDCODEVALUE,
	       DCM_IDCODINGSCHEMEDESIGNATOR,
	       DCM_IDCODEMEANING,
	       0
  };

  if (useProcedureCode) {
    MString x;
    for (i = 0; t2[i] != 0; i++) {
      x = mwlWrapper.getString(DCM_SDYREQUESTEDPROCODESEQ, t2[i]);
      ncreateWrapper.setString(DCM_IDPROCEDURECODESEQUENCE, t2[i], x);
    }
  } else {
    ncreateWrapper.createSequence(DCM_IDPROCEDURECODESEQUENCE);
  }
  MString specificCharacterSet = mwlWrapper.getString(0x00080005);
  if (specificCharacterSet != "") {
    ncreateWrapper.setString(0x00080005, specificCharacterSet);
  }

#if 0
  LST_HEAD* l3 = ::LST_Create();
  DCM_ELEMENT e = { DCM_IDPROCEDURECODESEQUENCE, DCM_SQ, "", 1, 0, 0 };
  e.d.sq = l3;
  DCM_OBJECT* nativeObject = ncreateWrapper.getNativeObject();
  ::DCM_AddSequenceElement(&nativeObject, &e);
#endif
}

static void
updatePPSInformationNCreate(MDICOMWrapper& mwlWrapper,
			    MDICOMWrapper& ncreateWrapper,
			    MDBModality& modalityDB,
			    int useProcedureCode)
{
  MString s;

  DCM_TAG t2[] = { DCM_IDCODEVALUE,
	       DCM_IDCODINGSCHEMEDESIGNATOR,
	       DCM_IDCODEMEANING,
	       0
  };

  MString requestedProcedureCode =
	mwlWrapper.getString(DCM_SDYREQUESTEDPROCODESEQ, DCM_IDCODEVALUE);
  int idx = 1;
  MString existingCode = "";
  do {
    existingCode =
	ncreateWrapper.getString(DCM_IDPROCEDURECODESEQUENCE, DCM_IDCODEVALUE, idx);
    if (existingCode == requestedProcedureCode) {
      return;
    } else if (existingCode != "") {
      idx++;
    }
  } while (existingCode != "");

  if (useProcedureCode) {
    MString x;
    int i = 0;
    for (i = 0; t2[i] != 0; i++) {
      x = mwlWrapper.getString(DCM_SDYREQUESTEDPROCODESEQ, t2[i]);
      ncreateWrapper.setString(DCM_IDPROCEDURECODESEQUENCE, t2[i], x, idx);
    }
  }
}


static void
addImageAcquistionResultsNCreate(MDICOMWrapper& mwlWrapper,
				 MDICOMWrapper& ncreateWrapper,
				 MDBModality& modalityDB,
				 const MString& modality,
				 const MString& studyID)
{
  MString s;

  s = modality;
  if (s == "")
    s = mwlWrapper.getString(DCM_PRCSCHEDULEDPROCSTEPSEQ, DCM_IDMODALITY);
  ncreateWrapper.setString(DCM_IDMODALITY, s);

  s = (studyID == "") ? mwlWrapper.getString(DCM_PRCREQUESTEDPROCEDUREID) : studyID;
  ncreateWrapper.setString(DCM_RELSTUDYID, s);

  DCM_OBJECT* nativeObject = ncreateWrapper.getNativeObject();

  {
    LST_HEAD* l3 = ::LST_Create();
    DCM_ELEMENT e = { DCM_PRCPERFORMEDAISEQUENCE, DCM_SQ, "", 1, 0, 0 };
    e.d.sq = l3;
    ::DCM_AddSequenceElement(&nativeObject, &e);
  }

  {
    LST_HEAD* l4 = ::LST_Create();
    DCM_ELEMENT e4 = { DCM_PRCPERFORMEDSERIESSEQ, DCM_SQ, "", 1, 0, 0 };
    e4.d.sq = l4;
    ::DCM_AddSequenceElement(&nativeObject, &e4);
  }
}

// These functions are for the MPPS N-Set commands

static void addPPSRelationshipNSet(MDICOMWrapper& nsetWrapper)
{
  TAG_TEXT t1[] = {
    { DCM_PRCPPSENDDATE, "" },
    { DCM_PRCPPSENDTIME, "" },
    { 0, 0 }
  };
  int i;

  ::UTL_GetDicomDate(t1[0].txt);
  ::UTL_GetDicomTime(t1[1].txt); t1[1].txt[6] = '\0';

  for (i = 0; t1[i].t1 != 0; i++) {
    nsetWrapper.setString(t1[i].t1, t1[i].txt);
  }
}

typedef struct {
  char* c1;
  char* c2;
} TEXT_PAIR;

static void initializePerformedCodeMap(MStringMultiMap& m)
{
  TEXT_PAIR p[] = {
    { "X1",  "X1_A1^SP Action Item X1_A1^DSS_MESA" },
    { "X2",  "X2_A1^SP Action Item X2_A1^DSS_MESA" },
    { "X3",  "X3A_A1^SP Action Item X3A_A1^DSS_MESA" },
    { "X3",  "X3B_A1^SP Action Item X3B_A1^DSS_MESA" },
    { "X4A", "X4A_A1^SP Action Item X4A_A1^DSS_MESA" },
    { "X4B", "X4B_A1^SP Action Item X4B_A1^DSS_MESA" },
    { "X4B", "X4B_A2^SP Action Item X4B_A2^DSS_MESA" },
    { "X5",  "X5_A1^SP Action Item X5_A1^DSS_MESA" },
    { "X5A",  "X5A_A1^SP Action Item X5A_A1^DSS_MESA" },
    { "X6",  "X6_A1^SP Action Item X6_A1^DSS_MESA" },
    { "X7",  "X7_A1^SP Action Item X7_A1^DSS_MESA" },
    { "X6-7",  "X6_A1^SP Action Item X6_A1^DSS_MESA" },
    { "X6-7",  "X7_A1^SP Action Item X7_A1^DSS_MESA" },
    { "X8A",  "X8A_A1^SP Action Item X8A_A1^DSS_MESA" },
    { "X8B",  "X8B_A1^SP Action Item X8B_A1^DSS_MESA" },
    { "X10", "X10_A1^SP Action Item X10_A1^DSS_MESA" },
    { "X11", "X11_A1^SP Action Item X11_A1^DSS_MESA" },
    { "X12", "X12_A1^SP Action Item X12_A1^DSS_MESA" },
    { "X20", "X20_A1^SP Action Item X20_A1^DSS_MESA" },
    { "X21", "X21_A1^SP Action Item X21_A1^DSS_MESA" },
    { "X22", "X22_A1^SP Action Item X22_A1^DSS_MESA" },
    { "X23", "X23_A1^SP Action Item X23_A1^DSS_MESA" },
    { "X101", "X101_A1^SP X101 MG Screening^DSS_MESA" },
    { "X102", "X102_A1^SP Action Item X102_A1^DSS_MESA" },
    { "GX.01.00", "GX.01.00_PC1^GX.01.00 Protocol Code Item 1^DSS_MESA" },
    { "GX.01.01", "GX.01.01_PC1^GX.01.01 Protocol Code Item 1^DSS_MESA" },
    { "XA.02.00", "XA.02.00_PC1^XA.02.00 Protocol Code Item 1^DSS_MESA" },
    { "XA.02.00", "XA.02.00_PC2^XA.02.00 Protocol Code Item 2^DSS_MESA" },
    { "NM.02.00", "NM.02.00_PC1^NM.02.00 Protocol Code Item 1^DSS_MESA" },
    { "X6-NM.02.00",  "X6_A1^SP Action Item X6_A1^DSS_MESA" },
    { "X6-NM.02.00",  "NM.02.00_PC1^NM.02.00 Protocol Code Item 1^DSS_MESA" },
    { "MR.01.00", "MR.01.00_PC1^MR.01.00 Protocol Code Item 1^DSS_MESA" },
    { "18-5002",  "18-5002^Lung CT^HL7IHE" },
    { "18-5022",  "18-5022^Chest PA^HL7IHE" },
    { "YY-20011", "XX-20011^Left Heart Cath^DSS_MESA" },
    { "YY-20012", "XX-20012^Left Heart Cath^DSS_MESA" },
    { "YY-20013", "XX-20013^Left Heart Cath^DSS_MESA" },
    { "YY-20013INT", "XX-20013INT^Left Heart Cath-Interventional^DSS_MESA" },
    { "YY-20021", "XX-20021^TTE^DSS_MESA" },
    { "YY-20031", "XX-20031^Stress Echo^DSS_MESA" },
    { "18-6000", "18-6000^MRI: CARDIAC^ERL_MESA" },
    { "P2-7131C", "P2-7131C^Balke protocol^SRT" },
    { "CT Exam", "CT Exam^CT Thorax w/ Contrast^CERNER" },
    { "911060", "911060^MR: Cardiac^IHEDEMO" },
    { "912050", "912050^MR: Back^IHEDEMO" },
    { "12050", "12050^MR: Back^IHEDEMO" },
    { "XEYE_200", "EYE_PC_200^Protocol Code Item: Eye Care 200^IHEDEMO" },
    { "XEYE_201", "EYE_PC_201^Protocol Code Item: Eye Care 201^IHEDEMO" },
    { "XEYE_2001", "1^Lids Photo - OD^99AAODemo" },
    { "XEYE_2002", "2^Lids Photo - OS^99AAODemo" },
    { "XEYE_2003", "3^Iris Photo - OD^99AAODemo" },
    { "XEYE_2004", "4^Iris Photo - OS^99AAODemo" },
    { "XEYE_2005", "5^Cornea Photo - OD^99AAODemo" },
    { "XEYE_2006", "6^Cornea Photo - OS^99AAODemo" },
    { "XEYE_3001", "7^30 Deg Center On Disk - OD^99AAODemo" },
    { "XEYE_3002", "8^30 Deg Center On Disk - OS^99AAODemo" },
    { "XEYE_3003", "9^45 Deg Center On Disk & Macula - OD^99AAODemo" },
    { "XEYE_3004", "10^45 Deg Center On Disk & Macula - OS^99AAODemo" },
    { "XEYE_3005", "11^Red Free - OD^99AAODemo" },
    { "XEYE_3006", "12^Red Free - OS^99AAODemo" },
    { "XEYE_4001", "13^Macula - OD^99AAODemo" },
    { "XEYE_4002", "14^Macula - OS^99AAODemo" },
    { "XEYE_4003", "15^Macula - OU^99AAODemo" },

    { 0, 0 }
  };
  int i;

  for (i = 0; p[i].c1 != 0; i++) {
    pair<MString, MString> p2(p[i].c1, p[i].c2);
    m.insert(p2);
  }
}

static void
addPerformedAICodeSeq(MDICOMWrapper& nsetWrapper, const MString& performedCode)
{
  MStringMultiMap m1;
  initializePerformedCodeMap(m1);


  LST_HEAD* l1 = ::LST_Create();

  MStringMultiMap::iterator i1 = m1.find(performedCode);
  while ((*i1).first == performedCode) {

    MString code = (*i1).second;
    MString codeValue = code.getToken('^', 0);
    MString codeMeaning = code.getToken('^', 1);
    MString codeDesignator = code.getToken('^', 2);

    DCM_SEQUENCE_ITEM* seqItem = (DCM_SEQUENCE_ITEM*)malloc(sizeof(*seqItem));
    ::DCM_CreateObject(&seqItem->object, 0);
    MDICOMWrapper codeWrapper(seqItem->object);
    codeWrapper.setString(DCM_IDCODEVALUE, codeValue);
    codeWrapper.setString(DCM_IDCODEMEANING, codeMeaning);
    codeWrapper.setString(DCM_IDCODINGSCHEMEDESIGNATOR, codeDesignator);

    ::LST_Enqueue(&l1, seqItem);

    i1++;

    if (i1 == m1.end())
      break;
  }

  DCM_ELEMENT e = { DCM_PRCPERFORMEDAISEQUENCE, DCM_SQ, "", 1, 0, 0 };
  e.d.sq = l1;

  DCM_OBJECT* obj = nsetWrapper.getNativeObject();
  ::DCM_AddSequenceElement(&obj, &e);
}

static void
addPPSDescription(MDICOMWrapper& nsetWrapper, const MString& performedCode)
{
  MStringMultiMap m1;
  initializePerformedCodeMap(m1);

  LST_HEAD* l1 = ::LST_Create();

  MStringMultiMap::iterator i1 = m1.find(performedCode);
  while ((*i1).first == performedCode) {

    MString code = (*i1).second;
    MString codeValue = code.getToken('^', 0);
    MString codeMeaning = code.getToken('^', 1);
    MString codeDesignator = code.getToken('^', 2);
    nsetWrapper.setString(DCM_PRCPPSDESCRIPTION,
	"PPS description: " + codeMeaning);

    i1++;
    if (i1 == m1.end())
      break;
  }
}

typedef struct {
  char *code;
  char *designator;
  char *meaning;
} CODE_MAP;

static void
addDiscontinueCode(MDICOMWrapper& nsetWrapper, const MString& discontinueCode)
{
  if (discontinueCode == "")
    return;

  TEXT_PAIR p[] = {
	{ "110500", "Doctor cancelled procedure" },
	{ "110501", "Equipment failure" },
	{ "110502", "Incorrect procedure ordered" },
	{ "110503", "Patient allergic to media/contrast" },
	{ "110504", "Patient died" },
	{ "110505", "Patient refused to continue procedure" },
	{ "110506", "Patient taken for treatment or surgery" },
	{ "110507", "Patient did not arrive" },
	{ "110508", "Patient pregnant" },
	{ "110509", "Change of procedure for correct charging" },
	{ "110510", "Duplicate order" },
	{ "110511", "Nursing unit cancel" },
	{ "110512", "Incorrect side ordered" },
	{ "110513", "Discontinued for unspecified reason" },
	{ "110514", "Incorrect worklist entry selected" }
  };
  int i;
  for (i = 0; i < (int)DIM_OF(p); i++) {
    if (discontinueCode == p[i].c1) {
      nsetWrapper.setString(0x00400281, DCM_IDCODEVALUE, p[i].c1);
      nsetWrapper.setString(0x00400281, DCM_IDCODEMEANING, p[i].c2);
      nsetWrapper.setString(0x00400281, DCM_IDCODINGSCHEMEDESIGNATOR, "DCM");
      return;
    }
  }
  cout << "mod_generatestudy:addDiscontinueCode" << endl;
  cout << " Caller asked to add a code with value <" << discontinueCode << ">" << endl;
  cout << " That does not match any values in our table; exiting" << endl;
  ::exit(1);
}

static void
addPerformedSeriesSequence(const MString& targetDirectory)
{
  MPPSAssistant assistant;

  MFileOperations f;

  f.scanDirectory(targetDirectory);

  int count = f.filesInDirectory();
  int index = 0;

  MString nsetFile = targetDirectory + "/mpps.set";

  MStringVector imNames;
  for (index = 0; index < count; index++) {
    MString fileName = f.fileName(index);

    if (!fileName.tokenExists('.', 1))
      continue;
    if (fileName.getToken('.', 1) != "dcm")
      continue;

    MString f1 = targetDirectory + "/" + fileName;

    assistant.addPerformedSeriesSequence(nsetFile, f1);
  }
}

// These are the functions for updating Image IODs
int
countReferencedStudies(MDICOMWrapper& ncreateWrapper)
{
  int i = 1;
  MStringMap m;
  while (1) {
    MDICOMWrapper* w = ncreateWrapper.getSequenceWrapper(0x00400270, i);
    if (w == 0)
      break;

    MString x = w->getString(0x00081110, 0x00081155);
    cout << "Referenced Study: " << x << endl;
    m[x] = x;
    i++;
  }
  cout << "Map size: " << m.size() << endl;
  return m.size();;
}

static void updateImageIOD(MDICOMWrapper& mwlWrapper,
			   MDICOMWrapper& ncreateWrapper,
			   const MString& protocolName,
			   const MString& ppsUID,
			   const MString& studyInstanceUID,
			   const MString& studyID,
			   bool zeroLengthAccessionNumber,
			   MDICOMWrapper& imageIODWrapper)
{
  DCM_TAG t0[] = {
    DCM_RELSTUDYINSTANCEUID,
    DCM_IDACCESSIONNUMBER,
    DCM_PATNAME,
    DCM_PATID,
    0x00100021,
    DCM_PATBIRTHDATE,
    DCM_PATSEX,
    DCM_IDREFERRINGPHYSICIAN,
    0
  };

  imageIODWrapper.importAttributes(mwlWrapper, t0);
  if (studyInstanceUID != "") {
    imageIODWrapper.setString(DCM_RELSTUDYINSTANCEUID, studyInstanceUID);
  }
  if (zeroLengthAccessionNumber) {
    imageIODWrapper.setString(DCM_IDACCESSIONNUMBER, "");
  }

  TAG_PAIR t1[] = {
    { DCM_IDREFERENCEDSTUDYSEQ, DCM_IDREFERENCEDSOPCLASSUID },
    { DCM_IDREFERENCEDSTUDYSEQ, DCM_IDREFERENCEDSOPINSTUID },
    { 0, 0 }
  };
  int i;
  MString s;

  int refStudyCount = countReferencedStudies(ncreateWrapper);

  if (refStudyCount == 1) {	// Just get the info from MWL
    for (i = 0; t1[i].t1 != 0; i++) {
      s = mwlWrapper.getString(t1[i].t1, t1[i].t2);
      if (s != "")
	imageIODWrapper.setString(t1[i].t1, t1[i].t2, s);
    }
  } else {			// Pick it up from the MPPS N-Create
    i = 1;
    while (1) {
      MDICOMWrapper* w = ncreateWrapper.getSequenceWrapper(0x00400270, i);
      if (w == 0)
      break;

      MString x;
      x = w->getString(0x00081110, 0x00081150);
      imageIODWrapper.setString(0x00081110, 0x00081150, x, i);
      x = w->getString(0x00081110, 0x00081155);
      imageIODWrapper.setString(0x00081110, 0x00081155, x, i);
      i++;
    }
  }


  DCM_TAG t2[] = {
    DCM_IDMODALITY,
    DCM_RELSTUDYID,
    DCM_PRCPPSID,
    DCM_PRCPPSSTARTDATE,
    DCM_PRCPPSSTARTTIME,
    DCM_PRCPPSDESCRIPTION,
    0
  };

  imageIODWrapper.importAttributes(ncreateWrapper, t2);
  if (studyID != "") {
    imageIODWrapper.setString(DCM_RELSTUDYID, studyID);
  }

  TAG_PAIR t3[] = {
    { DCM_PRCPPSSTARTDATE, DCM_IDSTUDYDATE },
    { DCM_PRCPPSSTARTTIME, DCM_IDSTUDYTIME },
    { DCM_PRCPPSSTARTDATE, DCM_IDSERIESDATE },
    { DCM_PRCPPSSTARTTIME, DCM_IDSERIESTIME },
    { DCM_PRCPPSSTARTDATE, DCM_IDIMAGEDATE },
    { DCM_PRCPPSSTARTTIME, DCM_IDIMAGETIME },
    { 0, 0 }
  };
  for (i = 0; t3[i].t1 != 0; i++) {
    s = ncreateWrapper.getString(t3[i].t1);
    imageIODWrapper.setString(t3[i].t2, s);
  }

  imageIODWrapper.setString(DCM_ACQPROTOCOLNAME, protocolName);

  imageIODWrapper.setString(DCM_IDREFERENCEDSTUDYCOMPONENTSEQ,
		DCM_IDREFERENCEDSOPCLASSUID, DICOM_SOPCLASSMPPS);
  imageIODWrapper.setString(DCM_IDREFERENCEDSTUDYCOMPONENTSEQ,
		DCM_IDREFERENCEDSOPINSTUID, ppsUID);

  MString specificCharacterSet = mwlWrapper.getString(0x00080005);
  if (specificCharacterSet != "") {
    imageIODWrapper.setString(0x00080005, specificCharacterSet);
  }
}

static void
newSOPInstanceUID(MDICOMWrapper& w, MDBModality& modalityDB)
{
  MString uid = modalityDB.newSOPInstanceUID();
  w.setString(DCM_IDSOPINSTANCEUID, uid);
}

static void setRequestAttributesSequence(MDICOMWrapper& w,
					 MDICOMWrapper& mwl)
{
  // Make sure the sequence exists in the output
  DCM_OBJECT* wNative = w.getNativeObject();
  LST_HEAD* l0 = 0;
  CONDITION cond = ::DCM_GetSequenceList(&wNative,
					 DCM_PRCREQUESTATTRIBUTESSEQ,
					 &l0);
  if (cond != DCM_NORMAL) {
    ::COND_PopCondition(TRUE);
    w.createSequence(DCM_PRCREQUESTATTRIBUTESSEQ);
  }

  DCM_SEQUENCE_ITEM* item = (DCM_SEQUENCE_ITEM*) ::malloc(sizeof(*item));
  ::DCM_CreateObject(&item->object, 0);
  MDICOMWrapper itemWrapper(item->object);


  // Set several text values in the output sequence item
  MString s;

  s = mwl.getString(DCM_PRCREQUESTEDPROCEDUREID);
  itemWrapper.setString(DCM_PRCREQUESTEDPROCEDUREID,
			s);

  s = mwl.getString(DCM_PRCSCHEDULEDPROCSTEPSEQ,
		    DCM_PRCSCHEDULEDPROCSTEPID);
  itemWrapper.setString(DCM_PRCSCHEDULEDPROCSTEPID,
			s);

  s = mwl.getString(DCM_PRCSCHEDULEDPROCSTEPSEQ,
		    DCM_PRCSCHEDULEDPROCSTEPDESCRIPTION);
  itemWrapper.setString(DCM_PRCSCHEDULEDPROCSTEPDESCRIPTION,
			s);

  // Add scheduled action item codes to output
  DCM_OBJECT* mwlNative = mwl.getNativeObject();
  LST_HEAD* l1 = 0;
  cond = ::DCM_GetSequenceList(&mwlNative,
			       DCM_PRCSCHEDULEDPROCSTEPSEQ,
			       &l1);
  DCM_SEQUENCE_ITEM* sqItem = (DCM_SEQUENCE_ITEM*) ::LST_Head(&l1);

  LST_HEAD* l2 = 0;
  cond = ::DCM_GetSequenceList(&sqItem->object,
			       DCM_PRCSCHEDULEDACTIONITEMCODESEQ,
			       &l2);

  DCM_SEQUENCE_ITEM* item2 = (DCM_SEQUENCE_ITEM*) ::LST_Head(&l2);
  ::LST_Position(&l2, item2);

  LST_HEAD* l3 = ::LST_Create();

  while (item2 != 0) {
    DCM_SEQUENCE_ITEM* item3 = (DCM_SEQUENCE_ITEM*) ::malloc(sizeof(*item3));
    ::DCM_CopyObject(&item2->object, &item3->object);
    ::LST_Enqueue(&l3, item3);

    item2 = (DCM_SEQUENCE_ITEM*) ::LST_Next(&l2);
  }

  DCM_ELEMENT e1 = { DCM_PRCSCHEDULEDACTIONITEMCODESEQ, DCM_SQ, "", 1, 0, 0};
  e1.d.sq = l3;
  cond = ::DCM_AddSequenceElement(&item->object, &e1);

  LST_HEAD* l4 = 0;
  cond = ::DCM_GetSequenceList(&wNative,
			       DCM_PRCREQUESTATTRIBUTESSEQ,
			       &l4);

  ::LST_Enqueue(&l4, item);

#if 0
  DCM_SEQUENCE_ITEM* item4 = (DCM_SEQUENCE_ITEM*) ::LST_Head(&l4);
  DCM_ELEMENT e1 = { DCM_PRCSCHEDULEDACTIONITEMCODESEQ, DCM_SQ, "", 1, 0, 0};
  e1.d.sq = l3;
  cond = ::DCM_AddSequenceElement(&item4->object, &e1);
#endif

}


static MString
copyUIDFromImage(const MString& imageDirectory)
{
  MString fileName = imageDirectory + MString("/x1.dcm");

  MDICOMWrapper w;
  int rslt = w.open(fileName);
  if (rslt != 0) {
    cout << "Could not open file to get Stu Ins UID: " << fileName << endl;
    ::exit(1);
  }

  MString s = w.getString(0x0020000D);

  return s;
}


#if 0
static void
produceImages(MDICOMWrapper& mwlWrapper, MDICOMWrapper& ncreateWrapper,
	      const MString& protocolName,
	      const MString& ppsUID,
	      const MString& studyInstanceUID,
	      const MString& studyID,
	      bool zeroLengthAccessionNumber,
	      int fillRequestAttributesSequence,
	      MDBModality& modalityDB,
	      const MString& imageDirectory,
	      const MString& targetDirectory)
{
  MFileOperations f;

  f.scanDirectory(imageDirectory);

  int count = f.filesInDirectory();
  int index = 0;

  // Build a list of file names for images in this group
  MStringVector imNames;
  for (index = 0; index < count; index++) {
    MString fileName = imageDirectory + "/" + f.fileName(index);
    if (f.isDirectory(fileName))
      continue;

    imNames.push_back(fileName);
  }

  MStringSet s;
  findExistingSeries(imNames, s);

  MStringMap seriesMap;

  for (MStringSet::iterator s1 = s.begin();
       s1 != s.end();
       s1++) {
    MString seriesUID = modalityDB.newSeriesInstanceUID();
    seriesMap[*s1] = seriesUID;
  }

  int imageCount = 0;
  for (index = 0; index < count; index++) {
    MString fileName = imageDirectory + "/" + f.fileName(index);
    if (f.isDirectory(fileName))
      continue;

    MDICOMWrapper w(fileName);

    updateImageIOD(mwlWrapper, ncreateWrapper, protocolName, ppsUID,
	    studyInstanceUID, studyID, zeroLengthAccessionNumber, w);

    MString seriesUID = w.getString(DCM_RELSERIESINSTANCEUID);
    MString newSeriesUID = seriesMap[seriesUID];
    w.setString(DCM_RELSERIESINSTANCEUID, newSeriesUID);

    newSOPInstanceUID(w, modalityDB);

    MString outputFile = targetDirectory + "/" + f.fileName(index);
    if (index == (count-1))
      outputFile = targetDirectory + "/" + "x1.dcm";

    if (fillRequestAttributesSequence)
      setRequestAttributesSequence(w, mwlWrapper);

    unsigned long options = w.getFileOptions();
    w.saveAs(outputFile, options);
    imageCount++;
  }

  if (imageCount == 0) {
    cout << "mod_generatestudy: no images found in "
	 << imageDirectory << endl;
    cout << "This is a fatal error" << endl;
    ::exit(1);
  }
}
#endif

static void
produceImages(MStringVector& mwlVector,
	      MDICOMWrapper& ncreateWrapper,
	      const MString& protocolName,
	      const MString& ppsUID,
	      const MString& studyInstanceUID,
	      const MString& studyID,
	      bool zeroLengthAccessionNumber,
	      int fillRequestAttributesSequence,
	      MDBModality& modalityDB,
	      const MString& imageDirectory,
	      const MString& targetDirectory)
{
  MFileOperations f;

  f.scanDirectory(imageDirectory);

  int count = f.filesInDirectory();
  int index = 0;

  // Build a list of file names for images in this group
  MStringVector imNames;
  for (index = 0; index < count; index++) {
    MString fileName = imageDirectory + "/" + f.fileName(index);

    imNames.push_back(fileName);
  }

  MStringSet s;
  findExistingSeries(imNames, s);

  MStringMap seriesMap;

  for (MStringSet::iterator s1 = s.begin();
       s1 != s.end();
       s1++) {
    MString seriesUID = modalityDB.newSeriesInstanceUID();
    seriesMap[*s1] = seriesUID;
  }

  MString firstMWLFile = mwlVector[0];
  MDICOMWrapper firstMWL(firstMWLFile);

  int imageCount = 0;
  for (index = 0; index < count; index++) {
    MString fileName = imageDirectory + "/" + f.fileName(index);

    if (f.isDirectory(fileName))
      continue;

    MDICOMWrapper w(fileName);

    updateImageIOD(firstMWL, ncreateWrapper, protocolName, ppsUID,
	    studyInstanceUID, studyID, zeroLengthAccessionNumber, w);

    MString seriesUID = w.getString(DCM_RELSERIESINSTANCEUID);
    MString newSeriesUID = seriesMap[seriesUID];
    w.setString(DCM_RELSERIESINSTANCEUID, newSeriesUID);

    newSOPInstanceUID(w, modalityDB);

    MString outputFile = targetDirectory + "/" + f.fileName(index);
    if (index == (count-1))
      outputFile = targetDirectory + "/" + "x1.dcm";

    if (fillRequestAttributesSequence) {
      for (int j = 0; j < mwlVector.size(); j++) {
	MString f = mwlVector[j];
	MDICOMWrapper mwlW(f);
	setRequestAttributesSequence(w, mwlW);
      }
    }
    unsigned long options = w.getFileOptions();
    w.saveAs(outputFile, options);
    imageCount++;
  }

  if (imageCount == 0) {
    cout << "mod_generatestudy: no images found in "
	 << imageDirectory << endl;
    cout << "This is a fatal error" << endl;
    ::exit(1);
  }
}

static void
setGSPSSeries(MDICOMWrapper& gspsWrapper, MDBModality& modalityDB)
{
  gspsWrapper.setString(0x00080060, "PR");		// Modality
  MString seriesUID = modalityDB.newSeriesInstanceUID();
  gspsWrapper.setString(0x0020000E, seriesUID);
  gspsWrapper.setString(0x00200011, "");		// Series Number
}

static void
setPresentationState(MDICOMWrapper& gspsWrapper,
	const MString& optionFileName,
	const MStringVector& imageFiles)
{
  MStringMap m;
  MFileOperations f;
  f.readParamsMap(optionFileName, m, '_');
  
  MCompositeObjectFactory factory;
  MString instanceNum = m["INSTANCE_NUMBER"];
  MString pLabel = m["PRESENTATION_LABEL"];
  MString pDescription = m["PRESENTATION_DESCRIPTION"];
  MString pCreator = m["PRESENTATION_CREATOR"];
  MString imageRange = m["IMAGE_RANGE"];

  MString lowerString = imageRange.getToken(' ', 0);
  MString upperString = imageRange.getToken(' ', 1);
  int lowerBound = lowerString.intData();
  int upperBound = upperString.intData();
  MStringVector selectedImages;

  MStringVector::const_iterator it = imageFiles.begin();
  for ( ; it != imageFiles.end(); it++) {
    MDICOMWrapper w;
    if (w.open(*it) != 0) {
      cout << "Unable to open DICOM file: " << *it << endl;
      ::exit(1);
    }
    MString instanceNumString = w.getString(0x00200013);
    int instanceNumber = instanceNumString.intData();
    if ((instanceNumber >= lowerBound) &&
	(instanceNumber <= upperBound) ) {
      selectedImages.push_back(*it);
    }
  }
  factory.setPresentationState(gspsWrapper,
	instanceNum,		// Instance Number
	pLabel,			// Presentation Label
	pDescription,		// Presentation Description
	pCreator,		// Presentation Creators Name
	selectedImages);	// Vector of image files
}

static void
produceGSPS(const MString& optionFileName,
	      MStringVector& mwlVector,
	      MDICOMWrapper& ncreateWrapper,
	      const MString& protocolName,
	      const MString& ppsUID,
	      int fillRequestAttributesSequence,
	      MDBModality& modalityDB,
	      const MString& imageDirectory,
	      const MString& targetDirectory)
{
  MFileOperations f;

  f.scanDirectorySuffix(imageDirectory, ".dcm");

  int count = f.filesInDirectory();
  int index = 0;

  // Build a list of file names for images in this group
  MStringVector imNames;
  for (index = 0; index < count; index++) {
    MString fileName = imageDirectory + "/" + f.fileName(index);

    imNames.push_back(fileName);
  }

  if (imNames.size() == 0) {
    cout << "Found no input images when trying to create GSPS Object" << endl;
    ::exit(1);
  }

  MStringSet s;
  findExistingSeries(imNames, s);
  int seriesCount = s.size();
  if (seriesCount != 1) {
    cout << "When trying to produce GSPS objects, found "
	 << seriesCount << " series." << endl
	 << "That count should be 1." << endl;
    ::exit(1);
  }

  MString firstImageName = imNames[0];
  MDICOMWrapper imageWrapper;
  if (imageWrapper.open(firstImageName) != 0) {
    cout << "Unable to open expected DICOM Image: " << firstImageName << endl;
    ::exit(1);
  }

  MDICOMWrapper gspsWrapper;

  MString firstMWLFile = mwlVector[0];
  MDICOMWrapper firstMWL(firstMWLFile);
  updateImageIOD(firstMWL, ncreateWrapper, protocolName, ppsUID,
	"", "",
	false,		// user zero length accession number
	gspsWrapper);
  if (fillRequestAttributesSequence) {
    for (int j = 0; j < mwlVector.size(); j++) {
      MString fx = mwlVector[j];
      MDICOMWrapper mwlW(fx);
      setRequestAttributesSequence(gspsWrapper, mwlW);
    }
  }

  MCompositeObjectFactory factory;
  factory.copyPatient(gspsWrapper, imageWrapper);
  factory.copyGeneralStudy(gspsWrapper, imageWrapper);
  factory.copyPatientStudy(gspsWrapper, imageWrapper);
  factory.copyGeneralEquipment(gspsWrapper, imageWrapper);
  setPresentationState(gspsWrapper, optionFileName, imNames);

  MString uid = modalityDB.newSOPInstanceUID();
  factory.setSOPCommon(gspsWrapper, DICOM_SOPCLASSGREYSCALEPS, uid);

  setGSPSSeries(gspsWrapper, modalityDB);
  gspsWrapper.setString(0x20500020, "IDENTITY");

  MString outputFile = targetDirectory + "/" + "gsps.dcm";
  gspsWrapper.saveAs(outputFile);


#if 0
  MStringSet s;
  findExistingSeries(imNames, s);

  MStringMap seriesMap;

  for (MStringSet::iterator s1 = s.begin();
       s1 != s.end();
       s1++) {
    MString seriesUID = modalityDB.newSeriesInstanceUID();
    seriesMap[*s1] = seriesUID;
  }

  MString firstMWLFile = mwlVector[0];
  MDICOMWrapper firstMWL(firstMWLFile);

  for (index = 0; index < count; index++) {
    MString fileName = imageDirectory + "/" + f.fileName(index);

    if (f.isDirectory(fileName))
      continue;

    MDICOMWrapper w(fileName);

    updateImageIOD(firstMWL, ncreateWrapper, protocolName, ppsUID, w);

    MString seriesUID = w.getString(DCM_RELSERIESINSTANCEUID);
    MString newSeriesUID = seriesMap[seriesUID];
    w.setString(DCM_RELSERIESINSTANCEUID, newSeriesUID);

    newSOPInstanceUID(w, modalityDB);

    MString outputFile = targetDirectory + "/" + f.fileName(index);
    if (index == (count-1))
      outputFile = targetDirectory + "/" + "x1.dcm";

    if (fillRequestAttributesSequence) {
      for (int j = 0; j < mwlVector.size(); j++) {
	MString f = mwlVector[j];
	MDICOMWrapper mwlW(f);
	setRequestAttributesSequence(w, mwlW);
      }
    }
    w.saveAs(outputFile);
  }
#endif
}


static void
createStorageCommitmentRequest(const MString& targetDirectory,
			       MDBModality& modalityDB)
{
  MFileOperations f;

  f.scanDirectory(targetDirectory);

  int count = f.filesInDirectory();
  int index = 0;

  LST_HEAD* l1 = ::LST_Create();

  MStringVector imNames;
  for (index = 0; index < count; index++) {
    MString fileName = f.fileName(index);
    MString path = targetDirectory + "/" + f.fileName(index);

    if (!fileName.tokenExists('.', 1))
      continue;
    if (fileName.getToken('.', 1) != "dcm")
      continue;

    DCM_SEQUENCE_ITEM* item = (DCM_SEQUENCE_ITEM*)malloc(sizeof(*item));
    ::DCM_CreateObject(&item->object, 0);
    MDICOMWrapper w1(item->object);
    MDICOMWrapper w2(path);
    MString s;
    s = w2.getString(DCM_IDSOPCLASSUID);
    w1.setString(DCM_IDREFERENCEDSOPCLASSUID, s);
    s = w2.getString(DCM_IDSOPINSTANCEUID);
    w1.setString(DCM_IDREFERENCEDSOPINSTUID, s);

    ::LST_Enqueue(&l1, item);
  }

  DCM_OBJECT* obj = 0;
  ::DCM_CreateObject(&obj, 0);

  DCM_ELEMENT e = { DCM_IDREFERENCEDSOPSEQUENCE, DCM_SQ, "", 1, 0, 0 };
  e.d.sq = l1;
  ::DCM_AddSequenceElement(&obj, &e);

  MString uid = modalityDB.newTransactionUID();
  MDICOMWrapper sc(obj);
  sc.setString(DCM_IDTRANSACTIONUID, uid);

  sc.saveAs(targetDirectory + "/sc.xxx");

}


static int
doScheduledGSPS(const MString& optionFileName,
		const MString& patientID,
		MStringVector& spsCodeVector,
		const MString& performedCode,
		const MString& protocolName,
		const MString& ppsStatus,
		const MString& discontinueCode,
		int useProcedureCode,
		const MString& mwlDirectory,
		const MString& imageDirectory,
		const MString& targetDirectory,
		MDBModality& modalityDB,
		bool groupCaseFlag,
		bool includePerformedProtocolCodes)
{
  int i;

  MDICOMWrapper ncreateWrapper;
  MPPSAssistant assistant;
  assistant.includePerformedProtocolCodes(includePerformedProtocolCodes);

  MStringVector mwlVector;

  MString uid = "";
  uid = copyUIDFromImage(imageDirectory);

  for (i = 0; i < spsCodeVector.size(); i++) {
    MString procedureCode = spsCodeVector[i];
    cout << procedureCode << endl;

    MString mwlFile = getMatchingMWL(patientID,
				     procedureCode,
				     mwlDirectory);

    if (mwlFile == "") {
      cout << "No matching MWL file for: " << patientID
	   << " " << procedureCode << endl;
      ::exit(1);
    }
    mwlVector.push_back(mwlFile);

    MDICOMWrapper mwlWrapper(mwlFile);
    assistant.mergeMWLPPSRelationship(mwlWrapper,
				      ncreateWrapper,
				      uid);

    if (i == 0) {
      addPPSInformationNCreate(mwlWrapper,
			       ncreateWrapper,
			       modalityDB,
			       useProcedureCode);

      addImageAcquistionResultsNCreate(mwlWrapper,
				       ncreateWrapper,
				       modalityDB, "PR", "");
    } else {
      updatePPSInformationNCreate(mwlWrapper,
				  ncreateWrapper,
				  modalityDB,
				  useProcedureCode);
    }
  }

  ncreateWrapper.saveAs(MString(targetDirectory) + "/mpps.crt");

  ncreateWrapper.saveAs(MString(targetDirectory) + "/mpps.status");

  MString ppsUID = modalityDB.newPPSUID();
  {
    char path[1024];
    targetDirectory.safeExport(path, sizeof(path));
    strcat(path, "/mpps_uid.txt");
    ofstream f(path);
    f << ppsUID << endl;
  }

  produceGSPS(optionFileName, mwlVector,
		ncreateWrapper, protocolName,
		ppsUID, 1,
		modalityDB,
		imageDirectory,
		targetDirectory);

  MDICOMWrapper nsetWrapper;

  addPPSRelationshipNSet(nsetWrapper);

  addPerformedAICodeSeq(nsetWrapper, performedCode);
  addPPSDescription(nsetWrapper, performedCode);

  nsetWrapper.setString(DCM_PRCPPSSTATUS, ppsStatus);

  nsetWrapper.saveAs(MString(targetDirectory) + "/mpps.set");

  addPerformedSeriesSequence(targetDirectory);

  assistant.mergeNSetDataSet(MString(targetDirectory) + "/mpps.status",
			     MString(targetDirectory) + "/mpps.set");

#if 0
  createStorageCommitmentRequest(targetDirectory, modalityDB);
#endif

  return 0;
}

static int
doScheduledCase(const MString& patientID,
		MStringVector& spsCodeVector,
		const MString& performedCode,
		const MString& protocolName,
		const MString& ppsStatus,
		const MString& discontinueCode,
		int useProcedureCode,
		const MString& mwlDirectory,
		const MString& imageDirectory,
		const MString& targetDirectory,
		MDBModality& modalityDB,
		bool groupCaseFlag,
		bool includePerformedProtocolCodes)
{
  int i;

  DCM_OBJECT* mppsNCreate;
  ::DCM_CreateObject(&mppsNCreate, 0);
  MDICOMWrapper ncreateWrapper(mppsNCreate);
  MPPSAssistant assistant;
  assistant.includePerformedProtocolCodes(includePerformedProtocolCodes);

  MStringVector mwlVector;

  MString uid = "";
  MString studyID = "";
  bool zeroLengthAccessionNumber = false;

  if (groupCaseFlag) {
    uid = modalityDB.newStudyInstanceUID();
    studyID = modalityDB.newStudyID();
  }

  MString accessionNumber = "";
  for (i = 0; i < spsCodeVector.size(); i++) {
    MString procedureCode = spsCodeVector[i];
    cout << procedureCode << endl;
    cout << "Scheduled case: study UID = " << uid << endl;
    cout << "Scheduled case: study ID =  " << studyID << endl;

    MString mwlFile = getMatchingMWL(patientID,
				     procedureCode,
				     mwlDirectory);

    if (mwlFile == "") {
      cout << "No matching MWL file for: " << patientID
	   << " " << procedureCode << endl;
      exit(1);
    }
    mwlVector.push_back(mwlFile);

    MDICOMWrapper mwlWrapper(mwlFile);
    assistant.mergeMWLPPSRelationship(mwlWrapper,
				      ncreateWrapper,
				      uid,
				      groupCaseFlag);

    if (i == 0) {
      addPPSInformationNCreate(mwlWrapper,
			       ncreateWrapper,
			       modalityDB,
			       useProcedureCode);

      addImageAcquistionResultsNCreate(mwlWrapper,
				       ncreateWrapper,
				       modalityDB, "", studyID);
      accessionNumber = mwlWrapper.getString(DCM_IDACCESSIONNUMBER); // 0008 0050
    } else {
      updatePPSInformationNCreate(mwlWrapper,
				  ncreateWrapper,
				  modalityDB,
				  useProcedureCode);
      MString tmp = mwlWrapper.getString(DCM_IDACCESSIONNUMBER); // 0008 0050
      if (tmp != accessionNumber) {
	zeroLengthAccessionNumber = true;
      }
    }
  }

  addDiscontinueCode(ncreateWrapper, discontinueCode);

  ncreateWrapper.saveAs(MString(targetDirectory) + "/mpps.crt");

  ncreateWrapper.saveAs(MString(targetDirectory) + "/mpps.status");

  MString ppsUID = modalityDB.newPPSUID();
  {
    char path[1024];
    targetDirectory.safeExport(path, sizeof(path));
    strcat(path, "/mpps_uid.txt");
    ofstream f(path);
    f << ppsUID << endl;
  }

  produceImages(mwlVector, ncreateWrapper, protocolName,
		ppsUID, uid, studyID,
		(groupCaseFlag == true),	// zero length accession number
		1,		// Fill Request Attributes Sequence Flag
		modalityDB,
		imageDirectory,
		targetDirectory);

  DCM_OBJECT* mppsNSet;
  ::DCM_CreateObject(&mppsNSet, 0);
  MDICOMWrapper nsetWrapper(mppsNSet);

  addPPSRelationshipNSet(nsetWrapper);

  addPerformedAICodeSeq(nsetWrapper, performedCode);
  addPPSDescription(nsetWrapper, performedCode);

  nsetWrapper.setString(DCM_PRCPPSSTATUS, ppsStatus);

  addDiscontinueCode(nsetWrapper, discontinueCode);

  nsetWrapper.saveAs(MString(targetDirectory) + "/mpps.set");

  addPerformedSeriesSequence(targetDirectory);

  MString statusName = MString(targetDirectory) + "/mpps.status";
  MString setName = MString(targetDirectory) + "/mpps.set";

  assistant.mergeNSetDataSet(statusName, setName);

  createStorageCommitmentRequest(targetDirectory, modalityDB);

  ::DCM_CloseObject(&mppsNCreate);
  ::DCM_CloseObject(&mppsNSet);

  return 0;
}

static int
doUnscheduledCase(const MString& patientID,
		  const MString& patientName,
		  const MString& modality,
		  const MString& performedCode,
		  const MString& protocolName,
		  const MString& ppsStatus,
		  const MString& discontinueCode,
		  const MString& aeTitle,
		  const MString& imageDirectory,
		  const MString& targetDirectory,
		  MDBModality& modalityDB,
		  bool includePerformedProtocolCodes)
{
  DCM_OBJECT* mppsNCreate;
  ::DCM_CreateObject(&mppsNCreate, 0);
  MDICOMWrapper ncreateWrapper(mppsNCreate);
  MPPSAssistant assistant;
  assistant.includePerformedProtocolCodes(includePerformedProtocolCodes);

  DCM_OBJECT* obj = 0;
  ::DCM_CreateObject(&obj, 0);
  MDICOMWrapper mwlWrapper(obj);
  mwlWrapper.setString(DCM_PATID, patientID);
  mwlWrapper.setString(DCM_PATNAME, patientName);
  mwlWrapper.setString(DCM_PRCSCHEDULEDPROCSTEPSEQ, DCM_IDMODALITY, modality);
  mwlWrapper.setString(DCM_PRCSCHEDULEDPROCSTEPSEQ,
		       DCM_PRCSCHEDULEDSTATIONAETITLE,
		       aeTitle);
  ncreateWrapper.setString(DCM_IDMODALITY, modality);
  MString uid = modalityDB.newStudyInstanceUID();
  mwlWrapper.setString(DCM_RELSTUDYINSTANCEUID,
		       uid);

  assistant.mergeMWLPPSRelationship(mwlWrapper,
				    ncreateWrapper);

  addPPSInformationNCreate(mwlWrapper,
			   ncreateWrapper,
			   modalityDB, 0);

  addImageAcquistionResultsNCreate(mwlWrapper,
				   ncreateWrapper,
				   modalityDB, "", "");

  ncreateWrapper.saveAs(MString(targetDirectory) + "/mpps.crt");

  ncreateWrapper.saveAs(MString(targetDirectory) + "/mpps.status");

  MString ppsUID = modalityDB.newPPSUID();
  {
    char path[1024];
    targetDirectory.safeExport(path, sizeof(path));
    strcat(path, "/mpps_uid.txt");
    ofstream f(path);
    f << ppsUID << endl;
  }

  MString tmp = targetDirectory + "/mwl_unscheduled.mwl";
  mwlWrapper.saveAs(tmp);
  MStringVector v;
  v.push_back(tmp);

  produceImages(v, ncreateWrapper, protocolName,
		ppsUID,
		"",	// Study Instance UID
		"",	// Study ID
		true,	// zero length accession number flag
		0,	// Fill Request Attributes Sequence Flag
		modalityDB,
		imageDirectory,
		targetDirectory);

  DCM_OBJECT* mppsNSet;
  ::DCM_CreateObject(&mppsNSet, 0);
  MDICOMWrapper nsetWrapper(mppsNSet);

  addPPSRelationshipNSet(nsetWrapper);

  addPerformedAICodeSeq(nsetWrapper, performedCode);
  addPPSDescription(nsetWrapper, performedCode);

  nsetWrapper.setString(DCM_PRCPPSSTATUS, ppsStatus);

  nsetWrapper.saveAs(MString(targetDirectory) + "/mpps.set");

  addPerformedSeriesSequence(targetDirectory);

  assistant.mergeNSetDataSet(MString(targetDirectory) + "/mpps.status",
			     MString(targetDirectory) + "/mpps.set");

  createStorageCommitmentRequest(targetDirectory, modalityDB);

  ::DCM_CloseObject(&obj);
  ::DCM_CloseObject(&mppsNCreate);
  ::DCM_CloseObject(&mppsNSet);

  return 0;
}

int main(int argc, char **argv)
{
  char *patientID = 0;
  MString patientName("");
  char *modality = "MR";
  //char* procedureCode = 0;
  char* mwlDirectory = 0;
  char* imageDirectory = 0;
  char* performedCode = "";
  char* targetDirectory = 0;
  MString protocolName("IHE Modality Protocol");
  MString ppsStatus("COMPLETED");
  MString discontinueCode("");
  MString aeTitle;
  bool doGSPS = false;
  MString optionFileName;

  MStringVector scheduledProcedureCodeVector;

  int useProcedureCode = 1;
  bool groupCase = false;
  bool includePerformedProtocolCodes = true;

  while (--argc > 0 && (*++argv)[0] == '-') {
    switch (*(argv[0] + 1)) {
    case 'a':
      argc--; argv++;
      if (argc <= 0)
	usageerror();
      aeTitle = *argv;
      break;
    case 'c':
      argc--; argv++;
      if (argc <= 0)
	usageerror();
      performedCode = *argv;
      break;
    case 'C':
      includePerformedProtocolCodes = false;
      break;
    case 'd':
      ppsStatus = "DISCONTINUED";
      discontinueCode = "";
      break;
    case 'D':
      ppsStatus = "DISCONTINUED";
      argc--; argv++;
      if (argc <= 0)
	usageerror();
      discontinueCode = *argv;
      break;
    case 'f':
      argc--; argv++;
      if (argc <= 0)
	usageerror();
      optionFileName = *argv;
      break;
    case 'g':
      groupCase = true;
      break;
    case 'h':
      usageerror();
      break;
    case 'i':
      argc--;
      argv++;
      if (argc <= 0)
	usageerror();
      imageDirectory = *argv;
      break;
    case 'm':
      argc--;
      argv++;
      if (argc <= 0)
	usageerror();
      modality = *argv;
      break;
    case 'n':
      useProcedureCode = 0;
      break;
    case 'o':
      argc--; argv++;
      if (argc <= 0)
	usageerror();
      if (strcmp(*argv, "GSPS") == 0)
	doGSPS = true;
      else
	usageerror();
      break;
    case 'p':
      argc--;
      argv++;
      if (argc <= 0)
	usageerror();
      patientID = *argv;
      break;
    case 'r':
      argc--;
      argv++;
      if (argc <= 0)
	usageerror();
      patientName = *argv;
      patientName.substitute('_', '^');
      break;
    case 's':			// Scheduled procedure code
      argc--;
      argv++;
      if (argc <= 0)
	usageerror();
      scheduledProcedureCodeVector.push_back(*argv);
      break;
    case 't':
      argc--;
      argv++;
      if (argc <= 0)
	usageerror();
      targetDirectory = *argv;
      break;
    case 'y':
      argc--;
      argv++;
      if (argc <= 0)
	usageerror();
      mwlDirectory = *argv;
      break;
    case 'z':
      argc--;
      argv++;
      if (argc <= 0)
	usageerror();
      protocolName = *argv;
      break;
    default:
      break;
    }
  }

  ::THR_Init();
  
  checkParams(patientID, mwlDirectory,
	      imageDirectory, targetDirectory);

  //MString patientID = getPatientID(patfileName);

  MDBModality modalityDB("mod1");
  int returnValue = 0;

  if (doGSPS && scheduledProcedureCodeVector.size() > 0) {
    returnValue = doScheduledGSPS(optionFileName,
				  patientID,
				  scheduledProcedureCodeVector,
				  performedCode,
				  protocolName,
				  ppsStatus,
				  discontinueCode,
				  useProcedureCode,
				  mwlDirectory,
				  imageDirectory,
				  targetDirectory,
				  modalityDB, groupCase,
				  includePerformedProtocolCodes);
  } else if (doGSPS) {
    cout << "Need MWL for GSPS (in this version)" << endl;
    return 1;
  } else if (scheduledProcedureCodeVector.size() > 0) {
    if (mwlDirectory == 0) {
      cout << "When performing a scheduled procedure, you need -y <MWL> option"
	   << endl;
      return 1;
    }

    returnValue = doScheduledCase(patientID,
				  scheduledProcedureCodeVector,
				  performedCode,
				  protocolName,
				  ppsStatus,
				  discontinueCode,
				  useProcedureCode,
				  mwlDirectory,
				  imageDirectory,
				  targetDirectory,
				  modalityDB, groupCase,
				  includePerformedProtocolCodes);
  } else {
    returnValue = doUnscheduledCase(patientID,
				    patientName,
				    modality,
				    performedCode,
				    protocolName,
				    ppsStatus,
				    discontinueCode,
				    aeTitle,
				    imageDirectory,
				    targetDirectory,
				    modalityDB,
				    includePerformedProtocolCodes);
  }

  return returnValue;
}


/* usageerror
**
** Purpose:
**	Print the usage message for this program and exit.
**
** Parameter Dictionary:
**	None
**
** Return Values:
**	None
**
** Algorithm:
**	Description of the algorithm (optional) and any other notes.
*/

static void
usageerror()
{
    char msg[] = "\
[-a <AE title>] [-c code] [-d] [-D code] [-f file] [-i image] [-m mod] [-n] [-o option] [-p patient] [-r name] [-s code] [-t dir] [-y dir] [-z protocol] \n\
\n\
    a     Set AE title of station (for the unscheduled case)\n\
    c     Performed code (used as table lookup to get action items\n\
    C     In the output MPPS, omit Performed Protocol Code Sequence\n\
    d     Discontinued case\n\
    D     Discontinued case; set code for discontinue reason\n\
    f     Specify a configuration file; format depends on data produced\n\
    i     Find input images in directory: image\n\
    h     Print this message\n\
    m     Set modality to mod.  Default is MR\n\
    n     Do not use procedure codes in PPS information \n\
    o     Define an option; legal values are (GSPS) \n\
    p     Set patient ID \n\
    r     Set patient Name \n\
    s     Set a scheduled Action Item code (can repeat this switch)\n\
    t     Define target directory for output\n\
    y     Directory containing MWL responses\n\
    z     Protocol name";

    cout << msg << endl;
    ::exit(1);
}

