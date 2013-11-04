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

// $Id: MLDispatchOrderPlacer.hpp,v 1.4 2006/06/30 13:47:40 bhasselfeld Exp $ $Author: bhasselfeld $ $Revision: 1.4 $ $Date: 2006/06/30 13:47:40 $ $State: Exp $
// ====================
//  = LIBRARY
//
//  = FILENAME
//	MLDispatchOrderPlacer.hpp 
//
//  = AUTHOR
//	Steve Moore
//
//  = COPYRIGHT
//	Copyright Washington University, 2002
//
// ====================
//
//  = VERSION
//	$Revision: 1.4 $
//
//  = DATE RELEASED
//	$Date: 2006/06/30 13:47:40 $
//
//  = COMMENTTEXT

#ifndef MLDispatchOrderPlacerISIN
#define MLDispatchOrderPlacerISIN

#include <iostream>

#include "MHL7Dispatcher.hpp"
#include "MDBOrderPlacer.hpp"

class MPatient;
class MVisit;
class MPlacerOrder;

using namespace std;

class MLDispatchOrderPlacer : public MHL7Dispatcher
{
public:
  //MLDispatchOrderPlacer();
  // Default constructor
  MLDispatchOrderPlacer(const MLDispatchOrderPlacer& cpy);
  virtual ~MLDispatchOrderPlacer();
  virtual void printOn(ostream& s) const;
  // This method is used in conjunction with the streaming operator <<
  // to print the current state of MLDispatchOrderPlacer

  virtual void streamIn(istream& s);

  // = Class specific methods.

  MLDispatchOrderPlacer(MHL7Factory& factory, MDBOrderPlacer* database,
              const MString& outputQueue,
              const MString& startEntityID,
              const MString& defaultApplID,
	      const MString& logDir,
	      const MString& storageDir,
	      bool analysisMode,
	      int& shutdownFlag);

  void logHL7Stream(const char* txt, int len);

  virtual int acceptADT(MHL7Msg& message, const MString& event);
  virtual int acceptORM(MHL7Msg& message, const MString& event);
  virtual int acceptORR(MHL7Msg& message, const MString& event);
  virtual int acceptXXX(MHL7Msg& message, const MString& event);
  virtual int acceptORU(MHL7Msg& message, const MString& event);

protected:
  bool mAnalysisMode;
  MString mLogDir;
  MString mStorageDir;
  int& mShutdownFlag;

  MDBOrderPlacer* mDatabase;

  MString mOutputQueue;
  MString mCurrSelfGenEntityID; // current self generated entity ID
  MString mApplicationID;

private:
  void processInfo(const MString& event, const MPatient& patient, const MVisit& visit);
  void processInfo(MHL7Msg& message, const MString& event,
                   const MPatient& patient, const MPlacerOrder& placerOrder);
  void sendORR(MHL7Msg& ormMsg, const MString& orderControl,
	const MString& placerOrderNumber);
  void orderError(const MString& event, const MString& orderControl);
  void processError(const MString& msgType, const MString& event, const MString& addionalInfo);
  MString getNewPlacerOrderNumber();
  void clearExistingMessages();
};  

inline istream& operator >> (istream& s, MLDispatchOrderPlacer& c) {
  c.streamIn(s);
  return s;
}

#endif
