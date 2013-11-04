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

#include "MPlacerOrder.hpp"
#ifdef GCC4
#include <stdlib.h>
#endif

MPlacerOrder::MPlacerOrder()
{
  tableName("placerorder");
  insert("patid");
  insert("issuer");
  insert("plaordnum");
  insert("filordnum");
  insert("messta");
}

MPlacerOrder::MPlacerOrder(const MPlacerOrder& cpy) :
  mPatientID(cpy.mPatientID),
  mMesaStatus(cpy.mMesaStatus),
  mIssuerOfPatientID(cpy.mIssuerOfPatientID),
  mPlacerOrderNumber(cpy.mPlacerOrderNumber),
  mFillerOrderNumber(cpy.mFillerOrderNumber),
  mOrderVector(cpy.mOrderVector)
{
  tableName("placerorder");
  insert("patid", cpy.mPatientID);
  insert("issuer", cpy.mIssuerOfPatientID);
  insert("plaordnum", cpy.mPlacerOrderNumber);
  insert("filordnum", cpy.mFillerOrderNumber);
  insert("messta", cpy.mMesaStatus);
}

MPlacerOrder::~MPlacerOrder()
{
}

void
MPlacerOrder::printOn(ostream& s) const
{
  s << "MPlacerOrder:"
    << mPatientID << ":"
    << mIssuerOfPatientID << ":"
    << mPlacerOrderNumber << ":"
    << mFillerOrderNumber << ":"
    << mMesaStatus << endl;

  int count = mOrderVector.size();
  int index = 0;
  for (; index < count; index++) {
    s << " " << mOrderVector[index] << endl;
  }
}

void
MPlacerOrder::streamIn(istream& s)
{
  //s >> this->member;
}

MPlacerOrder::MPlacerOrder(const MString& patientID,
			   const MString& issuerOfPatientID,
			   const MOrder& order) :
  mPatientID(patientID),
  mIssuerOfPatientID(issuerOfPatientID),
  mPlacerOrderNumber(order.placerOrderNumber()),
  mFillerOrderNumber(order.fillerOrderNumber()),
  mMesaStatus(order.mesaStatus())
{
  tableName("placerorder");
  insert("patid", patientID);
  insert("issuer", issuerOfPatientID);
  insert("plaordnum", order.placerOrderNumber());
  insert("filordnum", order.fillerOrderNumber());
  insert("messta", order.mesaStatus());

  MOrder o(order);
  add(o);
}
/*
MPlacerOrder::MPlacerOrder(const MString& patientID,
    const MString& issuerOfPatientID,
    const MString& placerOrderNumber,
    const MString& fillerOrderNumber,
    const MString& visitNumber,
    const MString& universalServiceID,
    const MString& orderControl,
    const MString& placerGroupNumber,
    const MString& orderStatus,
    const MString& quantityTiming,
    const MString& parent,
    const MString& dateTimeOfTransaction,
    const MString& enteredBy,
    const MString& orderingProvider,
    const MString& enteringOrganization,
    const MString& orderEffectiveDateTime,
    const MString& specimenSource,
    const MString& transportArrangementResponsibility,
    const MString& reasonForStudy,
    const MString& orderCallbackPhoneNumber,
    const MString& observationValue,
    const MString& dangerCode,
    const MString& relevantClinicalInfo) :
  mPatientID(patientID),
  mIssuerOfPatientID(issuerOfPatientID),
  mPlacerOrderNumber(placerOrderNumber),
  mFillerOrderNumber(fillerOrderNumber)
{
  tableName("placerorder");
  insert("patid", patientID);
  insert("issuer", issuerOfPatientID);
  insert("plaordnum", placerOrderNumber);
  insert("filordnum", fillerOrderNumber);

  MOrder o(placerOrderNumber,
           fillerOrderNumber,
           visitNumber,
           universalServiceID,
           orderControl,
           placerGroupNumber,
           orderStatus,
           quantityTiming,
           parent,
           dateTimeOfTransaction,
           enteredBy,
           orderingProvider,
           enteringOrganization,
           orderEffectiveDateTime,
           specimenSource,
           transportArrangementResponsibility,
           reasonForStudy,
           orderCallbackPhoneNumber,
           observationValue,
           dangerCode,
           relevantClinicalInfo);
  add(o);
}
  */
MString
MPlacerOrder::patientID() const
{
  return mPatientID;
}

MString
MPlacerOrder::placerOrderNumber() const
{
 return mPlacerOrderNumber;
}

MString
MPlacerOrder::fillerOrderNumber() const
{
 return mFillerOrderNumber;
}

MString
MPlacerOrder::issuerOfPatientID() const
{
  return mIssuerOfPatientID;
}

MString
MPlacerOrder::mesaStatus() const
{
  return mMesaStatus;
}

void
MPlacerOrder::patientID(const MString& s)
{
  mPatientID = s;
  insert("patid",s);
}

void
MPlacerOrder::issuerOfPatientID(const MString& s)
{
  mIssuerOfPatientID = s;
  insert("issuer",s);
}

void
MPlacerOrder::placerOrderNumber(const MString& s)
{
  mPlacerOrderNumber = s;
  insert("plaordnum",s);
  for (MOrderVector::iterator i = mOrderVector.begin();
       i != mOrderVector.end(); i++)
       (*i).placerOrderNumber(s); 
}

void
MPlacerOrder::fillerOrderNumber(const MString& s)
{
  mFillerOrderNumber = s;
  insert("filordnum",s);
  for (MOrderVector::iterator i = mOrderVector.begin();
       i != mOrderVector.end(); i++)
       (*i).fillerOrderNumber(s); 
}

void
MPlacerOrder::mesaStatus(const MString& s)
{
  mMesaStatus = s;
  insert("messta", s);
  for (MOrderVector::iterator i = mOrderVector.begin();
       i != mOrderVector.end(); i++)
    (*i).mesaStatus(s);
}

void
MPlacerOrder::add(const MOrder& o)
{
  if (o.placerOrderNumber() == mPlacerOrderNumber)
    mOrderVector.push_back(o);
}

MOrder&
MPlacerOrder::order(int index)
{
  if ( numOrders() && (index < numOrders()))
    return mOrderVector[index];
  else {
    cout << "Order vector empty or invalid index specified" << endl;
    ::exit(1);
  }
}

int
MPlacerOrder::numOrders() const
{
  return mOrderVector.size();
}

bool
MPlacerOrder::orderEmpty() const
{
  return mOrderVector.empty();
}

void
MPlacerOrder::import(MDomainObject& o)
{
  patientID(o.value("patid"));
  issuerOfPatientID(o.value("issuer"));
  placerOrderNumber(o.value("plaordnum"));
  fillerOrderNumber(o.value("filordnum"));
  mesaStatus(o.value("messta"));
}

