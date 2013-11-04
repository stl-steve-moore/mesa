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

// $Id: MStorageCommitRequest.hpp,v 1.6 2006/06/29 16:08:31 bhasselfeld Exp $ $Author: bhasselfeld $ $Revision: 1.6 $ $Date: 2006/06/29 16:08:31 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MStorageCommitRequest.hpp
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
//	$Revision: 1.6 $
//
//  = DATE RELEASED
//	$Date: 2006/06/29 16:08:31 $
//
//  = COMMENTS
//

#ifndef MStorageCommitRequestISIN
#define MStorageCommitRequestISIN

#include <iostream>
#include <string>

#include "MStorageCommitItem.hpp"

using namespace std;

class MStorageCommitRequest
// = TITLE
///	This class corresponds to a DICOM Storage Commitment request.
//
// = DESCRIPTION
/**	This class is a container for attributes which define a DICOM
	Storage Commitment Request.  It  supports the
	ability to get and set values with specific methods.  Because this
	class is just a container, it performs no validation tests. */
{
public:
  // = The standard methods in this framework.

  MStorageCommitRequest();
  ///< Default constructor

  MStorageCommitRequest(const MStorageCommitRequest& cpy);

  virtual ~MStorageCommitRequest();

  virtual void printOn(ostream& s) const;
  /**<\brief This method is used in conjunction with the streaming operator <<
    	     to print the current state of MStorageCommitRequest. */

  virtual void streamIn(istream& s);
  /**<\brief This method is used in conjunction with the streaming operator <<
  	     to print the current state of MStorageCommitRequest. */

  // = Class specific methods.

  void transactionUID(const MString& transactionUID);
  ///< Set the Transaction UID to the value passed in <{transactionUID}>.

  void retrieveAETitle(const MString& retrieveAETitle);
  ///< Set the retrieve AE title to the value passed in <{retrieveAETitle}>.

  void addItem(const MStorageCommitItem& item);
  /**<\brief Add one MStorageCommitItem passed in <{item}>.  The values in <{item}>
  	     are copied and stored in a vector maintained by this object. */

  MString transactionUID() const;
  ///< Return a copy of the Transaction UID.

  MString retrieveAETitle() const;
  ///< Return a copy of the Retrieve AE title.

  int itemCount() const;
  ///< Return the number of MStorageCommitItem's maintained in the internal vector.

  MStorageCommitItem item(int index) const;
  ///< Return a specific MStorageCommitItem from the internal vector.
  /**< The value of <{index}> ranges from 0 to <{itemCount()}> - 1. */
private:
  MString mTransactionUID;
  MString mRetrieveAETitle;
  MStorageCommitItemVector mItemVector;
};

inline ostream& operator<< (ostream& s, const MStorageCommitRequest& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MStorageCommitRequest& c) {
  c.streamIn(s);
  return s;
}

#endif
