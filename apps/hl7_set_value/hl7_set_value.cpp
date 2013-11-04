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
#include <fstream>
#include <string>
#include "ctn_os.h"

#include "MESA.hpp"
#include "MHL7Factory.hpp"
#include "MHL7Msg.hpp"
#include "MFileOperations.hpp"

using namespace std;

static void usage()
{
  char msg[] = "\
Usage: [-b <base> [-d <definition>] [-h] -f file\n\
	[-i <index> | -a] <segment> <field> <component> <value>\n\
\n\
  -a   Optional, instead of -i <index>, set for all segments \n\
  -b   Set base directory for HL7 parsing rules; default is $MESA_TARGET/runtime\n\
  -d   Set suffix for HL7 parsing rules; default is ihe\n\
  -f   Name of file containing message (required switch) \n\
  -h   Print help message\n\
  -i   Optional <index> denotes which repeated segment\n\
\n\
       <segment> is the three character segment\n\
       <field> is an integer, specifying the field number\n\
       <component> is an integer, specifying the component within a field\n\
       <value> is the new value to place in the updated message\n\
";
	
  cerr << msg << endl;
  exit(1);
}


int main(int argc, char** argv)
{
  MFileOperations fileOps;
  char path[256];

  fileOps.expandPath(path, "MESA_TARGET", "runtime");
  MString hl7Base(path);
  hl7Base += "/";

  MString hl7Definition(".ihe");
  int index = 1;
  MString filename("");

  while (--argc > 0 && (*++argv)[0] == '-') {
    switch (*(argv[0] + 1)) {
    case 'b':
      argc--; argv++;
      if (argc < 1)
        usage();
      hl7Base = MString(*argv) + "/";
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
    case 'f':
      argc--; argv++;
      filename = MString(*argv);
      break;
    case 'i':
      argc--; argv++;
      index = atoi(*argv);
      if (index == 0)
        usage();
      break;
    case 'a':
      index = -1;
      break;
    default:
      cerr << "Unrecognized option: " << (*argv)[1] << endl;
      usage();
      break;
    }
  }

  MHL7Factory f(hl7Base, hl7Definition);
  MHL7Msg* m;

  if (filename == "")
    usage();

  if (argc != 4)
    usage();

  char *segment = *argv++;
  int field = atoi(*argv++);
  int component = atoi(*argv++);
  char *value = *argv++;

  if (field == 0)
    usage();

  m = f.readFromFile(filename);
  if (m == 0) {
    cerr << "Unable to read HL7 message from: " << filename << endl;
    return 1;
  }

  if (index > 0) {
    m->setValue(index, segment, field, component, value);
  }
  else {	// If using -a switch
    MString seg = m->firstSegment();
    while (seg != "") {
      if (seg == segment)
        m->setValue(field, component, value);
      seg = m->nextSegment();
    }
  }

  char *filenameStr = filename.strData();
  ofstream of(filenameStr);
  delete [] filenameStr;

  char *buf = new char[1000000];
  int length;
  m->exportToWire(buf, 1000000, length);
  of << buf;

  delete []buf;

  return 0;
}
