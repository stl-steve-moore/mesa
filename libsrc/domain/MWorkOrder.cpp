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

#include "MWorkOrder.hpp"

MWorkOrder::MWorkOrder()
{
  tableName("work_orders");
  insert("ordnum");
  insert("typ");
  insert("params");
  insert("ordbyin");
  insert("datord");
  insert("timord");
  insert("datcom");
  insert("timcom");
  insert("elatim");
  insert("wortim");
  insert("status");
}

MWorkOrder::MWorkOrder(const MWorkOrder& cpy) :
  mOrderNumber(cpy.mOrderNumber),
  mType(cpy.mType),
  mParameters(cpy.mParameters),
  mOrderedBy(cpy.mOrderedBy),
  mDateOrdered(cpy.mDateOrdered),
  mTimeOrdered(cpy.mTimeOrdered),
  mDateCompleted(cpy.mDateCompleted),
  mTimeCompleted(cpy.mTimeCompleted),
  mElapsedTime(cpy.mElapsedTime),
  mWorkTime(cpy.mWorkTime),
  mStatus(cpy.mStatus)

{
  tableName("work_orders");
  insert("ordnum", mOrderNumber);
  insert("typ", mType);
  insert("params", mParameters);
  insert("ordbyin", mOrderedBy);
  insert("datord", mDateOrdered);
  insert("timord", mTimeOrdered);
  insert("datcom", mDateCompleted);
  insert("timcom", mTimeCompleted);
  insert("elatim", mElapsedTime);
  insert("wortim", mWorkTime);
  insert("status", mStatus);
}

MWorkOrder::~MWorkOrder()
{
}

void
MWorkOrder::printOn(ostream& s) const
{
  s << "Work Order:"
    << mOrderNumber << ":"
    << mType << ":"
    << mParameters << ":"
    << mOrderedBy << ":"
    << mDateOrdered << ":"
    << mTimeOrdered << ":"
    << mDateCompleted << ":"
    << mTimeCompleted << ":"
    << mElapsedTime << ":"
    << mWorkTime << ":"
    << mStatus;
}

void
MWorkOrder::streamIn(istream& s)
{
}

MWorkOrder::MWorkOrder( const MString& orderNumber,
	const MString& type,
	const MString& parameters,
	const MString& orderedBy,
	const MString& dateOrdered,
	const MString& timeOrdered,
	const MString& dateCompleted,
	const MString& timeCompleted,
	const MString& elapsedTime,
	const MString& workTime,
	const MString& status) :
  mOrderNumber(orderNumber),
  mType(type),
  mParameters(parameters),
  mOrderedBy(orderedBy),
  mDateOrdered(dateOrdered),
  mTimeOrdered(timeOrdered),
  mDateCompleted(dateCompleted),
  mTimeCompleted(timeCompleted),
  mElapsedTime(elapsedTime),
  mWorkTime(workTime),
  mStatus(status)
{
  tableName("work_orders");
  insert("ordnum", mOrderNumber);
  insert("typ", mType);
  insert("params", mParameters);
  insert("ordbyin", mOrderedBy);
  insert("datord", mDateOrdered);
  insert("timord", mTimeOrdered);
  insert("datcom", mDateCompleted);
  insert("timcom", mTimeCompleted);
  insert("elatim", mElapsedTime);
  insert("wortim", mWorkTime);
  insert("status", mStatus);
}

MString
MWorkOrder::orderNumber() const
{
  return mOrderNumber;
}

MString
MWorkOrder::type() const
{
  return mType;
}

MString
MWorkOrder::parameters() const
{
  return mParameters;
}

MString
MWorkOrder::orderedBy() const
{
  return mOrderedBy;
}

MString
MWorkOrder::dateOrdered() const
{
  return mDateOrdered;
}

MString
MWorkOrder::timeOrdered() const
{
  return mTimeOrdered;
}

MString
MWorkOrder::dateCompleted() const
{
  return mDateCompleted;
}

MString
MWorkOrder::timeCompleted() const
{
  return mTimeCompleted;
}

MString
MWorkOrder::elapsedTime() const
{
  return mElapsedTime;
}

MString
MWorkOrder::workTime() const
{
  return mWorkTime;
}

MString
MWorkOrder::status() const
{
  return mStatus;
}

void
MWorkOrder::orderNumber(const MString& s)
{
  mOrderNumber = s;
  insert("ordnum", s);
}

void
MWorkOrder::type(const MString& s)
{
  mType = s;
  insert("typ", s);
}

void
MWorkOrder::parameters(const MString& s)
{
  mParameters = s;
  insert("params", s);
}

void
MWorkOrder::orderedBy(const MString& s)
{
  mOrderedBy = s;
  insert("ordbyin", s);
}

void
MWorkOrder::dateOrdered(const MString& s)
{
  mDateOrdered = s;
  insert("datord", s);
}

void
MWorkOrder::timeOrdered(const MString& s)
{
  mTimeOrdered = s;
  insert("timord", s);
}

void
MWorkOrder::dateCompleted(const MString& s)
{
  mDateCompleted = s;
  insert("datcom", s);
}

void
MWorkOrder::timeCompleted(const MString& s)
{
  mTimeCompleted = s;
  insert("timcom", s);
}

void
MWorkOrder::elapsedTime(const MString& s)
{
  mElapsedTime = s;
  insert("elatim", s);
}

void
MWorkOrder::workTime(const MString& s)
{
  mWorkTime = s;
  insert("wortim", s);
}

void
MWorkOrder::status(const MString& s)
{
  mStatus= s;
  insert("status", s);
}

void
MWorkOrder::import(const MDomainObject& o)
{
  orderNumber(o.value("ordnum"));
  type(o.value("typ"));
  parameters(o.value("params"));
  orderedBy(o.value("ordby"));
  dateOrdered(o.value("datord"));
  timeOrdered(o.value("timord"));
  dateCompleted(o.value("datcom"));
  timeCompleted(o.value("timcom"));
  elapsedTime(o.value("elatim"));
  workTime(o.value("wortim"));
  status(o.value("status"));
}
