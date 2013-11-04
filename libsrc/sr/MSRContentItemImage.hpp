// $Id: MSRContentItemImage.hpp,v 1.3 2006/06/29 16:08:33 bhasselfeld Exp $ $Author: bhasselfeld $ $Revision: 1.3 $ $Date: 2006/06/29 16:08:33 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MSRContentItemImage.hpp
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
//	$Revision: 1.3 $
//
//  = DATE RELEASED
//	$Date: 2006/06/29 16:08:33 $
//
//  = COMMENTS
//

#ifndef MSRContentItemImageISIN
#define MSRContentItemImageISIN

#include "MSRContentItem.hpp"

using namespace std;

class MSRContentItemImage;

class MSRContentItemImage : public MSRContentItem
// = TITLE
///	A DICOM SR Content Item.
//
// = DESCRIPTION
/**	This class provides get/set methods for a content item. */
{
public:
  // = The standard methods in this framework.
  MSRContentItemImage();
  ///< Default constructor
  MSRContentItemImage(const MSRContentItemImage& cpy);
  virtual ~MSRContentItemImage();
  virtual void printOn(ostream& s) const;
  /**<\brief This method is used in conjunction with the streaming operator <<
  	     to print the current state of MSRContentItemImage */

  virtual void streamIn(istream& s);
  
  // = Class specific methods.
  MSRContentItemImage(const MSRContentItem& contentItem);
  void imageRefSOPClass(const MString& s);
  void imageRefSOPInstance(const MString& s);

  MString imageRefSOPClass( ) const;
  MString imageRefSOPInstance( ) const;

  bool isLevel1Equivalent(MSRContentItem* rhs, bool verbose = false) const;
  bool isLevel2Equivalent(MSRContentItem* rhs, bool verbose = false) const;

private:
  MString mImageRefSOPClass;
  MString mImageRefSOPInstance;
};

inline ostream& operator<< (ostream& s, const MSRContentItemImage& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MSRContentItemImage& c) {
  c.streamIn(s);
  return s;
}

#endif
