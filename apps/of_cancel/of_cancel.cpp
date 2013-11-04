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

// 
#include "MESA.hpp"
#include "MDomainObject.hpp"
#include "MDBInterface.hpp"
#include "MOrder.hpp"
#include "MPlacerOrder.hpp"
#include "MPatient.hpp"

using namespace std;

static void usage()
{
  char msg[] = "\
Usage: of_cancel -p <plaordnum> <database>";

  cerr << msg << endl;
  exit(1);
}
      
int main(int argc, char** argv)
{ 
  MString placerOrderNumber = "";

   while (--argc > 0 && (*++argv)[0] == '-') {
    switch(*(argv[0] + 1)) {
    case 'p':
      argc--; argv++;
      if (argc < 1)
	usage();
      placerOrderNumber = (*argv);
      break;
   default:
      break;
    }
  }
  if (argc < 1)
    usage();

  //work will be done in the specified database
  MDBInterface db(*argv);
  
  //we will first cancel a placer order
  MPlacerOrder order;
  MOrder o;
  MCriteriaVector cv;
  MCriteria c;
  c.attribute = "plaordnum";
  c.oper = TBL_EQUAL;
  c.value = placerOrderNumber;
  cv.push_back(c);
  db.remove(order, cv);
  db.remove(o, cv);
      
  return 0;
}
