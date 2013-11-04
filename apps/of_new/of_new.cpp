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
#include "MFillerOrder.hpp"
#include "MSchedule.hpp"
#include "MActionItem.hpp"
#include "MIdentifier.hpp"
#include "MMWL.hpp"
#include "MHL7DomainXlate.hpp"
#include "MHL7Factory.hpp"
#include "MHL7Msg.hpp"

using namespace std;

static void usage()
{
  char msg[] = "\
Usage: of_new -d <definitions> -b <base> -n <hl7 file> <database>";

  cerr << msg << endl;
  exit(1);
}
	      
int main(int argc, char** argv)
{ 
  MString hl7Base("/opt/mesa/runtime"); MString hl7Definition("ihe");
  MString message = "";

   while (--argc > 0 && (*++argv)[0] == '-') {
    switch(*(argv[0] + 1)) {
   case 'n':
      argc--; argv++;
      if (argc < 1)
	usage();
      message = (*argv);
      break;
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
   default:
      break;
    }
  }
  if (argc < 1)
    usage();

  //retirieve our hl7 message
  MHL7Factory factory(hl7Base, hl7Definition);
  MHL7Msg*  msg = factory.readFromFile(message);

  //work will be done in the specified database
  MDBInterface db(*argv);

  MPlacerOrder placerOrder;
  MHL7DomainXlate xLate;
  xLate.translateHL7((*msg), placerOrder);

  placerOrder.mesaStatus("REQUESTED");
  db.insert(placerOrder);
  for(int inx = 0; inx < placerOrder.numOrders(); inx++){
    (placerOrder.order(inx)).mesaStatus("REQUESTED");
    db.insert(placerOrder.order(inx));
  }
      
  return 0;
}
