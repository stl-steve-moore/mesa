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

#include "ctn_os.h"
#include "MESA.hpp"
#include "MDateTime.hpp"

#include "ctn_api.h"

static char rcsid[] = "$Id: MDateTime.cpp,v 1.1 2002/07/30 17:25:00 smm Exp $";

MDateTime::MDateTime()
{
}

MDateTime::MDateTime(const MDateTime& cpy)
{
}

MDateTime::~MDateTime()
{
}

void
MDateTime::printOn(ostream& s) const
{
  s << "MDateTime";
}

void
MDateTime::streamIn(istream& s)
{
  //s >> this->member;
}

// Non boiler plate methods follow

int
MDateTime::formatXSDateTime(MString& dateTime)
{
  char dateDICOM[32];
  char timeDICOM[32];
  char buf[64];

  ::UTL_GetDicomDate(dateDICOM);

  ::UTL_GetDicomTime(timeDICOM);

  char *pDate;
  char *pTime;
  char *p;

  p = buf;
  pDate = dateDICOM;
  pTime = timeDICOM;

  *p++ = *pDate++;	// CC
  *p++ = *pDate++;	// CC
  *p++ = *pDate++;	// YY
  *p++ = *pDate++;	// YY
  *p++ = '-';

  *p++ = *pDate++;	// MM
  *p++ = *pDate++;	// MM
  *p++ = '-';

  *p++ = *pDate++;	// DD
  *p++ = *pDate++;	// DD
  *p++ = 'T';		// Time divider

  *p++ = *pTime++;	// HH
  *p++ = *pTime++;	// HH
  *p++ = ':';

  *p++ = *pTime++;	// MM
  *p++ = *pTime++;	// MM
  *p++ = ':';

  *p++ = *pTime++;	// SS
  *p++ = *pTime++;	// SS
  *p++ = '\0';

  dateTime = buf;

  return 0;
}


int
MDateTime::formatRFC3339DateTime(MString& dateTime)
{
  char dateDICOM[32];
  char timeDICOM[32];
  char buf[64];

  ::UTL_GetDicomDate(dateDICOM);

  ::UTL_GetDicomTime(timeDICOM);

  char *pDate;
  char *pTime;
  char *p;

  p = buf;
  pDate = dateDICOM;
  pTime = timeDICOM;

  *p++ = *pDate++;	// CC
  *p++ = *pDate++;	// CC
  *p++ = *pDate++;	// YY
  *p++ = *pDate++;	// YY
  *p++ = '-';

  *p++ = *pDate++;	// MM
  *p++ = *pDate++;	// MM
  *p++ = '-';

  *p++ = *pDate++;	// DD
  *p++ = *pDate++;	// DD
  *p++ = 'T';		// Time divider

  *p++ = *pTime++;	// HH
  *p++ = *pTime++;	// HH
  *p++ = ':';

  *p++ = *pTime++;	// MM
  *p++ = *pTime++;	// MM
  *p++ = ':';

  *p++ = *pTime++;	// SS
  *p++ = *pTime++;	// SS

  *p++ = 'Z';		// repair, this makes a legal format, but the wrong time zone
  *p++ = '\0';

  dateTime = buf;

  return 0;
}

