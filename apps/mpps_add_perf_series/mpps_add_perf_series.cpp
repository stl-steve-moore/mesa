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

static char rcsid[] = "$Revision: 1.3 $ $RCSfile: mpps_add_perf_series.cpp,v $";


#include "MESA.hpp"
#include "ctn_api.h"

#include "MString.hpp"
#include "MPPSAssistant.hpp"

/* usageerror
**
** Purpose:
**	Print the usage text for this program and exit
**
** Parameter Dictionary:
**	None
**
** Return Values:
**	None
**
** Algorithm:
**	Description of the algorithm (optional) and any other notes.
*/

static void
usageerror()
{
    char usage[] = "\
Usage: im_dcmps [-a] [-c <title>] [-d FAC] [-f] [-i] [-j] [-k] [-m maxPDU] [-n naming] [-p] [-s] [-t trips] [-v] [-w] [-x dir] [-z sec] port\n\
\n\
    -a    Abort Association after receiving one image (debugging tool)\n\
    -d    Place one facility (DCM, DUL, SRV) in verbose mode\n\
    -c    Set the AE title of this server\n\
    -f    Fork a new process for each connection\n\
    -i    Ignore some incorrect parameters in Association request\n\
    -j    Use thread model.  Spawn a new thread for each connection\n\
    -k    Kill (delete) files immediately after they are received\n\
    -m    Set the maximum received PDU in the Association RP to maxPDU\n\
    -n    <naming> contains naming convention for files stored\n\
    -p    Dump the Association RQ parameters\n\
    -s    Silent mode.  Don't dump attributes of received images\n\
    -t    Execute the main loop trips times (debugging tool)\n\
    -v    Place DUL and SRV facilities in verbose mode\n\
    -w    Wait flag.  Wait for 1 second in callback routines (debugging)\n\
    -x    Set base directory for image creation.  Default is current directory\n\
    -z    Wait for sec seconds before releasing association\n\
\n\
    port  The TCP/IP port number to use\n";

    (void) fprintf(stderr, usage);
    exit(1);
}

int main(int argc, char **argv)
{
  CONDITION cond;
  CTNBOOLEAN
    verboseDCM = FALSE,
    done = FALSE,
    silent = FALSE;

  while (--argc > 0 && (*++argv)[0] == '-') {
    switch (*(argv[0] + 1)) {
    case 'd':
      argc--;
      argv++;
      if (argc < 1)
	usageerror();
      if (strcmp(*argv, "DCM") == 0)
	verboseDCM = TRUE;
      else
	usageerror();
      break;
    default:
      (void) fprintf(stderr, "Unrecognized option: %c\n", *(argv[0] + 1));
      break;
    }
  }

  if (argc < 2)
    usageerror();

  ::THR_Init();

  DCM_Debug(verboseDCM);

  MPPSAssistant assistant;

  MString src(*argv);
  argc--; argv++;

  while(argc > 0) {
    MString image(*argv);
    argc--; argv++;

    assistant.addPerformedSeriesSequence(src, image);
  }
  return 0;
}
