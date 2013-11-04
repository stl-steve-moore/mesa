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

// $Id: MUPSObjects.hpp,v 1.2 2008/03/19 20:42:41 smm Exp $ $Author: smm $ $Revision: 1.2 $ $Date: 2008/03/19 20:42:41 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MUPSObjects.hpp
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
//	$Revision: 1.2 $
//
//  = DATE RELEASED
//	$Date: 2008/03/19 20:42:41 $
//
//  = COMMENTS
//

#ifndef MUPSObjectsISIN
#define MUPSObjectsISIN

#include <iostream>
#include <string>

#include "MUPS.hpp"
#include "MUWLScheduledStationNameCode.hpp"

class MUPSObjects;
typedef vector < MUPSObjects > MUPSObjectsVector;

using namespace std;

class MUPSObjects
// = TITLE
///	A container class holding two different kinds of UPS objects.
//
// = DESCRIPTION
/**	This class is a container which holds MUPS and MUWLScheduledStationNameCodeVector
	objects.  It is a convenience for managing and passing these
	objects around as a single unit. */
{
public:

  // = The standard methods in this framework.

  //MUPSObjects();
  // Default constructor

  MUPSObjects(const MUPSObjects& cpy);

  virtual ~MUPSObjects();

  virtual void printOn(ostream& s) const;
  /**< This method is used in conjunction with the streaming operator <<
       to print the current state of MUPSObjects. */

  virtual void streamIn(istream& s);
  /**< This method is used in conjunction with the streaming operator >>
       to read the current state of MUPSObjects. */
  
  // = Class specific methods.

  MUPSObjects(const MUPS& ups, const MUWLScheduledStationNameCodeVector& ssnCodeVector);
  ///< This constructor takes a Modality Worklist object and a vector of Scheduled Station Name Code bojects
  /**< The values are copied to the internal state of this object. */

  MUPS ups();
  ///< Return a copy of the MUPS object maintained by this class.

  MUWLScheduledStationNameCodeVector  ssnCodeVector();
  ///< Return a copy of the SSN Code vector maintained by this class.

private:
  MUPS mUPS;
  MUWLScheduledStationNameCodeVector mMUWLScheduledStationNameCodeVector;
};

inline ostream& operator<< (ostream& s, const MUPSObjects& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MUPSObjects& c) {
  c.streamIn(s);
  return s;
}

#endif
