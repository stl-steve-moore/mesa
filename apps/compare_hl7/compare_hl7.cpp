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
#include "MESA.hpp"
#include "MHL7Compare.hpp"
#include "MHL7Msg.hpp"

using namespace std;

static void usage ()
{
  char *msg =
	"usage: hl7_compare [-b base] [-d definition] [-l level] [-m mask] <master file> <test file> \n\
\n\
  -b    Set base for HL7 definitions (default is $MESA_TARGET/runtime) \n\
  -d    Set extension for HL7 definitions (default is ihe) \n\
  -l    Set log level for output (1-4) \n\
  -m    Set mask file to determine attributes to compare \n\
  \n\
  master file    The file considered the gold standard \n\
  test file      The file under test";

  cout << msg << endl;

  ::exit(1);
}

int main(int argc, char** argv)
{

  MString hl7Base("/opt/mesa/runtime/");
  MString hl7Definition(".ihe");
  MString maskFile("master/compare.ini");
  int logLevel = 1;		// level 1 is errors only

   while (--argc > 0 && (*++argv)[0] == '-') {
    switch(*(argv[0] + 1)) {
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
    case 'l':
      argc--; argv++;
      if (argc < 1)
	usage();
      logLevel = atoi(*argv);
      break;
    case 'm':
      argc--; argv++;
      if (argc < 1)
	usage();
      maskFile = MString(*argv);
      break;
    case 'v':
      logLevel = 3;
      break;
    default:
      break;
    }
  }
 
  if (argc < 2)
    usage();

  MHL7Compare c(hl7Base, hl7Definition, maskFile);

  if ( (c.compare( *(argv), *(argv+1) ), logLevel) == -1)
    return 1;

  if (c.count())
  {
    cout << "There is (are) " << c.count() << " " << "difference(s)" << endl;
    MDiff mDiff = c.getDiff();
    for (MDiff::iterator i = mDiff.begin(); i != mDiff.end(); i++)
    {
      cout << "Segment Name: " << (*i).first << endl;
      cout << "Field Number: " << ((*i).second).fldNum << endl;
      cout << "Master Value: " << ((*i).second).existValue << endl;
      cout << "Test Value: " << ((*i).second).newValue << endl;
      cout << "Problem: " << ((*i).second).comment << endl << endl;
    }
    return 1;
  }
  else
    cout << "Message OK" << endl;

  return 0;
}

