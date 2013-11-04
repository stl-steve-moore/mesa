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

// $Id: MLStorageCommitmentSCU.hpp,v 1.2 2006/09/04 18:34:21 smm Exp $ $Author: smm $ $Revision: 1.2 $ $Date: 2006/09/04 18:34:21 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MLStorageCommitmentSCU.hpp
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
//	$Revision: 1.2 $
//
//  = DATE RELEASED
//	$Date: 2006/09/04 18:34:21 $
//
//  = COMMENTTEXT
//	Comments

#ifndef MLStorageCommitmentSCUISIN
#define MLStorageCommitmentSCUISIN

#include <iostream>
#include <string>

#include "MESA.hpp"
#include "MSOPHandler.hpp"

class MDBImageManager;

using namespace std;

class MLStorageCommitmentSCU : public MSOPHandler
// = TITLE
//	Short title/description
//
// = DESCRIPTION
//	Describe the class and how to use it
{
public:
  // = The standard methods in this framework.
  //MLStorageCommitmentSCU();
  // Default constructor
  MLStorageCommitmentSCU(const MLStorageCommitmentSCU& cpy);
  virtual ~MLStorageCommitmentSCU();
  virtual void printOn(ostream& s) const;
  // This method is used in conjunction with the streaming operator <<
  // to print the current state of MLStorageCommitmentSCU

  virtual void streamIn(istream& s);

  MLStorageCommitmentSCU(MDBImageManager& manager,
			const MString& storageDir);

  int initialize();

  bool supportsSCRole(DUL_SC_ROLE role);

  CONDITION handleNEventCommand(DUL_PRESENTATIONCONTEXT* ctx,
				MSG_N_EVENT_REPORT_REQ** message,
				MSG_N_EVENT_REPORT_RESP* response,
				DUL_ASSOCIATESERVICEPARAMETERS* params,
				MString& directoryName);

  CONDITION handleNEventDataSet(DUL_PRESENTATIONCONTEXT* ctx,
				MSG_N_EVENT_REPORT_REQ** message,
				MSG_N_EVENT_REPORT_RESP* response,
				DUL_ASSOCIATESERVICEPARAMETERS* params,
				MString& directoryName);

  // = Class specific methods.
private:
  MDBImageManager& mImageManager;
  MString mStorageDir;
};

inline ostream& operator<< (ostream& s, const MLStorageCommitmentSCU& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MLStorageCommitmentSCU& c) {
  c.streamIn(s);
  return s;
}

#endif
