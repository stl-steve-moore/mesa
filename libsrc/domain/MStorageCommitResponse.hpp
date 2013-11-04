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

// $Id: MStorageCommitResponse.hpp,v 1.6 2006/06/29 16:08:31 bhasselfeld Exp $ $Author: bhasselfeld $ $Revision: 1.6 $ $Date: 2006/06/29 16:08:31 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MStorageCommitResponse.hpp
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

#ifndef MStorageCommitResponseISIN
#define MStorageCommitResponseISIN

#include <iostream>
#include <string>

#include "MStorageCommitItem.hpp"

using namespace std;

class MStorageCommitResponse
// = TITLE
///	Corresponds to a DICOM Storage Commitment Response.
//
// = DESCRIPTION
/**	This class is a container for attributes which define a DICOM
	Storage Commitment Response.  It  supports the
	ability to get and set values with specific methods.  Because this
	class is just a container, it performs no validation tests. */
{
public:
  // = The standard methods in this framework.

  MStorageCommitResponse();
  ///< Default constructor

  MStorageCommitResponse(const MStorageCommitResponse& cpy);

  virtual ~MStorageCommitResponse();

  virtual void printOn(ostream& s) const;
  /**<\brief This method is used in conjunction with the streaming operator <<
  	     to print the current state of MStorageCommitResponse. */

  virtual void streamIn(istream& s);
  /**<\brief This method is used in conjunction with the streaming operator >>
  	     to read the current state of MStorageCommitResponse. */

  // = Class specific methods.

  void transactionUID(const MString& transactionUID);
  ///< Set the value of the Transaction UID to that passed in <{transactionUID}>.

  void retrieveAETitle(const MString& retrieveAETitle);
  ///< Set the value of Retrieve AE title to that passed in <{retrieveAETitle}>.

  void addSuccessItem(const MStorageCommitItem& item);
  /**<\brief Add one successful Storage Commitment item to the internal vector
  	     maintained by this class.  The attributes from <{item}> are copied and
   	     placed in the vector. */

  void addFailureItem(const MStorageCommitItem& item);
  /**<\brief Add one failure Storage Commitment item to the internal vector
  	     maintained by this class.  The attributes from <{item}> are copied and
	     placed in the vector. */

  MString transactionUID() const;
  ///< Return a copy of the Transaction UID.

  MString retrieveAETitle() const;
  ///< Return a copy of the Retrieve AE title.

  int successItemCount() const;
  ///< Return the number of items stored in the vector of successful Storage Commitment items (one/SOP instance).

  int failureItemCount() const;
  ///< Return the number of items stored in the vector of failed Storage Commitment items (one/SOP instance).

  MStorageCommitItem successItem(int index) const;
  /**<\brief Return one item from the internal vector of successful Storage
  	     Commitment items.  <{index}> begins counting at 0. */

  MStorageCommitItem failureItem(int index) const;
  /**<\brief Return one item from the internal vector of failed Storage
  	     Commitment items.  <{index}> begins counting at 0. */

private:
  MString mTransactionUID;
  MString mRetrieveAETitle;
  MStorageCommitItemVector mSuccessItemVector;
  MStorageCommitItemVector mFailureItemVector;
};

inline ostream& operator<< (ostream& s, const MStorageCommitResponse& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MStorageCommitResponse& c) {
  c.streamIn(s);
  return s;
}

#endif
