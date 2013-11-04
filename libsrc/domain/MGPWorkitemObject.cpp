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
#include "MGPWorkitemObject.hpp"

static char rcsid[] = "$Id: MGPWorkitemObject.cpp,v 1.6 2003/01/12 04:05:51 smm Exp $";

MGPWorkitemObject::MGPWorkitemObject()
{
}
#if 0
#endif

MGPWorkitemObject::MGPWorkitemObject(const MGPWorkitemObject& cpy)
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
  MInputInfoVector::const_iterator it3 = cpy.mInputInfoVector.begin();
  for (; it3 != cpy.mInputInfoVector.end(); it3++) {
    MInputInfo item = *it3;
    mInputInfoVector.push_back(item);
  }
}

MGPWorkitemObject::~MGPWorkitemObject()
{
}

void
MGPWorkitemObject::printOn(ostream& s) const
{
  s << "MGPWorkitemObject: \n";
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
  s << "\nInputInfoVector: \n";
  MInputInfoVector::const_iterator it3 = mInputInfoVector.begin();
  for (int i3 = 1; it3 != mInputInfoVector.end(); it3++, i3++) {
    MInputInfo item = *it3;
    s << "InputInfo item " << i3 << "\n";
    s << item;
  }
  s << "End MGPWorkitemObject\n";
}

void
MGPWorkitemObject::streamIn(istream& s)
{
  //s >> this->member;
}

// Non boiler-plate methods below

MGPWorkitemObject::MGPWorkitemObject(const MGPWorkitem& workitem)
{
  mGPWorkitem = workitem;
}

#if 0
MGPWorkitemObject::MGPWorkitemObject(const MGPWorkitem& workitem,
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
MGPWorkitemObject::workitem()
{
  return mGPWorkitem;
}

MStationNameVector
MGPWorkitemObject::stationNameVector()
{
  return mStationNameVector;
}

MStationClassVector
MGPWorkitemObject::stationClassVector()
{
  return mStationClassVector;
}

MInputInfoVector
MGPWorkitemObject::inputInfoVector()
{
  return mInputInfoVector;
}

void 
MGPWorkitemObject::startDateTime( MString& sdt)
{
  mGPWorkitem.startDateTime(sdt);
}

void 
MGPWorkitemObject::stationNameVector( MStationNameVector& snv)
{
  MStationNameVector::const_iterator it = snv.begin();
  for (; it != snv.end(); it++) {
    MStationName item = *it;
    mStationNameVector.push_back(item);
  }
}

void 
MGPWorkitemObject::stationClassVector( MStationClassVector& scv)
{
  MStationClassVector::const_iterator it = scv.begin();
  for (; it != scv.end(); it++) {
    MStationClass item = *it;
    mStationClassVector.push_back(item);
  }
}

void 
MGPWorkitemObject::inputInfoVector( MInputInfoVector& iiv)
{
  MInputInfoVector::const_iterator it = iiv.begin();
  for (; it != iiv.end(); it++) {
    MInputInfo item = *it;
    mInputInfoVector.push_back(item);
  }
}

void 
MGPWorkitemObject::addStationName( MStationName& s)
{
  MStationName sn = s;
  mStationNameVector.push_back(sn);
}

void 
MGPWorkitemObject::addStationClass( MStationClass& s)
{
  MStationClass sc = s;
  mStationClassVector.push_back(sc);
}

void 
MGPWorkitemObject::addInputInfo( MInputInfo& s)
{
  MInputInfo sc = s;
  mInputInfoVector.push_back(sc);
}

void 
MGPWorkitemObject::workitem( MGPWorkitem wi)
{
  mGPWorkitem = wi;
}

void
MGPWorkitemObject::insert( MDBInterface& db) {
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
  MInputInfoVector::const_iterator it3 = mInputInfoVector.begin();
  for (; it3 != mInputInfoVector.end(); it3++) {
    MInputInfo item = *it3;
    db.insert(item);
  }
}

void
MGPWorkitemObject::SOPInstanceUID( MString& s) {
  mGPWorkitem.SOPInstanceUID(s);
  MStationNameVector::iterator it = mStationNameVector.begin();
  for (; it != mStationNameVector.end(); it++) {
    //MStationName item = *it;
    //item.workitemkey(s);
    it->workitemkey(s);
    //MStationName *item = it;
    //item->workitemkey(s);
  }
  MStationClassVector::iterator it2 = mStationClassVector.begin();
  for (; it2 != mStationClassVector.end(); it2++) {
    //MStationClass item = *it2;
    //item.workitemkey(s);
    //MStationClass *item = it2;
    it2->workitemkey(s);
  }
  MInputInfoVector::iterator it3 = mInputInfoVector.begin();
  for (; it3 != mInputInfoVector.end(); it3++) {
    //MInputInfo *item = it3;
    it3->workitemkey(s);
  }
}
