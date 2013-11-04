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
#include "MDBSyslogManager.hpp"
#include "MLogClient.hpp"

MDBSyslogManager::MDBSyslogManager() :
  mDBInterface(0),
  mDBName("")
{
}

MDBSyslogManager::MDBSyslogManager(const MDBSyslogManager& cpy)
{
  if (mDBInterface)
    delete mDBInterface;
}

MDBSyslogManager::~MDBSyslogManager()
{
}

void
MDBSyslogManager::printOn(ostream& s) const
{
  s << "MDBSyslogManager";
}

void
MDBSyslogManager::streamIn(istream& s)
{
  //s >> this->member;
}

// Now, the non-boiler plate methods will follow.

MDBSyslogManager::MDBSyslogManager(const string& databaseName) :
  mDBName(databaseName),
  mDBInterface(0)
{
  if (databaseName != "")
    mDBInterface = new MDBInterface(databaseName);
}

int
MDBSyslogManager::initialize()
{
//  if (mDBInterface == 0)
//    return -1;

  return 0;
}

int
MDBSyslogManager::initialize(const MString& databaseName)
{
  if (mDBInterface != 0) {
    if (databaseName == mDBName)
      return 0;

    return -1;
  }

  mDBName = databaseName;
  if (databaseName != "")
    mDBInterface = new MDBInterface();

  if (mDBInterface->initialize(mDBName) != 0) {
    MLogClient logClient;
    logClient.log(MLogClient::MLOG_ERROR,
		"<no peer>", "MDBSyslogManager::initialize",
		__LINE__,
		"Unable to initialize database: ", databaseName);
    return 1;
  }

  return 0;
}

int
MDBSyslogManager::enterRecord(const MSyslogEntry& entry)
{
  if (mDBInterface == 0)
    return 1;

  int val = mDBInterface->insert(entry);

  return val;
}

static void syslogEntryCallback(MDomainObject& domainObj, void* ctx);

int
MDBSyslogManager::selectRecord(const MSyslogEntry& entry, MSyslogEntryVector &v)
{
  MCriteriaVector criteria;

  MCriteria c;
  MString identifier = entry.identifier();

  if (identifier != "") {
    c.attribute = "identifier";
    c.oper = TBL_EQUAL;
    c.value = identifier;
    criteria.push_back(c);
  }

  MSyslogEntry pattern(entry);
  mDBInterface->select(pattern, criteria, syslogEntryCallback, &v);

  return 0;
}

static void syslogEntryCallback(MDomainObject& domainObj, void* ctx)
{
  MSyslogEntryVector* v = (MSyslogEntryVector*) ctx;

  MSyslogEntry entry;
  entry.import(domainObj);
  (*v).push_back(entry);
}
