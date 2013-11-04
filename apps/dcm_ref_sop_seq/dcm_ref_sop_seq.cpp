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

static char rcsid[] = "$Revision: 1.4 $ $RCSfile: dcm_ref_sop_seq.cpp,v $";

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#ifdef _MSC_VER
#include <io.h>
#include <winsock.h>
#else
#include <unistd.h>
#include <sys/file.h>
#endif
#include <sys/types.h>
#include <sys/stat.h>

#include "MESA.hpp"
#include "ctn_api.h"
#include "MDICOMWrapper.hpp"

static DCM_OBJECT *
openFile(const char *fileName)
{
  DCM_OBJECT *obj;
  CONDITION cond;

  if (fileName != NULL) {
    cond = DCM_OpenFile(fileName, DCM_ORDERLITTLEENDIAN, &obj);
    if (cond != DCM_NORMAL) {
      COND_DumpConditions();
      exit(1);
    }
    return obj;
  }
  return 0;
}

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
dcm_ref_sop_seq [-f ofile] file [file...]\n\
\n\
    f     Set outpufile file\n\
\n\
    file  One or more input files\n";

    fprintf(stderr, msg);
    exit(1);
}

static void
addRefSequence(DCM_OBJECT** obj)
{
  DCM_ELEMENT e = { DCM_IDREFERENCEDSOPSEQUENCE, DCM_SQ, "", 1, 0, 0 };

  LST_HEAD* l;

  l = ::LST_Create();

  e.d.sq = l;
  ::DCM_AddSequenceElement(obj, &e);
}

static DCM_SEQUENCE_ITEM*
createReferencedItem(DCM_OBJECT** obj)
{
  char sopClass[DICOM_UI_LENGTH+1];
  char sopInstance[DICOM_UI_LENGTH+1];

  MString s;
  MDICOMWrapper w(*obj);

  s = w.getString(DCM_IDSOPCLASSUID);
  s.safeExport(sopClass, sizeof(sopClass));
  s = w.getString(DCM_IDSOPINSTANCEUID);
  s.safeExport(sopInstance, sizeof(sopInstance));

  DCM_ELEMENT e[] = {
    { DCM_IDREFERENCEDSOPCLASSUID, DCM_UI, "", 1, 0, sopClass },
    { DCM_IDREFERENCEDSOPINSTUID, DCM_UI, "", 1, 0, sopInstance }
  };

  DCM_OBJECT* newObj;
  ::DCM_CreateObject(&newObj, 0);
  ::DCM_ModifyElements(&newObj, e, 2, 0, 0, 0);

  DCM_SEQUENCE_ITEM* item = (DCM_SEQUENCE_ITEM*)malloc(sizeof(*item));
  item->object = newObj;

  return item;
}

static void
addRefSOPInstance(DCM_OBJECT** obj, DCM_OBJECT** outputObj)
{
  DCM_SEQUENCE_ITEM* item;

  item = createReferencedItem(obj);

  LST_HEAD* l;

  ::DCM_GetSequenceList(outputObj, DCM_IDREFERENCEDSOPSEQUENCE, &l);
  ::LST_Enqueue(&l, item);
}

int main(int argc, char **argv)
{
  CTNBOOLEAN verbose = FALSE;
  char* outputFile = "ref.dcm";

  while (--argc > 0 && (*++argv)[0] == '-') {
    switch (*(argv[0] + 1)) {
    case 'f':
      if (argc < 1)
	usageerror();
      argc--; argv++;
      outputFile = *argv;
      break;
    case 'v':
      verbose = TRUE;
      break;
    default:
      break;
    }
  }

  if (argc < 1)
    usageerror();

  ::THR_Init();

  DCM_OBJECT* outputObj;
  ::DCM_CreateObject(&outputObj, 0);
  addRefSequence(&outputObj);

  while(argc > 0) {
    DCM_OBJECT* obj;

    obj = openFile(*argv);
    if (obj == 0) {
      cout << "Could not open file: " << *argv << endl;
      ::COND_DumpConditions();
      return 1;
    }

    addRefSOPInstance(&obj, &outputObj);
    ::DCM_CloseObject(&obj);

    argc--; argv++;
  }

  ::DCM_WriteFile(&outputObj, DCM_ORDERLITTLEENDIAN, outputFile);
  ::DCM_CloseObject(&outputObj);

  ::THR_Shutdown();
  return 0;
}



