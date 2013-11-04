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

#include "mesa_dictionary.hpp"

static void usageerror()
{
    char msg[] = "\
mesa_dictionary [-h] [-v] [-r|-d|-a] -D group element \n\
    -h print extended help\n\
    -v verbose output\n\
    -r print out value representation of element\n\
    -d print out description of element\n\
    -a print out element tag, VR, and description of element (default)\n\
    -D group and element -- hexidecimal values of group and element to look up\n";

    fprintf(stderr, msg);
    exit(USAGE_ERROR);
}

int main(int argc, char **argv)
{
    int group = -1, element;
    // print mode: VR = 1, description = 2, all = 3
    int printMode = 3;

    while (--argc > 0 && (*++argv)[0] == '-') {
        switch (*(argv[0] + 1)) {
            case 'h':
                usageerror();
                break;
            case 'v':
                verbose = TRUE;
                break;
            case 'r':
                printMode = 1;
                break;
            case 'd':
                printMode = 2;
                break;
            case 'a':
                printMode = 3;
                break;
            case 'D':
                if (argc < 2)
                    usageerror();
                argc--; argv++;
                sscanf(*argv, "%x", &group);
                argc--; argv++;
                sscanf(*argv, "%x", &element);
                break;
            default:
                break;
        }
    }

    if (argc != 0) usageerror();

    // Require that -D was called to set the group and element values.
    if (group == -1) usageerror();

    DCM_TAG tag = DCM_MAKETAG(group, element);

    DCM_ELEMENT e;
    memset(&e, 0, sizeof(e));
    e.tag = tag;

    CONDITION cond = DCM_LookupElement(&e);
    if (cond != DCM_NORMAL) {
        if (cond == DCM_UNRECOGNIZEDGROUP) {
            fprintf(stderr, "Error: unknown group %04x\n", group);
            return UNKNOWN_GROUP;
        } else if (cond == DCM_UNRECOGNIZEDELEMENT) {
            fprintf(stderr, "Error: unknown element %04x\n", element);
            return UNKNOWN_ELEMENT;
        } else {
            fprintf(stderr, "Unknown error looking up element\n");
            return UNKNOWN_ERROR;
        }
    }

    switch (printMode) {
        case 1: // VR
            printf("%s\n", translate(e.representation));
            break;
        case 2: // description        
            printf("%s\n", e.description);
            break;
        case 3: // All
            printf("  %04x %04x %s %s\n", DCM_TAG_GROUP(e.tag),
                    DCM_TAG_ELEMENT(e.tag), translate(e.representation),
                    e.description);
            break;
    }

    return(MESA_NO_ERROR);
}

static char * translate(DCM_VALUEREPRESENTATION r)
{
    int i;
    for (i = 0; i < (int) DIM_OF(mesa_map); i++) {
	if (r == mesa_map[i].r)
	    return mesa_map[i].translation;
    }
    return unknown;
}
