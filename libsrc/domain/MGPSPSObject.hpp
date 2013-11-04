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

// $Id: MGPSPSObject.hpp,v 1.2 2006/06/29 16:08:30 bhasselfeld Exp $ $Author: bhasselfeld $ $Revision: 1.2 $ $Date: 2006/06/29 16:08:30 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MGPSPSObject.hpp
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
//	$Revision: 1.2 $
//
//  = DATE RELEASED
//	$Date: 2006/06/29 16:08:30 $
//
//  = COMMENTS
//	Modeled on MMWLObjects.hpp
//

#ifndef MGPSPSObjectISIN
#define MGPSPSObjectISIN

#include <iostream>
#include <string>

#include "MGPWorkitem.hpp"
#include "MStationName.hpp"
#include "MStationClass.hpp"
#include "MStationLocation.hpp"
#include "MInputInfo.hpp"
#include "MDBInterface.hpp"

class MGPSPSObject;
typedef vector < MGPSPSObject > MGPSPSObjectVector;

using namespace std;

class MGPSPSObject
// = TITLE
///	A container class holding the objecsts that compose a General Purpose Worklist.
//
// = DESCRIPTION
/**	This class is a container which holds MGPWorkitem and other-to-be-named
	objects.  It is a convenience for managing and passing these
	objects around as a single unit. */
{
public:

  // = The standard methods in this framework.

  /// Default constructor
  MGPSPSObject();

  MGPSPSObject(const MGPSPSObject& cpy);

  virtual ~MGPSPSObject();

  virtual void printOn(ostream& s) const;
  /**<\brief This method is used in conjunction with the streaming operator <<
  	     to print the current state of MGPSPSObject. */

  virtual void streamIn(istream& s);
  /**<\brief This method is used in conjunction with the streaming operator >>
  	     to read the current state of MGPSPSObject. */
  
  // = Class specific methods.

  MGPSPSObject(const MGPWorkitem& workitem);
  ///< This constructor takes a General Purpose Workitem object.
  /**< The value are copied to the internal state of this object.
       Other objects are added to this object using the set methods. */

  // Return a copy of the objects maintained by this class.
  MGPWorkitem workitem();
  MStationNameVector stationNameVector();
  MStationClassVector stationClassVector();
  MStationLocationVector stationLocationVector();
  MInputInfoVector inputInfoVector();

  // set methods
  void stationNameVector( MStationNameVector& snv );
  void stationClassVector( MStationClassVector& scv );
  void stationLocationVector( MStationLocationVector& slv );
  void inputInfoVector( MInputInfoVector& iiv );
  void addStationName( MStationName& sn );
  void addStationClass( MStationClass& sc );
  void addStationLocation( MStationLocation& sc );
  void workitem( MGPWorkitem wi );
  void SOPInstanceUID( MString& s );

  /// Insert this object into the database.
  void insert( MDBInterface& db);

private:
  MGPWorkitem mGPWorkitem;
  MStationNameVector mStationNameVector;
  MStationClassVector mStationClassVector;
  MStationLocationVector mStationLocationVector;
  MInputInfoVector mInputInfoVector;
};

inline ostream& operator<< (ostream& s, const MGPSPSObject& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MGPSPSObject& c) {
  c.streamIn(s);
  return s;
}

#endif
