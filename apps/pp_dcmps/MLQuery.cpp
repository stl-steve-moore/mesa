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
#include "MDBPostProcMgr.hpp"
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
  mPostProcMgr(cpy.mPostProcMgr),
  mLogDir(cpy.mLogDir)
{
}

MLQuery::~MLQuery()
{
  MGPWorkitemObjectVector::iterator mObjIt = mObjectsVector.end();
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

MLQuery::MLQuery(MDBPostProcMgr& ppmgr, MString logDir) :
  mPostProcMgr(ppmgr),
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
    char path[] = "logs/postprocmgr_gpwl";

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

  // this->inflateEmptySequences((*message)->identifier);

  //clear the MGPWorkitemObjectVector
  MGPWorkitemObjectVector::iterator mObjIt = mObjectsVector.end();
  for (; mObjIt != mObjectsVector.begin(); mObjIt--) {
    mObjectsVector.pop_back();
  }  

  MDICOMDomainXlate xlate;

  MGPWorkitem workitem;
  MStationNameVector snv;
  MStationClassVector scv;
  MInputInfoVector iiv;
  xlate.translateDICOM(w, workitem);
  xlate.translateDICOM(w, snv);
  xlate.translateDICOM(w, scv);
  xlate.translateDICOM(w, iiv);

  MGPWorkitemObject wio = MGPWorkitemObject(workitem);
  wio.stationNameVector(snv);
  wio.stationClassVector(scv);
  wio.inputInfoVector(iiv);
//cout << "Request\n";
//cout << wio;
//cout << "end Request\n";

  mPostProcMgr.queryPostProcWorkList(wio, *this);

  // xlate the response in MESA format into the DICOM format response.
  MGPWorkitemObjectVector::iterator objIt = mObjectsVector.begin();
  for (; objIt != mObjectsVector.end(); objIt++) {
//cout << (*objIt);
    MGPWorkitem x1 = (*objIt).workitem();
    xlate.translateDICOM(x1, (*message)->identifier, response->identifier);
    MStationNameVector x2 = (*objIt).stationNameVector();
    xlate.translateDICOM(x2, (*message)->identifier, response->identifier);
    MStationClassVector x3 = (*objIt).stationClassVector();
    xlate.translateDICOM(x3, (*message)->identifier, response->identifier);
    MInputInfoVector x4 = (*objIt).inputInfoVector();
    xlate.translateDICOM(x4, (*message)->identifier, response->identifier);
  }

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

    MDICOMDomainXlate xlate;
    MGPWorkitem workitem = mObjectsVector[index-1].workitem();
    xlate.translateDICOM(workitem,(*message)->identifier, response->identifier);
    MStationNameVector snv = mObjectsVector[index-1].stationNameVector();
    xlate.translateDICOM(snv, (*message)->identifier, response->identifier);
    MStationClassVector scv = mObjectsVector[index-1].stationClassVector();
    xlate.translateDICOM(scv, (*message)->identifier, response->identifier);
    MInputInfoVector iiv = mObjectsVector[index-1].inputInfoVector();
    xlate.translateDICOM(iiv, (*message)->identifier, response->identifier);
  }
  logClient.log(MLogClient::MLOG_VERBOSE,
		params->callingAPTitle,
		"MLQuery::returnCFindDataSet",
		__LINE__,
		"Sending C-Find dataset complete");

  return SRV_NORMAL;
}

#if 0
int
MLQuery::selectCallback(const MGPWorkitem& workitem,
                        const MStationNameVector snv)
{
  MGPWorkitemObject obj(workitem, snv);
  mObjectsVector.push_back(obj);
  return 0;
}
#endif
int
MLQuery::selectCallback(const MGPWorkitemObject& workitemObject)
{
  mObjectsVector.push_back(workitemObject);
  return 0;
}

MGPWorkitemObjectVector
MLQuery::retMGPWorkitemObject()
{
  return mObjectsVector;
}

int
MLQuery::objectVectorSize() const
{
  return mObjectsVector.size();
}

MGPWorkitemObject&
MLQuery::getMGPWorkitemObject(int index)
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
  if (item != NULL) {
    return;
  }

  item = (DCM_SEQUENCE_ITEM*) ::malloc(sizeof(*item));
  ::DCM_CreateObject(&item->object, 0);
  MDICOMWrapper w(item->object);

  w.setString(DCM_IDCODEVALUE, "");
  w.setString(DCM_IDCODINGSCHEMEDESIGNATOR, "");
  w.setString(DCM_IDCODEMEANING, "");

  ::LST_Enqueue(&l1, item);
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
  if (item != NULL) {
    return;
  }

  item = (DCM_SEQUENCE_ITEM*) ::malloc(sizeof(*item));
  ::DCM_CreateObject(&item->object, 0);
  MDICOMWrapper w(item->object);

  w.setString(DCM_IDREFERENCEDSOPCLASSUID, "");
  w.setString(DCM_IDREFERENCEDSOPINSTUID, "");

  ::LST_Enqueue(&l1, item);
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
  if (item != NULL) {
    return;
  }

  item = (DCM_SEQUENCE_ITEM*) ::malloc(sizeof(*item));
  ::DCM_CreateObject(&item->object, 0);
  MDICOMWrapper w(item->object);

  w.setString(DCM_IDREFERENCEDSOPCLASSUID, "");
  w.setString(DCM_IDREFERENCEDSOPINSTUID, "");

  ::LST_Enqueue(&l1, item);
}
