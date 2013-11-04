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

#include <iostream>
#include <string>
#include <fstream>

#include "ctn_os.h"
#include "MESA.hpp"
#include "MHL7Factory.hpp"
#include "MHL7Msg.hpp"
#include "MFileOperations.hpp"

using namespace std;

static void usage()
{
  char msg[] = "\n\
Usage: [-b base] [-d def] < <txt file> > <hl7 file>\n\
\n\
  -b   Set base directory for HL7 parsing rules; default is $MESA_TARGET/runtime \n\
  -d   Set suffix for HL7 parsing rules; default is ihe\n\
\n\
  txt file    Input text file \n\
  hl7 file    Output HL7 file";

  cout << msg;
  ::exit(1);
}

int main(int argc, char** argv)
{
  MFileOperations f;
  char path[256];

  f.expandPath(path, "MESA_TARGET", "runtime");
  strcat(path, "/");
  MString hl7Base(path);

  MString hl7Definition(".ihe");
  char* fileName = 0;

  while (--argc > 0 && (*++argv)[0] == '-') {
    switch(*(argv[0] + 1)) {
    case 'b':
      argc--; argv++;
      if (argc < 1)
        usage();
      hl7Base = MString(*argv) + "/";;
      break;
    case 'd':
      argc--; argv++;
      if (argc < 1)
        usage();
      hl7Definition = MString(".") + *argv;
      break;
    case 'f':
      argc--; argv++;
      if (argc < 1)
        usage();
      fileName = *argv;
      break;
    case 'h':
     usage();
     break;
    default:
      break;
    }
  }


  MHL7Factory factory(hl7Base, hl7Definition);
  MHL7Msg* m;

  m = factory.produce();

  if (fileName != 0) {
    ifstream inputFile(fileName);
    if (!inputFile) {
      cout << "Could not open input file: " << fileName << endl;
      return 1;
    }
    inputFile >> *m;
  } else {
    cin >> *m;
  }

  char wire[40000];
  int len = 0;
  m->exportToWire(wire, sizeof(wire), len);
  ::fwrite(wire, 1, len, stdout);

  return 0;
}
