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

// $Id: MStorageCommitItem.hpp,v 1.7 2006/06/29 16:08:31 bhasselfeld Exp $ $Author: bhasselfeld $ $Revision: 1.7 $ $Date: 2006/06/29 16:08:31 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MStorageCommitItem.hpp
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
//	$Revision: 1.7 $
//
//  = DATE RELEASED
//	$Date: 2006/06/29 16:08:31 $
//
//  = COMMENTS
//

#ifndef MStorageCommitItemISIN
#define MStorageCommitItemISIN

#include <iostream>
#include "MDomainObject.hpp"
#include <vector>

class MStorageCommitItem;
typedef vector < MStorageCommitItem > MStorageCommitItemVector;

using namespace std;

class MStorageCommitItem : public MDomainObject
// = TITLE
///	A domain object that corresponds to a DICOM Storage Commit item.
//
// = DESCRIPTION
/**	This class is a container for attributes which define a DICOM
	Storage Commit item.  It inherits from <{MDomainObject}> and supports
	the ability to get and set values with specific methods.  Because this
	class is just a container, it performs no validation tests. */
{
public:
  // = The standard methods in this framework.

  MStorageCommitItem();
  ///< Default constructor

  MStorageCommitItem(const MStorageCommitItem& cpy);

  virtual ~MStorageCommitItem();

  virtual void printOn(ostream& s) const;
  /**<\brief This method is used in conjunction with the streaming operator <<
  	     to print the current state of MStorageCommitItem. */

  virtual void streamIn(istream& s);
  /**<\brief This method is used in conjunction with the streaming operator >>
   	     to read the current state of MStorageCommitItem. */

  // = Class specific methods.

  MStorageCommitItem(const MString& sopClass, const MString& sopInstance,
		     const MString& transactionUID,
		     const MString& status = "0");
  /**<\brief This constructor takes a variable for each attribute managed by this
  	     class.  The value of each variable is copied into the internal state
             managed by this object. */

  void import(const MDomainObject& o);
  ///< This method imports the key-value pairs from the MDomainObject <{o}>.
  /**< The values are copied from <{o}> and stored in the internal state
       maintained by this object. */

  MString sopClass() const;
  /**<\brief Return a copy of the DICOM SOP Class UID for the instance which is
   	     to be stored/committed.	*/

  MString sopInstance() const;
  /**<\brief Return a copy of the DICOM SOP Instance UID for the instance which is
  	     to be stored/committed. */

  MString transactionUID() const;
  ///< Return a copy of the DICOM Transaction UID of the Storage Commitment request.

  MString status() const;
  /**<\brief Return a copy of the status maintained for this SOP instance.
  	     Status indicates if the SOP instance has been committed.  This is
   	     a MESA definition, not DICOM. */

  void sopClass(const MString& sopClass);
  ///< Set the SOP Class UID to the value in <{sopClass}>.

  void sopInstance(const MString& sopInstance);
  ///< Set the SOP Instance UID to the value in <{sopInstance}>.

  void transactionUID(const MString& transactionUID);
  ///< Set the Transaction UID to the value in <{transactionUID}>.

  void status(const MString& status);
  ///< Set the storage status to the value in <{status}>.

private:
  MString mSOPClass;
  MString mSOPInstance;
  MString mTransactionUID;
  MString mStatus;
};

inline ostream& operator<< (ostream& s, const MStorageCommitItem& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MStorageCommitItem& c) {
  c.streamIn(s);
  return s;
}

#endif
