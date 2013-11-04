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

static char rcsid[] = "$Revision: 1.5 $ $RCSfile: cfind_evaluate.cpp,v $";

#include "MESA.hpp"
#include "ctn_api.h"
#include "MDICOMWrapper.hpp"
#include "MFileOperations.hpp"
#include "MLCFindEval.hpp"
#include "MLEvalStudy.hpp"
#include "MLEvalMWL.hpp"
#include "MLEvalImageAvail.hpp"

#include <iomanip>
#include <vector>
#include <fstream>

typedef vector < DCM_TAG > tagVector;

static void usage()
{
  char msg[] =
"Usage: [-v] <test> <file> [<file> ...] \n\
\n\
  v       Set output to verbose mode\n\
\n\
  test    Test to run (PATIENT, STUDY, MWL, IMG_AVAIL)\n\
  file    Name of file or directory to evaluate";

  cerr << msg << endl;
  ::exit(1);
}

static void fillFileVector(MStringVector& v, const MString& name)
{
  MFileOperations f;

  if (f.isDirectory(name)) {
    f.scanDirectory(name);
    int idx = 0;
    for (idx = 0; idx < f.filesInDirectory(); idx++) {
      MString s = name + MString("/") + f.fileName(idx);
      if (f.isDirectory(s))
	continue;

      v.push_back(s);
    }
  } else {
    v.push_back(name);
  }
}

int main(int argc, char **argv)
{
  char* attributeFile = 0;
  bool verbose = false;

  while (--argc > 0 && (*++argv)[0] == '-') {
    switch (*(argv[0] + 1)) {
    case 'v':
      verbose = true;
      break;
    default:
      break;
    }
  }

  if (argc < 2)
    usage();

  MString testString(*argv++);
  argc--;

  int rtnStatus = 0;
  int evaluationCount = 0;
  int failureCount = 0;
  while(argc-- > 0) {
    MStringVector v;
    fillFileVector(v, *argv++);
    MStringVector::iterator it = v.begin();
    for (; it != v.end(); it++) {
      cout << endl << *it << endl;
      evaluationCount++;

      MDICOMWrapper w(*it);
      MLCFindEval* eval = 0;
      if (testString == "STUDY") {
	eval = new MLEvalStudy(w);
      } else if (testString == "MWL") {
	eval = new MLEvalMWL(w);
      } else if (testString == "IMG_AVAIL") {
	eval = new MLEvalImageAvail(w);
      } else {
	cerr << "Test is not recognized: " << testString << endl;
	return 1;
      }
      eval->verbose(verbose);
      int status = eval->run();
      if (status == 0) {
	cout << "CFIND evaluation succeeded for " << *it << endl;
      } else {
	rtnStatus = 1;
	failureCount++;
	cout << "CFIND evaluation failed for " << *it << endl;
      }
      delete eval;
    }
  }
  cout << "C-Find evaluation: " << testString
       << " " << evaluationCount << " evaluations, "
       << failureCount << " failures" << endl;
  return rtnStatus;
}
