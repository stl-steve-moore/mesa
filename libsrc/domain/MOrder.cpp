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

#include "MOrder.hpp"

MOrder::MOrder()
{
  tableName("ordr");
  insert("plaordnum");
  insert("filordnum");
  insert("visnum");
  insert("uniserid");
  insert("ordcon");
  insert("plagronum");
  insert("ordsta");
  insert("messta");
  insert("quatim");
  insert("par");
  insert("dattimtra");
  insert("entby");
  insert("ordpro");
  insert("refdoc");
  insert("entorg");
  insert("ordeffdattim");
  insert("spesou");
  insert("traarrres");
  insert("reaforstu");
  insert("ordcalphonum");
  insert("obsval");
  insert("dancod");
  insert("relcliinf");
  insert("orduid");
}

MOrder::MOrder(const MOrder& cpy) :
  mPlacerOrderNumber(cpy.mPlacerOrderNumber),
  mFillerOrderNumber(cpy.mFillerOrderNumber),
  mVisitNumber(cpy.mVisitNumber),
  mUniversalServiceID(cpy.mUniversalServiceID),
  mOrderControl(cpy.mOrderControl),
  mPlacerGroupNumber(cpy.mPlacerGroupNumber),
  mOrderStatus(cpy.mOrderStatus),
  mMesaStatus(cpy.mMesaStatus),
  mQuantityTiming(cpy.mQuantityTiming),
  mParent(cpy.mParent),
  mDateTimeOfTransaction(cpy.mDateTimeOfTransaction),
  mEnteredBy(cpy.mEnteredBy),
  mOrderingProvider(cpy.mOrderingProvider),
  mReferringDoctor(cpy.mReferringDoctor),
  mEnteringOrganization(cpy.mEnteringOrganization),
  mOrderEffectiveDateTime(cpy.mOrderEffectiveDateTime),
  mSpecimenSource(cpy.mSpecimenSource),
  mTransportArrangementResponsibility(cpy.mTransportArrangementResponsibility),
  mReasonForStudy(cpy.mReasonForStudy),
  mOrderCallbackPhoneNumber(cpy.mOrderCallbackPhoneNumber),
  mObservationValue(cpy.mObservationValue),
  mDangerCode(cpy.mDangerCode),
  mRelevantClinicalInfo(cpy.mRelevantClinicalInfo),
  mOrderUID(cpy.mOrderUID)
{
  tableName("ordr");
  insert("plaordnum", cpy.mPlacerOrderNumber);
  insert("filordnum", cpy.mFillerOrderNumber);
  insert("visnum", cpy.mVisitNumber);
  insert("uniserid", cpy.mUniversalServiceID);
  insert("ordcon", cpy.mOrderControl);
  insert("plagronum", cpy.mPlacerGroupNumber);
  insert("ordsta", cpy.mOrderStatus);
  insert("messta", cpy.mMesaStatus);
  insert("quatim", cpy.mQuantityTiming);
  insert("par", cpy.mParent);
  insert("dattimtra", cpy.mDateTimeOfTransaction);
  insert("entby", cpy.mEnteredBy);
  insert("ordpro", cpy.mOrderingProvider);
  insert("refdoc", cpy.mReferringDoctor);
  insert("entorg", cpy.mEnteringOrganization);
  insert("ordeffdattim", cpy.mOrderEffectiveDateTime);
  insert("spesou", cpy.mSpecimenSource);
  insert("traarrres", cpy.mTransportArrangementResponsibility);
  insert("reaforstu", cpy.mReasonForStudy);
  insert("ordcalphonum", cpy.mOrderCallbackPhoneNumber);
  insert("obsval", cpy.mObservationValue);
  insert("dancod", cpy.mDangerCode);
  insert("relcliinf", cpy.mRelevantClinicalInfo);
}

MOrder::~MOrder()
{
}

void
MOrder::printOn(ostream& s) const
{
  s << "MOrder:"
    << mPlacerOrderNumber << ":"
    << mFillerOrderNumber << ":"
    << mVisitNumber << ":"
    << mUniversalServiceID << ":"
    << mOrderControl << ":"
    << mPlacerGroupNumber << ":"
    << mOrderStatus << ":"
    << mMesaStatus << ":"
    << mQuantityTiming << ":"
    << mParent << ":"
    << mDateTimeOfTransaction << ":"
    << mEnteredBy << ":"
    << mOrderingProvider << ":"
    << mReferringDoctor << ":"
    << mEnteringOrganization << ":"
    << mSpecimenSource << ":"
    << mTransportArrangementResponsibility << ":"
    << mReasonForStudy << ":"
    << mOrderCallbackPhoneNumber << ":"
    << mObservationValue << ":"
    << mDangerCode << ":"
    << mRelevantClinicalInfo << ":"
    << mOrderUID;
}

void
MOrder::streamIn(istream& s)
{
  //s >> this->member;
}

MOrder::MOrder(const MString& placerOrderNumber,
    const MString& fillerOrderNumber,
    const MString& visitNumber,
    const MString& universalServiceID,
    const MString& orderControl,
    const MString& placerGroupNumber,
    const MString& orderStatus,
    const MString& mesaStatus,
    const MString& quantityTiming,
    const MString& parent,
    const MString& dateTimeOfTransaction,
    const MString& enteredBy,
    const MString& orderingProvider,
    const MString& referringDoctor,
    const MString& enteringOrganization,
    const MString& orderEffectiveDateTime,
    const MString& specimenSource,
    const MString& transportArrangementResponsibility,
    const MString& reasonForStudy,
    const MString& orderCallbackPhoneNumber,
    const MString& observationValue,
    const MString& dangerCode,
    const MString& relevantClinicalInfo) :
  mPlacerOrderNumber(placerOrderNumber),
  mFillerOrderNumber(fillerOrderNumber),
  mVisitNumber(visitNumber),
  mUniversalServiceID(universalServiceID),
  mOrderControl(orderControl),
  mPlacerGroupNumber(placerGroupNumber),
  mOrderStatus(orderStatus),
  mMesaStatus(mesaStatus),
  mQuantityTiming(quantityTiming),
  mParent(parent),
  mDateTimeOfTransaction(dateTimeOfTransaction),
  mEnteredBy(enteredBy),
  mOrderingProvider(orderingProvider),
  mReferringDoctor(referringDoctor),
  mEnteringOrganization(enteringOrganization),
  mOrderEffectiveDateTime(orderEffectiveDateTime),
  mSpecimenSource(specimenSource),
  mTransportArrangementResponsibility(transportArrangementResponsibility),
  mReasonForStudy(reasonForStudy),
  mOrderCallbackPhoneNumber(orderCallbackPhoneNumber),
  mObservationValue(observationValue),
  mDangerCode(dangerCode),
  mRelevantClinicalInfo(relevantClinicalInfo),
  mOrderUID("")
{
  tableName("ordr");
  insert("plaordnum", placerOrderNumber);
  insert("filordnum", fillerOrderNumber);
  insert("visnum", visitNumber);
  insert("uniserid", universalServiceID);
  insert("ordcon", orderControl);
  insert("plagronum", placerGroupNumber);
  insert("ordsta", orderStatus);
  insert("messta", mesaStatus);
  insert("quatim", quantityTiming);
  insert("par", parent);
  insert("dattimtra", dateTimeOfTransaction);
  insert("entby", enteredBy);
  insert("ordpro", orderingProvider);
  insert("refdoc", referringDoctor);
  insert("entorg", enteringOrganization);
  insert("ordeffdattim", orderEffectiveDateTime);
  insert("spesou", specimenSource);
  insert("traarrres", transportArrangementResponsibility);
  insert("reaforstu", reasonForStudy);
  insert("ordcalphonum", orderCallbackPhoneNumber);
  insert("obsval", observationValue);
  insert("dancod", dangerCode);
  insert("relcliinf", relevantClinicalInfo);
  insert("orduid", "");
}

MString
MOrder::placerOrderNumber() const
{
  return mPlacerOrderNumber;
}

MString
MOrder::fillerOrderNumber() const
{
  return mFillerOrderNumber;
}

MString
MOrder::visitNumber() const
{
  return mVisitNumber;
}

MString
MOrder::universalServiceID() const
{
  return mUniversalServiceID;
}

MString
MOrder::orderControl() const
{
  return mOrderControl;
}

MString
MOrder::placerGroupNumber() const
{
  return mPlacerGroupNumber;
}

MString
MOrder::orderStatus() const
{
  return mOrderStatus;
}

MString
MOrder::mesaStatus() const
{
  return mMesaStatus;
}

MString
MOrder::quantityTiming() const
{
  return mQuantityTiming;
}

MString
MOrder::parent() const
{
  return mParent;
}

MString
MOrder::dateTimeOfTransaction() const
{
  return mDateTimeOfTransaction;
}

MString
MOrder::enteredBy() const
{
  return mEnteredBy;
}

MString
MOrder::orderingProvider() const
{
  return mOrderingProvider;
}

MString
MOrder::referringDoctor() const
{
  return mReferringDoctor;
}

MString
MOrder::enteringOrganization() const
{
  return mEnteringOrganization;
}

MString
MOrder::orderEffectiveDateTime() const
{
  return mOrderEffectiveDateTime;
}

MString
MOrder::specimenSource() const
{
  return mSpecimenSource;
}

MString
MOrder::transportArrangementResponsibility() const
{
  return mTransportArrangementResponsibility;
}

MString
MOrder::reasonForStudy() const
{
  return mReasonForStudy;
}

MString
MOrder::orderCallbackPhoneNumber() const
{
  return mOrderCallbackPhoneNumber;
}

MString
MOrder::observationValue() const
{
  return mObservationValue;
}

MString
MOrder::dangerCode() const
{
  return mDangerCode;
}

MString
MOrder::relevantClinicalInfo() const
{
  return mRelevantClinicalInfo;
}

MString
MOrder::orderUID() const
{
  return mOrderUID;
}

void
MOrder::placerOrderNumber(const MString& s)
{
  mPlacerOrderNumber = s;
  insert("plaordnum", s);
}

void
MOrder::fillerOrderNumber(const MString& s)
{
  mFillerOrderNumber = s;
  insert("filordnum", s);
}

void
MOrder::visitNumber(const MString& s)
{
  mVisitNumber = s;
  insert("visnum", s);
}

void
MOrder::universalServiceID(const MString& s)
{
  mUniversalServiceID = s;
  insert("uniserid", s);
}

void
MOrder::orderControl(const MString& s)
{
  mOrderControl = s;
  insert("ordcon", s);
}

void
MOrder::placerGroupNumber(const MString& s)
{
  mPlacerGroupNumber = s;
  insert("plagronum", s);
}

void
MOrder::orderStatus(const MString& s)
{
  mOrderStatus = s;
  insert("ordsta", s);
}

void
MOrder::mesaStatus(const MString& s)
{
  mMesaStatus = s;
  insert("messta", s);
}

void
MOrder::quantityTiming(const MString& s)
{
  mQuantityTiming = s;
  insert("quatim", s);
}

void
MOrder::parent(const MString& s)
{
  mParent = s;
  insert("par", s);
}

void
MOrder::dateTimeOfTransaction(const MString& s)
{
  mDateTimeOfTransaction = s;
  insert("dattimtra", s);
}

void
MOrder::enteredBy(const MString& s)
{
  mEnteredBy = s;
  insert("entby", s);
}

void
MOrder::orderingProvider(const MString& s)
{
  mOrderingProvider = s;
  insert("ordpro", s);
}

void
MOrder::referringDoctor(const MString& s)
{
  mReferringDoctor = s;
  insert("refdoc", s);
}

void
MOrder::enteringOrganization(const MString& s)
{
  mEnteringOrganization = s;
  insert("entorg", s);
}

void
MOrder::orderEffectiveDateTime(const MString& s)
{
  mOrderEffectiveDateTime = s;
  insert("ordeffdattim", s);
}

void
MOrder::specimenSource(const MString& s)
{
  mSpecimenSource = s;
  insert("spesou", s);
}

void
MOrder::transportArrangementResponsibility(const MString& s)
{
  mTransportArrangementResponsibility = s;
  insert("traarrres", s);
}

void
MOrder::reasonForStudy(const MString& s)
{
  mReasonForStudy = s;
  insert("reaforstu", s);
}

void
MOrder::orderCallbackPhoneNumber(const MString& s)
{
  mOrderCallbackPhoneNumber = s;
  insert("ordcalphonum", s);
}

void
MOrder::observationValue(const MString& s)
{
  mObservationValue = s;
  insert("obsval", s);
}

void
MOrder::dangerCode(const MString& s)
{
  mDangerCode = s;
  insert("dancod", s);
}

void
MOrder::relevantClinicalInfo(const MString& s)
{
  mRelevantClinicalInfo = s;
  insert("relcliinf", s);
}

void
MOrder::orderUID(const MString& s)
{
  mOrderUID = s;
  insert("orduid", s);
}

void
MOrder::import(MDomainObject& o)
{
  placerOrderNumber(o.value("plaordnum"));
  fillerOrderNumber(o.value("filordnum"));
  visitNumber(o.value("visnum"));
  universalServiceID(o.value("uniserid"));
  orderControl(o.value("ordcon"));
  placerGroupNumber(o.value("plagronum"));
  orderStatus(o.value("ordsta"));
  mesaStatus(o.value("messta"));
  quantityTiming(o.value("quatim"));
  parent(o.value("par"));
  dateTimeOfTransaction(o.value("dattimtra"));
  enteredBy(o.value("entby"));
  orderingProvider(o.value("ordpro"));
  referringDoctor(o.value("refdoc"));
  enteringOrganization(o.value("entorg"));
  orderEffectiveDateTime(o.value("ordeffdattim"));
  specimenSource(o.value("spesou"));
  transportArrangementResponsibility(o.value("traarrres"));
  reasonForStudy(o.value("reaforstu"));
  orderCallbackPhoneNumber(o.value("ordcalphonum"));
  observationValue(o.value("obsval"));
  dangerCode(o.value("dancod"));
  relevantClinicalInfo(o.value("relcliinf"));
  orderUID(o.value("orduid"));
}
