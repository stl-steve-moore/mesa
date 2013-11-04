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
#include "MSREvalTID2000.hpp"
#include "MSRWrapper.hpp"
#include "MFileOperations.hpp"
#include "MSRContentItemFactory.hpp"
#include "MSRContentItemCode.hpp"
#include "MSRContentItemPName.hpp"
#include "MSRContentItemText.hpp"

#include <iomanip>

static char rcsid[] = "$Id: MSREvalTID2000.cpp,v 1.5 2006/03/24 20:40:47 smm Exp $";

MSREvalTID2000::MSREvalTID2000() :
  mTestWrapper(0),
  mVerbose(false)
{
}

MSREvalTID2000::MSREvalTID2000(const MSREvalTID2000& cpy) :
  mTestWrapper(cpy.mTestWrapper),
  mVerbose(cpy.mVerbose)
{
}

MSREvalTID2000::~MSREvalTID2000()
{
}

void
MSREvalTID2000::printOn(ostream& s) const
{
  s << "MSREvalTID2000";
}

void
MSREvalTID2000::streamIn(istream& s)
{
  //s >> this->member;
}

// Non boiler-plate methods below

void
MSREvalTID2000::verbose(bool flag)
{
  mVerbose = flag;
}

void
MSREvalTID2000::setTestObject(MSRWrapper *w)
{
  mTestWrapper = w;
}


int
MSREvalTID2000::evaluate()
{
  if (!mTestWrapper) {
    cout << "MSREvalTID2000::evaluate test wrapper is not set." << endl;
    return -1;
  }

  int rtnValue = 0;

  if (mVerbose) {
    cout << "CTX: About to evaluate Report Title: Context ID 7000, baseline" << endl;
  }
  rtnValue |= this->evaluateBaselineCode(mTestWrapper, 0x0040A043,
			"runtime/codes/sr/ctx_id_7000.txt");

  MSRContentItemVector v = mTestWrapper->contentItemVector();

  MSRContentItemVector::iterator contentIterator = v.begin();

  if (contentIterator == v.end()) {
    cout << "Failure: Empty set of content items" << endl;
    return -1;
  }

  MString rType;
  MString vType;
  rType = contentIterator->relationshipType();
  vType = contentIterator->valueType();
  MSRContentItemFactory factory;

  cout << rType << ":" << vType << endl;

  // Scan over HAS CONCEPT MOD:CODE:121058 Procedure Reported
  while (1) {
    if (rType != "HAS CONCEPT MOD" || vType != "CODE")
      break;


    MSRContentItemCode* c = (MSRContentItemCode*) factory.produceContentItem(*contentIterator);

    MString codeValue = c->conceptNameValue();
    cout << codeValue << endl;

    delete c;

    if (codeValue != "121058")
      break;

    contentIterator++;
    if (contentIterator == v.end()) {
      cout << "Reached end of content items while scanning for Procedure Reported" << endl;
      return -1;
    }
    rType = contentIterator->relationshipType();
    vType = contentIterator->valueType();
  }

  rtnValue = this->evalLanguageOfContentItem(contentIterator, v);

  rtnValue |= this->evalObservationContext1001(contentIterator, v);

  int foundAtLeastOneSectionHeading = 0;
  while (contentIterator != v.end()) {
    if (evalSection7001(contentIterator, v) == 0) {
      foundAtLeastOneSectionHeading = 1;
    }
    contentIterator++;
  }
  if (!foundAtLeastOneSectionHeading) {
    cout << "Found no Section Headings that satisfy TID 7001" << endl;
    cout << " That is a failure" << endl;
    rtnValue |= 1;
  }
  return rtnValue;
}

// Private methods start here

int
MSREvalTID2000::textCompare(const MString& textPattern,
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
MSREvalTID2000::evaluateBaselineCode(MDICOMWrapper* w, DCM_TAG tag,
		const MString& codeTable)
{
  MFileOperations f;
  char path[1024];

  f.expandPath(path, "MESA_TARGET", codeTable);

  cout << "CTX: Patient to baseline code table: " << path << endl;

  MCodeItemVector v;

  int rtnValue = 0;

  rtnValue = this->readCodeTable(v, path);
  if (rtnValue != 0)
    return rtnValue;

  MString codeValue = w->getString(tag, 0x00080100);
  MString codeDesig = w->getString(tag, 0x00080102);
  MString codeMeaning = w->getString(tag, 0x00080104);

  if (mVerbose) {
    cout << "CTX: MSREvalTID2000::evaluateBaselineCode code = <"
	<< codeDesig << ":"
	<< codeValue << ":"
	<< codeMeaning << ">" << endl;
  }

  MCodeItemVector::iterator it = v.begin();
  for (; it != v.end(); it++) {
    MString tValue = (*it).codeValue();
    MString tDesig = (*it).codeSchemeDesignator();
    MString tMeaning = (*it).codeMeaning();
    if (mVerbose) {
      cout << "CTX:  Code from table = <"
	<< tDesig << ":"
	<< tValue << ":"
	<< tMeaning << ">" << endl;
    }

    if ((codeValue == tValue) &&
	(codeMeaning == tMeaning) &&
	(codeDesig == tDesig)) {
      rtnValue = 0;
      if (mVerbose) {
	cout << "CTX:  Found matching code item" << endl;
      }
      break;
    }
  }
  if (rtnValue == 1) {
    cout << "CTX: Found no matching code item; we still pass this code" << endl
	<< " because this is a baseline comparison." << endl;
  }

  return 0;
}

int
MSREvalTID2000::evaluateEnumeratedCode(MDICOMWrapper* w, DCM_TAG tag,
		const MString& codeTable)
{
  MFileOperations f;
  char path[1024];

  f.expandPath(path, "MESA_TARGET", codeTable);

  cout << "CTX: Path to enumerated code table: " << path << endl;

  MCodeItemVector v;

  int rtnValue = 0;

  rtnValue = this->readCodeTable(v, path);
  if (rtnValue != 0)
    return rtnValue;

  MString codeValue = w->getString(tag, 0x00080100);
  MString codeDesig = w->getString(tag, 0x00080102);
  MString codeMeaning = w->getString(tag, 0x00080104);

  if (mVerbose) {
    cout << "CTX: MSREvalTID2000::evaluateBaselineCode code = <"
	<< codeDesig << ":"
	<< codeValue << ":"
	<< codeMeaning << ">" << endl;
  }

  rtnValue = 1;		// Assume failure

  MCodeItemVector::iterator it = v.begin();
  for (; it != v.end(); it++) {
    MString tValue = (*it).codeValue();
    MString tDesig = (*it).codeSchemeDesignator();
    MString tMeaning = (*it).codeMeaning();
    if (mVerbose) {
      cout << "CTX: Code from table = <"
	<< tDesig << ":"
	<< tValue << ":"
	<< tMeaning << ">" << endl;
    }

    if ((codeValue == tValue) &&
	(codeMeaning == tMeaning) &&
	(codeDesig == tDesig)) {
      rtnValue = 0;
      if (mVerbose) {
	cout << "CTX: Found matching code item" << endl;
      }
      break;
    }
  }
  if (rtnValue == 1) {
    cout << "ERR: Found no matching code item." << endl;
  }

  return rtnValue;
}

int
MSREvalTID2000::readCodeTable(MCodeItemVector& v, const char* path)
{
  ifstream f(path);

  if (!f) {
    cout << "ERR: Unable to open the code table: " << path << endl;
    return -1;
  }

  char buf[1024];

  while(f.getline(buf, sizeof(buf))) {
    if ((buf[0] == '#') || (buf[0] == '\n'))
      continue;

    char codeValue[128];
    char codeDesig[128];
    char codeMeaning[512];

    if (sscanf(buf, "%s %s %[^\n]", codeValue, codeDesig, codeMeaning) != 3) {
      cout << "Unable to parse code value: " << buf << endl;
      return -1;
    }

    MCodeItem c(codeValue, codeMeaning, codeDesig);
    v.push_back(c);
  }
  return 0;
}

int
MSREvalTID2000::evalLanguageOfContentItem(MSRContentItemVector::iterator& it,
	MSRContentItemVector& v)
{
  MString rType = it->relationshipType();
  MString vType = it->valueType();

  if (mVerbose) {
    cout << "CTX: MSREvalTID2000::evalLanguageOfContentItem looking for "
	<< "ETID 1204 Language of Content Item and Descendents" << endl
	<< "CTX:  <" << rType
	<< ":" << vType << ">" << endl;
  }

  if (rType != "HAS CONCEPT MOD") {
    cout << "ERR: MSREvalTID2000::evalLanguageOfContentItem looking for "
	<< "ETID 1204 Language of Content Item and Descendents" << endl;
    cout << "ERR: Relationship type should be HAS CONCEPT MOD, test value = "
	<< rType << endl;
    return 1;
  }

  if (vType != "CODE") {
    cout << "ERR: MSREvalTID2000::evalLanguageOfContentItem looking for "
	<< "ETID 1204 Langauge of Content Item and Descendents" << endl;
    cout << "ERR: Value type should be CODE, test value = "
	<< vType << endl;
    return 1;
  }

  MSRContentItemFactory factory;

  MSRContentItemCode *c = (MSRContentItemCode*)factory.produceContentItem(*it);

  MString cValue = c->conceptNameValue();
  MString cDesig = c->conceptNameDesignator();
  MString cMeaning = c->conceptNameMeaning();

  if (mVerbose) {
    cout << "CTX: <" << cDesig
	 << ":" << cValue
	 << ":" << cMeaning
	 << ">" << endl;
  }

  int rtnValue = 0;

  if (cValue != "121049") {
    cout << "ERR: Expected Code Value: <121049>, test value is <"
	 << cValue
	 << ">" << endl;
    rtnValue = 1;
  }
  if (cDesig != "DCM") {
    cout << "ERR: Expected Coding Scheme Designator: <DCM>, test value is <"
	 << cDesig
	 << ">" << endl;
    rtnValue = 1;
  }
  if (cMeaning != "Language of Content Item and Descendants") {
    cout << "ERR: Expected Code Meaning: <Language of Content Item and Descendents>, test value is <"
	 << cMeaning
	 << ">" << endl;
    rtnValue = 1;
  }

  if (rtnValue != 0)
    return rtnValue;

  DCM_OBJECT* obj = (DCM_OBJECT*)c->objectReference();
  MDICOMWrapper w(obj);

  if (mVerbose) {
    cout << "CTX: About to evaluate enumerated code values in 0040 A168"<< endl;
  }
  rtnValue = this->evaluateEnumeratedCode(&w, 0x0040A168,
			"runtime/codes/sr/ctx_id_5000.txt");

  delete c;

  // Increment the iterator and see if Country of Language is present
  it++;

  {
    rType = it->relationshipType();
    vType = it->valueType();

    if (mVerbose) {
      cout << "CTX: MSREvalTID2000::evalLanguageOfContentItem looking for "
	  << "ETID 1204 Language of Content Item and Descendents" << endl
	  << "CTX:  (121046 Country of Language)" << endl
	  << "CTX:  <" << rType
	  << ":" << vType << ">" << endl;
    }

    // The Country of Language is not required.  If we do not find it,
    // we merely return the status values from the previous tests.

    if (rType != "HAS CONCEPT MOD") {
      if (mVerbose) {
	cout << "WARN: Optional Country of Language does not seem to be here" << endl;
      }
      return rtnValue;
    }

    if (vType != "CODE") {
      if (mVerbose) {
	cout << "WARN: Optional Country of Language does not seem to be here" << endl;
      }
      return rtnValue;
    }

    c = (MSRContentItemCode*)factory.produceContentItem(*it);

    MString cValue = c->conceptNameValue();
    MString cDesig = c->conceptNameDesignator();
    MString cMeaning = c->conceptNameMeaning();

    if (mVerbose) {
      cout << "CTX: <" << cDesig
	   << ":" << cValue
	   << ":" << cMeaning
	   << ">" << endl;
    }

    if (cValue != "121046") {
      if (mVerbose) {
	cout << "WARN: Optional Country of Language does not seem to be here" << endl;
      }
      return rtnValue;
    }

    // The code value is correct, now we latch on and assume that
    // everyting else is correct (and fail the object if things are wrong).
    if (cDesig != "DCM") {
      cout << "ERR: Expected Coding Scheme Designator: <DCM>, test value is <"
	   << cDesig
	   << ">" << endl;
      rtnValue = 1;
    }
    if (cMeaning != "Country of Language") {
      cout << "ERR: Expected Code Meaning: <Country of Language>, test value is <"
	   << cMeaning
	   << ">" << endl;
      rtnValue = 1;
    }

    if (rtnValue != 0)
      return rtnValue;

    DCM_OBJECT* obj = (DCM_OBJECT*)c->objectReference();
    MDICOMWrapper w(obj);

    rtnValue = this->evaluateEnumeratedCode(&w, 0x0040A168,
			"runtime/codes/sr/ctx_id_5001.txt");

    delete c;
    it++;
  }

  if (mVerbose && (rtnValue == 0)) {
    cout << "CTX: MSREvalTID2000::evalLanguageOfContentItem successful test"
	 << endl << endl;
  }
  return rtnValue;
}

int
MSREvalTID2000::evalObservationContext1001(MSRContentItemVector::iterator& it,
	MSRContentItemVector& v)
{
  int rtnValue = 0;

  if (mVerbose) {
    cout << "CTX: MSREvalTID2000::evalObservationContext1001" << endl;
  }

  rtnValue = this->evalObserverCtx1002(it, v);

  return rtnValue;
}

int
MSREvalTID2000::evalObserverCtx1002(MSRContentItemVector::iterator& it,
	MSRContentItemVector& v)
{
  MString rType = it->relationshipType();
  MString vType = it->valueType();
  MSRContentItemFactory factory;
  int rtnValue = 0;

  MString observerType = "Person";
  int dummyFlag = 0;

  // Perform one iteration of this loop; allow breaks to get out.
  for (; dummyFlag == 0; dummyFlag++) {
    if (mVerbose) {
      cout << "CTX: MSREvalTID2000::evalObserverCtx1002 looking for "
	  << "ETID 1002 Observer Context" << endl
	  << " <" << rType
	  << ":" << vType << ">" << endl;
    }

    if (rType != "HAS OBS CONTEXT") {
      if (mVerbose) {
	cout << "CTX: (MC) Observer context 1002 does not appear to be here" << endl;
      }
      return 0;
    }

    if (vType != "CODE") {
      if (mVerbose) {
	cout << "CTX: (MC) Observer context does not appear to be here" << endl;
      }
      return 0;
    }
    MSRContentItemCode *c =(MSRContentItemCode*)factory.produceContentItem(*it);

    MString cValue = c->conceptNameValue();
    MString cDesig = c->conceptNameDesignator();
    MString cMeaning = c->conceptNameMeaning();

    if (mVerbose) {
      cout << "CTX:  <" << cDesig
	   << ":" << cValue
	   << ":" << cMeaning
	   << ">" << endl;
    }

    if (cValue != "121005") {
      if (mVerbose) {
	cout << "CTX: (MC) Observer context does not appear to be here" << endl;
      }
      delete c;
      break;
    }

    // They have the proper code value; from here on we expect them
    // to be correct
    if (cDesig != "DCM") {
      cout << "ERR: Expected Coding Scheme Designator: <DCM>, test value is <"
	   << cDesig
	   << ">" << endl;
      rtnValue = 1;
    }
    if (cMeaning != "Observer Type") {
      cout << "ERR: Expected Code Meaning: <Observer Type>, test value is <"
	   << cMeaning
	   << ">" << endl;
      rtnValue = 1;
    }

    observerType = c->codeNameMeaning();
    MString observerTypeCode = c->codeNameValue();
    MString observerTypeDesig = c->codeNameDesignator();

    if ((observerType == "Person") && (observerTypeCode == "121006")) {
      ;
    } else if ((observerType == "Device") && (observerTypeCode == "121007")) {
      ; 
    } else {
      cout << "ERR: Expected code for observer type to be either Person or Device" << endl
	<< " Test data has "
	<< "<" << observerTypeDesig
	<< ":" << observerTypeCode
	<< ":" << observerType
	<< ">" << endl;
	rtnValue = 1;
    }

    delete c;
    it++;
    if (rtnValue != 0)
      return rtnValue;
  }

  if (it == v.end()) {
    cout << "ERR: Have reached the end of content items and are unable to find the observer";
    cout << " This is a failure" << endl;
    return 1;
  }

  rType = it->relationshipType();
  vType = it->valueType();

  // Now we look at the actual observer
  if (observerType == "Person") {
    rtnValue = this->evalPersonObserverID1003(it, v);
  }

  return rtnValue;
}

int
MSREvalTID2000::evalPersonObserverID1003(MSRContentItemVector::iterator& it,
	MSRContentItemVector& v)
{
  MString rType = it->relationshipType();
  MString vType = it->valueType();
  MSRContentItemFactory factory;
  int rtnValue = 0;

  int dummyFlag = 0;
  for (; dummyFlag == 0; dummyFlag++) {
   if (mVerbose) {
      cout << "CTX: MSREvalTID2000::evalPersonObserverID1003 looking for "
	  << "PNAME EV 121008 Person Observer Name" << endl
	  << "CTX:  <" << rType
	  << ":" << vType << ">" << endl;
    }

    if (rType != "HAS OBS CONTEXT") {
      cout << "ERR: Person observer 1003 does not appear to be here" << endl;
      return 1;
    }

    if (vType != "PNAME") {
      cout << "ERR: Person observer identifying attributes: should be PNAME" << endl
	     << " Type in data is: " << vType;
      return 1;
    }

    MSRContentItemPName *p =(MSRContentItemPName*)factory.produceContentItem(*it);

    MString cValue = p->conceptNameValue();
    MString cDesig = p->conceptNameDesignator();
    MString cMeaning = p->conceptNameMeaning();
    delete p;

    if (mVerbose) {
      cout << "CTX: <" << cDesig
	   << ":" << cValue
	   << ":" << cMeaning
	   << ">" << endl;
    }

    if (cValue != "121008") {
      cout << "ERR: Code value for PNAME should be 121008" << endl
	   << " Test data contains <"
	   << cValue << ">" << endl;
      return 1;
    }
    it++;
  }
  for (dummyFlag = 0; dummyFlag == 0; dummyFlag++) {
    if (mVerbose) {
      cout << "CTX: MSREvalTID2000::evalPersonObserverID1003 looking for "
	  << "PNAME EV 121009 Person Observers Organization Name" << endl;
    }
    if (it == v.end()) {
      if (mVerbose) {
	cout << "CTX:  No further content items, must not have 121009 Person Observers Org Name" << endl;
      }
      return 0;
    }

    rType = it->relationshipType();
    vType = it->valueType();
    if (mVerbose) {
      cout << "CTX:  Relationship Type = " << rType
	  << " , Value Type = " << vType << endl;
    }

    if (rType != "HAS OBS CONTEXT") {
      if (mVerbose) {
	cout << "CTX: No Observation Ctx, must not have 121009 Person Observers Org Name" << endl;
      }
      return 0;
    }

    if (vType != "TEXT") {
      break;
    }

    MSRContentItemText *t =(MSRContentItemText*)factory.produceContentItem(*it);

    MString cValue = t->conceptNameValue();
    MString cDesig = t->conceptNameDesignator();
    MString cMeaning = t->conceptNameMeaning();
    delete t;

    if (mVerbose) {
      cout << "CTX:  <" << cDesig
	   << ":" << cValue
	   << ":" << cMeaning
	   << ">" << endl;
    }

    if (cValue != "121009") {
      cout << "ERR: Code value for TEXT should be 121009" << endl
	   << " Test data contains <"
	   << cValue << ">" << endl;
      return 1;
    }
    it++;
  }
  for (dummyFlag = 0; dummyFlag == 0; dummyFlag++) {
    rType = it->relationshipType();
    vType = it->valueType();
    if (mVerbose) {
      cout << "CTX: MSREvalTID2000::evalPersonObserverID1003 looking for "
	  << "PNAME EV 121010 Person Observers Role in Organization" << endl
	  << "CTX:  <" << rType
	  << ":" << vType << ">" << endl;
    }

    if (rType != "HAS OBS CONTEXT") {
      if (mVerbose) {
	cout << "ERR: No Observation Ctx, must not have 121010 Person Observers Role in Org" << endl;
      }
      return 0;
    }

    if (vType != "CODE") {
      break;
    }

    MSRContentItemCode *c =(MSRContentItemCode*)factory.produceContentItem(*it);

    MString cValue = c->conceptNameValue();
    MString cDesig = c->conceptNameDesignator();
    MString cMeaning = c->conceptNameMeaning();
    delete c;

    if (mVerbose) {
      cout << "CTX: <" << cDesig
	   << ":" << cValue
	   << ":" << cMeaning
	   << ">" << endl;
    }

    if (cValue != "121010") {
      cout << "ERR: Code value for CODE should be 121010" << endl
	   << " Test data contains <"
	   << cValue << ">" << endl;
      return 1;
    }
    it++;
  }
  for (dummyFlag = 0; dummyFlag == 0; dummyFlag++) {
   if (mVerbose) {
      cout << "CTX: MSREvalTID2000::evalPersonObserverID1003 looking for "
	  << "PNAME EV 121011 Person Observers Role in Procedure" << endl
	  << "CTX: <" << rType
	  << ":" << vType << ">" << endl;
    }

    if (rType != "HAS OBS CONTEXT") {
      if (mVerbose) {
	cout << "WARN: No Observation Ctx, must not have 121011 Person Observers Role in Procedure" << endl;
      }
      return 0;
    }

    if (vType != "CODE") {
      break;
    }

    MSRContentItemCode *c =(MSRContentItemCode*)factory.produceContentItem(*it);

    MString cValue = c->conceptNameValue();
    MString cDesig = c->conceptNameDesignator();
    MString cMeaning = c->conceptNameMeaning();
    delete c;

    if (mVerbose) {
      cout << "CTX: <" << cDesig
	   << ":" << cValue
	   << ":" << cMeaning
	   << ">" << endl;
    }

    if (cValue != "121011") {
      cout << "ERR: Code value for CODE should be 121011" << endl
	   << " Test data contains <"
	   << cValue << ">" << endl;
      return 1;
    }
    it++;
  }
  return 0;
}

int
MSREvalTID2000::evalSection7001(MSRContentItemVector::iterator& it,
	  MSRContentItemVector& v)
{
  MString rType = it->relationshipType();
  MString vType = it->valueType();
  MSRContentItemFactory factory;
  int rtnValue = 0;

  {
    cout << "CTX: MSREvalTID2000::evalSection7001 looking for "
	 << "BCID 7001 Diagnostic Imaging Report Headers"
	 << " <" << rType
	 << ":" << vType << ">" << endl
	 << "CTX:  If this is not a container, it will be ignored." << endl;
  }

  if (rType != "CONTAINS") {
    cout << "ERR: MSREvalTID2000::evalSection7001 relationship type should be CONTAINS" << endl
	 << " test data contains <"
	 << rType << ">" << endl;
    return 1;
  }
  if (vType != "CONTAINER") {
    cout << "ERR: MSREvalTID2000::evalSection7001 value type should be CONTAINER" << endl
	 << " test data contains <"
	 << vType << ">" << endl;
    return 1;
  }

  DCM_OBJECT* obj = (DCM_OBJECT*)(it->objectReference());
  MDICOMWrapper w(obj);

  MString codeValue = w.getString(0x0040A043, 0x00080100);
  MString codeDesig = w.getString(0x0040A043, 0x00080102);
  MString codeMeaning = w.getString(0x0040A043, 0x00080104);
  cout << "CTX: Found a container, now we check the code value for Diagnostic Image Report Headings" << endl;
  cout << " Your section heading is <"
	<< codeValue << ":"
	<< codeDesig << ":"
	<< codeMeaning << ">" << endl;

  this->evaluateBaselineCode(&w, 0x0040A043,
			"runtime/codes/sr/ctx_id_7001.txt");

  return 0;
}
