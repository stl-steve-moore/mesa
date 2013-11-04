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

#include <iomanip>
#include <fstream>
#include <fcntl.h>
#include <stdio.h>
#ifdef _WIN32
#include <io.h>
#else
#include <unistd.h>
#endif

#include "MHL7Compare.hpp"
#include "MHL7Msg.hpp"
#include "MHL7Factory.hpp"

MHL7Compare::MHL7Compare() :
  mLogLevel(1),
  mCount(0),
  mMsgExist(NULL),
  mFlavorExist(NULL),
  mFlavorNew(NULL),
  mMsgNew(NULL)
{
}

MHL7Compare::MHL7Compare(const MHL7Compare& cpy) :
  mLogLevel(cpy.mLogLevel),
  mCount(cpy.mCount),
  mMsgExist(cpy.mMsgExist),
  mMsgNew(cpy.mMsgNew),
  mFlavorExist(cpy.mFlavorExist),
  mFlavorNew(cpy.mFlavorNew),
  mDiff(cpy.mDiff)
{
}

MHL7Compare::~MHL7Compare()
{
}

void
MHL7Compare::printOn(ostream& s) const
{
  s << "MHL7Compare";
}

void
MHL7Compare::streamIn(istream& s)
{
  //s >> this->member;
}

// non-boiler plate methods below
MHL7Compare::MHL7Compare ( const MString& hl7Base, 
			   const MString& hl7Definition) :
  mLogLevel(1),
  mBase(hl7Base),
  mDefinition(hl7Definition),
  mCount(0)
{
}

MHL7Compare::MHL7Compare ( const MString& HL7Base, 
			   const MString& HL7Definition,
                           const MString& fileName) :
  mLogLevel(1),
  mBase(HL7Base),
  mDefinition(HL7Definition),
  mCount(0)
{
  initializeFormat(fileName);
}

int
MHL7Compare::compare(const MString& existFile, const MString& newFile, int logLevel) 
{
  mLogLevel = logLevel;
  MHL7Factory factory(mBase, mDefinition);

  MHL7Msg* msgExisting = factory.readFromFile(existFile);
  MHL7Msg* msgNew = factory.readFromFile(newFile);

  mMsgExist = msgExisting->getNativeMsg();
  mMsgNew   = msgNew->getNativeMsg();

  compareHL7();

  delete msgExisting;
  delete msgNew;

  return 0;

#if 0
  int baseLen = mBase.size()+1;
  int defLen = mDefinition.size()+1;
  char hl7Base[1024];
  char hl7Definition[30];
  mBase.safeExport(hl7Base, sizeof(hl7Base)-1);
  mDefinition.safeExport(hl7Definition, sizeof(hl7Definition)-1);
 
  if ( !existFile.size() || !newFile.size()) {
    cout << "File Names not properly specified" << endl;
    return -1;
  }

  cout << "Comparing Files: " << existFile << " and " << newFile << endl;

  int fd = 0;
  MString file(existFile);
  char *FullName = file.strData();

  fd = ::open(FullName, O_RDONLY);
  if (fd < 0) {
    cout << "Cannot open file: " << FullName << endl;
    delete [] FullName;
    return -1;
  } 

  // both file extensions should be in "v##" format where ## denotes the version number. e.g ".v22"
//   char *ver = strchr(FullName, '.');
//   if (!ver)
//   {
//     memset(FullName, 0, existFile.size());
//     strcpy(FullName, ".ihe");
//     ver = hl7Definition;
//   }
  
  mFlavorExist = HL7Init(hl7Base, hl7Definition);
  delete [] FullName;
  if (!mFlavorExist) {
    cout << "HL7Init Failed for the Existing Message" << endl;
    return -1;
  }
  mMsgExist = HL7Alloca(mFlavorExist);
  if (!mMsgExist) {
    cout << "HL7Alloca Failed for the Existing Message" << endl;
    HL7Drop(mFlavorExist);
    return -1;
  }
  
  char wire[16384];
  memset(wire, 0, sizeof(wire));
  int bytes = read(fd, wire, sizeof(wire));
  wire[bytes] = 0;

  close (fd);

  while (wire[strlen(wire)-1] != 13)
    wire[strlen(wire)-1] = 0;

  int iResult = HL7ReadMesg(mMsgExist, wire, strlen(wire));
  if (iResult != HL7_OK) {
    cout << "MHL7Compare: Failed to read the Existing message" << endl;
    cout << HL7ErrTxt(mMsgExist, iResult) << endl;
    HL7Free(mMsgExist);
    HL7Drop(mFlavorExist);
    mMsgExist = NULL;
    mFlavorExist = NULL;
    return -1;
  }

  // now read the new file
  fd = 0;
  file = newFile;
  FullName = file.strData();

  fd = open(FullName, O_RDONLY);
  if (fd < 0) {
    cout << "Cannot open file: " << FullName << endl;
    delete [] FullName;
    return -1;
  } 

  // file extension should be in "v##" format where ## denotes the version number. e.g ".v22"

//   ver = strchr(FullName, '.');
//   if (!ver)
//   {
//     memset(FullName, 0, existFile.size());
//     strcpy(FullName, ".ihe");
//     ver = FullName;
//   }

  // ver = hl7Definition;

  mFlavorNew = HL7Init(hl7Base, hl7Definition);
  delete [] FullName;
  if (!mFlavorNew)
  {
    cout << "HL7Init Failed for the New Message" << endl;
    HL7Free(mMsgExist);
    HL7Drop(mFlavorExist);
    return -1;
  }
  mMsgNew = HL7Alloca(mFlavorNew);
  if (!mMsgNew)
  {
    cout << "HL7Alloca Failed for the New Message" << endl;
    HL7Drop(mFlavorNew);
    HL7Free(mMsgExist);
    HL7Drop(mFlavorExist);
    return -1;
  }
  
  memset(wire, 0, sizeof(wire));
  bytes = read(fd, wire, sizeof(wire));
  wire[bytes] = 0;

  close (fd);

  while (wire[strlen(wire)-1] != 13)
    wire[strlen(wire)-1] = 0;

  iResult = HL7ReadMesg(mMsgNew, wire, strlen(wire));
  if (iResult != HL7_OK)
  {
    cout << "MHL7Compare: Failed to read the New message" << endl;
    cout << HL7ErrTxt(mMsgNew, iResult) << endl;
    HL7Free(mMsgExist);
    HL7Drop(mFlavorExist);
    mMsgExist = NULL;
    mFlavorExist = NULL;
    HL7Free(mMsgNew);
    HL7Drop(mFlavorNew);
    mMsgNew = NULL;
    mFlavorNew = NULL;
    return -1;
  }

  // now that we have allocated both messages, compare them
  compareHL7();
#endif
}

int
MHL7Compare::compare(HL7MSG* const existMsg, HL7MSG* const newMsg, int logLevel)
{
  mLogLevel = logLevel;
  mMsgExist = existMsg;
  mMsgNew = newMsg;
  mFlavorExist = NULL;
  mFlavorNew = NULL;

  this->compareHL7();
  return 0;
}

int
MHL7Compare::count()
{
  return mCount;
}

MDiff&
MHL7Compare::getDiff()
{
  return mDiff;
}

// Private methods below

void
MHL7Compare::compareHL7()
{
  MString segExist, segNew;

  int rExist = getFirstSegment(mMsgExist, segExist);
  if (!rExist)
  {
    cout << "Cannot access the first segment of the existing message" << endl;
    return;
  }

  int rNew = getFirstSegment(mMsgNew, segNew);
  if (!rNew)
  {
    cout << "MHL7Compare: Cannot access the first segment of the new message" << endl;
    return;
  }

  if (mSegInfo.empty())
  {
    // no initialize file was provided.
    // Compare all the fields of all the segments
    do
    {
      if (segExist != segNew)
      {
        cout << "MHL7Compare: segments not in proper order" << endl;
        DIFF diff;
        diff.fldNum = 0;
        diff.existValue = segExist;
        diff.newValue = segNew;
        diff.comment = "Segment order does not match";
        mDiff.insert (MDiff::value_type (segExist, diff) );
        mCount++;
        break;
      } // endif

      //cout << "Comparing segments: " << segExist << " " << segNew << endl;
      char *name = segNew.strData();

      if (!strcmp(name, "MSH"))
        compareMesgHeaders();
      else if (!strcmp(name, "EVN"))
        compareEVNs();
      else
        compareFields(segExist);  // applies to any segment

      rExist = getNextSegment(mMsgExist, segExist);
      rNew = getNextSegment(mMsgNew, segNew);
      if (rExist != rNew)
      {
        cout << "MHL7Compare: One message is shorter than the other" << endl;
        DIFF diff;
        diff.fldNum = 0;
        diff.existValue = segExist;
        diff.newValue = segNew;
        diff.comment = "One message is shorter than the other";
        mDiff.insert (MDiff::value_type (segExist, diff) );
        mCount++;
      }
    }
    while (rExist && rNew);
  } // endif mSegInfo.empty()
  else
  {
    for (MSegmentInfo::iterator i = mSegInfo.begin(); i != mSegInfo.end(); i++)
    {
      segExist = (*i).first;

      // Go to beginning of message, and restart search.
      rNew = getFirstSegment(mMsgNew, segNew);
      rExist = getFirstSegment(mMsgExist, segNew);
      if (segNew != segExist) {
	segNew = segExist;
	rExist = findSegment(mMsgExist, segExist);
	rNew = findSegment(mMsgNew, segNew);
      }

      // Check all instances of segExist in mMsgExist and mMsgNew
      // Note: if a segment mentioned in the .ini file does not
      // exist in the existing file, there is no error. 
      while(rExist || rNew)
      {
	// If a segment is not found in the new message, that exists in the
        // existing file, generate a difference.
        if (rExist && !rNew)
        {
          DIFF diff;
          diff.fldNum = 0;
          diff.existValue = segExist;
          diff.newValue = segNew;
          diff.comment = "New message is missing this segment";
          mDiff.insert (MDiff::value_type (segExist, diff) );
          mCount++;
	  rNew = rExist = false;
          continue;
        }

	// If a segment exists in the new message, but not in the existing,
	// then generate an appropriate difference.
	if (!rExist && rNew)
	{
	  DIFF diff;
	  diff.fldNum = 0;
	  diff.existValue = segExist;
	  diff.newValue = segNew;
	  diff.comment = "New message has too many segments of this type";
	  mDiff.insert (MDiff::value_type (segExist, diff) );
	  mCount++;
	  rNew = rExist = false;
	  continue;
	}
	  
        // Find the difference(s) within existing segments
        compareFieldValues(segExist,
                         ((*i).second).fldNum,
                         ((*i).second).compNum,
                         ((*i).second).subCompNum
                        );

	rExist = findSegment(mMsgExist, segExist);
	rNew = findSegment(mMsgNew, segExist);

      } // endwhile

    } // endfor
  } // endelse mSegInfo.empty()
}

void
MHL7Compare::compareMesgHeaders()
{
  // only few fields need to be checked for equivalence
 
  char *pFldExist, *pFldNew;

  // check for field separator
  pFldExist = HL7GetFld(mMsgExist, 1);
  pFldNew   = HL7GetFld(mMsgNew, 1);
  if ((!pFldExist && pFldNew) || (pFldExist && !pFldNew) || (pFldExist && pFldNew && strcmp(pFldExist, pFldNew)))
  {
    DIFF diff;
    diff.fldNum = 1;
    if (pFldExist)
      diff.existValue = pFldExist;
    else
      diff.existValue = "";
    if (pFldNew)
      diff.newValue = pFldNew;
    else
      diff.newValue = "";
    mDiff.insert (MDiff::value_type ("MSH", diff));
    mCount++;
  }

  // check for encoding characters 
  pFldExist = HL7GetFld(mMsgExist, 2);
  pFldNew   = HL7GetFld(mMsgNew, 2);
  if ((!pFldExist && pFldNew) || (pFldExist && !pFldNew) || (pFldExist && pFldNew && strcmp(pFldExist, pFldNew)))
  {
    DIFF diff;
    diff.fldNum = 2;
    if (pFldExist)
      diff.existValue = pFldExist;
    else
      diff.existValue = "";
    if (pFldNew)
      diff.newValue = pFldNew;
    else
      diff.newValue = "";
    mDiff.insert (MDiff::value_type ("MSH", diff));
    mCount++;
  }

  // check for Message Type 
  pFldExist = HL7GetFld(mMsgExist, 9);
  pFldNew   = HL7GetFld(mMsgNew, 9);
  if ((!pFldExist && pFldNew) || (pFldExist && !pFldNew) || (pFldExist && pFldNew && strcmp(pFldExist, pFldNew)))
  {
    DIFF diff;
    diff.fldNum = 9;
    if (pFldExist)
      diff.existValue = pFldExist;
    else
      diff.existValue = "";
    if (pFldNew)
      diff.newValue = pFldNew;
    else
      diff.newValue = "";
    mDiff.insert (MDiff::value_type ("MSH", diff));
    mCount++;
  }

  // check for Processing ID 
  pFldExist = HL7GetFld(mMsgExist, 11);
  pFldNew   = HL7GetFld(mMsgNew, 11);
  if ((!pFldExist && pFldNew) || (pFldExist && !pFldNew) || (pFldExist && pFldNew && strcmp(pFldExist, pFldNew)))
  {
    DIFF diff;
    diff.fldNum = 11;
    if (pFldExist)
      diff.existValue = pFldExist;
    else
      diff.existValue = "";
    if (pFldNew)
      diff.newValue = pFldNew;
    else
      diff.newValue = "";
    mDiff.insert (MDiff::value_type ("MSH", diff));
    mCount++;
  }

  // check for Version ID 
  pFldExist = HL7GetFld(mMsgExist, 12);
  pFldNew   = HL7GetFld(mMsgNew, 12);
  if ((!pFldExist && pFldNew) || (pFldExist && !pFldNew) || (pFldExist && pFldNew && strcmp(pFldExist, pFldNew)))
  {
    DIFF diff;
    diff.fldNum = 12;
    if (pFldExist)
      diff.existValue = pFldExist;
    else
      diff.existValue = "";
    if (pFldNew)
      diff.newValue = pFldNew;
    else
      diff.newValue = "";
    mDiff.insert (MDiff::value_type ("MSH", diff));
    mCount++;
  }
}

void
MHL7Compare::compareEVNs()
{
  // only few fields need to be checked for equivalence
 
  char *pFldExist, *pFldNew;

  // check for Event Type Code
  pFldExist = HL7GetFld(mMsgExist, 1);
  pFldNew   = HL7GetFld(mMsgNew, 1);
  if ((!pFldExist && pFldNew) || (pFldExist && !pFldNew) || (pFldExist && pFldNew && strcmp(pFldExist, pFldNew)))
  {
    DIFF diff;
    diff.fldNum = 1;
    if (pFldExist)
      diff.existValue = pFldExist;
    else
      diff.existValue = "";
    if (pFldNew)
      diff.newValue = pFldNew;
    else
      diff.newValue = "";
    mDiff.insert (MDiff::value_type ("MSH", diff));
    mCount++;
  }

  // check for Date/Time Planned Event 
  pFldExist = HL7GetFld(mMsgExist, 3);
  pFldNew   = HL7GetFld(mMsgNew, 3);
  if ((!pFldExist && pFldNew) || (pFldExist && !pFldNew) || (pFldExist && pFldNew && strcmp(pFldExist, pFldNew)))
  {
    DIFF diff;
    diff.fldNum = 3;
    if (pFldExist)
      diff.existValue = pFldExist;
    else
      diff.existValue = "";
    if (pFldNew)
      diff.newValue = pFldNew;
    else
      diff.newValue = "";
    mDiff.insert (MDiff::value_type ("MSH", diff));
    mCount++;
  }

  // check for Event Reason Code 
  pFldExist = HL7GetFld(mMsgExist, 4);
  pFldNew   = HL7GetFld(mMsgNew, 4);
  if ((!pFldExist && pFldNew) || (pFldExist && !pFldNew) || (pFldExist && pFldNew && strcmp(pFldExist, pFldNew)))
  {
    DIFF diff;
    diff.fldNum = 4;
    if (pFldExist)
      diff.existValue = pFldExist;
    else
      diff.existValue = "";
    if (pFldNew)
      diff.newValue = pFldNew;
    else
      diff.newValue = "";
    mDiff.insert (MDiff::value_type ("MSH", diff));
    mCount++;
  }

  // check for Event Occurred 
  pFldExist = HL7GetFld(mMsgExist, 6);
  pFldNew   = HL7GetFld(mMsgNew, 6);
  if ((!pFldExist && pFldNew) || (pFldExist && !pFldNew) || (pFldExist && pFldNew && strcmp(pFldExist, pFldNew)))
  {
    DIFF diff;
    diff.fldNum = 6;
    if (pFldExist)
      diff.existValue = pFldExist;
    else
      diff.existValue = "";
    if (pFldNew)
      diff.newValue = pFldNew;
    else
      diff.newValue = "";
    mDiff.insert (MDiff::value_type ("MSH", diff));
    mCount++;
  }
}

void
MHL7Compare::compareFields(const MString& segName)
{
  if (mLogLevel >= 3) {
    cout << segName << endl;
  }

  // assumes we are sitting on valid segments

  // first get the number of fields in both segments
  int nofExist = HL7GetNmbrOfFlds(mMsgExist);
  int nofNew = HL7GetNmbrOfFlds(mMsgNew);
 
  int fExist, fNew;

  // Each segment can have one or more '|' indicating empty trailing fields.  Their numbers
  // do not have to match for the segments to be considered the same.  We, therefore, need to
  // start from the last field
  if (nofExist != nofNew) {
    // find the last non-empty fields in segments of both the messages
    for (fExist = nofExist; fExist > 0; fExist--) {
      char *pFldExist = HL7GetFld(mMsgExist, fExist);
      if (pFldExist)
        break;
    }

    for (fNew = nofNew; fNew > 0; fNew--) {
      char *pFldNew = HL7GetFld(mMsgNew, fNew);
      if (pFldNew)
        break;
    }

    if (fExist != fNew) {
      DIFF diff;
      diff.fldNum = 0;
      diff.existValue = segName;
      diff.newValue = segName;
      diff.comment = "Different number of fields";
      mDiff.insert (MDiff::value_type (segName, diff));
      mCount++;
    }
  } else {
    fExist = nofExist;
    fNew   = nofNew;
  }

  if ( fExist && fNew ) {
    int nof = (fExist > fNew ? fExist : fNew);
    for (int f = 1; f <= nof; f++) {
      char *pFldExist, *pFldNew;

      if (f <= fExist)
	pFldExist = HL7GetFld(mMsgExist, f);
      else
	pFldExist = NULL;

      if (f <= fNew)
	pFldNew = HL7GetFld(mMsgNew, f);
      else
	pFldNew = NULL;

      if (pFldExist && pFldNew) {
	if (mLogLevel >= 3) {
	  cout	<< setw(3) << nof
		<< "<" << pFldExist << "> "
		<< "<" << pFldNew << ">"
		<< endl;
	}
	// if both fields look exactly the same, then no need for further analysis
	if (strcmp(pFldExist, pFldNew) != 0) {
	  if (!compareComponents(segName, pFldExist, pFldNew)) {
	    DIFF diff;
	    diff.fldNum = f;
	    diff.existValue = pFldExist;
	    diff.newValue = pFldNew;
	    diff.comment = "Different field values";
	    mDiff.insert (MDiff::value_type (segName, diff) );
	    mCount++;
	  }
	}
      } else {
	if ((!pFldExist && pFldNew) || (pFldExist && !pFldNew)) { // report the difference
	  DIFF diff;
	  diff.fldNum = f;
	  if (pFldExist)
	    diff.existValue = pFldExist;
	  else
	    diff.existValue = "";
	  if (pFldNew)
	    diff.newValue = pFldNew;
	  else
	    diff.newValue = "";
	  diff.comment = "Different number of fields";
	  mDiff.insert (MDiff::value_type (segName, diff) );
	  mCount++;
	} //endif
      } //endelse
    }
  } else  // no need to analyze any further if at least one of the segments is completely empty
    return;
}

int
MHL7Compare::compareComponents(const MString& segName, const MString& fldExist, const MString& fldNew)
{
  MString fld(fldExist);
  char *Exist = fld.strData();
  fld = fldNew;
  char *New = fld.strData();

  // position pointers at the last element of the fields
  char *pExist = &Exist[fldExist.size()-1]; 
  char *pNew = &New[fldNew.size()-1];

  // move to the last non empty component
  for (; pExist != Exist; pExist--)
    if (*pExist != '^')
      break;

  for (; pNew != New; pNew--)
    if (*pNew != '^')
      break;
  
  while ((pExist > Exist) && (pNew > New))
  {
    if (*pExist != *pNew)
      break;
    pExist--;
    pNew--;
  }

  if (*pExist != *pNew)
  {
    delete [] Exist;
    delete [] New;
    return 0;
  }
    
  delete [] Exist;
  delete [] New;
  return 1;
}

int
MHL7Compare::getFirstSegment(HL7MSG* mMsg, MString& segName)
{
  if (!mMsg)
    return 0;
  
  char *seg;

  int iResult = HL7FirstSegm(mMsg, &seg);
  if (iResult != HL7_OK)
  {
    cout << "HL7Compare: Cannot even find the first segment" << endl;
    cerr << HL7ErrTxt(mMsg, iResult) << endl;
    return 0;
  }

  segName = seg;
  return 1;
}

int
MHL7Compare::getNextSegment(HL7MSG* mMsg, MString& segName)
{
  if (!mMsg)
    return 0;
  
  char *seg;

  int iResult = HL7NextSegm(mMsg, &seg);
  if ((iResult != HL7_OK) && (iResult != HL7_END_OF_STRUCT))
  {
    cout << "HL7Compare: Cannot find the next segment after: " << segName << endl;
    cerr << HL7ErrTxt(mMsg, iResult) << endl;
    return 0;
  }

  if (iResult == HL7_END_OF_STRUCT)
    return 0;

  segName = seg;

  return 1;
}

int
MHL7Compare::findSegment(HL7MSG* mMsg, const MString& segName)
{
  if (!mMsg)
    return 0;

  if (!segName.size())
    return 0;
  
  char *seg = segName.strData();

  int iResult = HL7FindSegm(mMsg, seg);
  delete [] seg;
  if ((iResult != HL7_OK) && (iResult != HL7_END_OF_STRUCT))
  {
    cout << "HL7Compare: Cannot find the segment: " << segName << endl;
    cout << HL7ErrTxt(mMsg, iResult) << endl;
    return 0;
  }

  if (iResult == HL7_END_OF_STRUCT)
    return 0;

  return 1;
}

void
MHL7Compare::initializeFormat(const MString& fileName)
{
  // read the ini file and add segment/field information in the multimap
  // MSegmentInfo (mSegInfo)

  if (!fileName.size())
    return;

  char* fn = fileName.strData();
  ifstream f(fn);
  delete [] fn;

  char buf[1024];
  char *p;
  MString segName;

  memset(buf, 0, sizeof(buf));

  while (f.getline(buf, sizeof(buf)))
  {
    // ignore comments
    if ((buf[0] == '#') || (buf[0] == ' '))
      continue;

    p = buf;
    if (buf[0] == '[') //found a new section
    {
      // get segment name
      p++;
      char *tmp = strchr(p, ']');
      if (tmp != NULL)
      {
        *tmp = 0;
        segName = p;
        *tmp = ']';
      }
    } // endif
    else if (isdigit(buf[0]))
    {
      // get field specific information
      FIELD_INFO fldInfo;
      // get information on a particular field
      int  fldnum = -1, compnum = -1, subcompnum = -1;
      char num[1024];
      memset(num, 0, sizeof(num));
      int i = 0;
 //   while (*p != 0)
      while (1)
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

          if (*p == ';')
            break;
          if (*p == 0)
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

    // now that we have complete information about a particular field, we can insert
    if (segName.size())
      mSegInfo.insert (MSegmentInfo::value_type (segName, fldInfo) );

    //reinitialize FIELD_INFO struct
    fldInfo.fldNum = 0;
    fldInfo.compNum = 0;
    fldInfo.subCompNum = 0;
 
    memset(buf, 0, sizeof(buf));

    }  // endif
  }  //endwhile
  
  if (!f.eof())
    cout << "Could Not Read From File" << endl;
}

void
MHL7Compare::compareFieldValues(const MString& segment, int fldNum,
                                int compNum, int subCompNum)
{
  if (!segment.size())
    return;

  if (subCompNum) {
    // get the sub component

    MString existValue;
    char* pExist = HL7GetSub(mMsgExist, fldNum, 1, compNum, subCompNum);
    if (pExist)
      existValue = pExist;
    else
      existValue = "";

    MString newValue;
    char* pNew   = HL7GetSub(mMsgNew, fldNum, 1, compNum, subCompNum);
    if (pNew)
      newValue = pNew;
    else
      newValue = "";

    if (mLogLevel >= 3) {
      cout << segment << " " << setw(3) << fldNum << " "
	   << setw(3) << compNum << " " << setw(3) << subCompNum << " "
	   << "<" << existValue << "> "
	   << "<" << newValue << "> "
	   << endl;
    }

    if (existValue != newValue) {
      DIFF diff;
      diff.fldNum = fldNum;
      diff.existValue = existValue;
      diff.newValue = newValue;
      diff.comment = "Sub components do not match";
      mDiff.insert (MDiff::value_type (segment, diff) );
      mCount++;
    }
  } else if (compNum) {
    // get the component

    MString existValue;
    char* pExist = HL7GetComp(mMsgExist, fldNum, 1, compNum);
    if (pExist) {
      for (int i = strlen(pExist)-1; i >=0; i--) {
        if (pExist[i] == '\\')
          pExist[i] = 0;
        else
          break;
      }
      existValue = pExist;
    }
    else
      existValue = "";

    MString newValue;
    char* pNew   = HL7GetComp(mMsgNew, fldNum, 1, compNum);
    if (pNew) {
      for (int i = strlen(pNew)-1; i >=0; i--) {
        if (pNew[i] == '\\')
          pNew[i] = 0;
        else
          break;
      }
      newValue = pNew;
    } else {
      newValue = "";
    }

    if (mLogLevel >= 3) {
      cout << segment << " " << setw(3) << fldNum << " "
	   << setw(3) << compNum << " " << setw(3) << subCompNum << " "
	   << "<" << existValue << "> "
	   << "<" << newValue << "> "
	   << endl;
    }

    if (existValue != newValue) {
      DIFF diff;
      diff.fldNum = fldNum;
      diff.existValue = existValue;
      diff.newValue = newValue;
      diff.comment = "Components do not match";
      mDiff.insert (MDiff::value_type (segment, diff) );
      mCount++;
    }
  } else if (fldNum) {
    // get the entire field

    MString existValue;
    char* pExist = HL7GetFld(mMsgExist, fldNum);
    if (pExist) {
      for (int i = strlen(pExist)-1; i >=0; i--) {
        if (pExist[i] == '^' || pExist[i] == '\\')
          pExist[i] = 0;
        else
          break;
      }
      existValue = pExist;
    } else
      existValue = "";

    MString newValue;
    char* pNew   = HL7GetFld(mMsgNew, fldNum);
    if (pNew) {
      for (int i = strlen(pNew)-1; i >=0; i--) {
        if (pNew[i] == '^' || pNew[i] == '\\')
          pNew[i] = 0;
        else
          break;
      }
      newValue = pNew;
    } else {
      newValue = "";
    }

    if (mLogLevel >= 3) {
      cout << segment << " " << setw(3) << fldNum << " "
	   << setw(3) << compNum << " " << setw(3) << subCompNum << " "
	   << "<" << existValue << "> "
	   << "<" << newValue << "> "
	   << endl;
    }

    if (existValue != newValue) {
      DIFF diff;
      diff.fldNum = fldNum;
      diff.existValue = existValue;
      diff.newValue = newValue;
      diff.comment = "Fields do not match";
      mDiff.insert (MDiff::value_type (segment, diff) );
      mCount++;
    }
  } else {
    compareFields(segment);  // compare all the fields
  }
}



