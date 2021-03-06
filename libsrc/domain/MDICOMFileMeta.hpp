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

// $Id: MDICOMFileMeta.hpp,v 1.3 2006/06/29 16:08:30 bhasselfeld Exp $ $Author: bhasselfeld $ $Revision: 1.3 $ $Date: 2006/06/29 16:08:30 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MDICOMFileMeta.hpp
//
//  = AUTHOR
//	Steve Moore
//
//  = COPYRIGHT
//	Copyright HIMSS, RSNA, Washington University: 2001
//
// ====================
//
//  = VERSION
//	$Revision: 1.3 $
//
//  = DATE RELEASED
//	$Date: 2006/06/29 16:08:30 $
//
//  = COMMENTS
//

#ifndef MDICOMFileMetaISIN
#define MDICOMFileMetaISIN

#include <iostream>
#include "MDomainObject.hpp"

using namespace std;

class MDICOMFileMeta : public MDomainObject
// = TITLE
///	A domain object that corresponds to the DICOM File Meta information
//
// = DESCRIPTION
//
{
public:
  // = The standard methods in this framework.

  MDICOMFileMeta();
  ///< Default constructor

  MDICOMFileMeta(const MDICOMFileMeta& cpy);

  virtual ~MDICOMFileMeta();

  virtual void printOn(ostream& s) const;
  /**<\brief This method is used in conjunction with the streaming operator <<
             to print the current state of MDICOMFileMeta. */

  virtual void streamIn(istream& s);
  /**<\brief This method is used in conjunction with the streaming operator >>
  	     to read the current state of MDICOMFileMeta. */

  // = Class specific methods.

  void import(const MDomainObject& o);
  ///< This method imports the key-value pairs from the MDomainObject <{o}>.
  /**< The values are copied from <{o}> and stored in the internal state
       maintained by this object. */

  // A number of get methods that return values.  Use the method name
  // as a guide to the attribute.
  unsigned char* filePreamble() const;
  unsigned char* fileMetaInformationVersion() const;
  MString mediaStorageSOPClassUID() const;
  MString mediaStorageSOPInstanceUID() const;
  MString transferSyntaxUID() const;
  MString implementationClassUID() const;
  MString implementationVersionName() const;
  MString sourceApplicationEntityTitle() const;
  MString privateInformationCreatorUID() const;
  unsigned char* privateInformation() const;

  // A number of set methods that set one attribute value.  Use the method
  // name as a guide to the attribute.
  void filePreamble(unsigned char* s, int len = 128);
  void fileMetaInformationVersion(unsigned char* s, int len = 2);
  void mediaStorageSOPClassUID(const MString& s);
  void mediaStorageSOPInstanceUID(const MString& s);
  void transferSyntaxUID(const MString& s);
  void implementationClassUID(const MString& s);
  void implementationVersionName(const MString& s);
  void sourceApplicationEntityTitle(const MString& s);
  void privateInformationCreatorUID(const MString& s);
  void privateInformation(unsigned char* s, int len);


private:
  unsigned char mFilePreamble[128];
  int mFilePreambleLength;
  MString mMediaStorageSOPClassUID;
  MString mMediaStorageSOPInstanceUID;
  MString mTransferSyntaxUID;
  MString mImplementationClassUID;
  MString mImplementationVersionName;
  MString mSourceApplicationEntityTitle;
  MString mPrivateInformationCreatorUID;
  unsigned char* mPrivateInformation;
  int mPrivateInformationLength;
};

inline ostream& operator<< (ostream& s, const MDICOMFileMeta& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MDICOMFileMeta& c) {
  c.streamIn(s);
  return s;
}

#endif
