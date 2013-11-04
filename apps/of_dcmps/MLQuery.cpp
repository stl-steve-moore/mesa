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
#include "MLQuery.hpp"
#include "MDBOrderFillerBase.hpp"
#include "MDICOMWrapper.hpp"
#include "MDICOMDomainXlate.hpp"
#include "MFileOperations.hpp"
#include "MLogClient.hpp"

#if 0
MLQuery::MLQuery()
{
}
#endif

MLQuery::MLQuery(const MLQuery& cpy) :
  mOrderFiller(cpy.mOrderFiller),
  mLogDir(cpy.mLogDir)
{
}

MLQuery::~MLQuery()
{
  MMWLObjectsVector::iterator mObjIt = mObjectsVector.end();
  for (; mObjIt != mObjectsVector.begin(); mObjIt--) {
    mObjectsVector.pop_back();
  }  
}

void
MLQuery::printOn(ostream& s) const
{
  s << "MLQuery";
}

void
MLQuery::streamIn(istream& s)
{
  //s >> this->member;
}

// Non-boiler plate methods to follow

MLQuery::MLQuery(MDBOrderFillerBase& ordfil, MString logDir) :
  mOrderFiller(ordfil),
  mLogDir(logDir)
{
}

CONDITION
MLQuery::handleCFindCommand(DUL_PRESENTATIONCONTEXT* ctx,
			       MSG_C_FIND_REQ** message,
			       MSG_C_FIND_RESP* response,
			       DUL_ASSOCIATESERVICEPARAMETERS* params,
			       const MString& queryLevelString)
{
  MLogClient logClient;
  MString callingAPTitle;

  if (!params) {
    // We have been called by mwlQuery
    callingAPTitle = "mwlQuery()";
  }
  else {
    callingAPTitle = params->callingAPTitle;
  }

  logClient.log(MLogClient::MLOG_VERBOSE,
		callingAPTitle,
		"MLQuery::handleCFindCommand",
		__LINE__,
		"C-Find command received");

  MFileOperations f;
  MDICOMWrapper w((*message)->identifier);

  // Section in braces stores the query in a file
  // in case we want to examine it later for debugging
  {
    char path[] = "logs/ordfil_mwl";

    f.createDirectory("MESA_TARGET", path);

    MString s = f.uniqueFile("MESA_TARGET", path, "qry");
    char* s1 = s.strData();

    ::DCM_WriteFile(&(*message)->identifier,
		    DCM_ORDERLITTLEENDIAN,
		    s1);

    logClient.log(MLogClient::MLOG_VERBOSE,
		  callingAPTitle,
		  "MLQuery::handleCFindCommand",
		  __LINE__,
		  MString("C-Find query stored in ") + s);

    delete []s1;

    w.log(logClient, MLogClient::MLOG_VERBOSE);
  }

  // Add return values to empty sequences
  this->inflateEmptySequences((*message)->identifier);

  //clear the MMWLObjectsVector
  MMWLObjectsVector::iterator mObjIt = mObjectsVector.end();
  for (; mObjIt != mObjectsVector.begin(); mObjIt--) {
    mObjectsVector.pop_back();
  }  

  MDICOMDomainXlate xlate;

  MMWL mwl;
  MActionItemVector aiv;
  xlate.translateDICOM(w, mwl, aiv);
  mOrderFiller.queryModalityWorkList(mwl, *this);

#if 0
  MMWLObjectsVector::iterator objIt = mObjectsVector.begin();
  for (; objIt != mObjectsVector.end(); objIt++) {
    MMWL x1 = (*objIt).mwl();
    xlate.translateDICOM(x1, aiv,
			 (*message)->identifier,
			 response->identifier);
  }
#endif

  //add logging here to report number of items returned for query
  char rows[64];
  sprintf(rows, "%d", mObjectsVector.size());
  logClient.log(MLogClient::MLOG_VERBOSE,
	    callingAPTitle,
	    "MLQuery::handleCFindCommand",
	    __LINE__,
	    MString("C-Find query returned ") + rows + MString(" work list items"));

  return SRV_NORMAL;
}

//  virtual
CONDITION
MLQuery::returnCFindDataSet(DUL_PRESENTATIONCONTEXT* ctx,
                                       MSG_C_FIND_REQ** message,
                                       MSG_C_FIND_RESP* response,
                                       DUL_ASSOCIATESERVICEPARAMETERS* params,
			               const MString& queryLevelString,
                                       int index)
{
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_VERBOSE,
		params->callingAPTitle,
		"MLQuery::returnCFindDataSet",
		__LINE__,
		"Sending C-Find dataset");

  int size = mObjectsVector.size();
  if (index > size) {
    response->status = MSG_K_SUCCESS;
    response->dataSetType = DCM_CMDDATANULL;
  } else {
    response->status = MSG_K_C_FIND_MATCHCONTINUING;
    response->dataSetType = DCM_CMDDATAIDENTIFIER;

    MMWL mwl = mObjectsVector[index-1].mwl();
    MActionItemVector aiv = mObjectsVector[index-1].actionItemVector();
    MDICOMDomainXlate xlate;
    xlate.translateDICOM(mwl, aiv, (*message)->identifier, response->identifier);
    MDICOMWrapper x((*message)->identifier);
    MString specificCharacterSet = x.getString(0x00080005);
    if (specificCharacterSet != "") {
      MDICOMWrapper resp(response->identifier);
      resp.setString(0x00080005, specificCharacterSet);
    }
  }
  logClient.log(MLogClient::MLOG_VERBOSE,
		params->callingAPTitle,
		"MLQuery::returnCFindDataSet",
		__LINE__,
		"Sending C-Find dataset complete");

  return SRV_NORMAL;
}

int
MLQuery::selectCallback(const MMWL& mwl,
			const MActionItemVector& actionitem)
{
  MMWLObjects obj(mwl, actionitem);
  mObjectsVector.push_back(obj);
  return 0;
}

int
MLQuery::selectCallback(const MUPS& ups,
			const MUWLScheduledStationNameCodeVector& ssnCodeVector)
{
  // This should never get called.
  cout << "MLQuery::selectCallback called with MUPS object; that is a programming error" << endl;
//  MUPSObjects obj(ups, actionitem);
//  mObjectsVector.push_back(obj);
  return 0;
}

MMWLObjectsVector
MLQuery::retMMWLObjects()
{
  return mObjectsVector;
}

int
MLQuery::objectVectorSize() const
{
  return mObjectsVector.size();
}

MMWLObjects&
MLQuery::getMMWLObjects(int index)
{
  return mObjectsVector[index];
}

// Private methods below
void
MLQuery::inflateEmptySequences(DCM_OBJECT* obj)
{
  this->inflateScheduledProcedureStep(obj);

  this->inflateScheduledActionItem(obj);

  this->inflateRequestedProcedureCode(obj);

  this->inflateReferencedStudySequence(obj);

  this->inflateReferencedPatientSequence(obj);
}

void
MLQuery::inflateScheduledProcedureStep(DCM_OBJECT* obj)
{
  LST_HEAD *l1 = 0;

  CONDITION cond = ::DCM_GetSequenceList(&obj,
					 DCM_PRCSCHEDULEDPROCSTEPSEQ,
					 &l1);
  if (cond != DCM_NORMAL) {    // Then the sequence is not present
    ::COND_PopCondition(TRUE);
    return;
  }

  DCM_SEQUENCE_ITEM* item1 = (DCM_SEQUENCE_ITEM*) ::LST_Head(&l1);
  if (item1 != NULL) {         // Then there is something in the sequence
    return;
  }

  item1 = (DCM_SEQUENCE_ITEM*) ::malloc(sizeof(*item1));
  ::DCM_CreateObject(&item1->object, 0);
  MDICOMWrapper w(item1->object);

  DCM_TAG t[] = {
    DCM_PRCSCHEDULEDSTATIONAETITLE,
    DCM_PRCSCHEDULEDPROCSTEPSTARTDATE,
    DCM_PRCSCHEDULEDPROCSTEPSTARTTIME,
    DCM_IDMODALITY,
    DCM_PRCSCHEDULEDPERFORMINGPHYSNAME,
    DCM_PRCSCHEDULEDPROCSTEPDESCRIPTION,
    DCM_PRCSCHEDULEDSTATIONNAME,
    DCM_PRCSCHEDULEDPROCSTEPLOCATION,
    DCM_PRCPREMEDICATION,
    DCM_PRCSCHEDULEDPROCSTEPID,
    DCM_SDYREQUESTEDCONTRASTAGENT,
    0 };

  int i = 0;

  for (i = 0; t[i] != 0; i++)
    w.setString(t[i], "");


  LST_HEAD *l2 = ::LST_Create();
  DCM_ELEMENT e = { DCM_PRCSCHEDULEDACTIONITEMCODESEQ, DCM_SQ, "", 1, 0, 0 };
  e.d.sq = l2;
  ::DCM_AddSequenceElement(&item1->object, &e);

  ::LST_Enqueue(&l1, item1);

}

void
MLQuery::inflateScheduledActionItem(DCM_OBJECT* obj)
{
  LST_HEAD* l1 = 0;
  CONDITION cond = ::DCM_GetSequenceList(&obj,
					 DCM_PRCSCHEDULEDPROCSTEPSEQ,
					 &l1);
  if (cond != DCM_NORMAL) {
    ::COND_PopCondition(TRUE);
    return;
  }

  DCM_SEQUENCE_ITEM* item1 = (DCM_SEQUENCE_ITEM*)::LST_Head(&l1);
  if (item1 == NULL)
    return;

  LST_HEAD* l2 = 0;
  cond = ::DCM_GetSequenceList(&item1->object,
			       DCM_PRCSCHEDULEDACTIONITEMCODESEQ,
			       &l2);
  if (cond != DCM_NORMAL) {
    ::COND_PopCondition(TRUE);
    return;
  }

  DCM_SEQUENCE_ITEM* item2 = (DCM_SEQUENCE_ITEM*) ::LST_Head(&l2);
  if (item2 == NULL) {  // Then, we have an empty sequence
    item2 = (DCM_SEQUENCE_ITEM*) ::malloc(sizeof(*item2));
    ::DCM_CreateObject(&item2->object, 0);
    MDICOMWrapper w2(item2->object);
    w2.setString(DCM_IDCODEVALUE, "");
    w2.setString(DCM_IDCODINGSCHEMEDESIGNATOR, "");
    w2.setString(DCM_IDCODEMEANING, "");
    ::LST_Enqueue(&l2, item2);
  } else {	// See if they sent a zero-length item
    MDICOMWrapper w3(item2->object);
    bool emptyFlag = true;
    if (w3.attributePresent(DCM_IDCODEVALUE))
      emptyFlag = false;
    if (w3.attributePresent(DCM_IDCODINGSCHEMEDESIGNATOR))
      emptyFlag = false;
    if (w3.attributePresent(DCM_IDCODEMEANING))
      emptyFlag = false;
    if (emptyFlag) {		// Then none of these are included
      w3.setString(DCM_IDCODEVALUE, "");
      w3.setString(DCM_IDCODINGSCHEMEDESIGNATOR, "");
      w3.setString(DCM_IDCODEMEANING, "");
    }
  }
}

void
MLQuery::inflateRequestedProcedureCode(DCM_OBJECT* obj)
{
  LST_HEAD* l1 = 0;

  CONDITION cond = ::DCM_GetSequenceList(&obj,
					 DCM_SDYREQUESTEDPROCODESEQ,
					 &l1);
  if (cond != DCM_NORMAL) {
    ::COND_PopCondition(TRUE);
    return;
  }

  DCM_SEQUENCE_ITEM* item = (DCM_SEQUENCE_ITEM*) ::LST_Head(&l1);
  if (item == NULL) {
    item = (DCM_SEQUENCE_ITEM*) ::malloc(sizeof(*item));
    ::DCM_CreateObject(&item->object, 0);
    MDICOMWrapper w(item->object);

    w.setString(DCM_IDCODEVALUE, "");
    w.setString(DCM_IDCODINGSCHEMEDESIGNATOR, "");
    w.setString(DCM_IDCODEMEANING, "");

    ::LST_Enqueue(&l1, item);
  } else {
    bool emptyFlag = true;
    MDICOMWrapper w3(item->object);
    if (w3.attributePresent(DCM_IDCODEVALUE))
      emptyFlag = false;
    if (w3.attributePresent(DCM_IDCODINGSCHEMEDESIGNATOR))
      emptyFlag = false;
    if (w3.attributePresent(DCM_IDCODEMEANING))
      emptyFlag = false;
    if (emptyFlag) {		// Then none of these are included
      w3.setString(DCM_IDCODEVALUE, "");
      w3.setString(DCM_IDCODINGSCHEMEDESIGNATOR, "");
      w3.setString(DCM_IDCODEMEANING, "");
    }
  }
}

void
MLQuery::inflateReferencedStudySequence(DCM_OBJECT* obj)
{
  LST_HEAD* l1 = 0;

  CONDITION cond = ::DCM_GetSequenceList(&obj,
					 DCM_IDREFERENCEDSTUDYSEQ,
					 &l1);
  if (cond != DCM_NORMAL) {
    ::COND_PopCondition(TRUE);
    return;
  }

  DCM_SEQUENCE_ITEM* item = (DCM_SEQUENCE_ITEM*) ::LST_Head(&l1);
  if (item == NULL) {
    item = (DCM_SEQUENCE_ITEM*) ::malloc(sizeof(*item));
    ::DCM_CreateObject(&item->object, 0);
    MDICOMWrapper w(item->object);

    w.setString(DCM_IDREFERENCEDSOPCLASSUID, "");
    w.setString(DCM_IDREFERENCEDSOPINSTUID, "");

    ::LST_Enqueue(&l1, item);
  } else {
    MDICOMWrapper w3(item->object);
    bool emptyFlag = true;
    if (w3.attributePresent(DCM_IDREFERENCEDSOPCLASSUID))
      emptyFlag = false;
    if (w3.attributePresent(DCM_IDREFERENCEDSOPINSTUID))
      emptyFlag = false;
    if (emptyFlag) {		// The sequence is here, but empty
      w3.setString(DCM_IDREFERENCEDSOPCLASSUID, "");
      w3.setString(DCM_IDREFERENCEDSOPINSTUID, "");
    }
  }
}

void
MLQuery::inflateReferencedPatientSequence(DCM_OBJECT* obj)
{
  LST_HEAD* l1 = 0;

  CONDITION cond = ::DCM_GetSequenceList(&obj,
					 DCM_IDREFERENCEDPATIENTSEQ,
					 &l1);
  if (cond != DCM_NORMAL) {
    ::COND_PopCondition(TRUE);
    return;
  }

  DCM_SEQUENCE_ITEM* item = (DCM_SEQUENCE_ITEM*) ::LST_Head(&l1);
  if (item == NULL) {
    item = (DCM_SEQUENCE_ITEM*) ::malloc(sizeof(*item));
    ::DCM_CreateObject(&item->object, 0);
    MDICOMWrapper w(item->object);

    w.setString(DCM_IDREFERENCEDSOPCLASSUID, "");
    w.setString(DCM_IDREFERENCEDSOPINSTUID, "");

    ::LST_Enqueue(&l1, item);
  } else {
    MDICOMWrapper w3(item->object);
    bool emptyFlag = true;
    if (w3.attributePresent(DCM_IDREFERENCEDSOPCLASSUID))
      emptyFlag = false;
    if (w3.attributePresent(DCM_IDREFERENCEDSOPINSTUID))
      emptyFlag = false;
    if (emptyFlag) {		// The sequence is here, but empty
      w3.setString(DCM_IDREFERENCEDSOPCLASSUID, "");
      w3.setString(DCM_IDREFERENCEDSOPINSTUID, "");
    }
  }
}
