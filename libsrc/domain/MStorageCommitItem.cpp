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
#include "MStorageCommitItem.hpp"

static char rcsid[] = "$Id: MStorageCommitItem.cpp,v 1.5 2000/05/06 19:57:45 smm Exp $";

MStorageCommitItem::MStorageCommitItem()
{
  tableName("storagecommit");
  insert("sopcla");
  insert("sopins");
  insert("trauid");
  insert("status");
}

MStorageCommitItem::MStorageCommitItem(const MStorageCommitItem& cpy) :
  mSOPClass(cpy.mSOPClass),
  mSOPInstance(cpy.mSOPInstance),
  mTransactionUID(cpy.mTransactionUID),
  mStatus(cpy.mStatus)
{
  tableName("storagecommit");
  insert("sopcla", mSOPClass);
  insert("sopins", mSOPInstance);
  insert("trauid", mTransactionUID);
  insert("status", mStatus);
}

MStorageCommitItem::~MStorageCommitItem()
{
}

void
MStorageCommitItem::printOn(ostream& s) const
{
  s << "MStorageCommitItem "
    << mSOPClass << " "
    << mSOPInstance << " "
    << mTransactionUID << " "
    << mStatus;
}

void
MStorageCommitItem::streamIn(istream& s)
{
  //s >> this->member;
}

// Non-boiler plate methods below

MStorageCommitItem::MStorageCommitItem(const MString& sopClass,
				       const MString& sopInstance,
				       const MString& transactionUID,
				       const MString& status) :
  mSOPClass(sopClass),
  mSOPInstance(sopInstance),
  mTransactionUID(transactionUID),
  mStatus(status)
{
  insert("sopcla", mSOPClass);
  insert("sopins", mSOPInstance);
  insert("trauid", mTransactionUID);
  insert("status", mStatus);
}

void
MStorageCommitItem::import(const MDomainObject& o)
{
  sopClass(o.value("sopcla"));
  sopInstance(o.value("sopins"));
  transactionUID(o.value("trauid"));
  status(o.value("status"));
}


MString
MStorageCommitItem::sopClass() const
{
  return mSOPClass;
}

MString
MStorageCommitItem::sopInstance() const
{
  return mSOPInstance;
}

MString
MStorageCommitItem::transactionUID() const
{
  return mTransactionUID;
}

MString
MStorageCommitItem::status() const
{
  return mStatus;
}

void
MStorageCommitItem::sopClass(const MString& sopClass)
{
  mSOPClass = sopClass;
  insert("sopcla", mSOPClass);
}

void
MStorageCommitItem::sopInstance(const MString& sopInstance)
{
  mSOPInstance = sopInstance;
  insert("sopins", mSOPInstance);
}

void
MStorageCommitItem::transactionUID(const MString& transactionUID)
{
  mTransactionUID = transactionUID;
  insert("trauid", mTransactionUID);
}

void
MStorageCommitItem::status(const MString& status)
{
  mStatus = status;
  insert("status", mStatus);
}
