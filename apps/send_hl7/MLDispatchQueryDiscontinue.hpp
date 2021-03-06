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

// $Id: MLDispatchQueryDiscontinue.hpp,v 1.1 2004/11/05 23:27:52 smm Exp $ $Author: smm $ $Revision: 1.1 $ $Date: 2004/11/05 23:27:52 $ $State: Exp $
// ====================
//  = LIBRARY
//	hl7
//
//  = FILENAME
//	MLDispatchQueryDiscontinue.hpp
//
//  = AUTHOR
//	Steve Moore
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
//	$Date: 2004/11/05 23:27:52 $
//
//  = COMMENTTEXT

#ifndef MLDispatchQueryDiscontinueISIN
#define MLDispatchQueryDiscontinueISIN

#include <iostream>

#include "MLDispatch.hpp"

class MPatient;
class MVisit;

using namespace std;

class MLDispatchQueryDiscontinue : public MLDispatch
{
public:
  //MLDispatchQueryDiscontinue();
  // Default constructor
  MLDispatchQueryDiscontinue(const MLDispatchQueryDiscontinue& cpy);
  ~MLDispatchQueryDiscontinue();
  virtual void printOn(ostream& s) const;
  // This method is used in conjunction with the streaming operator <<
  // to print the current state of MLDispatchQueryDiscontinue

  virtual void streamIn(istream& s);

  // = Class specific methods.

  MLDispatchQueryDiscontinue(MHL7Factory& factory);

  //void logHL7Stream(const char* txt, int len);

  virtual int acceptACK(MHL7Msg& message, const MString& event);
  virtual int acceptRSP(MHL7Msg& message, const MString& event);

protected:

private:
  //int mMessageNumber;
  //MString mOutputPath;

  //void storeMessage(MHL7Msg& message);

};  

inline istream& operator >> (istream& s, MLDispatchQueryDiscontinue& c) {
  c.streamIn(s);
  return s;
}

#endif
