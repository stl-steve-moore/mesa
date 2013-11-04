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
#include "MSOPHandler.hpp"
#include "MDICOMAssociation.hpp"
#include "MDICOMWrapper.hpp"
#include "MLogClient.hpp"

#include <stdio.h>
#ifndef _WIN32
#include <unistd.h>
#endif
#include <fcntl.h>

MSOPHandler::MSOPHandler()
{
}

MSOPHandler::MSOPHandler(const MSOPHandler& cpy)
{
}

MSOPHandler::~MSOPHandler()
{
}

void
MSOPHandler::printOn(ostream& s) const
{
  s << "MSOPHandler";
}

void
MSOPHandler::streamIn(istream& s)
{
  //s >> this->member;
}

// Non-boilerplate methods to follow
extern "C" {
  DUL_PRESENTATIONCONTEXT*
  SRVPRV_PresentationContext(DUL_ASSOCIATESERVICEPARAMETERS* params,
			     char* classUID);
};

// virtual
int
MSOPHandler::initialize()
{
  return 0;
}

//virtual
bool
MSOPHandler:: supportsSCRole(DUL_SC_ROLE role)
{
  return true;
}

//virtual
bool
MSOPHandler::xferIVRLEOnly()
{
  return true;
}


// virtual
CONDITION
MSOPHandler::handleCEcho(DUL_ASSOCIATIONKEY** association,
			 DUL_PRESENTATIONCONTEXT* ctx,
			 MSG_C_ECHO_REQ ** message)
{
  MLogClient l;
  l.log(MLogClient::MLOG_CONVERSATION, "unknown peer",
	"MSOPHandler::handleCEcho", __LINE__,
	"Received C-Echo request, about to respond");

  MSG_C_ECHO_RESP echoResponse =
  { MSG_K_C_ECHO_RESP, 0, 0, DCM_CMDDATANULL, 0, "" };

  ::strcpy(echoResponse.classUID, (*message)->classUID);
  echoResponse.messageIDRespondedTo = (*message)->messageID;
  echoResponse.status = MSG_K_SUCCESS;
  echoResponse.conditionalFields = MSG_K_C_ECHORESP_CLASSUID;

  DCM_OBJECT* obj = NULL;
  CONDITION cond;
  cond = ::MSG_BuildCommand(&echoResponse, &obj);
  if (cond != MSG_NORMAL) {
    ::COND_DumpConditions();
    ::exit(1);
  }
  cond = ::SRV_SendCommand(association, ctx, &obj);
  (void) ::DCM_CloseObject(&obj);
  if (cond != SRV_NORMAL) {
    ::COND_DumpConditions();
    ::exit(1);
  }

  return 0;
}

//virtual
CONDITION
MSOPHandler::handleCEchoResponse(DUL_PRESENTATIONCONTEXT* ctx,
				  MSG_C_ECHO_RESP** message,
				  DUL_ASSOCIATESERVICEPARAMETERS* params)
{
  MLogClient l;
  l.log(MLogClient::MLOG_CONVERSATION, "unknown peer",
	"MSOPHandler::handleCEchoResponse", __LINE__,
	"Received C-Echo response");

  return SRV_NORMAL;
}

extern "C" {
CONDITION SRVPRV_ReadNextPDV(DUL_ASSOCIATIONKEY** association,
			     DUL_BLOCKOPTIONS block,
			     int timeout,
			     DUL_PDV* pdv);
}

// virtual
CONDITION
MSOPHandler::handleCStoreCommand(DUL_PRESENTATIONCONTEXT* ctx,
				 MSG_C_STORE_REQ** message,
				 MSG_C_STORE_RESP* response,
				 DUL_ASSOCIATESERVICEPARAMETERS* params,
				 MString& fileName)
{
  //cout << fileName << endl;

  return 0;
}

// virtual
CONDITION
MSOPHandler::handleCStoreDataSet(DUL_PRESENTATIONCONTEXT* ctx,
				 MSG_C_STORE_REQ** message,
				 MSG_C_STORE_RESP* response,
				 DUL_ASSOCIATESERVICEPARAMETERS* params,
				 MString& fileName)
{
  //cout << fileName << endl;

  return 0;
}


//virtual
CONDITION
MSOPHandler::handleCStoreResponse(DUL_PRESENTATIONCONTEXT* ctx,
				  MSG_C_STORE_RESP** message,
				  DUL_ASSOCIATESERVICEPARAMETERS* params)
{
  return SRV_NORMAL;
}


// virtual
CONDITION
MSOPHandler::handleCFindCommand(DUL_PRESENTATIONCONTEXT* ctx,
				MSG_C_FIND_REQ** message,
				MSG_C_FIND_RESP* response,
				DUL_ASSOCIATESERVICEPARAMETERS* params,
				const MString& queryLevel)
{
  //cout << queryLevel << endl;

  return 0;
}

// virtual
CONDITION
MSOPHandler::returnCFindDataSet(DUL_PRESENTATIONCONTEXT* ctx,
				MSG_C_FIND_REQ** message,
				MSG_C_FIND_RESP* response,
				DUL_ASSOCIATESERVICEPARAMETERS* params,
				const MString& queryLevel,
				int index)
{
  response->status = MSG_K_SUCCESS;
  response->dataSetType = DCM_CMDDATANULL;
  return SRV_NORMAL;
}

// virtual
CONDITION
MSOPHandler::handleCFindResponse(DUL_PRESENTATIONCONTEXT* ctx,
				 MSG_C_FIND_RESP** message,
				 DUL_ASSOCIATESERVICEPARAMETERS* params,
				 const MString& queryLevel,
				 int index)
{
  ::DCM_DumpElements(&(*message)->identifier, 1);
  return SRV_NORMAL;
}

// virtual
CONDITION
MSOPHandler::handleCMoveCommand(DUL_PRESENTATIONCONTEXT* ctx,
				MSG_C_MOVE_REQ** message,
				MSG_C_MOVE_RESP* response,
				DUL_ASSOCIATESERVICEPARAMETERS* params,
				const MString& queryLevel)
{
  //cout << queryLevel << endl;

  return 0;
}

// virtual
CONDITION
MSOPHandler::returnCMoveStatus(DUL_PRESENTATIONCONTEXT* ctx,
				MSG_C_MOVE_REQ** message,
				MSG_C_MOVE_RESP* response,
				DUL_ASSOCIATESERVICEPARAMETERS* params,
				const MString& queryLevel,
				int index)
{
  response->status = MSG_K_SUCCESS;
  response->dataSetType = DCM_CMDDATANULL;
  return SRV_NORMAL;
}

// virtual
CONDITION
MSOPHandler::handleCMoveResponse(DUL_PRESENTATIONCONTEXT* ctx,
				 MSG_C_MOVE_RESP** message,
				 DUL_ASSOCIATESERVICEPARAMETERS* params,
				 const MString& queryLevel,
				 int index)
{
  //::DCM_DumpElements(&(*message)->identifier, 1);
  return SRV_NORMAL;
}


//virtual
CONDITION
MSOPHandler::handleNCreateCommand(DUL_PRESENTATIONCONTEXT* ctx,
				  MSG_N_CREATE_REQ** createRequest,
				  MSG_N_CREATE_RESP* createResponse,
				  DUL_ASSOCIATESERVICEPARAMETERS* params,
				  MString& directoryName)
{
  //cout << directoryName << endl;

  return 0;
}


//virtual
CONDITION
MSOPHandler::handleNCreateDataSet(DUL_PRESENTATIONCONTEXT* ctx,
				  MSG_N_CREATE_REQ** createRequest,
				  MSG_N_CREATE_RESP* createResponse,
				  DUL_ASSOCIATESERVICEPARAMETERS* params,
				  MString& directoryName)
{
  //cout << directoryName << endl;

  return 0;
}

CONDITION
MSOPHandler::handleNCreateResponse(DUL_PRESENTATIONCONTEXT* ctx,
				   MSG_N_CREATE_RESP** message,
				   DUL_ASSOCIATESERVICEPARAMETERS* params)
{
  if ((*message)->dataSetType != DCM_CMDDATANULL) {
    cout << "Base SOP Handler" << endl;
    ::DCM_DumpElements(&(*message)->dataSet, 1);
  }
  return SRV_NORMAL;
}

CONDITION
MSOPHandler::handleNSetCommand(DUL_PRESENTATIONCONTEXT* ctx,
			       MSG_N_SET_REQ** setRequest,
			       MSG_N_SET_RESP* setResponse,
			       DUL_ASSOCIATESERVICEPARAMETERS* params,
			       MString& directoryName)
{
  //cout << directoryName << endl;

  return 0;
}


//virtual
CONDITION
MSOPHandler::handleNSetDataSet(DUL_PRESENTATIONCONTEXT* ctx,
			       MSG_N_SET_REQ** setRequest,
			       MSG_N_SET_RESP* setResponse,
			       DUL_ASSOCIATESERVICEPARAMETERS* params,
			       MString& directoryName)
{
  //cout << directoryName << endl;

  return 0;
}

CONDITION
MSOPHandler::handleNSetResponse(DUL_PRESENTATIONCONTEXT* ctx,
				MSG_N_SET_RESP** message,
				DUL_ASSOCIATESERVICEPARAMETERS* params)
{
  if ((*message)->dataSetType != DCM_CMDDATANULL) {
    cout << "Base SOP Handler" << endl;
    ::DCM_DumpElements(&(*message)->dataSet, 1);
  }
  return SRV_NORMAL;
}

CONDITION
MSOPHandler::handleNActionCommand(DUL_PRESENTATIONCONTEXT* ctx,
				  MSG_N_ACTION_REQ** actionRequest,
				  MSG_N_ACTION_RESP* actionResponse,
				  DUL_ASSOCIATESERVICEPARAMETERS* params,
				  MString& directoryName)
{
  //cout << directoryName << endl;

  return 0;
}


//virtual
CONDITION
MSOPHandler::handleNActionDataSet(DUL_PRESENTATIONCONTEXT* ctx,
				  MSG_N_ACTION_REQ** actionRequest,
				  MSG_N_ACTION_RESP* actionResponse,
				  DUL_ASSOCIATESERVICEPARAMETERS* params,
				  MString& directoryName)
{
  //cout << directoryName << endl;

  return 0;
}

CONDITION
MSOPHandler::handleNActionResponse(DUL_PRESENTATIONCONTEXT* ctx,
				   MSG_N_ACTION_RESP** message,
				   DUL_ASSOCIATESERVICEPARAMETERS* params)
{
  if ((*message)->dataSetType != DCM_CMDDATANULL) {
    cout << "Base SOP Handler" << endl;
    ::DCM_DumpElements(&(*message)->actionReply, 1);
  }
  return SRV_NORMAL;
}

CONDITION
MSOPHandler::handleNEventCommand(DUL_PRESENTATIONCONTEXT* ctx,
				 MSG_N_EVENT_REPORT_REQ** eventRequest,
				 MSG_N_EVENT_REPORT_RESP* eventResponse,
				 DUL_ASSOCIATESERVICEPARAMETERS* params,
				 MString& directoryName)
{
  //cout << directoryName << endl;

  return 0;
}


//virtual
CONDITION
MSOPHandler::handleNEventDataSet(DUL_PRESENTATIONCONTEXT* ctx,
				 MSG_N_EVENT_REPORT_REQ** eventRequest,
				 MSG_N_EVENT_REPORT_RESP* eventResponse,
				 DUL_ASSOCIATESERVICEPARAMETERS* params,
				 MString& directoryName)
{
  //cout << directoryName << endl;

  return 0;
}

CONDITION
MSOPHandler::handleNEventResponse(DUL_PRESENTATIONCONTEXT* ctx,
				  MSG_N_EVENT_REPORT_RESP** message,
				  DUL_ASSOCIATESERVICEPARAMETERS* params)
{
  mLastStatus = (*message)->status;
  mLastComment = (*message)->errorComment;

  return SRV_NORMAL;
}

int
MSOPHandler::sendCStoreRequest(DUL_ASSOCIATIONKEY** key,
			       DUL_ASSOCIATESERVICEPARAMETERS* params,
			       DCM_OBJECT** storageObject)
{
  MSG_C_STORE_REQ request = { MSG_K_C_STORE_REQ, 0, 0, DCM_CMDDATAIDENTIFIER,
			      0, 0, NULL, 0, "", "", "" };

  MDICOMWrapper w(*storageObject);
  MString sopClass = w.getString(DCM_IDSOPCLASSUID);
  MString sopInstance = w.getString(DCM_IDSOPINSTANCEUID);

  sopClass.safeExport(request.classUID, sizeof(request.classUID));
  sopInstance.safeExport(request.instanceUID, sizeof(request.instanceUID));

  request.messageID = ::SRV_MessageIDOut();
  request.dataSet = *storageObject;

  DCM_OBJECT* commandObject = 0;
  CONDITION cond;
  DUL_PRESENTATIONCONTEXT* ctx;

  ctx = ::SRVPRV_PresentationContext(params, request.classUID);
  if (ctx == 0)
    return -1;

  cond = ::MSG_BuildCommand(&request, &commandObject);
  if (cond != MSG_NORMAL)
    return -1;

  cond = ::SRV_SendCommand(key, ctx, &commandObject);
  if (cond != SRV_NORMAL)
    return -1;

  cond = ::SRV_SendDataSet(key, ctx, &request.dataSet,
			   NULL, NULL, 0);
  if (cond != SRV_NORMAL)
    return -1;

  return 0;
}

int
MSOPHandler::sendCStoreRequest(MDICOMAssociation& association,
	MDICOMWrapper& w)
{
  MSG_C_STORE_REQ request = { MSG_K_C_STORE_REQ, 0, 0, DCM_CMDDATAIDENTIFIER,
			      0, 0, NULL, 0, "", "", "" };

  MString sopClass = w.getString(DCM_IDSOPCLASSUID);
  MString sopInstance = w.getString(DCM_IDSOPINSTANCEUID);

  sopClass.safeExport(request.classUID, sizeof(request.classUID));
  sopInstance.safeExport(request.instanceUID, sizeof(request.instanceUID));

  request.messageID = ::SRV_MessageIDOut();
  request.dataSet = 0;

  DCM_OBJECT* commandObject = 0;
  CONDITION cond;

  cond = ::MSG_BuildCommand(&request, &commandObject);
  if (cond != MSG_NORMAL)
    return -1;

  DUL_PRESENTATIONCONTEXT* ctx = 0;

  DUL_ASSOCIATESERVICEPARAMETERS* params = association.getParameters();
  if (params == 0) {
    // repair
    return -1;
  }

  ctx = ::SRVPRV_PresentationContext(params, request.classUID);
  if (ctx == 0) {
    // repair
    return -1;
  }

  DUL_ASSOCIATIONKEY* key = association.getAssociationKey();
  cond = ::SRV_SendCommand(&key, ctx, &commandObject);

  ::DCM_CloseObject(&commandObject);

  DCM_OBJECT* dataSet = w.getNativeObject();
  if (dataSet == 0)
    return -1;

  cond = ::SRV_SendDataSet(&key, ctx, &dataSet,
			   NULL, NULL, 0);
  if (cond != SRV_NORMAL)
    return -1;

  return 0;
}

int
MSOPHandler::sendCEchoRequest(MDICOMAssociation& association)
{
  MSG_C_ECHO_REQ echoRequest = { MSG_K_C_ECHO_REQ, 0, 0, DCM_CMDDATANULL,
		DICOM_SOPCLASSVERIFICATION };
  echoRequest.messageID = ::SRV_MessageIDOut();
  DCM_OBJECT* commandObject = 0;
  CONDITION cond;

  cond = ::MSG_BuildCommand(&echoRequest, &commandObject);
  if (cond != MSG_NORMAL) {
    // repair
    return -1;
  }

  DUL_ASSOCIATESERVICEPARAMETERS* params = association.getParameters();
  if (params == 0) {
    // repair
    return -1;
  }
  DUL_PRESENTATIONCONTEXT* ctx = ::SRVPRV_PresentationContext(params, echoRequest.classUID);
  if (ctx == 0) {
    // repair
    return -1;
  }

  DUL_ASSOCIATIONKEY* key = association.getAssociationKey();
  cond = ::SRV_SendCommand(&key, ctx, &commandObject);

  ::DCM_CloseObject(&commandObject);

  return 0;
}

CONDITION
MSOPHandler::sendCFindRequest(DUL_ASSOCIATIONKEY** key,
			      DUL_ASSOCIATESERVICEPARAMETERS* params,
			      MSG_C_FIND_REQ* request)
{
  DCM_OBJECT* commandObject = 0;
  CONDITION cond;
  DUL_PRESENTATIONCONTEXT* ctx;

  ctx = ::SRVPRV_PresentationContext(params, request->classUID);
  cond = ::MSG_BuildCommand(request, &commandObject);

  cond = ::SRV_SendCommand(key, ctx, &commandObject);
  cond = ::SRV_SendDataSet(key, ctx, &request->identifier,
			   NULL, NULL, 0);

  return 0;
}

CONDITION
MSOPHandler::sendCFindRequest(DUL_ASSOCIATIONKEY** key,
			      DUL_ASSOCIATESERVICEPARAMETERS* params,
			      const MString& sopClass,
			      DCM_OBJECT** queryObject)
{
  MSG_C_FIND_REQ request = { MSG_K_C_FIND_REQ, 0, 0, DCM_CMDDATAIDENTIFIER,
			     0, NULL, "" };
  sopClass.safeExport(request.classUID, sizeof(request.classUID));

  request.messageID = ::SRV_MessageIDOut();
  request.identifier = *queryObject;

  DCM_OBJECT* commandObject = 0;
  CONDITION cond;
  DUL_PRESENTATIONCONTEXT* ctx;

  ctx = ::SRVPRV_PresentationContext(params, request.classUID);
  cond = ::MSG_BuildCommand(&request, &commandObject);

  cond = ::SRV_SendCommand(key, ctx, &commandObject);
  cond = ::SRV_SendDataSet(key, ctx, &request.identifier,
			   NULL, NULL, 0);

  return 0;
}

int
MSOPHandler::sendCFindRequest(MDICOMAssociation& assoc,
			      const MString& sopClass,
			      MDICOMWrapper& queryObject)
{
  MSG_C_FIND_REQ request = { MSG_K_C_FIND_REQ, 0, 0, DCM_CMDDATAIDENTIFIER,
			     0, NULL, "" };
  sopClass.safeExport(request.classUID, sizeof(request.classUID));

  request.messageID = ::SRV_MessageIDOut();
  request.identifier = queryObject.getNativeObject();

  DCM_OBJECT* commandObject = 0;
  CONDITION cond;
  DUL_PRESENTATIONCONTEXT* ctx = 0;

  DUL_ASSOCIATESERVICEPARAMETERS* params = assoc.getParameters();
  if (params == 0) {
    // repair
    return -1;
  }

  ctx = ::SRVPRV_PresentationContext(params, request.classUID);
  if (ctx == 0) {
    // repair
    return -1;
  }

  DUL_ASSOCIATIONKEY* key = assoc.getAssociationKey();

  cond = ::MSG_BuildCommand(&request, &commandObject);

  cond = ::SRV_SendCommand(&key, ctx, &commandObject);
  cond = ::SRV_SendDataSet(&key, ctx, &request.identifier,
			   NULL, NULL, 0);

  return 0;
}

CONDITION
MSOPHandler::sendCMoveRequest(DUL_ASSOCIATIONKEY** key,
			      DUL_ASSOCIATESERVICEPARAMETERS* params,
			      const MString& sopClass,
			      const MString& destination,
			      DCM_OBJECT** queryObject)
{
  MLogClient l;
  l.log(MLogClient::MLOG_CONVERSATION, "unknown peer",
	"MSOPHandler::sendCMoveRequest", __LINE__,
	"Enter method");

  int rtnStatus = 0;
  MSG_C_MOVE_REQ request = { MSG_K_C_MOVE_REQ, 0, 0, DCM_CMDDATAIDENTIFIER,
			     0, "", NULL, "" };
  DCM_OBJECT* commandObject = 0;
  CONDITION cond;
  DUL_PRESENTATIONCONTEXT* ctx;

  sopClass.safeExport(request.classUID, sizeof(request.classUID));
  destination.safeExport(request.moveDestination,
			 sizeof(request.moveDestination));

  request.messageID = ::SRV_MessageIDOut();
  request.identifier = *queryObject;
  if (request.identifier == 0) {
    l.logTimeStamp(MLogClient::MLOG_ERROR,
		    "MSOPHandler::sendCMoveRequest null request identifier; this is a programming error of some kind");
    rtnStatus = 1;
    goto exit_cmove;
  }

  ctx = ::SRVPRV_PresentationContext(params, request.classUID);
  cond = ::MSG_BuildCommand(&request, &commandObject);
  if (cond != MSG_NORMAL) {
    l.logTimeStamp(MLogClient::MLOG_ERROR,
		    "MSOPHandler::sendCMoveRequest unable to build a command structure; this is a programming error");
    l.logCTNErrorStack(MLogClient::MLOG_ERROR, "");
    rtnStatus = 1;
    goto exit_cmove;
  }

  cond = ::SRV_SendCommand(key, ctx, &commandObject);
  if (cond != SRV_NORMAL) {
    l.logTimeStamp(MLogClient::MLOG_ERROR,
		    "MSOPHandler::sendCMoveRequest unable to send C-Move command to peer");
    l.logCTNErrorStack(MLogClient::MLOG_ERROR, "");
    rtnStatus = 1;
    goto exit_cmove;
  }

  cond = ::SRV_SendDataSet(key, ctx, &request.identifier,
			   NULL, NULL, 0);
  if (cond != SRV_NORMAL) {
    l.logTimeStamp(MLogClient::MLOG_ERROR,
		    "MSOPHandler::sendCMoveRequest unable to send C-Move data-set to peer");
    l.logCTNErrorStack(MLogClient::MLOG_ERROR, "");
    rtnStatus = 1;
    goto exit_cmove;
  }


exit_cmove:
  l.log(MLogClient::MLOG_CONVERSATION, "unknown peer",
	"MSOPHandler::sendCMoveRequest", __LINE__,
	"Exit method");
  return rtnStatus;
}

CONDITION
MSOPHandler::sendNCreateRequest(DUL_ASSOCIATIONKEY** key,
				DUL_ASSOCIATESERVICEPARAMETERS* params,
				const MString& sopClass,
				const MString& sopInstanceUID,
				DCM_OBJECT** createObject)
{
  MSG_N_CREATE_REQ request = { MSG_K_N_CREATE_REQ, 0, 0, DCM_CMDDATAIDENTIFIER,
			     0, "", "" };
  sopClass.safeExport(request.classUID, sizeof(request.classUID));
  sopInstanceUID.safeExport(request.instanceUID, sizeof(request.instanceUID));
  request.conditionalFields = MSG_K_N_CREATEREQ_INSTANCEUID;

  request.messageID = ::SRV_MessageIDOut();
  request.dataSet = *createObject;

  DCM_OBJECT* commandObject = 0;
  CONDITION cond;
  DUL_PRESENTATIONCONTEXT* ctx;

  ctx = ::SRVPRV_PresentationContext(params, request.classUID);
  cond = ::MSG_BuildCommand(&request, &commandObject);

  cond = ::SRV_SendCommand(key, ctx, &commandObject);
  cond = ::SRV_SendDataSet(key, ctx, &request.dataSet,
			   NULL, NULL, 0);

  return 0;
}

int
MSOPHandler::sendNCreateRequest(MDICOMAssociation& association,
				const MString& sopClass,
				const MString& sopInstanceUID,
				MDICOMWrapper& createObject)
{
  MSG_N_CREATE_REQ request = { MSG_K_N_CREATE_REQ, 0, 0, DCM_CMDDATAIDENTIFIER,
			     0, "", "" };

  sopClass.safeExport(request.classUID, sizeof(request.classUID));
  sopInstanceUID.safeExport(request.instanceUID, sizeof(request.instanceUID));
  request.conditionalFields = MSG_K_N_CREATEREQ_INSTANCEUID;

  request.messageID = ::SRV_MessageIDOut();
  request.dataSet = createObject.getNativeObject();

  DCM_OBJECT* commandObject = 0;
  CONDITION cond;

  cond = ::MSG_BuildCommand(&request, &commandObject);
  if (cond != MSG_NORMAL)
    return -1;

  DUL_PRESENTATIONCONTEXT* ctx = 0;

  DUL_ASSOCIATESERVICEPARAMETERS* params = association.getParameters();
  if (params == 0) {
    // repair
    return -1;
  }

  ctx = ::SRVPRV_PresentationContext(params, request.classUID);
  if (ctx == 0) {
    // repair
    return -1;
  }

  DUL_ASSOCIATIONKEY* key = association.getAssociationKey();
  cond = ::SRV_SendCommand(&key, ctx, &commandObject);

  ::DCM_CloseObject(&commandObject);

  DCM_OBJECT* dataSet = createObject.getNativeObject();
  if (dataSet == 0)
    return -1;

  cond = ::SRV_SendDataSet(&key, ctx, &dataSet,
			   NULL, NULL, 0);
  if (cond != SRV_NORMAL)
    return -1;

  return 0;
}

CONDITION
MSOPHandler::sendNSetRequest(DUL_ASSOCIATIONKEY** key,
			     DUL_ASSOCIATESERVICEPARAMETERS* params,
			     const MString& sopClass,
			     const MString& sopInstanceUID,
			     DCM_OBJECT** setObject)
{
  MSG_N_SET_REQ request = { MSG_K_N_SET_REQ, 0, 0, DCM_CMDDATAIDENTIFIER,
			     0, "", "" };
  sopClass.safeExport(request.classUID, sizeof(request.classUID));
  sopInstanceUID.safeExport(request.instanceUID, sizeof(request.instanceUID));

  request.messageID = ::SRV_MessageIDOut();
  request.dataSet = *setObject;

  DCM_OBJECT* commandObject = 0;
  CONDITION cond;
  DUL_PRESENTATIONCONTEXT* ctx;

  ctx = ::SRVPRV_PresentationContext(params, request.classUID);
  cond = ::MSG_BuildCommand(&request, &commandObject);

  cond = ::SRV_SendCommand(key, ctx, &commandObject);
  cond = ::SRV_SendDataSet(key, ctx, &request.dataSet,
			   NULL, NULL, 0);

  return 0;
}

int
MSOPHandler::sendNSetRequest(MDICOMAssociation& association,
				const MString& sopClass,
				const MString& sopInstanceUID,
				MDICOMWrapper& setObject)
{
  MSG_N_SET_REQ request = { MSG_K_N_SET_REQ, 0, 0, DCM_CMDDATAIDENTIFIER,
			     0, "", "" };

  sopClass.safeExport(request.classUID, sizeof(request.classUID));
  sopInstanceUID.safeExport(request.instanceUID, sizeof(request.instanceUID));

  request.messageID = ::SRV_MessageIDOut();
  request.dataSet = setObject.getNativeObject();

  DCM_OBJECT* commandObject = 0;
  CONDITION cond;

  cond = ::MSG_BuildCommand(&request, &commandObject);
  if (cond != MSG_NORMAL)
    return -1;

  DUL_PRESENTATIONCONTEXT* ctx = 0;

  DUL_ASSOCIATESERVICEPARAMETERS* params = association.getParameters();
  if (params == 0) {
    // repair
    return -1;
  }

  ctx = ::SRVPRV_PresentationContext(params, request.classUID);
  if (ctx == 0) {
    // repair
    return -1;
  }

  DUL_ASSOCIATIONKEY* key = association.getAssociationKey();
  cond = ::SRV_SendCommand(&key, ctx, &commandObject);

  ::DCM_CloseObject(&commandObject);

  DCM_OBJECT* dataSet = setObject.getNativeObject();
  if (dataSet == 0)
    return -1;

  cond = ::SRV_SendDataSet(&key, ctx, &dataSet,
			   NULL, NULL, 0);
  if (cond != SRV_NORMAL)
    return -1;

  return 0;
}

CONDITION
MSOPHandler::sendNActionRequest(DUL_ASSOCIATIONKEY** key,
				DUL_ASSOCIATESERVICEPARAMETERS* params,
				const MString& sopClass,
				const MString& sopInstanceUID,
				int actionID,
				DCM_OBJECT** actionObject)
{
  MSG_N_ACTION_REQ request = { MSG_K_N_ACTION_REQ, 0, 0, DCM_CMDDATAIDENTIFIER,
			       actionID, 0, "", "" };
  sopClass.safeExport(request.classUID, sizeof(request.classUID));
  sopInstanceUID.safeExport(request.instanceUID, sizeof(request.instanceUID));

  request.messageID = ::SRV_MessageIDOut();
  request.actionInformation = *actionObject;

  DCM_OBJECT* commandObject = 0;
  CONDITION cond;
  DUL_PRESENTATIONCONTEXT* ctx;

  ctx = ::SRVPRV_PresentationContext(params, request.classUID);
  cond = ::MSG_BuildCommand(&request, &commandObject);

  cond = ::SRV_SendCommand(key, ctx, &commandObject);
  cond = ::SRV_SendDataSet(key, ctx, &request.actionInformation,
			   NULL, NULL, 0);

  return 0;
}

int
MSOPHandler::sendNActionRequest(MDICOMAssociation& association,
				const MString& sopClass,
				const MString& sopInstanceUID,
				int actionID,
				MDICOMWrapper& nactionObject)
{
  MSG_N_ACTION_REQ request = { MSG_K_N_ACTION_REQ, 0, 0, DCM_CMDDATAIDENTIFIER,
			       actionID, 0, "", "" };

  sopClass.safeExport(request.classUID, sizeof(request.classUID));
  sopInstanceUID.safeExport(request.instanceUID, sizeof(request.instanceUID));

  request.messageID = ::SRV_MessageIDOut();
  request.actionInformation = nactionObject.getNativeObject();

  DCM_OBJECT* commandObject = 0;
  CONDITION cond;

  cond = ::MSG_BuildCommand(&request, &commandObject);
  if (cond != MSG_NORMAL)
    return -1;

  DUL_PRESENTATIONCONTEXT* ctx = 0;

  DUL_ASSOCIATESERVICEPARAMETERS* params = association.getParameters();
  if (params == 0) {
    // repair
    return -1;
  }

  ctx = ::SRVPRV_PresentationContext(params, request.classUID);
  if (ctx == 0) {
    // repair
    return -1;
  }

  DUL_ASSOCIATIONKEY* key = association.getAssociationKey();
  cond = ::SRV_SendCommand(&key, ctx, &commandObject);

  ::DCM_CloseObject(&commandObject);

  DCM_OBJECT* dataSet = nactionObject.getNativeObject();
  if (dataSet == 0)
    return -1;

  cond = ::SRV_SendDataSet(&key, ctx, &dataSet,
			   NULL, NULL, 0);
  if (cond != SRV_NORMAL)
    return -1;

  return 0;
}

CONDITION
MSOPHandler::sendNEventReportRequest(DUL_ASSOCIATIONKEY** key,
				     DUL_ASSOCIATESERVICEPARAMETERS* params,
				     const MString& sopClass,
				     const MString& sopInstanceUID,
				     int eventTypeID,
				     DCM_OBJECT** setObject)
{
  MSG_N_EVENT_REPORT_REQ request = { MSG_K_N_EVENT_REPORT_REQ, 0, 0,
				     DCM_CMDDATAIDENTIFIER,
				     eventTypeID,
				     "", "", 0 };
  sopClass.safeExport(request.classUID, sizeof(request.classUID));
  sopInstanceUID.safeExport(request.affectedInstanceUID,
			    sizeof(request.affectedInstanceUID));

  request.messageID = ::SRV_MessageIDOut();
  request.dataSet = *setObject;

  DCM_OBJECT* commandObject = 0;
  CONDITION cond;
  DUL_PRESENTATIONCONTEXT* ctx;

  ctx = ::SRVPRV_PresentationContext(params, request.classUID);
  cond = ::MSG_BuildCommand(&request, &commandObject);

  cond = ::SRV_SendCommand(key, ctx, &commandObject);
  cond = ::SRV_SendDataSet(key, ctx, &request.dataSet,
			   NULL, NULL, 0);

  return 0;
}

CONDITION
MSOPHandler::sendNEventReportRequest(MDICOMAssociation& association,
				     const MString& sopClass,
				     const MString& sopInstanceUID,
				     int eventTypeID,
				     MDICOMWrapper& eventReport)
{
  MSG_N_EVENT_REPORT_REQ request = { MSG_K_N_EVENT_REPORT_REQ, 0, 0,
				     DCM_CMDDATAIDENTIFIER,
				     eventTypeID,
				     "", "", 0 };
  sopClass.safeExport(request.classUID, sizeof(request.classUID));
  sopInstanceUID.safeExport(request.affectedInstanceUID,
			    sizeof(request.affectedInstanceUID));

  request.messageID = ::SRV_MessageIDOut();
  request.dataSet = 0;

  DCM_OBJECT* commandObject = 0;
  CONDITION cond;
  DUL_PRESENTATIONCONTEXT* ctx = 0;

  DUL_ASSOCIATESERVICEPARAMETERS* params = association.getParameters();
  if (params == 0) {
    // repair
    return 1;
  }

  ctx = ::SRVPRV_PresentationContext(params, request.classUID);
  if (ctx == 0) {
    // repair
    return 1;
  }

  DUL_ASSOCIATIONKEY* key = association.getAssociationKey();

  cond = ::MSG_BuildCommand(&request, &commandObject);


  DCM_OBJECT* dataSet = eventReport.getNativeObject();
  if (dataSet == 0)
    return 1;

  cond = ::SRV_SendCommand(&key, ctx, &commandObject);
  cond = ::SRV_SendDataSet(&key, ctx, &dataSet, NULL, NULL, 0);

  return 0;
}

U16
MSOPHandler::lastStatus() const
{
  return mLastStatus;
}

MString
MSOPHandler::lastComment() const
{
  return mLastComment;
}

void
MSOPHandler::addApplicationEntity(const MApplicationEntity& ae)
{
  MString s = ae.title();
  mAEMap[s] = ae;
}
