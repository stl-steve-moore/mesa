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

// $Id: MPDIEval.hpp,v 1.11 2006/06/29 16:08:32 bhasselfeld Exp $ $Author: bhasselfeld $ $Revision: 1.11 $ $Date: 2006/06/29 16:08:32 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MPDIEval.hpp
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
//	$Revision: 1.11 $
//
//  = DATE RELEASED
//	$Date: 2006/06/29 16:08:32 $
//
//  = COMMENTS
//	

#ifndef MPDIEvalISIN
#define MPDIEvalISIN

//#include <iostream>
//#include <string>
#include <vector>
//#include "ctn_api.h"
#include "MDDRFile.hpp"

using namespace std;

typedef vector < U32 > MU32Vector;


class MPDIEval
// = TITLE
//	MPDIEval - 
//
// = DESCRIPTION
//
{

public:
  // = The standard methods in this framework.

  /// Default constructor.
  MPDIEval();

  MPDIEval(const MPDIEval& cpy);
  ///< Copy constructor

  virtual ~MPDIEval();
  ///< Destructor.

  virtual void printOn(ostream& s) const;
  /**<\brief This method is used in conjunction with the streaming operator <<
  	     to print the current state of MPDIEval. */

  virtual void streamIn(istream& s);
  /**<\brief This method is used in conjunction with the streaming operator >>
  	     to read the current state of MPDIEval. */

  // = Class specific methods.
  int initialize(const MString& rootDirectory);

  int runTest(int testNumber, int reportLevel,
		  MString& rtnTestDescription, MString& rtnComment);

protected:

private:
  MString mRootDirectory;
  MDDRFile* mDDRFile;
  int mReportLevel;

  void outputMessage(int level, const MString& txt);

  int checkUID(const MString& uid);

  int runTest1(MString& rtnTestDescription, MString& rtnComment);
  int runTest2(MString& rtnTestDescription, MString& rtnComment);
  int runTest3(MString& rtnTestDescription, MString& rtnComment);
  int runTest4(MString& rtnTestDescription, MString& rtnComment);
  int runTest5(MString& rtnTestDescription, MString& rtnComment);
  int runTest6(MString& rtnTestDescription, MString& rtnComment);
  int runTest7(MString& rtnTestDescription, MString& rtnComment);
  int runTest8(MString& rtnTestDescription, MString& rtnComment);
  int runTest9(MString& rtnTestDescription, MString& rtnComment);
  int runTest10(MString& rtnTestDescription, MString& rtnComment);
  int runTest11(MString& rtnTestDescription, MString& rtnComment);
  int runTest12(MString& rtnTestDescription, MString& rtnComment);
  int runTest13(MString& rtnTestDescription, MString& rtnComment);
  int runTest14(MString& rtnTestDescription, MString& rtnComment);

  // These all go with test 4
  int testStudyRecords(U32 offset);
  int testSeriesRecords(U32 offset);
  int testLeafRecords(U32 offset);
  int testCurveRecord(MDICOMWrapper& w);
  int testImageRecord(MDICOMWrapper& w);
  int testKeyObjectRecord(MDICOMWrapper& w);
  int testModalityLUTRecord(MDICOMWrapper& w);
  int testOverlayRecord(MDICOMWrapper& w);
  int testPresentationRecord(MDICOMWrapper& w);
  int testRTDoseRecord(MDICOMWrapper& w);
  int testRTPlanRecord(MDICOMWrapper& w);
  int testRTTreatmentRecord(MDICOMWrapper& w);
  int testRTStructureSetRecord(MDICOMWrapper& w);
  int testSRDocumentRecord(MDICOMWrapper& w);
  int testVOILUTRecord(MDICOMWrapper& w);
  int testWaveformRecord(MDICOMWrapper& w);
  int evalAttribute(MDICOMWrapper& w, DCM_TAG tag, int type123,
		  const MString& ctxString);
  bool isAllowableLeafType(const MString& leafType, char** forbiddenRecords);

  // These go with test 5
  int fillIdentifierMaps(MStringMap& patientMap,
		  MStringMap& studyMap, MStringMap& seriesMap,
		  MStringMap& instanceMap);
  int fillMapsBelowPatient(U32 studyLinkOffset,
		  MStringMap& studyMap, MStringMap& seriesMap,
		  MStringMap& instanceMap);
  int fillMapsBelowStudy(U32 seriesLinkOffset,
		  MStringMap& seriesMap, MStringMap& instanceMap);
  int fillMapsBelowSeries(U32 instanceLinkOffset,
		  MStringMap& instanceMap);

  // These go with test 6
  int fillFileVector(MStringVector& v);
  int fillFileVectorStudy(MStringVector& v, U32 studyLinkOffset);
  int fillFileVectorSeries(MStringVector& v, U32 seriesLinkOffset);
  int fillFileVectorInstanceLevel(MStringVector& v, U32 instanceLinkOffset);
  int countDirectoryLevels(const MString& referencedFileID);
  int testFileIDName(const MString& referencedFileID);

  // These go with test 7
  int fillLeafOffsetVector(MU32Vector& v);
  int fillLeafOffsetVectorStudyLevel(MU32Vector& v, U32 studyLinkOffset);
  int fillLeafOffsetVectorSeriesLevel(MU32Vector& v, U32 seriesLinkOffset);
  int fillLeafOffsetVectorInstanceLevel(MU32Vector& v, U32 instanceLinkOffset);
  int testLeafContents(U32 offset);

  // These go with test 8
  int testMetaHeader(const MString& referencedFileID);

  // These go with test 9
  int listAllFiles(MStringVector& fileVector, const MString& path);
  int testFileNameISO9660(const MString& path);
  int testCharactersInString(const MString& str, const char* legalCharacters);

  // These go with test 13
  int testDICOMFileForIHE_PDI(const MString& referencedFileID);
};

inline ostream& operator<< (ostream& s, const MPDIEval& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MPDIEval& c) {
  c.streamIn(s);
  return s;
}

#endif
