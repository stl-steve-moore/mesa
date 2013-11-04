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
#include "MHL7Acceptor.hpp"
#include "MHL7Factory.hpp"
#include "MHL7DomainXlate.hpp"
#include "MDBOrderPlacer.hpp"
#include "MPatient.hpp"
#include "MPlacerOrder.hpp"

using namespace std;

static void usage()
{
  char msg[] = "
Usage: [-a] [-b <base>] [-d <definition>] [-z <database>] <pid> <placer num> <hl7 file>\n\
  -a    Use analysis mode\n\
  -b    Use <base> as directory with HL7 definitions\n\
  -d    Extension for HL7 defintions is <definition>\n\
  -z    Open <database> rather than default, ordplc\n\
\n\
        <pid> is external patient ID\n\
        <placer num> is the placer number\n\
        <hl7 file> contains details of the order\n\
";

  cerr << msg << endl;
  exit(1);

}

int main(int argc, char** argv)
{ 
  int analysisMode = 0;
  MString hl7Base("/opt/mesa/runtime/");
  MString hl7Definition(".ordplc");
  MString databaseName("ordplc");

  while (--argc > 0 && (*++argv)[0] == '-') {
    switch(*(argv[0] + 1)) {
    case 'a':
      analysisMode = 1;
      break;
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
    case 'z':
      argc--; argv++;
      if (argc < 1)
	usage();
      databaseName = *argv;
      break;
    default:
      break;
    }
  }
  if (argc < 3)
    usage();

  MHL7Factory factory(hl7Base, hl7Definition);
  MHL7DomainXlate xlate;
  MDBOrderPlacer orderPlacerDB (databaseName);

  MString patientID(argv[0]);
  MString placerOrderNumber(argv[1]);
  MString hl7FileName(argv[2]);

  MHL7Msg* msg  = factory.readFromFile(hl7FileName);
 
  MPatient patient;
  MPlacerOrder placerOrder;

  //orderPlacerDB.select(p, "patid", patientID);
  // make sure patient exists

  xlate.translateHL7(*msg, patient);
  xlate.translateHL7(*msg, placerOrder);

  // insert patient ID from the command line into the patient domain object
  patient.patientID(patientID);
  // insert Placer Order # from the command line into the placerOrder object
  placerOrder.placerOrderNumber(placerOrderNumber);
  // change patient id in placerOrder domain object
  placerOrder.patientID(patientID);
  // insert order along with patient information into the database
  orderPlacerDB.enterOrder(placerOrder);

  return 0;
}
