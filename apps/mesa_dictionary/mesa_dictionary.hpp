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

// Program return values (arguments to exit())
#define MESA_NO_ERROR 0
#define NO_ERROR_USAGE_PRINTED 2
#define USAGE_ERROR 3
#define UNKNOWN_GROUP 4
#define UNKNOWN_ELEMENT 5
#define UNKNOWN_ERROR 10


// Global variables defined on the command line
CTNBOOLEAN verbose = FALSE;
static char* unknown = "??";

static void usageerror();
static char * translate(DCM_VALUEREPRESENTATION r);

typedef struct {
    DCM_VALUEREPRESENTATION r;
    char *translation;
}   MAP;

static MAP mesa_map[] = {
    {DCM_AE, "AE"},
    {DCM_AS, "AS"},
    {DCM_AT, "AT"},
    {DCM_CS, "CS"},
    {DCM_DA, "DA"},
    {DCM_DD, "DD"},
    {DCM_DS, "DS"},
    {DCM_FD, "FD"},
    {DCM_FL, "FL"},
    {DCM_IS, "IS"},
    {DCM_LO, "LO"},
    {DCM_LT, "LT"},
    {DCM_OT, "OT"},
    {DCM_SH, "SH"},
    {DCM_SL, "SL"},
    {DCM_SQ, "SQ"},
    {DCM_SS, "SS"},
    {DCM_ST, "ST"},
    {DCM_TM, "TM"},
    {DCM_UI, "UI"},
    {DCM_UL, "UL"},
    {DCM_US, "US"},
    {DCM_UT, "UT"},
    {DCM_UN, "UN"},
    {DCM_RET, "RET"},
    {DCM_CTX, "CTX"},
    {DCM_PN, "PN"},
    {DCM_OB, "OB"},
    {DCM_OW, "OW"},
    {DCM_DT, "DT"}
};
