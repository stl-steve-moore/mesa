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

// $Id: MSeries.hpp,v 1.13 2006/06/29 16:08:31 bhasselfeld Exp $ $Author: bhasselfeld $ $Revision: 1.13 $ $Date: 2006/06/29 16:08:31 $ $State: Exp $
//
// ====================
//  = AUTHOR
//	Saeed Akbani
//
//  = COPYRIGHT
//	Copyright HIMSS, RSNA, Washington University: 1999, 2000
//
// ====================
//
//  = VERSION
//	$Revision: 1.13 $
//
//  = DATE RELEASED
//	$Date: 2006/06/29 16:08:31 $
//
//  = COMMENTS

#ifndef MSeriesISIN
#define MSeriesISIN

#include <iostream>
#include "MDomainObject.hpp"
#include "MRequestAttribute.hpp"

class MSeries;
typedef vector < MSeries > MSeriesVector;

using namespace std;

class MSeries : public MDomainObject
// = TITLE
///	A domain object that corresponds to a DICOM series.
//
// = DESCRIPTION
/**	This class is a container for attributes which define a DICOM
	series.  It inherits from <{MDomainObject}> and supports the
	ability to get and set values with specific methods.  Because this
	class is just a container, it performs no validation tests. */
{
public:
  // = The standard methods in this framework.

  MSeries();
  ///< Default constructor

  MSeries(const MSeries& cpy);

  ~MSeries();

  virtual void printOn(ostream& s) const;
  /**<\brief This method is used in conjunction with the streaming operator <<
  	     to print the current state of MSeries. */

  virtual void streamIn(istream& s);
  /**<\brief This method is used in conjunction with the streaming operator >>
  	     to read the current state of MSeries. */

  // = Class specific methods.

  MSeries(const MString& studyInstanceUID, const MString& seriesInstanceUID,
          const MString& modality, const MString& seriesNumber,
          const MString& protocolName, const MString& seriesDescription,
	  const MString& seriesDate, const MString& numberSeriesRelatedInstances);
  /**<\brief This constructor takes a variable for each attribute that is managed
  	     by this object.  The values of the variables are copied to the internal
   	     state of the object. */

  void import(const MDomainObject& o);
  ///< This method imports the key-value pairs from the MDomainObject <{o}>.
  /**< The values are copied from <{o}> and stored in the internal state
       maintained by this object. */

  // A number of get methods that return values.  Use the method name
  // as a guide to the attribute.
  MString studyInstanceUID() const;
  MString seriesInstanceUID() const;
  MString modality() const;
  MString seriesNumber() const;
  MString protocolName() const;
  MString seriesDescription() const;
  MString seriesDate() const;
  MString numberSeriesRelatedInstances() const;
  MString timeSeriesLastModified() const;

  int numberRequestAttributes() const;
  MRequestAttribute requestAttribute(int index);

  // A number of set methods that set one attribute value.  Use the method
  // name as a guide to the attribute.
  void studyInstanceUID(const MString& s);
  void seriesInstanceUID(const MString& s);
  void modality(const MString& s);
  void seriesNumber(const MString& s);
  void protocolName(const MString& s);
  void seriesDescription(const MString& s);
  void seriesDate(const MString& s);
  void numberSeriesRelatedInstances(const MString& s);
  void numberSeriesRelatedInstances(int c);
  void timeSeriesLastModified(const MString& s);
  void addRequestAttribute(const MRequestAttribute& s);

private:
  MString mStudyInstanceUID;
  MString mSeriesInstanceUID;
  MString mModality;
  MString mSeriesNumber;
  MString mProtocolName;
  MString mSeriesDescription;
  MString mSeriesDate;
  MString mNumberSeriesRelatedInstances;
  MString mTimeLastModified;
  MRequestAttributeVector mRequestAttributeVector;

  void fillMap();
};

inline ostream& operator<< (ostream& s, const MSeries& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MSeries& c) {
  c.streamIn(s);
  return s;
}

#endif
