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

static char rcsid[] = "$Revision: 1.6 $ $RCSfile: evaluate_storage_commitment.cpp,v $";

#include "MESA.hpp"
#include "ctn_api.h"
#include "MDICOMWrapper.hpp"
#include <map>

/* usageerror
**
** Purpose:
**	Print the usage message for this program and exit.
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
  char msg[] = "\
evaluate_storage_commitment [-v] master.dcm test.dcm \n\
\n\
    -v             Verbose mode\n\
\n\
    master.dcm     The master (known good) file\n\
    test.dcm       File to be tested\n";

  cerr << msg << endl;
  ::exit(1);
}

typedef map < MString, MString, less < MString > > STRINGMAP;

static int compareSequence(MDICOMWrapper& wMaster,
			   MDICOMWrapper& wTest,
			   DCM_TAG tag,
			   int verbose)
{
  int index = 1;
  MString s1;
  MString s2;

  STRINGMAP m1;
  STRINGMAP m2;

  if (verbose)
    cout << "Master" << endl;

  index = 1;
  while((s1 = wMaster.getString(tag, DCM_IDREFERENCEDSOPCLASSUID, index)) != "") {

    s2 = wMaster.getString(tag, DCM_IDREFERENCEDSOPINSTUID, index);

    m1[s2] = s1;

    if (verbose) {
      cout << s1 << " :  " << s2 << endl;
    }

    index ++;
  }

  if (verbose)
    cout << "Test" << endl;

  index = 1;
  while((s1 = wTest.getString(tag, DCM_IDREFERENCEDSOPCLASSUID, index)) != "") {
    s2 = wTest.getString(tag, DCM_IDREFERENCEDSOPINSTUID, index);

    m2[s2] = s1;

    if (verbose) {
      cout << s1 << " :  " << s2 << endl;
    }

    index ++;
  }
  if (verbose)
    cout << endl;

  if (m1.size() != m2.size()) {
    cout << "Sequence lengths do not match: "
	 << m1.size() << " "
	 << m2.size() << endl;

    return 1;
  }

  // Assume a success
  int rtnValue = 0;

  for (STRINGMAP::iterator i1 = m1.begin();
       i1 != m1.end();
       i1++) {
    s1 = (*i1).second;          // SOP Class UID
    s2 = m2[(*i1).first];        // Look for same SOP Instance UID

    if (verbose) {
      cout << (*i1).first << " " << s1 << endl;
    }

    if (s2 == "") {
      cout << "No matching object for master: " << (*i1).first << endl;
      cout << " " << (*i1).second << endl;

      rtnValue = 1;
    } else if (s1 != s2) {
      cout << "SOP Class mismatch for object" << endl;
      cout << " " << (*i1).first << " " << (*i1).second << endl;
      cout << " " << s2 << endl;

      rtnValue = 2;
    }
  }

  return rtnValue;
}


static int testTransactionUID(MDICOMWrapper& wMaster,
			      MDICOMWrapper& wTest,
			      int verbose)
{
  MString uidMaster = wMaster.getString(DCM_IDTRANSACTIONUID);
  MString uidTest = wTest.getString(DCM_IDTRANSACTIONUID);

  if (uidMaster != uidTest) {
    cout << "Transaction UIDs do not match" << endl;
    cout << uidMaster << endl;
    cout << uidTest << endl;

    return 1;
  }

  return 0;
}

static int testCommittedImages(MDICOMWrapper& wMaster,
			       MDICOMWrapper& wTest,
			       int verbose)
{
  int result = 0;

  if (verbose)
    cout << "Testing images that should be committed" << endl;

  result = compareSequence(wMaster, wTest, DCM_IDREFERENCEDSOPSEQUENCE,
			   verbose);

  if (result != 0) {
    cout << "Failed on committed images" << endl;
    return 2;
  }
  return 0;
}

static int testErrorImages(MDICOMWrapper& wMaster,
			   MDICOMWrapper& wTest,
			   int verbose)
{
  int result = 0;

  if (verbose)
    cout << "Testing images that should have failed" << endl;

  result = compareSequence(wMaster, wTest, DCM_IDFAILEDSOPSEQUENCE,
			   verbose);

  if (result != 0) {
    cout << "Failed on error images" << endl;
    return 3;
  }

  return 0;
}


int main(int argc, char **argv)
{
  CTNBOOLEAN verbose = FALSE;

  while (--argc > 0 && (*++argv)[0] == '-') {
    switch (*(argv[0] + 1)) {
    case 'v':
      verbose = TRUE;
      break;
    default:
      break;
    }
  }

  if (argc < 2)
    usageerror();

  ::THR_Init();

  MDICOMWrapper wMaster(*argv++);
  MDICOMWrapper wTest(*argv);

  int result = 0;

  result = testTransactionUID(wMaster, wTest, verbose);
  if (result != 0)
    return result;

  result = testCommittedImages(wMaster, wTest, verbose);
  if (result != 0)
    return result;

  result = testErrorImages(wMaster, wTest, verbose);
  if (result != 0)
    return result;

  ::THR_Shutdown();
  return 0;
}
