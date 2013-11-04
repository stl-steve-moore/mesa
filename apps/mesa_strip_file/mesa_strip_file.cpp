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

static char rcsid[] = "$Revision: 1.4 $ $RCSfile: mesa_strip_file.cpp,v $";

#include "MESA.hpp"
#include "ctn_api.h"
#include "MDICOMWrapper.hpp"
#include "MWrapperFactory.hpp"

#include <iomanip>
#include <vector>
#include <fstream>
#include <strstream>

static void usage()
{
  char msg[] =
"Usage: [-l loglevel] [-t] [-T] -r <retainedAttributesFile> input output\n\
\n\
  -l         Set log level (1-4)\n\
  -t         Input file is in part 10 format\n\
  -T         Output file is in part 10 format\n\
  -r         <retain attribute file> \n\
  input      Name of input file\n\
  output     Name of output file";

  cerr << msg << endl;
  ::exit(1);
}


int main(int argc, char **argv)
{
  char logTxt[512] = "";
  MString retainFile = "";
  U32 inputOptions = DCM_ORDERLITTLEENDIAN;
  U32 outputOptions = DCM_ORDERLITTLEENDIAN;
  MLogClient::LOGLEVEL logLevel = MLogClient::MLOG_ERROR;

  while (--argc > 0 && (*++argv)[0] == '-') {
    switch (*(argv[0] + 1)) {
    case 'l':
      argc--; argv++;
      if (argc < 1)
	usage();
      logLevel = (MLogClient::LOGLEVEL)atoi(*argv);
      break;
    case 'r':
      argc--; argv++;
      if (argc < 1)
	usage();
      retainFile = *argv;
      break;
    case 't':
      inputOptions = DCM_PART10FILE;
      break;
    case 'T':
      outputOptions = DCM_PART10FILE;
      break;
    default:
      break;
    }
  }

  if (argc < 2)
    usage();

  MLogClient logClient;
  logClient.initialize(logLevel, "");

  int rtnStatus = 0;
  int status = 0;

  MString inputFile = argv[0];
  MString outputFile = argv[1];

  MDICOMWrapper w;
  MWrapperFactory factory;

  if (w.open(inputFile, inputOptions) != 0) {
    cout << "Unable to open input file: " << inputFile << endl;
    rtnStatus = 1;
    goto exit_label;
  }

  if (retainFile != "") {
    status = factory.retainTags(w, retainFile);
    if (status != 0) {
      cout << "Unable to apply the retain tags method from file: " << retainFile << endl;
      rtnStatus = 1;
      goto exit_label;
    }
  }

  if (w.saveAs(outputFile, outputOptions) != 0) {
    cout << "Unable to write output file: " << outputFile << endl;
    rtnStatus = 1;
  }

exit_label:
  return rtnStatus;
}
