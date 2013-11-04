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

// $Id: MReferencedRequest.hpp,v 1.2 2006/06/29 16:08:31 bhasselfeld Exp $ $Author: bhasselfeld $ $Revision: 1.2 $ $Date: 2006/06/29 16:08:31 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MReferencedRequest.hpp
//
//  = AUTHOR
//
//
//  = COPYRIGHT
//	Copyright HIMSS, RSNA, Washington University: 1999, 2000
//
// ====================
//
//  = VERSION
//	$Revision: 1.2 $
//
//  = DATE RELEASED
//	$Date: 2006/06/29 16:08:31 $
//
//  = COMMENTS
//

#ifndef MReferencedRequestISIN
#define MReferencedRequestISIN

#include <iostream>
#include <vector>
#include "MDomainObject.hpp"

using namespace std;

class MReferencedRequest;
typedef vector < MReferencedRequest > MReferencedRequestVector;

class MReferencedRequest : public MDomainObject
// = TITLE
///	A domain object that corresponds to a DICOM Referenced Request.
//
// = DESCRIPTION
/**	This class is a container for attributes which define a DICOM
	Requested Procedure.  It inherits from <{MDomainObject}> and
	supports the ability to get and set values with specific methods.  Because this
	class is just a container, it performs no validation tests. */
{
public:
  // = The standard methods in this framework.

  MReferencedRequest();
  ///< Default constructor

  MReferencedRequest(const MReferencedRequest& cpy);

  virtual ~MReferencedRequest();

  virtual void printOn(ostream& s) const;
  /**<\brief This method is used in conjunction with the streaming operator <<
  	     to print the current state of MReferencedRequest. */

  virtual void streamIn(istream& s);
  /**<\brief This method is used in conjunction with the streaming operator >>
  	     to read the current state of MReferencedRequest. */

  // = Class specific methods.

#if 0
  MReferencedRequest(const MString& studyInstanceUID, 
     const MString& referencedSOPClassUID,
     const MString& referencedSOPInstanceUID,
     const MString& accessionNumber,
     const MString& requestedProcedureCodeValue,
     const MString& requestedProcedureCodeMeaning,
     const MString& requestedProcedureCodeScheme,
     const MString& placerOrderNumber,
     const MString& fillerOrderNumber,
     const MString& requestedProcedureID,
     const MString& requestedProcedureDescription,
     const MString& requestedProcedureReason,
     const MString& requestedProcedureComments,
     const MString& confidentiality,
     const MString& requestingPhysician,
     const MString& referringPhysician,
     const MString& orderDate,
     const MString& orderTime);
  /**<\brief This constructor takes a variable for each attribute that is managed
  	     by this object.  The values of the variables are copied to the internal
  	     state of the object. */
#endif

  // A number of get methods that return values.  Use the method name
  // as a guide to the attribute.
  MString studyInstanceUID() const;
  MString referencedSOPClassUID() const;
  MString referencedSOPInstanceUID() const;
  MString accessionNumber() const;
  MString requestedProcedureCodeValue() const;
  MString requestedProcedureCodeMeaning() const;
  MString requestedProcedureCodeScheme() const;
  MString placerOrderNumber() const;
  MString fillerOrderNumber() const;
  MString requestedProcedureID() const;
  MString requestedProcedureDescription() const;
  MString requestedProcedureReason() const;
  MString requestedProcedureComments() const;
  MString confidentiality() const;
  MString requestingPhysician() const;
  MString referringPhysician() const;
  MString orderDate() const;
  MString orderTime() const;
  MString workitemkey() const;

  // A number of set methods that set one attribute value.  Use the method
  // name as a guide to the attribute.
  void studyInstanceUID(const MString& s);
  void referencedSOPClassUID(const MString& s);
  void referencedSOPInstanceUID(const MString& s);
  void accessionNumber(const MString& s);
  void requestedProcedureCodeValue(const MString& s);
  void requestedProcedureCodeMeaning(const MString& s);
  void requestedProcedureCodeScheme(const MString& s);
  void placerOrderNumber(const MString& s);
  void fillerOrderNumber(const MString& s);
  void requestedProcedureID(const MString& s);
  void requestedProcedureDescription(const MString& s);
  void requestedProcedureReason(const MString& s);
  void requestedProcedureComments(const MString& s);
  void confidentiality(const MString& s);
  void requestingPhysician(const MString& s);
  void referringPhysician(const MString& s);
  void orderDate(const MString& s);
  void orderTime(const MString& s);
  void workitemkey(const MString& s);

private:
  MString mStudyInstanceUID;
  MString mRefSOPClassUID;
  MString mRefSOPInstanceUID;
  MString mAccessionNumber;
  MString mReqProcCodeValue;
  MString mReqProcCodeMeaning;
  MString mReqProcCodeScheme;
  MString mPlacerOrderNumber;
  MString mFillerOrderNumber;
  MString mReqProcID;
  MString mReqProcDescription;
  MString mReqProcReason;
  MString mReqProcComments;
  MString mConfidentiality;
  MString mRequestingPhysician;
  MString mReferringPhysician;
  MString mOrderDate;
  MString mOrderTime;
  MString mWorkitemkey;

};

inline ostream& operator<< (ostream& s, const MReferencedRequest& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MReferencedRequest& c) {
  c.streamIn(s);
  return s;
}

#endif
