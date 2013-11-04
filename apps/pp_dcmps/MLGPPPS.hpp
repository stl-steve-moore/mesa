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

// $Id: MLGPPPS.hpp,v 1.2 2003/07/21 19:36:12 smm Exp $ $Author: smm $ $Revision: 1.2 $ $Date: 2003/07/21 19:36:12 $ $State: Exp $
//
// ====================
//  = LIBRARY
//	xxx
//
//  = FILENAME
//	MLGPPPS.hpp
//
//  = AUTHOR
//	Author Name
//
//  = COPYRIGHT
//	Copyright Washington University, 2002
//
// ====================
//
//  = VERSION
//	$Revision: 1.2 $
//
//  = DATE RELEASED
//	$Date: 2003/07/21 19:36:12 $
//
//  = COMMENTTEXT
//	Comments

#ifndef MLGPPPSISIN
#define MLGPPPSISIN

#include <iostream>
#include <string>

#include "MESA.hpp"
#include "MSOPHandler.hpp"

class MDBPostProcMgr;

using namespace std;

class MLGPPPS : public MSOPHandler
// = TITLE
//	Short title/description
//
// = DESCRIPTION
//	Describe the class and how to use it
{
public:
  // = The standard methods in this framework.
  //MLGPPPS();
  // Default constructor
  MLGPPPS(const MLGPPPS& cpy);
  virtual ~MLGPPPS();
  virtual void printOn(ostream& s) const;
  // This method is used in conjunction with the streaming operator <<
  // to print the current state of MLGPPPS

  virtual void streamIn(istream& s);

  MLGPPPS(MDBPostProcMgr& manager,
	  const MString& logDir,
	  const MString& storageDir);

  int initialize();

  CONDITION handleNCreateCommand(DUL_PRESENTATIONCONTEXT* ctx,
				 MSG_N_CREATE_REQ** message,
				 MSG_N_CREATE_RESP* response,
				 DUL_ASSOCIATESERVICEPARAMETERS* params,
				 MString& directoryName);

  CONDITION handleNCreateDataSet(DUL_PRESENTATIONCONTEXT* ctx,
				 MSG_N_CREATE_REQ** message,
				 MSG_N_CREATE_RESP* response,
				 DUL_ASSOCIATESERVICEPARAMETERS* params,
				 MString& directoryName);

  CONDITION handleNSetCommand(DUL_PRESENTATIONCONTEXT* ctx,
			      MSG_N_SET_REQ** message,
			      MSG_N_SET_RESP* response,
			      DUL_ASSOCIATESERVICEPARAMETERS* params,
			      MString& directoryName);

  CONDITION handleNSetDataSet(DUL_PRESENTATIONCONTEXT* ctx,
			      MSG_N_SET_REQ** message,
			      MSG_N_SET_RESP* response,
			      DUL_ASSOCIATESERVICEPARAMETERS* params,
			      MString& directoryName);

  
  // = Class specific methods.
private:
  MDBPostProcMgr& mPostProcMgr;
  MString mLogDir;
  MString mStorageDir;
};

inline ostream& operator<< (ostream& s, const MLGPPPS& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MLGPPPS& c) {
  c.streamIn(s);
  return s;
}

#endif
