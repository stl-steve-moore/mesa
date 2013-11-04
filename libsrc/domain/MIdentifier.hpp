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

// $Id: MIdentifier.hpp,v 1.15 2006/06/29 16:08:30 bhasselfeld Exp $ $Author: bhasselfeld $ $Revision: 1.15 $ $Date: 2006/06/29 16:08:30 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MIdentifier.hpp
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
//	$Revision: 1.15 $
//
//  = DATE RELEASED
//	$Date: 2006/06/29 16:08:30 $
//
//  = COMMENTS
//

#ifndef MIdentifierISIN
#define MIdentifierISIN

#include <iostream>
#include <string>

class MDBInterface;

using namespace std;

class MIdentifier
// = TITLE
///	A class that creates class specific identifiers for the user.
//
// = DESCRIPTION
/**	This object maintains an interface to a database for tracking
	the "next" open identifier in a class.  The caller can ask for
	and receive identifiers for different classes (patient ID,
	DICOM Study Instance UID, ...). */
{
  public:

  // = The standard methods in this framework.

  MIdentifier();
  ///< Default constructor

  MIdentifier(const MIdentifier& cpy);

  virtual ~MIdentifier();

  virtual void printOn(ostream& s) const;
  /**<\brief This method is used in conjunction with the streaming operator <<
  	     to print the current state of MIdentifier. */

  virtual void streamIn(istream& s);
  /**\brief This method is used in conjunction with the streaming operator >>
	    to read the current state of MIdentifier. */

  // = Class specific methods.
  typedef enum { MUID_PATIENT = 10, MUID_VISIT, MUID_STUDY,
		MUID_SERIES, MUID_SOPINSTANCE, MUID_RESULTS,
		MUID_INTERP, MUID_PRINTER, MUID_DEVICE,
		MUID_STUDYCOMPONENT, MUID_TRANSACTION,
		MUID_PPS, MUID_GPSPS, MUID_GPPPS } MUID_TYPE;
  ///< Enumerate the type of UIDs supported.

  MString dicomUID(MUID_TYPE t, MDBInterface& dbInterface) const;
  /**<\brief This method returns a DICOM UID.  In the argument list,
  	     <{t}> defines the type of requested UID and <{dbInterface}> is
  	     a handle to an open database which contains the information on
  	     available identifiers. */

  typedef enum { MID_PATIENT, MID_PLACERORDERNUMBER,
		 MID_FILLERORDERNUMBER, MID_REQUESTEDPROCEDURE,
		 MID_SPSID, MID_PPSID, MID_STUDYID, MID_VISITNUMBER,
		 MID_ACCOUNTNUMBER, MID_MESSAGECONTROLID, MID_FILLERAPPOINTMENTID
  } MID_TYPE;
  ///< Enumerate the type of identifiers (not DICOM UID) supported.

  MString mesaID(MID_TYPE t, MDBInterface& dbInterface) const;
  /**<\brief This method returns a MESA identifier.  A MESA identifier should
  	     be unique within the MESA system, but is not globally unique as is
  	     a DICOM UID.  */
  /**< In the argument list, <{t}> defines the type of
       identifier requested and <{dbInterface}> is a handle to an open
       database which contains the information on available identifiers. */

private:
  MString mTypeID;
  MString mPrefix;
  MString mNextValue;
};

inline ostream& operator<< (ostream& s, const MIdentifier& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MIdentifier& c) {
  c.streamIn(s);
  return s;
}

#endif
