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
#include "MPPSAssistant.hpp"
#include "MDICOMWrapper.hpp"
#include "MLogClient.hpp"

static char rcsid[] = "$Id: MPPSAssistant.cpp,v 1.16 2006/07/14 18:49:30 smm Exp $";

MPPSAssistant::MPPSAssistant() :
 mIncludePerformedProtocolCodes(true)
{
}

MPPSAssistant::MPPSAssistant(const MPPSAssistant& cpy) :
 mIncludePerformedProtocolCodes(cpy.mIncludePerformedProtocolCodes)
{
}

MPPSAssistant::~MPPSAssistant()
{
}

void
MPPSAssistant::printOn(ostream& s) const
{
  s << "MPPSAssistant";
}

void
MPPSAssistant::streamIn(istream& s)
{
  //s >> this->member;
}

// Non boiler-plate methods to follow

int
MPPSAssistant::validateNCreateDataSet(MDICOMWrapper& dataSet)
{
  return 0;
}

int
MPPSAssistant::validateNSetDataSet(const MString& mppsObjectPath,
				   const MString& dataSetPath)
{
  return 0;
}

int
MPPSAssistant::mergeNSetDataSet(const MString& mppsObjectPath,
				const MString& dataSetPath)
{
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_VERBOSE, "",
		  "MPPSAssistant::mergeNSetDataSet",
		  __LINE__,
		  "Enter method");

  char f1[1024];
  mppsObjectPath.safeExport(f1, sizeof(f1));

  DCM_OBJECT* obj = 0;
  CONDITION cond = ::DCM_OpenFile(f1, DCM_ORDERLITTLEENDIAN, &obj);
  if (cond != DCM_NORMAL) {
    ::COND_DumpConditions();
    logClient.logTimeStamp(MLogClient::MLOG_ERROR,
		    MString("MPPSAssistant::mergeNSetDataSet unable to open file") +
		    mppsObjectPath);
    return -1;
  }

  MDICOMWrapper mppsWrapper(obj);

  DCM_TAG simpleTags[] = {
    DCM_PRCPPSSTATUS,
    0x00404002,		// GPPPS Status
    DCM_PRCPPSDESCRIPTION,
    DCM_PRCPPTYPEDESCRIPTION,
    DCM_PRCPPSENDDATE,
    DCM_PRCPPSENDTIME,
    0
  };
  DCM_TAG sequenceTags[] = {
    DCM_IDPROCEDURECODESEQUENCE,
    //DCM_PRCPERFORMEDAISEQUENCE,
    DCM_PRCPERFORMEDSERIESSEQ,
    0x00400320,		// Billing Procedure Step Sequence
    0x00400321,		// Film Consumption Sequence
    0x00400324,		// Billing Supplies and Devices Sequence
    0x00404031,		// Requested Subsequence Workitem Code Sequence
    0x00404032,		// Non-DICOM Output Code Sequence
    0x00400281,		// PPS Discontinuation Reason
    0
  };
  DCM_TAG sequenceTagsPerformedProtocolCodeItems[] = {
    DCM_PRCPERFORMEDAISEQUENCE,
    0
  };

  char f2[1024];
  dataSetPath.safeExport(f2, sizeof(f2));
  DCM_OBJECT* dataSetObj = 0;
  cond = ::DCM_OpenFile(f2, DCM_ORDERLITTLEENDIAN, &dataSetObj);
  if (cond != DCM_NORMAL) {
    ::COND_DumpConditions();
    logClient.logTimeStamp(MLogClient::MLOG_ERROR,
		    MString("MPPSAssistant::mergeNSetDataSet unable to open file") +
		    dataSetPath);
    return -1;
  }
  MDICOMWrapper dataSet(dataSetObj);

  this->mergeSimpleTags(simpleTags, mppsWrapper, dataSet);
  this->mergeSequences(sequenceTags, mppsWrapper, dataSet);
  if (mIncludePerformedProtocolCodes) {
    this->mergeSequences(sequenceTagsPerformedProtocolCodeItems, mppsWrapper, dataSet);
  }

  DCM_OBJECT* finalObject = 0;

  ::DCM_CopyObject(&obj, &finalObject);
  ::DCM_CloseObject(&obj);
  ::DCM_WriteFile(&finalObject, DCM_ORDERLITTLEENDIAN, f1);
  ::DCM_CloseObject(&dataSetObj);
  ::DCM_CloseObject(&finalObject);

  logClient.log(MLogClient::MLOG_VERBOSE, "",
		  "MPPSAssistant::mergeNSetDataSet",
		  __LINE__,
		  "Exit method");
  return 0;
}

typedef struct {
  DCM_TAG t1;
  DCM_TAG t2;
} SEQUENCE_TAG;

int
MPPSAssistant::mergeMWLPPSRelationship(MDICOMWrapper& mwl,
				       MDICOMWrapper& wrapper,
				       const MString& studyInstanceUID,
				       bool groupCaseFlag)
{
  LST_HEAD* ssaSequenceList = 0;

  // Find out if the Scheduled Step Attribute Sequence exists.
  // If it exists, use the LST_HEAD from that attribute.  If it
  // does not exist, create a new list and add it to the wrapper/object.

  DCM_OBJECT* nativeObject = wrapper.getNativeObject();

  CONDITION cond = ::DCM_GetSequenceList(&nativeObject,
					 DCM_PRCSCHEDSTEPATTRSEQ,
					 &ssaSequenceList);
  if (cond != DCM_NORMAL) {
    ::COND_PopCondition(TRUE);
    DCM_ELEMENT e = {DCM_PRCSCHEDSTEPATTRSEQ, DCM_SQ, "", 1, 0, 0};

    ssaSequenceList = ::LST_Create();
    e.d.sq = ssaSequenceList;

    cond = ::DCM_AddSequenceElement(&nativeObject, &e);
    if (cond != DCM_NORMAL) {
      ::COND_DumpConditions();
      exit(1);
    }
  }

  DCM_SEQUENCE_ITEM* item = (DCM_SEQUENCE_ITEM*)malloc(sizeof(*item));

  DCM_CreateObject(&(item->object), 0);
  MDICOMWrapper sequenceItemWrapper(item->object);

  DCM_TAG v0[] = {
    DCM_RELSTUDYINSTANCEUID,
    DCM_IDACCESSIONNUMBER,
    DCM_PRCREQUESTEDPROCEDUREID,
    DCM_SDYREQUESTEDPRODESCRIPTION,
    //DCM_PRCSCHEDULEDPROCSTEPID,
    //DCM_PRCSCHEDULEDPROCSTEPDESCRIPTION,
    0
  };

  SEQUENCE_TAG v1[] = {
    { DCM_PRCSCHEDULEDPROCSTEPSEQ, DCM_PRCSCHEDULEDPROCSTEPDESCRIPTION },
    { DCM_PRCSCHEDULEDPROCSTEPSEQ, DCM_PRCSCHEDULEDPROCSTEPID },
    { 0, 0}
  };

  SEQUENCE_TAG v2[] = {
    { DCM_IDREFERENCEDSTUDYSEQ, DCM_IDREFERENCEDSOPCLASSUID },
    { DCM_IDREFERENCEDSTUDYSEQ, DCM_IDREFERENCEDSOPINSTUID },

    //{ DCM_PRCSCHEDULEDACTIONITEMCODESEQ, DCM_IDCODEVALUE },
    //{ DCM_PRCSCHEDULEDACTIONITEMCODESEQ, DCM_IDCODINGSCHEMEDESIGNATOR },
    //{ DCM_PRCSCHEDULEDACTIONITEMCODESEQ, DCM_IDCODEMEANING },

    { 0, 0}
  };

  DCM_TAG v4[] = {
    DCM_PATNAME,
    DCM_PATID,
    DCM_PATBIRTHDATE,
    DCM_PATSEX,
    0
  };

  SEQUENCE_TAG v5[] = {
    { DCM_IDREFERENCEDPATIENTSEQ, DCM_IDREFERENCEDSOPCLASSUID },
    { DCM_IDREFERENCEDPATIENTSEQ, DCM_IDREFERENCEDSOPINSTUID },
    { 0, 0 }
  };

  sequenceItemWrapper.importAttributes(mwl, v0);
  if (studyInstanceUID != "") {
    sequenceItemWrapper.setString(DCM_RELSTUDYINSTANCEUID, studyInstanceUID);
  }
#if 0
  if (groupCaseFlag) {
    sequenceItemWrapper.setString(DCM_IDACCESSIONNUMBER, "");
  }
#endif

  int i;
  for (i = 0; v1[i].t1 != 0; i++) {
    MString s = mwl.getString(v1[i].t1, v1[i].t2);
    sequenceItemWrapper.setString(v1[i].t2, s);
  }

  for (i = 0; v2[i].t1 != 0; i++) {
    MString s = mwl.getString(v2[i].t1, v2[i].t2);
    sequenceItemWrapper.createSequence(v2[i].t1);
    if (s != "")
      sequenceItemWrapper.setString(v2[i].t1, v2[i].t2, s, 1);
  }

  DCM_OBJECT* mwlNative = mwl.getNativeObject();
  LST_HEAD* l1 = 0;
  LST_HEAD* l2 = 0;
  DCM_SEQUENCE_ITEM* item2 = 0;

  cond = ::DCM_GetSequenceList(&mwlNative, DCM_PRCSCHEDULEDPROCSTEPSEQ, &l1);
  if (cond == DCM_NORMAL) {
    DCM_SEQUENCE_ITEM* item1 = (DCM_SEQUENCE_ITEM*)::LST_Head(&l1);
    cond = ::DCM_GetSequenceList(&item1->object,
				 DCM_PRCSCHEDULEDACTIONITEMCODESEQ,
				 &l2);
    if (cond == DCM_NORMAL) {
      item2 = (DCM_SEQUENCE_ITEM*)::LST_Head(&l2);
      (void) ::LST_Position(&l2, item2);
    }
  }
  (void) ::COND_PopCondition(TRUE);

  LST_HEAD* l3 = ::LST_Create();

  while (item2 != NULL) {
    DCM_SEQUENCE_ITEM* item3 = (DCM_SEQUENCE_ITEM*)malloc(sizeof(*item3));
    DCM_OBJECT* copy = 0;
    ::DCM_CopyObject(&item2->object, &item3->object);
    ::LST_Enqueue(&l3, item3);

    item2 = (DCM_SEQUENCE_ITEM*)::LST_Next(&l2);
  }
  DCM_ELEMENT e0 = { DCM_PRCSCHEDULEDACTIONITEMCODESEQ, DCM_SQ, "", 1, 0, 0};
  e0.d.sq = l3;
  cond = ::DCM_AddSequenceElement(&item->object, &e0);
  if (cond != DCM_NORMAL) {
    ::COND_DumpConditions();
    exit(1);
  }

  ::LST_Enqueue(&ssaSequenceList, item);

  wrapper.importAttributes(mwl,v4);

  for (i = 0; v5[i].t1 != 0; i++) {
    MString s = mwl.getString(v5[i].t1, v5[i].t2);
    wrapper.createSequence(v5[i].t1);
    if (s != "")
      wrapper.setString(v5[i].t1, v5[i].t2, s, 1);
  }

  return 0;
}

int
MPPSAssistant::mergeMWLPPSNCreate(MDICOMWrapper& mwl,
				  MDICOMWrapper& wrapper)
{

  return 0;
}


int
MPPSAssistant::addPerformedSeriesSequence(const MString& mppsObjectPath,
					  const MString& sopInstancePath)
{
  char* p1 = mppsObjectPath.strData();
  char* p2 = sopInstancePath.strData();

  DCM_OBJECT* mppsObj = 0;
  DCM_OBJECT* sopObj = 0;
  CONDITION cond;

  cond = ::DCM_OpenFile(p1, DCM_ORDERLITTLEENDIAN, &mppsObj);
  if (cond != DCM_NORMAL) {
    ::COND_DumpConditions();
    return -1;
  }
  cond = ::DCM_OpenFile(p2, DCM_ORDERLITTLEENDIAN, &sopObj);
  if (cond != DCM_NORMAL) {
    ::COND_DumpConditions();
    return -1;
  }

  this->addPerformedSeriesSequence(&mppsObj);

  this->addPerformedSeriesSeqItem(&mppsObj, &sopObj);

  DCM_OBJECT* cpy = 0;

  ::DCM_CopyObject(&mppsObj, &cpy);
  ::DCM_CloseObject(&mppsObj);
  ::DCM_CloseObject(&sopObj);

  ::DCM_WriteFile(&cpy, DCM_ORDERLITTLEENDIAN, p1);
  ::DCM_CloseObject(&cpy);

  return 0;
}

void
MPPSAssistant::includePerformedProtocolCodes(bool flag) {
 mIncludePerformedProtocolCodes = flag;
}

bool
MPPSAssistant::includePerformedProtocolCodes() const {
 return mIncludePerformedProtocolCodes;
}

// Private methods

int
MPPSAssistant::mergeSimpleTags(DCM_TAG* tags,
			       MDICOMWrapper& mppsWrapper,
			       MDICOMWrapper& dataSet)
{
  MLogClient logClient;
  while(*tags != 0) {
    if (dataSet.attributePresent(tags[0])) {
      if (mppsWrapper.attributePresent(tags[0])) {
	MString s = dataSet.getString(tags[0]);
	mppsWrapper.setString(tags[0], s);
	char t1[256];
	::sprintf(t1, "Merged attribute %08x ", tags[0]);
	logClient.logTimeStamp(MLogClient::MLOG_VERBOSE,
			MString(t1) + s);
      } else {
	char tmp[128];
	::sprintf(tmp, "%s %08x",
			"Attempt to set an MPPS attribute that was not created:",
			*tags);
	logClient.logTimeStamp(MLogClient::MLOG_ERROR, tmp);
	return -1;
      }
    }
    tags++;
  }
  return 0;
}

int
MPPSAssistant::mergeSequences(DCM_TAG* tags,
			       MDICOMWrapper& mppsWrapper,
			       MDICOMWrapper& dataSet)
{
  DCM_OBJECT* o1;
  DCM_OBJECT* o2;

  o1 = mppsWrapper.getNativeObject();
  o2 = dataSet.getNativeObject();

  while(*tags != 0) {
    LST_HEAD* l1 = 0;
    LST_HEAD* l2 = 0;
    CONDITION cond;

    cond = ::DCM_GetSequenceList(&o2, tags[0], &l2);
    if (cond == DCM_NORMAL) {
      cond = ::DCM_GetSequenceList(&o1, tags[0], &l1);
      if (cond == DCM_NORMAL) {
	DCM_SEQUENCE_ITEM* item;
	item = (DCM_SEQUENCE_ITEM*)LST_Dequeue(&l1);
	while(item != NULL) {
	  ::DCM_CloseObject(&item->object);
	  free(item);
	  item = (DCM_SEQUENCE_ITEM*)LST_Dequeue(&l1);
	}
	item = (DCM_SEQUENCE_ITEM*)LST_Dequeue(&l2);
	while(item != NULL) {
	  ::LST_Enqueue(&l1, item);
	  item = (DCM_SEQUENCE_ITEM*)LST_Dequeue(&l2);
	}
      } else {
	cerr << "Attempt to set an MPPS attribute that was not created" << endl;
	cerr << tags[0];
	return -1;
      }
    }
    (void)::COND_PopCondition(TRUE);
    tags++;
  }
  return 0;
}

int
MPPSAssistant::addPerformedSeriesSequence(DCM_OBJECT** obj)
{
  LST_HEAD* l = 0;
  CONDITION cond;

  cond = DCM_GetSequenceList(obj, DCM_PRCPERFORMEDSERIESSEQ, &l);
  if (cond == DCM_NORMAL)
    return 0;

  l = ::LST_Create();
  DCM_ELEMENT e = { DCM_PRCPERFORMEDSERIESSEQ, DCM_SQ, "", 1, 0, 0};
  e.d.sq = l;

  cond = ::DCM_AddSequenceElement(obj, &e);
  if (cond != DCM_NORMAL) {
    ::COND_DumpConditions();
    ::exit(1);
  }

  ::COND_PopCondition(TRUE);

  return 0;
}

int
MPPSAssistant::addPerformedSeriesSeqItem(DCM_OBJECT** mppsObj,
					 DCM_OBJECT** sopObj)
{
  LST_HEAD* l = 0;
  CONDITION cond;

  cond = DCM_GetSequenceList(mppsObj, DCM_PRCPERFORMEDSERIESSEQ, &l);

  DCM_SEQUENCE_ITEM* item;

  item = (DCM_SEQUENCE_ITEM*)::LST_Head(&l);
  (void)::LST_Position(&l, item);

  MDICOMWrapper sopWrapper(*sopObj);
  MString seriesUID = sopWrapper.getString(DCM_RELSERIESINSTANCEUID);
  while (item != 0) {
    MDICOMWrapper w(item->object);
    MString uid = w.getString(DCM_RELSERIESINSTANCEUID);
    if (seriesUID == uid) {
      this->addRefImageSeq(&item->object, sopObj);
      this->addRefStandaloneSOPSeq(&item->object, sopObj);
      break;
    } else {
      item = (DCM_SEQUENCE_ITEM*)::LST_Next(&l);
    }
  }

  if (item == NULL) {
    item = (DCM_SEQUENCE_ITEM*)malloc(sizeof(*item));
    ::DCM_CreateObject(&item->object, 0);
    this->addSeriesInformation(&item->object, sopObj);
    this->addRefImageSeq(&item->object, sopObj);
    this->addRefStandaloneSOPSeq(&item->object, sopObj);
    ::LST_Enqueue(&l, item);
  }

  return 0;
}

int
MPPSAssistant::addRefImageSeq(DCM_OBJECT** target, DCM_OBJECT** src)
{
  LST_HEAD* l = 0;
  CONDITION cond;

  cond = ::DCM_GetSequenceList(target, DCM_IDREFERENCEDIMAGESEQ, &l);
  if (cond != DCM_NORMAL) {
    l = ::LST_Create();
    DCM_ELEMENT e = { DCM_IDREFERENCEDIMAGESEQ, DCM_SQ, "", 1, 0, 0 };
    e.d.sq = l;
    ::DCM_AddSequenceElement(target, &e);
  };

  MDICOMWrapper w1(*src);
  MString s = w1.getString(DCM_IDSOPINSTANCEUID);

  DCM_SEQUENCE_ITEM* item;
  item = (DCM_SEQUENCE_ITEM*)::LST_Head(&l);
  (void)::LST_Position(&l, item);

  while (item != 0) {
    MDICOMWrapper w2(item->object);
    MString s2 = w2.getString(DCM_IDREFERENCEDSOPINSTUID);
    if (s2 == s)
      break;

    item = (DCM_SEQUENCE_ITEM*)::LST_Next(&l);
  }

  if (item == 0) {
    item = (DCM_SEQUENCE_ITEM*)malloc(sizeof(*item));
    ::DCM_CreateObject(&item->object, 0);
    MDICOMWrapper w3(item->object);
    w3.setString(DCM_IDREFERENCEDSOPINSTUID, s);
    MString classUID = w1.getString(DCM_IDSOPCLASSUID);
    w3.setString(DCM_IDREFERENCEDSOPCLASSUID, classUID);
    ::LST_Enqueue(&l, item);
  }

  return 0;
}

int
MPPSAssistant::addRefStandaloneSOPSeq(DCM_OBJECT** target, DCM_OBJECT** src)
{
  LST_HEAD* l = 0;
  CONDITION cond;

  cond = ::DCM_GetSequenceList(target, DCM_PRCREFSTANDALONESOPSEQ, &l);
  if (cond != DCM_NORMAL) {
    l = ::LST_Create();
    DCM_ELEMENT e = { DCM_PRCREFSTANDALONESOPSEQ, DCM_SQ, "", 1, 0, 0 };
    e.d.sq = l;
    ::DCM_AddSequenceElement(target, &e);
  };

  return 0;
}

int
MPPSAssistant::addSeriesInformation(DCM_OBJECT** target, DCM_OBJECT** src)
{
  DCM_TAG tags[] = {
    DCM_IDPERFORMINGPHYSICIAN,
    DCM_ACQPROTOCOLNAME,
    DCM_IDOPERATORNAME,
    DCM_RELSERIESINSTANCEUID,
    DCM_IDSERIESDESCR,
    DCM_IDRETRIEVEAETITLE,
    0
  };

  MDICOMWrapper w1(*target);
  MDICOMWrapper w2(*src);

  w1.importAttributes(w2, tags);

  return 0;
}
