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
#include "MDICOMWrapper.hpp"

static char rcsid[] = "$Id: MDICOMWrapper.cpp,v 1.40 2006/11/13 15:06:54 smm Exp $";

MDICOMWrapper::MDICOMWrapper()
{
  ::DCM_CreateObject(&mObj, 0);
  mAmOwner = true;
  mFileOptions = 0;
}

MDICOMWrapper::MDICOMWrapper(const MDICOMWrapper& cpy) :
  mObj(cpy.mObj),
  mAmOwner(false),
  mFileOptions(cpy.mFileOptions)
{
}

void
MDICOMWrapper::close()
{
  if (mAmOwner && (mObj != 0))
    ::DCM_CloseObject(&mObj);

  mAmOwner = false;
  mObj = 0;
}

MDICOMWrapper::~MDICOMWrapper()
{
  this->close();
}

void
MDICOMWrapper::printOn(ostream& s) const
{
  s << "MDICOMWrapper";
}

void
MDICOMWrapper::streamIn(istream& s)
{
  //s >> this->member;
}

// Non boiler-plate methods below

MDICOMWrapper::MDICOMWrapper(const MString& fileName,
			     unsigned long options)
{
  char fileString[1024];

  fileName.safeExport(fileString, sizeof(fileString));
  CONDITION cond;

  cond = ::DCM_OpenFile(fileString, options, &mObj);
  mFileOptions = options;

  if (cond != DCM_NORMAL) {
    mFileOptions = options | DCM_PART10FILE;
    ::COND_PopCondition(TRUE);
    cond = ::DCM_OpenFile(fileString, DCM_PART10FILE | DCM_ACCEPTVRMISMATCH, &mObj);
  }
  ::COND_PopCondition(TRUE);

#if 0
  if (cond != DCM_NORMAL) {
    ::COND_DumpConditions();
    ::exit(1);
  }
#endif

  mAmOwner = true;
}

int
MDICOMWrapper::open(const MString& fileName, unsigned long options)
{
  if (mAmOwner && (mObj != 0))
    ::DCM_CloseObject(&mObj);

  char fileString[1024];
  int rtnValue = 0;

  fileName.safeExport(fileString, sizeof(fileString));
  CONDITION cond;

  if (mAmOwner) {
    ::DCM_CloseObject(&mObj);
    (void)::COND_PopCondition(TRUE);
  }
  mFileOptions = options;
  cond = ::DCM_OpenFile(fileString, options | DCM_ACCEPTVRMISMATCH, &mObj);
  if (cond != DCM_NORMAL) {
    ::COND_PopCondition(TRUE);
    mFileOptions = options | DCM_PART10FILE;
    cond = ::DCM_OpenFile(fileString, DCM_PART10FILE | DCM_ACCEPTVRMISMATCH, &mObj);
  }
  if (cond != DCM_NORMAL) {
    ::COND_PopCondition(TRUE);
    rtnValue = -1;
    mAmOwner = false;
  } else {
    mAmOwner = true;
  }
  return rtnValue;
}

int
MDICOMWrapper::openTrySupportedFormats(const MString& fileName)
{
  U32 openFlags[] = {
	DCM_ORDERLITTLEENDIAN | DCM_ACCEPTVRMISMATCH,
	DCM_PART10FILE | DCM_ACCEPTVRMISMATCH,
	DCM_ORDERBIGENDIAN | DCM_ACCEPTVRMISMATCH
  };
  if (mAmOwner && (mObj != 0)) {
    mAmOwner = false;
    ::DCM_CloseObject(&mObj);
    mObj = 0;
  }

  char fileString[1024];
  int rtnValue = 0;

  fileName.safeExport(fileString, sizeof(fileString));
  CONDITION cond;

  (void)::COND_PopCondition(TRUE);

  int i = 0;
  cond = 0;
  for (i = 0; i < (int)DIM_OF(openFlags) && cond != DCM_NORMAL; i++) {
    cond = ::DCM_OpenFile(fileString, openFlags[i], &mObj);
    if (cond != DCM_NORMAL) {
      ::COND_PopCondition(TRUE);
    }
  }
  if (cond != DCM_NORMAL) {
    ::COND_PopCondition(TRUE);
    rtnValue = -1;
    mAmOwner = false;
    mObj = 0;
  } else {
    mAmOwner = true;
  }
  return rtnValue;
}

MDICOMWrapper::MDICOMWrapper(DCM_OBJECT* obj) :
  mObj(obj),
  mAmOwner(false)
{
}

int
MDICOMWrapper::saveAs(const MString& fileName,
		      unsigned long options)
{
  char* f = fileName.strData();

  ::DCM_WriteFile(&mObj, options, f);

  delete [] f;

  return 0;
}

MString
MDICOMWrapper::getString(DCM_TAG tag)
{
  char s[1024] = "";
  char s2[1024]= "";

  CONDITION cond;
  DCM_ELEMENT e;

  memset(&e, 0, sizeof(e));
  e.tag = tag;

  cond = ::DCM_LookupElement(&e);
  e.d.string = s;
  e.length = sizeof(s);

  cond = ::DCM_ParseObject(&mObj, &e, 1, 0, 0, 0);
  if (cond != DCM_NORMAL) {
    ::COND_PopCondition(TRUE);
    if (cond == DCM_ELEMENTNOTFOUND) {
     return MString("");
    }
  }
  switch (e.representation) {
  case DCM_US:
    sprintf(s2, "%d", *(e.d.us));
    strcpy(s, s2);
    break;
  case DCM_SS:
    sprintf(s2, "%d", *(e.d.ss));
    strcpy(s, s2);
    break;
  case DCM_FL:
    sprintf(s2, "%f", *(float*)(e.d.ot));
    strcpy(s, s2);
    break;
  default:
    break;
  }

  int i = 0;
  while (s[i] == ' ') {
    i++;
  }
  return MString(&s[i]);
}

MString
MDICOMWrapper::getString(DCM_TAG seqTag, DCM_TAG seqItem, int itemNumber)
 {
  CONDITION cond;

  LST_HEAD* l = 0;

  cond = ::DCM_GetSequenceList(&mObj, seqTag, &l);
  if (cond != DCM_NORMAL) {
    //::COND_DumpConditions();
    return "";
  }

  DCM_SEQUENCE_ITEM* item;
  item = (DCM_SEQUENCE_ITEM*)::LST_Head(&l);
  (void)::LST_Position(&l, item);

  for (int i = 1; i < itemNumber && item != 0; i++) {
    item = (DCM_SEQUENCE_ITEM*)::LST_Next(&l);
  }

  if (item == 0)
    return "";

  MDICOMWrapper w(item->object);

  MString s = w.getString(seqItem);
  return s;
}

MString
MDICOMWrapper::getSequenceString(DCM_TAG seqTag1, DCM_TAG seqTag2, DCM_TAG seqItem, int itemNumber)
{
  CONDITION cond;

  LST_HEAD* l = 0;

  cond = ::DCM_GetSequenceList(&mObj, seqTag1, &l);
  if (cond != DCM_NORMAL) {
    return "";
  }

  DCM_SEQUENCE_ITEM* item;
  item = (DCM_SEQUENCE_ITEM*)::LST_Head(&l);
  if (item == 0)
    return "";

  MDICOMWrapper w(item->object);
  return w.getString(seqTag2, seqItem, itemNumber);
}

MString
MDICOMWrapper::getSequenceString(DCM_TAG seqTag1, DCM_TAG seqTag2, DCM_TAG seqTag3, DCM_TAG seqItem, int itemNumber)
{
  CONDITION cond;

  LST_HEAD* l = 0;

  cond = ::DCM_GetSequenceList(&mObj, seqTag1, &l);
  if (cond != DCM_NORMAL) {
    return "";
  }

  DCM_SEQUENCE_ITEM* item;
  item = (DCM_SEQUENCE_ITEM*)::LST_Head(&l);
  if (item == 0)
    return "";

  MDICOMWrapper w(item->object);
  return w.getSequenceString(seqTag2, seqTag3, seqItem, itemNumber);
}

MStringVector
MDICOMWrapper::getStrings(DCM_TAG seqTag, DCM_TAG seqItem)
{
  CONDITION cond;
  MStringVector msv;

  LST_HEAD* l = 0;

  cond = ::DCM_GetSequenceList(&mObj, seqTag, &l);
  if (cond != DCM_NORMAL) {
    //::COND_DumpConditions();
    return msv;
  }

  DCM_SEQUENCE_ITEM* item;
  item = (DCM_SEQUENCE_ITEM*)::LST_Head(&l);
  (void)::LST_Position(&l, item);

  MString s;
  while( item != 0) {
    MDICOMWrapper w(item->object);
    s = w.getString(seqItem);
    msv.push_back(s);
    item = (DCM_SEQUENCE_ITEM*)::LST_Next(&l);
  }

  return msv;
}

U16
MDICOMWrapper::getU16(DCM_TAG tag)
{
  U16 v = 0;

  CONDITION cond;
  DCM_ELEMENT e;

  memset(&e, 0, sizeof(e));
  e.tag = tag;

  cond = ::DCM_LookupElement(&e);
  if (DCM_IsString(e.representation)) {
    MString s = this->getString(tag);
    v = (U16)s.intData();
  } else {
    e.d.us = &v;
    e.length = sizeof(v);

    cond = ::DCM_ParseObject(&mObj, &e, 1, 0, 0, 0);
    if (cond != DCM_NORMAL) {
      ::COND_PopCondition(TRUE);
    }
  }

  return v;
}

U32
MDICOMWrapper::getU32(DCM_TAG tag)
{
  U32 v = 0;

  CONDITION cond;
  DCM_ELEMENT e;

  memset(&e, 0, sizeof(e));
  e.tag = tag;

  cond = ::DCM_LookupElement(&e);
  e.d.ul = &v;
  e.length = sizeof(v);

  cond = ::DCM_ParseObject(&mObj, &e, 1, 0, 0, 0);
  if (cond != DCM_NORMAL) {
    ::COND_PopCondition(TRUE);
  }

  return v;
}

int
MDICOMWrapper::getVector(int& vectorLength, U16*& v, DCM_TAG tag)
{
  CONDITION cond;
  DCM_ELEMENT e;

  vectorLength = 0;
  v = 0;

  U32 byteCount = 0;
  cond = ::DCM_GetElementSize(&mObj, tag, &byteCount);
  if (cond != DCM_NORMAL) {
    ::COND_PopCondition(TRUE);
    return 1;
  }

  memset(&e, 0, sizeof(e));
  e.tag = tag;

  v = new U16[byteCount/2];
  cond = ::DCM_LookupElement(&e);
  e.d.us = v;
  e.length = byteCount;

  cond = ::DCM_ParseObject(&mObj, &e, 1, 0, 0, 0);
  if (cond != DCM_NORMAL) {
    ::COND_PopCondition(TRUE);
    return 1;
  }
  vectorLength = byteCount/2;
  return 0;
}



int
MDICOMWrapper::numberOfItems(DCM_TAG seqTag)
{
  CONDITION cond;

  LST_HEAD* l = 0;

  cond = ::DCM_GetSequenceList(&mObj, seqTag, &l);
  if (cond != DCM_NORMAL) {
    //::COND_DumpConditions();
    return 0;
  }

  DCM_SEQUENCE_ITEM* item;
  item = (DCM_SEQUENCE_ITEM*)::LST_Head(&l);
  (void)::LST_Position(&l, item);

  return (int) LST_Count( &l);
}


int
MDICOMWrapper::attributePresent(DCM_TAG tag)
{
  DCM_ELEMENT e;
  memset(&e, 0, sizeof(e));

  CONDITION cond;

  cond = ::DCM_GetElement(&mObj, tag, &e);
  if (cond == DCM_NORMAL) {
    return 1;
  } else {
    ::COND_PopCondition(TRUE);
    return 0;
  }
}

int
MDICOMWrapper::attributePresent(DCM_TAG tagSequence, DCM_TAG tag)
{
  DCM_ELEMENT e;
  memset(&e, 0, sizeof(e));

  CONDITION cond;

  // First run the negative test. If the sequence tag is not
  // present, then we konw the attribute itself is not present.
  cond = ::DCM_GetElement(&mObj, tagSequence, &e);
  if (cond != DCM_NORMAL) {
    return 0;
  }
  LST_HEAD* l = 0;

  cond = ::DCM_GetSequenceList(&mObj, tagSequence, &l);
  if (cond != DCM_NORMAL) {		// Test for this, but it should not happen
    ::COND_PopCondition(TRUE);
    return 0;
  }

  DCM_SEQUENCE_ITEM* item;
  item = (DCM_SEQUENCE_ITEM*)::LST_Head(&l);

  if (item == 0) {
    return 0;
  }

  MDICOMWrapper w(item->object);
  return w.attributePresent(tag);
}

int
MDICOMWrapper::attributePresent(DCM_TAG tagSequence1,
	DCM_TAG tagSequence0, DCM_TAG tag)
{
  DCM_ELEMENT e;
  memset(&e, 0, sizeof(e));

  CONDITION cond;

  // First run the negative test. If the sequence tag is not
  // present, then we konw the attribute itself is not present.
  cond = ::DCM_GetElement(&mObj, tagSequence1, &e);
  if (cond != DCM_NORMAL) {
    return 0;
  }
  LST_HEAD* l = 0;

  cond = ::DCM_GetSequenceList(&mObj, tagSequence1, &l);
  if (cond != DCM_NORMAL) {		// Test for this, but it should not happen
    ::COND_PopCondition(TRUE);
    return 0;
  }

  DCM_SEQUENCE_ITEM* item;
  item = (DCM_SEQUENCE_ITEM*)::LST_Head(&l);

  if (item == 0) {
    return 0;
  }

  MDICOMWrapper w(item->object);
  return w.attributePresent(tagSequence0, tag);
}

int
MDICOMWrapper::groupPresent(U16 group)
{
  if (DCM_GroupPresent(&mObj, group) == TRUE)
    return 1;

  return 0;
}

int
MDICOMWrapper::setString(DCM_TAG tag, const MString& value)
{
  DCM_ELEMENT e;
  memset(&e, 0, sizeof(e));
  U16 u16;
  U32 u32;
  S16 s16;
  S32 s32;

  e.tag = tag;
  ::DCM_LookupElement(&e);
  char* s = value.strData();

  if (e.representation == DCM_US) {
    u16 = atoi(s);
    e.d.us = &u16;
    e.length = sizeof(u16);
  } else if (e.representation == DCM_UL) {
    u32 = atoi(s);
    e.d.ul = &u32;
    e.length = sizeof(u32);
  } else if (e.representation == DCM_SS) {
    s16 = atoi(s);
    e.d.ss = &s16;
    e.length = sizeof(s16);
  } else if (e.representation == DCM_SL) {
    s32 = atoi(s);
    e.d.sl = &s32;
    e.length = sizeof(s32);
  } else {
    e.d.string = s;
    e.length = strlen(s);
  }

  CONDITION cond = ::DCM_ModifyElements(&mObj, &e, 1, 0, 0, 0);
  if (cond != DCM_NORMAL) {
    ::COND_DumpConditions();
    exit(1);
  }

  delete []s;

  return 0;
}

int
MDICOMWrapper::setString(DCM_TAG tag, const MString& value, const MString& vr)
{
  DCM_ELEMENT e;
  memset(&e, 0, sizeof(e));
  U16 u16;
  U32 u32;
  S16 s16;
  S32 s32;

  e.tag = tag;
  ::DCM_LookupElement(&e);
  char* s = value.strData();
  if (vr == "LO") {
    e.representation = DCM_LO;
  }

  if (e.representation == DCM_US) {
    u16 = atoi(s);
    e.d.us = &u16;
    e.length = sizeof(u16);
  } else if (e.representation == DCM_UL) {
    u32 = atoi(s);
    e.d.ul = &u32;
    e.length = sizeof(u32);
  } else if (e.representation == DCM_SS) {
    s16 = atoi(s);
    e.d.ss = &s16;
    e.length = sizeof(s16);
  } else if (e.representation == DCM_SL) {
    s32 = atoi(s);
    e.d.sl = &s32;
    e.length = sizeof(s32);
  } else {
    e.d.string = s;
    e.length = strlen(s);
  }

  CONDITION cond = ::DCM_ModifyElements(&mObj, &e, 1, 0, 0, 0);
  if (cond != DCM_NORMAL) {
    ::COND_DumpConditions();
    exit(1);
  }

  delete []s;

  return 0;
}

int
MDICOMWrapper::setString(DCM_TAG seqTag, DCM_TAG tag,
			 const MString& value, int index)
{
  LST_HEAD* l1 = 0;
  CONDITION cond;

  cond = ::DCM_GetSequenceList(&mObj, seqTag, &l1);
  if (cond != DCM_NORMAL) {
    ::COND_PopCondition(TRUE);

    l1 = ::LST_Create();
    DCM_ELEMENT e = {seqTag, DCM_SQ, "", 1, 0, 0 };
    e.d.sq = l1;

    DCM_SEQUENCE_ITEM* item = (DCM_SEQUENCE_ITEM*)malloc(sizeof(*item));
    ::DCM_CreateObject(&(item->object), 0);
    ::LST_Enqueue(&l1, item);

    cond = ::DCM_AddSequenceElement(&mObj, &e);
    if (cond != DCM_NORMAL) {
      ::COND_DumpConditions();
      exit(1);
    }
  }

  DCM_SEQUENCE_ITEM* item1 = 0;
  if (index != 0) {
    item1 = (DCM_SEQUENCE_ITEM*) ::LST_Head(&l1);
    (void) ::LST_Position(&l1, item1);

    while(index-- > 1) {
      item1 = (DCM_SEQUENCE_ITEM*) ::LST_Next(&l1);
    }
  }

  if (item1 == 0) {
    item1 = (DCM_SEQUENCE_ITEM*)malloc(sizeof(*item1));
    ::DCM_CreateObject(&(item1->object), 0);
    ::LST_Enqueue(&l1, item1);
  }

  MDICOMWrapper w (item1->object);
  w.setString(tag, value);

  return 0;
}

int
MDICOMWrapper::setString(DCM_TAG seqTag1, DCM_TAG seqTag2, DCM_TAG tag,
			 const MString& value, int index)
{
  LST_HEAD* l1 = 0;
  CONDITION cond;

  cond = ::DCM_GetSequenceList(&mObj, seqTag1, &l1);
  if (cond != DCM_NORMAL) {
    ::COND_PopCondition(TRUE);

    l1 = ::LST_Create();
    DCM_ELEMENT e = {seqTag1, DCM_SQ, "", 1, 0, 0 };
    e.d.sq = l1;

    DCM_SEQUENCE_ITEM* item = (DCM_SEQUENCE_ITEM*)malloc(sizeof(*item));
    ::DCM_CreateObject(&(item->object), 0);
    ::LST_Enqueue(&l1, item);

    cond = ::DCM_AddSequenceElement(&mObj, &e);
    if (cond != DCM_NORMAL) {
      ::COND_DumpConditions();
      exit(1);
    }
  }
  DCM_SEQUENCE_ITEM* item1 = 0;
  item1 = (DCM_SEQUENCE_ITEM*) ::LST_Head(&l1);

  MDICOMWrapper w(item1->object);
  return w.setString(seqTag2, tag, value, index);

/*
  DCM_SEQUENCE_ITEM* item1 = 0;
  if (index != 0) {
    item1 = (DCM_SEQUENCE_ITEM*) ::LST_Head(&l1);
    (void) ::LST_Position(&l1, item1);

    while(index-- > 1) {
      item1 = (DCM_SEQUENCE_ITEM*) ::LST_Next(&l1);
    }
  }

  if (item1 == 0) {
    item1 = (DCM_SEQUENCE_ITEM*)malloc(sizeof(*item1));
    ::DCM_CreateObject(&(item1->object), 0);
    ::LST_Enqueue(&l1, item1);
  }

  MDICOMWrapper w (item1->object);
  w.setString(tag, value);
*/

  return 0;
}

int
MDICOMWrapper::setSequenceString(DCM_TAG seqTag1, DCM_TAG seqTag2, DCM_TAG seqTag3,
	DCM_TAG tag, const MString& value, int index)
{
  LST_HEAD* l1 = 0;
  CONDITION cond;

  cond = ::DCM_GetSequenceList(&mObj, seqTag1, &l1);
  if (cond != DCM_NORMAL) {
    ::COND_PopCondition(TRUE);

    l1 = ::LST_Create();
    DCM_ELEMENT e = {seqTag1, DCM_SQ, "", 1, 0, 0 };
    e.d.sq = l1;

    DCM_SEQUENCE_ITEM* item = (DCM_SEQUENCE_ITEM*)malloc(sizeof(*item));
    ::DCM_CreateObject(&(item->object), 0);
    ::LST_Enqueue(&l1, item);

    cond = ::DCM_AddSequenceElement(&mObj, &e);
    if (cond != DCM_NORMAL) {
      ::COND_DumpConditions();
      exit(1);
    }
  }
  DCM_SEQUENCE_ITEM* item1 = 0;
  item1 = (DCM_SEQUENCE_ITEM*) ::LST_Head(&l1);

  MDICOMWrapper w(item1->object);
  return w.setString(seqTag2, seqTag3, tag, value, index);
}


int
MDICOMWrapper::setNumeric(DCM_TAG tag, int value)
{
  DCM_ELEMENT e;
  memset(&e, 0, sizeof(e));

  e.tag = tag;
  ::DCM_LookupElement(&e);
  void *p;
  U16 u16 = 0;
  S16 s16 = 0;
  U32 u32 = 0;
  S32 s32 = 0;

  switch(e.representation) {
    case DCM_US:
      u16 = value;
      p = &u16;
      e.length = 2;
      break;
    case DCM_SS:
      s16 = value;
      p = &s16;
      e.length = 2;
      break;
    case DCM_UL:
      u32 = value;
      p = &u32;
      e.length = 4;
      break;
    case DCM_SL:
      s32 = value;
      p = &s32;
      e.length = 4;
      break;
    default:
      printf("Could not set numeric for %08x\n", tag);
      ::exit(1);
      break;
  }
  e.d.ot = p;

  CONDITION cond = ::DCM_ModifyElements(&mObj, &e, 1, 0, 0, 0);
  if (cond != DCM_NORMAL) {
    ::COND_DumpConditions();
    exit(1);
  }

  return 0;
}

int
MDICOMWrapper::createSequence(DCM_TAG tag)
{
  LST_HEAD* l1 = 0;
  CONDITION cond;

  cond = ::DCM_GetSequenceList(&mObj, tag, &l1);
  if (cond != DCM_NORMAL) {
    ::COND_PopCondition(TRUE);

    l1 = ::LST_Create();
    DCM_ELEMENT e = {tag, DCM_SQ, "", 1, 0, 0 };
    e.d.sq = l1;

    cond = ::DCM_AddSequenceElement(&mObj, &e);
    if (cond != DCM_NORMAL) {
      ::COND_DumpConditions();
      exit(1);
    }
  }

  return 0;
}

DCM_OBJECT*
MDICOMWrapper::getNativeObject()
{
  return mObj;
}

MDICOMWrapper*
MDICOMWrapper::getSequenceWrapper(DCM_TAG tag, int index)
{
  CONDITION cond;

  LST_HEAD* l = 0;

  cond = ::DCM_GetSequenceList(&mObj, tag, &l);
  if (cond != DCM_NORMAL) {
    ::COND_PopCondition(TRUE);
    return 0;
  }

  DCM_SEQUENCE_ITEM* item;
  item = (DCM_SEQUENCE_ITEM*)::LST_Head(&l);
  (void)::LST_Position(&l, item);

  for (int i = 1; i < index && item != 0; i++) {
    item = (DCM_SEQUENCE_ITEM*)::LST_Next(&l);
  }

  if (item == 0)
    return 0;

  DCM_OBJECT* copyOfObject;

  cond = ::DCM_CopyObject(&item->object, &copyOfObject);
  MDICOMWrapper* w = new MDICOMWrapper(copyOfObject);
  if (w != 0)
    w->mAmOwner = true;

  return w;
}

MDICOMWrapper*
MDICOMWrapper::getSequenceWrapperOriginal(DCM_TAG tag, int index)
{
  CONDITION cond;

  LST_HEAD* l = 0;

  cond = ::DCM_GetSequenceList(&mObj, tag, &l);
  if (cond != DCM_NORMAL) {
    ::COND_PopCondition(TRUE);
    return 0;
  }

  DCM_SEQUENCE_ITEM* item;
  item = (DCM_SEQUENCE_ITEM*)::LST_Head(&l);
  (void)::LST_Position(&l, item);

  for (int i = 1; i < index && item != 0; i++) {
    item = (DCM_SEQUENCE_ITEM*)::LST_Next(&l);
  }

  if (item == 0)
    return 0;

  MDICOMWrapper* w = new MDICOMWrapper(item->object);

  return w;
}


/*
 * The element needs to be created but no values have to be filled in.
 * The buffer must likewise be created and the size passed as bufSize.  The
 * tag must be given.  All elements will be filled in for the element e.
 * This does not work for sequence elements...
 */
CONDITION MDICOMWrapper::getElement(DCM_TAG tag, DCM_ELEMENT* e, void *buffer, int bufSize) {
  CONDITION cond;
  e->tag = tag;

  cond = ::DCM_LookupElement(e);
  if (cond != DCM_NORMAL)
      return cond;
  e->d.ot = buffer;
  e->length = bufSize;

  cond = DCM_ParseObject(&mObj, e, 1, NULL, 0, NULL);
  return cond;
}

CONDITION MDICOMWrapper::getElements(
        CONDITION(*callback) (const DCM_ELEMENT* e, void* ctx), void* ctx) {

  return ::DCM_ScanParseObject(&mObj, 0, 0, 0, 0, callback, ctx);
}

typedef struct {
  MLogClient* client;
  MLogClient::LOGLEVEL level;
} LOG_CALLBACK_STRUCT;

static CONDITION logCallback(const DCM_ELEMENT* e, void* ctx)
{
  LOG_CALLBACK_STRUCT* s = (LOG_CALLBACK_STRUCT*)ctx;

  if (::DCM_IsString(e->representation)) {
    char* s1 = new char[e->length+1];
    strncpy(s1, e->d.string, e->length);
    s1[e->length] = '\0';

    char* s2 = new char[100 + e->length];
    ::sprintf(s2, "%04x %04x %s",
	      DCM_TAG_GROUP(e->tag),
	      DCM_TAG_ELEMENT(e->tag),
	      s1);

    (*s->client).log(s->level, s2);
    delete [] s1;
    delete [] s2;
  }

  return DCM_NORMAL;
}

void
MDICOMWrapper::log(MLogClient client, MLogClient::LOGLEVEL level)
{
  if (mObj == 0)
    return;

  LOG_CALLBACK_STRUCT s = { &client, level };

  ::DCM_ScanParseObject(&mObj, 0, 0, 0, 0, logCallback, &s);
}

int
MDICOMWrapper::importAttributes(MDICOMWrapper& w, const DCM_TAG* t)
{
  while (*t != 0) {
    MString s = w.getString(*t);
    this->setString(*t, s);

    t++;
  }

  return 0;
}

int
MDICOMWrapper::removeGroup(U16 group)
{
  if (mObj == 0)
    return -1;

  CONDITION cond;

  cond = ::DCM_RemoveGroup(&mObj, group);
  if ((cond == DCM_NORMAL) || (cond == DCM_GROUPNOTFOUND)) {
    (void) ::COND_PopCondition(TRUE);
    return 0;
  }

  (void) ::COND_PopCondition(TRUE);
  return -1;
}

int
MDICOMWrapper::removePrivateGroups()
{
  if (mObj == 0)
    return -1;

  CONDITION cond;

  cond = ::DCM_StripOddGroups(&mObj);
  if ((cond == DCM_NORMAL) || (cond == DCM_GROUPNOTFOUND)) {
    (void) ::COND_PopCondition(TRUE);
    return 0;
  }

  (void) ::COND_PopCondition(TRUE);
  return -1;
}


int
MDICOMWrapper::removeElement(DCM_TAG tag)
{
  if (mObj == 0)
    return -1;

  CONDITION cond;

  cond = ::DCM_RemoveElement(&mObj, tag);
  if ((cond == DCM_NORMAL) || (cond == DCM_ELEMENTNOTFOUND)) {
    (void) ::COND_PopCondition(TRUE);
    return 0;
  }

  (void) ::COND_PopCondition(TRUE);
  return -1;
}

bool MDICOMWrapper::isSequence(DCM_TAG tag)
{
  int x;
  bool isSequence = false;

  x = ::DCM_IsSequence(tag);
  if (x == 1) {
    isSequence = true;
  }
  return isSequence;
}

unsigned long MDICOMWrapper::getFileOptions() const
{
  return mFileOptions;
}
