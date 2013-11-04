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

// $Id: MLGPSPS.hpp,v 1.1 2002/07/17 19:50:46 drm Exp $ $Author: drm $ $Revision: 1.1 $ $Date: 2002/07/17 19:50:46 $ $State: Exp $
//
// ====================
//  = LIBRARY
//	xxx
//
//  = FILENAME
//	MLGPSPS.hpp
//
//  = AUTHOR
//	Author Name
//
//  = COPYRIGHT
//	Copyright Washington University, 1999
//
// ====================
//
//  = VERSION
//	$Revision: 1.1 $
//
//  = DATE RELEASED
//	$Date: 2002/07/17 19:50:46 $
//
//  = COMMENTTEXT
//	Comments

#ifndef MLGPSPSISIN
#define MLGPSPSISIN

#include <iostream>
#include <string>

#include "MESA.hpp"
#include "MSOPHandler.hpp"
#include "MDBPostProcMgr.hpp"

class MDBImageManager;

using namespace std;

class MLGPSPS : public MSOPHandler
// = TITLE
//	Short title/description
//
// = DESCRIPTION
//	Describe the class and how to use it
{
public:
  // = The standard methods in this framework.
  //MLGPSPS();
  // Default constructor
  MLGPSPS(const MLGPSPS& cpy);
  virtual ~MLGPSPS();
  virtual void printOn(ostream& s) const;
  // This method is used in conjunction with the streaming operator <<
  // to print the current state of MLGPSPS

  virtual void streamIn(istream& s);

  MLGPSPS( MDBPostProcMgr& mgr, MString logDir);

  int initialize();

  CONDITION handleNActionCommand(DUL_PRESENTATIONCONTEXT* ctx,
				 MSG_N_ACTION_REQ** message,
				 MSG_N_ACTION_RESP* response,
				 DUL_ASSOCIATESERVICEPARAMETERS* params,
				 MString& directoryName);

  CONDITION handleNActionDataSet(DUL_PRESENTATIONCONTEXT* ctx,
				 MSG_N_ACTION_REQ** message,
				 MSG_N_ACTION_RESP* response,
				 DUL_ASSOCIATESERVICEPARAMETERS* params,
				 MString& directoryName);

  // = Class specific methods.
private:
  MString mLogDir;
  MDBPostProcMgr& mPostProcMgr;
};

inline ostream& operator<< (ostream& s, const MLGPSPS& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MLGPSPS& c) {
  c.streamIn(s);
  return s;
}

#endif
