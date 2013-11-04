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
#include "MDICOMDomainXlate.hpp"
#include "MDICOMFileMeta.hpp"
#include "MDICOMDir.hpp"
#include "MPatient.hpp"

static void
usageerror()
{
    char msg[] = "\
mesa_dump_dicomdir [-v] file \n\
\n\
    -v     Verbose mode \n\
\n\
    file   Name of input file";

  cout << msg << endl;
  ::exit(1);
}

static void
dumpFileMeta(const MDICOMFileMeta& f)
{
  ///MString s;
  //s = f.mediaStorageSOPClassUID();
  //cout << "s:" << s << endl;

  cout	<< "Media Storage SOP Class:     "
	<< f.mediaStorageSOPClassUID() << endl
	<< "Media Storage SOP Inst UID:  "
	<< f.mediaStorageSOPInstanceUID() << endl
	<< "Transfer Syntax UID:         "
	<< f.transferSyntaxUID() << endl
	<< "Impl Class UID:              "
	<< f.implementationClassUID() << endl
	<< "Impl Version Name:           "
	<< f.implementationVersionName() << endl
	<< "Source AE Title:             "
	<< f.sourceApplicationEntityTitle() << endl
	<< "Private Info Crt UID:        "
	<< f.privateInformationCreatorUID() << endl

	<< endl;
}

static void
dumpFileSet(MDICOMWrapper& w)
{
  cout	<< "File Set ID:                 "
	<< w.getString(0x00041130) << endl
	<< "File Set Descriptor File ID: "
	<< w.getString(0x00041141) << endl
	<< "Spec char set/Descrip File:  "
	<< w.getString(0x00041142) << endl

	<< endl;
}

static void
dumpDICOMDir(const MDICOMDir& dir)
{
  int patientCount = dir.patientCount();
  int idx = 0;
  for (idx = 0; idx < patientCount; idx++) {
    MPatient p = dir.getPatient(idx);
    cout << idx << endl;
    cout << " " << p << endl;
    if (idx != (patientCount-1))
      cout << endl;
  }

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

  if (argc < 1)
    usageerror();

  MDICOMWrapper w(*argv);

  MDICOMDomainXlate xlate;

  MDICOMFileMeta fileMeta;
  xlate.translateDICOM(w, fileMeta);
  dumpFileMeta(fileMeta);

  dumpFileSet(w);

  MDICOMDir dir;
  xlate.translateDICOM(w, dir);
  dumpDICOMDir(dir);

  return 0;
}

