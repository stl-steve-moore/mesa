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
#include "MSREval.hpp"
#include "MSRWrapper.hpp"
#include "MSRContentItemFactory.hpp"
#include "MSREvalTID2000.hpp"

#include <iomanip>

static char rcsid[] = "$Id: MSREval.cpp,v 1.13 2006/03/24 20:41:16 smm Exp $";

MSREval::MSREval() :
  mTestWrapper(0),
  mPatternWrapper(0),
  mVerbose(false)
{
}

MSREval::MSREval(const MSREval& cpy) :
  mTestWrapper(cpy.mTestWrapper),
  mPatternWrapper(cpy.mPatternWrapper),
  mVerbose(cpy.mVerbose)
{
}

MSREval::~MSREval()
{
}

void
MSREval::printOn(ostream& s) const
{
  s << "MSREval";
}

void
MSREval::streamIn(istream& s)
{
  //s >> this->member;
}

// Non boiler-plate methods below

void
MSREval::verbose(bool flag)
{
  mVerbose = flag;
}

void
MSREval::setTestObject(MSRWrapper *w)
{
  mTestWrapper = w;
}


void
MSREval::setPatternObject(MSRWrapper *w)
{
  mPatternWrapper = w;
}

void
MSREval::readContentItemRequirements(const MString& fileName)
{
  if (fileName == "")
    return;

  char fTemp[1024];
  fileName.safeExport(fTemp, sizeof(fTemp));

  ifstream f(fTemp);
  if (!f) {
    cerr << "Could not open Content Item Requirements: " << fTemp << endl;
    exit (1);
  }
  char buf[1024];

  while (f.getline(buf, sizeof(buf))) {
    if (buf[0] == '\0' || buf[0] == '#' || buf[0] == '\n' || buf[0] == '\r')
      continue;

    CONTENT_ITEM_REQUIREMENT r;
    int count = sscanf(buf, "%d %c %[^\n]", &r.idx, &r.requirement, &r.comment);
    if (count == 2) {
      r.comment[0] = '\0';
    } else if (count != 3) {
      cerr << "Unable to parse Content Item Requirement: " << buf << endl;
      exit(1);
    }
    if (r.requirement == 'r')
      r.requirement = 'R';
    if (r.requirement == 'o')
      r.requirement = 'O';
    mRequirementVector.push_back(r);
  }
  if (mVerbose) {
    cout << "MSREval::readContentItemRequirements" << endl;
    MSREvalRequirementVector::iterator it = mRequirementVector.begin();
    for (; it != mRequirementVector.end(); it++) {
      cout << setw(3) << (*it).idx
	   << " " << (*it).requirement
	   << " " << (*it).comment
	   << endl;
    }
  }
}

int
MSREval::evalTemplateIdentification(const MString& templateString) const
{
  if (!mTestWrapper) {
    cout << "MSREval::evalTemplateIdentification test wrapper is not set." << endl;
    return -1;
  }

  MString sCopy(templateString);
  MString s;	// The expected value
  MString v;	// The test value

  // First test is Template Identifier: 0040 DB00
  s = sCopy.getToken(':', 0);

  v = mTestWrapper->getString(0x0040a504, 0x0040db00);
  if (mVerbose) {
    cout << "CTX: MSREval::evalTemplateIdentification: Template ID "
	 << "<" << v << ">"
	 << "<" << s << ">" << endl;
  }
  if (v == "") {
    cout << "Missing or 0-length template ID (fatal)." << endl;
    return -1;
  }

  if (s != v) {
    cout << "ERR: Template ID in test obj does not match expected value (fatal) " 
	 << "<" << v << ">"
	 << "<" << s << ">" << endl;
    return -1;
  }

  // Second test is Mapping Resource : 0008 01015
  s = sCopy.getToken(':', 1);

  v = mTestWrapper->getString(0x0040a504, 0x00080105);
  if (mVerbose) {
    cout << "CTX: MSREval::evalTemplateIdentification: Mapping Resource "
	 << "<" << v << ">"
	 << "<" << s << ">" << endl;
  }
  if (v == "") {
    cout << "ERR: Missing or 0-length Mapping Resource (fatal)." << endl;
    return -1;
  }

  if (s != v) {
    cout << "ERR: Mapping Resource in test obj does not match expected value (fatal) " 
	 << "<" << v << ">"
	 << "<" << s << ">" << endl;
    return 1;
  }

  return 0;
}

int
MSREval::evalTemplate(const MString& templateString) const
{
  if (!mTestWrapper) {
    cout << "MSREval::evalTemplateIdentification test wrapper is not set." << endl;
    return -1;
  }

  MString sCopy(templateString);
  MString s;	// The template identifier
  s = sCopy.getToken(':', 0);

  int rtnValue = 0;
  if (s == "2000") {
    MSREvalTID2000 e;
    e.verbose(mVerbose);
    e.setTestObject(mTestWrapper);
    rtnValue = e.evaluate();
  } else if (s == "2010") {
    rtnValue = 0;
  } else {
    cout << "ERR: MSREval::evalTemplate unknown Template ID " << s << endl;
    rtnValue = -1;
  }

  return rtnValue;
}

int
MSREval::evalPredecessorDocumentSequence() const
{
  if (mVerbose) {
    cout << "Evaluating 0040 A360 Predecessor Documents Sequence" << endl;
  }

  if (!mTestWrapper) {
    cout << "MSREval::evalPredecessorDocumentSequence test wrapper is not set."
	 << endl;
    return -1;
  }
  if (!mPatternWrapper) {
    cout << "MSREval::evalPredecessorDocumentSequence pattern wrapper is not set."
	 << endl;
    return -1;
  }
  if (! mTestWrapper->attributePresent(0x0040a360)) {
    cout << "Failure: 0040 A360 Predecessor Documents Sequence missing from test data"
	 << endl;
    return 1;
  }

  MString sPattern;
  MString sTest;
  int rtnValue = 0;


  MDICOMWrapper* p = mPatternWrapper->getSequenceWrapper(0x0040A360, 1);
  MDICOMWrapper* t = mTestWrapper->getSequenceWrapper(0x0040A360, 1);

  sPattern = p->getString(0x0020000D);
  sTest = t->getString(0x0020000D);
  rtnValue |= textCompare(sPattern, sTest, "(0040 A360) (0020 000D) Study Instance UID");

  sPattern = p->getString(0x00081115, 0x0020000E);
  sTest    = t->getString(0x00081115, 0x0020000E);
  rtnValue |= textCompare(sPattern, sTest,
			  "(0040 A360) (0008 1115) (0020 000E) Series Inst UID");


  MDICOMWrapper* pSeries = p->getSequenceWrapper(0x00081115, 1);
  MDICOMWrapper* tSeries = t->getSequenceWrapper(0x00081115, 1);

  sPattern = pSeries->getString(0x00081199, 0x00081150);
  sTest    = pSeries->getString(0x00081199, 0x00081150);
  rtnValue |= textCompare(sPattern, sTest,
			  "(0040 A360) (0008 1115) (0008 1199) (0008 1150) Ref Sop Class");

  sPattern = pSeries->getString(0x00081199, 0x00081155);
  sTest    = pSeries->getString(0x00081199, 0x00081155);
  rtnValue |= textCompare(sPattern, sTest,
			  "(0040 A360) (0008 1115) (0008 1199) (0008 1155) Ref Sop Inst");


  delete p;
  delete t;
  delete pSeries;
  delete tSeries;

  return rtnValue;
}

int
MSREval::evalSRDocumentContentModule() const
{
  if (!mTestWrapper) {
    cout << "MSREval::evalSRDocumentContentModule test wrapper is not set." << endl;
    return -1;
  }

  MString s;
  int rtnValue = 0;

  if (mVerbose) {
    cout << "About to evaluate SR Document Content Module" << endl;
  }

  s = mTestWrapper->getString(0x0040A040);	// Value Type
  if (mVerbose) {
    cout << "0040 A040 Value Type: <" << s << ">" << endl;
  }
  if (s != "CONTAINER") {
    cout << "Top level 0040 A040 Value Type should be CONTAINER" << endl;
    cout << "Failure: document top level 0040 A040 is <" << s << ">" << endl;
    rtnValue = 1;
  }

  s = mTestWrapper->getString(0x0040A050);	// Continuity of Content
  if (mVerbose) {
    cout << "0040 A050 Continuity of Content: <" << s << ">" << endl;
  }
  if (s != "SEPARATE" && s != "CONTINUOUS") {
    cout << "Top level 0040 A050 Continuity of Content should be SEPARATE or CONTINUOUS" << endl;
    cout << "Failure: document top level 0040 A050 is <" << s << ">" << endl;
    rtnValue = 1;
  }

  MSRContentItemVector& vTest = mTestWrapper->contentItemVector();
  MSRContentItemVector::iterator iTest = vTest.begin();

  int status = 0;
  int level = 1;
  for (; iTest != vTest.end(); iTest++) {
    status = this->testContinuityOfContent(&(*iTest), level);
    if (status != 0)
      rtnValue = 1;
  }

  return rtnValue;
}

int
MSREval::compareContentItems( )
{
  if (!mTestWrapper) {
    cout << "MSREval::compareContentItems test wrapper is not set." << endl;
    return -1;
  }
  if (!mPatternWrapper) {
    cout << "MSREval::compareContentItems pattern wrapper is not set." << endl;
    return -1;
  }

  MSRContentItemVector& vPattern = mPatternWrapper->contentItemVector();
  MSRContentItemVector& vTest = mTestWrapper->contentItemVector();
  MSRContentItemFactory f;

  MSRContentItemVector::iterator iPattern = vPattern.begin();
  MSRContentItemVector::iterator iTest = vTest.begin();

  int rtnValue = 0;

  for (; iPattern != vPattern.end(); iPattern++) {
    MString pRelationshipType = (*iPattern).relationshipType();
    MString pValueType = (*iPattern).valueType();
    if (mVerbose) {
      cout << " " << pRelationshipType << " " << pValueType << endl;
    }
    MSRContentItem* itemPattern = f.produceContentItem(*iPattern);
    if (iTest == vTest.end()) {
      cout << "In MSREval::compareContentItems, pattern has a content item "
	   << endl
	   << " but test SR object does not (failure)." << endl;
      cout << " Content Item in pattern->" << pRelationshipType
	   << " " << pValueType << endl;
      rtnValue = 1;
      continue;
    }
    MSRContentItem* itemTest = f.produceContentItem(*iTest);
    if (itemPattern != 0) {
      if (itemTest == 0) {
	cout << "Pattern has a content item but test object does not." << endl;
	cout << " " << *itemPattern << endl;
	rtnValue = 1;
	continue;
      }
      if (! ((*itemTest).isLevel1Equivalent(itemPattern))) {
	cout << "Content Items do not match" << endl;
	cout << " " << *itemTest << endl;
	cout << " " << *itemPattern << endl;
	rtnValue = 1;
      }
    }
    if (iTest != vTest.end())
      iTest++;
  }
  return rtnValue;
}

int
MSREval::compareRequiredContentItems( )
{
  if (!mTestWrapper) {
    cout << "MSREval::compareRequiredContentItems test wrapper is not set."
	 << endl;
    return -1;
  }
  if (!mPatternWrapper) {
    cout << "MSREval::compareRequiredContentItems pattern wrapper is not set."
	 << endl;
    return -1;
  }

  MSRContentItemVector& vPattern = mPatternWrapper->contentItemVector();
  MSRContentItemVector& vTest = mTestWrapper->contentItemVector();
  MSRContentItemFactory f;

  MSRContentItemVector::iterator iPattern = vPattern.begin();
  MSRContentItemVector::iterator iTest = vTest.begin();

  int contentItemIdx = 1;
  int count = mRequirementVector.size();
  int rtnValue = 0;	// 0 indicates success

  if (mVerbose) {
    cout << "MSREval::compareRequiredContentItems, about to walk through "
	 << count << " content items" << endl;
  }

  MSREvalRequirementVector::iterator reqIt = mRequirementVector.begin();

  MSRContentItem* itemPattern = 0;
  for (contentItemIdx = 1; contentItemIdx <= count;
	contentItemIdx++, reqIt++, iPattern++) {
    if ((*reqIt).idx != contentItemIdx) {
      cout << "MSREval::compareRequiredContentItems" << endl
	   << " fatal mismatch between our internal index ("
	   << contentItemIdx
	   << ") and the index found in the requirements file: "
	   << (*reqIt).idx << endl;
      return -1;
    }
    char r = (*reqIt).requirement;
    if (r != 'R' && r != 'F') {
      continue;
    }

    if (mVerbose) {
      cout << "=====" << endl;
      cout << setw(4) << (*reqIt).idx
	   << " " << (*reqIt).comment << endl;
    }
    MString pRelationshipType = (*iPattern).relationshipType();
    MString pValueType = (*iPattern).valueType();
    if (mVerbose) {
      cout << "Pattern content item "
	   << pRelationshipType << " : " << pValueType << endl;
    }
    itemPattern = f.produceContentItem(*iPattern);

    bool match = false;		// Indicates if we found a matching item
    while (iTest != vTest.end() && !match) {
      if (itemPattern == 0) {
	match = true;
	iTest++;
	continue;
      }

      MString tRelationshipType = (*iTest).relationshipType();
      MString tValueType = (*iTest).valueType();
      if (mVerbose) {
//	cout << "     Test Content Item "
	cout << "Test Content Item    "
	     << tRelationshipType << " : " << tValueType << endl;
      }
      MSRContentItem* itemTest = f.produceContentItem(*iTest);
      if (itemTest == 0) {
	if (mVerbose) {
//	  cout << "    Pattern has a content item but test object does not."
	  cout << "Pattern has a content item but test object does not."
		<< endl;
//	  cout << "    " << *itemPattern << endl;
	  cout << *itemPattern << endl;
	}
	iTest++;
	continue;
      }
      bool localResult = false;
      if (r == 'R')
	localResult = (*itemTest).isLevel1Equivalent(itemPattern, mVerbose);
      else if (r == 'F')
	localResult = (*itemTest).isLevel2Equivalent(itemPattern, mVerbose);
      else
	localResult = false;

      if (localResult) {
	if (mVerbose) {
	  cout << "Found matching content item in test data" << endl;
	  cout << "Test    " << *itemTest << endl;
	  cout << "Pattern " << *itemPattern << endl << endl;
	}
	match = true;
	if (pValueType == "CONTAINER") {
	  if (mVerbose) {
	    cout << "Now testing content items in container" << endl;
	    int localRslt = this->compareContentItems(&(*iPattern), &(*iTest) );

	    if (localRslt != 0)
	      match = false;
	  }
	}


	iTest++;
	delete itemTest;
	continue;
      } else {
	if (mVerbose) {
//	  cout << "     Content Items do not match" << endl;
//	  cout << "    " << *itemTest << endl;
//	  cout << "    " << *itemPattern << endl;
	  cout << "Content Items do not match" << endl;
	  cout << "Test    " << *itemTest << endl;
	  cout << "Pattern " << *itemPattern << endl << endl;
	}
	iTest++;
	delete itemTest;
	continue;
      }
    }
    if (!match) {
      rtnValue = 1;
      if (mVerbose) {
//	cout << "    Found no matching content item for this required item"
	cout << "Found no matching content item for this required item"
	     << endl;
      }
    }
    delete itemPattern;
  }

  return rtnValue;
}

int
MSREval::compareContentItems(MSRContentItem* patternItem,
			  MSRContentItem* testItem)
{
  MSRContentItemVector& vPattern = patternItem->contentItemVector();
  MSRContentItemVector& vTest = testItem->contentItemVector();

  MSRContentItemFactory f;

  MSRContentItemVector::iterator iPattern = vPattern.begin();
  MSRContentItemVector::iterator iTest = vTest.begin();

  int rtnValue = 0;

  for (; iPattern != vPattern.end(); iPattern++) {
    MString pRelationshipType = (*iPattern).relationshipType();
    MString pValueType = (*iPattern).valueType();
    if (mVerbose) {
      cout << " " << pRelationshipType << " " << pValueType << endl;
    }
    MSRContentItem* itemPattern = f.produceContentItem(*iPattern);
    if (iTest == vTest.end()) {
      cout << "In MSREval::compareContentItems, pattern has a content item "
	   << endl
	   << " but test SR object does not (failure)." << endl;
      cout << " Content Item in pattern->" << pRelationshipType
	   << " " << pValueType << endl;
      rtnValue = 1;
      continue;
    }
    MSRContentItem* itemTest = f.produceContentItem(*iTest);
    if (itemPattern != 0) {
      if (itemTest == 0) {
	cout << "Pattern has a content item but test object does not." << endl;
	cout << " " << *itemPattern << endl;
	rtnValue = 1;
	delete itemPattern;
	continue;
      }
      if (! ((*itemTest).isLevel1Equivalent(itemPattern, mVerbose))) {
	cout << "Content Items do not match" << endl;
	cout << " " << *itemTest << endl;
	cout << " " << *itemPattern << endl;
	delete itemPattern;
	delete itemTest;
	rtnValue = 1;
      }
    }
    if (iTest != vTest.end())
      iTest++;
  }
  return rtnValue;
}


// Private methods start here

int
MSREval::textCompare(const MString& textPattern,
		     const MString& textTest,
		     const MString& label) const
{
  if (mVerbose) {
    cout << label << endl
	 << "<" << textTest << "> "
	 << "<" << textPattern << ">" << endl;
  }

  if (textPattern != textTest) {
    if (!mVerbose) {
      cout << label << endl
	   << "<" << textTest << "> "
	   << "<" << textPattern << ">" << endl;

    }
    cout << "Failure: text attributes do not match" << endl;
    return 1;
  }
  return 0;
}

int
MSREval::testContinuityOfContent(MSRContentItem *testItem, int level) const
{
  MString s = testItem->valueType();

  if (mVerbose) {
    cout << "Testing for Continuity of Content at level: "
	 << level
	 << " for value type: "
	 << "<" << s << ">" << endl;
  }
  if (s != "CONTAINER") {
    return 0;
  }

  int rtnValue = 0;

  DCM_OBJECT *obj = (DCM_OBJECT*)testItem->objectReference();
  MDICOMWrapper w(obj);

  s = w.getString(0x0040A050);	// Continuity of Content
  if (mVerbose) {
    cout << "0040 A050 Continuity of Content: <" << s << ">" << endl;
  }
  if (s != "SEPARATE" && s != "CONTINUOUS") {
    cout << "Failure in content item at level: " << level << endl;
    cout << "0040 A050 Continuity of Content should be SEPARATE or CONTINUOUS" << endl;
    cout << "Document value is <" << s << ">" << endl;
    rtnValue = 1;
  }

  MSRContentItemVector& v = testItem->contentItemVector();
  MSRContentItemVector::iterator it = v.begin();

  int status = 0;
  for (; it != v.end(); it++) {
    status = this->testContinuityOfContent(&(*it), level+1);
    if (status != 0)
      rtnValue = 1;
  }

  return rtnValue;
}
