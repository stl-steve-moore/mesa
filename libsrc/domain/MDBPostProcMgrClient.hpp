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

// $Id: MDBPostProcMgrClient.hpp,v 1.3 2006/06/29 16:08:30 bhasselfeld Exp $ $Author: bhasselfeld $ $Revision: 1.3 $ $Date: 2006/06/29 16:08:30 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MDBPostProcMgrClient.hpp
//
//  = AUTHOR
//	David Maffitt
//
//  = COPYRIGHT
//	Copyright HIMSS, RSNA, Washington University: 1999, 2000
//
// ====================
//
//  = VERSION
//	$Revision: 1.3 $
//
//  = DATE RELEASED
//	$Date: 2006/06/29 16:08:30 $
//
//  = COMMENTS

#ifndef MDBPostProcMgrClientISIN
#define MDBPostProcMgrClientISIN

#include <iostream>
#include <string>

class MGPWorkitem;
#include "MGPWorkitemObject.hpp"
//class MActionItemVector;
//class MCodeItemVector;

using namespace std;

class MDBPostProcMgrClient
// = TITLE
///	Client class for the Post Processing Manager Database Interface.
//
// = DESCRIPTION
/**	Users of the select methods of the MDBPostProcMgr class implement
	this class.  The user should override the <{selectCallback}> methods
	which are invoked by the MDBPostProcMgr for each matching row in
	a select operation. */
{
public:
  // = The standard methods in this framework.

  MDBPostProcMgrClient();
  ///< Default constructor

  MDBPostProcMgrClient(const MDBPostProcMgrClient& cpy);

  virtual ~MDBPostProcMgrClient();

  virtual void printOn(ostream& s) const;
  /**<\brief This method is used in conjunction with the streaming operator <<
   to print the current state of MDBPostProcMgrClient. */

  virtual void streamIn(istream& s);
  
  // = Class specific methods.
  
  //pure virtual
  virtual int selectCallback(const MGPWorkitemObject& workitemObject)=0;
  /**<\brief User of the <{MDBPostProcMgr::queryPostProcWorklist}> method should 
             override and implement this method.  The <{MDBPostProcMgr}> will invoke 
	     this method for every matching record.  The <{MDBPostProcMgr}> fills
  	     in <{workitemObject}> with one record. */
private:
};

inline ostream& operator<< (ostream& s, const MDBPostProcMgrClient& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MDBPostProcMgrClient& c) {
  c.streamIn(s);
  return s;
}

#endif
