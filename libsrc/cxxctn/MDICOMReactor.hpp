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

// $Id: MDICOMReactor.hpp,v 1.15 2006/08/16 03:57:36 smm Exp $ $Author: smm $ $Revision: 1.15 $ $Date: 2006/08/16 03:57:36 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MDICOMReactor.hpp
//
//  = AUTHOR
//	Steve Moore
//
//  = COPYRIGHT
//	Copyright HIMSS, RSNA, Washington University: 1999, 2000
//
// ====================
//
//  = VERSION
//	$Revision: 1.15 $
//
//  = DATE RELEASED
//	$Date: 2006/08/16 03:57:36 $
//
//  = COMMENTS
//	Based on the Reactor pattern found in the ACE project.

#ifndef MDICOMReactorISIN
#define MDICOMReactorISIN

#include <iostream>
#include <string>
#include <map>

#include "ctn_api.h"
#include "MString.hpp"
#include "MSOPHandler.hpp"
class MDICOMAssociation;

using namespace std;

typedef map<MString, MSOPHandler*,  less <MString> > MSOPHandlerMap;

class MDICOMReactor
// = TITLE
///	A dispatcher for DICOM network events
//
// = DESCRIPTION
/**	The MDICOMReactor class is used to control and dispatch network
	events that are received from peer applications.  The user registers
	classes to receive events from specific DICOM SOP classes, and the
	MDICOMReactor handles the details of accepting the network messages
	and invoking the proper handler. */
{
public:
  // = The standard methods in this framework.

  MDICOMReactor();
  ///< Default constructor.

  MDICOMReactor(const MDICOMReactor& cpy);
  ///< Copy constructor.

  virtual ~MDICOMReactor();
  ///< Destructor.

  virtual void printOn(ostream& s) const;
  /**< This method is used in conjunction with the streaming operator <<
   to print the current state of MDICOMReactor. */

  virtual void streamIn(istream& s);
  // This method is used in conjunction with the streaming operator <<
  // to print the current state of MDICOMReactor.
  
  // = Class specific methods.
  MDICOMReactor(bool storePart10Files);

  int registerHandler(MSOPHandler* handler, const MString& SOPClass);
  ///< Register the handler for all messages associated with the SOP Class.

  MSOPHandler* recallHandler(const MString& SOPClass);
  ///< Return pointer to the handler registered for this SOP Class.

  int processRequests(DUL_ASSOCIATIONKEY** association,
		  DUL_ASSOCIATESERVICEPARAMETERS* service,
		  unsigned long count = 0);
  ///< Process all incoming DICOM requests and dispatch to appropriate handler.
  /**< This method controls the event loop of DICOM events.
   The caller provides CTN parameters <{association}> and
   <{service}> which describe an established association.  The <{count}>
   argument specifies the number of events to process.  Use 0 to
   process until the association is broken.
   0 is returned on success.
   -1 is returned on failure. */

  int processRequests(MDICOMAssociation& assoc,
		  unsigned long count = 0);

  void storeAsPart10(bool flag);
  ///< Set the flag for storing objects in Part 10 format.
  /**< Passing a value of <{true}> in flag causes the MDICOMReactor to store
   objects in DICOM Part 10 format. */

protected:
  // Protected methods can be inherited if you want to inherent and
  // build your own DICOM Reactor.

  int handleRequest(DUL_ASSOCIATIONKEY** association,
		    DUL_ASSOCIATESERVICEPARAMETERS* service,
		    DUL_PRESENTATIONCONTEXT* ctx,
		    MSG_TYPE messageType,
		    void** message);
  /**<\brief Used by the <{processRequests}> method to handle a specific request after
   some initial tests have been made.  Normally only used internally. */
  /**< In the argument list: <{association}> and <{service}> are CTN variables
   which describe the current association.  <{ctx}> is a pointer to the
   curent presentation context (for the current event/message).
   <{messageType}> defines the type of message to be processed and
   <{message}> is the address of a pointer to the received message. */

  int handleCEcho(DUL_ASSOCIATIONKEY** association,
		  DUL_PRESENTATIONCONTEXT* ctx,
		  MSG_C_ECHO_REQ ** message);


  int handleCStore(MSOPHandler* handler,
		   DUL_ASSOCIATIONKEY** association,
		   DUL_PRESENTATIONCONTEXT* ctx,
		   MSG_C_STORE_REQ ** message,
		   DUL_ASSOCIATESERVICEPARAMETERS* params);
  ///< Called by handleRequest to handle a specific C-Store request.

  int handleCStoreResponse(MSOPHandler* handler,
			   DUL_ASSOCIATIONKEY** association,
			   DUL_PRESENTATIONCONTEXT* ctx,
			   MSG_C_STORE_RESP** message,
			   DUL_ASSOCIATESERVICEPARAMETERS* params);
  ///< Called by handleRequest to handle a specific C-Store Response.

  int handleCFind(MSOPHandler* handler,
		  DUL_ASSOCIATIONKEY** association,
		  DUL_PRESENTATIONCONTEXT* ctx,
		  MSG_C_FIND_REQ ** message,
		  DUL_ASSOCIATESERVICEPARAMETERS* params);
  ///< Called by handleRequest to handle a specific C-Find Request.

  int handleCFindResponse(MSOPHandler* handler,
			  DUL_ASSOCIATIONKEY** association,
			  DUL_PRESENTATIONCONTEXT* ctx,
			  MSG_C_FIND_RESP** message,
			  DUL_ASSOCIATESERVICEPARAMETERS* params);
  ///< Called by handleRequest to handle a specific C-Find Response.

  int handleCMove(MSOPHandler* handler,
		  DUL_ASSOCIATIONKEY** association,
		  DUL_PRESENTATIONCONTEXT* ctx,
		  MSG_C_MOVE_REQ ** message,
		  DUL_ASSOCIATESERVICEPARAMETERS* params);
  ///< Called by handleRequest to handle a specific C-Move Request.

  int handleCMoveResponse(MSOPHandler* handler,
			  DUL_ASSOCIATIONKEY** association,
			  DUL_PRESENTATIONCONTEXT* ctx,
			  MSG_C_MOVE_RESP** message,
			  DUL_ASSOCIATESERVICEPARAMETERS* params);
  ///< Called by handleRequest to handle a specific C-Move Response

  int handleNCreate(MSOPHandler* handler,
		    DUL_ASSOCIATIONKEY** association,
		    DUL_PRESENTATIONCONTEXT* ctx,
		    MSG_N_CREATE_REQ ** message,
		    DUL_ASSOCIATESERVICEPARAMETERS* params);
  ///< Called by handleRequest to handle a specific N-Create request.

  int handleNCreateResponse(MSOPHandler* handler,
			    DUL_ASSOCIATIONKEY** association,
			    DUL_PRESENTATIONCONTEXT* ctx,
			    MSG_N_CREATE_RESP** message,
			    DUL_ASSOCIATESERVICEPARAMETERS* params);
  ///< Called by handleRequest to handle a specific N-Create response.

  int handleNSet(MSOPHandler* handler,
		 DUL_ASSOCIATIONKEY** association,
		 DUL_PRESENTATIONCONTEXT* ctx,
		 MSG_N_SET_REQ ** message,
		 DUL_ASSOCIATESERVICEPARAMETERS* params);
  ///< Called by handleRequest to handle a specific N-Set request.

  int handleNSetResponse(MSOPHandler* handler,
			 DUL_ASSOCIATIONKEY** association,
			 DUL_PRESENTATIONCONTEXT* ctx,
			 MSG_N_SET_RESP** message,
			 DUL_ASSOCIATESERVICEPARAMETERS* params);
  ///< Called by handleRequest to handle a specific N-Set response.

  int handleNActionRequest(MSOPHandler* handler,
			   DUL_ASSOCIATIONKEY** association,
			   DUL_PRESENTATIONCONTEXT* ctx,
			   MSG_N_ACTION_REQ ** message,
			   DUL_ASSOCIATESERVICEPARAMETERS* params);
  ///< Called by handleRequest to handle a specific N-Action request.

  int handleNActionResponse(MSOPHandler* handler,
			    DUL_ASSOCIATIONKEY** association,
			    DUL_PRESENTATIONCONTEXT* ctx,
			    MSG_N_ACTION_RESP** message,
			    DUL_ASSOCIATESERVICEPARAMETERS* params);
  ///< Called by handleRequest to handle a specific N-Action response.

  int handleNEventReport(MSOPHandler* handler,
			 DUL_ASSOCIATIONKEY** association,
			 DUL_PRESENTATIONCONTEXT* ctx,
			 MSG_N_EVENT_REPORT_REQ ** message,
			 DUL_ASSOCIATESERVICEPARAMETERS* params);
  ///< Called by handleRequest to handle a specific N-Event request.

  int handleNEventReportResponse(MSOPHandler* handler,
				 DUL_ASSOCIATIONKEY** association,
				 DUL_PRESENTATIONCONTEXT* ctx,
				 MSG_N_EVENT_REPORT_RESP** message,
				 DUL_ASSOCIATESERVICEPARAMETERS* params);
  ///< Called by handleRequest to handle a specific N-Event response.

  int setFileMeta(DCM_FILE_META* fileMeta, MSG_C_STORE_REQ* msg);

  int writePart10MetaHeader(int fd, DCM_FILE_META* fileMeta);

private:
  MSOPHandlerMap mHandlerMap;
  bool mStoreAsPart10;
  MString mStorageXferSyntax;
};

inline ostream& operator<< (ostream& s, const MDICOMReactor& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MDICOMReactor& c) {
  c.streamIn(s);
  return s;
}

#endif
