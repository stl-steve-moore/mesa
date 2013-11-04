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

// $Id: MLEvalImageAvail.hpp,v 1.1 2001/03/29 21:11:30 smm Exp $ $Author: smm $ $Revision: 1.1 $ $Date: 2001/03/29 21:11:30 $ $State: Exp $
//
// ====================
//  = LIBRARY
//	xxx
//
//  = FILENAME
//	MLQuery.hpp
//
//  = AUTHOR
//	Author Name
//
//  = COPYRIGHT
//	Copyright Washington University, 1999
//
// ====================
//
//  = VERSION
//	$Revision: 1.1 $
//
//  = DATE RELEASED
//	$Date: 2001/03/29 21:11:30 $
//
//  = COMMENTTEXT
//	Comments

#ifndef MLEvalImageAvailISIN
#define MLEvalImageAvailISIN

#include <iostream>
#include <string>

#include "MESA.hpp"
#include "MLEvalStudy.hpp"

using namespace std;

class MDICOMWrapper;
class MDomainObject;
class MPatientStudy;
class MStudy;
class MSeries;

class MLEvalImageAvail : public MLEvalStudy
// = TITLE
//	Short title/description
//
// = DESCRIPTION
//	Describe the class and how to use it
{
public:
  // = The standard methods in this framework.
  //MLEvalImageAvail();
  // Default constructor
  MLEvalImageAvail(const MLEvalImageAvail& cpy);
  virtual ~MLEvalImageAvail();
  virtual void printOn(ostream& s) const;
  // This method is used in conjunction with the streaming operator <<
  // to print the current state of MLEvalImageAvail

  virtual void streamIn(istream& s);

  MLEvalImageAvail(MDICOMWrapper& testData);

  int run();

protected:

private:
  int evalInstanceLevel();
  int testInstanceLevelIAKeys();

};

inline ostream& operator<< (ostream& s, const MLEvalImageAvail& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MLEvalImageAvail& c) {
  c.streamIn(s);
  return s;
}

#endif
