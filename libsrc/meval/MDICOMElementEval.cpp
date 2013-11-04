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
#include "MDICOMElementEval.hpp"
#include "MEval.hpp"
#include "MDICOMWrapper.hpp"
#include "ctn_api.h"
#include <iomanip>


static char rcsid[] = "$Id: MDICOMElementEval.cpp,v 1.7 2006/10/17 04:00:54 smm Exp $";

MDICOMElementEval::MDICOMElementEval() :
  mVerbose(false)
{
}

MDICOMElementEval::MDICOMElementEval(const MDICOMElementEval& cpy) :
  mVerbose(cpy.mVerbose)
{
}

MDICOMElementEval::~MDICOMElementEval()
{
}

void
MDICOMElementEval::printOn(ostream& s) const
{
  s << "MDICOMElementEval";
}

void
MDICOMElementEval::streamIn(istream& s)
{
  //s >> this->member;
}

// Non boiler-plate methods below

void
MDICOMElementEval::verbose(bool flag)
{
  mVerbose = flag;
}

typedef struct {
  char* label;
  DCM_TAG tag;
} ATTRIBUTE;

int
MDICOMElementEval::evalElement(int level, MDICOMWrapper& wTest, MDICOMWrapper& wGoldStandard, DCM_TAG tag,
	const MString& language)
{
  CONDITION cond;
  DCM_ELEMENT e;
  ::memset(&e, 0, sizeof(e));
  e.tag = tag;
  cond = ::DCM_LookupElement(&e);
  if (cond != DCM_NORMAL) {
    U16 group = DCM_TAG_GROUP(tag);
    U16 element = DCM_TAG_ELEMENT(tag);
    cout << MESA_ERROR_TEXT
	 << " Could not find CTN dictionary entry for attribute with tag: "
	 << setw(4) << setfill ('0') << hex << group << " "
	 << setw(4) << setfill ('0') << hex << element << endl;
    return -1;
  }

  int status = -1;
  if (::DCM_IsString(e.representation)) {
    status = this->evaluateString("label", level,
	wTest, wGoldStandard, &e, language);
  }
  return status;
}

// Private methods below here

int
MDICOMElementEval::evaluateString(const MString& label, int level,
        MDICOMWrapper& wTest, MDICOMWrapper& wGold, DCM_ELEMENT* e,
	const MString& language) const
{
  int status = 0;
  MString sTest = wTest.getString(e->tag);
  MString sGold = wGold.getString(e->tag);
  U16 group = DCM_TAG_GROUP(e->tag);
  U16 element = DCM_TAG_ELEMENT(e->tag);

  if (level >= 2) {
      cout << "CTX: "
 	   << hex
	   << setw(4) << setfill('0') << group << " "
	   << setw(4) << setfill('0') << element << dec
	   << " " << e->description << endl;
      cout << "CTX: (Test) " << sTest << endl
	   << "CTX: (Std)  " << sGold << endl;
  }
  if (e->representation == DCM_PN) {
    status = this->evaluatePN(label, level, sTest, sGold, language);
  } else {
    if (sTest != sGold) {
      status = -1;
      cout << MESA_ERROR_TEXT << " "
	 << sTest << ":" << sGold << endl;
    }
  }

  if (status != 0) {
    if (level >= 3)
      cout << MESA_CONTEXT_TEXT << " "
	   << sTest << ":" << sGold << endl;
  }
  return status;
}

int
MDICOMElementEval::evaluatePN(const MString& label, int level,
        const MString& sTest, const MString& sGold, const MString& language) const
{
  if (level >= 3 && language == "Japanese") {
    this->dumpCharInHex(sTest, sGold, language);
  }
  if (sTest == sGold)
    return 0;

  int testLength = sTest.length();
  int goldLength = sGold.length();
  int minLength = (testLength < goldLength) ? testLength : goldLength;

//#ifdef _WIN32
//  if (sTest.compare(0, minLength, sGold) != 0) {
//#else
//  if (sTest.compare(sGold, 0, minLength) != 0) {
//#endif

   if (sTest.stringCompare(0, minLength, sGold) != 0) {
    cout << MESA_ERROR_TEXT
	 << " Person name does not match:"
	 << " tst = " << sTest
	 << " std = " << sGold << endl;
    return -1;
  }

  char c = 0;
  int i;
  if (testLength > minLength) {
    for (i = minLength; i < testLength; i++) {
      c = sTest[i];
      if (c != '^') {
	cout	<< MESA_ERROR_TEXT
		<< " Found extra character(s) at end of test name ("
		<< c << "), expected to be '^'" << endl;
	cout << MESA_ERROR_TEXT
	     << " Person name does not match:"
	     << " tst = " << sTest
	     << " std = " << sGold << endl;
	return -1;
      }
    }
    if (level >= 2) {
      cout << MESA_WARN_TEXT
	   << " Extra '^' characters at the end of (test) Person Name ignored"
	   << endl;
      cout << MESA_WARN_TEXT
	   << " Test Person Name was " << sTest << endl;
    }
    return 0;
  }
  if (goldLength > minLength) {
    for (i = minLength; i < goldLength; i++) {
      c = sGold[i];
      if (c != '^') {
	cout	<< MESA_ERROR_TEXT
		<< " Found extra character(s) at end of gold standard name ("
		<< c << "), expected to be '^'" << endl;
	cout << MESA_ERROR_TEXT
	     << " Person name does not match:"
	     << " tst = " << sTest
	     << " std = " << sGold << endl;
	return -1;
      }
    }
    if (level >= 2) {
      cout << MESA_WARN_TEXT
	   << " Extra '^' characters at the end of (gold std) Person Name ignored"
	   << endl;
      cout << MESA_WARN_TEXT
	   << " Gold standard Person Name was " << sTest << endl;
    }
    return 1;
  }
  cout << "Patient name does not match: <"
	<< sTest << "><"
	<< sGold << ">" << endl;
  return -1;
}

void
MDICOMElementEval::dumpCharInHex(const MString& sTest, const MString& sStd,
	const MString& language) const {
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

