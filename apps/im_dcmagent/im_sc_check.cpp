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

static char rcsid[] = "$Revision: 1.5 $ $RCSfile: im_sc_check.cpp,v $";
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
Usage: im_sc_check [-v] flag\n\
\n\
    -v       Turn on verbose mode\n\
\n\
    flag     0  Are all commited images in the DB?\n\
             1  Are all images in the DB committed?\n";

    (void) fprintf(stderr, usage);
    exit(1);
}

// Are all committed images in the Image DB?

static int test0(int verbose)
{
  int rtnValue = 0;
  MDBImageManager imageManager("imgmgr");
  MStorageCommitItemVector itemVector;
  MStorageCommitItem item;

  imageManager.selectStorageCommitItem(item, itemVector);

  MStorageCommitItemVector::iterator it;
  for (it = itemVector.begin();
       it != itemVector.end();
       it++) {
    if (verbose > 1)
      cout << *it << endl;

    MSOPInstance i1;
    MSOPInstance i2;

    i1.instanceUID((*it).sopInstance());

    int count = imageManager.selectSOPInstance(i1, i2);
    if (count != 1) {
      if (verbose) {
	cout << *it << endl;
	cout << "Count for this SOP Instance is " << count << endl;
      }
      rtnValue = 1;
    }
  }
  return rtnValue;    
}

// Are all images in the Image DB committed?

static int test1(int verbose)
{
  int rtnValue = 0;
  MDBImageManager imageManager("imgmgr");
  MSOPInstanceVector instanceVector;
  MSOPInstance sopInstance;
  imageManager.selectSOPInstance(instanceVector);

  MSOPInstanceVector::iterator iSOP;
  for (iSOP = instanceVector.begin();
       iSOP != instanceVector.end();
       iSOP++) {
    if (verbose > 1)
      cout << *iSOP << endl;

    MStorageCommitItem item1;
    MStorageCommitItem item2;

    item1.sopInstance((*iSOP).instanceUID());
    int count = imageManager.selectStorageCommitItem(item1, item2);
    if (count == 0) {
      if (verbose) {
	cout << *iSOP << endl;
	cout << "Count for this SOP Instance is " << count << endl;
      }
      rtnValue = 1;
    }
  }

  return rtnValue;
}

int main(int argc, char **argv)
{
  int verbose = 0;

  while (--argc > 0 && (*++argv)[0] == '-') {
    switch (*(argv[0] + 1)) {
    case 'a':
    case 'c':
      break;
    case 'v':
      argc--; argv++;
      if (argc < 1)
	usageerror();
      verbose = atoi(*argv);
      break;
    default:
      (void) fprintf(stderr, "Unrecognized option: %c\n", *(argv[0] + 1));
      break;
    }
  }

  if (argc < 1)
    usageerror();

  ::THR_Init();

  int testCode = atoi(*argv);
  int rtnValue = 0;

  if (testCode == 0)
    rtnValue = test0(verbose);
  else
    rtnValue = test1(verbose);

  return rtnValue;
}
