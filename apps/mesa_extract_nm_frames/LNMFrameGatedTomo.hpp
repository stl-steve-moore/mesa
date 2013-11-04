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

// $Id: LNMFrameGatedTomo.hpp,v 1.1 2004/09/27 20:54:41 ssurul01 Exp $ $Author: ssurul01 $ $Revision: 1.1 $ $Date: 2004/09/27 20:54:41 $ $State: Exp $
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
//	$Revision: 1.1 $
//
//  = DATE RELEASED
//	$Date: 2004/09/27 20:54:41 $
//
//  = COMMENTS
//	Base class for NM frame extraction algorithms.

#ifndef LNMFrameGatedTomoISIN
#define LNMFrameGatedTomoISIN

#include "LNMFrame.hpp"

using namespace std;

class LNMFrameGatedTomo : public LNMFrame
// = TITLE
//
// = DESCRIPTION

{
public:
  // = The standard methods in this framework.

  LNMFrameGatedTomo();
  // Default constructor

  LNMFrameGatedTomo(const LNMFrameGatedTomo& cpy);

  virtual ~LNMFrameGatedTomo();

  virtual void printOn(ostream& s) const;
  // This method is used in conjunction with the streaming operator <<
  // to print the current state of LNMFrameGatedTomo.

  virtual void streamIn(istream& s);
  // This method is used in conjunction with the streaming operator >>
  // to read the current state of LNMFrameGatedTomo.

  // = Class specific methods.

  virtual int extract(ofstream& f, MDICOMWrapper& w, MStringMap& m, ofstream& o);
  // This method extracts frames from a GATED TOMO NM image.

 protected:

 protected:
};

inline ostream& operator<< (ostream& s, const LNMFrameGatedTomo& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, LNMFrameGatedTomo& c) {
  c.streamIn(s);
  return s;
}

#endif /* LNMFrameGatedTomoISIN */
