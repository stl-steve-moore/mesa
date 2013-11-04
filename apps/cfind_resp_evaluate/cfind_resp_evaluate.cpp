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

static char rcsid[] = "$Revision: 1.11 $ $RCSfile: cfind_resp_evaluate.cpp,v $";

#include "MESA.hpp"
#include "ctn_api.h"
#include "MDICOMWrapper.hpp"
#include "MFileOperations.hpp"
#include "MDICOMElementEval.hpp"

#include <iomanip>
#include <vector>
#include <fstream>

typedef vector < DCM_TAG > tagVector;

static void usage()
{
  char msg[] =
"Usage: [-l level] [-L lang] [-s gggg eeee] [-v] <tag> <mask> <test dir> <master dir> \n\
\n\
  -l        Set output log level (1-4, default is 1) \n\
  -L        Set language of responses (Japanese) \n\
  -s        Specify the tag of a sequence to use as part of key\n\
  tag       DICOM tag of attribute to use as key (gggg eeee)\n\
  mask      Name of mask file that specifies attributes to test \n\
  test dir  Directory containing test responses to evaluate \n\
  master dir   Directory containing gold standard responses";

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
static void
fillMap(MStringMap& m, MStringVector& v, DCM_TAG seqTag, DCM_TAG tag)
{
  MStringVector::iterator it = v.begin();
  for (; it != v.end(); it++) {
    MString f = *it;
    MDICOMWrapper w(f);
    MString key = "";
    if (seqTag == 0x00000000) {
      key = w.getString(tag);
    } else {
      key = w.getString(seqTag, tag);
    }
    if (key == "") {
      cout << "ERR: Unable to extract key from: " << f << endl;
      ::exit(1);
    }
    m[key] = f;
  }
}

int
evaluate(const MString& tstFile, const MString& stdFile,
	 const MString& maskName, bool verbose, int logLevel,
	 const MString& language)
{
  char buf[1024];
  maskName.safeExport(buf, sizeof(buf));

  ifstream  f(buf);
  if (!f) {
    cout << "ERR: Unable to open mask file: " << maskName << endl;
    ::exit(1);
  }

  MDICOMWrapper tstWrapper(tstFile);
  MDICOMWrapper stdWrapper(stdFile);
  MDICOMElementEval eval;

  int rtnValue = 0;

  while (f.getline(buf, sizeof(buf))) {
    if ((buf[0] == '#' || buf[0] == '\n' || buf[0] == '\0'))
      continue;

    int gggg = 0, eeee = 0;
    int seqGGGG = 0, seqEEEE = 0;
    char c = ' ';
    if (::sscanf(buf, "%x %x %x %x %c", &seqGGGG, &seqEEEE, &gggg, &eeee, &c) != 5) {
      seqGGGG = seqEEEE = 0;
      if (::sscanf(buf, "%x %x %c", &gggg, &eeee, &c) != 3) {
	cout << "ERR: Mask file lines should be <gggg eeee c>: " << buf << endl;
	cout << "ERR:  or <gggg eeee gggg eeee c>" << buf << endl;
	::exit(1);
      }
    }
    DCM_TAG seqTag = DCM_MAKETAG(seqGGGG, seqEEEE);
    DCM_TAG tag = DCM_MAKETAG(gggg, eeee);
    MString tstString;
    MString stdString;

    bool attributePresent = false;
    DCM_ELEMENT e;
    ::memset(&e, 0, sizeof(e));
    e.tag = tag;
    ::DCM_LookupElement(&e);
    ::COND_PopCondition(TRUE);

    if (seqGGGG == 0x0000) {
      if (tstWrapper.attributePresent(tag))
	attributePresent = true;

      tstString = tstWrapper.getString(tag);
      stdString = stdWrapper.getString(tag);
    } else {
      tstString = tstWrapper.getString(seqTag, tag);
      stdString = stdWrapper.getString(seqTag, tag);
    }
    if (logLevel >= 3) {
      if (e.representation == DCM_PN) {
	cout << "CTX: " << buf << ":" << tstString << endl;
	cout << "CTX: " << buf << ":" << stdString << endl;
      } else {
	cout << "CTX: " << buf << ":" << tstString << ":" << stdString << endl;
      }
    }

    switch (c) {
    case '=':
      if (seqGGGG == 0x0000) {
	int tmp = 0;
	tmp = eval.evalElement(logLevel, tstWrapper, stdWrapper, tag, language);
	if (tmp != 0) {
	  rtnValue = 1;
	}
      } else {
	if (tstString != stdString) {
	  cout << "ERR: C-Find response failed for an attribute: " << buf << endl;
	  cout << "ERR:  Your value: " << tstString << endl;
	  cout << "ERR:  Expected v: " << stdString << endl;
	  rtnValue = 1;
	}
      }
      break;
    case 'O':
      if (tstString.size() == 0) {
	cout << "WARN: C-Find response examined for optional attribute: " << buf << endl;
	cout << "WARN:  Your response did not contain the value or it was 0-length" << endl;
	cout << "WARN:  This is merely an informative message." << endl;
      }
      break;
    case 'P':
      if (tstString.size() == 0) {
	cout << "ERR: C-Find response expected to find a value for: " << buf << endl;
	cout << "ERR:  Your response did not contain the value or it was 0-length" << endl;
	rtnValue = 1;
      }
      break;
    case 'Z':	// Test for present, but attribute can be zero length
      if (! attributePresent) {
	cout << "ERR: C-Find response expected to find a value for: " << buf << endl;
	cout << "ERR:  Your response did not contain the value" << endl;
	rtnValue = 1;
      }
      break;
    default:
      break;
    }
  }
  return rtnValue;
}

int main(int argc, char **argv)
{
  char* attributeFile = 0;
  bool verbose = false;
  int seqGroup = 0;
  int seqElement = 0;

  int group = 0;
  int element = 0;
  char* language = "";		// Language of messages for evaluation
  int level = 1;		// Level 1 is errors only

  while (--argc > 0 && (*++argv)[0] == '-') {
    switch (*(argv[0] + 1)) {
    case 'l':
      argc--; argv++;
      if (argc < 1)
	usage();
      level = atoi(*argv);
      if (level > 2)
	verbose = true;
      break;
    case 'L':
      argc--;
      argv++;
      if (argc < 1)
	usage();
      language = *argv;
      break;
    case 's':
      argc--;
      argv++;
      if (argc < 2)
	usage();
      if (::sscanf(*argv, "%x", &seqGroup) != 1) {
	cerr << "Unable to scan group: " << *argv << endl;
	usage();
      }
      argc--; argv++;
      if (::sscanf(*argv, "%x", &seqElement) != 1) {
	cerr << "Unable to scan element: " << *argv << endl;
	usage();
      }
      break;
    case 'v':
      verbose = true;
      level = 3;
      break;
    default:
      break;
    }
  }

  if (argc < 5)
    usage();

  if (::sscanf(argv[0], "%x", &group) != 1) {
    cerr << "Unable to scan group: " << argv[0] << endl;
    usage();
  }

  if (::sscanf(argv[1], "%x", &element) != 1) {
    cerr << "Unable to scan group: " << argv[1] << endl;
    usage();
  }
  DCM_TAG tag = DCM_MAKETAG(group, element);
  DCM_TAG seqTag = DCM_MAKETAG(seqGroup, seqElement);

  MString maskName(argv[2]);
  
  MStringVector testFiles;
  fillFileVector(testFiles, argv[3]);
  MStringVector stdFiles;
  fillFileVector(stdFiles, argv[4]);

  if (stdFiles.size() != testFiles.size()) {
    cout << "ERR: The number of responses in the test directory (" << argv[3] << ")" << endl
	 << "ERR:  does not match responses in the std directory (" << argv[4] << ")" << endl;
    cout << "ERR:  The counts are: " << testFiles.size() << " and "
	  << stdFiles.size() << endl;

    return 1;
  }

  int rtnStatus = 0;
  int evaluationCount = stdFiles.size();
  int failureCount = 0;

  MStringMap testMap;
  MStringMap stdMap;
  fillMap(testMap, testFiles, seqTag, tag);
  fillMap(stdMap, stdFiles, seqTag, tag);

  MStringMap::iterator it = stdMap.begin();
  for (it; it != stdMap.end(); it++) {
    MString key = (*it).first;

    MString stdFile = (*it).second;
    MString tstFile = testMap[key];

    if (verbose)
      cout << key << " " << tstFile << " " << stdFile << endl;

    int testStatus = evaluate(tstFile, stdFile, maskName, verbose, level, language);
    if (testStatus != 0) {
      cout << "ERR: C-Find resp evaluate failed for: " << tstFile << endl;
      rtnStatus = 1;
      failureCount++;
    }
  }

  return rtnStatus;
}
