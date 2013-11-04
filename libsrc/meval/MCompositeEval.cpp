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
#include "MCompositeEval.hpp"
#include "MDICOMWrapper.hpp"
#include "MDICOMElementEval.hpp"

static char rcsid[] = "$Id: MCompositeEval.cpp,v 1.7 2003/12/19 20:38:46 smm Exp $";

MCompositeEval::MCompositeEval() :
  mTestWrapper(0),
  mPatternWrapper(0),
  mVerbose(false)
{
}

MCompositeEval::MCompositeEval(const MCompositeEval& cpy) :
  mTestWrapper(cpy.mTestWrapper),
  mPatternWrapper(cpy.mPatternWrapper),
  mVerbose(cpy.mVerbose)
{
}

MCompositeEval::~MCompositeEval()
{
}

void
MCompositeEval::printOn(ostream& s) const
{
  s << "MCompositeEval";
}

void
MCompositeEval::streamIn(istream& s)
{
  //s >> this->member;
}

// Non boiler-plate methods below

void
MCompositeEval::verbose(bool flag)
{
  mVerbose = flag;
}

void
MCompositeEval::setTestObject(MDICOMWrapper *w)
{
  mTestWrapper = w;
}


void
MCompositeEval::setPatternObject(MDICOMWrapper *w)
{
  mPatternWrapper = w;
}

typedef struct {
  char* label;
  DCM_TAG tag;
} ATTRIBUTE;

int
MCompositeEval::evalPatientModule(int level, const MString& language)
{
  int x = this->consistencyTest();
  if (x != 0)
    return x;

  int rtnValue = 0;
  MString testVal;
  MString patternVal;

  ATTRIBUTE a[] = {
	{"0010 0010 Patient Name", 0x00100010},
	{"0010 0020 Patient ID  ", 0x00100020},
	{"0010 0030 Patient DOB ", 0x00100030},
	{"0010 0040 Patient Sex ", 0x00100040}
  };

  int idx;
  MDICOMElementEval eval;

  for (idx = 0; idx < (int)DIM_OF(a); idx++) {
    int status = eval.evalElement(level,
	*mTestWrapper, *mPatternWrapper, a[idx].tag, language);
    if (status != 0) {
      rtnValue = 1;
    }
#if 0
    testVal = mTestWrapper->getString(a[idx].tag);
    patternVal = mTestWrapper->getString(a[idx].tag);

    rtnValue |= this->evaluateString(a[idx].label, level,
			testVal, patternVal);
#endif
  }
  return rtnValue;
}

int
MCompositeEval::evalGeneralStudyModule(int level, const MString& language, int mwlEnabled,
	int ignoreStudyInstanceUID)
{
  int x = this->consistencyTest();
  if (x != 0)
    return x;

  int rtnValue = 0;
  MString testVal;
  MString patternVal;

  ATTRIBUTE a[] = {
//	{"0020 000D Study Instance UID", 0x0020000D},
	{"0008 0050 Accession Number  ", 0x00080050}
  };
  MDICOMElementEval eval;

  int idx;
  int status = 0;
  for (idx = 0; idx < (int)DIM_OF(a); idx++) {
    status = eval.evalElement(level,
	*mTestWrapper, *mPatternWrapper, a[idx].tag, language);
    if (status != 0) {
      rtnValue = 1;
    }
  }

  if (ignoreStudyInstanceUID && (level > 2)) {
    cout << "Ignoring Study Instance UID; maybe IHE Group Case?" << endl;
  }

  if (mwlEnabled && !ignoreStudyInstanceUID) {
    status = eval.evalElement(level,
	*mTestWrapper, *mPatternWrapper, 0x0020000D, language);
  }

  if (mwlEnabled) {
    rtnValue |= this->evalReferencedStudySequence(level, language);

    rtnValue |= this->evalProcedureCodeSequence(level, language);
  }

  return rtnValue;
}

int
MCompositeEval::evalPatientStudyModule(int level, const MString& language, int mwlEnabled)
{
  return 0;
}

int
MCompositeEval::evalGeneralSeriesModule(int level, const MString& language, int mwlEnabled)
{
  int x = this->consistencyTest();
  if (x != 0)
    return x;

  int rtnValue = 0;

  if (mwlEnabled) {
    ATTRIBUTE a[] = {
	// The first item is used as the "key" value when trying to
	// match up sequence items.
	{ "0040 0009 Scheduled Procedure Step ID", 0x00400009},
	{ "0040 1001 Requested Procedure ID     ", 0x00401001},
	{ "0040 0007 Scheduled Proc Step Descr  ", 0x00400007}
    };

    x = this->evalSequence(level, language, "0040 0275 Request Attributes Sequence",
				0x00400275, a, (int)DIM_OF(a));
    if (x != 0)
      rtnValue = 1;

    ATTRIBUTE codes[] = {
	// The first item is used as the "key" value when trying to
	// match up sequence items.
	{"Code Value              ", 0x00080100},
	{"Coding Scheme Designator", 0x00080102},
	{"Code Meaning            ", 0x00080104}
    };
    x = this->evalSequence(level, language, "0040 0275 Request Attributes Sequence",
				0x00400275, 0x00400009,
				"0040 0008 Scheduled Protocol Code Sequence",
				0x00400008, codes, (int)DIM_OF(codes));
    if (x != 0)
      rtnValue = 1;
  }

  if (mwlEnabled) {
    ATTRIBUTE a[] = {
	// The first item is used as the "key" value when trying to
	// match up sequence items.
	{ "0008 1150 Referenced SOP Class UID ", 0x00081150}
    };

    x = this->evalSequence(level, language,
			"0008 1111 Referenced Study Component Sequence",
			0x00081111, a, (int)DIM_OF(a));
    if (x != 0)
      rtnValue = 1;
  }

  return rtnValue;
}

int
MCompositeEval::evalGeneralEquipment(int level, int mwlEnabled)
{
  return 0;
}

int
MCompositeEval::evalGeneralImage(int level, int mwlEnabled)
{
  return 0;
}

int
MCompositeEval::evalImagePixel(int level, int mwlEnabled)
{
  return 0;
}


// Private methods below
int
MCompositeEval::consistencyTest() const
{
  int rtnValue = 0;
  if (mTestWrapper == 0) {
    cout << "MCompositeEval::consistencyTest " << endl
	 << " No test object registered." << endl;
    rtnValue = 1;
  }
  if (mPatternWrapper == 0) {
    cout << "MCompositeEval::consistencyTest " << endl
	 << " No pattern (master) object registered." << endl;
    rtnValue = 1;
  }

  return rtnValue;
}

int
MCompositeEval::evaluateString(const MString& label, int level,
			const MString& testVal, const MString& patternVal) const
{
  if (level > 2) {
    cout << label
	 << " <" << testVal << ">"
	 << " <" << patternVal << ">"
	 << endl;
  }
  if (testVal == patternVal)
    return 0;

  if (level == 1) {
    if (level <= 2) {
      cout << label
	   << " <" << testVal << ">"
	   << " <" << patternVal << ">"
	   << endl;
    }
    cout << "Warning: strings do not match: Warning Only" << endl;
    return 0;
  }
  if (level <= 2) {
    cout << label
	 << " <" << testVal << ">"
	 << " <" << patternVal << ">"
	 << endl;
  }
  cout << "Failure strings do not match " << endl;
  return 1;
}

int
MCompositeEval::evalReferencedStudySequence(int level, const MString& language)
{
  int rtnValue = 0;

  if (level > 2) {
    cout << "Comparing Referenced Study Sequence" << endl;
  }

  {
    ATTRIBUTE a[] = {
	// The first item is used as the "key" value when trying to
	// match up sequence items.
	{ "0008 1155 Referenced SOP Instance UID ", 0x00081155},
	{ "0008 1150 Referenced SOP Class UID    ", 0x00081150}
    };

    int x;
    x = this->evalSequence(level, language, "0008 1110 Referenced Study Sequence",
				0x00081110, a, (int)DIM_OF(a));
    if (x != 0)
      rtnValue = 1;
  }
  return rtnValue;
}


int
MCompositeEval::evalProcedureCodeSequence(int level, const MString& language)
{
  int rtnValue;
#if 0
  rtnValue = this->evalCodeSequence(level, "0008 1032 Procedure Code Sequence",
		0x00081032);
#endif

  ATTRIBUTE codes[] = {
    // The first entry is the "key" used to match up sequence items.
    {"Code Value              ", 0x00080100},
    {"Coding Scheme Designator", 0x00080102},
    {"Code Meaning            ", 0x00080104}
  };
  rtnValue = this->evalSequence(level, language, "0008 1032 Procedure Code Sequence",
				0x00081032, codes, (int)DIM_OF(codes));
  return rtnValue;
}

#if 0
int
MCompositeEval::evalCodeSequence(int level, const MString& label, DCM_TAG tag)
{
  if (mVerbose) {
    cout << "Code Sequence Evaluation: " << label << endl;
  }

  if (!mPatternWrapper->attributePresent(tag)) {
    if (mVerbose) {
      cout << "Warning: Attribute does not exist in the pattern object" << endl;
      return 0;
    }
  }
  if (!mTestWrapper->attributePresent(tag)) {
    if (!mVerbose) {
      cout << "Code Sequence Evaluation: " << label << endl;
    }
    cout << "Failure: Attribute exists in pattern object but not in test object" << endl;
    return 1;
  }

  ATTRIBUTE codes[] = {
	  {"Code Value              ", 0x00080100},
	  {"Coding Scheme Designator", 0x00080102},
	  {"Code Meaning            ", 0x00080104}
  };

  int rtnValue = 0;
  int idx = 1;
  MString v = mPatternWrapper->getString(tag, codes[0].tag);
  while (v != "") {
    int jx = 0;
    MString sPattern;
    MString sTest;
    for (jx = 0; jx < (int)DIM_OF(codes); jx++) {
      sPattern = mPatternWrapper->getString(tag, codes[jx].tag, idx);
      sTest =       mTestWrapper->getString(tag, codes[jx].tag, idx);
      if (mVerbose) {
	cout << codes[jx].label
	     << " <" << sTest << ">"
	     << " <" << sPattern << ">"
	     << endl;
      }
      if (sPattern != sTest) {
	if (!mVerbose) {
	  cout << codes[jx].label
	       << " <" << sTest << ">"
	       << " <" << sPattern << ">"
	       << endl;
	}
	cout << "Failure: Code item does not match" << endl;
	rtnValue = 1;
      }
    }
    idx++;
    v = mPatternWrapper->getString(tag, codes[0].tag, idx);
  }
  return rtnValue;
}
#endif

int
MCompositeEval::evalSequence(int level, const MString& language, const MString& label, DCM_TAG tag,
	ATTRIBUTE* attrArray, int length)
{
  int rtnValue;

  rtnValue = this->evalSequence(level, language, mTestWrapper, mPatternWrapper,
		label, tag, attrArray, length);
  return rtnValue;
}

int
MCompositeEval::evalSequence(int level, const MString& language, MDICOMWrapper* tst, MDICOMWrapper* pat,
	const MString& label, DCM_TAG tag,
	ATTRIBUTE* attrArray, int length)
{
  if (level > 2) {
    cout << "Sequence Evaluation: " << label << endl;
  }

  if (!pat->attributePresent(tag)) {
    if (level > 2) {
      cout << "Warning: Attribute does not exist in the pattern object" << endl;
    }
    return 0;
  }
  if (!tst->attributePresent(tag)) {
    if (level <= 2) {
      cout << "Sequence Evaluation: " << label << endl;
    }
    cout << "Failure: Attribute exists in pattern object but not in test object" << endl;
    return 1;
  }

  if (level > 2) {
    int ix;
    MString s;
    cout << " Pattern sequence items" << endl;
    ix = 1;
    while ((s = pat->getString(tag, attrArray[0].tag, ix)) != ""){
      int iy;
      for (iy = 0; iy < length; iy++) {
	s = pat->getString(tag, attrArray[iy].tag, ix);
	cout << "  " << attrArray[iy].label
	     << " " << s << endl;
      }
      ix++;
    }

    cout << " Test sequence items" << endl;
    ix = 1;
    while ((s = tst->getString(tag, attrArray[0].tag, ix)) != ""){
      int iy;
      for (iy = 0; iy < length; iy++) {
	s = tst->getString(tag, attrArray[iy].tag, ix);
	cout << "  " << attrArray[iy].label
	     << " " << s << endl;
      }
      ix++;
    }
  }

  // The first tag in the array is the "key" value that uniquely identifies
  // this item in the sequence (by our definition, not by DICOM)

  int rtnValue = 0;
  int idxPattern = 1;
  int idxTest;
  MString keyPattern;
  MString keyTest;
  DCM_TAG keyTag = attrArray[0].tag;

  while ((keyPattern = pat->getString(tag, keyTag, idxPattern)) != "") {
    idxTest = 1;
    bool matchThisItem = false;
    if (level > 2) {
      cout << " Now processing sequence item: "
	   << attrArray[0].label << " "
	   << keyPattern << endl;
    }
    while (((keyTest = tst->getString(tag, keyTag, idxTest)) != "") &&
		(matchThisItem == false) ) {
      if (keyPattern == keyTest) {
	bool allMatch = true;
	int jx;
	MString sPattern;
	MString sTest;
	for(jx = 0; (jx < length) && (allMatch == true); jx++) {
	  sPattern = pat->getString(tag,attrArray[jx].tag,idxPattern);
	  sTest = tst->getString(tag, attrArray[jx].tag, idxTest);
	  if (sPattern != sTest) {
	    allMatch = false;
	  }
	}
	if (allMatch == true)
	  matchThisItem = true;
      }
      idxTest++;
    }
    if (matchThisItem == false) {
      rtnValue = 1;
      if (level <= 2) {
	cout << "Sequence Evaluation: " << label << endl;
      }
      cout << attrArray[0].label << endl
	   << " Found no matching entry for: " << keyPattern << endl;
    }
    idxPattern++;
  }

  return rtnValue;
}

int
MCompositeEval::evalSequence(int level, const MString& language, const MString& label, DCM_TAG tag,
	DCM_TAG keyTag, const MString& sequenceLabel, DCM_TAG sequenceTag,
	ATTRIBUTE* attrArray, int length)
{
  if (level > 2) {
    cout << "Secondary Sequence Evaluation (sequences within sequences): "
	 << label << endl
	 << "  " << sequenceLabel << endl;
  }

  if (!mPatternWrapper->attributePresent(tag)) {
    if (level > 2) {
      cout << "Warning: Attribute does not exist in the pattern object" << endl;
    }
    return 0;
  }
  if (!mTestWrapper->attributePresent(tag)) {
    if (level <= 2) {
      cout << "Sequence Evaluation: " << label << endl;
    }
    cout << "Failure: Attribute exists in pattern object but not in test object" << endl;
    return 1;
  }

  // The first tag in the array is the "key" value that uniquely identifies
  // this item in the sequence (by our definition, not by DICOM)

  int rtnValue = 0;
  int idxPattern = 1;
  int idxTest;
  MString keyPattern;
  MString keyTest;

  while ((keyPattern=mPatternWrapper->getString(tag,keyTag,idxPattern)) != "") {
    idxTest = 1;
    int matchThisItem = 1;
    if (level > 2) {
      cout << " Now processing sequence item: "
	   << keyPattern << endl;
    }
    while (((keyTest=mTestWrapper->getString(tag,keyTag,idxTest)) != "") &&
		(matchThisItem == 1) ) {
      if (keyPattern == keyTest) {
	MDICOMWrapper* tst = mTestWrapper->getSequenceWrapper(tag, idxTest);
	MDICOMWrapper* pat = mPatternWrapper->getSequenceWrapper(tag, idxPattern);

	rtnValue |= this->evalSequence(level, language, tst, pat,
			sequenceLabel, sequenceTag,
			attrArray, length);

	delete tst;
	delete pat;
      }
      idxTest++;
    }
    if (matchThisItem == 0) {
      rtnValue = 1;
      cout << "Found no matching entry for: " << keyPattern << endl;
    }
    idxPattern++;
  }

  return rtnValue;
}
