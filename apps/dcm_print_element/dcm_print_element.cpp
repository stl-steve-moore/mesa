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

#include "MESA.hpp"
#include "ctn_api.h"
#include "MDICOMWrapper.hpp"
#include "MFileOperations.hpp"

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
dcm_print_element [-i index] [-s g1 e1] [-x] [-z g0 e0 g1 e1] g2 e2 file \n\
\n\
    -i     Tells which of the values in a sequence to take (1, 2, ..)\n\
    -s     Give the tag (g1 e1) for the top level of a sequence\n\
    -x     Print status of the attribute rather than the value\n\
    -z     Give the tags (g0 e0 g1 e1) for two levels of sequence\n\
\n\
    g2 e2  Group/element of the attribute to print\n\
    file   Name of input file\n";

    fprintf(stderr, msg);
    exit(1);
}

static MString getTagStatusSequence(MDICOMWrapper& w,
	DCM_TAG tagSeq0, DCM_TAG tagSeq, DCM_TAG tagElement)
{
  int count = w.numberOfItems(tagElement);
  if (count == 0) {
    return "2";		// Sequence present, 0 lenth sequence
  } else {
    return "3";		// Sequence present with some data
 }
}

static MString getTagStatusPlain(MDICOMWrapper& w,
	DCM_TAG tagSeq0, DCM_TAG tagSeq, DCM_TAG tagElement)
{
  MString s;

  if (tagSeq == 0) {
    s = w.getString(tagElement);
  } else if (tagSeq0 == 0) {
    s = w.getString(tagSeq, tagElement, 1);
  } else {
    s = w.getSequenceString(
		    tagSeq0, tagSeq, tagElement, 1);
  }
  if (s == "") {
    return "4";
  } else {
    return "5";
  }
}

static MString getTagStatus(MDICOMWrapper& w,
	DCM_TAG tagSeq0, DCM_TAG tagSeq, DCM_TAG tagElement)
{

  // First round of tests to see if the attribute is found
  // in the object.
  if (tagSeq == 0x00000000) {		// Looking for a plain attribute (level 0)?
    if (!w.attributePresent(tagElement)) {
      return "1";		// Attribute does not exist
    }
  } else if (tagSeq0 == 0) {		// Looking for an attribute at level 1?
    if (!w.attributePresent(tagSeq, tagElement)) {
      return "1";
    }
  } else {
    if (!w.attributePresent(tagSeq0, tagSeq, tagElement)) {	// Looking at seuquence level 2
      return "1";
    }
  }

  if (MDICOMWrapper::isSequence(tagElement)) {
    return getTagStatusSequence(w, tagSeq0, tagSeq, tagElement);
  } else {
    return getTagStatusPlain(w, tagSeq0, tagSeq, tagElement);
  }
}

int main(int argc, char **argv)
{

  CTNBOOLEAN verbose = FALSE;
  CTNBOOLEAN printStatus = FALSE;

  int seqGroup = 0;
  int seqElement = 0;
  int seqGroup0 = 0;
  int seqElement0 = 0;
  int group = 0;
  int element = 0;
  int index = 1;

  while (--argc > 0 && (*++argv)[0] == '-') {
    switch (*(argv[0] + 1)) {
    case 'i':
      if (argc < 1)
	usageerror();
      argc--; argv++;
      index = atoi(*argv);
      break;
    case 's':
      if (argc < 2)
	usageerror();
      argc--; argv++;
      sscanf(*argv, "%x", &seqGroup);
      argc--; argv++;
      sscanf(*argv, "%x", &seqElement);
      break;
    case 'v':
      verbose = TRUE;
      break;
    case 'x':
      printStatus = TRUE;
      break;
    case 'z':
      if (argc < 4)
	usageerror();
      argc--; argv++;
      sscanf(*argv, "%x", &seqGroup0);
      argc--; argv++;
      sscanf(*argv, "%x", &seqElement0);
      argc--; argv++;
      sscanf(*argv, "%x", &seqGroup);
      argc--; argv++;
      sscanf(*argv, "%x", &seqElement);
      break;
    default:
      break;
    }
  }

  if (argc < 3)
    usageerror();

  ::THR_Init();

  sscanf(*argv, "%x", &group);
  argc--; argv++;
  sscanf(*argv, "%x", &element);
  argc--; argv++;

  if (! MFileOperations::fileExists(*argv)) {
    if (printStatus) {
      printf("0\n");
      return 0;
    } else {
      printf("File does not exist: %s\n", *argv);
      return 0;
    }
  }

  MDICOMWrapper w(*argv);
  MString s;

  // If asking to print status, get the status, print and exit
  if (printStatus) {
    s = getTagStatus(w,
	DCM_MAKETAG(seqGroup0, seqElement0),
	DCM_MAKETAG(seqGroup,  seqElement),
	DCM_MAKETAG(group,     element)
    );
    cout << s << endl;

    ::THR_Shutdown();
    return 0;
  }

  if ((seqGroup == 0) && (seqElement == 0)) {
    s = w.getString(DCM_MAKETAG(group, element));
  } else if (seqGroup0 == 0) {
    s = w.getString(DCM_MAKETAG(seqGroup, seqElement),
		    DCM_MAKETAG(group, element),
		    index);
  } else {
    s = w.getSequenceString(
		    DCM_MAKETAG(seqGroup0, seqElement0),
		    DCM_MAKETAG(seqGroup, seqElement),
		    DCM_MAKETAG(group, element),
		    index);
  }

  cout << s << endl;

  ::THR_Shutdown();
  return 0;
}
