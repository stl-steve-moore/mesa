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
#include "MFileOperations.hpp"
#include "MServerAgent.hpp"
#include <sys/types.h>
#include <time.h>
#ifdef _WIN32
#include <process.h>
#else
#include <unistd.h>
#endif
#include <iostream>
#include <fstream>

static char rcsid[] = "$Id: MServerAgent.cpp,v 1.5 2002/01/02 15:42:01 smm Exp $";

MServerAgent::MServerAgent(const MString & servername, const MString & path)
{
  MFileOperations f;
  char name[128];
  if (f.expandPath(name, "MESA_TARGET", "pids/") < 0) usage();
  //if ((strlen(servername) + strlen(mPathname)) < 128) strcat (mPathname, servername);
  mPIDpath = name + servername + ".pid";
}

MServerAgent::MServerAgent(const MServerAgent& cpy) :
  mPIDpath(cpy.mPIDpath)
{
}

MServerAgent::~MServerAgent()
{
}

void
MServerAgent::printOn(ostream& s) const
{
  s << "MServerAgent";
}

void
MServerAgent::streamIn(istream& s)
{
  //s >> this->member;
}

int
MServerAgent::registerServerPID ()
{
  //Write PID file
  int pid;
#ifdef _WIN32
  pid = _getpid();
#else
  pid = getpid();
#endif
  char *timeStr;
  time_t clock = time(0);
  timeStr = ctime(&clock);
  ofstream pidfile(mPIDpath.strData(), ios::out|ios::trunc);
  pidfile << pid << endl;
  pidfile << "Started: " << timeStr;
  pidfile.close();

  return 0;
}

int
MServerAgent::closeServerPID ()
{
  time_t clock = time(0);
  char *timeStr = ctime(&clock);
  ofstream pidfile(mPIDpath.strData(), ios::app|ios::out);
  pidfile << "Finished: " << timeStr;
  pidfile.close();

  return 0;
}

int
MServerAgent::usage ()
{

  cerr << "Make sure '$MESA_TARGET/pids' is a valid directory\n";
  //cerr << "MServerAgent: env variable and directory $MESA_TARGET/pids must be defined\n\
//to write PID file.\n";

 return 0;
}
