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
#include "MGPPPSObject.hpp"

static char rcsid[] = "$Id: MGPPPSObject.cpp,v 1.6 2003/06/04 20:34:03 drm Exp $";

MGPPPSObject::MGPPPSObject()
{
}
#if 0
#endif

MGPPPSObject::MGPPPSObject(const MGPPPSObject& cpy)
{
  mWorkitem = cpy.mWorkitem;
  for( MActHumanPerformersVector::const_iterator it = cpy.mActHumanPerformersVector.begin();
         it != cpy.mActHumanPerformersVector.end(); it++) {
    MActHumanPerformers item = *it;
    mActHumanPerformersVector.push_back(item);
  }
  for( MPerfStationNameVector::const_iterator it1 = cpy.mPerfStationNameVector.begin();
         it1 != cpy.mPerfStationNameVector.end(); it1++) {
    MPerfStationName item = *it1;
    mPerfStationNameVector.push_back(item);
  }
  for( MPerfStationClassVector::const_iterator it2 = cpy.mPerfStationClassVector.begin();
         it2 != cpy.mPerfStationClassVector.end(); it2++) {
    MPerfStationClass item = *it2;
    mPerfStationClassVector.push_back(item);
  }
  for( MPerfStationLocationVector::const_iterator it3 = cpy.mPerfStationLocationVector.begin();
         it3 != cpy.mPerfStationLocationVector.end(); it3++) {
    MPerfStationLocation item = *it3;
    mPerfStationLocationVector.push_back(item);
  }
  for( MPerfProcAppsVector::const_iterator it4 = cpy.mPerfProcAppsVector.begin();
         it4 != cpy.mPerfProcAppsVector.end(); it4++) {
    MPerfProcApps item = *it4;
    mPerfProcAppsVector.push_back(item);
  }
  for( MPerfWorkitemVector::const_iterator it5 = cpy.mPerfWorkitemVector.begin();
         it5 != cpy.mPerfWorkitemVector.end(); it5++) {
    MPerfWorkitem item = *it5;
    mPerfWorkitemVector.push_back(item);
  }
  for( MReqSubsWorkitemVector::const_iterator it6 = cpy.mReqSubsWorkitemVector.begin();
         it6 != cpy.mReqSubsWorkitemVector.end(); it6++) {
    MReqSubsWorkitem item = *it6;
    mReqSubsWorkitemVector.push_back(item);
  }
  for( MNonDCMOutputVector::const_iterator it7 = cpy.mNonDCMOutputVector.begin();
         it7 != cpy.mNonDCMOutputVector.end(); it7++) {
    MNonDCMOutput item = *it7;
    mNonDCMOutputVector.push_back(item);
  }
  for( MOutputInfoVector::const_iterator it8 = cpy.mOutputInfoVector.begin();
         it8 != cpy.mOutputInfoVector.end(); it8++) {
    MOutputInfo item = *it8;
    mOutputInfoVector.push_back(item);
  }
  for( MRefGPSPSVector::const_iterator it9 = cpy.mRefGPSPSVector.begin();
         it9 != cpy.mRefGPSPSVector.end(); it9++) {
    MRefGPSPS item = *it9;
    mRefGPSPSVector.push_back(item);
  }
}

#if 0
MGPPPSObject::MGPPPSObject( MDICOMWrapper& w)
{
  MDICOMDomainXlate xlate;

  xlate.translateDICOM( w, mWorkitem);
  xlate.translateDICOM( w, mActHumanPerformersVector);
  xlate.translateDICOM( w, mPerfStationNameVector);
  xlate.translateDICOM( w, mPerfStationClassVector);
  xlate.translateDICOM( w, mPerfStationLocationVector);
  xlate.translateDICOM( w, mPerfProcAppsVector);
  xlate.translateDICOM( w, mPerfWorkitemVector);
  xlate.translateDICOM( w, mOutputInfoVector);
  xlate.translateDICOM( w, mReqSubsWorkitemVector);
  xlate.translateDICOM( w, mNonDCMOutputVector);
  xlate.translateDICOM( w, mRefGPSPSVector);
}
#endif

MGPPPSObject::~MGPPPSObject()
{
}

void
MGPPPSObject::printOn(ostream& s) const
{
  s << "MGPPPSObject: \n";
  s << mWorkitem;
  s << "\nActHumanPerformersVector: \n";
  MActHumanPerformersVector::const_iterator it = mActHumanPerformersVector.begin();
  for (int i = 1; it != mActHumanPerformersVector.end(); it++, i++) {
    MActHumanPerformers item = *it;
    s << "ActHumanPerformers item " << i << "\n";
    s << item;
  }
  s << "\nStationNameVector: \n";
  MPerfStationNameVector::const_iterator it2 = mPerfStationNameVector.begin();
  for (int i2 = 1; it2 != mPerfStationNameVector.end(); it2++, i2++) {
    MPerfStationName item = *it2;
    s << "StationName item " << i2 << "\n";
    s << item;
  }
  s << "\nStationClassVector: \n";
  MPerfStationClassVector::const_iterator it3 = mPerfStationClassVector.begin();
  for (int i3 = 1; it3 != mPerfStationClassVector.end(); it3++, i3++) {
    MPerfStationClass item = *it3;
    s << "StationClass item " << i3 << "\n";
    s << item;
  }
  s << "\nStationLocationVector: \n";
  MPerfStationLocationVector::const_iterator it4 = mPerfStationLocationVector.begin();
  for (int i4 = 1; it4 != mPerfStationLocationVector.end(); it4++, i4++) {
    MPerfStationLocation item = *it4;
    s << "StationLocation item " << i4 << "\n";
    s << item;
  }
  s << "\nPerformedProcessingApplicationsVector: \n";
  MPerfProcAppsVector::const_iterator it5 = mPerfProcAppsVector.begin();
  for (int i5 = 1; it5 != mPerfProcAppsVector.end(); it5++, i5++) {
    MPerfProcApps item = *it5;
    s << "Processing Application item " << i5 << "\n";
    s << item;
  }
  s << "\nPerformedWorkitemVector: \n";
  MPerfWorkitemVector::const_iterator it6 = mPerfWorkitemVector.begin();
  for (int i6 = 1; it6 != mPerfWorkitemVector.end(); it6++, i6++) {
    MPerfWorkitem item = *it6;
    s << "Performed Workitem item " << i6 << "\n";
    s << item;
  }
  s << "\nRequestedSubsequentWorkitemVector: \n";
  MReqSubsWorkitemVector::const_iterator it7 = mReqSubsWorkitemVector.begin();
  for (int i7 = 1; it7 != mReqSubsWorkitemVector.end(); it7++, i7++) {
    MReqSubsWorkitem item = *it7;
    s << "Req Subsequent Workitem item " << i7 << "\n";
    s << item;
  }
  s << "\nNonDICOMOutputVector: \n";
  MNonDCMOutputVector::const_iterator it8 = mNonDCMOutputVector.begin();
  for (int i8 = 1; it8 != mNonDCMOutputVector.end(); it8++, i8++) {
    MNonDCMOutput item = *it8;
    s << "Non DICOM Output item " << i8 << "\n";
    s << item;
  }
  s << "\nOutputInfoVector: \n";
  MOutputInfoVector::const_iterator it9 = mOutputInfoVector.begin();
  for (int i9 = 1; it9 != mOutputInfoVector.end(); it9++, i9++) {
    MOutputInfo item = *it9;
    s << "Output Info item " << i9 << "\n";
    s << item;
  }
  s << "\nRefGPSPSVector: \n";
  MRefGPSPSVector::const_iterator it10 = mRefGPSPSVector.begin();
  for (int i10 = 1; it10 != mRefGPSPSVector.end(); it10++, i10++) {
    MRefGPSPS item = *it10;
    s << "Referenced GPSPS item " << i10 << "\n";
    s << item;
  }
  s << "End MGPPPSObject\n";
}

void
MGPPPSObject::streamIn(istream& s)
{
  //s >> this->member;
}

// Non boiler-plate methods below

MGPPPSObject::MGPPPSObject( const MGPPPSWorkitem& workitem)
{
  mWorkitem = workitem;
}

MGPPPSWorkitem
MGPPPSObject::workitem()
{
  return mWorkitem;
}

MActHumanPerformersVector
MGPPPSObject::actualHumanPerformersVector()
{
  return mActHumanPerformersVector;
}

MString 
MGPPPSObject::status() {
  return mWorkitem.status();
}

MPerfStationNameVector
MGPPPSObject::performedStationNameVector()
{
  return mPerfStationNameVector;
}

MPerfStationClassVector
MGPPPSObject::performedStationClassVector()
{
  return mPerfStationClassVector;
}

MPerfStationLocationVector
MGPPPSObject::performedStationLocationVector()
{
  return mPerfStationLocationVector;
}

MPerfProcAppsVector
MGPPPSObject::performedProcAppsVector()
{
  return mPerfProcAppsVector;
}

MPerfWorkitemVector
MGPPPSObject::performedWorkitemVector()
{
  return mPerfWorkitemVector;
}

MReqSubsWorkitemVector
MGPPPSObject::reqSubsWorkitemVector()
{
  return mReqSubsWorkitemVector;
}

MNonDCMOutputVector
MGPPPSObject::nonDCMOutputVector()
{
  return mNonDCMOutputVector;
}

MOutputInfoVector
MGPPPSObject::outputInfoVector()
{
  return mOutputInfoVector;
}

MRefGPSPSVector
MGPPPSObject::refGPSPSVector()
{
  return mRefGPSPSVector;
}

void 
MGPPPSObject::actualHumanPerformersVector( MActHumanPerformersVector& v)
{
  MActHumanPerformersVector& mv = mActHumanPerformersVector;
  mv.erase(mv.begin(),mv.end());
  MActHumanPerformersVector::const_iterator it = v.begin();
  for (; it != v.end(); it++) {
    MActHumanPerformers item = *it;
    mActHumanPerformersVector.push_back(item);
  }
}

void 
MGPPPSObject::addActHumanPerformer( MActHumanPerformers& s)
{
  MActHumanPerformers sn = s;
  mActHumanPerformersVector.push_back(sn);
}

void 
MGPPPSObject::workitem( MGPPPSWorkitem wi)
{
  mWorkitem = wi;
}

void
MGPPPSObject::insert( MDBInterface& db) {
  db.insert(mWorkitem);
  for( MActHumanPerformersVector::const_iterator it = mActHumanPerformersVector.begin();
         it != mActHumanPerformersVector.end(); it++) {
    MActHumanPerformers item = *it;
    db.insert(item);
  }
  for( MPerfStationNameVector::const_iterator it2 = mPerfStationNameVector.begin();
         it2 != mPerfStationNameVector.end(); it2++) {
    MPerfStationName item = *it2;
    db.insert(item);
  }
  for( MPerfStationClassVector::const_iterator it3 = mPerfStationClassVector.begin();
         it3 != mPerfStationClassVector.end(); it3++) {
    MPerfStationClass item = *it3;
    db.insert(item);
  }
  for( MPerfStationLocationVector::const_iterator it4 = mPerfStationLocationVector.begin();
         it4 != mPerfStationLocationVector.end(); it4++) {
    MPerfStationLocation item = *it4;
    db.insert(item);
  }
  for( MPerfProcAppsVector::const_iterator it5 = mPerfProcAppsVector.begin();
         it5 != mPerfProcAppsVector.end(); it5++) {
    MPerfProcApps item = *it5;
    db.insert(item);
  }
  for( MPerfWorkitemVector::const_iterator it6 = mPerfWorkitemVector.begin();
         it6 != mPerfWorkitemVector.end(); it6++) {
    MPerfWorkitem item = *it6;
    db.insert(item);
  }
  for( MReqSubsWorkitemVector::const_iterator it7 = mReqSubsWorkitemVector.begin();
         it7 != mReqSubsWorkitemVector.end(); it7++) {
    MReqSubsWorkitem item = *it7;
    db.insert(item);
  }
  for( MNonDCMOutputVector::const_iterator it8 = mNonDCMOutputVector.begin();
         it8 != mNonDCMOutputVector.end(); it8++) {
    MNonDCMOutput item = *it8;
    db.insert(item);
  }
  for( MOutputInfoVector::const_iterator it9 = mOutputInfoVector.begin();
         it9 != mOutputInfoVector.end(); it9++) {
    MOutputInfo item = *it9;
    db.insert(item);
  }
  for( MRefGPSPSVector::const_iterator it10 = mRefGPSPSVector.begin();
         it10 != mRefGPSPSVector.end(); it10++) {
    MRefGPSPS item = *it10;
    db.insert(item);
  }
}

void
MGPPPSObject::SOPInstanceUID( const MString& s) {
  mWorkitem.SOPInstanceUID(s);
  for( MActHumanPerformersVector::iterator it = mActHumanPerformersVector.begin();
         it != mActHumanPerformersVector.end(); it++) {
    //MActHumanPerformers *item = it;
    it->workitemkey(s);
  }
  for( MPerfStationNameVector::iterator it2 = mPerfStationNameVector.begin();
         it2 != mPerfStationNameVector.end(); it2++) {
    //MPerfStationName *item = it2;
    it2->workitemkey(s);
  }
  for( MPerfStationClassVector::iterator it3 = mPerfStationClassVector.begin();
         it3 != mPerfStationClassVector.end(); it3++) {
    //MPerfStationClass *item = it3;
    it3->workitemkey(s);
  }
  for( MPerfStationLocationVector::iterator it4 = mPerfStationLocationVector.begin();
         it4 != mPerfStationLocationVector.end(); it4++) {
    //MPerfStationLocation *item = it4;
    it4->workitemkey(s);
  }
  for( MPerfProcAppsVector::iterator it5 = mPerfProcAppsVector.begin();
         it5 != mPerfProcAppsVector.end(); it5++) {
    //MPerfProcApps *item = it5;
    it5->workitemkey(s);
  }
  for( MPerfWorkitemVector::iterator it6 = mPerfWorkitemVector.begin();
         it6 != mPerfWorkitemVector.end(); it6++) {
    //MPerfWorkitem *item = it6;
    it6->workitemkey(s);
  }
  for( MOutputInfoVector::iterator it7 = mOutputInfoVector.begin();
         it7 != mOutputInfoVector.end(); it7++) {
    //MOutputInfo *item = it7;
    it7->workitemkey(s);
  }
  for( MReqSubsWorkitemVector::iterator it8 = mReqSubsWorkitemVector.begin();
         it8 != mReqSubsWorkitemVector.end(); it8++) {
    //MReqSubsWorkitem *item = it8;
    it8->workitemkey(s);
  }
  for( MNonDCMOutputVector::iterator it9 = mNonDCMOutputVector.begin();
         it9 != mNonDCMOutputVector.end(); it9++) {
    //MNonDCMOutput *item = it9;
    it9->workitemkey(s);
  }
  for( MRefGPSPSVector::iterator it10 = mRefGPSPSVector.begin();
         it10 != mRefGPSPSVector.end(); it10++) {
    //MRefGPSPS *item = it10;
    it10->workitemkey(s);
  }
}


void 
MGPPPSObject::performedStationNameVector( MPerfStationNameVector& v)
{
  MPerfStationNameVector& mv = mPerfStationNameVector;
  mv.erase(mv.begin(),mv.end());
  MPerfStationNameVector::const_iterator it = v.begin();
  for (; it != v.end(); it++) {
    MPerfStationName item = *it;
    mPerfStationNameVector.push_back(item);
  }
}

void 
MGPPPSObject::performedStationClassVector( MPerfStationClassVector& v)
{
  MPerfStationClassVector& mv = mPerfStationClassVector;
  mv.erase(mv.begin(),mv.end());
  MPerfStationClassVector::const_iterator it = v.begin();
  for (; it != v.end(); it++) {
    MPerfStationClass item = *it;
    mPerfStationClassVector.push_back(item);
  }
}

void 
MGPPPSObject::performedStationLocationVector( MPerfStationLocationVector& v)
{
  MPerfStationLocationVector& mv = mPerfStationLocationVector;
  mv.erase(mv.begin(),mv.end());
  MPerfStationLocationVector::const_iterator it = v.begin();
  for (; it != v.end(); it++) {
    MPerfStationLocation item = *it;
    mPerfStationLocationVector.push_back(item);
  }
}

void 
MGPPPSObject::performedProcAppsVector( MPerfProcAppsVector& v)
{
  MPerfProcAppsVector& mv = mPerfProcAppsVector;
  mv.erase(mv.begin(),mv.end());
  MPerfProcAppsVector::const_iterator it = v.begin();
  for (; it != v.end(); it++) {
    MPerfProcApps item = *it;
    mPerfProcAppsVector.push_back(item);
  }
}

void 
MGPPPSObject::performedWorkitemVector( MPerfWorkitemVector& v)
{
  MPerfWorkitemVector& mv = mPerfWorkitemVector;
  mv.erase(mv.begin(),mv.end());
  MPerfWorkitemVector::const_iterator it = v.begin();
  for (; it != v.end(); it++) {
    MPerfWorkitem item = *it;
    mPerfWorkitemVector.push_back(item);
  }
}

void 
MGPPPSObject::reqSubsWorkitemVector( MReqSubsWorkitemVector& v)
{
  MReqSubsWorkitemVector& mv = mReqSubsWorkitemVector;
  mv.erase(mv.begin(),mv.end());
  MReqSubsWorkitemVector::const_iterator it = v.begin();
  for (; it != v.end(); it++) {
    MReqSubsWorkitem item = *it;
    mReqSubsWorkitemVector.push_back(item);
  }
}

void 
MGPPPSObject::nonDCMOutputVector( MNonDCMOutputVector& v)
{
  MNonDCMOutputVector& mv = mNonDCMOutputVector;
  mv.erase(mv.begin(),mv.end());
  MNonDCMOutputVector::const_iterator it = v.begin();
  for (; it != v.end(); it++) {
    MNonDCMOutput item = *it;
    mNonDCMOutputVector.push_back(item);
  }
}

void 
MGPPPSObject::outputInfoVector( MOutputInfoVector& v)
{
  MOutputInfoVector& mv = mOutputInfoVector;
  mv.erase(mv.begin(),mv.end());
  MOutputInfoVector::const_iterator it = v.begin();
  for (; it != v.end(); it++) {
    MOutputInfo item = *it;
    mOutputInfoVector.push_back(item);
  }
}

void 
MGPPPSObject::refGPSPSVector( MRefGPSPSVector& v)
{
  MRefGPSPSVector& mv = mRefGPSPSVector;
  mv.erase(mv.begin(),mv.end());
  MRefGPSPSVector::const_iterator it = v.begin();
  for (; it != v.end(); it++) {
    MRefGPSPS item = *it;
    mRefGPSPSVector.push_back(item);
  }
}

#if 0
void
MGPPPSObject::update( MDBInterface& db) {
  db.insert(mWorkitem);
  if (!mDBInterface)
    return;

  MCriteriaVector cv;
  MCriteria c;
  c.attribute = "sopinsuid";
  c.oper      = TBL_EQUAL;
  c.value     = mWorkitem.SOPInstanceUID();
  cv.push_back(c);

  MUpdateVector   uv;
  MUpdate         u;
  u.attribute = "status";
  u.func      = TBL_SET;
  u.value     = s;
  uv.push_back(u);

  MGPPPSWorkitem wi;
  mDBInterface->update( wi, cv, uv);

}
#endif


#if 0
void MGPPPSObject::update( MDBInterface &db) {
  mWorkitem.update(db);
  for( MOutputInfoVector::iterator it = mOutputInfoVector.begin();
         it != mOutputInfoVector.end(); it++) {
    MOutputInfo *item = it;
    item->update(db);
  }
  for( MReqSubsWorkitemVector::iterator it = mReqSubsWorkitemVector.begin();
         it != mReqSubsWorkitemVector.end(); it++) {
    MReqSubsWorkitem *item = it;
    item->update(db);
  }
  for( MNonDCMOutputVector::iterator it = mNonDCMOutputVector.begin();
         it != mNonDCMOutputVector.end(); it++) {
    MNonDCMOutput *item = it;
    item->update(db);
  }
}
#endif
