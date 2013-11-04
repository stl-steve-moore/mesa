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

// $Id: MDICOMApp.hpp,v 1.5 2006/06/29 16:08:30 bhasselfeld Exp $ $Author: bhasselfeld $ $Revision: 1.5 $ $Date: 2006/06/29 16:08:30 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MDICOMApp.hpp
//
//  = AUTHOR
//	Saeed Akbani
//
//  = COPYRIGHT
//	Copyright HIMSS, RSNA, Washington University: 1999, 2000
//
// ====================
//
//  = VERSION
//	$Revision: 1.5 $
//
//  = DATE RELEASED
//	$Date: 2006/06/29 16:08:30 $
//
//  = COMMENTS
//

#ifndef MDICOMAppISIN
#define MDICOMAppISIN

#include <iostream>
#include "MDomainObject.hpp"

class MDICOMApp;
typedef vector < MDICOMApp > MDICOMAppVector;

using namespace std;

class MDICOMApp : public MDomainObject
// = TITLE
///	Domain object which corresponds to a DICOM application.
//
// = DESCRIPTION
/**	This class is a container for attributes that describe
	a DICOM Application.  It provides methods to get/set the attributes
	by name. */
{
public:
  // = The standard methods in this framework.

  MDICOMApp();
  ///< Default constructor

  MDICOMApp(const MDICOMApp& cpy);

  virtual ~MDICOMApp();

  virtual void printOn(ostream& s) const;
  /**<\brief This method is used in conjunction with the streaming operator <<
             to print the current state of MDICOMApp. */

  virtual void streamIn(istream& s);
  /**<\brief This method is used in conjunction with the streaming operator >>
             to read the current state of MDICOMApp. */

  // = Class specific methods.

  MDICOMApp(const MString& aeTitle, const MString& host,
	    const MString& port, const MString& organization,
	    const MString& comment);
  ///< Constructor which takes all attributes which are part of the class.

  void import(const MDomainObject& o);
  ///< This method takes an existing MDomain Object, <{o}>, and imports the attributes into this object.  
  /**< One would typically use the domain object <{o}> to set attributes 
       by key-value pair and then import the attributes into this domain-specific object. */
  
  MString aeTitle() const;
  ///< Return a copy of the attribute: AE title.

  MString host() const;
  ///< Return a copy of the attribute: host.  This is the host name of the app.

  MString port() const;
  ///< Return a copy of the attribute: port.  This is a TCP/IP port number.

  MString organization() const;
  /**<\brief  Return a copy of the attribute: organization.  
	      This is typically the name of an organization managing the application. */

  MString comment() const;
  /**<\brief Return a copy of the attribute: comment.  This is free form text
   	     which describes the application. */

  void aeTitle(const MString& s);
  ///< Set the attribute AE title to the value passed in <{s}>.

  void host(const MString& s);
  ///< Set the attribute host to the value passed in <{s}>.

  void port(const MString& s);
  ///< Set the attribute port to the value passed in <{s}>.

  void organization(const MString& s);
  ///< Set the attribute organization to the value passed in <{s}>.

  void comment(const MString& s);
  ///< Set the attribute comment to the value passed in <{s}>.

private:
  MString mAETitle;
  MString mHost;
  MString mPort;
  MString mOrganization;
  MString mComment;
};

inline ostream& operator<< (ostream& s, const MDICOMApp& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MDICOMApp& c) {
  c.streamIn(s);
  return s;
}

#endif
