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

// $Id: MSOPStorageHandler.hpp,v 1.6 2006/06/29 16:08:29 bhasselfeld Exp $ $Author: bhasselfeld $ $Revision: 1.6 $ $Date: 2006/06/29 16:08:29 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MSOPStorageHandler.hpp
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
//	$Date: 2006/06/29 16:08:29 $
//
//  = COMMENTS
//	This class is deprecated and will be retired.

#ifndef MSOPStorageHandlerISIN
#define MSOPStorageHandlerISIN

#include <iostream>
#include <string>

#include "MSOPHandler.hpp"

using namespace std;

class MSOPStorageHandler : public MSOPHandler
// = TITLE
//	Short title/description
//
// = DESCRIPTION
//	Describe the class and how to use it
{
public:
  // = The standard methods in this framework.

  MSOPStorageHandler();
  ///< Default constructor

  MSOPStorageHandler(const MSOPStorageHandler& cpy);

  virtual ~MSOPStorageHandler();

  virtual void printOn(ostream& s) const;
  /**<\brief This method is used in conjunction with the streaming operator <<
   to print the current state of MSOPStorageHandler */

  virtual void streamIn(istream& s);
  
  // = Class specific methods.

  virtual CONDITION handleCStoreCommand(DUL_PRESENTATIONCONTEXT* ctx,
					MSG_C_STORE_REQ** message,
					MSG_C_STORE_RESP* response,
					DUL_ASSOCIATESERVICEPARAMETERS* params,
					MString& fileName);

  virtual CONDITION handleCStoreDataSet(DUL_PRESENTATIONCONTEXT* ctx,
					MSG_C_STORE_REQ** message,
					MSG_C_STORE_RESP* response,
					DUL_ASSOCIATESERVICEPARAMETERS* params,
					MString& fileName);
private:
};

inline ostream& operator<< (ostream& s, const MSOPStorageHandler& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MSOPStorageHandler& c) {
  c.streamIn(s);
  return s;
}

#endif
