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



// Author, Date:	Stephen M. Moore, 2001.08.02
// Intent:		This program serves as an agent for the MESA
//			Data Server.  It reads entries from a queue
//			and exports data to other systems.
// Usage:		export_agent [-l level] <db name>
// Last Update:		$Author: smm $, $Date: 2009/03/06 18:41:51 $
// Source File:		$RCSfile: export_agent.cpp,v $
// Revision:		$Revision: 1.5 $
// Status:		$State: Exp $

static char rcsid[] = "$Revision: 1.5 $ $RCSfile: export_agent.cpp,v $";

#include "MESA.hpp"
#include "ctn_api.h"
#include "MLogClient.hpp"
#include "MFileOperations.hpp"
#include "MDBImageManager.hpp"
#include "MCGIParser.hpp"
#include "MLogClient.hpp"

#include "MLQuery.hpp"
#include "MLXferAgent.hpp"

static void
usageerror()
{
    char usage[] = "\
Usage: export_agent [-l level] [-s directory] <db name>\n\
\n\
    -l    Set log level (0 = none, 4 = verbose)\n\
    -s    Set log directory (default = $MESA_TARGET/logs) \n\
\n\
    <db name> \n\
          Name of the database to use\n";


    cout << usage << endl;

    ::exit(1);
}

static void logStart(MLogClient::LOGLEVEL logLevel,
		     const MString& logDirectory)
{
  if (logLevel != MLogClient::MLOG_NONE) {
    MFileOperations f;
    f.createDirectory(logDirectory);
    MString logFile = logDirectory + "/" + "export_agent.log";

    MLogClient logClient;
    logClient.initialize(logLevel, logFile);

    char tmp[128];
    ::sprintf(tmp, "Begin export_agent, log level = %d", (int)logLevel);
    logClient.logTimeStamp(MLogClient::MLOG_ERROR,	// Force this message out
			   tmp);

    cout << "export_agent logging messages at level "
	 << logLevel
	 << " to "
	 << logFile
	 << endl;
  }
}

static void initializeImageManager(MDBImageManager& imgMgr,
		     const MString& dbName)
{
  int status = imgMgr.initialize(dbName);
  if (status != 0) {
    MLogClient logClient;
    logClient.logTimeStamp(MLogClient::MLOG_ERROR,
	MString("export_agent unable to initialize Img Mgr database ") + dbName);

    ::exit(1);
  }
}

static void logEnd(MLogClient::LOGLEVEL logLevel)
{
  if (logLevel != MLogClient::MLOG_NONE) {
    MLogClient logClient;

    logClient.logTimeStamp(MLogClient::MLOG_ERROR,	// Force this message out
			   "Stopping export_agent");

    cout << "export_agent stopping"
	 << endl;
  }
}

static int
runOneCycle(MDBImageManager& imgMgr, bool deleteFlag)
{
  int status;
  MLogClient logClient;

  MLQuery query(imgMgr);

  status = query.queryNewWorkOrders();
  if (status != 0) {
    logClient.logTimeStamp(MLogClient::MLOG_ERROR,
	"Unable to query Image Manager database for work orders");
    return -1;
  }

  int count = query.workOrderCount();
  char tmp[128];
  sprintf(tmp, "Number of work orders in query: %d", count);
  logClient.log(MLogClient::MLOG_CONVERSATION,
		"", "runOneCycle", __LINE__,
		tmp);

  int idx;
  MLXferAgent xferAgent(imgMgr);

  for (idx = 0; idx < count; idx++) {
    MWorkOrder o = query.getWorkOrder(idx);
    cout << o << endl;

    MString type = o.type();
    MString params = o.parameters();

    int status = 1;

    if (type == "XMIT_STUDY") {
      status = xferAgent.xmitStudy(params);
    } else if (type == "XMIT_SERIES") {
      status = xferAgent.xmitSeries(params);
    }

    if (status != 0) {
      cout << "Unable to process" << endl;
      return 1;
    }

#if 0
    MCGIParser parser;
    parser.parse(params);
    MString x = parser.getValue("destAE");
    cout << "Destination AE: " << x << endl;
#endif

    imgMgr.setWorkOrderComplete(o, "2");

    if (deleteFlag) {
      MString orderNumber = o.orderNumber();
      cout << orderNumber << endl;
      imgMgr.deleteWorkOrder(orderNumber);
    }
  }
  return 0;
}

int main(int argc, char **argv)
{
  MLogClient::LOGLEVEL logLevel = MLogClient::MLOG_CONVERSATION;
  MFileOperations f;
  char path[256];

  f.expandPath(path, "MESA_TARGET", "logs");
  MString logDirectory(path);

  bool deleteFlag = false;

  while (--argc > 0 && (*++argv)[0] == '-') {
    int l1 = 0;
    switch (*(argv[0] + 1)) {
      case 'd':
	deleteFlag = true;
	break;
      case 'l':
	argc--;
	argv++;
	if (argc < 1)
	  usageerror();
	if (sscanf(*argv, "%d", &l1) != 1)
	  usageerror();
	logLevel = (MLogClient::LOGLEVEL)l1;
	break;

      case 's':
	argc--; argv++;
	if (argc < 1)
	  usageerror();
	logDirectory = MString(*argv) + "/";
	break;

      default:
	(void) fprintf(stderr, "Unrecognized option: %c\n", *(argv[0] + 1));
	break;
    }
  }

  if (argc < 1)
    usageerror();

  ::THR_Init();

  logStart(logLevel, logDirectory);

  MDBImageManager imgMgr;
  initializeImageManager(imgMgr, *argv);

  runOneCycle(imgMgr, deleteFlag);

  logEnd(logLevel);

  return 0;
}

