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

static char rcsid[] = "$Revision: 1.13 $ $RCSfile: mpps_evaluate.cpp,v $";

#include "MESA.hpp"
#include "ctn_api.h"
#include "MDICOMWrapper.hpp"
#include "MLMPPSEvaluator.hpp"
#include "MLEvalSimple1.hpp"
#include "MLEvalUnscheduled2.hpp"
#include "MLEvalGroup3.hpp"

#include <iomanip>
#include <vector>
#include <fstream>

typedef vector < DCM_TAG > tagVector;

static void usage()
{
  char msg[] =
"Usage: [-l level] [-L language] [-v] <mod | mgr> <test> <test file> <master> \n\
\n\
  -l         Output level (1 = errors, 2 = warnings, 3 = verbose, 4 = reference) \n\
  -L         Set language (Japanese) \n\
  -P         Protocol code flag (0 for no evaluate, 1 for evaluate\n\
  -v         Verbose mode (same as -l 3) \n\
  mod | mgr  Test output from modality (mod) or MPPS manager (mgr) \n\
  test       Test number (1=simple, 2=unscheduled, 3=group) \n\
  test file  File with MPPS data to test \n\
  master     Master file considered gold standard ";

  cerr << msg << endl;
  ::exit(1);
}

int main(int argc, char **argv)
{
  int outputLevel = 1;
  char* language = "";
  bool protocolCodeFlag = true;

  while (--argc > 0 && (*++argv)[0] == '-') {
    switch (*(argv[0] + 1)) {
    case 'l':
      argc--; argv++;
      if (argc < 1)
	usage();
      outputLevel = atoi(*argv);
      break;
    case 'L':
      argc--; argv++;
      if (argc < 1)
	usage();
      language = *argv;
      break;
    case 'P':
      argc--; argv++;
      if (argc < 1)
	usage();
      if (::strcmp(*argv, "0") == 0) {
	protocolCodeFlag = false;
      }
      break;
    case 'v':
      outputLevel = 3;
      break;
    default:
      break;
    }
  }

  if (argc < 4)
    usage();

  MString dataSource(*argv++);

  MString testString(*argv++);

  MDICOMWrapper testData(*argv++);

  MDICOMWrapper standardData(*argv);

  int testNumber = testString.intData();
  MLMPPSEvaluator* eval = 0;

  switch (testNumber) {
    case 1:
      eval = new MLEvalSimple1(testData, standardData);
      break;
    case 2:
      eval = new MLEvalUnscheduled2(testData, standardData);
      break;
    case 3:
      eval = new MLEvalGroup3(testData, standardData);
      break;
    case 4:
      break;
    case 5:
      break;
    case 6:
      break;
    default:
      cerr << "Unknown test number: " << testNumber << endl;
      return 1;
      break;
  }

  eval->outputLevel(outputLevel);
  eval->language(language);
  eval->performedProtocolCodeFlag(protocolCodeFlag);
  int status = eval->run(testString, "FINAL");
  return status;
}
