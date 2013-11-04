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

static char rcsid[] = "$Revision: 1.5 $ $RCSfile: im_sc_filldb.cpp,v $";
/*#include <unistd.h>
*/

#include "MESA.hpp"
#include "ctn_api.h"

#include "MString.hpp"
#include "MDICOMWrapper.hpp"
#include "MDBImageManager.hpp"
#include "MStorageCommitItem.hpp"
#include "MStorageCommitRequest.hpp"
#include "MStorageCommitResponse.hpp"
#include "MDICOMDomainXlate.hpp"
#include "MDICOMReactor.hpp"
#include "MSOPHandler.hpp"
#include "MDICOMApp.hpp"

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
Usage: im_sc_filldb file.in\n\
\n\
    file.in  Input file with commitment N-Action Request\n";

    (void) fprintf(stderr, usage);
    exit(1);
}

static void
myExit(DUL_ASSOCIATIONKEY ** association)
{
  ::fprintf(stderr, "Abnormal exit\n");
  ::COND_DumpConditions();

  if (association != NULL)
    if (*association != NULL)
      (void) ::DUL_DropAssociation(association);
  ::THR_Shutdown();
  ::exit(1);
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
    case 'a':
      break;
    case 'c':
      break;
    default:
      (void) fprintf(stderr, "Unrecognized option: %c\n", *(argv[0] + 1));
      break;
    }
  }

  if (argc < 1)
    usageerror();

  ::THR_Init();

  MDICOMWrapper w(*argv);

  MDICOMDomainXlate xlate;

  MStorageCommitRequest scRequest;

  xlate.translateDICOM(w, scRequest);

  MDBImageManager imageManager("imgmgr");

  cout << scRequest.transactionUID() << endl;
  cout << scRequest.retrieveAETitle() << endl;

  int count = scRequest.itemCount();
  int i = 1;

  MStorageCommitResponse scResponse;
  MString s;
  s = scRequest.transactionUID();
  scResponse.transactionUID(s);
  s = scRequest.retrieveAETitle();
  scResponse.retrieveAETitle(s);

  for (i = 0; i < count; i++) {
    MStorageCommitItem item = scRequest.item(i);
    //cout << " " << item << endl;

    imageManager.enterStorageCommitmentItem(item);

    if (item.status() == "0")
      scResponse.addSuccessItem(item);
    else
      scResponse.addFailureItem(item);
  }

  int status = 0;

  return status;
}
