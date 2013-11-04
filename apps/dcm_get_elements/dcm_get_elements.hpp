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

// need to have a value which is guaranteed not to exist
#define UNDEFINED_TAG 0xFFFFFFFF

// Program return values (arguments to exit())
#define MESA_NO_ERROR 0
#define ELEMENT_DOES_NOT_EXIST 1
#define NO_ERROR_USAGE_PRINTED 2
#define USAGE_ERROR 3
#define MALFORMED_ROOT_ELEMENT 10
#define ITEM_IN_NON_SQ_TAG 11
#define NON_SQ_TAG_NOT_LAST 12
#define UNKNOWN_TAG 13
#define UNKNOWN_ERROR 14
#define ERROR_GETTING_ITEM 15
#define ERROR_GETTING_SEQUENCE 16
#define ERROR_OPENING_FILE 17

// These strings are output during the course of regular output and may
// substitute for element data.  They are put here in one place to make
// parsing easier.
#define SEQUENCE_MSG "<< Sequence of %d elements >>"
#define DATA_ON_DISK_MSG "<< Data on disk >>"
#define VM_UNIMPLEMENTED_MSG "<< VM=%d.  Unimplemented >>"
#define BINARY_MSG "<< BINARY data >>"
#define UNIMPLEMENTED_MSG "<< Unimplemented >>"


// Global variables defined on the command line
CTNBOOLEAN dcoFormat = FALSE;
CTNBOOLEAN verbose = FALSE;
CTNBOOLEAN ignoreNoElement = FALSE;

typedef struct {
    MDICOMWrapper* w;
    int level;
    int item;
    DCM_TAG tag;
    CTNBOOLEAN expandSequences;
    CTNBOOLEAN recurseFurther;
} PRINT_ELEMENT_STRUCT;


    
static void extended_usage_error();
static void usageerror();
void printSequence(const DCM_ELEMENT *e, void *ctx);
static CONDITION printElement(const DCM_ELEMENT *e, void *ctx);
int readElementDescription(MString elementDesc, DCM_TAG *tag, int *item);
int parseRootElement(MDICOMWrapper **w, MString rootElement, DCM_ELEMENT *e, int *item);
int processRootElement(MDICOMWrapper *w, char *rootElement,  CTNBOOLEAN expandSequence);
