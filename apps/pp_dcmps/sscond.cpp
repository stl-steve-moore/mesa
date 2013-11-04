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

static char rcsid[] = "$Revision: 1.1 $ $RCSfile: sscond.cpp,v $";

#include <stdio.h>
#include <time.h>
#include "MESA.hpp"
#include "ctn_api.h"

#include "pp_dcmps.h"

typedef struct {
    CONDITION cond;
    char *message;
}   VECTOR;

static VECTOR messageVector[] = {
    {APP_NORMAL, "Normal return from application routine"},
    {APP_ILLEGALSERVICEPARAMETER, "APP Illegal service parameter (name %s, value %s)"},
    {APP_MISSINGSERVICEPARAMETER, "APP The %s parameter is missing"},
    {APP_PARAMETERWARNINGS, "APP One or more service parameters were incorrect"},
    {APP_PARAMETERFAILURE, "APP One or more service parameters were incorrect"},
};


/* APP_Message
**
** Purpose:
**	This function accepts a CONDITION as an input parameter and finds
**	the ASCIZ message that is defined for that CONDITION.  If the
**	CONDITION is defined for this facility, this function returns
**	a pointer to the ASCIZ string which describes the condition.
**	If the CONDITION is not found, the function returns NULL.
**
** Parameter Dictionary:
**	condition	The CONDITION used to search the dictionary.
**
** Return Values:
**	ASCIZ string which describes the condtion requested by the caller
**	NULL if the condition is not found
**
*/
char *
APP_Message(CONDITION condition)
{
    int
        index;

    for (index = 0; messageVector[index].message != NULL; index++)
	if (condition == messageVector[index].cond)
	    return messageVector[index].message;

    return NULL;
}
