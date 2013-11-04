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

// $Id: MLDispatchOrderFillerJapanese.hpp,v 1.3 2006/06/30 13:47:39 bhasselfeld Exp $ $Author: bhasselfeld $ $Revision: 1.3 $ $Date: 2006/06/30 13:47:39 $ $State: Exp $
// ====================
//  = LIBRARY
//	hl7
//
//  = FILENAME
//	MLDispatchOrderFillerJapanese.hpp
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
//	$Revision: 1.3 $
//
//  = DATE RELEASED
//	$Date: 2006/06/30 13:47:39 $
//
//  = COMMENTTEXT

#ifndef MLDispatchOrderFillerJapaneseISIN
#define MLDispatchOrderFillerJapaneseISIN

#include <iostream>

#include "MHL7Dispatcher.hpp"
#include "MDBOrderFillerJapanese.hpp"

class MPatient;
class MVisit;
class MPlacerOrder;
class MFillerOrder;

using namespace std;

class MLDispatchOrderFillerJapanese : public MHL7Dispatcher
{
public:
  //MLDispatchOrderFillerJapanese();
  // Default constructor
  MLDispatchOrderFillerJapanese(const MLDispatchOrderFillerJapanese& cpy);
  ~MLDispatchOrderFillerJapanese();
  virtual void printOn(ostream& s) const;
  // This method is used in conjunction with the streaming operator <<
  // to print the current state of MLDispatchOrderFillerJapanese

  virtual void streamIn(istream& s);

  // = Class specific methods.

  MLDispatchOrderFillerJapanese(MHL7Factory& factory, MDBOrderFillerJapanese* database,
	      const MString& logDir, const MString& storageDir,
	      bool analysisMode, int& shutdownFlag);

  void logHL7Stream(const char* txt, int len);

  virtual int acceptADT(MHL7Msg& message, const MString& event);
  virtual int acceptORM(MHL7Msg& message, const MString& event);
  virtual int acceptORR(MHL7Msg& message, const MString& event);
  virtual int acceptXXX(MHL7Msg& message, const MString& event);

protected:

private:
  bool mAnalysisMode;
  MString mLogDir;
  MString mStorageDir;
  int& mShutdownFlag;

  MDBOrderFillerJapanese* mDatabase;

  // The database reference for storing messages.   
  void processInfo(const MString& event, const MPatient& patient, const MVisit& visit);
  void processInfo(const MString& event, const MString& orderControl,
                   const MPatient& patient, const MPlacerOrder& placerOrder, 
		   const MFillerOrder& fillerOrder);
  void orderError(const MString& event, const MString& orderControl);
  void processError(const MString& msgType, const MString& event, const MString& addionalInfo);
  void clearExistingMessages();
};  

inline istream& operator >> (istream& s, MLDispatchOrderFillerJapanese& c) {
  c.streamIn(s);
  return s;
}

#endif
