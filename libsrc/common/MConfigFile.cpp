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
//

#include "ctn_os.h"

#include "MESA.hpp"
#include "MConfigFile.hpp"
#include "MFileOperations.hpp"

#include <fstream>
#include <string.h>

static char rcsid[] = "$Id: MConfigFile.cpp,v 1.5 2002/07/30 14:13:16 smm Exp $";

MConfigFile::MConfigFile()
{
}

MConfigFile::MConfigFile(const MConfigFile& cpy) :
  mMap(cpy.mMap)
{
}

MConfigFile::~MConfigFile()
{
}

void
MConfigFile::printOn(ostream& s) const
{
  s << "MConfigFile";
}

void
MConfigFile::streamIn(istream& s)
{
  //s >> this->member;
}

// Non boiler plate methods to follow below

int
MConfigFile::readConfigFile(const MString& path)
{
  char buf[1024];

  path.safeExport(buf, sizeof(buf));

  ifstream f(buf);
  if (f == 0)
    return -1;

  while (f.getline(buf, sizeof(buf))) {
    if ((buf[0] == '#') || (buf[0] == '\n') || (buf[0] == '\0'))
      continue;

    char* tok1 = ::strtok(buf, " \t\n");
    if (tok1 == "")
      continue;

    char* tok2 = ::strtok(0, "\n");
    while (isspace(*tok2))
      tok2++;

    mMap[tok1] = tok2;
  }

  return 0;
}

MString
MConfigFile::value(const MString& key)
{
  return mMap[key];
}

int
MConfigFile::intValue(const MString& key)
{
  MString s = mMap[key];
  if (s == "")
    return -1;

  int i = s.intData();

  return i;
}

void
MConfigFile::value(const MString& key, const MString& value)
{
  mMap[key] = value;
}

MString
MConfigFile::completePath(const MString& key)
{
  MString value = mMap[key];

  char buffer[1024];

  value.safeExport(buffer, sizeof(buffer));

  char* tok1 = ::strtok(buffer, " \t\n");

  if (tok1 == 0)
    return "";

  char* tok2 = ::strtok(0, " \t\n");

  if (tok2 == 0)
    return tok1;

  MFileOperations fileOps;

  char buffer2[1024];

  int status = fileOps.expandPath(buffer2, tok1, tok2);
  if (status != 0)
    return "";

  return MString(buffer2);
}
