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
#include "MGPSPSObject.hpp"

static char rcsid[] = "$Id: MGPSPSObject.cpp,v 1.3 2003/01/12 04:05:51 smm Exp $";

MGPSPSObject::MGPSPSObject()
{
}
#if 0
#endif

MGPSPSObject::MGPSPSObject(const MGPSPSObject& cpy)
{
  mGPWorkitem = cpy.mGPWorkitem;
  MStationNameVector::const_iterator it = cpy.mStationNameVector.begin();
  for (; it != cpy.mStationNameVector.end(); it++) {
    MStationName item = *it;
    mStationNameVector.push_back(item);
  }
  MStationClassVector::const_iterator it2 = cpy.mStationClassVector.begin();
  for (; it2 != cpy.mStationClassVector.end(); it2++) {
    MStationClass item = *it2;
    mStationClassVector.push_back(item);
  }
  MStationLocationVector::const_iterator it3 = cpy.mStationLocationVector.begin();
  for (; it3 != cpy.mStationLocationVector.end(); it3++) {
    MStationLocation item = *it3;
    mStationLocationVector.push_back(item);
  }
  MInputInfoVector::const_iterator it4 = cpy.mInputInfoVector.begin();
  for (; it4 != cpy.mInputInfoVector.end(); it4++) {
    MInputInfo item = *it4;
    mInputInfoVector.push_back(item);
  }
}

MGPSPSObject::~MGPSPSObject()
{
}

void
MGPSPSObject::printOn(ostream& s) const
{
  s << "MGPSPSObject: \n";
  s << mGPWorkitem;
  s << "\nStationNameVector: \n";
  MStationNameVector::const_iterator it = mStationNameVector.begin();
  for (int i = 1; it != mStationNameVector.end(); it++, i++) {
    MStationName item = *it;
    s << "StationName item " << i << "\n";
    s << item;
  }
  s << "\nStationClassVector: \n";
  MStationClassVector::const_iterator it2 = mStationClassVector.begin();
  for (int i2 = 1; it2 != mStationClassVector.end(); it2++, i2++) {
    MStationClass item = *it2;
    s << "StationClass item " << i2 << "\n";
    s << item;
  }
  s << "\nStationLocationVector: \n";
  MStationLocationVector::const_iterator it3 = mStationLocationVector.begin();
  for (int i3 = 1; it3 != mStationLocationVector.end(); it3++, i3++) {
    MStationLocation item = *it3;
    s << "StationLocation item " << i3 << "\n";
    s << item;
  }
  s << "\nInputInfoVector: \n";
  MInputInfoVector::const_iterator it4 = mInputInfoVector.begin();
  for (int i4 = 1; it4 != mInputInfoVector.end(); it4++, i4++) {
    MInputInfo item = *it4;
    s << "InputInfo item " << i4 << "\n";
    s << item;
  }
  s << "End MGPSPSObject\n";
}

void
MGPSPSObject::streamIn(istream& s)
{
  //s >> this->member;
}

// Non boiler-plate methods below

MGPSPSObject::MGPSPSObject(const MGPWorkitem& workitem)
{
  mGPWorkitem = workitem;
}

#if 0
MGPSPSObject::MGPSPSObject(const MGPWorkitem& workitem,
                                     const MStationNameVector& snv)
//  mGPWorkitem(workitem),
//  mStationNameVector(snv)
{
  mGPWorkitem = workitem;
  MStationNameVector::const_iterator it = snv.begin();
  for (; it != snv.end(); it++) {
    MStationName item = *it;
    mStationNameVector.push_back(item);
  }
}
#endif

MGPWorkitem
MGPSPSObject::workitem()
{
  return mGPWorkitem;
}

MStationNameVector
MGPSPSObject::stationNameVector()
{
  return mStationNameVector;
}

MStationClassVector
MGPSPSObject::stationClassVector()
{
  return mStationClassVector;
}

MStationLocationVector
MGPSPSObject::stationLocationVector()
{
  return mStationLocationVector;
}

MInputInfoVector
MGPSPSObject::inputInfoVector()
{
  return mInputInfoVector;
}

void 
MGPSPSObject::stationNameVector( MStationNameVector& snv)
{
  MStationNameVector::const_iterator it = snv.begin();
  for (; it != snv.end(); it++) {
    MStationName item = *it;
    mStationNameVector.push_back(item);
  }
}

void 
MGPSPSObject::stationClassVector( MStationClassVector& scv)
{
  MStationClassVector::const_iterator it = scv.begin();
  for (; it != scv.end(); it++) {
    MStationClass item = *it;
    mStationClassVector.push_back(item);
  }
}

void 
MGPSPSObject::stationLocationVector( MStationLocationVector& slv)
{
  MStationLocationVector::const_iterator it = slv.begin();
  for (; it != slv.end(); it++) {
    MStationLocation item = *it;
    mStationLocationVector.push_back(item);
  }
}

void 
MGPSPSObject::inputInfoVector( MInputInfoVector& slv)
{
  MInputInfoVector::const_iterator it = slv.begin();
  for (; it != slv.end(); it++) {
    MInputInfo item = *it;
    mInputInfoVector.push_back(item);
  }
}

void 
MGPSPSObject::addStationName( MStationName& s)
{
  MStationName sn = s;
  mStationNameVector.push_back(sn);
}

void 
MGPSPSObject::addStationClass( MStationClass& s)
{
  MStationClass sc = s;
  mStationClassVector.push_back(sc);
}

void 
MGPSPSObject::addStationLocation( MStationLocation& s)
{
  MStationLocation sc = s;
  mStationLocationVector.push_back(sc);
}

void 
MGPSPSObject::workitem( MGPWorkitem wi)
{
  mGPWorkitem = wi;
}

void
MGPSPSObject::insert( MDBInterface& db) {
  db.insert(mGPWorkitem);
  MStationNameVector::const_iterator it = mStationNameVector.begin();
  for (; it != mStationNameVector.end(); it++) {
    MStationName item = *it;
    db.insert(item);
  }
  MStationClassVector::const_iterator it2 = mStationClassVector.begin();
  for (; it2 != mStationClassVector.end(); it2++) {
    MStationClass item = *it2;
    db.insert(item);
  }
  MStationLocationVector::const_iterator it3 = mStationLocationVector.begin();
  for (; it3 != mStationLocationVector.end(); it3++) {
    MStationLocation item = *it3;
    db.insert(item);
  }
  MInputInfoVector::const_iterator it4 = mInputInfoVector.begin();
  for (; it4 != mInputInfoVector.end(); it4++) {
    MInputInfo item = *it4;
    db.insert(item);
  }
}

void
MGPSPSObject::SOPInstanceUID( MString& s) {
  mGPWorkitem.SOPInstanceUID(s);
  MStationNameVector::iterator it = mStationNameVector.begin();
  for (; it != mStationNameVector.end(); it++) {
    //MStationName item = *it;
    //item.workitemkey(s);
    //MStationName *item = it;
    it->workitemkey(s);
  }
  MStationClassVector::iterator it2 = mStationClassVector.begin();
  for (; it2 != mStationClassVector.end(); it2++) {
    //MStationClass *item = it2;
    it2->workitemkey(s);
  }
  MStationLocationVector::iterator it3 = mStationLocationVector.begin();
  for (; it3 != mStationLocationVector.end(); it3++) {
    //MStationLocation *item = it3;
    it3->workitemkey(s);
  }
  MInputInfoVector::iterator it4 = mInputInfoVector.begin();
  for (; it4 != mInputInfoVector.end(); it4++) {
    //MInputInfo *item = it4;
    it4->workitemkey(s);
  }
}
