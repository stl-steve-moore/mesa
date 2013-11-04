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

// $Id: MBeginTransferDICOMInstances.hpp,v 1.1 2009/03/30 18:30:59 smm Exp $ $Author: smm $ $Revision: 1.1 $ $Date: 2009/03/30 18:30:59 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MBeginTransferDICOMInstances.hpp
//
//  = AUTHOR
//	Steve Moore
//
//  = COPYRIGHT
//	Copyright HIMSS, RSNA, Washington University: 2002
//
// ====================
//
//  = VERSION
//	$Revision: 1.1 $
//
//  = DATE RELEASED
//	$Date: 2009/03/30 18:30:59 $
//
//  = COMMENTS

#ifndef MBeginTransferDICOMInstancesISIN
#define MBeginTransferDICOMInstancesISIN

//#include <iostream>
//#include <string>

using namespace std;

class MBeginTransferDICOMInstances
// = TITLE
//	MBeginTransferDICOMInstances
//
// = DESCRIPTION

{
public:
  // = The standard methods in this framework.

  //MBeginTransferDICOMInstances();
  ///< Default constructor

  MBeginTransferDICOMInstances(const MBeginTransferDICOMInstances& cpy);
  ///< Copy constructor

  virtual ~MBeginTransferDICOMInstances();
  ///< Destructor

  virtual void printOn(ostream& s) const;
  /**<\brief This method is used in conjunction with the streaming operator <<
  	     to print the current state of MBeginTransferDICOMInstances */

  virtual void streamIn(istream& s);
  /**<\brief This method is used in conjuction with the streaming operator >>
  	     to read the current state of MBeginTransferDICOMInstances. */
  
  // = Class specific methods.

  MBeginTransferDICOMInstances(const MString& eventOutcomeIndicator);

  virtual MString exportXML( );

protected:

private:
  MString mEventOutcomeIndicator;
};

inline ostream& operator<< (ostream& s, const MBeginTransferDICOMInstances& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MBeginTransferDICOMInstances& c) {
  c.streamIn(s);
  return s;
}

#endif
