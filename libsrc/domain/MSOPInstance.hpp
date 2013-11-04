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

// $Id: MSOPInstance.hpp,v 1.14 2007/09/10 15:36:58 smm Exp $ $Author: smm $ $Revision: 1.14 $ $Date: 2007/09/10 15:36:58 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MSOPInstance.hpp
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
//	$Revision: 1.14 $
//
//  = DATE RELEASED
//	$Date: 2007/09/10 15:36:58 $
//
//  = COMMENTS

#ifndef MSOPInstanceISIN
#define MSOPInstanceISIN

#include <iostream>
#include "MDomainObject.hpp"

class MSOPInstance;
typedef vector < MSOPInstance > MSOPInstanceVector;

using namespace std;

class MSOPInstance : public MDomainObject
// = TITLE
///	A domain object that corresponds to a DICOM SOP Instance.
//
// = DESCRIPTION
/**	This class is a container for attributes which define a DICOM
	SOP Instance.  It inherits from <{MDomainObject}> and supports the
	ability to get and set values with specific methods.  Because this
	class is just a container, it performs no validation tests. */
{
public:
  // = The standard methods in this framework.

  MSOPInstance();
  ///< Default constructor

  MSOPInstance(const MSOPInstance& cpy);

  ~MSOPInstance();

  virtual void printOn(ostream& s) const;
  /**<\brief This method is used in conjunction with the streaming operator <<
  	     to print the current state of MSOPInstance. */

  virtual void streamIn(istream& s);
  /**<\brief This method is used in conjunction with the streaming operator >>
  	     to read the current state of MSOPInstance. */

  // = Class specific methods.

  MSOPInstance(const MString& seriesInstanceUID,
	       const MString& classUID, const MString& instanceUID,
	       const MString& instanceNumber,
	       const MString& fileName);
  /**<\brief This constructor takes a variable for each attribute that is managed
  	     by this object.  The values of the variables are copied to the internal
             state of the object. */

  void import(MDomainObject& o);
  ///< This method imports the key-value pairs from the MDomainObject <{o}>.
  /**< The values are copied from <{o}> and stored in the internal state
       maintained by this object. */

  MString seriesInstanceUID() const;
  ///< Return a copy of the Series Instance UID.  This is the link back to the series.

  MString classUID() const;
  ///< Return a copy of the SOP Class UID for the SOP instance.

  MString instanceUID() const;
  ///< Return a copy of the SOP Instance UID.

  MString instanceNumber() const;
  ///< Return a copy of the Instance Number.

  MString conceptNameCodeValue() const;
  ///< Return a copy of the Concept Name Code Value;

  MString conceptNameCodeScheme() const;
  ///< Return a copy of the Concept Name Coding Scheme Designator;

  MString conceptNameCodeVersion() const;
  ///< Return a copy of the Concept Name Coding Scheme Version;

  MString conceptNameCodeMeaning() const;
  ///< Return a copy of the Concept Name Code Meaning;

  MString fileName() const;
  ///< Return a copy of the name of the file which holds the SOP Instance.

  MString documentTitle() const;
  ///< Return a copy of the Document Title

  void seriesInstanceUID(const MString& s);
  ///< Set the value of Series Instance UID to the value in <{s}>.

  void classUID(const MString& s);
  ///< Set the value of SOP Class UID to the value in <{s}>.

  void instanceUID(const MString& s);
  ///< Set the value of SOP Instance UID to the value in <{s}>.

  void instanceNumber(const MString& s);
  ///< Set the value of Instance Number to the value in <{s}>.

  void rows(const MString& s);
  ///< Set the value of Rows to the value in <{s}>.

  void columns(const MString& s);
  ///< Set the value of Columns to the value in <{s}>.

  void bitsAllocated(const MString& s);
  ///< Set the value of Bits Allocated to the value in <{s}>.

  void numberOfFrames(const MString& s);
  ///< Set the value of Number of Frames to the value in <{s}>.

  void presentationLabel(const MString& s);
  ///< Set the value of Presentation Label to the value in <{s}>.

  void presentationDescription(const MString& s);
  ///< Set the value of Presentation Description to the value in <{s}>.

  void presentationCreationDate(const MString& s);
  ///< Set the value of Presentation Creation Date to the value in <{s}>.

  void presentationCreationTime(const MString& s);
  ///< Set the value of Presentation Creation Time to the value in <{s}>.

  void presentationCreatorsName(const MString& s);
  ///< Set the value of Presentation Creators Name to the value in <{s}>.

  void completionFlag(const MString& s);
  ///< Set the value of Completion Flag to the value in <{s}>.

  void verificationFlag(const MString& s);
  ///< Set the value of Verification Flag to the value in <{s}>.

  void contentDate(const MString& s);
  ///< Set the value of Content Date to the value in <{s}>.

  void contentTime(const MString& s);
  ///< Set the value of Content Time to the value in <{s}>.

  void observationDateTime(const MString& s);
  ///< Set the value of Observation DateTime to the value in <{s}>.

  void conceptNameCodeValue(const MString& s);
  ///< Set the value of Concept Name Code Value to the value in <{s}>.

  void conceptNameCodeScheme(const MString& s);
  ///< Set the value of Concept Name Coding Scheme Designator to the value in <{s}>.

  void conceptNameCodeVersion(const MString& s);
  ///< Set the value of Concept Name Coding Scheme Version to the value in <{s}>.

  void conceptNameCodeMeaning(const MString& s);
  ///< Set the value of Concept Name Code Meaning to the value in <{s}>.

  void fileName(const MString& s);
  ///< Set the value of the file name to the value in <{s}>.

  void documentTitle(const MString& s);
  ///< Set the value of the Document Title to the value in <{s}>.

private:
  MString mSeriesInstanceUID;
  MString mClassUID;
  MString mInstanceUID;
  MString mInstanceNumber;
  MString mRows;
  MString mColumns;
  MString mBitsAllocated;
  MString mNumberOfFrames;

  // Presentation State Specific
  MString mPresentationLabel;
  MString mPresentationDescription;
  MString mPresentationCreationDate;
  MString mPresentationCreationTime;
  MString mPresentationCreatorsName;

  // SR Specific
  MString mCompletionFlag;
  MString mVerificationFlag;
  MString mContentDate;
  MString mContentTime;
  MString mObservationDateTime;
  MString mConceptNameCodeValue;
  MString mConceptNameCodeScheme;
  MString mConceptNameCodeVersion;
  MString mConceptNameCodeMeaning;
  MString mDocTitle;

  MString mFileName;

  void fillMap();
};

inline ostream& operator<< (ostream& s, const MSOPInstance& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MSOPInstance& c) {
  c.streamIn(s);
  return s;
}

#endif
