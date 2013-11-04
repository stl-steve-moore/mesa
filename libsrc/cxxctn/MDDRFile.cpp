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
#pragma implementation "MDDRFile.hpp"
#include "MDDRFile.hpp"
#include "MLogClient.hpp"


static char rcsid[] = "$Id: MDDRFile.cpp,v 1.4 2004/09/29 22:20:07 smm Exp $";

MDDRFile::MDDRFile() :
  mDICOMWrapper(0),
  mPatientList(0)
{
}

MDDRFile::MDDRFile(const MDDRFile& cpy)
{
}

MDDRFile::~MDDRFile()
{
}


void
MDDRFile::printOn(ostream& s) const
{
  s << "MDDRFile";
}

void
MDDRFile::streamIn(istream& s)
{
  //s >> this->member;
}

// Non boiler-plate methods below

int
MDDRFile::open(const MString& path)
{
  mDICOMWrapper = new MDICOMWrapper();
  int status = mDICOMWrapper->open(path, DCM_PART10FILE);
  return status;
}

int
MDDRFile::getPatientCount()
{
  MLogClient logClient;
  if (mDICOMWrapper == 0) {
    return -1;
  }

  CONDITION cond;
  if (mPatientList == 0) {
    mPatientList = ::LST_Create();
    DCM_OBJECT* obj = mDICOMWrapper->getNativeObject();
    cond = ::DDR_GetPatientList(&obj, &mPatientList);
    if (cond != DDR_NORMAL) {
      logClient.log(MLogClient::MLOG_ERROR, "Unable to get Patient List from DICOM object");
      logClient. logCTNErrorStack(MLogClient::MLOG_ERROR, "");
      return -1;
    }
  }
  int count = ::LST_Count(&mPatientList);
  return count;
}

int
MDDRFile::getPatientRecord(int idx, DDR_PATIENT* patient)
{
  int count = this->getPatientCount();
  if (count <= 0) {
    return 1;
  }

  int i = 0;
  LST_NODE* n = ::LST_Head(&mPatientList);
  ::LST_Position(&mPatientList, n);
  for (i = 0; i < idx; i++) {
    n = ::LST_Next(&mPatientList);
  }
  DDR_PATIENT* p = (DDR_PATIENT*)n;
  *patient = *p;
  return 0;
}

int
MDDRFile::getStudyCount(const char* patientID)
{
  if (mDICOMWrapper == 0) {
    return -1;
  }
  CONDITION cond;
  LST_HEAD* studyList = 0;
  studyList = ::LST_Create();

  DCM_OBJECT* obj = mDICOMWrapper->getNativeObject();
  cond = ::DDR_GetStudyList(&obj, patientID, &studyList);
  if (cond != DDR_NORMAL) {
    return -1;
  }
  int count = ::LST_Count(&studyList);

  LST_NODE* n;
  while ((n = ::LST_Dequeue(&studyList)) != 0) {
    CTN_FREE(n);
  }
  ::LST_Destroy(&studyList);
  return count;
}

int
MDDRFile::getStudyCount(U32 offset)
{
  if (mDICOMWrapper == 0) {
    return -1;
  }
  CONDITION cond;
  DCM_OBJECT* studyObject = 0;

  DCM_OBJECT* obj = mDICOMWrapper->getNativeObject();
  int count = 0;
  while (offset != 0) {
    cond = ::DCM_GetSequenceByOffset(&obj, DCM_DIRRECORDSEQUENCE,
		    offset, &studyObject);
    if (cond != DCM_NORMAL) {
      return -1;
      // repair
      //::exit(1);
    }
    MDICOMWrapper w(studyObject);
    offset = w.getU32(DCM_DIRNEXTRECORDOFFSET);
    count++;
  }

  return count;
}

MDICOMWrapper*
MDDRFile::getStudyRecord(int idx, U32 offset)
{
  if (mDICOMWrapper == 0) {
    return 0;
  }
  CONDITION cond;
  DCM_OBJECT* studyObject = 0;

  DCM_OBJECT* obj = mDICOMWrapper->getNativeObject();
  int count = 0;
  MDICOMWrapper* rtnWrapper = 0;
  while (offset != 0 && idx-- >= 0) {
    cond = ::DCM_GetSequenceByOffset(&obj, DCM_DIRRECORDSEQUENCE,
		    offset, &studyObject);
    if (cond != DCM_NORMAL) {
      return 0;
    }
    MDICOMWrapper w(studyObject);
    offset = w.getU32(DCM_DIRNEXTRECORDOFFSET);
  }
  rtnWrapper = new MDICOMWrapper(studyObject);

  return rtnWrapper;
}

int
MDDRFile::getSeriesCount(U32 offset)
{
  if (mDICOMWrapper == 0) {
    return -1;
  }
  CONDITION cond;
  DCM_OBJECT* seriesObject = 0;

  DCM_OBJECT* obj = mDICOMWrapper->getNativeObject();
  int count = 0;
  while (offset != 0) {
    cond = ::DCM_GetSequenceByOffset(&obj, DCM_DIRRECORDSEQUENCE,
		    offset, &seriesObject);
    if (cond != DCM_NORMAL) {
      return -1;
      // repair
      //::exit(1);
    }
    MDICOMWrapper w(seriesObject);
    offset = w.getU32(DCM_DIRNEXTRECORDOFFSET);
    count++;
  }

  return count;
}

MDICOMWrapper*
MDDRFile::getSeriesRecord(int idx, U32 offset)
{
  if (mDICOMWrapper == 0) {
    return 0;
  }
  CONDITION cond;
  DCM_OBJECT* seriesObject = 0;

  DCM_OBJECT* obj = mDICOMWrapper->getNativeObject();
  int count = 0;
  MDICOMWrapper* rtnWrapper = 0;
  while (offset != 0 && idx-- >= 0) {
    cond = ::DCM_GetSequenceByOffset(&obj, DCM_DIRRECORDSEQUENCE,
		    offset, &seriesObject);
    if (cond != DCM_NORMAL) {
      return 0;
    }
    MDICOMWrapper w(seriesObject);
    offset = w.getU32(DCM_DIRNEXTRECORDOFFSET);
  }
  rtnWrapper = new MDICOMWrapper(seriesObject);

  return rtnWrapper;
}

int
MDDRFile::getLeafCount(U32 offset)
{
  if (mDICOMWrapper == 0) {
    return -1;
  }
  CONDITION cond;
  DCM_OBJECT* leafObject = 0;

  DCM_OBJECT* obj = mDICOMWrapper->getNativeObject();
  int count = 0;
  while (offset != 0) {
    cond = ::DCM_GetSequenceByOffset(&obj, DCM_DIRRECORDSEQUENCE,
		    offset, &leafObject);
    if (cond != DCM_NORMAL) {
      return -1;
      // repair
      //::exit(1);
    }
    MDICOMWrapper w(leafObject);
    offset = w.getU32(DCM_DIRNEXTRECORDOFFSET);
    count++;
  }

  return count;
}

MDICOMWrapper*
MDDRFile::getLeafRecord(int idx, U32 offset)
{
  if (mDICOMWrapper == 0) {
    return 0;
  }
  CONDITION cond;
  DCM_OBJECT* leafObject = 0;

  DCM_OBJECT* obj = mDICOMWrapper->getNativeObject();
  int count = 0;
  MDICOMWrapper* rtnWrapper = 0;
  while (offset != 0 && idx-- >= 0) {
    cond = ::DCM_GetSequenceByOffset(&obj, DCM_DIRRECORDSEQUENCE,
		    offset, &leafObject);
    if (cond != DCM_NORMAL) {
      return 0;
    }
    MDICOMWrapper w(leafObject);
    offset = w.getU32(DCM_DIRNEXTRECORDOFFSET);
  }
  rtnWrapper = new MDICOMWrapper(leafObject);

  return rtnWrapper;
}


//int
//MDDRFile::getFileSetID(DDR_FILESETID* fileSetID)
//{
//  return 0;
//}


