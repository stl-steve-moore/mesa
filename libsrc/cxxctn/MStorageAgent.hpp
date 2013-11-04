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

// $Id: MStorageAgent.hpp,v 1.10 2006/10/17 03:48:34 smm Exp $ $Author: smm $ $Revision: 1.10 $ $Date: 2006/10/17 03:48:34 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MStorageAgent.hpp
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
//	$Revision: 1.10 $
//
//  = DATE RELEASED
//	$Date: 2006/10/17 03:48:34 $
//
//  = COMMENTS

#ifndef MStorageAgentISIN
#define MStorageAgentISIN

#include <iostream>
#include <string>
#include "ctn_api.h"

using namespace std;

#define NET_INIT_ERROR         10
#define CSTORE_REQ_FAILED      11
#define ASSOC_RELEASE_FAILED   12
#define SRV_CLASS_ABNORMAL 13
#define ASSOC_REQ_REJECTED     14
#define ASSOC_REQ_FAILED       15

class MDICOMWrapper;

class MStorageAgent
// = TITLE
///	A helper class to send a DICOM composite object to a storage SCP.
//
// = DESCRIPTION
//	
{
public:
  // = The standard methods in this framework.

  MStorageAgent();
  ///< Default constructor

  MStorageAgent(const MStorageAgent& cpy);
  ///< Copy constructor.

  virtual ~MStorageAgent();
  ///< Destructor.

  virtual void printOn(ostream& s) const;
  /**<\brief This method is used in conjunction with the streaming operator <<
   to print the current state of MStorageAgent. */

  virtual void streamIn(istream& s);
  /**<\brief This method is used in conjunction with the streaming operator >>
   to read the current state of MStorageAgent. */

  // = Class specific methods.

  int storeInstance(const MString& callingAETitle,
		    const MString& calledAETitle,
		    const MString& host,
		    int port,
		    const MString& path,
		    U16& result,
		    MString& resultMessage);
  /**<\brief This method opens a DICOM file, establishes an association with a
   storage SCP, and sends the DICOM composite object to the storage SCP
   using the DICOM C-Store command. */
  /**< 0 is returned on success.
   -1 is returned on failure.
   In the argument list: <{callingAETitle}> identifies your application.
   <{calledAETitle}> identifies the peer application.
   <{host}> is the host name or IP address of the peer.
   <{port}> is the port number of the peer application.
   <{path}> is the full or relative path name of the file to send.
   <{result}> will be written by this method with the DICOM status
   of the storage request.  That is, this method will return 0 because
   the operation proceeded according to the DICOM protocol, but the peer
   application may return a status of success or failure.
   <{resultMessage}> is an ASCII message that is returned by the peer
   in the event of an error.  The peer may or may not return this message. */

  int storeInstance(const MString& callingAETitle,
		    const MString& calledAETitle,
		    const MString& host,
		    int port,
		    MDICOMWrapper& w,
		    U16& result,
		    MString& resultMessage);
  /**<\brief This method establishes an association with a
   storage SCP and sends a DICOM composite object to the storage SCP
   using the DICOM C-Store command. */
  /**< 0 is returned on success.
   -1 is returned on failure.
   In the argument list: <{callingAETitle}> identifies your application.
   <{calledAETitle}> identifies the peer application.
   <{host}> is the host name or IP address of the peer.
   <{port}> is the port number of the peer application.
   <{w}> is a wrapper defining an existing composite object.
   <{result}> will be written by this method with the DICOM status
   of the storage request.  That is, this method will return 0 because
   the operation proceeded according to the DICOM protocol, but the peer
   application may return a status of success or failure.
   <{resultMessage}> is an ASCII message that is returned by the peer
   in the event of an error.  The peer may or may not return this message. */


private:
  DUL_NETWORKKEY* mNetwork;
  DUL_ASSOCIATIONKEY* mAssociation;
  DUL_ASSOCIATESERVICEPARAMETERS mParams;

  int initialize();
  int requestAssociation(const MString& callingAETitle,
			 const MString& calledAETitle,
			 const MString& host,
			 int port,
			 const MString& sopClass,
			 const MString& xferSyntax);

  int releaseAssociation();
};

inline ostream& operator<< (ostream& s, const MStorageAgent& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MStorageAgent& c) {
  c.streamIn(s);
  return s;
}

#endif
