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

static char rcsid[] = "$Revision: 1.3 $ $RCSfile: mod_newuids.cpp,v $";


#include "MESA.hpp"
#include "MDICOMWrapper.hpp"
#include "ctn_api.h"
#include "MDBModality.hpp"
#include "MFileOperations.hpp"

#include <vector>
#include <set>

typedef vector < MString > MStringVector;
typedef set < MString > MStringSet;
typedef map < MString, MString, less<MString> > MStringMap;

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
Usage: mod_newuids file1 [file2...]\n";

  cerr << usage;
  ::exit(1);
}

static void findExistingSeries(MStringVector& v,
			       MStringSet& s)
{
  for (MStringVector::iterator vi = v.begin();
       vi != v.end();
       vi++) {
    MDICOMWrapper w(*vi);

    MString series = w.getString(DCM_RELSERIESINSTANCEUID);
    s.insert(series);
  }
}

static void applyNewUIDs(MStringVector& v, MStringMap& seriesMap)
{
  for (MStringVector::iterator vi = v.begin();
       vi != v.end();
       vi++) {
    MDICOMWrapper w(*vi);
    MString seriesUID = w.getString(DCM_RELSERIESINSTANCEUID);
    MString newSeriesUID = seriesMap[seriesUID];
    w.setString(DCM_RELSERIESINSTANCEUID, newSeriesUID);

    w.saveAs(*vi + "xxx");
    MFileOperations op;
    op.rename(*vi + "xxx", *vi);
  }
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

  if (argc < 1)
    usageerror();

  ::THR_Init();

  DCM_Debug(verboseDCM);

  MStringVector v;

  while(argc > 0) {
    MString f(*argv);
    v.push_back(f);
    argc--; argv++;
  }

  MStringSet s;
  findExistingSeries(v, s);
  MStringMap seriesMap;
  MDBModality modalityDB("mod1");

  for (MStringSet::iterator s1 = s.begin();
       s1 != s.end();
       s1++) {
    MString seriesUID = modalityDB.newSeriesInstanceUID();
    seriesMap[*s1] = seriesUID;
    cout << *s1 <<  " " << seriesUID << endl;
  }

  applyNewUIDs(v, seriesMap);

  return 0;
}
