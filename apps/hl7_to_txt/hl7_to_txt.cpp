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
#include "ctn_os.h"
#include "MESA.hpp"
#include "MHL7Factory.hpp"
#include "MHL7Msg.hpp"

#include "MPatient.hpp"
#include "MHL7DomainXlate.hpp"
#include "MFileOperations.hpp"

using namespace std;

static void usage()
{
  char msg[] = "\
Usage: [-b base] [-d definition] [-h] file\n\
\n\
  -b   Set base directory for HL7 parsing rules; default is $MESA_TARGET/runtime\n\
  -d   Set suffix for HL7 parsing rules; default is ihe\n\
  -h   Print help message and exit\n\
\n\
  file Name of the file to dump";

  cerr << msg << endl;
  exit(1);
}


int main(int argc, char** argv)
{
  MFileOperations f;
  char path[256];

  f.expandPath(path, "MESA_TARGET", "runtime");
  strcat(path, "/");
  MString hl7Base(path);
  MString hl7Definition(".ihe");

  while (--argc > 0 && (*++argv)[0] == '-') {
    switch (*(argv[0] + 1)) {
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
    case 'h':
      usage();
      break;
    default:
      cerr << "Unrecognized option: " << (*argv)[1] << endl;
      usage();
      break;
    }
  }

  MHL7Factory factory(hl7Base, hl7Definition);
  MHL7Msg* m;


  if (argc != 1)
    usage();

  m = factory.readFromFile(*argv);

  if (m == 0) {
    cout << "Unable to read HL7 file: " << *argv << endl;
    return 1;
  }

  m->streamOut(cout);

  return 0;
}
