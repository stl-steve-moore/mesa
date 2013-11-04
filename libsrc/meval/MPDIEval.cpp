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
#include "MPDIEval.hpp"
#include "MFileOperations.hpp"

#include <iomanip>
#include <strstream>

static char rcsid[] = "$Id: MPDIEval.cpp,v 1.19 2009/01/16 20:33:25 smm Exp $";

MPDIEval::MPDIEval() :
  mRootDirectory(""),
  mDDRFile(0),
  mReportLevel(1)
{
}

MPDIEval::MPDIEval(const MPDIEval& cpy) :
  mRootDirectory(cpy.mRootDirectory),
  mDDRFile(0)
{
}

MPDIEval::~MPDIEval()
{
}

void
MPDIEval::printOn(ostream& s) const
{
  s << "MPDIEval";
}

void
MPDIEval::streamIn(istream& s)
{
  //s >> this->member;
}

// Non boiler-plate methods below

int
MPDIEval::initialize(const MString& rootDirectory)
{
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_VERBOSE,
	MString("MPDIEval::initialize enter method with directory: ") + rootDirectory);

  mRootDirectory = rootDirectory;

  MString path = rootDirectory + MString("/DICOMDIR");
  mDDRFile = new MDDRFile();
  if (mDDRFile == 0) {
    return 1;
  }

  if (mDDRFile->open(path) != 0) {
    logClient.log(MLogClient::MLOG_ERROR,
	MString("Unable to open DICOMDIR file with path: ") + path);
    delete mDDRFile;
    mDDRFile = 0;
    return 1;
  }
  return 0;
}

int
MPDIEval::runTest(int testNumber, int reportLevel,
		MString& rtnTestDescription, MString& rtnComment)
{
  char logTxt[512];
  strstream s(logTxt, sizeof(logTxt));
  s << "MPDIEval::runTest enter method with test number: " << testNumber << '\0';
 
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_VERBOSE, logTxt);
  mReportLevel = reportLevel;

  rtnTestDescription = "";
  rtnComment = "";

  int rtnStatus = 1;		// Assume an error
  switch (testNumber) {
    case 1:
      rtnStatus = this->runTest1(rtnTestDescription, rtnComment);
      break;
    case 2:
      rtnStatus = this->runTest2(rtnTestDescription, rtnComment);
      break;
    case 3:
      rtnStatus = this->runTest3(rtnTestDescription, rtnComment);
      break;
    case 4:
      rtnStatus = this->runTest4(rtnTestDescription, rtnComment);
      break;
    case 5:
      rtnStatus = this->runTest5(rtnTestDescription, rtnComment);
      break;
    case 6:
      rtnStatus = this->runTest6(rtnTestDescription, rtnComment);
      break;
    case 7:
      rtnStatus = this->runTest7(rtnTestDescription, rtnComment);
      break;
    case 8:
      rtnStatus = this->runTest8(rtnTestDescription, rtnComment);
      break;
    case 9:
      rtnStatus = this->runTest9(rtnTestDescription, rtnComment);
      break;
    case 10:
      rtnStatus = this->runTest10(rtnTestDescription, rtnComment);
      break;
    case 11:
      rtnStatus = this->runTest11(rtnTestDescription, rtnComment);
      break;
    case 12:
      rtnStatus = this->runTest12(rtnTestDescription, rtnComment);
      break;
    case 13:
      rtnStatus = this->runTest13(rtnTestDescription, rtnComment);
      break;
    case 14:
      rtnStatus = this->runTest14(rtnTestDescription, rtnComment);
      break;
    default:
      strstream s1(logTxt, sizeof(logTxt));
      s1 << "MPDIEval::runTest unrecognized test number: " << testNumber << '\0';
      logClient.log(MLogClient::MLOG_ERROR, logTxt);
      rtnComment = logTxt;
      break;
  }
  logClient.log(MLogClient::MLOG_VERBOSE, "MPDIEval::runTest exit method");
  return rtnStatus;
}

// Private methods below here

void
MPDIEval::outputMessage(int level, const MString& errTxt)
{
  MString preamble = "ERR: ";
  switch (level) {
  case 2:
    preamble = "WARN: ";
    break;
  case 3:
  case 0:
    preamble = "CTX: ";
    break;
  case 4:
    preamble = "REF: ";
    break;
  }
  if (level <= mReportLevel) {
    cout << preamble << errTxt << endl;
  }
}

int
MPDIEval::checkUID(const MString& uid)
{
  char uidTxt[65];
  if (uid.size() > 64) {
    return 1;
  }
  uid.safeExport(uidTxt, sizeof(uidTxt));
  int i;
  char legalChars[] = "0123456789.";
  for (i = 0; i < uid.size(); i++) {
    char c = uidTxt[i];
    char* p = strchr(legalChars, c);
    if (p == NULL) {
      return 1;
    }
  }
  return 0;
}


int
MPDIEval::runTest1(MString& rtnTestDescription, MString& rtnComment)
{
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_VERBOSE, "MPDIEval::runTest1 enter method");

  rtnTestDescription = "PDI Test 1: Test for DICOMDIR in root directory";
  this->outputMessage(0, rtnTestDescription);

  MFileOperations f;
  int rtnStatus = 0;

  if (! f.isDirectory(mRootDirectory)) {
    this->outputMessage(1, 
	MString("MPDIEVAL::runTest1 root directory specified is not a directory: ") + mRootDirectory);
    this->outputMessage(1, 
	MString("MPDIEVAL::runTest1 If you specified a Windows drive (D:), try D:\\"));
    rtnComment = "PDI Test 1: Root directory specified is not a directory, did you mean " + mRootDirectory + "\\";
    rtnStatus = 1;
  }

  if (rtnStatus == 0) {
    f.scanDirectory(mRootDirectory);
    int count = f.filesInDirectory();
    int i = 0;
    bool foundDICOMDIR = false;
    for (i = 0; i < count && !foundDICOMDIR; i++) {
      MString s = f.fileName(i);
      if (s == "DICOMDIR") {
	foundDICOMDIR = true;
      }
    }
    if (!foundDICOMDIR) {
      this->outputMessage(1, 
	MString("MPDIEval::runTest1 root directory does not contain DICOMDIR file: ") + mRootDirectory);
      rtnComment = "PDI Test 1: Root directory does not contain DICOMDIR file";
      rtnStatus = 1;
    } else {
      this->outputMessage(3,
	MString("MPDIEval::runTest1 found DICOMDIR in root directory as expected"));
    }
  }

  logClient.log(MLogClient::MLOG_VERBOSE, "MPDIEval::runTest1 exit method");
  return rtnStatus;
}

int
MPDIEval::runTest2(MString& rtnTestDescription, MString& rtnComment)
{
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_VERBOSE, "MPDIEval::runTest2 enter method");

  rtnTestDescription = "PDI Test 2: Test for DICOM instances in root directory";
  this->outputMessage(0, rtnTestDescription);

  MFileOperations f;
  int rtnStatus = 0;

  if (! f.isDirectory(mRootDirectory)) {
    this->outputMessage(1, 
	MString("MPDIEVAL::runTest2 root directory specified is not a directory: ") + mRootDirectory);
    this->outputMessage(1, 
	MString("MPDIEVAL::runTest2 If you specified a Windows drive (D:), try D:\\"));
    rtnComment = "PDI Test 2: Root directory specified is not a directory, did you mean " + mRootDirectory + "\\";
    rtnStatus = 1;
  }

  if (rtnStatus == 0) {
    f.scanDirectory(mRootDirectory);
    int count = f.filesInDirectory();
    int i = 0;
    for (i = 0; i < count && rtnStatus == 0; i++) {
      MString s = f.fileName(i);
      if (s == "DICOMDIR") {
	continue;
      }
      MString path = mRootDirectory + "/" + s;
      if (f.isDirectory(mRootDirectory + "/" + s)) {
	continue;
      }
      MDICOMWrapper w;
      if (w.open(path, DCM_PART10FILE) == 0) {
	rtnStatus = 1;
	logClient.log(MLogClient::MLOG_ERROR,
		MString("PDI Test 2: Found DICOM instance in root directory: ") + path);
	rtnComment = MString("PDI Test 2: Found DICOM instance in root directory: ") + s;
      }
    }
  }

  logClient.log(MLogClient::MLOG_VERBOSE, "MPDIEval::runTest2 exit method");
  return rtnStatus;
}

int
MPDIEval::runTest3(MString& rtnTestDescription, MString& rtnComment)
{
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_VERBOSE, "MPDIEval::runTest3 enter method");

  rtnTestDescription = "PDI Test 3: Test attributes in group 0002 of DICOMDIR";
  this->outputMessage(0, rtnTestDescription);

  MFileOperations f;
  int rtnStatus = 0;

  if (! f.isDirectory(mRootDirectory)) {
    this->outputMessage(1, 
	MString("MPDIEVAL::runTest3 root directory specified is not a directory: ") + mRootDirectory);
    this->outputMessage(1, 
	MString("MPDIEVAL::runTest3 If you specified a Windows drive (D:), try D:\\"));
    rtnComment = "PDI Test 3: Root directory specified is not a directory, did you mean " + mRootDirectory + "\\";
    rtnStatus = 1;
  }

  MDICOMWrapper w;
  if (rtnStatus == 0) {
    MString path = mRootDirectory + "/DICOMDIR";
    if (w.open(path, DCM_PART10FILE) != 0) {
      MString errString = MString("PDI Test 3: Cannot open DICOMDIR file: ") + path;
      logClient.log(MLogClient::MLOG_ERROR, errString);
      rtnComment = errString;
      rtnStatus = 1;
    }
  }
  DCM_OBJECT* obj;
  char logTxt[512] = "";
  if (rtnStatus == 0) {
    obj = w.getNativeObject();
    DCM_ELEMENT e = { DCM_MAKETAG(0x0002, 0x0001), DCM_OB, "", 1, 2, NULL};
    unsigned char version[2];
    e.d.ot = version;
    CONDITION cond = ::DCM_ParseObject(&obj, &e, 1, 0, 0, 0);
    if (cond != DCM_NORMAL) {
      MString errString = "PDI Test 3: Cannot get 0002 0001 from DICOMDIR file";
      logClient.log(MLogClient::MLOG_ERROR, errString);
      rtnComment = errString;
      rtnStatus = 1;
    }
    if (rtnStatus == 0 && version[0] != 0x00) {
      strstream x1(logTxt, sizeof(logTxt));
      x1 << "PDI Test 3: 00002 0001 Byte 0 is not 0x00: " << setw(2) << setfill('0') << hex << (unsigned int)version[0] << '\0';
      logClient.log(MLogClient::MLOG_ERROR, logTxt);
      rtnComment = logTxt;
      rtnStatus = 1;
    }
    if (rtnStatus == 0 && version[1] != 0x01) {
      strstream x1(logTxt, sizeof(logTxt));
      x1 << "PDI Test 3: 00002 0001 Byte 1 is not 0x01: " << setw(2) << setfill('0') << hex << (unsigned int)version[1] << '\0';
      logClient.log(MLogClient::MLOG_ERROR, logTxt);
      rtnComment = logTxt;
      rtnStatus = 1;
    }
  }
  if (rtnStatus == 0) {
    MString x = w.getString(DCM_MAKETAG(0x0002, 0x0002));
    if (x != "1.2.840.10008.1.3.10") {
      strstream x1(logTxt, sizeof(logTxt));
      x1 << "PDI Test 3: 00002 0002 Stored SOP Class UID has wrong SOP class UID: " << x << '\0';
      logClient.log(MLogClient::MLOG_ERROR, logTxt);
      rtnComment = logTxt;
      rtnStatus = 1;
    }
  }
  if (rtnStatus == 0) {
    MString x = w.getString(DCM_MAKETAG(0x0002, 0x0003));
    if (this->checkUID(x) != 0) {
      strstream x1(logTxt, sizeof(logTxt));
      x1 << "PDI Test 3: 00002 0003  SOP Instance UID illegal UID: " << x << '\0';
      logClient.log(MLogClient::MLOG_ERROR, logTxt);
      rtnComment = logTxt;
      rtnStatus = 1;
    }
  }
  if (rtnStatus == 0) {
    MString x = w.getString(DCM_MAKETAG(0x0002, 0x0010));
    if (x != "1.2.840.10008.1.2.1") {
      strstream x1(logTxt, sizeof(logTxt));
      x1 << "PDI Test 3: 00002 0010 Transfer Syntax UID is not EVRLE: " << x << '\0';
      logClient.log(MLogClient::MLOG_ERROR, logTxt);
      rtnComment = logTxt;
      rtnStatus = 1;
    }
  }
  if (rtnStatus == 0) {
    MString x = w.getString(DCM_MAKETAG(0x0002, 0x0012));
    if (this->checkUID(x) != 0) {
      strstream x1(logTxt, sizeof(logTxt));
      x1 << "PDI Test 3: 00002 0012  SOP Implementation Class UID illegal UID: " << x << '\0';
      logClient.log(MLogClient::MLOG_ERROR, logTxt);
      rtnComment = logTxt;
      rtnStatus = 1;
    }
  }

  logClient.log(MLogClient::MLOG_VERBOSE, "MPDIEval::runTest3 exit method");
  return rtnStatus;
}

int
MPDIEval::runTest4(MString& rtnTestDescription, MString& rtnComment)
{
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_VERBOSE, "MPDIEval::runTest4 enter method");
  char logTxt[512] = "";

  rtnTestDescription = "PDI Test 4: General structure of DICOMDIR";
  this->outputMessage(0, rtnTestDescription);

  MFileOperations f;
  int rtnStatus = 0;

  if (f.isDirectory(mRootDirectory) != 1) {
    rtnComment = "PDI Test 4: Root directory specified is not a directory, did you mean " + mRootDirectory + "\\";
    MString errTxt = MString("MPDIEVAL::runTest4 root directory specified is not a directory: ") + mRootDirectory;
    this->outputMessage(1, errTxt);
    this->outputMessage(1, "MPDIEVAL::runTest4 If you specified a Windows drive (D:), try D:\\");
    rtnStatus = 1;
  }

  MDDRFile ddrFile;
  if (rtnStatus == 0) {
    MString path = mRootDirectory + "/DICOMDIR";
    if (ddrFile.open(path) != 0) {
      MString errString = MString("PDI Test 4: Cannot open DICOMDIR file: ") + path;
      this->outputMessage(1, errString);
      rtnComment = errString;
      rtnStatus = 1;
    }
  }

  int patientCount = ddrFile.getPatientCount();
  strstream x1(logTxt, sizeof(logTxt));
  x1 << "MPDIEval::runTest 4, patient count = " << patientCount << '\0';
  this->outputMessage(3, logTxt);
  if (patientCount <= 0) {
    rtnComment =  "PDI Test 4: Patient count is <= 0; cannot execute test";
    this->outputMessage(1, rtnComment);
    return 1;
  }

  int idx = 0;
  for (idx = 0; idx < patientCount; idx++) {
    DDR_PATIENT p;
    ::memset(&p, 0, sizeof(p));
    int status = ddrFile.getPatientRecord(idx, &p);
    if (status == 0) {
      strstream x2(logTxt, sizeof(logTxt));
      x2 << "Patient index: " << idx
	 << " patient information <"
	 << p.PatientID << "> <"
	 << p.PatientName << "> <"
	 << p.BirthDate << "> <"
	 << p.Sex << ">" << '\0';
      this->outputMessage(3, logTxt);
    } else {
      strstream x3(logTxt, sizeof(logTxt));
      x3 << "Could not get patient record at index: " << idx << '\0';
      this->outputMessage(1, logTxt);
      rtnStatus = 1;
      continue;
    }
    if (::strlen(p.PatientID) == 0) {
      strstream x4(logTxt, sizeof(logTxt));
      x4 << "Zero length patient ID at index: " << idx << '\0';
      this->outputMessage(1, logTxt);
      rtnStatus = 1;
      continue;
    }
    status = this->testStudyRecords(p.StudyLinkOffset);
    if (status != 0) {
      rtnStatus = 1;
    }
  }

  logClient.log(MLogClient::MLOG_VERBOSE, "MPDIEval::runTest4 exit method");
  return rtnStatus;
}

int
MPDIEval::runTest5(MString& rtnTestDescription, MString& rtnComment)
{
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_VERBOSE, "MPDIEval::runTest5 enter method");
  char logTxt[512] = "";

  rtnTestDescription = "PDI Test 5: ID hierarchy in DICOMDIR (looking for duplicate identifiers)";
  this->outputMessage(0, rtnTestDescription);

  int rtnStatus = 0;

  int patientCount = mDDRFile->getPatientCount();
  strstream x1(logTxt, sizeof(logTxt));
  x1 << "MPDIEval::runTest 5, patient count = " << patientCount << '\0';
  this->outputMessage(3, logTxt);
  if (patientCount <= 0) {
    rtnComment =  "PDI Test 5: Patient count is <= 0; cannot execute test";
    this->outputMessage(1, rtnComment);
    return 1;
  }

  MStringMap patientIDMap;
  MStringMap studyUIDMap;
  MStringMap seriesUIDMap;
  MStringMap instanceUIDMap;
  if (this->fillIdentifierMaps(patientIDMap, studyUIDMap, seriesUIDMap, instanceUIDMap) != 0) {
    rtnStatus = 1;
    goto exit_test5;
  }

exit_test5:
  return rtnStatus;
}

int
MPDIEval::runTest6(MString& rtnTestDescription, MString& rtnComment)
{
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_VERBOSE, "MPDIEval::runTest6 enter method");
  char logTxt[512] = "";

  rtnTestDescription = "PDI Test 6: looking at directory entries for file names";
  this->outputMessage(0, rtnTestDescription);

  int rtnStatus = 0;
  int idx = 0;
  int i = 0;
  int status = 0;

  MStringVector fileVector;
  if (this->fillFileVector(fileVector) != 0) {
    rtnStatus = 1;
    goto exit_test6;
  }
  for (i = 0; i < fileVector.size(); i++) {
    MString referencedFileID = fileVector[i];
    this->outputMessage(3, referencedFileID);
    int directoryLevels = this->countDirectoryLevels(referencedFileID);
    if (directoryLevels > 7) {
      strstream s(logTxt, sizeof(logTxt));
      s << "Number of directory levels exceeds 7 (" << directoryLevels << ")"
	      << " for entry " << referencedFileID << '\0';
      this->outputMessage(1, logTxt);
      rtnStatus = 1;
    }
    status = this->testFileIDName(referencedFileID);
    if (status != 0) {
      rtnStatus = 1;
    }
  }

exit_test6:
  return rtnStatus;
}

int
MPDIEval::runTest7(MString& rtnTestDescription, MString& rtnComment)
{
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_VERBOSE, "MPDIEval::runTest7 enter method");
  char logTxt[512] = "";

  rtnTestDescription = "PDI Test 7: Examining directory records at the leaf level";
  this->outputMessage(0, rtnTestDescription);

  int rtnStatus = 0;
  int idx = 0;
  int i = 0;
  int status = 0;

  MU32Vector offsetVector;
  if (this->fillLeafOffsetVector(offsetVector) != 0) {
    rtnStatus = 1;
    goto exit_test7;
  }
  for (i = 0; i < offsetVector.size(); i++) {
    U32 offset = offsetVector[i];
    cout << offset << endl;
    status = this->testLeafContents(offset);
    if (status != 0) {
      rtnStatus = 1;
    }
  }

exit_test7:
  return rtnStatus;
}

int
MPDIEval::runTest8(MString& rtnTestDescription, MString& rtnComment)
{
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_VERBOSE, "MPDIEval::runTest8 enter method");
  char logTxt[512] = "";

  rtnTestDescription = "PDI Test 8: Examining meta-header records";
  this->outputMessage(0, rtnTestDescription);

  int rtnStatus = 0;
  int idx = 0;
  int i = 0;
  int status = 0;

  MStringVector fileVector;
  if (this->fillFileVector(fileVector) != 0) {
    rtnStatus = 1;
    goto exit_test8;
  }
  for (i = 0; i < fileVector.size(); i++) {
    MString referencedFileID = fileVector[i];
    this->outputMessage(3, referencedFileID);
    status = this->testMetaHeader(referencedFileID);
    if (status != 0) {
      rtnStatus = 1;
    }
  }

exit_test8:
  return rtnStatus;
}

int
MPDIEval::runTest9(MString& rtnTestDescription, MString& rtnComment)
{
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_VERBOSE, "MPDIEval::runTest9 enter method");
  char logTxt[512] = "";

  rtnTestDescription = "PDI Test 9: Examining directory and file names for naming convention";
  this->outputMessage(0, rtnTestDescription);

  int rtnStatus = 0;
  int idx = 0;
  int i = 0;
  int status = 0;
  MFileOperations f;
  int directoryCount = 0;
  int fileCount = 0;

  MStringVector fileVector;
  if (this->listAllFiles(fileVector, mRootDirectory) != 0) {
    rtnStatus = 1;
    goto exit_test9;
  }
  for (i = 0; i < fileVector.size(); i++) {
    MString fileName = fileVector[i];
    this->outputMessage(3, fileName);
    if (f.isDirectory(fileName)) {
      directoryCount++;
    } else {
      fileCount++;
      int rootLength = mRootDirectory.length();
      MString pathWithoutRoot = fileName.subString(rootLength, 0);
      if (this->testFileNameISO9660(pathWithoutRoot) != 0) {
	rtnStatus = 1;
      }
    }
  }
  { 
    strstream x1(logTxt, sizeof(logTxt));
    x1 << "Directory count: " << directoryCount << '\0';
    this->outputMessage(3, logTxt);
    strstream x2(logTxt, sizeof(logTxt));
    x2 << "File count:      " << fileCount << '\0';
    this->outputMessage(3, logTxt);
  }

exit_test9:
  return rtnStatus;
}

int
MPDIEval::runTest10(MString& rtnTestDescription, MString& rtnComment)
{
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_VERBOSE, "MPDIEval::runTest10 enter method");

  rtnTestDescription = "PDI Test 10: Test for IHE_PDI in root directory";
  this->outputMessage(0, rtnTestDescription);

  MFileOperations f;
  int rtnStatus = 0;

  if (! f.isDirectory(mRootDirectory)) {
    rtnComment = "PDI Test 10: Root directory specified is not a directory, did you mean " + mRootDirectory + "\\";
    MString errTxt = MString("MPDIEVAL::runTest10 root directory specified is not a directory: ") + mRootDirectory;
    this->outputMessage(1, errTxt);
    this->outputMessage(1, "MPDIEVAL::runTest10 If you specified a Windows drive (D:), try D:\\");
    rtnStatus = 1;
  }

  if (rtnStatus == 0) {
    f.scanDirectory(mRootDirectory);
    int count = f.filesInDirectory();
    int i = 0;
    bool foundIHEPDIDirectory = false;
    for (i = 0; i < count && !foundIHEPDIDirectory; i++) {
      MString s = f.fileName(i);
      if (s == "IHE_PDI") {
	foundIHEPDIDirectory = true;
      }
    }
    if (!foundIHEPDIDirectory) {
      this->outputMessage(1, MString("MPDIEVAL::runTest10 root directory does not contain IHE_PDI directory: ") + mRootDirectory);
      rtnComment = "PDI Test 10: Root directory does not contain IHE_PDI directory";
      rtnStatus = 1;
    }
  }

  if (rtnStatus == 0) {		// IHE_PDI exists, is it a directory?
    if (! f.isDirectory(mRootDirectory + "/IHE_PDI")) {
      this->outputMessage(1, MString("MPDIEVAL::runTest10 in root directory, IHE_PDI is not a directory: ") + mRootDirectory);
      rtnComment = "PDI Test 10: IHE_PDI in the root is not a directory";
      rtnStatus = 1;
    }
  }

  logClient.log(MLogClient::MLOG_VERBOSE, "MPDIEval::runTest10 exit method");
  return rtnStatus;
}

int
MPDIEval::runTest11(MString& rtnTestDescription, MString& rtnComment)
{
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_VERBOSE, "MPDIEval::runTest11 enter method");

  rtnTestDescription = "PDI Test 11: Test for INDEX.HTM in root directory";
  this->outputMessage(0, rtnTestDescription);

  MFileOperations f;
  int rtnStatus = 0;

  if (! f.isDirectory(mRootDirectory)) {
    this->outputMessage(1, 
	MString("MPDIEVAL::runTest11 root specified is not a directory or does not exist: ") + mRootDirectory);
    this->outputMessage(1, "MPDIEVAL::runTest11 If you specified a Windows drive (D:), try D:\\");
    rtnComment = "PDI Test 11: root specified is not a directory or does not exist.";
    rtnStatus = 1;
  }

  if (rtnStatus == 0) {
    f.scanDirectory(mRootDirectory);
    int count = f.filesInDirectory();
    int i = 0;
    bool foundINDEX = false;
    for (i = 0; i < count && !foundINDEX; i++) {
      MString s = f.fileName(i);
      if (s == "INDEX.HTM") {
	foundINDEX = true;
      }
    }
    if (!foundINDEX) {
      logClient.log(MLogClient::MLOG_ERROR,
	MString("MPDIEVAL::runTest11 root directory does not contain INDEX.HTM file: ") + mRootDirectory);
      rtnComment = "PDI Test 11: root directory does not contain INDEX.HTM file";
      rtnStatus = 1;
    }
  }

  logClient.log(MLogClient::MLOG_VERBOSE, "MPDIEval::runTest11 exit method");
  return rtnStatus;
}

int
MPDIEval::runTest12(MString& rtnTestDescription, MString& rtnComment)
{
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_VERBOSE, "MPDIEval::runTest12 enter method");

  rtnTestDescription = "PDI Test 12: Test for README.TXT in root directory";
  this->outputMessage(0, rtnTestDescription);

  MFileOperations f;
  int rtnStatus = 0;

  if (! f.isDirectory(mRootDirectory)) {
    this->outputMessage(1,
	MString("MPDIEVAL::runTest12 root specified is not a directory or does not exist: ") + mRootDirectory);
    this->outputMessage(1, "MPDIEVAL::runTest12 If you specified a Windows drive (D:), try D:\\");
    rtnComment = "PDI Test 12: root specified is not a directory or does not exist.";
    rtnStatus = 1;
  }

  if (rtnStatus == 0) {
    f.scanDirectory(mRootDirectory);
    int count = f.filesInDirectory();
    int i = 0;
    bool foundINDEX = false;
    for (i = 0; i < count && !foundINDEX; i++) {
      MString s = f.fileName(i);
      if (s == "README.TXT") {
	foundINDEX = true;
      }
    }
    if (!foundINDEX) {
      logClient.log(MLogClient::MLOG_ERROR,
	MString("MPDIEVAL::runTest12 root directory does not contain README.TXT file: ") + mRootDirectory);
      rtnComment = "PDI Test 12: root directory does not contain README.TXT file";
      rtnStatus = 1;
    }
  }

  logClient.log(MLogClient::MLOG_VERBOSE, "MPDIEval::runTest12 exit method");
  return rtnStatus;
}

int
MPDIEval::runTest13(MString& rtnTestDescription, MString& rtnComment)
{
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_VERBOSE, "MPDIEval::runTest13 enter method");
  char logTxt[512] = "";

  rtnTestDescription = "PDI Test 13: looking at directory entries to see if they contain IHE_PDI";
  this->outputMessage(0, rtnTestDescription);

  int rtnStatus = 0;
  int idx = 0;
  int i = 0;
  int status = 0;

  MStringVector fileVector;
  if (this->fillFileVector(fileVector) != 0) {
    rtnStatus = 1;
    goto exit_test6;
  }
  for (i = 0; i < fileVector.size(); i++) {
    MString referencedFileID = fileVector[i];
    this->outputMessage(3, referencedFileID);

    status = this->testDICOMFileForIHE_PDI(referencedFileID);
    if (status != 0) {
      rtnStatus = 1;
    }
  }

exit_test6:
  return rtnStatus;
}

int
MPDIEval::runTest14(MString& rtnTestDescription, MString& rtnComment)
{
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_VERBOSE, "MPDIEval::runTest14 enter method");
  char logTxt[512] = "";

  rtnTestDescription = "PDI Test 14: Examining directory names; none should start with IHE other than IHE_PDI";
  this->outputMessage(0, rtnTestDescription);

  int rtnStatus = 0;
  int idx = 0;
  int i = 0;
  int status = 0;
  MFileOperations f;
  int directoryCount = 0;
  int fileCount = 0;

  MStringVector fileVector;
  if (this->listAllFiles(fileVector, mRootDirectory) != 0) {
    rtnStatus = 1;
    goto exit_test14;
  }
  for (i = 0; i < fileVector.size(); i++) {
    MString fileName = fileVector[i];
    this->outputMessage(3, fileName);
    int rootLength = mRootDirectory.length();
    MString pathWithoutRoot = fileName.subString(rootLength+1, 0);
    if (pathWithoutRoot == "IHE_PDI") {
      continue;
    }
    if (pathWithoutRoot.find("IHE_PDI/", 0) == 0) {
      continue;
    }
    if (pathWithoutRoot.find("IHE_PDI\\", 0) == 0) {
      continue;
    }

    if (pathWithoutRoot.find("IHE", 0) == 0) {
      strstream x1(logTxt, sizeof(logTxt));
      x1 << "File/directory begins with IHE; that violates Rad TF-3: 4.47.4.1.2.2.3" << endl;
      x1 << "Name is: " << fileName << '\0';
      this->outputMessage(1, logTxt);
      rtnStatus = 1;
    }
  }

exit_test14:
  return rtnStatus;
}



typedef struct {
  DCM_TAG tag;
  int type123;
  int errCode;
} TAG_TYPE_STRUCT;

int
MPDIEval::testStudyRecords(U32 offset)
{
  MLogClient logClient;
  char logTxt[512] = "";
  TAG_TYPE_STRUCT m[]  = {
    { DCM_MAKETAG(0x0020, 0x0010), 1, 2 },	// Study ID
    { DCM_MAKETAG(0x0008, 0x0020), 1, 2 },	// Study Date
    { DCM_MAKETAG(0x0008, 0x0030), 1, 2 },	// Study Time
    { DCM_MAKETAG(0x0008, 0x1030), 2, 2 },	// Study Description
    { DCM_MAKETAG(0x0008, 0x0050), 2, 2 },	// Accession Number
    { DCM_MAKETAG(0x0000, 0x0000), 0, 2 }
  };

  int studyCount = mDDRFile->getStudyCount(offset);
  strstream x1(logTxt, sizeof(logTxt));
  x1 << " study count = " << studyCount << '\0';
  this->outputMessage(3, logTxt);

  int idx = 0;
  int rtnStatus = 0;
  int status = 0;
  for (idx = 0; idx < studyCount; idx++) {
    MDICOMWrapper* studyWrapper = mDDRFile->getStudyRecord(idx, offset);
    if (studyWrapper == 0) {
      strstream x2(logTxt, sizeof(logTxt));
      x2 << " Could not get study record at index: " << idx
	 << " for patient with offset: " << offset
	 << '\0';
      this->outputMessage(1, logTxt);
      rtnStatus = 1;
    } else {
      int j = 0;
      this->outputMessage(3, "STUDY RECORD evaluation");
      for (j = 0; m[j].tag != 0; j++) {
	status = this->evalAttribute(*studyWrapper, m[j].tag, m[j].type123,
			"STUDY RECORD");
	if (status != 0) {
	  if (rtnStatus == 0) {	// Then use the new error status
	    rtnStatus = m[j].errCode;
	  } else if (rtnStatus == 1) {	// Then leave as is
	    ;
	  } else {	// Err code will either be 1 or 2, so take it
	    rtnStatus = m[j].errCode;
	  }
	}
      }
      U32 firstSeriesOffset = studyWrapper->getU32(DCM_DIRLOWERLEVELOFFSET);
      status = this->testSeriesRecords(firstSeriesOffset);
      if (status != 0) {
	rtnStatus = 1;
      }
      delete studyWrapper;
    }
  }


#if 0
  for (idx = 0; idx < studyCount; idx++) {
    DDR_STUDY study;
    ::memset(&study, 0, sizeof(study));
    int status = mDDRFile->getStudyRecord(idx, patientID, &study);
    if (status == 0) {
      strstream x2(logTxt, sizeof(logTxt));
      x2 << " Study index: " << idx
	 << "  study information <"
	 << study.StudyInstanceUID<< "> <"
	 << study.StudyDate << "> <"
	 << study.StudyTime << "> <"
	 << study.AccessionNumber << "> <"
	 << study.StudyID << "> <"
	 << study.StudyDescription << ">" << '\0';
      logClient.log(MLogClient::MLOG_CONVERSATION, logTxt);
    } else {
      strstream x3(logTxt, sizeof(logTxt));
      x3 << "Could not get study record at index: " << idx << '\0';
      logClient.log(MLogClient::MLOG_ERROR, logTxt);
      rtnStatus = 1;
      continue;
    }
  }
#endif
  return rtnStatus;
}

int
MPDIEval::testSeriesRecords(U32 offset)
{
  MLogClient logClient;
  char logTxt[512] = "";
  TAG_TYPE_STRUCT m[]  = {
    { DCM_MAKETAG(0x0008, 0x0060), 1, 2 },	// Modality
    { DCM_MAKETAG(0x0020, 0x000E), 1, 1 },	// Series Instance UID
    { DCM_MAKETAG(0x0020, 0x0011), 1, 2 },	// Series Number
    { DCM_MAKETAG(0x0000, 0x0000), 0, 0 }
  };

  int seriesCount = mDDRFile->getSeriesCount(offset);
  strstream x1(logTxt, sizeof(logTxt));
  x1 << " series count = " << seriesCount << '\0';
  this->outputMessage(3, logTxt);

  int idx = 0;
  int rtnStatus = 0;
  int status = 0;
  for (idx = 0; idx < seriesCount; idx++) {
    MDICOMWrapper* seriesWrapper = mDDRFile->getSeriesRecord(idx, offset);
    if (seriesWrapper == 0) {
      strstream x2(logTxt, sizeof(logTxt));
      x2 << " Could not get series record at index: " << idx
	 << " for study with offset: " << offset
	 << '\0';
      this->outputMessage(3, logTxt);
      rtnStatus = 1;
    } else {
      int j = 0;
      this->outputMessage(3, "SERIES RECORD evaluation");
      for (j = 0; m[j].tag != 0; j++) {
	status = this->evalAttribute(*seriesWrapper, m[j].tag, m[j].type123,
			"SERIES RECORD");
	if (status != 0) {
	  if (rtnStatus == 0) {	// Then use the new error status
	    rtnStatus = m[j].errCode;
	  } else if (rtnStatus == 1) {	// Then leave as is
	    ;
	  } else {	// Err code will either be 1 or 2, so take it
	    rtnStatus = m[j].errCode;
	  }
	}
      }
      U32 firstLeafOffset = seriesWrapper->getU32(DCM_DIRLOWERLEVELOFFSET);
      status = this->testLeafRecords(firstLeafOffset);
      if (status != 0) {
	rtnStatus = 1;
      }
      delete seriesWrapper;
    }
  }

  return rtnStatus;
}

int
MPDIEval::testLeafRecords(U32 offset)
{
  MLogClient logClient;
  char logTxt[512] = "";
  char *forbiddenDirectoryTypes[] = {
	  "VISIT", "RESULTS", "INTERPRETATION",
	  "STUDY COMPONENT", "STORED PRINT",
	  "TOPIC", "PRIVATE", 0};

  int leafCount = mDDRFile->getLeafCount(offset);
  strstream x1(logTxt, sizeof(logTxt));
  x1 << " leaf count = " << leafCount << '\0';
  this->outputMessage(3, logTxt);

  int idx = 0;
  int rtnStatus = 0;
  int status = 0;
  for (idx = 0; idx < leafCount; idx++) {
    MDICOMWrapper* leafWrapper = mDDRFile->getLeafRecord(idx, offset);
    if (leafWrapper == 0) {
      strstream x2(logTxt, sizeof(logTxt));
      x2 << " Could not get leaf record at index: " << idx
	 << " for series with offset: " << offset
	 << '\0';
      this->outputMessage(1, logTxt);
      rtnStatus = 1;
    } else {
      int j = 0;
      this->outputMessage(3, "LEAF RECORD evaluation");
      MString leafType = leafWrapper->getString(DCM_MAKETAG(0x0004, 0x1430));
      strstream x3(logTxt, sizeof(logTxt));
      x3 << "Directory type for leaf node: " << leafType << '\0';
      this->outputMessage(3, logTxt);
      bool legalLeafType;
      legalLeafType = this->isAllowableLeafType(leafType, forbiddenDirectoryTypes);
      if (!legalLeafType) {
        strstream x4(logTxt, sizeof(logTxt));
	x4 << "Detected unallowed DIRECTORY type at leaf level: " << leafType
		<< '\0';
	rtnStatus = 2;
        this->outputMessage(1, logTxt);
        this->outputMessage(4, "See IHE-Rad, Vol 2., Section 4.47.4.1.2.3.1.2");
      } else if (leafType == "IMAGE") {
	status = this->testImageRecord(*leafWrapper);
	if (status != 0) {
	  rtnStatus = 1;
	}
      } else if (leafType == "VOI LUT") {
	status = this->testVOILUTRecord(*leafWrapper);
	if (status != 0) {
	  rtnStatus = 1;
	}
      } else if (leafType == "RT DOSE") {
	status = this->testRTDoseRecord(*leafWrapper);
	if (status != 0) {
	  rtnStatus = 1;
	}
      } else if (leafType == "RT PLAN") {
	status = this->testRTPlanRecord(*leafWrapper);
	if (status != 0) {
	  rtnStatus = 1;
	}
      } else if (leafType == "PRESENTATION") {
	status = this->testPresentationRecord(*leafWrapper);
	if (status != 0) {
	  rtnStatus = 1;
	}
      } else if (leafType == "SR DOCUMENT") {
	status = this->testSRDocumentRecord(*leafWrapper);
	if (status != 0) {
	  rtnStatus = 1;
	}
      } else if (leafType == "OVERLAY") {
	status = this->testOverlayRecord(*leafWrapper);
	if (status != 0) {
	  rtnStatus = 1;
	}
      } else if (leafType == "CURVE") {
      } else if (leafType == "RT STRUCTURE SET") {
	status = this->testRTStructureSetRecord(*leafWrapper);
	if (status != 0) {
	  rtnStatus = 1;
	}
      } else if (leafType == "RT TREAT RECORD") {
	status = this->testRTTreatmentRecord(*leafWrapper);
	if (status != 0) {
	  rtnStatus = 1;
	}
      } else if (leafType == "MODALITY LUT") {
	status = this->testModalityLUTRecord(*leafWrapper);
	if (status != 0) {
	  rtnStatus = 1;
	}
      } else if (leafType == "WAVEFORM") {
	status = this->testWaveformRecord(*leafWrapper);
	if (status != 0) {
	  rtnStatus = 1;
	}
      } else if (leafType == "KEY OBJECT DOC") {
	status = this->testKeyObjectRecord(*leafWrapper);
	if (status != 0) {
	  rtnStatus = 1;
	}
      } else {
	strstream x3(logTxt, sizeof(logTxt));
	x3 << "E: Unrecognized leaf type: " << leafType << '\0';
	this->outputMessage(1, logTxt);
	rtnStatus = 1;
      }
      delete leafWrapper;
    }
  }

  return rtnStatus;
}

int
MPDIEval::testCurveRecord(MDICOMWrapper& w)
{
  MLogClient logClient;
  char logTxt[512] = "";
  TAG_TYPE_STRUCT m[]  = {
    { DCM_MAKETAG(0x0020, 0x0024), 1, 1 },	// Curve number
    { DCM_MAKETAG(0x0000, 0x0000), 0, 0 }
  };

  this->outputMessage(3, "CURVE RECORD evaluation");
  int status = 0;
  int rtnStatus = 0;
  int j = 0;
  for (j = 0; m[j].tag != 0; j++) {
    status = this->evalAttribute(w, m[j].tag, m[j].type123, "CURVE RECORD");
    if (status != 0) {
      rtnStatus = 1;
    }
  }

  return rtnStatus;
}

int
MPDIEval::testImageRecord(MDICOMWrapper& w)
{
  MLogClient logClient;
  char logTxt[512] = "";
  TAG_TYPE_STRUCT m[]  = {
    { DCM_MAKETAG(0x0020, 0x0013), 1, 1 },	// Instance Number
    { DCM_MAKETAG(0x0000, 0x0000), 0, 0 }
  };

  this->outputMessage(3, "IMAGE RECORD evaluation");
  int status = 0;
  int rtnStatus = 0;
  int j = 0;
  for (j = 0; m[j].tag != 0; j++) {
    status = this->evalAttribute(w, m[j].tag, m[j].type123, "IMAGE RECORD");
    if (status != 0) {
      rtnStatus = 1;
    }
  }

  return rtnStatus;
}

int
MPDIEval::testKeyObjectRecord(MDICOMWrapper& w)
{
  MLogClient logClient;
  char logTxt[512] = "";
  TAG_TYPE_STRUCT m[]  = {
    { DCM_MAKETAG(0x0020, 0x0013), 1, 2 },	// Instance Number
    { DCM_MAKETAG(0x0008, 0x0023), 1, 2 },	// Content Date
    { DCM_MAKETAG(0x0008, 0x0033), 1, 2 },	// Content Time
    { DCM_MAKETAG(0x0000, 0x0000), 0, 0 }
  };

  this->outputMessage(3, "RT PLAN RECORD evaluation");
  int status = 0;
  int rtnStatus = 0;
  int j = 0;
  for (j = 0; m[j].tag != 0; j++) {
    status = this->evalAttribute(w, m[j].tag, m[j].type123, "RT PLAN RECORD");
    if (status != 0) {
      rtnStatus = 1;
    }
  }

  return rtnStatus;
}

int
MPDIEval::testModalityLUTRecord(MDICOMWrapper& w)
{
  MLogClient logClient;
  char logTxt[512] = "";
  TAG_TYPE_STRUCT m[]  = {
    { DCM_MAKETAG(0x0020, 0x0026), 1, 1 },	// Lookup table number
    { DCM_MAKETAG(0x0000, 0x0000), 0, 0 }
  };

  this->outputMessage(3, "MODALITY LUT RECORD evaluation");
  int status = 0;
  int rtnStatus = 0;
  int j = 0;
  for (j = 0; m[j].tag != 0; j++) {
    status = this->evalAttribute(w, m[j].tag, m[j].type123, "MODALITY LUT RECORD");
    if (status != 0) {
      rtnStatus = 1;
    }
  }

  return rtnStatus;
}

int
MPDIEval::testOverlayRecord(MDICOMWrapper& w)
{
  MLogClient logClient;
  char logTxt[512] = "";
  TAG_TYPE_STRUCT m[]  = {
    { DCM_MAKETAG(0x0020, 0x0022), 1, 2 },	// Overlay Number
    { DCM_MAKETAG(0x0000, 0x0000), 0, 0 }
  };

  this->outputMessage(3, "OVERLAY RECORD evaluation");
  int status = 0;
  int rtnStatus = 0;
  int j = 0;
  for (j = 0; m[j].tag != 0; j++) {
    status = this->evalAttribute(w, m[j].tag, m[j].type123, "OVERLAY RECORD");
    if (status != 0) {
      rtnStatus = 1;
    }
  }

  return rtnStatus;
}

int
MPDIEval::testPresentationRecord(MDICOMWrapper& w)
{
  MLogClient logClient;
  char logTxt[512] = "";
  TAG_TYPE_STRUCT m[]  = {
    { DCM_MAKETAG(0x0020, 0x0013), 1, 2 },	// Instance Number
    { DCM_MAKETAG(0x0070, 0x0080), 1, 2 },	// Presentation Label
    { DCM_MAKETAG(0x0070, 0x0081), 2, 2 },	// Presentation Description
    { DCM_MAKETAG(0x0070, 0x0082), 1, 2 },	// Presentation Creation Date
    { DCM_MAKETAG(0x0070, 0x0083), 1, 2 },	// Presentation Creation Time
    { DCM_MAKETAG(0x0070, 0x0084), 2, 2 },	// Presentation Creator's Name
    { DCM_MAKETAG(0x0000, 0x0000), 0, 0 }
  };

  this->outputMessage(3, "PRESENTATION  RECORD evaluation");
  int status = 0;
  int rtnStatus = 0;
  int j = 0;
  for (j = 0; m[j].tag != 0; j++) {
    status = this->evalAttribute(w, m[j].tag, m[j].type123, "PRESENTATION  RECORD");
    if (status != 0) {
      rtnStatus = 1;
    }
  }

  return rtnStatus;
}

int
MPDIEval::testRTDoseRecord(MDICOMWrapper& w)
{
  MLogClient logClient;
  char logTxt[512] = "";
  TAG_TYPE_STRUCT m[]  = {
    { DCM_MAKETAG(0x0020, 0x0013), 1, 1 },	// Instance Number
    { DCM_MAKETAG(0x3004, 0x000A), 1, 1 },	// Dose Summation Type
    { DCM_MAKETAG(0x0000, 0x0000), 0, 0 }
  };

  this->outputMessage(3, "RT DOSE RECORD evaluation");
  int status = 0;
  int rtnStatus = 0;
  int j = 0;
  for (j = 0; m[j].tag != 0; j++) {
    status = this->evalAttribute(w, m[j].tag, m[j].type123, "RT DOSE RECORD");
    if (status != 0) {
      rtnStatus = 1;
    }
  }

  return rtnStatus;
}

int
MPDIEval::testRTPlanRecord(MDICOMWrapper& w)
{
  MLogClient logClient;
  char logTxt[512] = "";
  TAG_TYPE_STRUCT m[]  = {
    { DCM_MAKETAG(0x0020, 0x0013), 1, 2 },	// Instance Number
    { DCM_MAKETAG(0x300A, 0x0002), 1, 2 },	// RT Plan Label
    { DCM_MAKETAG(0x300A, 0x0006), 2, 2 },	// RT Plan Date
    { DCM_MAKETAG(0x300A, 0x0007), 2, 2 },	// RT Plan TIme
    { DCM_MAKETAG(0x0000, 0x0000), 0, 0 }
  };

  this->outputMessage(3, "RT PLAN RECORD evaluation");
  int status = 0;
  int rtnStatus = 0;
  int j = 0;
  for (j = 0; m[j].tag != 0; j++) {
    status = this->evalAttribute(w, m[j].tag, m[j].type123, "RT PLAN RECORD");
    if (status != 0) {
      rtnStatus = 1;
    }
  }

  return rtnStatus;
}

int
MPDIEval::testRTTreatmentRecord(MDICOMWrapper& w)
{
  MLogClient logClient;
  char logTxt[512] = "";
  TAG_TYPE_STRUCT m[]  = {
    { DCM_MAKETAG(0x0020, 0x0013), 1, 2 },	// Instance Number
    { DCM_MAKETAG(0x3008, 0x0250), 2, 2 },	// Treatment Date
    { DCM_MAKETAG(0x3008, 0x0251), 2, 2 },	// Treatment Time
    { DCM_MAKETAG(0x0000, 0x0000), 0, 0 }
  };

  this->outputMessage(3, "RT TREATMENT RECORD evaluation");
  int status = 0;
  int rtnStatus = 0;
  int j = 0;
  for (j = 0; m[j].tag != 0; j++) {
    status = this->evalAttribute(w, m[j].tag, m[j].type123, "RT TREATMENT RECORD");
    if (status != 0) {
      rtnStatus = 1;
    }
  }

  return rtnStatus;
}

int
MPDIEval::testRTStructureSetRecord(MDICOMWrapper& w)
{
  MLogClient logClient;
  char logTxt[512] = "";
  TAG_TYPE_STRUCT m[]  = {
    { DCM_MAKETAG(0x0020, 0x0013), 1, 2 },	// Instance Number
    { DCM_MAKETAG(0x3006, 0x0002), 1, 2 },	// Structure Set Label
    { DCM_MAKETAG(0x3006, 0x0008), 2, 2 },	// Structure Set Date
    { DCM_MAKETAG(0x3006, 0x0009), 2, 2 },	// Structure Set Time
    { DCM_MAKETAG(0x0000, 0x0000), 0, 0 }
  };

  this->outputMessage(3, "RT STRUCTURE SET RECORD evaluation");
  int status = 0;
  int rtnStatus = 0;
  int j = 0;
  for (j = 0; m[j].tag != 0; j++) {
    status = this->evalAttribute(w, m[j].tag, m[j].type123, "RT STRUCTURE SET RECORD");
    if (status != 0) {
      rtnStatus = 1;
    }
  }

  return rtnStatus;
}

int
MPDIEval::testSRDocumentRecord(MDICOMWrapper& w)
{
  MLogClient logClient;
  char logTxt[512] = "";
  TAG_TYPE_STRUCT m[]  = {
    { DCM_MAKETAG(0x0020, 0x0013), 1, 2 },	// Instance Number
    { DCM_MAKETAG(0x0040, 0xA491), 1, 2 },	// Completion Flag
    { DCM_MAKETAG(0x0040, 0xA491), 1, 2 },	// Verification Flag
    { DCM_MAKETAG(0x0008, 0x0023), 1, 2 },	// Content Date
    { DCM_MAKETAG(0x0008, 0x0033), 1, 2 },	// Content Time
    { DCM_MAKETAG(0x0000, 0x0000), 0, 0 }
  };

  this->outputMessage(3, "RT PLAN RECORD evaluation");
  int status = 0;
  int rtnStatus = 0;
  int j = 0;
  for (j = 0; m[j].tag != 0; j++) {
    status = this->evalAttribute(w, m[j].tag, m[j].type123, "RT PLAN RECORD");
    if (status != 0) {
      rtnStatus = 1;
    }
  }

  return rtnStatus;
}

int
MPDIEval::testVOILUTRecord(MDICOMWrapper& w)
{
  MLogClient logClient;
  char logTxt[512] = "";
  TAG_TYPE_STRUCT m[]  = {
    { DCM_MAKETAG(0x0020, 0x0026), 1, 1 },	// Lookup Table Number
    { DCM_MAKETAG(0x0000, 0x0000), 0, 0 }
  };

  this->outputMessage(3, "VOI LUT RECORD evaluation");
  int status = 0;
  int rtnStatus = 0;
  int j = 0;
  for (j = 0; m[j].tag != 0; j++) {
    status = this->evalAttribute(w, m[j].tag, m[j].type123, "VOI LUT RECORD");
    if (status != 0) {
      rtnStatus = 1;
    }
  }

  return rtnStatus;
}

int
MPDIEval::testWaveformRecord(MDICOMWrapper& w)
{
  MLogClient logClient;
  char logTxt[512] = "";
  TAG_TYPE_STRUCT m[]  = {
    { DCM_MAKETAG(0x0020, 0x0013), 1, 2 },	// Instance Number
    { DCM_MAKETAG(0x0008, 0x0023), 1, 2 },	// Content Date
    { DCM_MAKETAG(0x0008, 0x0033), 1, 2 },	// Content Time
    { DCM_MAKETAG(0x0000, 0x0000), 0, 0 }
  };

  this->outputMessage(3, "RT PLAN RECORD evaluation");
  int status = 0;
  int rtnStatus = 0;
  int j = 0;
  for (j = 0; m[j].tag != 0; j++) {
    status = this->evalAttribute(w, m[j].tag, m[j].type123, "RT PLAN RECORD");
    if (status != 0) {
      rtnStatus = 1;
    }
  }

  return rtnStatus;
}

int
MPDIEval::evalAttribute(MDICOMWrapper& w, DCM_TAG tag, int type123,
		const MString& ctxString)
{
  int rtnStatus = 0;
  MLogClient logClient;
  char logTxt[512] = "";
  DCM_ELEMENT e;
  ::memset(&e, 0, sizeof(e));
  e.tag = tag;
  CONDITION cond;
  cond = ::DCM_LookupElement(&e);
  if (cond != DCM_NORMAL) {
    ::COND_PopCondition(TRUE);
    e.description[0] = '\0';
  }
  strstream x1(logTxt, sizeof(logTxt));
  x1 << "V: Tag "
     << hex << setw(8) << setfill('0') << tag
     << " Type " << dec << type123
     << " " << e.description << '\0';
  this->outputMessage(3, logTxt);
  MString v = w.getString(tag);
  this->outputMessage(3, MString("    ->") + v);

  strstream s(logTxt, sizeof(logTxt));
  switch (type123) {
  case 1:
    if (! w.attributePresent(tag)) {
      s << ctxString << " "
	<< "Type 1 attribute is missing: "
	<< setw(8) << hex << setfill('0') << tag << '\0';
      this->outputMessage(1, logTxt);
      rtnStatus = 1;
    }
    if (rtnStatus == 0) {
      MString str = w.getString(tag);
      if (str.length() == 0) {
        s << ctxString << " "
	  << "Type 1 attribute is zero length: "
	  << setw(8) << hex << setfill('0') << tag << '\0';
        this->outputMessage(1, logTxt);
	rtnStatus = 1;
      }
    }
    break;
  case 2:
    if (! w.attributePresent(tag)) {
      s << ctxString << " "
	<< "Type 2 attribute is missing: "
	<< setw(8) << hex << setfill('0') << tag << '\0';
      this->outputMessage(1, logTxt);
      rtnStatus = 1;
    }
    break;
  case 3:
    break;
  default:
    break;
  }
  return rtnStatus;
}

bool
MPDIEval::isAllowableLeafType(const MString& leafType,
		char** forbiddenDirectoryTypes)
{
  bool isLegal = true;
  while(*forbiddenDirectoryTypes != 0 && (! isLegal)) {
    MString s = *forbiddenDirectoryTypes;
    if (s == leafType) {
      isLegal = false;
    }
    forbiddenDirectoryTypes++;
  }
  return isLegal;
}

// Private methods for test 5 start here

int
MPDIEval::fillIdentifierMaps(MStringMap& patientMap,
		MStringMap& studyMap, MStringMap& seriesMap,
		MStringMap& instanceMap)
{
  char logTxt[512] = "";
  int rtnStatus = 0;
  int patientCount = mDDRFile->getPatientCount();
  if (patientCount <= 0) {
    MString rtnComment =  "Patient count is <= 0; cannot execute test";
    this->outputMessage(1, rtnComment);
    return 1;
  }

  int idx = 0;
  for (idx = 0; idx < patientCount; idx++) {
    DDR_PATIENT p;
    ::memset(&p, 0, sizeof(p));
    int status = mDDRFile->getPatientRecord(idx, &p);
    if (status == 0) {
      strstream x2(logTxt, sizeof(logTxt));
      x2 << "Patient index: " << idx
	 << " patient information <"
	 << p.PatientID << "> <"
	 << p.PatientName << "> <"
	 << p.BirthDate << "> <"
	 << p.Sex << ">" << '\0';
      this->outputMessage(3, logTxt);
    } else {
      strstream x3(logTxt, sizeof(logTxt));
      x3 << "Could not get patient record at index: " << idx << '\0';
      this->outputMessage(1, logTxt);
      rtnStatus = 1;
      continue;
    }
    if (::strlen(p.PatientID) == 0) {
      strstream x4(logTxt, sizeof(logTxt));
      x4 << "Zero length patient ID at index: " << idx << '\0';
      this->outputMessage(1, logTxt);
      rtnStatus = 1;
      continue;
    }
    MStringMap::iterator it = patientMap.find(p.PatientID);
    if (it != patientMap.end()) {
      strstream x5(logTxt, sizeof(logTxt));
      x5 << "Duplicate Patient ID found in DICOMDIR: " << p.PatientID << '\0';
      this->outputMessage(1, logTxt);
      rtnStatus = 1;
      continue;
    }
    patientMap[p.PatientID] = p.PatientID;
    if (this->fillMapsBelowPatient(p.StudyLinkOffset,
			    studyMap, seriesMap, instanceMap) != 0) {
      rtnStatus = 1;
    }
  }
  return rtnStatus;
}

int
MPDIEval::fillMapsBelowPatient(U32 studyLinkOffset,
		                  MStringMap& studyMap, MStringMap& seriesMap,
				                    MStringMap& instanceMap)
{
  char logTxt[512] = "";
  int studyCount = mDDRFile->getStudyCount(studyLinkOffset);
  strstream x1(logTxt, sizeof(logTxt));
  x1 << " study count = " << studyCount << '\0';
  this->outputMessage(3, logTxt);

  int idx = 0;
  int rtnStatus = 0;
  int status = 0;
  for (idx = 0; idx < studyCount; idx++) {
    MDICOMWrapper* studyWrapper = mDDRFile->getStudyRecord(idx, studyLinkOffset);
    if (studyWrapper == 0) {
      strstream x2(logTxt, sizeof(logTxt));
      x2 << " Could not get study record at index: " << idx
	 << " for patient with offset: " << studyLinkOffset
	 << '\0';
      this->outputMessage(1, logTxt);
      rtnStatus = 1;
    } else {
      int j = 0;
      MString studyInstanceUID = studyWrapper->getString(DCM_MAKETAG(0x0020, 0x000D));
      this->outputMessage(3, MString("Recording Study Instance UID: ") + studyInstanceUID);
      MStringMap::iterator it = studyMap.find(studyInstanceUID);
      if (it != studyMap.end()) {
	strstream x5(logTxt, sizeof(logTxt));
	x5 << "Duplicate Study Instance UID found in DICOMDIR: " << studyInstanceUID << '\0';
	this->outputMessage(1, logTxt);
	rtnStatus = 1;
	continue;
      }
      studyMap[studyInstanceUID] = studyInstanceUID;
      U32 firstSeriesOffset = studyWrapper->getU32(DCM_DIRLOWERLEVELOFFSET);
      delete studyWrapper;
      if (this->fillMapsBelowStudy(firstSeriesOffset, seriesMap, instanceMap) != 0) {
	rtnStatus = 1;
      }
    }
  }
  return rtnStatus;
}

int
MPDIEval::fillMapsBelowStudy(U32 seriesLinkOffset,
		                  MStringMap& seriesMap, MStringMap& instanceMap)
{
  char logTxt[512] = "";
  int seriesCount = mDDRFile->getSeriesCount(seriesLinkOffset);
  strstream x1(logTxt, sizeof(logTxt));
  x1 << " series count = " << seriesCount << '\0';
  this->outputMessage(3, logTxt);

  int idx = 0;
  int rtnStatus = 0;
  int status = 0;
  for (idx = 0; idx < seriesCount; idx++) {
    MDICOMWrapper* seriesWrapper = mDDRFile->getSeriesRecord(idx, seriesLinkOffset);
    if (seriesWrapper == 0) {
      strstream x2(logTxt, sizeof(logTxt));
      x2 << " Could not get series record at index: " << idx
	 << " for series with offset: " << seriesLinkOffset
	 << '\0';
      this->outputMessage(1, logTxt);
      rtnStatus = 1;
    } else {
      int j = 0;
      MString seriesInstanceUID = seriesWrapper->getString(DCM_MAKETAG(0x0020, 0x000E));
      this->outputMessage(3, MString("Recording Series Instance UID: ") + seriesInstanceUID);
      MStringMap::iterator it = seriesMap.find(seriesInstanceUID);
      if (it != seriesMap.end()) {
	strstream x5(logTxt, sizeof(logTxt));
	x5 << "Duplicate Series Instance UID found in DICOMDIR: " << seriesInstanceUID << '\0';
	this->outputMessage(1, logTxt);
	rtnStatus = 1;
	continue;
      }
      seriesMap[seriesInstanceUID] = seriesInstanceUID;
      U32 firstInstanceOffset = seriesWrapper->getU32(DCM_DIRLOWERLEVELOFFSET);
      delete seriesWrapper;
      if (this->fillMapsBelowSeries(firstInstanceOffset, instanceMap) != 0) {
	rtnStatus = 1;
      }
    }
  }
  return rtnStatus;
}

int
MPDIEval::fillMapsBelowSeries(U32 instanceLinkOffset,
		                  MStringMap& instanceMap)
{
  char logTxt[512] = "";
  int instanceCount = mDDRFile->getLeafCount(instanceLinkOffset);
  strstream x1(logTxt, sizeof(logTxt));
  x1 << " instance count = " << instanceCount << '\0';
  this->outputMessage(3, logTxt);

  int idx = 0;
  int rtnStatus = 0;
  int status = 0;
  for (idx = 0; idx < instanceCount; idx++) {
    MDICOMWrapper* instanceWrapper = mDDRFile->getLeafRecord(idx, instanceLinkOffset);
    if (instanceWrapper == 0) {
      strstream x2(logTxt, sizeof(logTxt));
      x2 << " Could not get instance record at index: " << idx
	 << " for instance with offset: " << instanceLinkOffset
	 << '\0';
      this->outputMessage(1, logTxt);
      rtnStatus = 1;
    } else {
      int j = 0;
      MString SOPInstanceUID = instanceWrapper->getString(DCM_MAKETAG(0x0008, 0x0018));
      if (SOPInstanceUID == "") {
	this->outputMessage(3, MString("No SOP Instance UID at Image Level"));
	delete instanceWrapper;
	continue;
      }
      this->outputMessage(3, MString("Recording SOP Instance UID: ") + SOPInstanceUID);
      MStringMap::iterator it = instanceMap.find(SOPInstanceUID);
      if (it != instanceMap.end()) {
	strstream x5(logTxt, sizeof(logTxt));
	x5 << "Duplicate SOP Instance UID found in DICOMDIR: " << SOPInstanceUID << '\0';
	this->outputMessage(1, logTxt);
	rtnStatus = 1;
	continue;
      }
      instanceMap[SOPInstanceUID] = SOPInstanceUID;
      delete instanceWrapper;
    }
  }
  return rtnStatus;
}

// Private methods for test 6 start here

int
MPDIEval::fillFileVector(MStringVector& v)
{
  char logTxt[512] = "";
  int rtnStatus = 0;
  int patientCount = mDDRFile->getPatientCount();
  if (patientCount <= 0) {
    MString rtnComment =  "Patient count is <= 0; cannot execute test";
    this->outputMessage(1, rtnComment);
    return 1;
  }

  int idx = 0;
  for (idx = 0; idx < patientCount; idx++) {
    DDR_PATIENT p;
    ::memset(&p, 0, sizeof(p));
    int status = mDDRFile->getPatientRecord(idx, &p);
    if (status == 0) {
    } else {
      strstream x3(logTxt, sizeof(logTxt));
      x3 << "Could not get patient record at index: " << idx << '\0';
      this->outputMessage(1, logTxt);
      rtnStatus = 1;
      continue;
    }
    U32 studyOffset = p.StudyLinkOffset;
    if (this->fillFileVectorStudy(v, studyOffset) != 0) {
      rtnStatus = 1;
      break;
    }
  }
  return rtnStatus;
}

int
MPDIEval::fillFileVectorStudy(MStringVector& v, U32 studyLinkOffset)
{
  char logTxt[512] = "";
  int studyCount = mDDRFile->getStudyCount(studyLinkOffset);

  int idx = 0;
  int rtnStatus = 0;
  int status = 0;
  for (idx = 0; idx < studyCount; idx++) {
    MDICOMWrapper* studyWrapper = mDDRFile->getStudyRecord(idx, studyLinkOffset);
    if (studyWrapper == 0) {
      strstream x2(logTxt, sizeof(logTxt));
      x2 << " Could not get study record at index: " << idx
	 << " for patient with offset: " << studyLinkOffset
	 << '\0';
      this->outputMessage(1, logTxt);
      rtnStatus = 1;
    } else {
      int j = 0;
      U32 firstSeriesOffset = studyWrapper->getU32(DCM_DIRLOWERLEVELOFFSET);
      delete studyWrapper;
      if (this->fillFileVectorSeries(v, firstSeriesOffset) != 0) {
	rtnStatus = 1;
	break;
      }
    }
  }
  return rtnStatus;
}

int
MPDIEval::fillFileVectorSeries(MStringVector& v, U32 seriesLinkOffset)
{
  char logTxt[512] = "";
  int seriesCount = mDDRFile->getSeriesCount(seriesLinkOffset);
  strstream x1(logTxt, sizeof(logTxt));
  x1 << " series count = " << seriesCount << '\0';
  this->outputMessage(3, logTxt);

  int idx = 0;
  int rtnStatus = 0;
  int status = 0;
  for (idx = 0; idx < seriesCount; idx++) {
    MDICOMWrapper* seriesWrapper = mDDRFile->getSeriesRecord(idx, seriesLinkOffset);
    if (seriesWrapper == 0) {
      strstream x2(logTxt, sizeof(logTxt));
      x2 << " Could not get series record at index: " << idx
	 << " for series with offset: " << seriesLinkOffset
	 << '\0';
      this->outputMessage(1, logTxt);
      rtnStatus = 1;
    } else {
      int j = 0;
      MString seriesInstanceUID = seriesWrapper->getString(DCM_MAKETAG(0x0020, 0x000E));
      U32 firstInstanceOffset = seriesWrapper->getU32(DCM_DIRLOWERLEVELOFFSET);
      delete seriesWrapper;
      if (this->fillFileVectorInstanceLevel(v, firstInstanceOffset) != 0) {
	rtnStatus = 1;
	break;
      }
    }
  }
  return rtnStatus;
}

int
MPDIEval::fillFileVectorInstanceLevel(MStringVector& v, U32 instanceLinkOffset)
{
  char logTxt[512] = "";
  int instanceCount = mDDRFile->getLeafCount(instanceLinkOffset);
  strstream x1(logTxt, sizeof(logTxt));
  x1 << " instance count = " << instanceCount << '\0';
  this->outputMessage(3, logTxt);

  int idx = 0;
  int rtnStatus = 0;
  int status = 0;
  for (idx = 0; idx < instanceCount; idx++) {
    MDICOMWrapper* instanceWrapper = mDDRFile->getLeafRecord(idx, instanceLinkOffset);
    if (instanceWrapper == 0) {
      strstream x2(logTxt, sizeof(logTxt));
      x2 << " Could not get instance record at index: " << idx
	 << " for instance with offset: " << instanceLinkOffset
	 << '\0';
      this->outputMessage(1, logTxt);
      rtnStatus = 1;
    } else {
      int j = 0;
      MString referencedFileID = instanceWrapper->getString(DCM_MAKETAG(0x0004, 0x1500));
      v.push_back(referencedFileID);
      delete instanceWrapper;
    }
  }
  return rtnStatus;
}

int
MPDIEval::countDirectoryLevels(const MString& referencedFileID)
{
  const char* s = referencedFileID.strData();

  int count = 0;
  for (; *s != '\0'; s++) {
    if (*s == '\\') {
      count++;
    }
  }
  return count;
}

int
MPDIEval::testFileIDName(const MString& referencedFileID)
{
  const char* s = referencedFileID.strData();
  int rtnStatus = 0;
  bool illegalCharacter = false;
  bool illegalLength = false;
  char legalChars[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_";
  char logTxt[512] = "";

  int componentLength = 0;
  char c;
  char* cPtr = 0;

  for (; *s != '\0'; s++) {
    c = *s;
    if (c == '\\') {
      if (componentLength > 8) {
	rtnStatus = 1;
	if (! illegalLength) {	// Then, we have not seen this yet
	  strstream x1(logTxt, sizeof(logTxt));
	  x1 << "Component length exceeds 8 characters in referenced file ID: "
		  << referencedFileID << '\0';
	  this->outputMessage(1, logTxt);
	}
	illegalLength = true;
      }
      componentLength = 0;
    } else {
      componentLength++;
      cPtr = ::strchr(legalChars, c);
      if (cPtr == 0) {
	rtnStatus = 1;
	if (! illegalCharacter) {	// Then, we have not seen this yet
	  strstream x2(logTxt, sizeof(logTxt));
	  x2 << "Illegal character (" << c << ") in referenced file ID: "
		  << referencedFileID << '\0';
	  this->outputMessage(1, logTxt);
	}
	illegalCharacter = true;
      }
    }
  }

  if (componentLength > 8) {
    rtnStatus = 1;
    if (! illegalLength) {	// Then, we have not seen this yet
      strstream x1(logTxt, sizeof(logTxt));
      x1 << "Component length exceeds 8 characters in referenced file ID: "
    	  << referencedFileID << '\0';
      this->outputMessage(1, logTxt);
    }
  }
  return rtnStatus;
}

// Private methods for test 7 start here
int
MPDIEval::fillLeafOffsetVector(MU32Vector& v)
{
  char logTxt[512] = "";
  int rtnStatus = 0;
  int patientCount = mDDRFile->getPatientCount();
  if (patientCount <= 0) {
    MString rtnComment =  "Patient count is <= 0; cannot execute test";
    this->outputMessage(1, rtnComment);
    return 1;
  }

  int idx = 0;
  for (idx = 0; idx < patientCount; idx++) {
    DDR_PATIENT p;
    ::memset(&p, 0, sizeof(p));
    int status = mDDRFile->getPatientRecord(idx, &p);
    if (status == 0) {
    } else {
      strstream x3(logTxt, sizeof(logTxt));
      x3 << "Could not get patient record at index: " << idx << '\0';
      this->outputMessage(1, logTxt);
      rtnStatus = 1;
      continue;
    }
    U32 studyOffset = p.StudyLinkOffset;
    if (this->fillLeafOffsetVectorStudyLevel(v, studyOffset) != 0) {
      rtnStatus = 1;
      break;
    }
  }
  return rtnStatus;
}

int
MPDIEval::fillLeafOffsetVectorStudyLevel(MU32Vector& v, U32 studyLinkOffset)
{
  char logTxt[512] = "";
  int studyCount = mDDRFile->getStudyCount(studyLinkOffset);

  int idx = 0;
  int rtnStatus = 0;
  int status = 0;
  for (idx = 0; idx < studyCount; idx++) {
    MDICOMWrapper* studyWrapper = mDDRFile->getStudyRecord(idx, studyLinkOffset);
    if (studyWrapper == 0) {
      strstream x2(logTxt, sizeof(logTxt));
      x2 << " Could not get study record at index: " << idx
	 << " for patient with offset: " << studyLinkOffset
	 << '\0';
      this->outputMessage(1, logTxt);
      rtnStatus = 1;
    } else {
      int j = 0;
      U32 firstSeriesOffset = studyWrapper->getU32(DCM_DIRLOWERLEVELOFFSET);
      delete studyWrapper;
      if (this->fillLeafOffsetVectorSeriesLevel(v, firstSeriesOffset) != 0) {
	rtnStatus = 1;
	break;
      }
    }
  }
  return rtnStatus;
}

int
MPDIEval::fillLeafOffsetVectorSeriesLevel(MU32Vector& v, U32 seriesLinkOffset)
{
  char logTxt[512] = "";
  int seriesCount = mDDRFile->getSeriesCount(seriesLinkOffset);
  strstream x1(logTxt, sizeof(logTxt));
  x1 << " series count = " << seriesCount << '\0';
  this->outputMessage(3, logTxt);
  if (seriesCount < 0) {
    strstream x2(logTxt, sizeof(logTxt));
    x2 << "Could not find all series records starting at offset: " << seriesLinkOffset << '\0';
    this->outputMessage(1, logTxt);
    return 1;
  }

  int idx = 0;
  int rtnStatus = 0;
  int status = 0;
  for (idx = 0; idx < seriesCount; idx++) {
    MDICOMWrapper* seriesWrapper = mDDRFile->getSeriesRecord(idx, seriesLinkOffset);
    if (seriesWrapper == 0) {
      strstream x2(logTxt, sizeof(logTxt));
      x2 << " Could not get series record at index: " << idx
	 << " for series with offset: " << seriesLinkOffset
	 << '\0';
      this->outputMessage(1, logTxt);
      rtnStatus = 1;
    } else {
      int j = 0;
      MString seriesInstanceUID = seriesWrapper->getString(DCM_MAKETAG(0x0020, 0x000E));
      U32 firstInstanceOffset = seriesWrapper->getU32(DCM_DIRLOWERLEVELOFFSET);
      delete seriesWrapper;
      if (this->fillLeafOffsetVectorInstanceLevel(v, firstInstanceOffset) != 0) {
	rtnStatus = 1;
	break;
      }
    }
  }
  return rtnStatus;
}

int
MPDIEval::fillLeafOffsetVectorInstanceLevel(MU32Vector& v, U32 instanceLinkOffset)
{
  char logTxt[512] = "";
  int instanceCount = mDDRFile->getLeafCount(instanceLinkOffset);
  strstream x1(logTxt, sizeof(logTxt));
  x1 << " instance count = " << instanceCount << '\0';
  this->outputMessage(3, logTxt);

  int idx = 0;
  int rtnStatus = 0;
  int status = 0;
  U32 currentInstanceLink = instanceLinkOffset;
  for (idx = 0; idx < instanceCount; idx++) {
    MDICOMWrapper* instanceWrapper = mDDRFile->getLeafRecord(idx, instanceLinkOffset);
    if (instanceWrapper == 0) {
      strstream x2(logTxt, sizeof(logTxt));
      x2 << " Could not get instance record at index: " << idx
	 << " for instance with offset: " << instanceLinkOffset
	 << '\0';
      this->outputMessage(1, logTxt);
      rtnStatus = 1;
    } else {
      int j = 0;
      v.push_back(currentInstanceLink);
      currentInstanceLink = instanceWrapper->getU32(DCM_MAKETAG(0x0004, 0x1400));
      delete instanceWrapper;
    }
  }
  return rtnStatus;
}

typedef struct {
  DCM_TAG tagInDirectory;
  DCM_TAG tagInFile;
} TAG_EQUIVALENT_VALUES;

int
MPDIEval::testLeafContents(U32 offset)
{
  char logTxt[1024] = "";
  int rtnStatus = 0;
  int idx = 0;
  MDICOMWrapper leafWrapper;

  TAG_EQUIVALENT_VALUES m[] = {
	{DCM_MAKETAG(0x0004, 0x1510),		// Referenced SOP Class UID
	 DCM_MAKETAG(0x0008, 0x0016)},		// SOP Class UID

	{DCM_MAKETAG(0x0004, 0x1511),		// Referenced SOP Instance UID
	 DCM_MAKETAG(0x0008, 0x0018)},		// SOP Instance UID

	{DCM_MAKETAG(0x0004, 0x1512),		// Referenced Transfer Syntax
	 DCM_MAKETAG(0x0002, 0x0010)},		// Transfer Syntax UID

	{0, 0}
  };
  MString directoryString;
  MString fileString;
  MString referencedFileID;

  MDICOMWrapper* dirWrapper = mDDRFile->getLeafRecord(0, offset);
  if (dirWrapper == 0) {
    strstream x1(logTxt, sizeof(logTxt));
    x1 << "Could not get leaf records at offset: " << offset << '\0';
    this->outputMessage(1, logTxt);
    rtnStatus = 1;
  }

  if (rtnStatus == 0) {
    referencedFileID = dirWrapper->getString(DCM_MAKETAG(0x0004, 0x1500));
    if (referencedFileID == "") {
      strstream x2(logTxt, sizeof(logTxt));
      x2 << "Could not get 0004 1500 Referenced File ID at offset: " << offset << '\0';
      this->outputMessage(1, logTxt);
      rtnStatus = 1;
    }
  }

  if (rtnStatus == 0) {
    MString path = mRootDirectory + "/" + referencedFileID;
    path.substitute('\\', '/');
    leafWrapper.open(path, DCM_PART10FILE);

    for (idx = 0; m[idx].tagInDirectory != 0x00000000; idx++) {
      directoryString = dirWrapper->getString(m[idx].tagInDirectory);
      fileString = leafWrapper.getString(m[idx].tagInFile);
      strstream x3(logTxt, sizeof(logTxt));
      this->outputMessage(3, "");
      x3 << hex << setw(8) << setfill('0') << m[idx].tagInDirectory
	      << " " << directoryString << '\0';
      this->outputMessage(3, logTxt);
      strstream x4(logTxt, sizeof(logTxt));
      x4 << hex << setw(8) << setfill('0') << m[idx].tagInFile
	      << " " << fileString << '\0';
      this->outputMessage(3, logTxt);
      if (directoryString != fileString) {
        strstream x5(logTxt, sizeof(logTxt));
        x5 << "Mismatch between directory record entry and entry in referenced file set" << endl;
        x5 << hex << setw(8) << setfill('0') << m[idx].tagInDirectory
	      << " " << directoryString << " : ";
        x5 << hex << setw(8) << setfill('0') << m[idx].tagInFile
	      << " " << fileString << '\0';
	this->outputMessage(1, logTxt);
        rtnStatus = 1;
      }
    }
    MString xferSyntaxUID = leafWrapper.getString(DCM_MAKETAG(0x0002, 0x0010));
    if (xferSyntaxUID != "1.2.840.10008.1.2.1") {
      strstream x6(logTxt, sizeof(logTxt));
      x6 << "Referenced file does not have correct Xfer Syntax UID, expecting EVRLE, found: "
	      << xferSyntaxUID
	      << " in file " << referencedFileID << '\0';
      this->outputMessage(1, logTxt);
      rtnStatus = 1;
    }
  }

exit_testLeafContents:
  delete dirWrapper;
  return rtnStatus;
}

int
MPDIEval::testMetaHeader(const MString& referencedFileID)
{
  char logTxt[1024] = "";
  int rtnStatus = 0;
  int idx = 0;

  TAG_EQUIVALENT_VALUES m[] = {
	{DCM_MAKETAG(0x0002, 0x0002),		// Media Stored SOP Class UID
	 DCM_MAKETAG(0x0008, 0x0016)},		// SOP Class UID

	{DCM_MAKETAG(0x0002, 0x0003),		// Media Stored SOP Instance UID
	 DCM_MAKETAG(0x0008, 0x0018)},		// SOP Instance UID

	{0, 0}
  };
  MString directoryString;
  MString fileString;

  MString path = mRootDirectory + "/" + referencedFileID;
  path.substitute('\\', '/');
  MDICOMWrapper leafWrapper;
  leafWrapper.open(path, DCM_PART10FILE);

  if (rtnStatus == 0) {
    for (idx = 0; m[idx].tagInDirectory != 0x00000000; idx++) {
      directoryString = leafWrapper.getString(m[idx].tagInDirectory);
      fileString = leafWrapper.getString(m[idx].tagInFile);
      strstream x3(logTxt, sizeof(logTxt));
      this->outputMessage(3, "");
      x3 << hex << setw(8) << setfill('0') << m[idx].tagInDirectory
	      << " " << directoryString << '\0';
      this->outputMessage(3, logTxt);
      strstream x4(logTxt, sizeof(logTxt));
      x4 << hex << setw(8) << setfill('0') << m[idx].tagInFile
	      << " " << fileString << '\0';
      this->outputMessage(3, logTxt);
      if (directoryString != fileString) {
        strstream x5(logTxt, sizeof(logTxt));
        x5 << "Mismatch between Meta Header entry and entry in file " << endl;
        x5 << hex << setw(8) << setfill('0') << m[idx].tagInDirectory
	      << " " << directoryString << " : ";
        x5 << hex << setw(8) << setfill('0') << m[idx].tagInFile
	      << " " << fileString << '\0';
	this->outputMessage(1, logTxt);
        rtnStatus = 1;
      }
    }
  }

  return rtnStatus;
}

// Private methods for test 9 start here

int
MPDIEval::listAllFiles(MStringVector& fileVector, const MString& path) 
{
  MFileOperations f;
  f.scanDirectory(path);
  int count = f.filesInDirectory();
  int i = 0;
  int rtnStatus = 0;

  for (i = 0; i < count && rtnStatus == 0; i++) {
    MString s = f.fileName(i);
    MString fullPath = path + "/" + s;
    if (f.isDirectory(fullPath)) {
      fileVector.push_back(fullPath);
      if (this->listAllFiles(fileVector, fullPath) != 0) {
	rtnStatus = 1;
      }
    } else {
      fileVector.push_back(fullPath);
    }
  }
  return rtnStatus;
}

int
MPDIEval::testFileNameISO9660(const MString& path)
{
  char pathText[512] = "";
  path.safeExport(pathText, sizeof(pathText));

  char* currentToken = 0;
  char* nextToken = 0;

  currentToken = ::strtok(pathText, "/");
  nextToken = ::strtok(0, "/");
  int rtnStatus = 0;
  bool illegalCharacter = false;
  bool illegalLength = false;
  char legalChars[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_";
  char logTxt[512] = "";

  // This first loop is for the components that are
  // directories
  while(nextToken != 0) {
    this->outputMessage(3, MString("Testing Component: ") + currentToken);
    if (this->testCharactersInString(currentToken, legalChars) != 0) {
      strstream xa(logTxt, sizeof(logTxt));
      xa << "Illegal character found in path: " << currentToken << '\0';
      this->outputMessage(1, logTxt);
      this->outputMessage(1, "Legal characters are A-Z, 0-9, _");
      rtnStatus = 1;
    }
    if (::strlen(currentToken) > 8) {
      strstream xb(logTxt, sizeof(logTxt));
      xb << "Component length exceeds 8 characters: " << currentToken;
      this->outputMessage(1, logTxt);
      rtnStatus = 1;
    }
    currentToken = nextToken;
    nextToken = ::strtok(0, "/");
  }

  int componentLength = 0;
  char c;
  char* cPtr = 0;

  MString x(currentToken);
  MString name("");
  MString extension("");
  if (x.tokenExists('.', 2)) {
    strstream x1(logTxt, sizeof(logTxt));
    x1 << "Illegal component (" << x << ") found in: " << path << '\0';
    this->outputMessage(1, logTxt);
    this->outputMessage(1, "Found second '.' in component");
    rtnStatus = 1;
  } else if (x.tokenExists('.', 1)) {
    name = x.getToken('.', 0);
    extension = x.getToken('.', 1);
  } else {
    name = x;
  }
  if (name.length() > 8) {
    strstream x2(logTxt, sizeof(logTxt));
    x2 << "Length of file name exceeds 8 characters: " << x << '\0';
    this->outputMessage(1, logTxt);
    strstream x3(logTxt, sizeof(logTxt));
    x3 << "Full path: " << path << '\0';
    this->outputMessage(1, logTxt);
    rtnStatus = 1;
  }
  if (extension.length() > 3) {
    strstream x2(logTxt, sizeof(logTxt));
    x2 << "Length of file extension exceeds 3 characters: " << x << '\0';
    this->outputMessage(1, logTxt);
    strstream x3(logTxt, sizeof(logTxt));
    x3 << "Full path: " << path << '\0';
    this->outputMessage(1, logTxt);
    rtnStatus = 1;
  }

  return rtnStatus;
}

int
MPDIEval::testCharactersInString(const MString& path, const char* legalChars)
{
  char* ptr = path.strData();
  int len = path.length();
  int i;
  char c;

  for (i = 0; i < len; i++) {
    c = *ptr++;
    const char* p = strchr(legalChars, c);
    if (p == NULL) {
      return 1;
    }
  }
  return 0;
}

int
MPDIEval::testDICOMFileForIHE_PDI(const MString& referencedFileID)
{
  int x = referencedFileID.find("IHE_PDI");
  if (x >= 0) {
    return 1;
  } else {
    return 0;
  }
}
