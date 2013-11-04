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

// $Id: MLStorage.hpp,v 1.2 2004/08/04 17:40:59 smm Exp $ $Author: smm $ $Revision: 1.2 $ $Date: 2004/08/04 17:40:59 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MLStorage.hpp
//
//  = AUTHOR
//	Steve Moore
//
//  = COPYRIGHT
//	Copyright Washington University, 1999
//
// ====================
//
//  = VERSION
//	$Revision: 1.2 $
//
//  = DATE RELEASED
//	$Date: 2004/08/04 17:40:59 $
//
//  = COMMENTS
//

#ifndef MLStorageISIN
#define MLStorageISIN

#include <iostream>
#include <string>

#include "MESA.hpp"
#include "MSOPStorageHandler.hpp"

class MDBImageManager;

using namespace std;

class MLStorage : public MSOPStorageHandler
// = TITLE
//	Short title/description
//
// = DESCRIPTION
//	Describe the class and how to use it
{
public:
  // = The standard methods in this framework.
  //MLStorage();
  // Default constructor
  MLStorage(const MLStorage& cpy);
  virtual ~MLStorage();
  virtual void printOn(ostream& s) const;
  // This method is used in conjunction with the streaming operator <<
  // to print the current state of MLStorage

  virtual void streamIn(istream& s);

  MLStorage(MDBImageManager* manager, const MString& logDir,
	    const MString& storageDir);

  int initialize();

  CONDITION handleCStoreCommand(DUL_PRESENTATIONCONTEXT* ctx,
				MSG_C_STORE_REQ** message,
				MSG_C_STORE_RESP* response,
				DUL_ASSOCIATESERVICEPARAMETERS* params,
				MString& fileName);

  CONDITION handleCStoreDataSet(DUL_PRESENTATIONCONTEXT* ctx,
				MSG_C_STORE_REQ** message,
				MSG_C_STORE_RESP* response,
				DUL_ASSOCIATESERVICEPARAMETERS* params,
				MString& fileName);
  
  // = Class specific methods.
private:
  MDBImageManager* mImageManager;
  MString mLogDir;
  MString mStorageDir;
};

inline ostream& operator<< (ostream& s, const MLStorage& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MLStorage& c) {
  c.streamIn(s);
  return s;
}

#endif
