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

// File: im_hl7.cpp

#include "ctn_os.h"
#include "MESA.hpp"

#include "MDBImageManager.hpp"
#include "MDBImageManagerJapanese.hpp"
#include "MDBOrderFiller.hpp"
#include "MDBOrderFillerJapanese.hpp"
#include "MDBOrderPlacer.hpp"
#include "MDBOrderPlacerJapanese.hpp"
#include "MDBXRefMgr.hpp"
#include "MDBPDSupplier.hpp"

#include "MLogClient.hpp"


using namespace std;

static void usage()
{
  char msg[] = "\
Usage: mesa_db_test \n";

  cerr << msg << endl;
  ::exit(1);
}

MDBInterface *
openInterface(const MString& dbName)
{
  MDBInterface* m = new MDBInterface(dbName);
  if (m == 0) {
    MLogClient logClient;
    logClient.log(MLogClient::MLOG_ERROR,
                  "<no peer>", "mesa_db_test::openInterface", __LINE__,
                  "Unable to create new MDBInterface");
    ::exit(1);
  }
  return m;
}

MDBImageManager*
openImgMgr(const MString& dbName)
{
  MDBImageManager* m = new MDBImageManager(dbName);
  if (m == 0) {
    MLogClient logClient;
    logClient.log(MLogClient::MLOG_ERROR,
                  "<no peer>", "mesa_db_test::openImgMgr", __LINE__,
                  "Unable to create new MDBImageManager");
    ::exit(1);
  }
  return m;
}

MDBImageManagerJapanese*
openImgMgrJapanese(const MString& dbName)
{
  MDBImageManagerJapanese* m = new MDBImageManagerJapanese(dbName);
  if (m == 0) {
    MLogClient logClient;
    logClient.log(MLogClient::MLOG_ERROR,
                  "<no peer>", "mesa_db_test::openImgMgrJapanese", __LINE__,
                  "Unable to create new MDBImageManagerJapanese");
    ::exit(1);
  }
  return m;
}

MDBOrderFiller*
openOrderFiller(const MString& dbName)
{
  MDBOrderFiller* m = new MDBOrderFiller(dbName);
  if (m == 0) {
    MLogClient logClient;
    logClient.log(MLogClient::MLOG_ERROR,
                  "<no peer>", "mesa_db_test::openOrderFiller", __LINE__,
                  "Unable to create new MDBOrderFiller");
    ::exit(1);
  }
  return m;
}

MDBOrderFillerJapanese*
openOrderFillerJapanese(const MString& dbName)
{
  MDBOrderFillerJapanese* m = new MDBOrderFillerJapanese(dbName);
  if (m == 0) {
    MLogClient logClient;
    logClient.log(MLogClient::MLOG_ERROR,
                  "<no peer>", "mesa_db_test::openOrderFillerJapanese", __LINE__,
                  "Unable to create new MDBOrderFillerJapanese");
    ::exit(1);
  }
  return m;
}

MDBOrderPlacer*
openOrderPlacer(const MString& dbName)
{
  MDBOrderPlacer* m = new MDBOrderPlacer(dbName);
  if (m == 0) {
    MLogClient logClient;
    logClient.log(MLogClient::MLOG_ERROR,
                  "<no peer>", "mesa_db_test::openOrderPlacer", __LINE__,
                  "Unable to create new MDBOrderPlacer");
    ::exit(1);
  }
  return m;
}

MDBOrderPlacerJapanese*
openOrderPlacerJapanese(const MString& dbName)
{
  MDBOrderPlacerJapanese* m = new MDBOrderPlacerJapanese(dbName);
  if (m == 0) {
    MLogClient logClient;
    logClient.log(MLogClient::MLOG_ERROR,
                  "<no peer>", "mesa_db_test::openOrderPlacerJapanese", __LINE__,
                  "Unable to create new MDBOrderPlacerJapanese");
    ::exit(1);
  }
  return m;
}

MDBXRefMgr*
openXRefMgr(const MString& dbName)
{
  MDBXRefMgr* m = new MDBXRefMgr(dbName);
  if (m == 0) {
    MLogClient logClient;
    logClient.log(MLogClient::MLOG_ERROR,
                  "<no peer>", "mesa_db_test::openXRefMgr", __LINE__,
                  "Unable to create new MDBXRefMgr");
    ::exit(1);
  }
  return m;
}

MDBPDSupplier*
openPDSupplier(const MString& dbName)
{
  MDBPDSupplier* m = new MDBPDSupplier(dbName);
  if (m == 0) {
    MLogClient logClient;
    logClient.log(MLogClient::MLOG_ERROR,
                  "<no peer>", "mesa_db_test::openPDSupplier", __LINE__,
                  "Unable to create new MDBPDSupplier");
    ::exit(1);
  }
  return m;
}

int main(int argc, char** argv)
{ 
  MLogClient logClient;
  char path[256];
  MLogClient::LOGLEVEL logLevel = MLogClient::MLOG_NONE;
  int l1 = 0;

  while (--argc > 0 && (*++argv)[0] == '-') {
    switch(*(argv[0] + 1)) {
 
    case 'b':
      argc--; argv++;
      if (argc < 1)
	usage();
      break;

    case 'l':
      argc--;
      argv++;
      if (argc < 1)
	usage();
      if (sscanf(*argv, "%d", &l1) != 1)
	usage();
      logLevel = (MLogClient::LOGLEVEL)l1;
      break;

    case 'S':
      break;

    default:
      break;
    }
  }

  logClient.initialize(logLevel, "mesa_db_test.log");

  logClient.log(MLogClient::MLOG_WARN,
                  "<no peer>", "mesa_db_test<main>", __LINE__,
                  "Begin test process");

  MDBImageManager* dbImgMgr = 0;
  MDBImageManagerJapanese* dbImgMgrJapanese = 0;
  MDBOrderFiller * dbOrderFiller = 0;
  MDBOrderFillerJapanese * dbOrderFillerJapanese = 0;
  MDBOrderPlacer * dbOrderPlacer = 0;
  MDBOrderPlacerJapanese* dbOrderPlacerJapanese = 0;
  MDBXRefMgr* dbXRefMgr = 0;
  MDBPDSupplier* dbPDSupplier = 0;

  logClient.logTimeStamp(MLogClient::MLOG_WARN, "About to open imgmgr table");
  dbImgMgr = openImgMgr("imgmgr");

  logClient.logTimeStamp(MLogClient::MLOG_WARN, "About to open ordfil table");
  dbOrderFiller = openOrderFiller("ordfil");

  logClient.logTimeStamp(MLogClient::MLOG_WARN, "About to open ordplc table");
  dbOrderPlacer = openOrderPlacer("ordfil");

  delete dbImgMgr;
  delete dbImgMgrJapanese;
  delete dbOrderFiller;
  delete dbOrderFillerJapanese;
  delete dbOrderPlacer;
  delete dbOrderPlacerJapanese;
  delete dbXRefMgr;
  delete dbPDSupplier;

#if 0
  MDBInterface* dbInterface = 0;
  dbInterface = openInterface("adt");
  long nextSequence = 0;
  int status = dbInterface->nextSequence("xyz", nextSequence);
  if (status != 0) {
    cout << "Unable to get next status" << endl;
    ::COND_DumpConditions();
    return 1;
  }
  cout << "Next sequence: " << nextSequence << endl;
  status = dbInterface->nextSequence("xyz", nextSequence);
  cout << "Next sequence: " << nextSequence << endl;
#endif

  return 0;
}
