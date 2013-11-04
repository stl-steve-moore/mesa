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

static char rcsid[] = "$Revision: 1.9 $ $RCSfile: mesa_extract_nm_frames.cpp,v $";

#include "MESA.hpp"
#include "ctn_api.h"
#include "MLogClient.hpp"
#include "MDICOMWrapper.hpp"

#include "LNMFrameDynamic.hpp"
#include "LNMFrameGated.hpp"
#include "LNMFrameStatic.hpp"
#include "LNMFrameWholeBody.hpp"
#include "LNMFrameTomo.hpp"
#include "LNMFrameGatedTomo.hpp"
#include "LNMFrameReconTomo.hpp"
#include "LNMFrameReconGatedTomo.hpp"

#include <iomanip>
#include <vector>
#include <fstream>
#include <strstream>

typedef vector < DCM_TAG > tagVector;

static void usage()
{
  char msg[] =
"Usage: [-p NAME=value] [-l log] NM-file-in frames-out\n\
\n\
  -p           Set a parameter for an index vector\n\
               Names are:\n\
                 ANGULARVIEW\n\
                 DETECTOR\n\
                 ENERGY\n\
                 PHASE\n\
                 ROTATION\n\
                 RR\n\
                 SLICE\n\
                 TIMESLICE\n\
                 TIMESLOT\n\
  -l           Set log level (1-4) for debugging\n\
  NM-file-in   Input NM file\n\
  frames-out   Output file name for frames (pixels)";

  cerr << msg << endl;
  ::exit(1);
}

static void grabParam(MStringMap& frameIncrementPointerMap, const char* p)
{
  MString x(p);
  if (! x.tokenExists('=', 1)) {
    return;
  }
  MString pName = x.getToken('=', 0);
  MString pValue = x.getToken('=', 1);
  frameIncrementPointerMap[pName] = pValue;
}

LNMFrame*
frameFactory(const MString& imageType) {
  LNMFrame* f = 0;
  if (imageType == "DYNAMIC") {
    f = new LNMFrameDynamic();
  } if (imageType == "STATIC") {
    f = new LNMFrameStatic();
  } if (imageType == "GATED") {
    f = new LNMFrameGated();
  } if (imageType == "TOMO") {
    f = new LNMFrameTomo();
  } if (imageType == "GATED TOMO") {
    f = new LNMFrameGatedTomo();
  } if (imageType == "RECON TOMO") {
    f = new LNMFrameReconTomo();
  } if (imageType == "RECON GATED TOMO") {
    f = new LNMFrameReconTomo();
  } if (imageType == "WHOLE BODY") {
    f = new LNMFrameWholeBody();
  } else {
  }
  return f;
}

int main(int argc, char **argv)
{
  MLogClient logClient;
  MLogClient::LOGLEVEL logLevel = MLogClient::MLOG_ERROR;
  int reportLevel = 1;
  bool verbose = false;
  MString tmp;
  int testNumber = 1;
  char logTxt[512] = "";
  char* outputFile = 0;
  MStringMap frameIncrementPointerMap;

  while (--argc > 0 && (*++argv)[0] == '-') {
    switch (*(argv[0] + 1)) {
    case 'l':
      argc--; argv++;
      if (argc < 1)
	usage();
      logLevel = (MLogClient::LOGLEVEL)atoi(*argv);
      break;
    case 'p':
      argc--; argv++;
      if (argc < 1)
	usage();
      grabParam(frameIncrementPointerMap, *argv);
      break;
    case 'f':
      argc--;
      argv++;
      if (argc < 1)
        usage();
      outputFile = *argv;
      cout << "outputFile: " << outputFile << "\n";
      break;

    default:
      break;
    }
  }

  if (argc < 2)
    usage();

  logClient.initialize(logLevel, "");
  int rtnStatus = 0;

  MStringMap::iterator it = frameIncrementPointerMap.begin();
  for (; it != frameIncrementPointerMap.end(); it++) {
    MString pName = (*it).first;
    MString pValue= (*it).second;
    cout << pName << ":" << pValue << endl;
  }
  MDICOMWrapper w;
  if (w.open(*argv) != 0) {
    cout << "Unable to open NM image: " << *argv << endl;
    return 1;
  }
  MString imageType = w.getString(0x00080008);
  if (imageType.tokenExists('\\', 2)) {
    imageType = imageType.getToken('\\', 2);
  }
  cout << imageType << endl;
  LNMFrame* f = frameFactory(imageType);
  if (f == 0) {
    cout << "Did not recognize the image type: " << imageType << endl;
    return 1;
  }
  ofstream outputStream;
  outputStream.open(argv[1], ios::binary);

  if (outputFile != 0) {
    ofstream o(outputFile);
    if (o == 0) {
      cerr << "Could not open attribute file: " << outputFile << endl;
      ::exit(1);
    }
    f->extract(outputStream, w, frameIncrementPointerMap, o);
    outputStream.close();
    o.close();
  } else {
      //f->extract(outputStream, w, frameIncrementPointerMap);
  }

  return rtnStatus;
}
