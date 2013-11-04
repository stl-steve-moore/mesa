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

#include <fstream>
#include <fcntl.h>
#include <stdio.h>
#ifdef _WIN32
#include <io.h>
#else
#include <unistd.h>
#endif

#include "MHL7Validator.hpp"
#include "MHL7Msg.hpp"

#if 0
MHL7Validator::MHL7Validator() :
  mFlavor(NULL),
  mMsg(NULL),
  mProcessingID('P'),
  mVersionNumber(".v22")
{
//  initializeFormat();
}
#endif

MHL7Validator::MHL7Validator(const MHL7Validator& cpy) :
  mProcessingID(cpy.mProcessingID),
  mVersionNumber(cpy.mVersionNumber),
  mSegInfo(cpy.mSegInfo),
  mSegmentNames(cpy.mSegmentNames),
  mLogLevel(cpy.mLogLevel)
{
}

MHL7Validator::~MHL7Validator()
{
  //HL7Free(mMsg);
  //HL7Drop(mFlavor);
}

void
MHL7Validator::printOn(ostream& s) const
{
  s << "MHL7Validator";
}

void
MHL7Validator::streamIn(istream& s)
{
  //s >> this->member;
}


// Non-boiler plate methods below
MHL7Validator::MHL7Validator ( const MString& hl7Base,
                           const MString& hl7Definition) :
  mBase(hl7Base),
  mDefinition(hl7Definition),
  mCount(0),
  mLogLevel(1)
{
}


#if 0
MHL7Validator::MHL7Validator(const MString& versionNumber, const MString& hl7Message) :
  mProcessingID('P'),
  mVersionNumber(versionNumber)
{
  initializeFormat();
  char *ver = mVersionNumber.strData();
  char fileExt[10];

  memset(fileExt, 0, sizeof(fileExt));
  fileExt[0] = '.';
  fileExt[1] = 'v';
  char *pStr = strchr(ver, '.');
  strcpy(pStr, pStr+1);
  strcat(fileExt, ver);
  delete [] ver;
  mFlavor = HL7Init("", fileExt);

  if (!mFlavor)
  {
    cout << "HL7Init Failed" << endl;
    return;
  }
  mMsg = HL7Alloca(mFlavor);
  if (!mMsg)
  {
    cout << "HL7Alloca Failed" << endl;
    return;
  }

  MString tmpMsg(hl7Message);
  char *wire = tmpMsg.strData();
  int iResult = HL7ReadMesg(mMsg, wire, strlen(wire));
  if (iResult != HL7_OK)
  {
    cout << "MHL7Validator: Failed to read the message" << endl;
    cout << HL7ErrTxt(mMsg, iResult) << endl;
    HL7Free(mMsg);
    mMsg = NULL;
  }
  delete [] wire;
}
#endif

#if 0
MHL7Validator::MHL7Validator(const MString& versionNumber, const MString& filePath, const MString& fileName) :
  mProcessingID('P'),
  mVersionNumber(versionNumber)
{
  initializeFormat();

  MString fullPath(filePath);
  if (fullPath.size())
  {
    char *p = fullPath.strData();
    if (p[strlen(p)-1] != '/')
      fullPath += "/";
    delete [] p;
  }
  fullPath += fileName;
  char *fullName = fullPath.strData();
  int fd = 0;

  fd = ::open(fullName, O_RDONLY);
  if (fd < 0) 
  {
    cout << "Cannot open file: " << fullName << endl;
    delete [] fullName;
    return;
  } 

  delete [] fullName;


  char *ver = mVersionNumber.strData();
  char fileExt[10];

  memset(fileExt, 0, sizeof(fileExt));
  fileExt[0] = '.';
  fileExt[1] = 'v';
  char *pStr = strchr(ver, '.');
  strcpy(pStr, pStr+1);
  strcat(fileExt, ver);
  delete [] ver;

  mFlavor = HL7Init("", fileExt);
  if (!mFlavor)
  {
    cout << "HL7Init Failed" << endl;
    return;
  }
  mMsg = HL7Alloca(mFlavor);
  if (!mMsg)
  {
    cout << "HL7Alloca Failed" << endl;
    return;
  }
  
  char wire[16384];
  memset(wire, 0, sizeof(wire));
  int bytes = ::read(fd, wire, sizeof(wire));
  wire[bytes] = 0;
/*
  if (!hl7fstream.eof())
  {
    cout << "MHL7Validator: Failed to read the file" << endl;
    HL7Free(mMsg);
    mMsg = NULL;
  }
*/
  ::close(fd);

  while (wire[strlen(wire)-1] != 13)
    wire[strlen(wire)-1] = 0;

  int iResult = HL7ReadMesg(mMsg, wire, strlen(wire));
  if (iResult != HL7_OK)
  {
    cout << "MHL7Validator: Failed to read the message" << endl;
    cout << HL7ErrTxt(mMsg, iResult) << endl;
    HL7Free(mMsg);
    mMsg = NULL;
    return;
  }
  else
    cout << "MHL7Validator: Read the message" << endl;
}

MHL7Validator::MHL7Validator(const MString& versionNumber, HL7FLVR* flavor, HL7MSG *hl7Msg) :
  mProcessingID('P'),
  mVersionNumber(versionNumber),
  mFlavor(flavor),
  mMsg(hl7Msg)
{
  // outsider will set the processing ID if other than 'P';
}
#endif

int
MHL7Validator::validateHL7Message(MHL7Msg& msg, const MString& maskFile,
				  ERROR_INFO& errInfo, int logLevel)
{
  mLogLevel = logLevel;

  if (this->initializeFormat(maskFile) != 0)
    return 1;

  // check the entire message for validity.  Perform various tests

  initializeErrorInfo(errInfo);

  int iResult = 0;

  MStringVector::iterator segNames = mSegmentNames.begin();
  for (; segNames != mSegmentNames.end(); segNames++) {
    if (mLogLevel >= 3)
      cout << "CTX: Validating segment: " << *segNames << endl;

    if (this->checkFormat(msg, *segNames, errInfo) != 0)
      iResult = 1;
  }
  return iResult;

}

void
MHL7Validator::processingID(char processingID)
{
  if ((processingID == 'D') || (processingID == 'P') || (processingID == 'T'))
    mProcessingID = processingID;
  else
  {
    cout << "ERR: MHL7Validator: Cannot set Processing ID" << endl;
    cout << "ERR: Valid ID's are: " << endl;
    cout << "ERR: D - Debugging" << endl;
    cout << "ERR: P - Production" << endl;
    cout << "ERR: T - Training" << endl;
  }
}

int
MHL7Validator::validateProcessingID()
{
#if 0
  if (!mMsg)
    return 0;
  
  char *pFld = NULL; 
  HL7FindSegm(mMsg, "MSH");
  pFld = HL7GetFld(mMsg, 11);
  if (*pFld != mProcessingID)
    return 0;
  
  return 1;
#endif
  return 0;
}

int
MHL7Validator::validateVersionNumber()
{
#if 0
  if (!mMsg)
    return 0;
  
  char *pFld = NULL; 
  HL7FindSegm(mMsg, "MSH");
  pFld = HL7GetFld(mMsg, 12);
  char *ver = mVersionNumber.strData();
  if (strcmp(ver, pFld))
  {
    delete [] ver;
    return 0;
  }
#endif
  return 1;
}

int
MHL7Validator::validateSegments(MHL7Msg& msg, ERROR_INFO& errInfo)
{
  // get each segment one by one and perform field validations on every segment

  MString segName = msg.firstSegment();

  if (segName == "") {
    errInfo.fldNum = 0;
    errInfo.compNum = 0;
    errInfo.subCompNum = 0;
    errInfo.errorType = SEG_NOT_PRESENT;
    return -1;
  }

  int iResult;
  do {
    if (mLogLevel >= 3)
      cout << "CTX: Validating Segment: " << segName << endl;
    iResult = validateFields(msg, errInfo);
    if (iResult != 0) {
      cout << "ERR: HL7Validator: Failed to Validate Segment: " << segName << endl;

      errInfo.segName = segName;
      break;
    }
    // also validate formats (local restrictions defined in the validation file
#if 0
    if (mSegInfo.count(segName))
      iResult = checkFormat(segName, errInfo);
    if (!iResult)
    {
      errInfo.segName = segName;
      break;
    }
#endif
  } while ((segName = msg.nextSegment()) != "");

  return iResult;
}

int
MHL7Validator::validateFields(MHL7Msg& msg, ERROR_INFO& errInfo)
{
  // assumes we are sitting on a valid segment
  int nof = msg.numberOfFields();

  for (int f = 1; f<= nof; f++) {
    MString pFld = msg.getValue(f, 0);
    //if (pFld == "")
      //continue;

    if (mLogLevel >= 3)
      cout << "CTX: Validating Field: " << f << " Value: " << pFld << endl;

    MString errText;
    int iResult = msg.validateField(f, errText);
    if (iResult != 0) {
      cout << "ERR: HL7Validator: Failed to Validate Field " << f << endl;
      cout << "ERR: Field Contents: " << pFld << endl;
      cout << "ERR: " << errText << endl;
      errInfo.fldNum = f;
      errInfo.compNum = 1;
      errInfo.subCompNum = 1;
      errInfo.errorType = INVALID_FIELD;
      return -1;
    }
  }  //endfor

  return 0;
}

#if 0
int
MHL7Validator::validateFields(const MString& segName, ERROR_INFO& errInfo)
{
  if (!segName.size())
  {
    errInfo.errorType = INVALID_PARAMS;
    return 0;
  }
 
  if (!mMsg)
  {
    errInfo.errorType = HL7MSG_NOT_AVAIL;
    return 0;
  }

  MString tmpSegNam(segName);
  char *seg = tmpSegNam.strData();
  int iResult = HL7FindSegm(mMsg, seg);
  delete [] seg;

  errInfo.segName = segName;
  if (iResult != HL7_OK)
  {
    errInfo.fldNum = 0;
    errInfo.compNum = 0;
    errInfo.subCompNum = 0;
    errInfo.errorType = SEG_NOT_PRESENT;
    cout << "Could Not Find Segment: " << segName << endl;
    cout << HL7ErrTxt(mMsg, iResult) << endl;
    return 0;
  }

  iResult = validateFields(segName, errInfo);
  if (iResult != 0)
    cout << "HL7Validator: Failed to Validate Segment: " << segName << endl;

  return iResult;
}
#endif

#if 0
int
MHL7Validator::getFirstSegment(MString& segName)
{
  if (!mMsg)
    return 0;
  
  char *seg;

  int iResult = HL7FirstSegm(mMsg, &seg);
  if (iResult != HL7_OK) {
    cout << "HL7Validator: Cannot even find the first segment" << endl;
    cout << HL7ErrTxt(mMsg, iResult) << endl;
    return 0;
  }

  segName = seg;
  return 1;
}
#endif

#if 0
int
MHL7Validator::getNextSegment(MString& segName)
{
  if (!mMsg)
    return 0;
  
  char *seg;

  int iResult = HL7NextSegm(mMsg, &seg);
  if ((iResult != HL7_OK) && (iResult != HL7_END_OF_STRUCT)) {
    cout << "HL7Validator: Cannot find the next segment after: " << segName << endl;
    cout << HL7ErrTxt(mMsg, iResult) << endl;
    return 0;
  }

  if (iResult == HL7_END_OF_STRUCT)
    return 0;

  segName = seg;

  return 1;
}
#endif


void
MHL7Validator::initializeErrorInfo(ERROR_INFO& errInfo)
{
  errInfo.segName = "Unknown Segment";
  errInfo.fldNum = 0;
  errInfo.compNum = 0;
  errInfo.subCompNum = 0;
  errInfo.errorType = ERROR_UNKNOWN;
}

int
MHL7Validator::checkFormat(MHL7Msg& msg, const MString& key, ERROR_INFO& errInfo)
{
  int rtnStatus = 0;		// Assume a success

  // position the iterator at the first field restriction of the segment
  // indicated by the key, then iterate through the entire map looking for
  // field restrictions defined for this segment

  for (MSegmentInfo::iterator i = mSegInfo.find(key); i != mSegInfo.end(); i++){
    if ((*i).first == key) {
      if (checkFieldFormat(msg, (*i).second, key, errInfo) != 0) {
	errInfo.segName = key;
        rtnStatus = 1;
      }
    }
  }

  return rtnStatus;
}

int
MHL7Validator::checkFieldFormat(MHL7Msg& msg, const FIELD_INFO& fldInfo,
				const MString& segName, ERROR_INFO& errInfo)
{
  int status = 0;	// Assume success
  MString pFld;
  char segment[64];
  segName.safeExport(segment, sizeof(segment));

  // get the field and check for locally defined format and possible values,
  // which the field is allowd to take

  if (fldInfo.fldNum && !fldInfo.subCompNum && !fldInfo.compNum) {

    pFld = msg.getValue(segment, fldInfo.fldNum, 0);
    if (mLogLevel >= 3) {
      cout << "CTX:  " << fldInfo.fldNum
	   << "." << fldInfo.subCompNum
	   << "." << fldInfo.compNum
	   << "\t<" << pFld << ">" << endl;
    }
    // remove any subcomponents
    if (pFld == "") {
      cout << " " << segName << " "
	   << fldInfo.fldNum << "."
	   << fldInfo.subCompNum << "."
	   << fldInfo.compNum << " "
	   << " Failed field validation because field is empty."
	   << endl;
      return 1;
    } else {
      MString pTmp = pFld.getToken('^', 0);

      status = verifyFormat(pTmp, fldInfo.format);
    }

    if (status == 0) {
      if ( fldInfo.possVals.size() )
        status = verifyPossibleValues(pFld, fldInfo.possVals);
      else
        return 0;
    }
  } else if ( fldInfo.fldNum && fldInfo.compNum && !fldInfo.subCompNum) {
    pFld = msg.getValue(segment, fldInfo.fldNum, fldInfo.compNum);
    if (mLogLevel >= 3) {
      cout << "CTX:  " << fldInfo.fldNum
	   << "." << fldInfo.compNum
	   << "\t<" << pFld << ">" << endl;
    }
    // remove any subcomponents
    if (pFld == "") {
      cout << " Field/component of 0-length fails validation." << endl;
      return 1;
    } else {
      MString pTmp = pFld.getToken('\\', 0);

      status = verifyFormat(pTmp, fldInfo.format);
    }

    if (status == 0) {
      if ( fldInfo.possVals.size() )
        status = verifyPossibleValues(pFld, fldInfo.possVals);
      else
        return 0;
    }
  } else if ( fldInfo.fldNum && fldInfo.compNum && fldInfo.subCompNum) {
    if (1) {
      cout << " " << fldInfo.fldNum
	   << "." << fldInfo.subCompNum
	   << "." << fldInfo.compNum << endl;
      cout << "Need to examine MHL7Validator; not ready for this case."
	   << endl;
      ::exit(1);
    }
#if 0
    pFld = HL7GetSub(mMsg, fldInfo.fldNum, 1, fldInfo.compNum, fldInfo.subCompNum);
    // remove any subcomponents
    if (pFld) {
      char* pTmp = NULL;
      pTmp = strchr(pFld, '&');
      if (pTmp)
        *pTmp = 0; 
      status = verifyFormat(pFld, fldInfo.format);
    } else {
      return 1;
    }

    if (status) {
      if ( fldInfo.possVals.size() )
        status = verifyPossibleValues(pFld, fldInfo.possVals);
      else
        return 1;
    }
#endif
  } else {
    return 0;
  }

  if (status != 0) {
    cout << "Failed this field: "
	 << segName << " "
	 << fldInfo.fldNum << "."
	 << fldInfo.compNum << "."
	 << fldInfo.subCompNum << endl;

    errInfo.fldNum = fldInfo.fldNum;
    errInfo.compNum = fldInfo.compNum;
    errInfo.subCompNum = fldInfo.subCompNum;
    errInfo.errorType = INVALID_FIELD;
  }
  return status;
}

int
MHL7Validator::verifyFormat(const MString& value, const MString& format)
{
  /************************************ Formatting Information
  $ means one or more characters to follow
  # means a numeric character
  X means any alphanumeric
  any thing else means a literal
  Example: XXX00$#.00 means 3 alphanumeric characters followed by
    2 leading zeros, followed by one or more numerics, followed by
    a period ("."), followed by two trailing zeros
  Note: special characters like '\' should be preceded by a slash ('\')
  ************************************************************************/
  char *val = value.strData();
  char *form = format.strData();

  char *pFrm = form;
  char *pVal = val;
  char tstchr;
  int rtnStatus = 0;

  if ((*pVal == 0) || (*pFrm == 0))
    goto formatExit;

  if (*pVal == '\\')
    pVal++;

  while(*pVal != 0) {
    if (*pFrm == '$')
      tstchr = *(pFrm + 1);
    else
      tstchr = *pFrm; 

    switch (tstchr) {
      case '#':
	if (!isdigit(*pVal)) {
	  rtnStatus = 1;
	  cout << " The following character is expected to be a digit: " << *pVal << endl;
	  goto formatExit;
	}
	break;
      case 'X':
	if (!isalpha(*pVal)) {
	  rtnStatus = 1;
	  cout << " The following character is expected to be an alpha character: " << *pVal << endl;
	  goto formatExit;
	}
	break;
      case 'Z':
	if (!isprint(*pVal)) {
	  rtnStatus = 1;
	  cout << " The following character is expected to be a printable character: " << *pVal << endl;
	  goto formatExit;
	}
	break;
      default:
	if (*pVal != tstchr) {
	  rtnStatus = 1;
	  cout << " The character in the HL7 field (" << *pVal << ")"
	       << " does not match the format character (" << tstchr << ")" << endl;
	  goto formatExit;
	}
	break;
    }

    pVal++;
    if (*pVal == '\\')
      pVal++;

    if (*pFrm == '$') {
      switch (tstchr) {
	case '#':
	  if (!isdigit(*pVal))
	    pFrm += 2;
	  break;
	case 'X':
	  if (!isalpha(*pVal))
	    pFrm += 2;
	  break;
	case 'Z':
	  if (!isprint(*pVal))
	    pFrm += 2;
	  break;
	default:
	  if (tstchr != *pVal)
	    pFrm += 2;
	  break;
      }
    } else {
      pFrm++;
    }
  }

  if (*pFrm == '$')
    pFrm++;

  if (*pFrm != 0) {
    cout << " In format test, there are still format characters to satisfy"
	 << endl
	 << " and we have reach the end of your input data. "
	 << endl;
    rtnStatus = 1;
  }

formatExit:
  delete [] val;
  delete [] form;

  return rtnStatus;
}

int
MHL7Validator::verifyPossibleValues(const MString& value,
			const MPossVals& possVals)
{
  // if there are any limitations on the values that the field can take,
  //  they will be stored in a vector inside FIELD_INFO

  MPossVals pv(possVals);
  MPossVals::iterator i = pv.begin();
  if ( i == pv.end())
    return 0;

  int rtnValue = 1;  // Assume a failure
  do {
    if (value == *i) {
      rtnValue = 0;
      break;
    }
    i++;
  } while (i != pv.end());

  if (rtnValue != 0) {
    cout << " Failed test for possible values. Input value = <"
	 << value << ">" << endl;
    cout << " List of possible values:" << endl;
    for (i = pv.begin(); i != pv.end(); i++) {
      cout << "  <" << *i << ">" << endl;
    }
  }
  return rtnValue;
}

int
MHL7Validator::initializeFormat(const MString& path)
{
  // read the ini file and add segment/field information (local restrictions)
  // in the multimap MSegmentInfo (mSegInfo)

  char txt[1024];
  path.safeExport(txt, sizeof(txt));

  ifstream f(txt);
  if (!f) {
    cout << "Could not read from format file: " << path << endl;
    return 1;
  }

  char buf[1024];
  char *p;
  MString segName;

  memset(buf, 0, sizeof(buf));

  while (f.getline(buf, sizeof(buf))) {
    // ignore comments
    if ((buf[0] == '#') || (buf[0] == ' '))
      continue;

    p = buf;
    if (buf[0] == '[') { //found a new section
      // get segment name
      p++;
      char *tmp = strchr(p, ']');
      if (tmp != NULL) {
        *tmp = 0;
        segName = p;
	mSegmentNames.push_back(segName);
        *tmp = ']';
      }
    } else if (isdigit(buf[0])) {
      // get field specific information
      FIELD_INFO fldInfo;
      // get information on a particular field
      int  fldnum = -1, compnum = -1, subcompnum = -1;
      char num[1024];
      memset(num, 0, sizeof(num));
      int i = 0;
      while (*p != 0)
      {
        if (!isdigit(*p)) 
        {
          num[i] = 0;
          if (fldnum < 0)
            fldnum = atoi(num);
          else if (compnum < 0)
            compnum = atoi(num);
          else
            subcompnum = atoi(num);

          if (*p == ',')
            break;

          i = 0;
          memset(num, 0, sizeof(num));
        }
        else
        {
          num[i] = *p;
          i++;
        }

        if (*p == '.')
          p++;  // move to the next character
        else if ( !isdigit(*p) )
          break;
        else
          p++;
      } // endwhile

      if ( fldnum >  0 )
        fldInfo.fldNum = fldnum;
      else
        fldInfo.fldNum = 0;
      if (compnum > 0)
        fldInfo.compNum = compnum;
      else
        fldInfo.compNum = 0;
      if (subcompnum > 0)
        fldInfo.subCompNum = subcompnum;
      else
        fldInfo.subCompNum = 0;

      // now jump pass the "Format ="
      p = strstr(buf, "Format");
      if (p)
      {
        while (*p != '=')
          p++;
        p++;
        while(*p == ' ')
          p++;
      }
      // now put the formating information in the structure
      char *tmp = p;
      char format[1024];
      memset(format,0,sizeof(format));
      i = 0;
      while (p && (*p != ',')&& (*p != ';') && (*p))
      {
        format[i] = *p;
        p++;
        i++;
      } // endwhile

      if (strlen(format))
        fldInfo.format = format;

      // now go after Possible Values
      p = strstr(buf, "PV");
      if (p)
      {
        while (*p != '=')
          p++;
        p++;
        while (*p == ' ')
          p++;
      }

      i = 0;
      char pv[512];
      memset(pv, 0, sizeof(pv));
      while (p && (*p != ';') && (*p))
      {
        if (*p == ':')
        {
          p++;
          pv[i] = 0;
          if (strlen(pv))
            fldInfo.possVals.push_back(pv);
          memset(pv, 0, sizeof(pv));
          i = 0;
          continue;
        }
        pv[i] = *p;
        i++;
        p++; 
      } // endwhile 
      if (strlen(pv))
        fldInfo.possVals.push_back(pv);

    // now that we have complete information about a particular field, we can insert
    if (segName.size() && fldInfo.fldNum && (fldInfo.format.size() || fldInfo.possVals.size()))
      //mSegInfo.insert(segName, fldInfo);
      mSegInfo.insert (MSegmentInfo::value_type (segName, fldInfo) );

    //reinitialize FIELD_INFO struct
    fldInfo.fldNum = 0;
    fldInfo.compNum = 0;
    fldInfo.subCompNum = 0;
    fldInfo.format = "";
    fldInfo.possVals.erase(fldInfo.possVals.begin(), fldInfo.possVals.end());
 
    memset(buf, 0, sizeof(buf));

    }  // endif
  }  //endwhile
  
  if (!f.eof()) {
    cout << "Could Not Read From File: " << path << endl;
    return 1;
  }

  return 0;
}
