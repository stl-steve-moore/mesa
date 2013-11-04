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

static char rcsid[] = "$Revision: 1.10 $ $RCSfile: mesa_composite_eval.cpp,v $";

#include "MESA.hpp"
#include "ctn_api.h"
#include "MDICOMWrapper.hpp"
#include "MCompositeEval.hpp"

#include <iomanip>
#include <vector>
#include <fstream>

typedef vector < DCM_TAG > tagVector;

static void usage()
{
  char msg[] =
"Usage: [-L lang] [-l level] [-o option] [-p pattern] [-v] file\n\
\n\
  -L      Set language for evaluation (Japanese) \n\
  -l      Set log level for output (1-4, default is 1) \n\
  -o      Set an option; one of mwl, nouid \n\
  -p      Specify a file to use as a pattern\n\
  -v      Verbose mode \n\
\n\
  file    Name of file to evaluate";

  cerr << msg << endl;
  ::exit(1);
}


int main(int argc, char **argv)
{
  bool verbose = false;
  MString patternName;
  int mwlEnabled = 0;
  int noStudyInstanceUID = 0;
  MString s;
  int logLevel = 1;	// Default log level for output
  MString language = "";

  while (--argc > 0 && (*++argv)[0] == '-') {
    switch (*(argv[0] + 1)) {
    case 'L':
      argc--; argv++;
      if (argc < 1)
	usage();
      language = *argv;
      break;
    case 'l':
      argc--; argv++;
      if (argc < 1)
	usage();
      logLevel = atoi(*argv);
      break;
    case 'o':
      argc--; argv++;
      if (argc < 1)
	usage();
      s = *argv;
      if (s == "mwl") mwlEnabled = 1;
      if (s == "nouid") noStudyInstanceUID = 1;
      break;
    case 'p':
      argc--; argv++;
      if (argc < 1)
	usage();
      patternName = *argv;
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

  MDICOMWrapper* patternWrapper = 0;
  MDICOMWrapper* testWrapper = new MDICOMWrapper(*argv);

  if (patternName != "") {
    patternWrapper = new MDICOMWrapper(patternName);
  }


  MCompositeEval e;
  e.verbose(verbose);
  e.setTestObject(testWrapper);
  e.setPatternObject(patternWrapper);

  int rtnStatus = 0;

  rtnStatus = e.evalPatientModule(logLevel, language);
  rtnStatus |= e.evalGeneralStudyModule(logLevel, language, mwlEnabled, noStudyInstanceUID);
  rtnStatus |= e.evalPatientStudyModule(logLevel, language, mwlEnabled);
  rtnStatus |= e.evalGeneralSeriesModule(logLevel, language, mwlEnabled);
  rtnStatus |= e.evalGeneralEquipment(logLevel, mwlEnabled);
  rtnStatus |= e.evalGeneralImage(logLevel, mwlEnabled);
  rtnStatus |= e.evalImagePixel(logLevel, mwlEnabled);

  if (rtnStatus != 0) {
    cout << "DICOM Composite Object " << *argv
	 << " fails evaluation." << endl;
  }

  return rtnStatus;
}


