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
#include "MDICOMReactor.hpp"
#include "MDICOMAssociation.hpp"
#include "MString.hpp"
#include "MSOPHandler.hpp"
#include "MLogClient.hpp"

#include <stdio.h>
#ifdef _WIN32
#include <io.h>
#else
#include <unistd.h>
#endif
#include <fcntl.h>
#include <sys/stat.h>

MDICOMReactor::MDICOMReactor() :
  mStoreAsPart10(false),
  mStorageXferSyntax("")
{
}

MDICOMReactor::MDICOMReactor(const MDICOMReactor& cpy) :
  mStoreAsPart10(cpy.mStoreAsPart10),
  mStorageXferSyntax(cpy.mStorageXferSyntax)
{
}

MDICOMReactor::~MDICOMReactor()
{
}

void
MDICOMReactor::printOn(ostream& s) const
{
  s << "MDICOMReactor";
}

void
MDICOMReactor::streamIn(istream& s)
{
  //s >> this->member;
}

// Non-boilerplate methods follow.

MDICOMReactor::MDICOMReactor(bool storePart10) :
  mStoreAsPart10(storePart10)
{
}
int
MDICOMReactor::registerHandler(MSOPHandler* handler, const MString& SOPClass)
{
  mHandlerMap[SOPClass] = handler; 

  return 0;
}

MSOPHandler*
MDICOMReactor::recallHandler(const MString& SOPClass)
{
  MSOPHandlerMap::iterator i = mHandlerMap.find(SOPClass);
  if (i == mHandlerMap.end())
    return 0;

  return (*i).second;
}

int
MDICOMReactor::processRequests(DUL_ASSOCIATIONKEY** association,
			       DUL_ASSOCIATESERVICEPARAMETERS* service,
			       unsigned long count)
{
  int networkLink = 1;
  int commandServiced = 0;
  CONDITION cond = SRV_NORMAL;
  MSG_TYPE messageType;
  void* message = 0;
  DUL_PRESENTATIONCONTEXTID ctxID = 0;
  DUL_PRESENTATIONCONTEXT* ctx = 0;
  int done = 0;
  int transactionComplete;
  MLogClient logClient;
  char txt[512];

  (void) ::COND_PopCondition(TRUE);
  while((networkLink == 1) && !CTN_ERROR(cond) && !done) {
    logClient.log(MLogClient::MLOG_VERBOSE,
		  service->callingAPTitle,
		  "MDICOMReactor::processRequests",
		  __LINE__,
		  "About to poll for next DICOM Command");

    cond = ::SRV_ReceiveCommand(association, service, DUL_BLOCK, 0, &ctxID,
				NULL, &messageType, &message);
    logClient.log(MLogClient::MLOG_VERBOSE,
		  service->callingAPTitle,
		  "MDICOMReactor::processRequests",
		  __LINE__,
		  "Received command/status from CTN SRV Facility");

    if (cond == SRV_PEERREQUESTEDRELEASE) {
      logClient.log(MLogClient::MLOG_VERBOSE,
		    service->callingAPTitle,
		    "MDICOMReactor::processRequests",
		    __LINE__,
		    "Peer requested release");
      networkLink = 0;
      (void) ::DUL_AcknowledgeRelease(association);
      logClient.log(MLogClient::MLOG_VERBOSE,
		    service->callingAPTitle,
		    "MDICOMReactor::processRequests",
		    __LINE__,
		    "Peer request release acknowledged");
      (void) ::DUL_DropAssociation(association);
      (void) ::COND_PopCondition(TRUE);
    } else if (cond == SRV_PEERABORTEDASSOCIATION) {
      logClient.log(MLogClient::MLOG_VERBOSE,
		    service->callingAPTitle,
		    "MDICOMReactor::processRequests",
		    __LINE__,
		    "Peer aborted association");
      logClient.logCTNErrorStack(MLogClient::MLOG_VERBOSE,
	"DICOM peer aborted association");
      networkLink = 0;
    } else if (cond != SRV_NORMAL) {
      CONDITION temp = ::COND_TopCondition(&temp, txt, sizeof(txt));
      while (temp != COND_NORMAL) {
	logClient.log(MLogClient::MLOG_ERROR,
		    service->callingAPTitle,
		    "MDICOMReactor::processRequests",
		    __LINE__,
		    MString("Error condition: ") + txt);
	::COND_PopCondition(FALSE);
	temp = ::COND_TopCondition(&temp, txt, sizeof(txt));
      }
      cond = 0;
      (void) ::DUL_DropAssociation(association);
      networkLink = 0;
    } else {
      ctx = (DUL_PRESENTATIONCONTEXT*) ::LST_Head(&service->acceptedPresentationContext);
      if (ctx != NULL)
	(void) ::LST_Position(&service->acceptedPresentationContext, ctx);
      commandServiced = 0;
      while(ctx != NULL) {
	if (ctx->presentationContextID == ctxID) {
	  if (commandServiced) {
	    cerr << "Context ID Repeat in processRequests " << ctxID << endl;;
	    ::exit(1);
	  } else {
	    transactionComplete = this->handleRequest(association, service,
						      ctx, messageType,
						      &message);
	    CTN_FREE(message);
	    message = 0;
	    commandServiced = 1;
	  }
	}
	ctx = (DUL_PRESENTATIONCONTEXT*) ::LST_Next(&service->acceptedPresentationContext);
      }
    }
    if (count > 0 && transactionComplete) {
      count--;
      if (count == 0)
	done = 1;
    }
    (void) ::COND_PopCondition(TRUE);
  }
  logClient.log(MLogClient::MLOG_VERBOSE,
		service->callingAPTitle,
		"MDICOMReactor::processRequests",
		__LINE__,
		"About to leave MDICOMReactor::processRequests");

  return 0;
}

int
MDICOMReactor::processRequests(MDICOMAssociation& assoc,
			       unsigned long count)
{
  DUL_ASSOCIATIONKEY* key = assoc.getAssociationKey();
  DUL_ASSOCIATESERVICEPARAMETERS* service = assoc.getParameters();
  return this->processRequests(&key, service, count);
}

void
MDICOMReactor::storeAsPart10(bool flag)
{
 mStoreAsPart10 = flag;
}


int
MDICOMReactor::handleRequest(DUL_ASSOCIATIONKEY** association,
			     DUL_ASSOCIATESERVICEPARAMETERS* service,
			     DUL_PRESENTATIONCONTEXT* ctx,
			     MSG_TYPE messageType,
			     void** message)
{
  MSOPHandler* h;
  h = mHandlerMap[ctx->abstractSyntax];
  int transactionComplete = 1;
  MLogClient logClient;
  char txt[1024];

  sprintf(txt, "About to handle request for message of type: %d",
	  (int)messageType);

  logClient.log(MLogClient::MLOG_VERBOSE,
		service->callingAPTitle,
		"MDICOMReactor::handleRequest",
		__LINE__,
		txt);

  switch (messageType) {
  case MSG_K_C_ECHO_REQ:
    h->handleCEcho(association, ctx, (MSG_C_ECHO_REQ**)message);
    break;
  case MSG_K_C_ECHO_RESP:
    h->handleCEchoResponse(ctx, (MSG_C_ECHO_RESP**)message, service);
    break;
  case MSG_K_C_STORE_REQ:
    this->handleCStore(h, association, ctx, (MSG_C_STORE_REQ**)message,
		       service);
    break;
  case MSG_K_C_STORE_RESP:
    this->handleCStoreResponse(h, association, ctx,
			       (MSG_C_STORE_RESP**)message, service);
    break;
  case MSG_K_C_FIND_REQ:
    this->handleCFind(h, association, ctx, (MSG_C_FIND_REQ**)message,
		      service);
    break;
  case MSG_K_C_FIND_RESP:
    transactionComplete = this->handleCFindResponse(h, association, ctx,
						    (MSG_C_FIND_RESP**)message,
						    service);
    break;
  case MSG_K_C_MOVE_REQ:
    this->handleCMove(h, association, ctx, (MSG_C_MOVE_REQ**)message,
		      service);
    break;
  case MSG_K_C_MOVE_RESP:
    transactionComplete = this->handleCMoveResponse(h, association, ctx,
						    (MSG_C_MOVE_RESP**)message,
						    service);
    break;
  case MSG_K_N_CREATE_REQ:
    this->handleNCreate(h, association, ctx, (MSG_N_CREATE_REQ**)message,
			service);
    break;
  case MSG_K_N_CREATE_RESP:
    this->handleNCreateResponse(h, association, ctx,
				(MSG_N_CREATE_RESP**)message, service);
    break;
  case MSG_K_N_SET_REQ:
    this->handleNSet(h, association, ctx, (MSG_N_SET_REQ**)message,
		     service);
    break;
  case MSG_K_N_SET_RESP:
    this->handleNSetResponse(h, association, ctx,
			     (MSG_N_SET_RESP**)message, service);
    break;
  case MSG_K_N_ACTION_REQ:
    this->handleNActionRequest(h, association, ctx,
			       (MSG_N_ACTION_REQ**)message, service);
    break;
  case MSG_K_N_ACTION_RESP:
    this->handleNActionResponse(h, association, ctx,
				(MSG_N_ACTION_RESP**)message, service);
    break;
  case MSG_K_N_EVENT_REPORT_REQ:
    this->handleNEventReport(h, association, ctx,
			     (MSG_N_EVENT_REPORT_REQ**)message, service);
    break;
  case MSG_K_N_EVENT_REPORT_RESP:
    this->handleNEventReportResponse(h, association, ctx,
				     (MSG_N_EVENT_REPORT_RESP**)message,
				     service);
  }
  return transactionComplete;
}

// virtual
int
MDICOMReactor::handleCEcho(DUL_ASSOCIATIONKEY** association,
			 DUL_PRESENTATIONCONTEXT* ctx,
			 MSG_C_ECHO_REQ ** message)
{
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

extern "C" {
CONDITION SRVPRV_ReadNextPDV(DUL_ASSOCIATIONKEY** association,
			     DUL_BLOCKOPTIONS block,
			     int timeout,
			     DUL_PDV* pdv);
}

int
MDICOMReactor::handleCStore(MSOPHandler* handler,
			    DUL_ASSOCIATIONKEY** association,
			    DUL_PRESENTATIONCONTEXT* ctx,
			    MSG_C_STORE_REQ ** message,
			    DUL_ASSOCIATESERVICEPARAMETERS* params)
{
  MSG_C_STORE_RESP storeResponse;
  memset(&storeResponse, 0, sizeof(storeResponse));
  storeResponse.type = MSG_K_C_STORE_RESP;
  mStorageXferSyntax = ctx->acceptedTransferSyntax;
  ::strcpy(storeResponse.classUID, (*message)->classUID);
  ::strcpy(storeResponse.instanceUID, (*message)->instanceUID);
  storeResponse.conditionalFields = MSG_K_C_STORERESP_CLASSUID |
		MSG_K_C_STORERESP_INSTANCEUID;
  storeResponse.dataSetType = DCM_CMDDATANULL;
  storeResponse.messageIDRespondedTo = (*message)->messageID;

  MString fileName("image.dcm");
  handler->handleCStoreCommand(ctx, (MSG_C_STORE_REQ**)message,
			       &storeResponse,
			       params, fileName);

  char fileExport[1024];
  fileName.safeExport(fileExport, sizeof(fileExport));
  int fd = -1;

  MLogClient logClient;
  logClient.log(MLogClient::MLOG_VERBOSE,
		params->callingAPTitle,
		"MDICOMReactor::handleCStore",
		__LINE__,
		"C-Store command; file stored in " + fileName);

  if (::strlen(fileExport) > 0) {
#ifdef _WIN32
    fd = ::_open(fileExport, O_CREAT | O_WRONLY | O_TRUNC | O_BINARY,
		_S_IREAD | _S_IWRITE);
#else
    fd = ::open(fileExport, O_CREAT | O_WRONLY | O_TRUNC, 0666);
#endif
    if (fd < 0) {
      ::perror(fileExport);
      //::exit(1);
    }
  }

  unsigned short sendStatus = 0x0000;
  if ((fd > 0) && mStoreAsPart10) {
    DCM_FILE_META fileMeta;
    ::memset(&fileMeta, 0, sizeof(fileMeta));
    this->setFileMeta(&fileMeta, *message);
    int metaStatus = this->writePart10MetaHeader(fd, &fileMeta);
    if (metaStatus != 0)
      fd = -1;
  }

  if (fd < 0) {
    sendStatus = MSG_K_C_STORE_OUTOFRESOURCES;
    storeResponse.conditionalFields |= MSG_K_C_STORERESP_ERRORCOMMENT;
    ::strcpy(storeResponse.errorComment,
		"Storage Service unable to create local file");
    logClient.log(MLogClient::MLOG_WARN,
		  params->callingAPTitle,
		  "MDICOMReactor::handleCStore",
		  __LINE__,
		  "Storage Service unable to create local file: " + fileName);


  }
  int done = 0;
  CONDITION cond;
  while (!done) {
    DUL_PDV pdv;
    cond = ::SRVPRV_ReadNextPDV(association, DUL_BLOCK, 0, &pdv);
    if (cond != SRV_NORMAL) {
      ::COND_DumpConditions();
      ::exit(1);
    }
    if (pdv.pdvType != DUL_DATASETPDV) {
      cerr << "Unxpected PDV type" << endl;
      ::exit(1);
    }
    if (sendStatus == 0) {
      if (write(fd, pdv.data, pdv.fragmentLength) != (int)pdv.fragmentLength)
	sendStatus = MSG_K_C_STORE_OUTOFRESOURCES;
    }
    if (pdv.lastPDV)
      done++;
  }
  if (fd > 0)
    ::close(fd);

  storeResponse.status = sendStatus;
#if 0
  DCM_OBJECT* obj = 0;

  if (sendStatus == 0x0000) {
    unsigned long opt = DCM_ORDERLITTLEENDIAN | DCM_FORMATCONVERSION;
    if (mStoreAsPart10) {
      opt = DCM_PART10FILE | DCM_FORMATCONVERSION;
    }
    cond = ::DCM_OpenFile(fileExport, opt, &obj);
    if (cond != DCM_NORMAL) {
      logClient.log(MLogClient::MLOG_ERROR,
		    params->callingAPTitle,
		    "MDICOMReactor::handleCStore",
		    __LINE__,
		    "Storage Service unable to open local file: " + fileName);
      ::COND_DumpConditions();
    }
  }
  (*message)->dataSet = obj;
#endif
  handler->handleCStoreDataSet(ctx, message,
			       &storeResponse,
			       params, fileName);


  DCM_OBJECT* commandObject = 0;
  cond = ::MSG_BuildCommand(&storeResponse, &commandObject);
  //MASSERT (cond == MSG_NORMAL);
  cond = ::SRV_SendCommand(association, ctx, &commandObject);
  //MASSERT (cond == SRV_NORMAL);
  (void) ::DCM_CloseObject(&commandObject);
  //(void) ::DCM_CloseObject(&obj);

  return 0;
}

int
MDICOMReactor::handleCStoreResponse(MSOPHandler* handler,
				   DUL_ASSOCIATIONKEY** association,
				   DUL_PRESENTATIONCONTEXT* ctx,
				   MSG_C_STORE_RESP** message,
				   DUL_ASSOCIATESERVICEPARAMETERS* params)
{
  handler->handleCStoreResponse(ctx, message, params);

  return 0;
}

int
MDICOMReactor::handleCFind(MSOPHandler* handler,
			   DUL_ASSOCIATIONKEY** association,
			   DUL_PRESENTATIONCONTEXT* ctx,
			   MSG_C_FIND_REQ ** message,
			   DUL_ASSOCIATESERVICEPARAMETERS* params)
{
  CONDITION cond;
  char classUID[128];
  MLogClient logClient;

  ::strcpy(classUID, (*message)->classUID);
  logClient.log(MLogClient::MLOG_VERBOSE,
		  params->callingAPTitle,
		  "MDICOMReactor::handleCFind",
		  __LINE__,
		  "About to poll for Data Set that completes C-Find Request");

  cond = ::SRV_ReceiveDataSet(association, ctx, DUL_BLOCK, 0, ".",
				&(*message)->identifier);
  if (cond != SRV_NORMAL) {
    logClient.log(MLogClient::MLOG_ERROR,
		  params->callingAPTitle,
		  "MDICOMReactor::handleCFind",
		  __LINE__,
		  "Unable to to read Data Set that is part of C-Find Request");
    logClient.log(MLogClient::MLOG_ERROR,
		  params->callingAPTitle,
		  "MDICOMReactor::handleCFind",
		  __LINE__,
		  "Application is about to exit");
    ::COND_DumpConditions();
    exit(1);
  }


  char queryLevelString[128];
  DCM_ELEMENT queryLevelElement = {
	DCM_IDQUERYLEVEL, DCM_CS, "", 1, sizeof(queryLevelString),
	queryLevelString};

  cond = ::DCM_ParseObject(&(*message)->identifier, &queryLevelElement, 1,
			   NULL, 0, NULL);
  if (cond != DCM_NORMAL) {
    ::COND_PopCondition(TRUE);
    queryLevelString[0] = '\0';
  }

  MSG_C_FIND_RESP findResponse;
  memset(&findResponse, 0, sizeof(findResponse));
  findResponse.type = MSG_K_C_FIND_RESP;
  findResponse.messageIDRespondedTo = (*message)->messageID;
  findResponse.conditionalFields = MSG_K_C_FINDRESP_CLASSUID;
  cond = ::DCM_CreateObject(&findResponse.identifier, 0);
  if (cond != DCM_NORMAL) {
    COND_DumpConditions();
    ::exit(1);
  }

  handler->handleCFindCommand(ctx, (MSG_C_FIND_REQ**)message,
			      &findResponse,
			      params, queryLevelString);

  int done = 0;
  int index = 1;
  while (!done) {
    findResponse.dataSetType = DCM_CMDDATANULL;
    findResponse.status = 0xfff;
    cond = ::DCM_CreateObject(&findResponse.identifier, 0);
    if (cond != DCM_NORMAL) {
      COND_DumpConditions();
      ::exit(1);
    }
    cond = handler->returnCFindDataSet(ctx, (MSG_C_FIND_REQ**)message,
				       &findResponse,
				       params, queryLevelString, index);
    if (cond == SRV_NORMAL) {
      MSG_STATUS_DESCRIPTION statusDescription;
      cond = MSG_StatusLookup(findResponse.status, MSG_K_C_FIND_RESP,
			      &statusDescription);
      if (statusDescription.statusClass != MSG_K_CLASS_PENDING)
	done = 1;
    } else {
      findResponse.dataSetType = DCM_CMDDATANULL;
    }

    findResponse.conditionalFields |= MSG_K_C_FINDRESP_CLASSUID;
    (void) ::strcpy(findResponse.classUID, classUID);

    DCM_OBJECT* responseObject = 0;
    cond = ::MSG_BuildCommand(&findResponse, &responseObject);
    if (cond != MSG_NORMAL) {
      COND_DumpConditions();
      ::exit(1);
    }
    cond = ::SRV_SendCommand(association, ctx, &responseObject);
    if (cond != SRV_NORMAL) {
      COND_DumpConditions();
      ::exit(1);
    }

    if (findResponse.dataSetType != DCM_CMDDATANULL) {
      cond = ::SRV_SendDataSet(association, ctx, &findResponse.identifier,
			       NULL, NULL, 0);
      if (cond != SRV_NORMAL) {
	COND_DumpConditions();
	::exit(1);
      }
    }
    index++;
    ::DCM_CloseObject(&findResponse.identifier);
  }

  return 0;
}

int
MDICOMReactor::handleCFindResponse(MSOPHandler* handler,
		      DUL_ASSOCIATIONKEY** association,
		      DUL_PRESENTATIONCONTEXT* ctx,
		      MSG_C_FIND_RESP** message,
		      DUL_ASSOCIATESERVICEPARAMETERS* params)
{
  CONDITION cond;
  int done = 0;
  int index = 1;

  {
    if ((*message)->dataSetType != DCM_CMDDATANULL) {
      cond = ::SRV_ReceiveDataSet(association, ctx, DUL_BLOCK, 0, ".",
				&(*message)->identifier);
      if (cond != SRV_NORMAL) {
	::COND_DumpConditions();
	::exit(1);
      }
    }
    handler->handleCFindResponse(ctx, message, params, "", index);

    MSG_STATUS_DESCRIPTION statusDescription;
    ::MSG_StatusLookup((*message)->status, MSG_K_C_FIND_RESP,
		       &statusDescription);
    if (statusDescription.statusClass != MSG_K_CLASS_PENDING)
      done = 1;
  }
  return done;
}

int
MDICOMReactor::handleCMove(MSOPHandler* handler,
			   DUL_ASSOCIATIONKEY** association,
			   DUL_PRESENTATIONCONTEXT* ctx,
			   MSG_C_MOVE_REQ ** message,
			   DUL_ASSOCIATESERVICEPARAMETERS* params)
{
  CONDITION cond;
  char classUID[128];

  ::strcpy(classUID, (*message)->classUID);

  cond = ::SRV_ReceiveDataSet(association, ctx, DUL_BLOCK, 0, ".",
				&(*message)->identifier);
  if (cond != SRV_NORMAL) {
    ::COND_DumpConditions();
    exit(1);
  }

  char queryLevelString[128];
  DCM_ELEMENT queryLevelElement = {
	DCM_IDQUERYLEVEL, DCM_CS, "", 1, sizeof(queryLevelString),
	queryLevelString};

  cond = ::DCM_ParseObject(&(*message)->identifier, &queryLevelElement, 1,
			   NULL, 0, NULL);
  if (cond != DCM_NORMAL) {
    ::COND_PopCondition(TRUE);
    queryLevelString[0] = '\0';
  }

  MSG_C_MOVE_RESP moveResponse;
  memset(&moveResponse, 0, sizeof(moveResponse));
  moveResponse.type = MSG_K_C_MOVE_RESP;
  moveResponse.messageIDRespondedTo = (*message)->messageID;
  moveResponse.conditionalFields = MSG_K_C_MOVERESP_CLASSUID;

  handler->handleCMoveCommand(ctx, message,
			      &moveResponse,
			      params, queryLevelString);

  int done = 0;
  int index = 1;
  while (!done) {
    moveResponse.dataSetType = DCM_CMDDATANULL;
    moveResponse.status = 0xfff;
    cond = handler->returnCMoveStatus(ctx, message,
				       &moveResponse,
				       params, queryLevelString, index);
    if (cond == SRV_NORMAL) {
      MSG_STATUS_DESCRIPTION statusDescription;
      cond = MSG_StatusLookup(moveResponse.status, MSG_K_C_MOVE_RESP,
			      &statusDescription);
      if (statusDescription.statusClass != MSG_K_CLASS_PENDING)
	done = 1;
    } else {
      moveResponse.dataSetType = DCM_CMDDATANULL;
    }

    moveResponse.conditionalFields |= MSG_K_C_MOVERESP_CLASSUID;
    (void) ::strcpy(moveResponse.classUID, classUID);

    DCM_OBJECT* responseObject = 0;
    cond = ::MSG_BuildCommand(&moveResponse, &responseObject);
    if (cond != MSG_NORMAL) {
      COND_DumpConditions();
      ::exit(1);
    }
    cond = ::SRV_SendCommand(association, ctx, &responseObject);
    if (cond != SRV_NORMAL) {
      COND_DumpConditions();
      ::exit(1);
    }

    index++;
  }

  return 0;
}

int
MDICOMReactor::handleCMoveResponse(MSOPHandler* handler,
		      DUL_ASSOCIATIONKEY** association,
		      DUL_PRESENTATIONCONTEXT* ctx,
		      MSG_C_MOVE_RESP** message,
		      DUL_ASSOCIATESERVICEPARAMETERS* params)
{
  int done = 0;
  int index = 1;

  {
    handler->handleCMoveResponse(ctx, message, params, "", index);

    MSG_STATUS_DESCRIPTION statusDescription;
    ::MSG_StatusLookup((*message)->status, MSG_K_C_MOVE_RESP,
		       &statusDescription);
    if (statusDescription.statusClass != MSG_K_CLASS_PENDING)
      done = 1;
  }
  return done;
}


int
MDICOMReactor::handleNCreate(MSOPHandler* handler,
			     DUL_ASSOCIATIONKEY** association,
			     DUL_PRESENTATIONCONTEXT* ctx,
			     MSG_N_CREATE_REQ ** message,
			     DUL_ASSOCIATESERVICEPARAMETERS* params)
{
  MSG_N_CREATE_RESP createResponse;
  memset(&createResponse, 0, sizeof(createResponse));
  createResponse.type = MSG_K_N_CREATE_RESP;
  createResponse.conditionalFields =0;
  createResponse.dataSetType = DCM_CMDDATANULL;
  createResponse.dataSet = 0;
  createResponse.status = MSG_K_SUCCESS;
  createResponse.messageIDRespondedTo = (*message)->messageID;
  CONDITION cond = 0;

  MString directoryName(".");
  (*message)->dataSet = 0;
  handler->handleNCreateCommand(ctx,
				(MSG_N_CREATE_REQ**)message,
				&createResponse,
				params, directoryName);

  if ((*message)->dataSetType == DCM_CMDDATANULL) {
    (*message)->dataSet = 0;
  } else {
    char directoryText[1024];
    directoryName.safeExport(directoryText, sizeof(directoryText));
    cond = ::SRV_ReceiveDataSet(association, ctx, DUL_BLOCK, 0, directoryText,
				&(*message)->dataSet);
    if (cond != SRV_NORMAL) {
      createResponse.status = MSG_K_PROCESSINGFAILURE;
    }
  }

  if (createResponse.status == MSG_K_SUCCESS) {
    cond = ::DCM_CreateObject(&createResponse.dataSet, 0);
    if (cond != DCM_NORMAL) {
      createResponse.status = MSG_K_PROCESSINGFAILURE;
    }
  }

  handler->handleNCreateDataSet(ctx, (MSG_N_CREATE_REQ**)message,
				&createResponse,
				params, directoryName);

  DCM_OBJECT* responseObject = 0;
  cond = ::MSG_BuildCommand(&createResponse, &responseObject);
  //MASSERT (cond == MSG_NORMAL);
  cond = ::SRV_SendCommand(association, ctx, &responseObject);
  (void)::DCM_CloseObject(&responseObject);
  //MASSERT (cond == SRV_NORMAL);

  if (createResponse.dataSetType != DCM_CMDDATANULL) {
    cond = ::SRV_SendDataSet(association, ctx, &createResponse.dataSet,
			     NULL, NULL, 0);
    //(void) ::DCM_CloseObject(&createResponse.dataSet);
    //MASSERT (cond == SRV_NORMAL);
  }
  (void) ::DCM_CloseObject(&createResponse.dataSet);

  return 0;
}

int
MDICOMReactor::handleNCreateResponse(MSOPHandler* handler,
				     DUL_ASSOCIATIONKEY** association,
				     DUL_PRESENTATIONCONTEXT* ctx,
				     MSG_N_CREATE_RESP** message,
				     DUL_ASSOCIATESERVICEPARAMETERS* params)
{
  CONDITION cond;

  if ((*message)->dataSetType != DCM_CMDDATANULL) {
    cond = ::SRV_ReceiveDataSet(association, ctx, DUL_BLOCK, 0, ".",
				&(*message)->dataSet);
    if (cond != SRV_NORMAL) {
      ::COND_DumpConditions();
      ::exit(1);
    }
  }
  handler->handleNCreateResponse(ctx, message, params);

  return 1;
}

int
MDICOMReactor::handleNSet(MSOPHandler* handler,
			  DUL_ASSOCIATIONKEY** association,
			  DUL_PRESENTATIONCONTEXT* ctx,
			  MSG_N_SET_REQ ** message,
			  DUL_ASSOCIATESERVICEPARAMETERS* params)
{
  MSG_N_SET_RESP setResponse;
  memset(&setResponse, 0, sizeof(setResponse));
  setResponse.type = MSG_K_N_SET_RESP;
  setResponse.conditionalFields =0;
  setResponse.dataSetType = DCM_CMDDATANULL;
  setResponse.dataSet = 0;
  setResponse.messageIDRespondedTo = (*message)->messageID;
  setResponse.status = MSG_K_SUCCESS;
  CONDITION cond = 0;

  MString directoryName(".");
  (*message)->dataSet = 0;
  handler->handleNSetCommand(ctx,
			     (MSG_N_SET_REQ**)message,
			     &setResponse,
			     params, directoryName);

  if ((*message)->dataSetType == DCM_CMDDATANULL) {
    (*message)->dataSet = 0;
  } else {
    char directoryText[1024];
    directoryName.safeExport(directoryText, sizeof(directoryText));
    cond = ::SRV_ReceiveDataSet(association, ctx, DUL_BLOCK, 0, directoryText,
				&(*message)->dataSet);
    if (cond != SRV_NORMAL) {
      setResponse.status = MSG_K_PROCESSINGFAILURE;
    }
  }

  if (setResponse.status == MSG_K_SUCCESS) {
    cond = ::DCM_CreateObject(&setResponse.dataSet, 0);
    if (cond != DCM_NORMAL) {
      setResponse.status = MSG_K_PROCESSINGFAILURE;
    }
  }

  handler->handleNSetDataSet(ctx, (MSG_N_SET_REQ**)message,
			     &setResponse,
			     params, directoryName);

  DCM_OBJECT* responseObject = 0;
  cond = ::MSG_BuildCommand(&setResponse, &responseObject);
  //MASSERT (cond == MSG_NORMAL);
  cond = ::SRV_SendCommand(association, ctx, &responseObject);
  (void)::DCM_CloseObject(&responseObject);
  //MASSERT (cond == SRV_NORMAL);

  if (setResponse.dataSetType != DCM_CMDDATANULL) {
    cond = ::SRV_SendDataSet(association, ctx, &setResponse.dataSet,
			     NULL, NULL, 0);
    //(void) ::DCM_CloseObject(&setResponse.dataSet);
    //MASSERT (cond == SRV_NORMAL);
  }
  (void) ::DCM_CloseObject(&setResponse.dataSet);

  return 0;
}


int
MDICOMReactor::handleNSetResponse(MSOPHandler* handler,
				  DUL_ASSOCIATIONKEY** association,
				  DUL_PRESENTATIONCONTEXT* ctx,
				  MSG_N_SET_RESP** message,
				  DUL_ASSOCIATESERVICEPARAMETERS* params)
{
  CONDITION cond;

  if ((*message)->dataSetType != DCM_CMDDATANULL) {
    cond = ::SRV_ReceiveDataSet(association, ctx, DUL_BLOCK, 0, ".",
				&(*message)->dataSet);
    if (cond != SRV_NORMAL) {
      ::COND_DumpConditions();
      ::exit(1);
    }
  }
  handler->handleNSetResponse(ctx, message, params);

  return 1;
}

int
MDICOMReactor::handleNActionRequest(MSOPHandler* handler,
				    DUL_ASSOCIATIONKEY** association,
				    DUL_PRESENTATIONCONTEXT* ctx,
				    MSG_N_ACTION_REQ ** message,
				    DUL_ASSOCIATESERVICEPARAMETERS* params)
{
  MSG_N_ACTION_RESP actionResponse;
  memset(&actionResponse, 0, sizeof(actionResponse));
  actionResponse.type = MSG_K_N_ACTION_RESP;
  actionResponse.conditionalFields =0;
  actionResponse.dataSetType = DCM_CMDDATANULL;
  actionResponse.actionReply = 0;
  actionResponse.messageIDRespondedTo = (*message)->messageID;
  actionResponse.status = MSG_K_SUCCESS;
  CONDITION cond = 0;

  MString directoryName(".");
  (*message)->actionInformation = 0;
  handler->handleNActionCommand(ctx,
				(MSG_N_ACTION_REQ**)message,
				&actionResponse,
				params, directoryName);

  if ((*message)->dataSetType == DCM_CMDDATANULL) {
    (*message)->actionInformation = 0;
  } else {
    char directoryText[1024];
    directoryName.safeExport(directoryText, sizeof(directoryText));
    cond = ::SRV_ReceiveDataSet(association, ctx, DUL_BLOCK, 0, directoryText,
				&(*message)->actionInformation);
    if (cond != SRV_NORMAL) {
      actionResponse.status = MSG_K_PROCESSINGFAILURE;
    }
  }

  if (actionResponse.status == MSG_K_SUCCESS) {
    cond = ::DCM_CreateObject(&actionResponse.actionReply, 0);
    if (cond != DCM_NORMAL) {
      actionResponse.status = MSG_K_PROCESSINGFAILURE;
    }
  }

  handler->handleNActionDataSet(ctx, (MSG_N_ACTION_REQ**)message,
				&actionResponse,
				params, directoryName);

  DCM_OBJECT* responseObject = 0;
  cond = ::MSG_BuildCommand(&actionResponse, &responseObject);
  //MASSERT (cond == MSG_NORMAL);
  cond = ::SRV_SendCommand(association, ctx, &responseObject);
  (void)::DCM_CloseObject(&responseObject);
  //MASSERT (cond == SRV_NORMAL);

  if (actionResponse.dataSetType != DCM_CMDDATANULL) {
    cond = ::SRV_SendDataSet(association, ctx,
			     &actionResponse.actionReply,
			     NULL, NULL, 0);
    //(void) ::DCM_CloseObject(&setResponse.dataSet);
    //MASSERT (cond == SRV_NORMAL);
  }
  (void) ::DCM_CloseObject(&actionResponse.actionReply);

  return 0;
}


int
MDICOMReactor::handleNActionResponse(MSOPHandler* handler,
				     DUL_ASSOCIATIONKEY** association,
				     DUL_PRESENTATIONCONTEXT* ctx,
				     MSG_N_ACTION_RESP** message,
				     DUL_ASSOCIATESERVICEPARAMETERS* params)
{
  CONDITION cond;

  if ((*message)->dataSetType != DCM_CMDDATANULL) {
    cond = ::SRV_ReceiveDataSet(association, ctx, DUL_BLOCK, 0, ".",
				&(*message)->actionReply);
    if (cond != SRV_NORMAL) {
      ::COND_DumpConditions();
      ::exit(1);
    }
  }
  handler->handleNActionResponse(ctx, message, params);

  return 1;
}

int
MDICOMReactor::handleNEventReport(MSOPHandler* handler,
				  DUL_ASSOCIATIONKEY** association,
				  DUL_PRESENTATIONCONTEXT* ctx,
				  MSG_N_EVENT_REPORT_REQ ** message,
				  DUL_ASSOCIATESERVICEPARAMETERS* params)
{
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_VERBOSE,
		params->callingAPTitle,
		"MDICOMReactor::handleNEventReport", __LINE__,
		"N-Event Report Request received");

  MSG_N_EVENT_REPORT_RESP eventResponse;
  memset(&eventResponse, 0, sizeof(eventResponse));
  eventResponse.type = MSG_K_N_EVENT_REPORT_RESP;
  eventResponse.conditionalFields =0;
  eventResponse.dataSetType = DCM_CMDDATANULL;
  eventResponse.dataSet = 0;
  eventResponse.messageIDRespondedTo = (*message)->messageID;
  eventResponse.status = MSG_K_SUCCESS;
  CONDITION cond = 0;

  MString directoryName(".");
  (*message)->dataSet = 0;
  handler->handleNEventCommand(ctx,
			       (MSG_N_EVENT_REPORT_REQ**)message,
			       &eventResponse,
			       params, directoryName);

  if ((*message)->dataSetType == DCM_CMDDATANULL) {
    (*message)->dataSet = 0;
  } else {
    char directoryText[1024];
    directoryName.safeExport(directoryText, sizeof(directoryText));
    cond = ::SRV_ReceiveDataSet(association, ctx, DUL_BLOCK, 0, directoryText,
				&(*message)->dataSet);
    if (cond != SRV_NORMAL) {
      logClient.log(MLogClient::MLOG_ERROR, params->callingAPTitle,
		"MDICOMReactor::handleNEventReport", __LINE__,
		"Failed to receive Data Set for N-Event Report");
      eventResponse.status = MSG_K_PROCESSINGFAILURE;
    }
  }

  if (eventResponse.status == MSG_K_SUCCESS) {
    cond = ::DCM_CreateObject(&eventResponse.dataSet, 0);
    if (cond != DCM_NORMAL) {
      eventResponse.status = MSG_K_PROCESSINGFAILURE;
    }
  }

  logClient.log(MLogClient::MLOG_VERBOSE, params->callingAPTitle,
		"MDICOMReactor::handleNEventReport", __LINE__,
		"About to invoke handler for N-Event report");

  handler->handleNEventDataSet(ctx, (MSG_N_EVENT_REPORT_REQ**)message,
			     &eventResponse,
			     params, directoryName);

  DCM_OBJECT* responseObject = 0;
  cond = ::MSG_BuildCommand(&eventResponse, &responseObject);
  //MASSERT (cond == MSG_NORMAL);
  cond = ::SRV_SendCommand(association, ctx, &responseObject);
  if (cond != SRV_NORMAL) {
    logClient.log(MLogClient::MLOG_ERROR, params->callingAPTitle,
		"MDICOMReactor::handleNEventReport", __LINE__,
		"Error when sending N-Event Response command");
  }
  (void)::DCM_CloseObject(&responseObject);
  //MASSERT (cond == SRV_NORMAL);

  if (eventResponse.dataSetType != DCM_CMDDATANULL) {
    cond = ::SRV_SendDataSet(association, ctx, &eventResponse.dataSet,
			     NULL, NULL, 0);
    if (cond != SRV_NORMAL) {
      logClient.log(MLogClient::MLOG_ERROR, params->callingAPTitle,
		"MDICOMReactor::handleNEventReport", __LINE__,
		"Error when sending N-Event Response command");
    }
    //(void) ::DCM_CloseObject(&setResponse.dataSet);
    //MASSERT (cond == SRV_NORMAL);
  }
  (void) ::DCM_CloseObject(&eventResponse.dataSet);

  return 0;
}

int
MDICOMReactor::handleNEventReportResponse(MSOPHandler* handler,
					  DUL_ASSOCIATIONKEY** association,
					  DUL_PRESENTATIONCONTEXT* ctx,
					  MSG_N_EVENT_REPORT_RESP** message,
					  DUL_ASSOCIATESERVICEPARAMETERS* params)
{
  CONDITION cond;

  if ((*message)->dataSetType != DCM_CMDDATANULL) {
    cond = ::SRV_ReceiveDataSet(association, ctx, DUL_BLOCK, 0, ".",
				&(*message)->dataSet);
    if (cond != SRV_NORMAL) {
      ::COND_DumpConditions();
      ::exit(1);
    }
  }
  handler->handleNEventResponse(ctx, message, params);

  return 1;
}

static CONDITION
callbackFunction(void* buf, U32 bytesExported, int lastFlag, void* ctx)
{
  int fd = *(int*)ctx;

  if (write(fd, buf, bytesExported) != bytesExported) {
    return 0;
  }
  return DCM_NORMAL;
}

int
MDICOMReactor::setFileMeta(DCM_FILE_META* fileMeta, MSG_C_STORE_REQ* msg)
{
  memset(fileMeta->preamble, 0, sizeof(fileMeta->preamble));
  fileMeta->fileMetaInformationVersion[0] = 0x01;
  fileMeta->fileMetaInformationVersion[1] = 0x00;
  strcpy(fileMeta->mediaStorageSOPClassUID, msg->classUID);
  strcpy(fileMeta->mediaStorageSOPInstanceUID, msg->instanceUID);
  //strcpy(fileMeta->transferSyntaxUID,  DICOM_TRANSFERLITTLEENDIAN);
  mStorageXferSyntax.safeExport(fileMeta->transferSyntaxUID,
	sizeof(fileMeta->transferSyntaxUID));
  strcpy(fileMeta->implementationClassUID, MIR_IMPLEMENTATIONCLASSUID);
  strcpy(fileMeta->implementationVersionName, MIR_IMPLEMENTATIONVERSIONNAME);
  strcpy(fileMeta->sourceApplicationEntityTitle, "XX");
  strcpy(fileMeta->privateInformationCreatorUID, "");

  return 0;
}

int
MDICOMReactor::writePart10MetaHeader(int fd, DCM_FILE_META* fileMeta)
{
  DCM_OBJECT* obj = 0;

  CONDITION cond = ::DCM_CreateObject(&obj, 0);
  if (cond != DCM_NORMAL) {
    return -1;
  }

  cond = ::DCM_SetFileMeta(&obj, fileMeta);
  if (cond != DCM_NORMAL) {
    return -1;
  }

  char buffer[2048];
  cond = ::DCM_ExportStream(&obj, 
			    DCM_EXPLICITLITTLEENDIAN | DCM_PART10FILE,
			    buffer, sizeof(buffer), callbackFunction, &fd);
  if (cond != DCM_NORMAL) {
    return -1;
  }

  return 0;
}
