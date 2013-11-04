//
//        Copyright (C) 2002, HIMSS, RSNA and Washington University
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

// File: ihe_audit_message.cpp

#include "ctn_os.h"

#include <fstream>

#include "MESA.hpp"

#include "MAuditMessage.hpp"
#include "MAuditMessageFactory.hpp"

using namespace std;

static void usage()
{
  char msg[] = "\
Usage: [-t type] [-T] input output \n\
\n\
  -t      Specify message type. Use -T to list all types \n\
  -T      List all audit message types and exit \n\
\n\
  input   Input ASCII file describes message \n\
  output  Output XML file";

  cerr << msg << endl;
  ::exit(1);
}

static void listAuditMessages()
{
  char* msgs[] = {"STARTUP", "CONFIGURATION", "PATIENT_RECORD", "PROCEDURE_RECORD", "MWL_PROVIDED",
	"BEGIN_STORING_INSTANCES", "INSTANCES_SENT", "INSTANCES_USED", "NODE_AUTHENTICATION_FAILURE",
	"USER_AUTHENTICATED", "DICOM_QUERY", "INSTANCES_STORED",
	"ATNA_STARTUP", "ATNA_CONFIGURATION", "ATNA_USER_AUTHENTICATED", "ATNA_PATIENT_RECORD",

  0};

  cout << "List of supported Audit Messages:" << endl;
  int idx = 0;
  while (msgs[idx] != 0) {
    cout << " " << msgs[idx++] << endl;
  }
}


int main(int argc, char** argv)
{ 
  MString msgType = "";
 
  while (--argc > 0 && (*++argv)[0] == '-') {
    switch(*(argv[0] + 1)) {
 
    case 't':
      if (argc < 1)
	usage();

      argc--; argv++;
      msgType = *argv;
      break;
    case 'T':
      listAuditMessages();
      usage();
      break;

    default:
      break;
    }
  }
  if (argc < 2)
    usage();

  char* inputFile = argv[0];
  char* outputFile = argv[1];

  MAuditMessageFactory f;

  MAuditMessage* m = f.produceMessage(msgType, inputFile);
  if (m == 0) {
    cerr << "Unable to produce audit message of type: " << msgType << endl
	 << " from file: " << inputFile << endl;
    return 1;
  }

  ofstream o(outputFile);
  MString xml = m->message();
  o << xml << endl;

  delete m;

  return 0;
}
