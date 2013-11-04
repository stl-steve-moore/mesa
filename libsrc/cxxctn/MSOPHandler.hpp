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

// $Id: MSOPHandler.hpp,v 1.22 2006/10/17 03:49:25 smm Exp $ $Author: smm $ $Revision: 1.22 $ $Date: 2006/10/17 03:49:25 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MSOPHandler.hpp
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
//	$Revision: 1.22 $
//
//  = DATE RELEASED
//	$Date: 2006/10/17 03:49:25 $
//
//  = COMMENTS
//	This is easier to understand if you have a good background in
//	the MIR CTN software.

#ifndef MSOPHandlerISIN
#define MSOPHandlerISIN

#include <iostream>
#include <string>

#include "ctn_api.h"

#include "MApplicationEntity.hpp"

class MDICOMAssociation;
class MDICOMWrapper;

using namespace std;

class MSOPHandler
// = TITLE
///	Base class for handlers for DICOM SOP classes.
//
// = DESCRIPTION
/**	This is the base class for handlers for DICOM SOP classes.
	The methods on this class are invoked by the MDICOMReactor in response
	to requests from peer applications.  A C++ class which wants to act
	as a handler for a specific DICOM SOP class inherits from this C++
	class and then overrides methods as appropriate.
	For example, a storage SCP would override <{handleCStoreDataCommand}>
	and <{handleCStoreDataSet}>, but none of the other methods. */
{
public:
  // = The standard methods in this framework.
  MSOPHandler();
  ///< Default constructor
  MSOPHandler(const MSOPHandler& cpy);
  virtual ~MSOPHandler();
  virtual void printOn(ostream& s) const;
  /**<\brief This method is used in conjunction with the streaming operator <<
   to print the current state of MSOPHandler */

  virtual void streamIn(istream& s);
  
  // = Class specific methods.

  virtual int initialize();
  /**<\brief Initialize the handler.  This will be called just before the
   application begins to process requests. */

  virtual bool supportsSCRole(DUL_SC_ROLE role);
  /**<\brief This should be implemented by derived classes.  At association
   negotation, the handler will be asked if it supports the proposed
   Service Class role.  Answer true or false as appropriate. */

  virtual bool xferIVRLEOnly();
  /**<\brief This should be implemented by derived classes.  This derived
   handler should override this method and answer true if the handler
   supports only the Implicit VR Little Endian transfer syntax.
   Answer or false if more transfer syntaxes are supported. */

  // = These are invoked by the MDICOMReactor.

  virtual CONDITION handleCEcho(DUL_ASSOCIATIONKEY** association,
				DUL_PRESENTATIONCONTEXT* ctx,
				MSG_C_ECHO_REQ ** message);
  ///< Handle a C-Echo request from a peer.  
  /**< In the argument list,
   <{association}> describes the current DICOM association and <{ctx}> is
   the presentation context for the current operation.  <{message}>
   is the DICOM C-Echo request. */

  virtual CONDITION handleCEchoResponse(DUL_PRESENTATIONCONTEXT* ctx,
				MSG_C_ECHO_RESP ** message,
				DUL_ASSOCIATESERVICEPARAMETERS* params);
  ///< Handle a C-Echo response from a peer.
  /**< In the argument list, <{ctx}> defines the current presentation context.
   <{message}> is the response message from the verification SCP.
   <{params}> describes association parameters. */

  virtual CONDITION handleCStoreCommand(DUL_PRESENTATIONCONTEXT* ctx,
					MSG_C_STORE_REQ** message,
					MSG_C_STORE_RESP* response,
					DUL_ASSOCIATESERVICEPARAMETERS* params,
					MString& fileName);
  /**<\brief This method is invoked when the MDICOMReactor has received the C-Store
   command from the peer application (but not the dataset). */
  /**< In this method, the C++ class should determine a temporary or
   permanent name for the SOP instance to be stored and return it
   in <{fileName}>.  This will be used by the MDICOMReactor to store
   the SOP instance as it is received.
   Other arguments: <{ctx}> describes the presentation context for the
   operation, <{message}> contains the C-Store command, <{response}> is
   the response formulated by your class, and <{params}> describes
   the service parameters for the association.
   Write a file name in <{fileName}>.  If the operation should be
   aborted, place the appropriate DICOM status value in <{response->status}>.
   Return SRV_NORMAL unless catastrophe.  Any other return value will
   signal the MDICOMReactor to shut down (ungracefully). */

  virtual CONDITION handleCStoreDataSet(DUL_PRESENTATIONCONTEXT* ctx,
					MSG_C_STORE_REQ** message,
					MSG_C_STORE_RESP* response,
					DUL_ASSOCIATESERVICEPARAMETERS* params,
					MString& fileName);
  /**<\brief This method is invoked when the MDICOMReactor has received the complete
   dataset for a C-Store operation.  */
  /**< You are now granted ownership of the file and are allowed to rename it if desired.  
     When your method is invoked,
     the MDICOMReactor has already opened the file and passed a CTN DCM object
     in <{message}>, so you do not need to open the file a second time.
     Place the appropriate DICOM status value in <{reponse->status}>.
     Return SRV_NORMAL unless catastrophe.  Any other return value will signal
     the MDICOMReactor to shut down (ungracefully).
     <{ctx}> describes the presentation context for the operation.
     <{message}> contains the C-Store command and opened CTN DCM object.
     <{response}> is the response to be sent to the peer; you may update status.
     <{params}> describes the service parameters for the association.
     <{fileName}> is the name of the existing file (which you set in
     <{handleCStoreCommand}>). */

  virtual CONDITION handleCStoreResponse(DUL_PRESENTATIONCONTEXT* ctx,
					 MSG_C_STORE_RESP** message,
					 DUL_ASSOCIATESERVICEPARAMETERS* params);
  /**<\brief This method is invoked when the MDICOMReactor has received a C-Store
   response from a storage SCP.  The writer of this method can examine
   the response sent by the peer application.  This method should
   return SRV_NORMAL. */
  /**< In the argument list, <{ctx}> defines the current presentation context.
   <{message}> is the response message from the storage SCP.
   <{params}> describes association parameters. */

  virtual CONDITION handleCFindCommand(DUL_PRESENTATIONCONTEXT* ctx,
				       MSG_C_FIND_REQ** message,
				       MSG_C_FIND_RESP* response,
				       DUL_ASSOCIATESERVICEPARAMETERS* params,
				       const MString& queryLevel);
  /**<\brief This method is invoked when the MDICOMReactor has received both the
   C-Find command and C-Find identifier from a query SCU.  */
  /**< The information is presented to your class to allow you to setup, begin, and/or
   complete your query.  Place the appropriate DICOM status value in
   <{response->status}>.  Do not return responses to the query (yet).
   Return SRV_NORMAL unless catastrophe.  Any other return value will signal
   the MDICOMReactor to shut down (ungracefully).
   <{ctx}> describes the presentation context for the operation.
   <{message}> contains the C-Find command and identifier.
   <{response}> is the response to be sent to the peer; you may update
   status.
   <{params}> describes the service parameters for the association.
   <{queryLevel}> is taken from the C-Find data set and indicates the
   DICOM query level (PATIENT, STUDY, SERIES, IMAGE) for hierarchical
   queries.
   The value is empty ("") for other queries (MWL). */

  virtual CONDITION returnCFindDataSet(DUL_PRESENTATIONCONTEXT* ctx,
				       MSG_C_FIND_REQ** message,
				       MSG_C_FIND_RESP* response,
				       DUL_ASSOCIATESERVICEPARAMETERS* params,
				       const MString& queryLevel,
				       int index);
  /**<\brief This method is invoked by the MDICOMReactor in a loop to gather
   C-Find responses from your class.  */
  /**< On each invocation, you should take
   the "next" response and place it in <{response->identifier}>.
   When you are returning a valid response, set <{response->dataSetType}> to
   DCM_CMDDATAOTHER and place the appropriate DICOM status in
   <{response->status}>.
   When you want to return the final response (which contains no identifier),
   set <{response->dataSetType}> to DCM_CMDDATANULL and place the
   appropriate DICOM status in <{response->status}>.
   On each loop through the MDICOMReactor, you get a new empty copy of
   the identifier in the response.  Therefore, you cannot just update "new"
   values.
   <{ctx}> describes the presentation context for the operation.
   <{message}> contains the C-Find command and identifier.
   <{response}> is the response to be sent to the peer; you may update
   status.
   <{params}> describes the service parameters for the association.
   <{queryLevel}> is taken from the C-Find data set and indicates the
   DICOM query level (PATIENT, STUDY, SERIES, IMAGE) for hierarchical
   queries.
   <{index}> starts at 1 and increments with each succeeding call to your
   method. */

  virtual CONDITION handleCFindResponse(DUL_PRESENTATIONCONTEXT* ctx,
					MSG_C_FIND_RESP** message,
					DUL_ASSOCIATESERVICEPARAMETERS* params,
					const MString& queryLevel,
					int index);
  /**<\brief This method is invoked by the MDICOMReactor for each C-Find response
   returned by a query SCP.  The method is invoked for the final response
   which includes no dataset.  This method should extract the response and
   return SRV_NORMAL. */
  /**< If the operation should be canceled, the method should return
   SRV_OPERATIONCANCELLED.
   In the argument list, <{ctx}> describes the current presentation context.
   <{message}> contains the C-Find response from the query SCP.
   <{params}> describes the service parameters for the association.
   <{queryLevel}> is taken from the C-Find data set and indicates the
   DICOM query level (PATIENT, STUDY, SERIES, IMAGE) for hierarchical
   queries.
   <{index}> starts at 1 and increments with each succeeding call to your
   method. */

  virtual CONDITION handleCMoveCommand(DUL_PRESENTATIONCONTEXT* ctx,
				       MSG_C_MOVE_REQ** message,
				       MSG_C_MOVE_RESP* response,
				       DUL_ASSOCIATESERVICEPARAMETERS* params,
				       const MString& queryLevel);
  /**<\brief This method is invoked when the MDICOMReactor has received both the
  C-Move command and C-Move identifier from a query SCU.  */
  /**< The information
   is presented to your class to allow you to setup, begin, and/or
   complete your query.  Place the appropriate DICOM status value in
   <{response->status}>.
   Return SRV_NORMAL unless catastrophe.  Any other return value will signal
   the MDICOMReactor to shut down (ungracefully).
   <{ctx}> describes the presentation context for the operation.
   <{message}> contains the C-Find command and identifier.
   <{response}> is the response to be sent to the peer; you may update
   status.
   <{params}> describes the service parameters for the association.
   <{queryLevel}> is taken from the C-Find data set and indicates the
   DICOM query level (PATIENT, STUDY, SERIES, IMAGE) for hierarchical
   queries.
   The value is empty ("") for other queries. */


  virtual CONDITION returnCMoveStatus(DUL_PRESENTATIONCONTEXT* ctx,
				      MSG_C_MOVE_REQ** message,
				      MSG_C_MOVE_RESP* response,
				      DUL_ASSOCIATESERVICEPARAMETERS* params,
				      const MString& queryLevel,
				      int index);

  virtual CONDITION handleCMoveResponse(DUL_PRESENTATIONCONTEXT* ctx,
					MSG_C_MOVE_RESP** message,
					DUL_ASSOCIATESERVICEPARAMETERS* params,
					const MString& queryLevel,
					int index);

  virtual CONDITION handleNCreateCommand(DUL_PRESENTATIONCONTEXT* ctx,
					 MSG_N_CREATE_REQ** createRequest,
					 MSG_N_CREATE_RESP* createResponse,
					 DUL_ASSOCIATESERVICEPARAMETERS* params,
					 MString& directoryName);
  /**<\brief This method is invoked by the MDICOMReactor when it has received
  // an N-Create command from a peer application.  
  /**< The MDICOMReactor will store
   the data set in a file in a directory of your choosing.  You select the
   directory by modifying the path in <{directoryName}>.
   In the argument list, <{ctx}> describes the presentation context.
   <{createRequest}> contains the N-Create message sent by the peer.
   <{createResponse}> is the response which is being formulated.
   <{params}> describes the association service parameters.
   <{directoryName}> is a string that you can write to indicate where
   to store the data set when it arrives. */

  virtual CONDITION handleNCreateDataSet(DUL_PRESENTATIONCONTEXT* ctx,
					 MSG_N_CREATE_REQ** createRequest,
					 MSG_N_CREATE_RESP* createResponse,
					 DUL_ASSOCIATESERVICEPARAMETERS* params,
					 MString& directoryName);
  /**<\brief This method is invoked by the MDICOMReactor when it has received the
  // data set associated with an N-Create command.  
  /**< The user should process
   the command/data set and place appropriate status in the response.
   In the argument list, <{ctx}> describes the presentation context.
   <{createRequest}> contains the N-Create message sent by the peer.  It will
   contain a CTN DCM object with the attributes of the data set.
   <{createResponse}> is the response which is being formulated.
   <{params}> describes the association service parameters.
   <{directoryName}> is a string with the name of the directory where
   the data set was stored in a file. */


  virtual CONDITION handleNCreateResponse(DUL_PRESENTATIONCONTEXT* ctx,
					  MSG_N_CREATE_RESP** message,
					  DUL_ASSOCIATESERVICEPARAMETERS* params);
  /**<\brief This method is invoked by the MDICOMReactor when it has received the
   response to your N-Create command. */
  /**< In the argument list, <{ctx}> describes the presentation context.
   <{message}> is the response from the peer application.
   <{params}> describes the association service parameters. */

  virtual CONDITION handleNSetCommand(DUL_PRESENTATIONCONTEXT* ctx,
				      MSG_N_SET_REQ** message,
				      MSG_N_SET_RESP* response,
				      DUL_ASSOCIATESERVICEPARAMETERS* params,
				      MString& directoryName);
  ///< This method uses the same mechanism documented for <{handleNCreateCommand}>.

  virtual CONDITION handleNSetDataSet(DUL_PRESENTATIONCONTEXT* ctx,
				      MSG_N_SET_REQ** message,
				      MSG_N_SET_RESP* response,
				      DUL_ASSOCIATESERVICEPARAMETERS* params,
				      MString& directoryName);
  ///< This method uses the same mechanism documented for <{handleNCreateDataSet}>.

  virtual CONDITION handleNSetResponse(DUL_PRESENTATIONCONTEXT* ctx,
				       MSG_N_SET_RESP** message,
				       DUL_ASSOCIATESERVICEPARAMETERS* params);
  ///< This method uses the same mechanism documented for <{handleNCreateResponse}>.

  virtual CONDITION handleNActionCommand(DUL_PRESENTATIONCONTEXT* ctx,
					 MSG_N_ACTION_REQ** message,
					 MSG_N_ACTION_RESP* response,
					 DUL_ASSOCIATESERVICEPARAMETERS* params,
					 MString& directoryName);
  ///< This method uses the same mechanism documented for <{handleNCreateCommand}>.

  virtual CONDITION handleNActionDataSet(DUL_PRESENTATIONCONTEXT* ctx,
					 MSG_N_ACTION_REQ** message,
					 MSG_N_ACTION_RESP* response,
					 DUL_ASSOCIATESERVICEPARAMETERS* params,
					 MString& directoryName);
  ///< This method uses the same mechanism documented for <{handleNCreateDataSet}>.

  virtual CONDITION handleNActionResponse(DUL_PRESENTATIONCONTEXT* ctx,
					  MSG_N_ACTION_RESP** message,
					  DUL_ASSOCIATESERVICEPARAMETERS* params);
  ///< This method uses the same mechanism documented for <{handleNCreateResponse}>.

  virtual CONDITION handleNEventCommand(DUL_PRESENTATIONCONTEXT* ctx,
					MSG_N_EVENT_REPORT_REQ** message,
					MSG_N_EVENT_REPORT_RESP* response,
					DUL_ASSOCIATESERVICEPARAMETERS* params,
					MString& directoryName);
  ///< This method uses the same mechanism documented for <{handleNCreateCommand}>.

  virtual CONDITION handleNEventDataSet(DUL_PRESENTATIONCONTEXT* ctx,
					MSG_N_EVENT_REPORT_REQ** message,
					MSG_N_EVENT_REPORT_RESP* response,
					DUL_ASSOCIATESERVICEPARAMETERS* params,
					MString& directoryName);
  ///< This method uses the same mechanism documented for <{handleNCreateDataSet}>.

  virtual CONDITION handleNEventResponse(DUL_PRESENTATIONCONTEXT* ctx,
					 MSG_N_EVENT_REPORT_RESP** message,
					 DUL_ASSOCIATESERVICEPARAMETERS* params);
  ///< This method uses the same mechanism documented for <{handleNCreateResponse}>.

  int sendCStoreRequest(DUL_ASSOCIATIONKEY** key,
			DUL_ASSOCIATESERVICEPARAMETERS* params,
			DCM_OBJECT** storageObject);
  ///< This method sends a DICOM C-Store request (command plus data set) using an established association.
  /**< In the argument list, <{key}> is a CTN Association key for an open
   association.
   <{params}> describes the service parameters for the association.
   <{storageObject}> is the object to be sent.
   0 is returned on success.
  -1 is returned on failure. */

  int sendCStoreRequest(MDICOMAssociation& association,
	MDICOMWrapper& w);

  int sendCEchoRequest(MDICOMAssociation& association);
  ///< This method sends a DICOM C-Echo request using an established DICOM Association.
  /**< In the argument list, <{association}> is the object that
   holds an existing, open DICOM association with a peer application. */


  CONDITION sendCFindRequest(DUL_ASSOCIATIONKEY** key,
			     DUL_ASSOCIATESERVICEPARAMETERS* params,
			     MSG_C_FIND_REQ* request);
  ///< This method sends a DICOM C-Find request (command plus data set) using an established association.
  /**< In the argument list, <{key}> is a CTN Association key for an open
   association.
   <{params}> describes the service parameters for the association.
   <{request}> is a structure which describes the C-Find request. */

  CONDITION sendCFindRequest(DUL_ASSOCIATIONKEY** key,
			     DUL_ASSOCIATESERVICEPARAMETERS* params,
			     const MString& sopClass,
			     DCM_OBJECT** queryObject);
  ///< This method sends a DICOM C-Find request (command plus data set) using an established association.
  /**< In the argument list, <{key}> is a CTN Association key for an open
   association.
   <{params}> describes the service parameters for the association.
   <{sopClass}> contains the UID of the DICOM SOP Class for the query.
   <{queryObject}> is a CTN DCM object with the attributes of the query. */

  int sendCFindRequest(MDICOMAssociation& assoc,
			     const MString& sopClass,
			     MDICOMWrapper& queryObject);

  CONDITION sendCMoveRequest(DUL_ASSOCIATIONKEY** key,
			     DUL_ASSOCIATESERVICEPARAMETERS* params,
			     const MString& sopClass,
			     const MString& destination,
			     DCM_OBJECT** queryObject);
  ///< This method sends a DICOM C-Move request (command plus data set) using an established association.
  /**< In the argument list, <{key}> is a CTN Association key for an open
   association.
   <{params}> describes the service parameters for the association.
   <{sopClass}> contains the UID of the DICOM SOP Class for the move.
   <{destination}> is the AE title of the destination of the move.
   <{queryObject}> is a CTN DCM object with the attributes of the move. */

  CONDITION sendNCreateRequest(DUL_ASSOCIATIONKEY** key,
			       DUL_ASSOCIATESERVICEPARAMETERS* params,
			       const MString& sopClass,
			       const MString& sopInstanceUID,
			       DCM_OBJECT** createObject);
  ///< This method sends a DICOM N-Create request (command plus data set) using an established association.
  /**< In the argument list, <{key}> is a CTN Association key for an open
   association.
   <{params}> describes the service parameters for the association.
   <{sopClass}> contains the UID of the DICOM SOP Class for the request.
   <{sopInstanceUID}> is the UID of the object to be created.
   <{createObject}> is a CTN DCM object with the attributes of the object. */

  int sendNCreateRequest(MDICOMAssociation& assoc,
			       const MString& sopClass,
			       const MString& sopInstanceUID,
			       MDICOMWrapper& createObject);


  CONDITION sendNSetRequest(DUL_ASSOCIATIONKEY** key,
			    DUL_ASSOCIATESERVICEPARAMETERS* params,
			    const MString& sopClass,
			    const MString& sopInstanceUID,
			    DCM_OBJECT** setObject);
  ///< This method sends a DICOM N-Set request using the mechanism described for <{sendNCreateRequest}>.

  int sendNSetRequest(MDICOMAssociation& assoc,
			    const MString& sopClass,
			    const MString& sopInstanceUID,
			    MDICOMWrapper& setObject);

  CONDITION sendNActionRequest(DUL_ASSOCIATIONKEY** key,
			       DUL_ASSOCIATESERVICEPARAMETERS* params,
			       const MString& sopClass,
			       const MString& sopInstanceUID,
			       int actionID,
			       DCM_OBJECT** nactionObject);
  ///< This method sends a DICOM N-Action request using the mechanism described for <{sendNCreateRequest}>.
  /**< The one change is the <{actionID}> argument which is part of the
   DICOM N-Action request. */

  int sendNActionRequest(MDICOMAssociation& assoc,
			       const MString& sopClass,
			       const MString& sopInstanceUID,
			       int actionID,
			       MDICOMWrapper& nactionObject);

  CONDITION sendNEventReportRequest(DUL_ASSOCIATIONKEY** key,
				    DUL_ASSOCIATESERVICEPARAMETERS* params,
				    const MString& sopClass,
				    const MString& sopInstanceUID,
				    int eventTypeID,
				    DCM_OBJECT** eventObject);
  ///< This method sends a DICOM N-Event Report using the mechanism described for <{sendNCreateRequest}>.
  ///< The one change is the <{eventTypeID}> argument which is part of the DICOM N-Event Report.

  CONDITION sendNEventReportRequest(MDICOMAssociation& assoc,
				    const MString& sopClass,
				    const MString& sopInstanceUID,
				    int eventTypeID,
				    MDICOMWrapper& neventObject);

  U16 lastStatus() const;
  ///< Some of the methods above record the last status returned from a peer.  This method returns that status.

  MString lastComment() const;
  ///< Some of the methods above record the last comment returned from a peer.  This method returns that comment.

  void addApplicationEntity(const MApplicationEntity& ae);
  /**<\brief Add one Application Entity to the map which is maintained by this
   class.  This map will be used to establish connections to other
   applications (for example, during C-Move operations). */

protected:
  U16 mLastStatus;
  MString mLastComment;
  MApplicationEntityMap mAEMap;

private:
};

inline ostream& operator<< (ostream& s, const MSOPHandler& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MSOPHandler& c) {
  c.streamIn(s);
  return s;
}

#endif
