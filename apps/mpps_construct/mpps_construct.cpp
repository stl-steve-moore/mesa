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

static char rcsid[] = "$Revision: 1.3 $ $RCSfile: mpps_construct.cpp,v $";


#include "MESA.hpp"
#include "ctn_api.h"

#include "MString.hpp"
#include "MDBModality.hpp"
#include "MDBModality.hpp"
#include "MPatient.hpp"
#include "MDICOMDomainXlate.hpp"

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

static void newWithPatientID(const MString& patientID, const char* fileName)
{
  MDBModality db("mod1");
  MPatient p;

  MDICOMDomainXlate xlate;

  DCM_OBJECT* dcmObj;

  ::DCM_CreateObject(&dcmObj, 0);

  U32 patientTags[] = { DCM_PATID, DCM_PATNAME, DCM_PATBIRTHDATE, DCM_PATSEX, 0};

  xlate.translateDICOM(p, patientTags, dcmObj);

  ::DCM_WriteFile(&dcmObj, DCM_ORDERLITTLEENDIAN, fileName);
  ::DCM_CloseObject(&dcmObj);
}

static void  addSequence(U16 group, U16 element, const char* srcFile,
			const char* sequenceFile, const char* targetFile)
{
  DCM_OBJECT* dcmObj = 0;
  DCM_OBJECT* seqObj = 0;
  CONDITION cond;

  cond = ::DCM_OpenFile(srcFile, DCM_ORDERLITTLEENDIAN, &dcmObj);
  if (cond != DCM_NORMAL) {
    ::COND_DumpConditions();
    ::exit(1);
  }
  cond = ::DCM_OpenFile(sequenceFile, DCM_ORDERLITTLEENDIAN, &seqObj);
  if (cond != DCM_NORMAL) {
    ::COND_DumpConditions();
    ::exit(1);
  }

  DCM_TAG tag = DCM_MAKETAG(group, element);
  LST_HEAD* sequenceList = 0;
  cond = ::DCM_GetSequenceList(&dcmObj, tag, &sequenceList);
  if (cond == DCM_NORMAL) {
    DCM_SEQUENCE_ITEM* sequenceItem = (DCM_SEQUENCE_ITEM*)::malloc(sizeof(*sequenceItem));
    sequenceItem->object = seqObj;
    ::LST_Enqueue(&sequenceList, &sequenceItem);
  } else {
    DCM_ELEMENT e;
    ::memset(&e, 0, sizeof(e));
    e.tag = tag;
    e.representation = DCM_SQ;
    e.d.sq = ::LST_Create();
    DCM_SEQUENCE_ITEM* sequenceItem = (DCM_SEQUENCE_ITEM*)::malloc(sizeof(*sequenceItem));
    sequenceItem->object = seqObj;
    ::LST_Enqueue(&e.d.sq, sequenceItem);
    ::DCM_AddSequenceElement(&dcmObj, &e);
  }

  ::DCM_WriteFile(&dcmObj, DCM_ORDERLITTLEENDIAN, targetFile);
  ::DCM_CloseObject(&dcmObj);
  (void)::COND_PopCondition(TRUE);
}

static void  addAttributes(const char* srcFile,
			const char* deltaFile, const char* targetFile)
{
  DCM_OBJECT* dcmObj = 0;
  DCM_OBJECT* deltaObj = 0;
  CONDITION cond;

  cond = ::DCM_OpenFile(srcFile, DCM_ORDERLITTLEENDIAN, &dcmObj);
  if (cond != DCM_NORMAL) {
    ::COND_DumpConditions();
    ::exit(1);
  }
  cond = ::DCM_OpenFile(deltaFile, DCM_ORDERLITTLEENDIAN, &deltaObj);
  if (cond != DCM_NORMAL) {
    ::COND_DumpConditions();
    ::exit(1);
  }

  ::DCM_MergeObject(&deltaObj, &dcmObj);
  ::DCM_WriteFile(&dcmObj, DCM_ORDERLITTLEENDIAN, targetFile);
  ::DCM_CloseObject(&dcmObj);
  ::DCM_CloseObject(&deltaObj);
}


int main(int argc, char **argv)
{
  CONDITION cond;
  CTNBOOLEAN
    verboseDCM = FALSE,
    done = FALSE,
    silent = FALSE;

  MString patientID("");
  U16 group = 0;
  U16 element = 0;

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
    case 'p':
      argc--; argv++;
      patientID = *argv;
      break;
    case 's':
      { int temp = 0;
	argc--; argv++;
	::sscanf(*argv, "%x", &temp);
	group = (U16)temp;
	argc--; argv++;
	::sscanf(*argv, "%x", &temp);
	element = (U16)temp;
      }
      break;
    default:
      (void) fprintf(stderr, "Unrecognized option: %c\n", *(argv[0] + 1));
      break;
    }
  }

  ::THR_Init();

  DCM_Debug(verboseDCM);

  if (patientID != "" && argc == 1)
    newWithPatientID(patientID, *argv);
  else if ((group | element) != 0x0000) {
   addSequence(group, element, argv[0], argv[1], argv[2]);
  } else {
   addAttributes(argv[0], argv[1], argv[2]);
  }


    return 0;
}


