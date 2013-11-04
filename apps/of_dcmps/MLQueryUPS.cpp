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
#include "MLQueryUPS.hpp"
#include "MDBOrderFillerBase.hpp"
#include "MDICOMWrapper.hpp"
#include "MDICOMDomainXlate.hpp"
#include "MFileOperations.hpp"
#include "MLogClient.hpp"

#if 0
MLQueryUPS::MLQueryUPS()
{
}
#endif

MLQueryUPS::MLQueryUPS(const MLQueryUPS& cpy) :
  mOrderFiller(cpy.mOrderFiller),
  mLogDir(cpy.mLogDir)
{
}

MLQueryUPS::~MLQueryUPS()
{
  MUPSObjectsVector::iterator mObjIt = mObjectsVector.end();
  for (; mObjIt != mObjectsVector.begin(); mObjIt--) {
    mObjectsVector.pop_back();
  }  
}

void
MLQueryUPS::printOn(ostream& s) const
{
  s << "MLQueryUPS";
}

void
MLQueryUPS::streamIn(istream& s)
{
  //s >> this->member;
}

// Non-boiler plate methods to follow

MLQueryUPS::MLQueryUPS(MDBOrderFillerBase& ordfil, MString logDir) :
  mOrderFiller(ordfil),
  mLogDir(logDir)
{
}

CONDITION
MLQueryUPS::handleCFindCommand(DUL_PRESENTATIONCONTEXT* ctx,
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
		"MLQueryUPS::handleCFindCommand",
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
		  "MLQueryUPS::handleCFindCommand",
		  __LINE__,
		  MString("C-Find query stored in ") + s);

    delete []s1;

    w.log(logClient, MLogClient::MLOG_VERBOSE);
  }

  // Add return values to empty sequences
  this->inflateEmptySequences((*message)->identifier);

  //clear the MUPSObjectsVector
  MUPSObjectsVector::iterator mObjIt = mObjectsVector.end();
  for (; mObjIt != mObjectsVector.begin(); mObjIt--) {
    mObjectsVector.pop_back();
  }  

  MDICOMDomainXlate xlate;

  MUPS ups;
//  MActionItemVector aiv;
//  xlate.translateDICOM(w, ups, aiv);
  MUWLScheduledStationNameCodeVector ssnCodeVector;
  xlate.translateDICOM(w, ups, ssnCodeVector);
  mOrderFiller.queryUnifiedWorkList(ups, *this);

  //add logging here to report number of items returned for query
  char rows[64];
  sprintf(rows, "%d", mObjectsVector.size());
  logClient.log(MLogClient::MLOG_VERBOSE,
	    callingAPTitle,
	    "MLQueryUPS::handleCFindCommand",
	    __LINE__,
	    MString("C-Find query returned ") + rows + MString(" work list items"));

  return SRV_NORMAL;
}

//  virtual
CONDITION
MLQueryUPS::returnCFindDataSet(DUL_PRESENTATIONCONTEXT* ctx,
                                       MSG_C_FIND_REQ** message,
                                       MSG_C_FIND_RESP* response,
                                       DUL_ASSOCIATESERVICEPARAMETERS* params,
			               const MString& queryLevelString,
                                       int index)
{
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_VERBOSE,
		params->callingAPTitle,
		"MLQueryUPS::returnCFindDataSet",
		__LINE__,
		"Sending C-Find dataset");

  int size = mObjectsVector.size();
  if (index > size) {
    response->status = MSG_K_SUCCESS;
    response->dataSetType = DCM_CMDDATANULL;
  } else {
    response->status = MSG_K_C_FIND_MATCHCONTINUING;
    response->dataSetType = DCM_CMDDATAIDENTIFIER;

    MUPS  ups = mObjectsVector[index-1].ups();
    MUWLScheduledStationNameCodeVector ssnCodeVector = mObjectsVector[index-1].ssnCodeVector();
    MDICOMDomainXlate xlate;
    xlate.translateDICOM(ups, ssnCodeVector, (*message)->identifier, response->identifier);
    MDICOMWrapper x((*message)->identifier);
    MString specificCharacterSet = x.getString(0x00080005);
    if (specificCharacterSet != "") {
      MDICOMWrapper resp(response->identifier);
      resp.setString(0x00080005, specificCharacterSet);
    }
  }
  logClient.log(MLogClient::MLOG_VERBOSE,
		params->callingAPTitle,
		"MLQueryUPS::returnCFindDataSet",
		__LINE__,
		"Sending C-Find dataset complete");

  return SRV_NORMAL;
}

int
MLQueryUPS::selectCallback(const MUPS & ups,
			const MUWLScheduledStationNameCodeVector& ssnCodeVector)
{
  MUPSObjects obj(ups, ssnCodeVector);
  mObjectsVector.push_back(obj);
  return 0;
}

int
MLQueryUPS::selectCallback(const MMWL & mwl,
			const MActionItemVector& actionitem)
{
  // This should never get called.
  cout << "MLQueryUPS::selectCallback with MWL object should not be called" << endl;
//  MUPSObjects obj(mwl, actionitem);
//  mObjectsVector.push_back(obj);
  return -1;
}

MUPSObjectsVector
MLQueryUPS::retMUPSObjects()
{
  return mObjectsVector;
}

int
MLQueryUPS::objectVectorSize() const
{
  return mObjectsVector.size();
}

MUPSObjects&
MLQueryUPS::getMUPSObjects(int index)
{
  return mObjectsVector[index];
}

// Private methods below
void
MLQueryUPS::inflateEmptySequences(DCM_OBJECT* obj)
{
  this->inflateScheduledProcedureStep(obj);

  this->inflateScheduledActionItem(obj);

  this->inflateRequestedProcedureCode(obj);

  this->inflateReferencedStudySequence(obj);

  this->inflateReferencedPatientSequence(obj);

  this->inflateScheduledStationNameCodeSequence(obj);
}

void
MLQueryUPS::inflateScheduledProcedureStep(DCM_OBJECT* obj)
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
MLQueryUPS::inflateScheduledActionItem(DCM_OBJECT* obj)
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
MLQueryUPS::inflateRequestedProcedureCode(DCM_OBJECT* obj)
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
MLQueryUPS::inflateReferencedStudySequence(DCM_OBJECT* obj)
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
MLQueryUPS::inflateReferencedPatientSequence(DCM_OBJECT* obj)
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

void
MLQueryUPS::inflateScheduledStationNameCodeSequence(DCM_OBJECT* obj)
{
  LST_HEAD* l1 = 0;

  CONDITION cond = ::DCM_GetSequenceList(&obj,
					 DCM_MAKETAG(0x0040, 0x4025),
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
