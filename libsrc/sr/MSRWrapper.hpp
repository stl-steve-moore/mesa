// $Id: MSRWrapper.hpp,v 1.4 2006/06/29 16:08:33 bhasselfeld Exp $ $Author: bhasselfeld $ $Revision: 1.4 $ $Date: 2006/06/29 16:08:33 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MSRWrapper.hpp
//
//  = AUTHOR
//	Steve Moore
//
//  = COPYRIGHT
//	Copyright Washington University, 2000
//
// ====================
//
//  = VERSION
//	$Revision: 1.4 $
//
//  = DATE RELEASED
//	$Date: 2006/06/29 16:08:33 $
//
//  = COMMENTS
//

#ifndef MSRWrapperISIN
#define MSRWrapperISIN

#include <iostream>
#include <string>

#include "MDICOMWrapper.hpp"
#include "MCodeItem.hpp"
#include "MSRContentItem.hpp"

using namespace std;

class MSRWrapper : public MDICOMWrapper
// = TITLE
///	A wrapper for DICOM SR objects.
//
// = DESCRIPTION
/**	This class provides access to the contents of DICOM SR objects. */
{
public:
  // = The standard methods in this framework.
  MSRWrapper();
  ///< Default constructor
  MSRWrapper(const MSRWrapper& cpy);
  virtual ~MSRWrapper();
  virtual void printOn(ostream& s) const;
  /**<\brief This method is used in conjunction with the streaming operator <<
  	     to print the current state of MSRWrapper */

  virtual void streamIn(istream& s);
  
  // = Class specific methods.
  MSRWrapper(const MString& fileName);
  ///< This constructor associates a file name with the wrapper. The file is not actually read.

  int expandSRTree( );
  ///< Open the associated file and create internal lists of content items.

  MSRContentItemVector& contentItemVector( );
  ///< Return a reference to the internal vector of content items.

private:
  MCodeItem mDocumentTitle;
  MSRContentItemVector mContentItemVector;

  int readContentVector(int nestLevel, DCM_OBJECT** obj,
			MSRContentItemVector& v);
};

inline ostream& operator<< (ostream& s, const MSRWrapper& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MSRWrapper& c) {
  c.streamIn(s);
  return s;
}

#endif
