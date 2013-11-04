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
#include "MApplicationEntity.hpp"

static char rcsid[] = "$Id: MApplicationEntity.cpp,v 1.2 2000/05/06 19:17:01 smm Exp $";

MApplicationEntity::MApplicationEntity()
{
}

MApplicationEntity::MApplicationEntity(const MApplicationEntity& cpy)
{
}

MApplicationEntity::~MApplicationEntity()
{
}

void
MApplicationEntity::printOn(ostream& s) const
{
  s << "MApplicationEntity";
}

void
MApplicationEntity::streamIn(istream& s)
{
  //s >> this->member;
}

// Class specific methods are defined below.

MApplicationEntity::MApplicationEntity(const MString& s)
{
  MString x(s);

  mTitle = x.getToken('^', 0);
  mHost = x.getToken('^', 1);
  MString port = x.getToken('^', 2);
  mOrganization = x.getToken('^', 3);
  mComment = x.getToken('^', 4);

  this->trim(mTitle);
  this->trim(mHost);
  this->trim(mOrganization);
  this->trim(mComment);

  mPort = port.intData();
}


void
MApplicationEntity::title(const MString& title)
{
  mTitle = title;
}

void
MApplicationEntity::host(const MString& host)
{
  mHost = host;
}

void
MApplicationEntity::port(int port)
{
  mPort = port;
}

void
MApplicationEntity::organization(const MString& organization)
{
  mOrganization = organization;
}

void
MApplicationEntity::comment(const MString& comment)
{
  mComment = comment;
}

MString
MApplicationEntity::title() const
{
  return mTitle;
}

MString
MApplicationEntity::host() const
{
  return mHost;
}

int
MApplicationEntity::port() const
{
  return mPort;
}

MString
MApplicationEntity::organization() const
{
  return mOrganization;
}

MString
MApplicationEntity::comment() const
{
  return mComment;
}

// Private methods defined below

// trim
// Trim beginning and trailing white space
void
MApplicationEntity::trim(MString& s)
{
  char* p1 = s.strData();

  char* p2 = p1;

  while (isspace(*p2))
    p2++;

  int i = ::strlen(p2);

  char* p3 = p2 + i -1;
  while ((p3 > p2) && isspace(*p3)) {
    *p3 = '\0';
    p3--;
  }

  s = p2;
  delete [] p1;
}
