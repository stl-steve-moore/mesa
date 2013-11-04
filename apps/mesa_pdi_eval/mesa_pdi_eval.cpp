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

static char rcsid[] = "$Revision: 1.7 $ $RCSfile: mesa_pdi_eval.cpp,v $";

#include "MESA.hpp"
#include "ctn_api.h"
#include "MDDRFile.hpp"
#include "MPDIEval.hpp"

#include <iomanip>
#include <vector>
#include <fstream>
#include <strstream>

typedef vector < DCM_TAG > tagVector;

static void usage()
{
  char msg[] =
"Usage: [-r report] [-l log] directory test\n\
\n\
  -r           Set report level (1-4)\n\
  -l           Set log level (1-4) for debugging\n\
  directory    Name of directory to evaluate\n\
  test         Test number to run";

  cerr << msg << endl;
  ::exit(1);
}


int main(int argc, char **argv)
{
  MLogClient logClient;
  MLogClient::LOGLEVEL logLevel = MLogClient::MLOG_ERROR;
  int reportLevel = 1;
  bool verbose = false;
  MString tmp;
  int testNumber = 1;
  char logTxt[512] = "";

  while (--argc > 0 && (*++argv)[0] == '-') {
    switch (*(argv[0] + 1)) {
    case 'l':
      argc--; argv++;
      if (argc < 1)
	usage();
      logLevel = (MLogClient::LOGLEVEL)atoi(*argv);
      break;
    case 'r':
      argc--; argv++;
      if (argc < 1)
	usage();
      reportLevel = atoi(*argv);
      break;
    default:
      break;
    }
  }

  if (argc < 1)
    usage();

  //logClient.initialize(logLevel, "mesa_pdi_eval.log");
  logClient.initialize(logLevel, "");
  int rtnStatus = 0;
  MPDIEval e;

  MString directoryName = *argv;
  if (directoryName.size() == 2) {
    if (directoryName.subString(1, 1) == ":") {
      directoryName += "\\";
    }
  }

  strstream s0(logTxt, sizeof(logTxt));
  s0 << "mesa_pdi_eval test number: " << testNumber
     << ", directory: " << directoryName << '\0';
  logClient.log(MLogClient::MLOG_CONVERSATION, MString(logTxt));

  if (e.initialize(directoryName) != 0) {
    logClient.log(MLogClient::MLOG_ERROR,
	MString("Unable to initialize evaluation class; will continue with testing"));
    //return 1;
  }

  testNumber = atoi(argv[1]);

  MString testComment = "";
  MString testDescription = "";
  rtnStatus = e.runTest(testNumber, reportLevel, testDescription, testComment);

  strstream s1(logTxt, sizeof(logTxt));
#if 0
  if (reportLevel >= 3) {
    cout << testDescription << endl;
  }
#endif
  if (rtnStatus == 0) {
    s1 << "mesa_pdi_eval test number: " << testNumber << ": PASS" << '\0';
  } else {
    s1 << "mesa_pdi_eval test number: " << testNumber << ": FAIL" << '\0';
  }
  if (rtnStatus != 0) {
    cout << testComment << endl;
  }
  cout << logTxt << endl;
  //logClient.log(MLogClient::MLOG_CONVERSATION, MString(logTxt));

  return rtnStatus;
}
