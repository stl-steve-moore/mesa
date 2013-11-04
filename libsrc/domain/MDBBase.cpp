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
#include "MDBBase.hpp"
#include "MLogClient.hpp"
#include "ctn_api.h"

MDBBase::MDBBase()
{
}

MDBBase::MDBBase(const MDBBase& cpy)
{
}

MDBBase::~MDBBase()
{
  TBL_CloseDB();
}

void
MDBBase::printOn(ostream& s) const
{
  s << "MDBBase";
}

void
MDBBase::streamIn(istream& s)
{
  //s >> this->member;
}

// Non-boilerplate methods to follow

//MDBBase::open(const string& dbName, const string& tableName)
int
MDBBase::open(const MString& dbName)
{
  CONDITION cond;
  MString dbn(dbName);
  char* db = dbn.strData();

  MLogClient logClient;
  logClient.log(MLogClient::MLOG_VERBOSE, "",
		"MDBBase::open", __LINE__,
		dbName);

  cond = ::TBL_OpenDB(db, &mDBHandle);
  delete [] db;
  if (cond != TBL_NORMAL) {
    this->logErrorStack(dbName);
    return 1;
    //::COND_DumpConditions();
    //::exit(1);
  }
  return 0;
}

#if 0
int
MDBBase::safeExport(const string& s, char* target, size_t len) const
{
  int length = s.length();
  if (length > len-1)
    length = len-1;

  ::strncpy(target, s.data(), length);
  target[length] = '\0';
  return 0;
}
#endif

int
MDBBase::insertRow(TBL_FIELD* f, const MString& tableName)
{
  CONDITION cond;
  MString tbl(tableName);
  char* tn = tbl.strData();

  MLogClient logClient;
  logClient.log(MLogClient::MLOG_VERBOSE, "",
		"MDBBase::insertRow", __LINE__,
		tableName);

  cond = ::TBL_InsertTable(&mDBHandle, f, tn);
  delete [] tn;
  if (cond != TBL_NORMAL) {
    this->logErrorStack(tableName);

    return 1;
  }
  return 0;
}

int
MDBBase::deleteRow(TBL_CRITERIA* c, const MString& tableName)
{
  CONDITION cond;
  MString tbl(tableName);
  char* tn = tbl.strData();


  MLogClient logClient;
  logClient.log(MLogClient::MLOG_VERBOSE, "",
		"MDBBase::deleteRow", __LINE__,
		tableName);

  cond = ::TBL_DeleteTable(&mDBHandle, c, tn);
  delete [] tn;
  if (cond != TBL_NORMAL) {
    this->logErrorStack(tableName);

    ::COND_DumpConditions();
    ::exit(1);
  }
  return 0;
}

int
MDBBase::updateRow(TBL_CRITERIA* c, TBL_UPDATE* u, const MString& tableName)
{
  CONDITION cond;
  MString tbl(tableName);
  char* tn = tbl.strData();

  MLogClient logClient;
  logClient.log(MLogClient::MLOG_VERBOSE, "",
		"MDBBase::updateRow", __LINE__,
		tableName);

  cond = ::TBL_UpdateTable(&mDBHandle, c, u, tn);
  delete [] tn;
  if (cond != TBL_NORMAL) {
    this->logErrorStack(tableName);

    return 1;
  }
  return 0;
}

int
MDBBase::selectRow(TBL_CRITERIA* c, TBL_FIELD* f,
		   CONDITION (*callback)(TBL_FIELD*, long, void*),
		   void *ctx, const MString& tableName, long* count)
{
  CONDITION cond;
  MString tbl(tableName);
  char* tn = tbl.strData();

  MLogClient logClient;
  logClient.log(MLogClient::MLOG_VERBOSE, "",
		"MDBBase::selectRow", __LINE__,
		tableName);

  cond = ::TBL_SelectTable(&mDBHandle, c, f, count, callback, ctx, tn);
  delete [] tn;
  if (cond != TBL_NORMAL) {
    CONDITION c1 = 0;
    this->logErrorStack(tableName);

    return 1;
  }
  return 0;
}


int
MDBBase::nextSequence(const MString& sequenceName, long& sequenceNumber)
{
  sequenceNumber = 0;
  char sequenceText[512] = "";
  sequenceName.safeExport(sequenceText, sizeof(sequenceText));

  CONDITION cond = TBL_NextSequence(&mDBHandle, sequenceText, &sequenceNumber);
  if (cond != TBL_NORMAL) {
    sequenceNumber = -1;
    return 1;
  }
  return 0;
}

int
MDBBase::nextSequence(const MString& sequenceName, MString& sequenceNumber)
{
  long seqNum = 0;
  char sequenceText[512] = "";
  sequenceName.safeExport(sequenceText, sizeof(sequenceText));

  CONDITION cond = TBL_NextSequence(&mDBHandle, sequenceText, &seqNum);
  if (cond != TBL_NORMAL) {
    seqNum = -1;
    return 1;
  }

  char tmp[128];
  strstream x(tmp,127);
  x << seqNum << '\0';
  sequenceNumber = tmp;

  return 0;
}

void
MDBBase::logErrorStack(const MString& modifier) const
{
  CONDITION cond = 0;
  MLogClient logClient;

  while(1) {
    char msg[512] = "";
    (void)::COND_TopCondition(&cond, msg, sizeof(msg));
    if (cond == COND_NORMAL) {
      break;
    }
    ::strcat(msg, ": ");
    logClient.log(MLogClient::MLOG_ERROR, MString(msg) + modifier);
    (void)::COND_PopCondition(FALSE);
  }
}
