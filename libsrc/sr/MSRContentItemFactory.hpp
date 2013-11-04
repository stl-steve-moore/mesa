// $Id: MSRContentItemFactory.hpp,v 1.4 2006/06/29 16:08:33 bhasselfeld Exp $ $Author: bhasselfeld $ $Revision: 1.4 $ $Date: 2006/06/29 16:08:33 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MSRContentItemFactory.hpp
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

#ifndef MSRContentItemFactoryISIN
#define MSRContentItemFactoryISIN

using namespace std;

class MSRContentItem;

class MSRContentItemFactory
// = TITLE
///	A DICOM SR Content ItemFactory.
//
// = DESCRIPTION
/**	This class provides get/set methods for a content item. */
{
public:
  // = The standard methods in this framework.
  MSRContentItemFactory();
  ///< Default constructor
  MSRContentItemFactory(const MSRContentItemFactory& cpy);
  virtual ~MSRContentItemFactory();
  virtual void printOn(ostream& s) const;
  /**<\brief This method is used in conjunction with the streaming operator <<
  	     to print the current state of MSRContentItemFactory */

  virtual void streamIn(istream& s);
  
  // = Class specific methods.

  MSRContentItem* produceContentItem(MSRContentItem& item);


private:
  MSRContentItem* produceContentItemCode(MSRContentItem& item);
  MSRContentItem* produceContentItemContainer(MSRContentItem& item);
  MSRContentItem* produceContentItemImage(MSRContentItem& item);
  MSRContentItem* produceContentItemPName(MSRContentItem& item);
  MSRContentItem* produceContentItemText(MSRContentItem& item);
};

inline ostream& operator<< (ostream& s, const MSRContentItemFactory& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MSRContentItemFactory& c) {
  c.streamIn(s);
  return s;
}

#endif
