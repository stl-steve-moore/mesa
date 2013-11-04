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

#include "MESA.hpp"
#include "ctn_os.h"
#include "ctn_api.h"
#include <fstream>

static void
usageerror()
{
    char msg[] = "\
mesa_convert [-i type] [-o type] [-v] file \n\
\n\
    -i     Input format (hex) \n\
    -o     Output type (char) \n\
    -v     Verbose mode \n\
\n\
    file   Name of output file";

  cout << msg << endl;
  ::exit(1);
}

static bool readByte(unsigned char& u, const MString& inputType)
{
  int j = 0;
  bool rtnValue = false;
  if (inputType == "hex") {
    if (::scanf("%02x", &j) == 1) {
      rtnValue = true;
      u = (unsigned char)(j & 0xff);
    }
  }
  return rtnValue;
}

static void writeByte(ofstream& f, unsigned char u, const MString& outputType)
{
  f << u;
}

int main(int argc, char **argv)
{
  CTNBOOLEAN verbose = FALSE;
  MString inputType = "hex";
  MString outputType = "char";

  while (--argc > 0 && (*++argv)[0] == '-') {
    switch (*(argv[0] + 1)) {
    case 'i':
      argc--; argv++;
      if (argc < 1)
	usageerror();
      inputType = *argv;
      break;
    case 'o':
      argc--; argv++;
      if (argc < 1)
	usageerror();
      outputType = *argv;
      break;
    case 'v':
      verbose = TRUE;
      break;
    default:
      break;
    }
  }

  if (argc < 1)
    usageerror();

  ofstream f (*argv);
  if (!f) {
    cout << "Unable to create output file: " << *argv;
    return 1;
  }

  unsigned char u;
  bool done = false;
  bool readSuccessful = false;
  while (!done) {
    readSuccessful = readByte(u, inputType);
    if (!readSuccessful) {
      done = true;
    } else {
      writeByte(f, u, outputType);
    }
  }

  return 0;
}

