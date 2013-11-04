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

// $Id: MServerAgent.hpp,v 1.6 2006/06/29 16:08:29 bhasselfeld Exp $ $Author: bhasselfeld $ $Revision: 1.6 $ $Date: 2006/06/29 16:08:29 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MServerAgent.hpp
//
//  = AUTHOR
//	F. David Sacerdoti
//
//  = COPYRIGHT
//	Copyright HIMSS, RSNA, Washington University: 1999, 2000
//
// ====================
//
//  = VERSION
//	$Revision: 1.6 $
//
//  = DATE RELEASED
//	$Date: 2006/06/29 16:08:29 $
//
//  = COMMENTS
//	Uses non-MT safe routine ctime.

#ifndef CLASSISIN
#define CLASSISIN

#include <iostream>
#include <string>

using namespace std;

class MString;

class MServerAgent
// = TITLE
///	Performs some bookkeeping work on behalf of server applications.
//
// = DESCRIPTION
/**	MServerAgent is used to perform bookkeeping operations in a consistent
	fashion across different server applications.
	The first set of operations is logging the Process ID so that other
	applications or scripts can determine that the server is running. */
{
public:
  // = The standard methods in this framework.

  MServerAgent(const MString & servername, const MString & path = "");
  ///< Default constructor.

  MServerAgent(const MServerAgent& cpy);
  ///< Copy constructor.

  virtual ~MServerAgent();
  ///< Destructor.

  virtual void printOn(ostream& s) const;
  /**<\brief This method is used in conjunction with the streaming operator <<
   to print the current state of MServerAgent. */

  virtual void streamIn(istream& s);
  /**<\brief This method is used in conjunction with the streaming operator >>
   to read the current state of MServerAgent. */
  
  // = Class specific methods.

  int registerServerPID ();

  //< Creates a file in $MESA_TARGET/pids with the pid and start time of the server.
  /**< 0 is returned on success.
  // -1 is returned on failure ($MESA_TARGET not set, could not create file). */

  int closeServerPID ();
  ///< Adds the finish time to the pid file
  /**< 0 is returned on success.
   -1 is returned on failure. */

private:
  MString mPIDpath;
  int usage ();
};

inline ostream& operator<< (ostream& s, const MServerAgent& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MServerAgent& c) {
  c.streamIn(s);
  return s;
}

#endif
