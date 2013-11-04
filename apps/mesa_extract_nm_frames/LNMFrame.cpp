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

#include "MESA.hpp"
#include "ctn_os.h"
#include "MString.hpp"

#include "LNMFrame.hpp"
#include "MDICOMWrapper.hpp"


static char rcsid[] = "$Id: LNMFrame.cpp,v 1.5 2004/09/27 17:37:22 ssurul01 Exp $";

LNMFrame::LNMFrame()
{
}

LNMFrame::~LNMFrame(void)
{
}

LNMFrame::LNMFrame(const LNMFrame& cpy)
{
}

void
LNMFrame::printOn(ostream& s) const
{
  s << "LNMFrame";
}

void
LNMFrame::streamIn(istream& s)
{
}

// Non boiler-place methods follow below

int
LNMFrame::getFrameInformation(MDICOMWrapper& w, U32& frameSize, U16& frameCount, ofstream& o)
{
  U32 rows = w.getU16(DCM_IMGROWS);
  U32 cols = w.getU16(DCM_IMGCOLUMNS);
  U32 bitsStored = w.getU16(DCM_IMGBITSSTORED);
  U32 imgHighBit = w.getU16(DCM_IMGHIGHBIT);
  U32 imgPixRep = w.getU16(DCM_IMGPIXELREPRESENTATION);
  U32 imgBitAlloc = w.getU16(DCM_IMGBITSALLOCATED);
  U32 imgBitStored = w.getU16(DCM_IMGBITSSTORED);
  frameCount = w.getU16(DCM_IMGNUMBEROFFRAMES);
  frameSize = rows * cols;
  if (imgBitAlloc > 8 && imgBitAlloc <= 16) {
    frameSize *= 2;
  }
  cout << rows << " " << cols << " " << imgHighBit << " " << imgPixRep << " " << imgBitAlloc << " " << imgBitStored << " " << frameSize << " " << frameCount << endl;
  o << rows << " " << cols << " " << imgHighBit << " " << imgPixRep << " " << imgBitAlloc << " " << imgBitStored << " " << frameSize << " " << frameCount;
  return 0;
}
