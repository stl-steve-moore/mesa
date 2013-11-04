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
#include "MCharsetEncoder.hpp"
#include "MLogClient.hpp"

#include <iomanip>

static char rcsid[] = "$Id: MCharsetEncoder.cpp,v 1.3 2004/05/11 21:04:48 smm Exp $";

MCharsetEncoder::MCharsetEncoder()
{
}

MCharsetEncoder::MCharsetEncoder(const MCharsetEncoder& cpy)
{
}

MCharsetEncoder::~MCharsetEncoder()
{
}

void
MCharsetEncoder::printOn(ostream& s) const
{
  s << "MCharsetEncoder";
}

void
MCharsetEncoder::streamIn(istream& s)
{
  //s >> this->member;
}

// Non boiler plate methods follow

int
MCharsetEncoder::xlate(
        void* outString, int& outputLength, int maxOut,
        const void* inString, int inLength,
        const MString& inEncoding, const MString& outEncoding)
{
  outputLength = 0;
  int status = 1;	// Indicates a failure;

  if (inEncoding == "ISO2022JP" && outEncoding == "EUC_JP") {
    status = this->xlateISO2022JP_EUCJP(outString, outputLength,
			maxOut, inString, inLength);
  } else if (inEncoding == "EUC_JP" && outEncoding == "ISO2022JP") {
    status = this->xlateEUCJP_ISO2022JP(outString, outputLength,
			maxOut, inString, inLength);
  }

  return status;
}

int
MCharsetEncoder::xlateHL7DICOM(
        void* outString, int& outputLength, int maxOut,
        const void* inString, int inLength,
        const MString& encoding)
{
  MLogClient logClient;

  CHR_CHARACTER currentMode = CHR_ASCII;
  CHR_CHARACTER newMode = CHR_ASCII;
  unsigned char buf[10] = "";
  int byteCount = 0;
  int skipCount = 0;
  const unsigned char* pInput = (const unsigned char*)inString;
  unsigned char* pOutput = (unsigned char*)outString;
  int status = 0;

  while (inLength > 0) {
    status = this->getNextHL7Character(buf, byteCount, skipCount,
		currentMode, newMode, pInput, inLength);
    if (status != 0) {
      return 1;
    }
    int i = 0;
    if (byteCount == 1 &&
	(newMode == CHR_ASCII || newMode == CHR_ISOIR14) &&
	buf[0] == '~') {
      buf[0] = '=';
    }
    for (i = 0; i < byteCount; i++) {
      pOutput[i+outputLength] = buf[i];

      cout << hex << setw(2) << setfill('0') << (unsigned int)buf[i] << ' ';
    }
    cout << endl;
    inLength -= skipCount;
    pInput += skipCount;
    currentMode = newMode;
    outputLength += byteCount;
  }
  return 0;
}

int
MCharsetEncoder::xlateHL7DICOMEUCJP(
        void* outString, int& outputLength, int maxOut,
        const void* inString, int inLength,
        const MString& encoding)
{
  MLogClient logClient;

  CHR_CHARACTER currentMode = CHR_ASCII;
  CHR_CHARACTER newMode = CHR_ASCII;
  unsigned char c;
  unsigned char c1;
  unsigned char c2;
  unsigned char c3;
  const unsigned char* pInput = (const unsigned char*)inString;
  unsigned char* pOutput = (unsigned char*)outString;
  int status = 0;

  outputLength = 0;
  while (inLength > 0) {
    c = *pInput++;  inLength--;

    if (c == CHR_SS2) {		// CHR_ISOIR13, JIS X 0201: Katakana
      *pOutput++ = c; outputLength++;
      *pOutput++ = *pInput++;
      inLength--;
      outputLength++;
      currentMode = CHR_ISOIR13;
    } else if (c == CHR_SS3) {	// CHR_ISOIR159, Double byte JIS X 0212: Supp Kanji
      *pOutput++ = c; outputLength++;
      *pOutput++ = *pInput++;
      *pOutput++ = *pInput++;
      inLength -= 2;
      outputLength += 2;
      currentMode = CHR_ISOIR159;
    } else if ((c & 0x80) != 0) { // CHR_ISOIR87, JIS X 0208: Kanji
      *pOutput++ = c; outputLength++;
      *pOutput++ = *pInput++;
      *pOutput++ = *pInput++;
      inLength -= 2;
      outputLength += 2;
      currentMode = CHR_ISOIR87;
    } else {			// CHR_ASCII, ISO IR 6
      if (c == '~') {
	c = '=';
      }
      *pOutput++ = c; outputLength++;
      currentMode = CHR_ASCII;
    }
  }
  return 0;
}

int
MCharsetEncoder::substituteCharacter(
        void* charString, int length,
        const unsigned char inChar, const unsigned char outChar,
	const MString& encoding)
{
  MLogClient logClient;
  if (encoding != "EUCJP") {
    return 0;
  }
  unsigned char* p = (unsigned char*)charString;
  unsigned char c;
  while (length > 0) {
    c = *p++; length--;
    if (c == CHR_SS2) {	// CHR_ISOIR13, JIS X 0202: Katakana
      c = *p;
      if (c == inChar) {
	*p = outChar;
      };
      p++; length--;
    } else if (c == CHR_SS3) {	// CHR_ISOIR159, Double byte JIS X 00212: Supp Kanji
      p += 2; length -= 2;
    } else if ((c & 0x80) != 0) {	// CHR_ISOIR87, JIS X 0208: Kanji
      p += 2; length -= 2;
    } else {			// ASCII
      if (c == inChar) {
	*(p-1) = outChar;
      };
    }
  }
  return 0;
}


// Private methods defined below here

int
MCharsetEncoder::xlateISO2022JP_EUCJP(
        void* outString, int& outputLength, int maxOut,
        const void* inString, int inLength)
{
  int encodedLength = 0;
  CONDITION cond;

  cond = CHR_Encode(inString, inLength,
	CHR_ISO2022JP, outString, maxOut,
	CHR_EUC_JP, &encodedLength);
  if (cond != CHR_NORMAL) {
    ::COND_DumpConditions();
    return 1;
  }
  outputLength = encodedLength;
  return 0;
}


int
MCharsetEncoder::xlateEUCJP_ISO2022JP(
        void* outString, int& outputLength, int maxOut,
        const void* inString, int inLength)
{
  int encodedLength = 0;
  CONDITION cond;

  cond = CHR_Encode(inString, inLength,
	CHR_EUC_JP, outString, maxOut,
	CHR_ISO2022JP, &encodedLength);
  if (cond != CHR_NORMAL) {
    ::COND_DumpConditions();
    return 1;
  }
  outputLength = encodedLength;
  return 0;
}



int
MCharsetEncoder::getNextHL7Character(unsigned char* output, int& outputCount, int& skipCount,
	CHR_CHARACTER currentMode, CHR_CHARACTER& newMode,
	const unsigned char* input, int inLength)
{
  if (inLength <= 0) {
    outputCount = 0;
    skipCount = 0;
    return 1;
  }

  int rtnValue = 0;
  bool foundEscapeSequence = false;
  if (*input == '\0') {
    outputCount = 0;
    skipCount = 0;
    rtnValue = 1;
    foundEscapeSequence = true;
  } else if (*input == CHR_ESCAPE) {
    foundEscapeSequence = true;
    if (inLength == 1) {		// ESCAPE at the end of a string
      outputCount = 1;		// Not quite legal, but allow it
      skipCount = 1;
      *output = *input;
    } else if (inLength == 2) {	// This is not legal, <ESC> <XX>
      outputCount = 0;		// Not quite legal, but allow it
      skipCount = 0;
      rtnValue = 1;
    } else if (inLength == 3) {
      if (input[1] == 0x28 && input[2] == 0x42) {
					// Switch to ASCII
	outputCount = 3;
	skipCount = 3;
	*output++ = *input++;
	*output++ = *input++;
	*output++ = *input++;
	newMode = CHR_ASCII;
      } else if (input[1] == 0x28 && input[2] == 0x49) {
					// Switch to ISO IR 13, single byte JIS X 0201: Katakana
	outputCount = 3;
	skipCount = 3;
	*output++ = *input++;
	*output++ = *input++;
	*output++ = *input++;
	newMode = CHR_ISOIR13;
      } else if (input[1] == 0x28 && input[2] == 0x4a) {
					// Switch to ISO IR 14, single byte JIS X 0201-1976: Romaji
	outputCount = 3;
	skipCount = 3;
	*output++ = *input++;
	*output++ = *input++;
	*output++ = *input++;
	newMode = CHR_ISOIR14;
      } else if (input[1] == 0x24 && input[2] == 0x42) {
					// Switch to ISO IR 87, double byte JIS X 0208: Kanji
	outputCount = 3;
	skipCount = 3;
	*output++ = *input++;
	*output++ = *input++;
	*output++ = *input++;
	newMode = CHR_ISOIR87;
      } else {			// Illegal escape sequence
	outputCount = 0;
	skipCount = 0;
	rtnValue = 1;
      }
    } else {				// inLength > 3
      if (input[1] == 0x28 && input[2] == 0x42) {
					// Switch to ASCII
	outputCount = 3;
	skipCount = 3;
	*output++ = *input++;
	*output++ = *input++;
	*output++ = *input++;
	newMode = CHR_ASCII;
      } else if (input[1] == 0x28 && input[2] == 0x49) {
					// Switch to ISO IR 13, single byte JIS X 0201: Katakana
	outputCount = 3;
	skipCount = 3;
	*output++ = *input++;
	*output++ = *input++;
	*output++ = *input++;
	newMode = CHR_ISOIR13;
      } else if (input[1] == 0x28 && input[2] == 0x4a) {
					// Switch to ISO IR 14, single byte JIS X 0201-1976: Romaji
	outputCount = 3;
	skipCount = 3;
	*output++ = *input++;
	*output++ = *input++;
	*output++ = *input++;
	newMode = CHR_ISOIR14;
      } else if (input[1] == 0x24 && input[2] == 0x42) {
					// Switch to ISO IR 87, double byte JIS X 0208: Kanji
	outputCount = 3;
	skipCount = 3;
	*output++ = *input++;
	*output++ = *input++;
	*output++ = *input++;
	newMode = CHR_ISOIR87;
      } else if (input[1] == 0x24 && input[2] == 0x28 && input[3] == 0x44) {
					// Switch to ISO IR 159, double byte JIS X 0212: Supp Kanji
	outputCount = 4;
	skipCount = 4;
	*output++ = *input++;
	*output++ = *input++;
	*output++ = *input++;
	 newMode = CHR_ISOIR159;
      } else if (input[1] == 0x24 && input[2] == 0x29 && input[3] == 0x43) {
					// Switch to ISO IR 149, double byte KS X 1001: Hangul
	outputCount = 4;
	skipCount = 4;
	*output++ = *input++;
	*output++ = *input++;
	*output++ = *input++;
	newMode = CHR_ISOIR149;
      } else {			// Illegal escape sequence
	outputCount = 0;
	skipCount = 0;
	rtnValue = 1;
      }
    }
  }
  if (foundEscapeSequence) {
    return rtnValue;
  }

  rtnValue = 0;
  switch (currentMode) {
  case CHR_ASCII:
  case CHR_ISOIR13:
  case CHR_ISOIR14:
    *output = *input;
    outputCount = 1;
    skipCount = 1;
    break;

  case CHR_ISOIR87:
  case CHR_ISOIR159:
  case CHR_ISOIR149:
    *output++ = *input++;
    *output++ = *input++;
    outputCount = 2;
    skipCount = 2;
    break;
  default:
    rtnValue = 1;
  }
  return rtnValue;
}
