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

// $Id: LNMFrame.hpp,v 1.4 2004/11/03 20:46:51 smm Exp $ $Author: smm $ $Revision: 1.4 $ $Date: 2004/11/03 20:46:51 $ $State: Exp $
//
// ====================
//  = FILENAME
//	LNNFrame.hpp
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
//	$Date: 2004/11/03 20:46:51 $
//
//  = COMMENTS
//	Base class for NM frame extraction algorithms.

#ifndef LNMFrameISIN
#define LNMFrameISIN

#include "ctn_api.h"
#include <fstream>

using namespace std;
class MDICOMWrapper;

class LNMFrame
// = TITLE
//
// = DESCRIPTION

{
public:
  // = The standard methods in this framework.

  LNMFrame();
  // Default constructor

  LNMFrame(const LNMFrame& cpy);

  virtual ~LNMFrame();

  virtual void printOn(ostream& s) const;
  // This method is used in conjunction with the streaming operator <<
  // to print the current state of LNMFrame.

  virtual void streamIn(istream& s);
  // This method is used in conjunction with the streaming operator >>
  // to read the current state of LNMFrame.

  // = Class specific methods.
  int getFrameInformation(MDICOMWrapper& w, U32& frameSize, U16& frameCount, ofstream& o);

  virtual int extract(ofstream& f, MDICOMWrapper& w, MStringMap& m, ofstream& o) = 0;
  // This method is implemented by derived classes.
  // The derived classes use the values in the MStringMap to determine
  // which frames to extract from the NM object.

 protected:

 protected:
};

inline ostream& operator<< (ostream& s, const LNMFrame& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, LNMFrame& c) {
  c.streamIn(s);
  return s;
}

#endif /* LNMFrameISIN */
