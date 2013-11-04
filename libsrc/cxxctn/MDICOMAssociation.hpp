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

// $Id: MDICOMAssociation.hpp,v 1.4 2006/06/29 16:08:29 bhasselfeld Exp $ $Author: bhasselfeld $ $Revision: 1.4 $ $Date: 2006/06/29 16:08:29 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MDICOMAssociation.hpp
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
//	$Revision: 1.4 $
//
//  = DATE RELEASED
//	$Date: 2006/06/29 16:08:29 $
//
//  = COMMENTS
//	Based on the Reactor pattern found in the ACE project.

#ifndef MDICOMAssociationISIN
#define MDICOMAssociationISIN

#include <iostream>
#include <string>
#include <map>

#include "ctn_api.h"

using namespace std;

class MDICOMProxy;

class MDICOMAssociation
// = TITLE
//	MDICOMAssociation
//
// = DESCRIPTION

{
public:
  // = The standard methods in this framework.

  MDICOMAssociation();
  ///< Default constructor.

  MDICOMAssociation(const MDICOMAssociation& cpy);
  ///< Copy constructor.

  virtual ~MDICOMAssociation();
  ///< Destructor.

  virtual void printOn(ostream& s) const;
  /**<\brief This method is used in conjunction with the streaming operator <<
   to print the current state of MDICOMAssociation. */

  virtual void streamIn(istream& s);
  /**<\brief This method is used in conjunction with the streaming operator <<
   to print the current state of MDICOMAssociation. */
  
  int registerSOPClass(const MString& sopClass, DUL_SC_ROLE role);

  int registerSOPClass(const MString& sopClass, DUL_SC_ROLE role,
	const MString& xferSyntax1, const MString& xferSyntax2 = "",
	const MString& xferSyntax3 = "");

  int releaseAssociation();

  int requestAssociation(const MString& callingAE,
	  const MString& calledAE, const MString& node, int port);

  int requestAssociation(CTN_SOCKET sock, const MString& callingAE,
	  const MString& calledAE);

  int requestAssociation(MDICOMProxy& proxy, const MString& callingAE,
	  const MString& calledAE);

  DUL_ASSOCIATESERVICEPARAMETERS* getParameters();

  DUL_ASSOCIATIONKEY* getAssociationKey();

protected:


private:
  DUL_NETWORKKEY* mNetworkKey;
  DUL_ASSOCIATIONKEY* mAssociationKey;
  DUL_ASSOCIATESERVICEPARAMETERS mServiceParameters;

};

inline ostream& operator<< (ostream& s, const MDICOMAssociation& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MDICOMAssociation& c) {
  c.streamIn(s);
  return s;
}

#endif
