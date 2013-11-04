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

#include <fstream>

#include "MDICOMConfig.hpp"

#include "MSOPStorageHandler.hpp"
#include "MDICOMReactor.hpp"


static char rcsid[] = "$Id: MDICOMConfig.cpp,v 1.3 2000/07/30 03:28:59 smm Exp $";

MDICOMConfig::MDICOMConfig()
{
}

MDICOMConfig::MDICOMConfig(const MDICOMConfig& cpy)
{
}

MDICOMConfig::~MDICOMConfig()
{
}

void
MDICOMConfig::printOn(ostream& s) const
{
  s << "MDICOMConfig";
}

void
MDICOMConfig::streamIn(istream& s)
{
  //s >> this->member;
}


// Class specifc methods below

int
MDICOMConfig::registerStorageClasses(MSOPStorageHandler* handler,
				     MDICOMReactor& reactor,
				     const MString& configurationFile)
{
  char fn[1024];
  configurationFile.safeExport(fn, sizeof(fn));

  ifstream f(fn);

  if (f == 0)
    return -1;

  char buf[1024];
  while (f.getline(buf, sizeof(buf))) {
    if ((buf[0] == '#' || buf[0] == '\n'))
      continue;

    MString sopClass = this->trim(buf);

    int v = reactor.registerHandler(handler, sopClass);
    if (v != 0)
      return -1;
  }

  return 0;
}

int
MDICOMConfig::registerSOPClasses(MSOPHandler* handler,
				 MDICOMReactor& reactor,
				 const MString& configurationFile)
{
  char fn[1024];
  configurationFile.safeExport(fn, sizeof(fn));

  ifstream f(fn);

  if (f == 0)
    return -1;

  char buf[1024];
  while (f.getline(buf, sizeof(buf))) {
    if ((buf[0] == '#' || buf[0] == '\n'))
      continue;

    MString sopClass = this->trim(buf);

    int v = reactor.registerHandler(handler, sopClass);
    if (v != 0)
      return -1;
  }

  return 0;
}

int
MDICOMConfig::registerApplicationEntities(MSOPHandler& handler,
					  const MString& aeFile)
{
  char fn[1024];
  aeFile.safeExport(fn, sizeof(fn));

  ifstream f(fn);

  if (f == 0)
    return -1;

  char buf[1024];
  while (f.getline(buf, sizeof(buf))) {
    if ((buf[0] == '#' || buf[0] == '\n'))
      continue;

    MApplicationEntity ae(buf);

    handler.addApplicationEntity(ae);
  }

  return 0;
}

// Private methods defined below

// Trim off leading and trailing white space characters and
// return an MString.  This method destroys the input string.

MString
MDICOMConfig::trim(char* buffer)
{
  while(isspace(*buffer))
    buffer++;

  char* p = buffer;

  while(isdigit(*buffer) || (*buffer == '.'))
    buffer++;

  *buffer = '\0';

  MString s(p);
  return s;
}
