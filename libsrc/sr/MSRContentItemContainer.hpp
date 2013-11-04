// $Id: MSRContentItemContainer.hpp,v 1.3 2006/06/29 16:08:33 bhasselfeld Exp $ $Author: bhasselfeld $ $Revision: 1.3 $ $Date: 2006/06/29 16:08:33 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MSRContentItemContainer.hpp
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

#ifndef MSRContentItemContainerISIN
#define MSRContentItemContainerISIN

#include "MSRContentItem.hpp"

using namespace std;

class MSRContentItemContainer;

class MSRContentItemContainer : public MSRContentItem
// = TITLE
///	A DICOM SR Content Item.
//
// = DESCRIPTION
/**	This class provides get/set methods for a content item. */
{
public:
  // = The standard methods in this framework.
  MSRContentItemContainer();
  ///< Default constructor
  MSRContentItemContainer(const MSRContentItemContainer& cpy);
  virtual ~MSRContentItemContainer();
  virtual void printOn(ostream& s) const;
  /**<\brief This method is used in conjunction with the streaming operator <<
  	     to print the current state of MSRContentItemContainer */

  virtual void streamIn(istream& s);
  
  // = Class specific methods.
  MSRContentItemContainer(const MSRContentItem& contentItem);
  void conceptNameValue(const MString& s);
  void conceptNameDesignator(const MString& s);
  void conceptNameMeaning(const MString& s);

  MString conceptNameValue( ) const;
  MString conceptNameDesignator( ) const;
  MString conceptNameMeaning( ) const;

  virtual bool isLevel1Equivalent(MSRContentItem* rhs, bool verbose = false) const;
  virtual bool isLevel2Equivalent(MSRContentItem* rhs, bool verbose = false) const;

private:
  MString mConceptNameValue;
  MString mConceptNameDesignator;
  MString mConceptNameMeaning;

};

inline ostream& operator<< (ostream& s, const MSRContentItemContainer& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MSRContentItemContainer& c) {
  c.streamIn(s);
  return s;
}

#endif
