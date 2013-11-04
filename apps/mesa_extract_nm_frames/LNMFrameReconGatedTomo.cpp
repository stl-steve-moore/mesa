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
#include "MDICOMWrapper.hpp"

#include "LNMFrameReconGatedTomo.hpp"


static char rcsid[] = "$Id: LNMFrameReconGatedTomo.cpp,v 1.2 2004/09/30 13:38:56 ssurul01 Exp $";

LNMFrameReconGatedTomo::LNMFrameReconGatedTomo ()
{
}

LNMFrameReconGatedTomo::~LNMFrameReconGatedTomo (void)
{
}

LNMFrameReconGatedTomo::LNMFrameReconGatedTomo (const LNMFrameReconGatedTomo& cpy)
{
}

void
LNMFrameReconGatedTomo::printOn(ostream& s) const
{
  s << "LNMFrameReconGatedTomo";
}

void
LNMFrameReconGatedTomo::streamIn(istream& s)
{
}

// Non boiler-plate methods start here

int
LNMFrameReconGatedTomo::extract(ofstream& f, MDICOMWrapper& w, MStringMap& m, ofstream& o)
{
  U32 frameSize = 0;
  U16 frameCount = 0;
  if (this->getFrameInformation(w, frameSize, frameCount, o) != 0) {
    return 1;
  }
  unsigned char* pixels = new unsigned char[frameSize];
  DCM_OBJECT* obj = w.getNativeObject();

  int rrVectorLength;
  unsigned short* rrVector = 0;
  if (w.getVector(rrVectorLength, rrVector, 0x00540060) != 0) {
    return 1;
  }
  int sliceVectorLength;
  unsigned short* sliceVector = 0;
  if (w.getVector(sliceVectorLength, sliceVector, 0x00540080) != 0) {
    return 1;
  }
  int timeSlotVectorLength;
  unsigned short* timeSlotVector = 0;
  if (w.getVector(timeSlotVectorLength, timeSlotVector, 0x00540070) != 0) {
    return 1;
  }
  int matchingFrameCount = 0;
  int i;
  unsigned short fixedSlice = 0;
  unsigned short fixedRR = 0;
  unsigned short fixedTimeSlot = 0;
  MString x;
  x = m["SLICE"];
  if (x != "") fixedSlice = x.intData();
  x = m["RR"];
  if (x != "") fixedRR = x.intData();
  x = m["TIMESLOT"];
  if (x != "") fixedTimeSlot = x.intData();

  void* ctx = 0;
  U32 rtnLength = 0;
  CONDITION cond = 0;
  DCM_ELEMENT pixelElement;
  ::memset(&pixelElement, 0, sizeof(pixelElement));
  pixelElement.tag = 0x7fe00010;
  ::DCM_LookupElement(&pixelElement);
  pixelElement.length = frameSize;

  for (i = 0; i < rrVectorLength; i++) {
    bool matchingFrame = true;
    cout << rrVector[i] << ' ' << sliceVector[i] << ' ' 
	 << timeSlotVector[i]<< endl;
    if (fixedSlice != 0 && fixedSlice != sliceVector[i]) {
      matchingFrame = false;
    }
    if (fixedRR != 0 && fixedRR!= rrVector[i]) {
      matchingFrame = false;
    }
    if (fixedTimeSlot != 0 && fixedTimeSlot!= timeSlotVector[i]) {
      matchingFrame = false;
    }
    cout << fixedRR << ' ' << fixedSlice << ' ' << fixedTimeSlot << 'x' << matchingFrame << endl;
    pixelElement.d.ob = pixels;
    cond = ::DCM_GetElementValue(&obj, &pixelElement, &rtnLength, &ctx);
    if (matchingFrame) {
      matchingFrameCount++;
      f.write((const char*)pixels, frameSize);
    }
  }
  //o << "Matching Frame Count: " << matchingFrameCount << endl;
  o << " " << matchingFrameCount << endl;

  delete []sliceVector;
  delete []rrVector;
  delete []timeSlotVector;
  return 0;
}
