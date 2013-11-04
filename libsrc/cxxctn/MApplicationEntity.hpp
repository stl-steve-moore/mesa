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

// $Id: MApplicationEntity.hpp,v 1.4 2006/06/29 16:08:29 bhasselfeld Exp $ $Author: bhasselfeld $ $Revision: 1.4 $ $Date: 2006/06/29 16:08:29 $ $State: Exp $
// ====================
//  = FILENAME
//	MApplicationEntity.hpp
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
//	$Revision: 1.4 $
//
//  = DATE RELEASED
//	$Date: 2006/06/29 16:08:29 $
//
//  = COMMENTS

#ifndef MApplicationEntityISIN
#define MApplicationEntityISIN

#include <iostream>
#include <string>
#include <map>

using namespace std;

class MApplicationEntity;
typedef map<MString, MApplicationEntity, less <MString> > MApplicationEntityMap;

class MApplicationEntity
// = TITLE
//	Short title/description
//
// = DESCRIPTION
//	Describe the class and how to use it
{
public:
  // = The standard methods in this framework.
  MApplicationEntity();
  ///< Default constructor
  MApplicationEntity(const MApplicationEntity& cpy);
  virtual ~MApplicationEntity();
  virtual void printOn(ostream& s) const;
  /**<\brief This method is used in conjunction with the streaming operator <<
   to print the current state of MApplicationEntity */

  virtual void streamIn(istream& s);
  
  // = Class specific methods.

  MApplicationEntity(const MString& s);
  ///< Construct from a single line which describes the Application Entity

  void title(const MString& title);
  void host(const MString& host);
  void port(int port);
  void organization(const MString& organization);
  void comment(const MString& comment);

  MString title() const;
  MString host() const;
  int port() const;
  MString organization() const;
  MString comment() const;

private:
  MString mTitle;
  MString mHost;
  int mPort;
  MString mOrganization;
  MString mComment;

  void trim(MString& s);
};

inline ostream& operator<< (ostream& s, const MApplicationEntity& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MApplicationEntity& c) {
  c.streamIn(s);
  return s;
}

#endif
