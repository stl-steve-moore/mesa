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

// $Id: MMWLObjects.hpp,v 1.6 2006/06/29 16:08:31 bhasselfeld Exp $ $Author: bhasselfeld $ $Revision: 1.6 $ $Date: 2006/06/29 16:08:31 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MMWLObjects.hpp
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
//	$Revision: 1.6 $
//
//  = DATE RELEASED
//	$Date: 2006/06/29 16:08:31 $
//
//  = COMMENTS
//

#ifndef MMWLObjectsISIN
#define MMWLObjectsISIN

#include <iostream>
#include <string>

#include "MMWL.hpp"
#include "MActionItem.hpp"

class MMWLObjects;
typedef vector < MMWLObjects > MMWLObjectsVector;
typedef vector < MActionItem > MActionItemVector;

using namespace std;

class MMWLObjects
// = TITLE
///	A container class holding two different kinds of MWL objects.
//
// = DESCRIPTION
/**	This class is a container which holds MMWL and MActionItemVector
	objects.  It is a convenience for managing and passing these
	objects around as a single unit. */
{
public:

  // = The standard methods in this framework.

  //MMWLObjects();
  // Default constructor

  MMWLObjects(const MMWLObjects& cpy);

  virtual ~MMWLObjects();

  virtual void printOn(ostream& s) const;
  /**< This method is used in conjunction with the streaming operator <<
       to print the current state of MMWLObjects. */

  virtual void streamIn(istream& s);
  /**< This method is used in conjunction with the streaming operator >>
       to read the current state of MMWLObjects. */
  
  // = Class specific methods.

  MMWLObjects(const MMWL& mwl, const MActionItemVector& actionitem);
  ///< This constructor takes a Modality Worklist object and a vector of action items.  
  /**< The values are copied to the internal state of this object. */

  MMWL mwl();
  ///< Return a copy of the MMWL object maintained by this class.

  MActionItemVector actionItemVector();
  ///< Return a copy of the Action Item vector maintained by this class.

private:
  MMWL mMWL;
  MActionItemVector mActionItemVector;
};

inline ostream& operator<< (ostream& s, const MMWLObjects& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MMWLObjects& c) {
  c.streamIn(s);
  return s;
}

#endif
