//
//        Copyright (C) 1999 - 2001, HIMSS, RSNA and Washington University
//
//        The MESA test tools software and supporting documentation were
//        developed for the Integrating the Healthcare Enterprise (IHE)
//        initiative (1999-2001), under the sponsorship of the
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

static char rcsid[] = "$Revision: 1.1 $ $RCSfile: main.cpp,v $";

#include "MESA.hpp"

static void
usageerror()
{
  char msg[] = "\
usage [-a] [-b xxx] [-c] arg \n\
\n\
  -a   Enable feature a \n\
  -b   Set value XXX to xxx \n\
  -c   xxx \n\
\n\
  arg  Name of xyz ";

  cout << msg << endl;
  ::exit(1);
}

int main(int argc, char **argv)
{

  while (--argc > 0 && (*++argv)[0] == '-') {
    switch (*(argv[0] + 1)) {
    case 'a':
      break;
    case 'b':
      argc--;
      argv++;
      if (argc <= 0)
	usageerror();
      break;
    case 'c':
      break;
    default:
      break;
    }
  }

  if (argc < 1)
    usageerror();

  return 0;
}
