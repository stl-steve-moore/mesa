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

static char rcsid[] = "$Revision: 1.2 $ $RCSfile: update_gppps.cpp,v $";

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
//#ifdef GCCSUNOS
//#include <sys/types.h>
//#endif
#include "MESA.hpp"
#include "ctn_api.h"
#include "MDICOMWrapper.hpp"
#include <iostream>
#include <iomanip>
#include "MDICOMDomainXlate.hpp"
#include "MDomainObject.hpp"
#include "MOutputInfo.hpp"
#include "MReqSubsWorkitem.hpp"
#include "MNonDCMOutput.hpp"

void
updatePPS( MGPPPSObject& gppps, MGPPPSObject& new_gppps ) 
{
  // update gppps with new_gppps
  MGPPPSWorkitem item = gppps.workitem();
  MGPPPSWorkitem new_item = new_gppps.workitem();

  MString value = new_item.status();
  if( value != "") item.status(value);

  value = new_item.description();
  if( value != "") item.description(value);

  value = new_item.endDate();
  if( value != "") item.endDate(value);
  
  value = new_item.endTime();
  if( value != "") item.endTime(value);

  gppps.workitem(item);

  MOutputInfoVector oiv = new_gppps.outputInfoVector();
  if( oiv.size() > 0) {
     MOutputInfo oi = oiv[0];
     MString value = oi.studyInstanceUID();
cout << "oi studyInsanceUID: " << value << endl;
     if( value != "") gppps.outputInfoVector(oiv);
  }

  MNonDCMOutputVector ndov = new_gppps.nonDCMOutputVector();
  if( ndov.size() > 0) {
     MNonDCMOutput ndo = ndov[0];
     MString value = ndo.codeValue();
cout << "ndo codeValue: " << value << endl;
     if( value != "") gppps.nonDCMOutputVector(ndov);
  }

  MReqSubsWorkitemVector rswv = new_gppps.reqSubsWorkitemVector();
  if( rswv.size() > 0) {
     MReqSubsWorkitem rsw = rswv[0];
     MString value = rsw.codeValue();
cout << "rsw codeValue: " << value << endl;
     if( value != "") gppps.reqSubsWorkitemVector(rswv);
  }
}

static void
usage()
{
    char msg[] = "\
Usage: update_gppps -t <template file> [-v] [-o <output file>] \n\
           <gppps.crt file> [<gppps.set file> ...] \n\
\n\
    -t     <template file>  file name for empty gppps object (DICOM format)\n\
                            Defines attributes to be used.\n\
    -v     Verbose mode\n\
    -o     <output file>    file name for gppps object (DICOM format)\n\
                            default is gppps.dcm \n\
\n\
    <gppps.crt file>   File (DICOM format) that creates gppps object\n\
    <gppps.set file>   File whose attributes will modify initial object";

    cerr << msg << endl;
    ::exit(1);
}

int
main(int argc, char **argv)
{
  CONDITION cond;
  bool verbose = FALSE;
  int rtnStatus = 0;
  MString out_fname = MString("gppps.dcm");
  MString tmplt_fname = MString("");;

  while (--argc > 0 && (*++argv)[0] == '-') {
    switch (*(argv[0] + 1)) {
    case 'v':
      verbose = true;
      break;
    case 'o':
      argc--; argv++;
      if (argc < 1)
         usage();
      out_fname = MString(*argv);
      break;
    case 't':
      argc--; argv++;
      if (argc < 1)
         usage();
      tmplt_fname = MString(*argv);
      break;
    default:
      break;
    }
  }

  ::THR_Init();
  if (argc < 1)
    usage();

  if( tmplt_fname == "") {
     cout << "\nMissing gppps object template file (dicom format)." << endl;
     usage();
     exit(1);
  }
  MDICOMWrapper w_tmplt;
  if( w_tmplt.open(tmplt_fname) != 0) {
     cout << "\nError reading gppps template file (dicom format): " << tmplt_fname << endl;
     usage();
     exit(1);
  }
  DCM_OBJECT *tmplt = w_tmplt.getNativeObject();
  
  MDICOMWrapper w_gppps(*argv);
  MGPPPSObject gppps, new_gppps;
  MDICOMDomainXlate xlate;
  xlate.translateDICOM( w_gppps, gppps);
  // cout << "Dump gppps object." << endl;
  // cout << gppps;

  while( --argc > 0) {
     MDICOMWrapper w_new_gppps(*(++argv));
     xlate.translateDICOM( w_new_gppps, new_gppps);
     // cout << "Dump new_gppps: " << new_gppps << endl;
     updatePPS( gppps, new_gppps);
  }

  DCM_OBJECT *obj;
  ::DCM_CreateObject(&obj,0);
  xlate.translateDICOM( gppps, tmplt, obj);
  MDICOMWrapper out_gppps(obj);
  out_gppps.saveAs(out_fname);

  exit(0);
}

