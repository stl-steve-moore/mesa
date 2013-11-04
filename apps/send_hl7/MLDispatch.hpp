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

// $Id: MLDispatch.hpp,v 1.4 2006/08/07 15:09:12 bhasselfeld Exp $ $Author: bhasselfeld $ $Revision: 1.4 $ $Date: 2006/08/07 15:09:12 $ $State: Exp $
// ====================
//  = LIBRARY
//	hl7
//
//  = FILENAME
//	MLDispatch.hpp
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
//	$Revision: 1.4 $
//
//  = DATE RELEASED
//	$Date: 2006/08/07 15:09:12 $
//
//  = COMMENTTEXT

#ifndef MLDispatchISIN
#define MLDispatchISIN

#include <iostream>

#include "MHL7Dispatcher.hpp"

class MPatient;
class MVisit;

using namespace std;

class MLDispatch : public MHL7Dispatcher
{
public:
  //MLDispatch();
  // Default constructor
  MLDispatch(const MLDispatch& cpy);
  ~MLDispatch();
  virtual void printOn(ostream& s) const;
  // This method is used in conjunction with the streaming operator <<
  // to print the current state of MLDispatch

  virtual void streamIn(istream& s);

  // = Class specific methods.

  MLDispatch(MHL7Factory& factory);

  //void logHL7Stream(const char* txt, int len);

  virtual int acceptACK(MHL7Msg& message, const MString& event);
  virtual int acceptORR(MHL7Msg& message, const MString& event);
  virtual int acceptRSP(MHL7Msg& message, const MString& event);

  void setOutputPath(const MString& path);
  void setTransactionComplete(bool flag);
  bool transactionComplete( ) const;

  void receivedAckMessage(bool flag);
  bool receivedAckMessage( ) const;

  virtual void registerHL7Message (MHL7Msg* message);

protected:
  int mMessageNumber;
  bool mTransactionComplete;
  MString mOutputPath;
  void storeMessage(MHL7Msg& message);

private:
  bool mReceivedAck;


};  

inline istream& operator >> (istream& s, MLDispatch& c) {
  c.streamIn(s);
  return s;
}

#endif
