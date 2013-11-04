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

// $Id: MLDispatchQueryContinue.hpp,v 1.1 2005/12/01 21:46:29 smm Exp $ $Author: smm $ $Revision: 1.1 $ $Date: 2005/12/01 21:46:29 $ $State: Exp $
// ====================
//  = LIBRARY
//	hl7
//
//  = FILENAME
//	MLDispatchQueryContinue.hpp
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
//	$Date: 2005/12/01 21:46:29 $
//
//  = COMMENTTEXT

#ifndef MLDispatchQueryContinueISIN
#define MLDispatchQueryContinueISIN

#include <iostream>

#include "MLDispatch.hpp"

class MPatient;
class MVisit;

using namespace std;

class MLDispatchQueryContinue : public MLDispatch
{
public:
  //MLDispatchQueryContinue();
  // Default constructor
  MLDispatchQueryContinue(const MLDispatchQueryContinue& cpy);
  ~MLDispatchQueryContinue();
  virtual void printOn(ostream& s) const;
  // This method is used in conjunction with the streaming operator <<
  // to print the current state of MLDispatchQueryContinue

  virtual void streamIn(istream& s);

  // = Class specific methods.

  MLDispatchQueryContinue(MHL7Factory& factory);

  //void logHL7Stream(const char* txt, int len);

  virtual int acceptACK(MHL7Msg& message, const MString& event);
  virtual int acceptRSP(MHL7Msg& message, const MString& event);

  virtual void registerHL7Message(MHL7Msg* message);
protected:

private:
  //int mMessageNumber;
  //MString mOutputPath;

  //void storeMessage(MHL7Msg& message);
  MHL7Msg* mQueryMessage;
  MString mOriginalMessageControlID;
  int mControlIDIndex;

};  

inline istream& operator >> (istream& s, MLDispatchQueryContinue& c) {
  c.streamIn(s);
  return s;
}

#endif
