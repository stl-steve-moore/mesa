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
#include "MCGIParser.hpp"

#include "cgi-lib.h"
#include "cgi-llist.h"

static char rcsid[] = "$Id: MCGIParser.cpp,v 1.1 2001/08/10 22:33:31 smm Exp $";

MCGIParser::MCGIParser() :
  ptrLlist(0)
{
}

MCGIParser::MCGIParser(const MCGIParser& cpy)
{
}

MCGIParser::~MCGIParser()
{
  if (ptrLlist != 0) {
    llist* p = (llist*)ptrLlist;
    ::list_clear(p);
    delete p;
  }
}

void
MCGIParser::printOn(ostream& s) const
{
  s << "MCGIParser";
}

void
MCGIParser::streamIn(istream& s)
{
  //s >> this->member;
}

// Non boiler plate methods follow

int
MCGIParser::parse(const MString& buffer)
{
  if (ptrLlist != 0) {
    llist* p = (llist*) ptrLlist;
    ::list_clear(p);
    delete p;
  }

  llist* p1 = new llist;
  ptrLlist = p1;
  ::list_create(p1);
  char* c = buffer.strData();
  int status = ::parse_CGI_encoded(p1, c);
  delete []c;

  if (status >= 0)
    return 0;
  else
    return 1;
}

MString
MCGIParser::getValue(const MString& key)
{
  if (ptrLlist == 0)
    return "";

  llist* p = (llist*) ptrLlist;
  char* keyChar = key.strData();

  char* c = cgi_val(*p, keyChar);
  if (c == 0)
    c = "";

  delete []keyChar;
  return c;
}
