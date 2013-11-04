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

static char rcsid[] = "$Revision: 1.9 $ $RCSfile: sr_to_hl7.cpp,v $";

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "MESA.hpp"
#include "MSRWrapper.hpp"
#include "MHL7Factory.hpp"
#include "MSRContentItem.hpp"
#include "MSRContentItemFactory.hpp"
#include "MSRContentItemContainer.hpp"
#include "MSRContentItemText.hpp"
#include "MHL7Msg.hpp"
#include "MFileOperations.hpp"

#include "ctn_api.h"
#include <iostream>
#include <fstream>


static CTNBOOLEAN verboseOutput = FALSE;

static void usageerror();

static void
setPID(MDICOMWrapper& w, MHL7Msg& m)
{
  MString s;

  m.insertSegment("PID");

  s = w.getString(0x00100020);
  s = s + "^^^ADT1";
  m.setValue("PID", 3, 0, s);

  s = w.getString(0x00100010);
  m.setValue("PID", 5, 0, s);

  m.setValue("PID", 18, 0, "PatientAcct");

}

static void
setOBR(MDICOMWrapper& w, MHL7Msg& m)
{
  MString s;

  m.insertSegment("OBR");

  // Set ID
  m.setValue("OBR", 1, 0, "1");

  // Placer Order Number
  s = w.getString(0x0040a370, 0x00402016);
  m.setValue("OBR", 2, 0, s);

  // Filler Order Number
  s = w.getString(0x0040a370, 0x00402017);
  m.setValue("OBR", 3, 0, s);

  if (w.attributePresent(0x0040a032)) {
    s = w.getString(0x0040a032);
  } else {
    s = w.getString(0x00080023);
    s = s + w.getString(0x00080033);
  }
  m.setValue("OBR", 7, 0, s);

  m.setValue("OBR", 25, 0, "F");
}

static void
setOBXIdentification(MDICOMWrapper& w, MHL7Msg& m, int& setID)
{
  MString s;

  m.insertSegment("OBX");

  char txt[10];
  ::sprintf(txt, "%-d", setID++);

  m.setValue("OBX", 1, 0, txt);
  m.setValue("OBX", 2, 0, "HD");
  m.setValue("OBX", 3, 0, "^SR Instance UID");

  s = w.getString(0x00080018);
  m.setValue("OBX", 5, 0, s);

  m.setValue("OBX", 11, 0, "F");
}

static void
setOBXImageReference(MSRWrapper& w, MSRContentItem& item,
		     MHL7Msg& m, int& setID, int& subID)
{
  MString s;

  char setIDText[10];
  char subIDText[10];
  ::sprintf(setIDText, "%-d", setID++);
  ::sprintf(subIDText, "%-d", subID++);

  // First OBX is for the Study Instance UID
  m.insertSegment("OBX");
  m.setValue(1, 0, setIDText);
  m.setValue(2, 0, "HD");
  m.setValue(3, 0, "^Study Instance UID");
  m.setValue(4, 0, subIDText);

  s = w.getString(0x0040A370, 0x0020000D);
  m.setValue(5, 0, s);

  m.setValue(11, 0, "F");

  // Second OBX is for the SR Series UID
  m.insertSegment("OBX");
  ::sprintf(setIDText, "%-d", setID++);
  m.setValue(1, 0, setIDText);
  m.setValue(2, 0, "HD");
  m.setValue(3, 0, "^Series Instance UID");
  m.setValue(4, 0, subIDText);

  s = w.getString(0x0020000E);
  m.setValue(5, 0, s);
  m.setValue(11, 0, "F");


  MDICOMWrapper* seqWrapper = w.getSequenceWrapper(0x0040A370, 1);

  // Third OBX is for the Ref Study Seq: SOP Instance
  m.insertSegment("OBX");
  ::sprintf(setIDText, "%-d", setID++);
  m.setValue(1, 0, setIDText);
  m.setValue(2, 0, "HD");
  m.setValue(3, 0, "^SOP Instance UID");
  m.setValue(4, 0, subIDText);

  s = "";
  if (seqWrapper != 0)
    s = seqWrapper->getString(0x00081110, 0x00081155);
  m.setValue(5, 0, s);
  m.setValue(11, 0, "F");

  // Fourth OBX is fo rhte Ref Study Seq: SOP Class
  m.insertSegment("OBX");
  ::sprintf(setIDText, "%-d", setID++);
  m.setValue(1, 0, setIDText);
  m.setValue(2, 0, "HD");
  m.setValue(3, 0, "^SOP Class UID");
  m.setValue(4, 0, subIDText);

  s = "";
  if (seqWrapper != 0)
    s = seqWrapper->getString(0x00081110, 0x00081150);
  m.setValue(5, 0, s);
  m.setValue(11, 0, "F");

  delete seqWrapper;
}

static void
setOBXImageReferences(MSRWrapper& w, MSRContentItemVector& v,
		      MHL7Msg& m, int& setID, int& subID)
{
  MSRContentItemVector::iterator it = v.begin();
  for (; it != v.end(); it++) {
    MString relationshipType = (*it).relationshipType();
    MString valueType = (*it).valueType();
    cout << relationshipType << " " << valueType << endl;
    if (relationshipType == "CONTAINS" && valueType == "CONTAINER") {
      MSRContentItemVector& containerV = (*it).contentItemVector();
      setOBXImageReferences(w, containerV, m, setID, subID);
    } else if (relationshipType == "CONTAINS" && valueType == "IMAGE") {
      setOBXImageReference(w, *it, m, setID, subID);
    }
  }
}

static void
setOBXImageReferences(MSRWrapper& w, MHL7Msg& m, int& setID, int& subID)
{
  MSRContentItemVector& v = w.contentItemVector();
  MSRContentItemVector::iterator it = v.begin();

  for (; it != v.end(); it++) {
    MString relationshipType = (*it).relationshipType();
    MString valueType = (*it).valueType();
    cout << relationshipType << " " << valueType << endl;
    if (relationshipType == "CONTAINS" && valueType == "CONTAINER") {
      MSRContentItemVector& containerV = (*it).contentItemVector();
      setOBXImageReferences(w, containerV, m, setID, subID);
    }
  }
}

static void
setOBXImageReference(MHL7Msg& m, int& setID, int& subID,
	const MString& studyInstanceUID,
	const MString& seriesInstanceUID,
	const MString& sopInstanceUID,
	const MString& sopClassUID)
{
  char setIDText[10];
  char subIDText[10];
  ::sprintf(setIDText, "%-d", setID++);
  ::sprintf(subIDText, "%-d", subID++);

  // First OBX is for the Study Instance UID
  m.insertSegment("OBX");
  m.setValue(1, 0, setIDText);
  m.setValue(2, 0, "HD");
  m.setValue(3, 0, "^Study Instance UID");
  m.setValue(4, 0, subIDText);

  m.setValue(5, 0, studyInstanceUID);

  m.setValue(11, 0, "F");

  // Second OBX is for the Series UID
  m.insertSegment("OBX");
  ::sprintf(setIDText, "%-d", setID++);
  m.setValue(1, 0, setIDText);
  m.setValue(2, 0, "HD");
  m.setValue(3, 0, "^Series Instance UID");
  m.setValue(4, 0, subIDText);

  m.setValue(5, 0, seriesInstanceUID);
  m.setValue(11, 0, "F");

  // Third OBX is for the SOP Instance UID
  m.insertSegment("OBX");
  ::sprintf(setIDText, "%-d", setID++);
  m.setValue(1, 0, setIDText);
  m.setValue(2, 0, "HD");
  m.setValue(3, 0, "^SOP Instance UID");
  m.setValue(4, 0, subIDText);

  m.setValue(5, 0, sopInstanceUID);
  m.setValue(11, 0, "F");

  // Fourth OBX is SOP Class UID
  m.insertSegment("OBX");
  ::sprintf(setIDText, "%-d", setID++);
  m.setValue(1, 0, setIDText);
  m.setValue(2, 0, "HD");
  m.setValue(3, 0, "^SOP Class UID");
  m.setValue(4, 0, subIDText);

  m.setValue(5, 0, sopClassUID);
  m.setValue(11, 0, "F");
}


static void
setOBXImageReferencesReqProcedureEvidence(
	MSRWrapper& w, MHL7Msg& m, int& setID, int& subID)
{
  MString studyInstanceUID;
  MString seriesInstanceUID;
  MString instanceUID;
  MString classUID;

  int studyIDX = 1;
  int seriesIDX = 1;
  int instanceIDX = 1;

  studyInstanceUID = w.getString(0x0040A375, 0x0020000D, studyIDX);
  cout << "Study Instance UID: " << studyInstanceUID << endl;

  while (studyInstanceUID != "") {
    cout << studyIDX << " Study Instance UID: " << studyInstanceUID << endl;
    MDICOMWrapper* studyWrapper = w.getSequenceWrapper(0x0040A375, studyIDX);
    if (studyWrapper == 0)
      break;

    seriesIDX = 1;
    seriesInstanceUID = studyWrapper->getString(0x00081115, 0x0020000E, seriesIDX);
    while (seriesInstanceUID != "") {
      cout << seriesIDX << " Series Instance UID: " << seriesInstanceUID << endl;
      MDICOMWrapper* seriesWrapper =
	studyWrapper->getSequenceWrapper(0x00081115, seriesIDX);
      if (seriesWrapper == 0)
	break;

      instanceIDX = 1;
      classUID = seriesWrapper->getString(0x00081199, 0x00081150, instanceIDX);
      instanceUID = seriesWrapper->getString(0x00081199, 0x00081155, instanceIDX);
      while (instanceUID != "") {
	cout << instanceIDX << " SOP Instance UID: " << instanceUID << endl;
	setOBXImageReference(m, setID, subID,
		studyInstanceUID, seriesInstanceUID, instanceUID, classUID);
	instanceIDX++;
	instanceUID = seriesWrapper->getString(0x00081199, 0x00081155, instanceIDX);
      }

      delete seriesWrapper;
      seriesIDX++;
      seriesInstanceUID = studyWrapper->getString(0x00081115, 0x0020000E, seriesIDX);
    }



    delete studyWrapper;
    studyIDX++;
    studyInstanceUID = w.getString(0x0040A375, 0x0020000D, studyIDX);
  }
#if 0
  for (; it != v.end(); it++) {
    MString relationshipType = (*it).relationshipType();
    MString valueType = (*it).valueType();
    cout << relationshipType << " " << valueType << endl;
    if (relationshipType == "CONTAINS" && valueType == "CONTAINER") {
      MSRContentItemVector& containerV = (*it).contentItemVector();
      setOBXImageReferences(w, containerV, m, setID, subID);
    }
  }
#endif
}

static MString
extractText(MSRContentItemText& item)
{
  MString s = item.text();
  return s;
}

static MString
extractText(MSRContentItemContainer& item)
{
  MString s;
  MSRContentItemFactory f;

  s = item.conceptNameMeaning();
  MSRContentItemVector& v = item.contentItemVector();
  MSRContentItemVector::iterator i = v.begin();
  for (; i != v.end(); i++) {
    MString vt = (*i).valueType();
    if (vt == "TEXT") {
      MSRContentItemText* contentText =
	      (MSRContentItemText*)f.produceContentItem(*i);
      s = s + " ";
      s = s + extractText(*contentText);
      delete contentText;
    }
  }
  return s;
}

static MString
extractText(MSRContentItem& item)
{
  MSRContentItemFactory f;

  MSRContentItem* i = f.produceContentItem(item);
  if (i == 0)
    return "";

  MString rt = i->relationshipType();
  MString vt = i->valueType();

  MString s;

  if (rt == "CONTAINS" && vt == "CONTAINER") {
    s = extractText(* (MSRContentItemContainer*)i);
  }

  delete i;
  return s;

}

static void
setOBXText(MHL7Msg& m, int& setID, const MString& reportText)
{
  m.insertSegment("OBX");
  char txt[10];
  ::sprintf(txt, "%-d", setID++);

  m.setValue(1, 0, txt);
  m.setValue(2, 0, "TX");
  m.setValue(3, 0, "^SR Text");

  m.setValue(5, 0, reportText);
  m.setValue(11, 0, "F");
}

static void
setOBXReportText(MSRWrapper& w, MHL7Msg& m, int& setID)
{
#if 0
  MString reportHeading;

  m.insertSegment("OBX");
  char txt[10];
  ::sprintf(txt, "%-d", setID++);

  m.setValue(1, 0, txt);
  m.setValue(2, 0, "TX");
  m.setValue(3, 0, "^SR Text");

  reportHeading = w.getString(0x0040a043, 0x00080104);
#endif

  MSRContentItemVector& v = w.contentItemVector();
  MSRContentItemVector::iterator i = v.begin();
  for (; i != v.end(); i++) {
    MString rt = (*i).relationshipType();
    MString vt = (*i).valueType();
    if (rt == "CONTAINS" && vt == "CONTAINER") {
      MString tmp = extractText(*i);
      setOBXText(m, setID, tmp);
      //s = s + "\n";
      //s = s + tmp;
    }
  }

#if 0
  m.setValue(5, 0, s);
  m.setValue(11, 0, "F");
#endif
}


int main(int argc, char **argv)
{
  unsigned long options = DCM_ORDERLITTLEENDIAN;
  bool verbose = false;
  MString templateFile;
  MFileOperations f;
  char path[256];

  f.expandPath(path, "MESA_TARGET", "runtime");
  strcat(path, "/");
  MString hl7Base(path);

  MString hl7Definition(".ihe");

  while (--argc > 0 && (*++argv)[0] == '-') {
    switch (*(argv[0] + 1)) {
    case 'b':
      argc--; argv++;
      if (argc < 1)
	usageerror();
      hl7Base = MString(*argv) + "/";;
      break;
    case 'd':
      argc--; argv++;
      if (argc < 1)
	usageerror();
      hl7Definition = MString(".") + *argv;
      break;
    case 't':
      argc--;
      argv++;
      if (argc < 1)
	usageerror();
      templateFile = *argv;
      break;
    case 'v':
      verbose = TRUE;
      break;
    default:
      break;
    }
  }

  ::THR_Init();
  if (argc != 2)
    usageerror();

  if (templateFile == "")
    usageerror();

  MSRWrapper w(*argv);
  w.expandSRTree();

  MHL7Factory factory(hl7Base, hl7Definition);
  MHL7Msg* m = factory.produceOnlyMSH(templateFile, "ORU^R01");

  setPID(w, *m);
  setOBR(w, *m);

  int setID = 1;
  int subID = 1;
  setOBXIdentification(w, *m, setID);
  //setOBXImageReferences(w, *m, setID, subID);
  setOBXImageReferencesReqProcedureEvidence(w, *m, setID, subID);
  setOBXReportText(w, *m, setID);

  int status = m->saveAs(argv[1]);

  delete m;

  if (status != 0)
    return 1;

  return 0;
}

/* usageerror
**
** Purpose:
**	Print the usage string for this application and exit.
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
Usage: sr_to_hl7 [-b base] [-d definition] [-t template] [-v] file1 file2 \n\
\n\
    -b   Set base directory for HL7 parsing rules; default is $MESA_TARGET/runtime\n\
    -d   Set suffix for HL7 parsing rules; default is ihe\n\
    -t   Set template file for MSH; required argument\n\
    -v   Verbose mode\n\
\n\
    file1   Input SR document \n\
    file2   Output HL7 message";

    cerr << msg << endl;
    ::exit(1);
}


