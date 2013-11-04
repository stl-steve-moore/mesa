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

// $Id: MDDRFile.hpp,v 1.3 2006/06/29 16:08:29 bhasselfeld Exp $ $Author: bhasselfeld $ $Revision: 1.3 $ $Date: 2006/06/29 16:08:29 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MDDRFile.hpp
//
//  = AUTHOR
//	Steve Moore
//
//  = COPYRIGHT
//	Copyright HIMSS, RSNA, Washington University: 1999, 2000
//
// ====================
//
//  = VERSION
//	$Revision: 1.3 $
//
//  = DATE RELEASED
//	$Date: 2006/06/29 16:08:29 $
//
//  = COMMENTS
//	Should eventually be replaced by a full C++ implementation.

#ifndef MDDRFileISIN
#define MDDRFileISIN

#include <iostream>
#include <string>
#include "ctn_api.h"
#include "MDICOMWrapper.hpp"
#include "MLogClient.hpp"

using namespace std;

class MDDRFile
// = TITLE
//	MDDRFile - 
//
// = DESCRIPTION
{
public:
  // = The standard methods in this framework.

  /// Default constructor.
  MDDRFile();

  MDDRFile(const MDDRFile& cpy);
  ///< Copy constructor

  virtual ~MDDRFile();
  ///< Destructor.

  virtual void printOn(ostream& s) const;
  /**<\brief This method is used in conjunction with the streaming operator <<
   to print the current state of MDDRFile. */

  virtual void streamIn(istream& s);
  /**<\brief This method is used in conjunction with the streaming operator >>
  to read the current state of MDDRFile. */

  // = Class specific methods.

  int open(const MString& path);

  int getPatientCount();
  int getPatientRecord(int idx, DDR_PATIENT* patient);
  int getStudyCount(const char* patientID);
  int getStudyCount(U32 offset);
  MDICOMWrapper* getStudyRecord(int idx, U32 offset);
  int getSeriesCount(U32 offset);
  MDICOMWrapper* getSeriesRecord(int idx, U32 offset);
  int getLeafCount(U32 offset);
  MDICOMWrapper* getLeafRecord(int idx, U32 offset);

  //virtual int getFileSetID(DDR_FILESETID* fileSetID);

protected:

private:
  MDICOMWrapper* mDICOMWrapper;
  LST_HEAD* mPatientList;
};

inline ostream& operator<< (ostream& s, const MDDRFile& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MDDRFile& c) {
  c.streamIn(s);
  return s;
}

#endif
