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
#include "MHL7Msg.hpp"
#include "MHL7DomainXlate.hpp"
#include "MHL7LLPHandler.hpp"
#include "MLMessenger.hpp"
#include "MAMessenger.hpp"
#include "MPatient.hpp"
#include "MPlacerOrder.hpp"
#include "MDBOrderPlacer.hpp"

#include "ace/SOCK_Connector.h"

#define HL7SIZE 8192

using namespace std;

static void usage()
{
  char msg[] = "
Usage: [-a] [-b <base>] [-d <definition>] [-z <database>] <port> <server> <pid> <placer num> <hl
7 file>\n\
  -a    Use analysis mode\n\
  -b    Use <base> as directory with HL7 definitions\n\
  -d    Extension for HL7 defintions is <definition>\n\
  -z    Open <database> rather than default, ordplc\n\
\n\
        <port> is port number server is listening on\n\
        <server> is address of server\n\
        <pid> is external patient ID\n\
        <placer num> is the placer number\n\
        <hl7 file> contains a shell order message\n\
";

  cerr << msg << endl;
  exit(1);

}

int main(int argc, char** argv)
{ 
  int analysisMode = 0;
  MString logDir("/opt/mesa/testdata/");
  MString hl7Base("/opt/mesa/runtime/");
  MString hl7Definition(".ordplc");
  MString databaseName("ordplc");

  while (--argc > 0 && (*++argv)[0] == '-') {
    switch(*(argv[0] + 1)) {
    case 'a':
      argc--; argv++;
      if (argc < 1)
	usage();
      analysisMode =1;
      logDir = MString(*argv) + "/";
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

  if (argc < 5)
    usage();
 
  int port = atoi(argv[0]);

  ACE_INET_Addr ServerAddress(port, argv[1]);

  MHL7Factory factory(hl7Base, hl7Definition);
  MDBOrderPlacer orderPlacerDB (databaseName);
  MLMessenger* messenger = new MLMessenger (factory);
  MHL7LLPHandler handler (*messenger);
  ACE_Reactor reactor;

  if (handler.open (ServerAddress, &reactor) == -1)
  {
    handler.close();
    cerr << "(op_send) Make sure Server is up and listening on the port.\n";
    delete messenger;
    exit(-1);
  }

  MString patientID(argv[2]);
  MString placerOrderNumber(argv[3]);

  argc -=4;
  argv +=4;

  MPatient patient;
  MPlacerOrder placerOrder;

  // get patient and order info from the database
  patient.patientID(patientID);
  placerOrder.patientID(patientID);
  placerOrder.placerOrderNumber(placerOrderNumber);
  if (!orderPlacerDB.getOrder(patient, placerOrder))
  {
    cout << "Order Not Found for patient ID: " << patientID \
         << " and Order #: " << placerOrderNumber << endl;
    delete messenger;
    exit(1);
  }
/*
  if (analysisMode)
    messenger = new MAMessenger(factory, orderPlacerDB, logDir);
  else
    messenger = new MLMessenger (factory, orderPlacerDB);  */

  while (argc)
  {
    MHL7DomainXlate xlate;
    MHL7Msg*  msg = factory.readFromFile(*argv);

    // insert patient and order information into the hl7 message
    xlate.translateDomain(patient, *msg);
    xlate.translateDomain(*msg, placerOrder);

    char b[HL7SIZE];
    int l = 0;
    msg->exportToWire(b, sizeof(b), l);
    messenger->sendHL7Message(*msg);
    delete msg;
    argc -= 1;
  }

  // Will only wait for 1 ACK message
  while (messenger->notFinished())
    reactor.handle_events();

  // The call to handler.close will free up the messenger/handler's memory
  // and prevent any memory leaks.
  handler.close();

  delete messenger;
  return 0;
}
