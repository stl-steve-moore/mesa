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

#include "MFillerOrder.hpp"
#ifdef GCC4
#include <stdlib.h>
#endif

MFillerOrder::MFillerOrder()
{
  tableName("fillerorder");
  insert("patid");
  insert("issuer");
  insert("plaordnum");
  insert("filordnum");
  insert("accnum");
}

MFillerOrder::MFillerOrder(const MFillerOrder& cpy) :
  mPatientID(cpy.mPatientID),
  mIssuerOfPatientID(cpy.mIssuerOfPatientID),
  mPlacerOrderNumber(cpy.mPlacerOrderNumber),
  mFillerOrderNumber(cpy.mFillerOrderNumber),
  mAccessionNumber(cpy.mAccessionNumber),
  mOrderVector(cpy.mOrderVector)
{
  tableName("fillerorder");
  insert("patid", cpy.mPatientID);
  insert("issuer", cpy.mIssuerOfPatientID);
  insert("plaordnum", cpy.mPlacerOrderNumber);
  insert("filordnum", cpy.mFillerOrderNumber);
  insert("accnum", cpy.mAccessionNumber);
}

MFillerOrder::~MFillerOrder()
{
}

void
MFillerOrder::printOn(ostream& s) const
{
  s << "MFillerOrder";
}

void
MFillerOrder::streamIn(istream& s)
{
  //s >> this->member;
}

MFillerOrder::MFillerOrder(const MString& patientID,
    const MString& issuerOfPatientID,
    const MString& accessionNumber,
    const MOrder& order) :
  mPatientID(patientID),
  mIssuerOfPatientID(issuerOfPatientID),
  mPlacerOrderNumber(order.placerOrderNumber()),
  mFillerOrderNumber(order.fillerOrderNumber()),
  mAccessionNumber(accessionNumber)
{
  tableName("fillerorder");
  insert("patid", patientID);
  insert("issuer", issuerOfPatientID);
  insert("plaordnum", order.placerOrderNumber());
  insert("filordnum", order.fillerOrderNumber());
  insert("accnum", accessionNumber);

  MOrder o(order);
  add(o);
}
/*
MFillerOrder::MFillerOrder(const MString& patientID,
    const MString& issuerOfPatientID,
    const MString& placerOrderNumber,
    const MString& fillerOrderNumber,
    const MString& accessionNumber,
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
  mAccessionNumber(accessionNumber)
{
  tableName("fillerorder");
  insert("patid", patientID);
  insert("issuer", issuerOfPatientID);
  insert("accnum", accessionNumber);

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
MFillerOrder::patientID() const
{
  return mPatientID;
}

MString
MFillerOrder::issuerOfPatientID() const
{
  return mIssuerOfPatientID;
}

MString
MFillerOrder::placerOrderNumber() const
{
  return mPlacerOrderNumber;
}

MString
MFillerOrder::fillerOrderNumber() const
{
  return mFillerOrderNumber;
}

MString
MFillerOrder::accessionNumber() const
{
  return mAccessionNumber;
}

const MOrder&
MFillerOrder::order(int index) const
{
  if ( numOrders() && (index < numOrders()))
    return mOrderVector[index];
  else {
    cout << "Order vector empty or invalid index specified" << endl;
    ::exit(1);
  }
}

void
MFillerOrder::patientID(const MString& s)
{
  mPatientID = s;
  insert("patid",s);
}

void
MFillerOrder::issuerOfPatientID(const MString& s)
{
  mIssuerOfPatientID = s;
  insert("issuer",s);
}

void
MFillerOrder::placerOrderNumber(const MString& s)
{
  mPlacerOrderNumber = s;
  insert("plaordnum",s);
  
  for (MOrderVector::iterator i = mOrderVector.begin();
       i != mOrderVector.end(); i++)
    (*i).placerOrderNumber(s);
}

void
MFillerOrder::fillerOrderNumber(const MString& s)
{
  mFillerOrderNumber = s;
  insert("filordnum",s);

  for (MOrderVector::iterator i = mOrderVector.begin();
       i != mOrderVector.end(); i++)
    (*i).fillerOrderNumber(s);
}

void
MFillerOrder::accessionNumber(const MString& s)
{
  mAccessionNumber = s;
  insert("accnum",s);
}

void
MFillerOrder::add(const MOrder& o)
{
  if (o.fillerOrderNumber() == mFillerOrderNumber)
    mOrderVector.push_back(o);
}

bool
MFillerOrder::orderEmpty() const
{
  return mOrderVector.empty();
}

int
MFillerOrder::numOrders() const
{
  return mOrderVector.size();
}

void
MFillerOrder::import(MDomainObject& o)
{
  patientID(o.value("patid"));
  issuerOfPatientID(o.value("issuer"));
  placerOrderNumber(o.value("plaordnum"));
  fillerOrderNumber(o.value("filordnum"));
  accessionNumber(o.value("accnum"));
}
