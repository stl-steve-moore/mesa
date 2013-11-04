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

// $Id: MLMessenger.hpp,v 1.1 2002/04/16 19:30:16 drm Exp $ $Author: drm $ $Revision: 1.1 $ $Date: 2002/04/16 19:30:16 $ $State: Exp $
// ====================
//  = FILENAME
//	MLMessenger.hpp
//
//  = AUTHOR
//	PD
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
//	$Date: 2002/04/16 19:30:16 $
//
//  = COMMENTTEXT
// Serves as the HL7 message interface for the Image Manager. Extends the
// MHL7Messenger class.

#ifndef MLMessengerISIN
#define MLMessengerISIN

#include <iostream>

#include "MHL7Messenger.hpp"

// class MDBImageManager;
// class MPatient;
// class MVisit;

using namespace std;

class MLMessenger : public MHL7Messenger
{
public:
  //MLMessenger();
  // Default constructor
  MLMessenger(const MLMessenger& cpy);
  ~MLMessenger();
  virtual void printOn(ostream& s) const;
  // This method is used in conjunction with the streaming operator <<
  // to print the current state of MLMessenger

  virtual void streamIn(istream& s);

  // = Class specific methods.

  MLMessenger(MHL7Factory& factory, // MDBImageManager& database,
	      const MString& logDir, const MString& storageDir,
	      bool analysisMode, int& shutdownFlag);

  MHL7Messenger* clone();
  // The most important method of this class. Without it, this server will not operate.

  virtual int acceptBAR(MHL7Msg& message, const MString& event);
  virtual int acceptDFT(MHL7Msg& message, const MString& event);
  virtual int acceptXXX(MHL7Msg& message, const MString& event);

  void logHL7Stream(const char* txt, int len);

protected:
  //MDBImageManager& mDatabase;
  // The database reference for storing messages.   

private:
  bool mAnalysisMode;
  MString mLogDir;
  MString mStorageDir;
  int& mShutdownFlag;

  void clearExistingMessages();
};  

inline istream& operator >> (istream& s, MLMessenger& c) {
  c.streamIn(s);
  return s;
}

#endif
