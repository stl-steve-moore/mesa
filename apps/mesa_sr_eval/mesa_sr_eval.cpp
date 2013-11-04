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

static char rcsid[] = "$Revision: 1.8 $ $RCSfile: mesa_sr_eval.cpp,v $";

#include "MESA.hpp"
#include "ctn_api.h"
#include "MSRWrapper.hpp"
#include "MSREval.hpp"

#include <iomanip>
#include <vector>
#include <fstream>

typedef vector < DCM_TAG > tagVector;

static void usage()
{
  char msg[] =
"Usage: [-r requirements] [-p pattern] [-t template] file\n\
\n\
  -r      Specify a text file listing required/optional content items\n\
  -o      Specify an option, one of (PREDECESSOR) \n\
  -p      Specify a file to use as a pattern\n\
  -t      Specify the Template Identifier to test for\n\
  -v      Verbose mode\n\
\n\
  file    Name of file to evaluate";

  cerr << msg << endl;
  ::exit(1);
}


int main(int argc, char **argv)
{
  bool verbose = false;
  MString templateID;
  MString patternName;
  MString requirementsFile;
  bool evalPredecessorDocSeq = false;
  MString tmp;

  while (--argc > 0 && (*++argv)[0] == '-') {
    switch (*(argv[0] + 1)) {
    case 'o':
      argc--; argv++;
      if (argc < 1)
	usage();
      tmp = *argv;
      if (tmp == "PREDECESSOR") evalPredecessorDocSeq = true;
      else usage();
      break;
    case 'p':
      argc--; argv++;
      if (argc < 1)
	usage();
      patternName = *argv;
      break;
    case 'r':
      argc--; argv++;
      if (argc < 1)
	usage();
      requirementsFile = *argv;
      break;
    case 't':
      argc--; argv++;
      if (argc < 1)
	usage();
      templateID = *argv;
      break;
    case 'v':
      verbose = true;
      break;
    default:
      break;
    }
  }

  if (argc < 1)
    usage();

  MSRWrapper* patternWrapper = 0;
  //MSRWrapper* testWrapper = new MSRWrapper(*argv);
  MSRWrapper* testWrapper = new MSRWrapper;
  if (testWrapper == 0) {
    cout << "Unable to create new MSRWrapper" << endl;
    return 1;
  }
  if (testWrapper->open(*argv) != 0) {
    cout << "Unable to open test SR file: " << *argv << endl;
    return 1;
  }
  testWrapper->expandSRTree();

  if (patternName != "") {
    patternWrapper = new MSRWrapper;
    if (patternWrapper->open(patternName) != 0) {
      cout << "Unable to open pattern SR file: " << *argv << endl;
      return 1;
    }
    patternWrapper->expandSRTree();
  }


  MSREval e;
  e.verbose(verbose);
  e.setTestObject(testWrapper);
  e.setPatternObject(patternWrapper);
  e.readContentItemRequirements(requirementsFile);

  int rtnStatus = 0;
  int x = 0;

  if (templateID != "") {
    x = e.evalTemplateIdentification(templateID);
    if (x < 0)
      return 1;
    if (x > 0)
      rtnStatus = 1;

    x = e.evalTemplate(templateID);
    if (x < 0)
      return 1;
    if (x > 0)
      rtnStatus = 1;
  }

  if (patternWrapper != 0) {
    x = e.compareRequiredContentItems();
    if (x < 0)
      return 1;
    if (x > 0)
      rtnStatus = 1;

    if (evalPredecessorDocSeq) {
      x = e.evalPredecessorDocumentSequence();
      if (x < 0)
	return 1;
      if (x > 0)
	rtnStatus = 1;
    }
  }

  x = e.evalSRDocumentContentModule();
  if (x < 0)
    return 1;
  if (x > 0)
    rtnStatus = 1;

  return rtnStatus;
}
