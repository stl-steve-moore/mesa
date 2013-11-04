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

static char rcsid[] = "$Revision: 1.3 $ $RCSfile: mesa_dump_obj.cpp,v $";

#include "MESA.hpp"
#include "ctn_api.h"
#include "MDICOMWrapper.hpp"

#include <iomanip>
#include <vector>
#include <fstream>

typedef vector < DCM_TAG > tagVector;

static void usage()
{
  char msg[] =
    "Usage: [-a <attribute file>] [-f <output file>] <input file name(s)>";
  cerr << msg << endl;
  ::exit(1);
}

static void readTags(istream& i, tagVector& v)
{
  char buf[1024];

  while(i.getline(buf, sizeof(buf))) {
    if ((buf[0] == '#' || buf[0] == '\n'))
      continue;

    int i1 = 0, i2 = 0;
    ::sscanf(buf, "%x %x", &i1, &i2);
    DCM_TAG tag = DCM_MAKETAG(i1, i2);
    v.push_back(tag);
  }
}

static void readTags(const char* fileName, tagVector& v)
{
  if (fileName != 0) {
    ifstream f(fileName);
    if (f == 0) {
      cerr << "Could not open attribute file: " << fileName << endl;
      ::exit(1);
    }
    readTags(f, v);
  } else {
    readTags(cin, v);
  }
}

static void dumpAttributes(MDICOMWrapper& w,
			   tagVector& v,
			   ostream& o)
{
  tagVector::iterator i = v.begin();
  while (i != v.end()) {
    DCM_TAG t = *i;
    U16 group = DCM_TAG_GROUP(t);
    U16 element = DCM_TAG_ELEMENT(t);

    DCM_ELEMENT e;
    ::memset(&e, 0, sizeof(e));
    e.tag = t;
    CONDITION cond = ::DCM_LookupElement(&e);
    if (cond != DCM_NORMAL) {
      ::COND_PopCondition(TRUE);
      e.description[0] = '\0';
    }

    o << hex << setw(4) << setfill ('0') << group << " "
      << hex << setw(4) << element;

    o << setw (40) << setfill (' ') << e.description << ": ";

    MString s = w.getString(t);

    o << resetiosflags(0);

    o << s;

    o << endl;

    i++;
  }
}

static void dumpAttributes(MDICOMWrapper& w,
			   tagVector& v,
			   const char* outputFile)
{
  if (outputFile != 0) {
    ofstream f(outputFile);
    if (f == 0) {
      cerr << "Could not open attribute file: " << outputFile << endl;
      ::exit(1);
    }
    dumpAttributes(w, v, f);
  } else {
    dumpAttributes(w, v, cout);
  }

}

int main(int argc, char **argv)
{
  char* attributeFile = 0;
  char* outputFile = 0;

  while (--argc > 0 && (*++argv)[0] == '-') {
    switch (*(argv[0] + 1)) {
    case 'a':
      argc--;
      argv++;
      if (argc <= 0)
	usage();
      attributeFile = *argv;
      break;
    case 'f':
      argc--;
      argv++;
      if (argc <= 0)
	usage();
      outputFile = *argv;
      break;
    default:
      break;
    }
  }

  if (argc < 1)
    usage();

  tagVector v;

  readTags(attributeFile, v);

  MDICOMWrapper w(*argv);

  dumpAttributes(w, v, outputFile);

  return 0;
}
