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

// $Id: MDBOFClient.hpp,v 1.9 2008/03/19 20:44:29 smm Exp $ $Author: smm $ $Revision: 1.9 $ $Date: 2008/03/19 20:44:29 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MDBOFClient.hpp
//
//  = AUTHOR
//	Phil DiCorpo
//
//  = COPYRIGHT
//	Copyright HIMSS, RSNA, Washington University: 1999, 2000
//
// ====================
//
//  = VERSION
//	$Revision: 1.9 $
//
//  = DATE RELEASED
//	$Date: 2008/03/19 20:44:29 $
//
//  = COMMENTS

#ifndef MDBOFClientISIN
#define MDBOFClientISIN

#include <iostream>
#include <string>

class MMWL;
class MUPS;
#include "MMWLObjects.hpp"
#include "MUPSObjects.hpp"
//class MActionItemVector;
//class MCodeItemVector;

using namespace std;

class MDBOFClient
// = TITLE
///	Client class for the Order Filler Database Interface.
//
// = DESCRIPTION
/**	Users of the select methods of the MDBOrderFiller class implement
	this class.  The user should override the <{selectCallback}> methods
	which are invoked by the MDBOrderFiller for each matching row in
	a select operation. */
{
public:
  // = The standard methods in this framework.

  MDBOFClient();
  ///< Default constructor

  MDBOFClient(const MDBOFClient& cpy);

  virtual ~MDBOFClient();

  virtual void printOn(ostream& s) const;
  /**<\brief This method is used in conjunction with the streaming operator <<
   to print the current state of MDBOFClient. */

  virtual void streamIn(istream& s);
  
  // = Class specific methods.
  
  //pure virtual
  virtual int selectCallback(const MMWL& mwl,
			     const MActionItemVector& actionItem)=0;
  virtual int selectCallback(const MUPS& ups,
			     const MUWLScheduledStationNameCodeVector& ssnCodeVector)=0;
  ///< User of the <{MDBOrderFiller::queryModalityWorklist}> method should override and implement this method.  
  /**< The <{MDBOrderFiller}> will invoke this method for every matching MWL record.  The <{MDBOrderFiller}> fills
  in <{mwl}> with one record and the <{actionItem}> vector with the 
  proper number of action items. */

private:
};

inline ostream& operator<< (ostream& s, const MDBOFClient& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MDBOFClient& c) {
  c.streamIn(s);
  return s;
}

#endif
