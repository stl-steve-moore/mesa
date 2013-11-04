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
#include "MLQuery.hpp"
#include "MDBImageManager.hpp"
#include "MWorkOrder.hpp"
#include "MLogClient.hpp"

#if 0
MLQuery::MLQuery()
{
}
#endif

MLQuery::MLQuery(const MLQuery& cpy) :
  mImageManager(cpy.mImageManager),
  mWorkOrderVector(cpy.mWorkOrderVector)
{
}

MLQuery::~MLQuery()
{
}

void
MLQuery::printOn(ostream& s) const
{
  s << "MLQuery";
}

void
MLQuery::streamIn(istream& s)
{
  //s >> this->member;
}

// Non-boiler plate methods to follow

MLQuery::MLQuery(MDBImageManager& manager) :
  mImageManager(manager)
{
}

int
MLQuery::queryAllWorkOrders()
{
  MLogClient logClient;

  logClient.log(MLogClient::MLOG_VERBOSE,
                "",
                "MLQuery::queryAllWorkOrders",
                __LINE__,
                "Poll for all work orders");

  MWorkOrderVector::iterator pStart = mWorkOrderVector.begin();
  MWorkOrderVector::iterator pEnd   = mWorkOrderVector.end();
  mWorkOrderVector.erase(pStart, pEnd);

  mImageManager.queryWorkOrder(*this);

  return 0;
}

int
MLQuery::queryNewWorkOrders()
{
  MLogClient logClient;

  logClient.log(MLogClient::MLOG_VERBOSE,
                "",
                "MLQuery::queryAllWorkOrders",
                __LINE__,
                "Poll for all work orders");

  MWorkOrderVector::iterator pStart = mWorkOrderVector.begin();
  MWorkOrderVector::iterator pEnd   = mWorkOrderVector.end();
  mWorkOrderVector.erase(pStart, pEnd);

  mImageManager.queryWorkOrder(*this, 0);

  return 0;
}

int
MLQuery::workOrderCount()
{
  return mWorkOrderVector.size();
}

MWorkOrder
MLQuery::getWorkOrder(int index)
{
  if (index >= mWorkOrderVector.size()) {
    MLogClient logClient;

    logClient.log(MLogClient::MLOG_WARN,
                "",
                "MLQuery::returnWorkOrder",
                __LINE__,
                "Request for work order with index >= size of work order vector");

    MWorkOrder o;
    return o;
  }
  return mWorkOrderVector[index];
}

int
MLQuery::selectCallback(const MWorkOrder& workOrder)
{
  mWorkOrderVector.push_back(workOrder);

  return 0;
}
