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
#include "MMESAMisc.hpp"
#include <strstream>
#include <fstream>
#include <sstream>

static char rcsid[] = "$Id: MMESAMisc.cpp,v 1.1 2001/12/28 21:05:03 smm Exp $";

MMESAMisc::MMESAMisc()
{
}

MMESAMisc::MMESAMisc(const MMESAMisc& cpy)
{
}

MMESAMisc::~MMESAMisc()
{
}

void
MMESAMisc::printOn(ostream& s) const
{
  s << "MMESAMisc";
}

void
MMESAMisc::streamIn(istream& s)
{
  //s >> this->member;
}

// Non boiler-plate methods to follow

int
MMESAMisc::convertTime(time_t t, int& year, int& month, int& day,
		int& hour, int& minute, int& second)
{
    struct tm* cTime = ::localtime(&t);
  if (cTime == 0) {
    year = 0;
    month = 0;
    day = 0;
    hour = 0;
    minute = 0;
    second = 0;
    return -1;
  }

  year   = cTime->tm_year + 1900;
  month  = cTime->tm_mon + 1;
  day    = cTime->tm_mday;
  hour   = cTime->tm_hour;
  minute = cTime->tm_min;
  second = cTime->tm_sec;

  return 0;
}


MString
MMESAMisc::generateOID(const MString& pathToOIDFile, int index)
{
  char buf[1024] = "";
  pathToOIDFile.safeExport(buf, sizeof(buf)-1);
  ifstream f(buf);
  if (f == 0) {
    return "";
  }

  char base[1024] = "";
  int offset = 0;

  istringstream instream;
  bool done = false;
  char txt[1024] = "";
  while (!done && f.getline(txt, sizeof(txt))) {
    //cout << txt << endl;
    if ((txt[0] == '#') || (txt[0] == '\n') || (txt[0] == '\r'))
      continue;
    instream.clear();
    instream.str(txt);
    instream >> base >> offset;
    offset++;
    done = true;
  }
  //cout << "XX" << endl;
  f.close();

  ofstream fOut;
  fOut.open(buf, ios_base::out | ios_base::trunc);
  fOut << "# OID file for base: " << base << endl;
  fOut << base << "\t" << offset << endl;
  fOut.close();

  strstream x(txt, sizeof(txt));
  x << base << "." << index << "." << offset << '\0';
  MString oid(txt);

  return oid;
}


