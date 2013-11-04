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
#include "MHL7MessageControlID.hpp"

#include <sys/types.h>
#include <time.h>
#include <stdio.h>

static char rcsid[] = "$Id: MHL7MessageControlID.cpp,v 1.3 2000/05/08 22:20:18 smm Exp $";

MHL7MessageControlID::MHL7MessageControlID()
{
}

MHL7MessageControlID::MHL7MessageControlID(const MHL7MessageControlID& cpy)
{
}

MHL7MessageControlID::~MHL7MessageControlID()
{
}

void
MHL7MessageControlID::printOn(ostream& s) const
{
  s << "MHL7MessageControlID";
}

void
MHL7MessageControlID::streamIn(istream& s)
{
  //s >> this->member;
}

// Non boiler plate methods follow

MString
MHL7MessageControlID::controlID() const
{
  time_t t;

  t = time(0);
  char s[20];

  sprintf(s, "%08x", t);
  return MString("MESA") + s;
}
