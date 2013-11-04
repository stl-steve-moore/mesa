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

static char rcsid[] = "$Revision: 1.2 $ $RCSfile: mesa_audit_eval.cpp,v $";

#include "ctn_os.h"
#include "MESA.hpp"

#include "MFileOperations.hpp"
#include "MSyslogMessage.hpp"
#include "MSyslogFactory.hpp"

static void usage()
{
  char msg[] =
"Usage: [-l level] [-t type] file\n\
\n\
  -l      Specify level of detail in output (1-4) \n\
  -t      Specify the audit record type; use -T for list of all types\n\
  -T      List all types of audit records \n\
\n\
  file    Name of file to evaluate";

  cerr << msg << endl;
  ::exit(1);
}


int main(int argc, char **argv)
{
  MString msgType = "";
  int detailLevel = 1;

  MString tmp;

  while (--argc > 0 && (*++argv)[0] == '-') {
    switch (*(argv[0] + 1)) {
    case 'l':
      argc--; argv++;
      if (argc < 1)
	usage();
      tmp = *argv;
      detailLevel = tmp.intData();
      break;
    case 't':
      argc--; argv++;
      if (argc < 1)
	usage();
      msgType = *argv;
      break;
    case 'T':
      break;
    default:
      break;
    }
  }

  if (argc < 1)
    usage();

  cout << "File to evaluate: " << *argv << endl;
  cout << "Type: " << msgType << endl;
  cout << "Log level: " << detailLevel << endl;

  MFileOperations f;

  char* txt = f.readAllText(*argv);
  if (txt == 0) {
    cout << "Unable to read text from file: " << *argv;
    return 1;
  }

  MSyslogFactory syslogFactory;
  MSyslogMessage* m = syslogFactory.produceMessage(txt, ::strlen(txt));
  if (m == 0) {
    cout << "Could not produce syslog message from this text: " << txt << endl;
    return 1;
  }

  delete []txt;
  cout << *m << endl;

  return 0;
}
