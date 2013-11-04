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

// $Id: MGPPPSObject.hpp,v 1.5 2006/06/29 16:08:30 bhasselfeld Exp $ $Author: bhasselfeld $ $Revision: 1.5 $ $Date: 2006/06/29 16:08:30 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MGPPPSObject.hpp
//
//  = AUTHOR
//	David Maffitt
//
//  = COPYRIGHT
//	Copyright HIMSS, RSNA, Washington University: 2002
//
// ====================
//
//  = VERSION
//	$Revision: 1.5 $
//
//  = DATE RELEASED
//	$Date: 2006/06/29 16:08:30 $
//
//  = COMMENTS
//	Modeled on MMWLObjects.hpp
//

#ifndef MGPPPSObjectISIN
#define MGPPPSObjectISIN

#include <iostream>
#include <string>

#include "MDICOMWrapper.hpp"
#include "MGPPPSWorkitem.hpp"
//#include "MDICOMDomainXlate.hpp"
#include "MDBInterface.hpp"
#include "MActHumanPerformers.hpp"
#include "MPerfStationName.hpp"
#include "MPerfStationClass.hpp"
#include "MPerfStationLocation.hpp"
#include "MPerfProcApps.hpp"
#include "MPerfWorkitem.hpp"
#include "MReqSubsWorkitem.hpp"
#include "MNonDCMOutput.hpp"
#include "MOutputInfo.hpp"
#include "MRefGPSPS.hpp"

class MGPPPSObject;
typedef vector < MGPPPSObject > MGPPPSObjectVector;

using namespace std;

class MGPPPSObject
// = TITLE
///	A container class holding the objecsts that compose a General Purpose Performed Procedure Step.
//
// = DESCRIPTION
/**	This class is a container which holds MGPPPSWorkitem and other
        domain objects that comprise a GP PPS object.
	It is a convenience for managing and passing these
	objects around as a single unit. */
{
public:

  // = The standard methods in this framework.

  /// Default constructor
  MGPPPSObject();

  MGPPPSObject(const MGPPPSObject& cpy);

#if 0
  MGPPPSObject( MDICOMWrapper& w);
#endif

  virtual ~MGPPPSObject();

  virtual void printOn(ostream& s) const;
  /**<\brief This method is used in conjunction with the streaming operator <<
             to print the current state of MGPPPSObject. */

  virtual void streamIn(istream& s);
  /**<\brief This method is used in conjunction with the streaming operator >>
  	     to read the current state of MGPPPSObject. */
  
  // = Class specific methods.

  MGPPPSObject(const MGPPPSWorkitem& workitem);
  ///< This constructor takes a General Purpose Workitem object.
  /**< The value are copied to the internal state of this object.
       Other objects are added to this object using the set methods. */

  // get methods
  // Return a copy of the objects maintained by this class.

  MGPPPSWorkitem workitem();
  MActHumanPerformersVector actualHumanPerformersVector();
  MPerfStationNameVector performedStationNameVector();
  MPerfStationClassVector performedStationClassVector();
  MPerfStationLocationVector performedStationLocationVector();
  MPerfProcAppsVector performedProcAppsVector();
  MPerfWorkitemVector performedWorkitemVector();
  MReqSubsWorkitemVector reqSubsWorkitemVector();
  MNonDCMOutputVector nonDCMOutputVector();
  MOutputInfoVector outputInfoVector();
  MRefGPSPSVector refGPSPSVector();

  MString status();
 

  // set methods
  void actualHumanPerformersVector( MActHumanPerformersVector& v );
  void addActHumanPerformer(  MActHumanPerformers& ahp );
  void workitem( MGPPPSWorkitem wi );
  void SOPInstanceUID( const MString& s );
  void performedStationNameVector(MPerfStationNameVector& v );
  void performedStationClassVector(MPerfStationClassVector& v );
  void performedStationLocationVector(MPerfStationLocationVector& v );
  void performedProcAppsVector(MPerfProcAppsVector& v );
  void performedWorkitemVector(MPerfWorkitemVector& v );
  void reqSubsWorkitemVector(MReqSubsWorkitemVector& v );
  void nonDCMOutputVector(MNonDCMOutputVector& v );
  void outputInfoVector(MOutputInfoVector& v );
  void refGPSPSVector(MRefGPSPSVector& v );

  /// Insert this object into the database.
  void insert( MDBInterface& db);

  // Update this object's entry in the database.
  //void update( MDBInterface& db);

private:
  MGPPPSWorkitem mWorkitem;
  MActHumanPerformersVector mActHumanPerformersVector;
  MPerfStationNameVector mPerfStationNameVector;
  MPerfStationClassVector mPerfStationClassVector;
  MPerfStationLocationVector mPerfStationLocationVector;
  MPerfProcAppsVector mPerfProcAppsVector;
  MPerfWorkitemVector mPerfWorkitemVector;
  MReqSubsWorkitemVector mReqSubsWorkitemVector;
  MNonDCMOutputVector mNonDCMOutputVector;
  MOutputInfoVector mOutputInfoVector;
  MRefGPSPSVector mRefGPSPSVector;

};

inline ostream& operator<< (ostream& s, const MGPPPSObject& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MGPPPSObject& c) {
  c.streamIn(s);
  return s;
}

#endif
