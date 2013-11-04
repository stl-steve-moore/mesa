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

// $Id: MIssuer.hpp,v 1.2 2006/06/29 16:08:31 bhasselfeld Exp $ $Author: bhasselfeld $ $Revision: 1.2 $ $Date: 2006/06/29 16:08:31 $ $State: Exp $
// ======================
// = FILENAME
//	MIssuer.hpp
//
// = AUTHOR
//	Steve Moore
//
//  = COPYRIGHT
//	Copyright HIMSS, RSNA, Washington University: 1999, 2000
// ====================
//
//  = VERSION
//	$Revision: 1.2 $
//
//  = DATE RELEASED
//	$Date: 2006/06/29 16:08:31 $
//
//  = COMMENTS
//
#ifndef MIssuerISIN
#define MIssuerISIN

#include <iostream>
#include "MDomainObject.hpp"

class MIssuer;
typedef vector < MIssuer > MIssuerVector;

using namespace std;

// = TITLE
///	A domain object which represents an issuer of an identifier .
//
// = DESCRIPTION
/**	This class is a container for attributes which define an issuer.
	It inherits from <{MDomainObject}> and supports the
	ability to get and set values with specific methods.  Because this
	class is just a container, it performs no validation tests. */

class MIssuer : public MDomainObject
{
public:
  // The standard methods in this framework.

  MIssuer();
  ///< Default constructor.

  MIssuer(const MIssuer& issuer);

  ~MIssuer();

  virtual void printOn(ostream& s) const;

  virtual void streamIn(istream& s);

  // Class specific methods.

  MIssuer(const MString& issuer);
  ///< This constructor takes all of the attributes which are managed by this class.

  void import(const MDomainObject& o);
  ///< This method imports the key-value pairs which are in the domain object <{o}>.  
  /**< These values are used to overwrite any existing values in the MIssuer object. */

  // Get methods whose names match attribute names.
  MString issuer() const;

  // Set methods whose names match attribute names.
  void issuer(const MString& s);

private:
  
  MString mIssuer;

  void fillMap();

};

inline ostream& operator<< (ostream& s, const MIssuer& issuer) {
	  issuer.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MIssuer& issuer) {
  issuer.streamIn(s);
  return s;
}

#endif
