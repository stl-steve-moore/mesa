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
#include "MMWLObjects.hpp"

static char rcsid[] = "$Id: MMWLObjects.cpp,v 1.5 2001/06/21 20:14:01 drm Exp $";

#if 0
MMWLObjects::MMWLObjects()
{
}
#endif

MMWLObjects::MMWLObjects(const MMWLObjects& cpy)
//  mMWL(cpy.mMWL),
//  mActionItemVector(cpy.mActionItemVector)
{
  mMWL = cpy.mMWL;
  MActionItemVector::const_iterator it = cpy.mActionItemVector.begin();
  for (; it != cpy.mActionItemVector.end(); it++) {
    MActionItem item = *it;
    mActionItemVector.push_back(item);
  }
}

MMWLObjects::~MMWLObjects()
{
}

void
MMWLObjects::printOn(ostream& s) const
{
  s << "MMWLObjects: ";
  s << mMWL;
}

void
MMWLObjects::streamIn(istream& s)
{
  //s >> this->member;
}

// Non boiler-plate methods below

MMWLObjects::MMWLObjects(const MMWL& mwl,
			 const MActionItemVector& actionitem
			 )
//  mMWL(mwl),
//  mActionItemVector(actionitem)
{
  mMWL = mwl;
  MActionItemVector::const_iterator it = actionitem.begin();
  for (; it != actionitem.end(); it++) {
    MActionItem item = *it;
    mActionItemVector.push_back(item);
  }
}

MMWL
MMWLObjects::mwl()
{
  return mMWL;
}

MActionItemVector
MMWLObjects::actionItemVector()
{
  return mActionItemVector;
}
