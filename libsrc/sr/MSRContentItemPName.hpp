// $Id: MSRContentItemPName.hpp,v 1.4 2006/06/29 16:08:33 bhasselfeld Exp $ $Author: bhasselfeld $ $Revision: 1.4 $ $Date: 2006/06/29 16:08:33 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MSRContentItemPName.hpp
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

#ifndef MSRContentItemPNameISIN
#define MSRContentItemPNameISIN

#include "MSRContentItem.hpp"

using namespace std;

class MSRContentItemPName;

class MSRContentItemPName : public MSRContentItem
// = TITLE
///	A DICOM SR Content Item.
//
// = DESCRIPTION
/**	This class provides get/set methods for a content item. */
{
public:
  // = The standard methods in this framework.
  MSRContentItemPName();
  ///< Default constructor
  MSRContentItemPName(const MSRContentItemPName& cpy);
  virtual ~MSRContentItemPName();
  virtual void printOn(ostream& s) const;
  /**<\brief This method is used in conjunction with the streaming operator <<
  	     to print the current state of MSRContentItemPName */

  virtual void streamIn(istream& s);
  
  // = Class specific methods.
  MSRContentItemPName(const MSRContentItem& contentItem);
  void conceptNameValue(const MString& s);
  void conceptNameDesignator(const MString& s);
  void conceptNameMeaning(const MString& s);
  void personName(const MString& s);

  MString conceptNameValue( ) const;
  MString conceptNameDesignator( ) const;
  MString conceptNameMeaning( ) const;
  MString personName( ) const;

  bool isLevel1Equivalent(MSRContentItem* rhs, bool verbose = false) const;

private:
  MString mConceptNameValue;
  MString mConceptNameDesignator;
  MString mConceptNameMeaning;
  MString mPersonName;

};

inline ostream& operator<< (ostream& s, const MSRContentItemPName& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MSRContentItemPName& c) {
  c.streamIn(s);
  return s;
}

#endif
