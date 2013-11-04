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

static char rcsid[] = "$Revision: 1.1 $ $RCSfile: naction_support.cpp,v $";

#include "ctn_os.h"

#include "MESA.hpp"
#include "ctn_api.h"
#include "MDICOMReactor.hpp"
#include "MSOPHandler.hpp"
#include "MLNAction.hpp"

DCM_OBJECT *
createQueryObject(const char *fileName)
{
    DCM_OBJECT *obj;
    CONDITION cond;
    DCM_ELEMENT e;
    char txt[1024] = "";

    int group = 0;
    int element = 0;
    char textValue[1024];

    if (fileName != NULL) {
	cond = DCM_OpenFile(fileName, DCM_ORDERLITTLEENDIAN, &obj);
	if (cond != DCM_NORMAL) {
	    COND_DumpConditions();
	    exit(1);
	}
	return obj;
    }
    cond = DCM_CreateObject(&obj, 0);
    if (cond != DCM_NORMAL) {
	COND_DumpConditions();
	exit(1);
    }
    while (fgets(txt, sizeof(txt), stdin) != NULL) {
	if (txt[0] == '#' || txt[0] == '\0')
	    continue;
	if (txt[0] == '\n' || txt[0] == '\r')
	    continue;

	if (sscanf(txt, "%x %x %[^\n]", &group, &element, textValue) != 3)
	    continue;

	e.tag = DCM_MAKETAG(group, element);
	DCM_LookupElement(&e);
	if (strncmp(textValue, "#", 1) == 0) {
	    e.length = 0;
	    e.d.string = NULL;
	} else {
	    e.length = strlen(textValue);
	    e.d.string = textValue;
	}

	cond = DCM_AddElement(&obj, &e);
	if (cond != DCM_NORMAL) {
	    COND_DumpConditions();
	    exit(1);
	}
    }

    return obj;
}

typedef struct {
  char* sopClass;
  char* synonym;
} CLASS_MAP;

CLASS_MAP m1[] = {
  { DICOM_SOPCLASSSTORAGECOMMITMENTPUSHMODEL, "commitment" },
  { DICOM_SOPCLASSSTORAGECOMMITMENTPUSHMODEL, "commit" },
  { DICOM_SOPCLASSSTORAGECOMMITMENTPUSHMODEL, DICOM_SOPCLASSSTORAGECOMMITMENTPUSHMODEL },
  { DICOM_SOPGPSPS, "GPSPS" },
  { DICOM_SOPGPSPS, "gpsps" },
  { DICOM_SOPGPSPS, DICOM_SOPGPSPS }

};

void
printSupportedClasses()
{
  int i;

  for (i = 0; i < (int)DIM_OF(m1); i++) {
    cout << m1[i].sopClass << " " << m1[i].synonym << endl;
  }
}

void
translateSOPClass(const char* synonym, char* translation)
{
  int i;

  for (i = 0; i < (int)DIM_OF(m1); i++) {
    if (strcmp(m1[i].synonym, synonym) == 0) {
      strcpy(translation, m1[i].sopClass);
      return;
    }
  }
  strcpy(translation, synonym);
}

