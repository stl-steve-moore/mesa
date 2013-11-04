// $Id: MSRContentItem.hpp,v 1.8 2006/06/29 16:08:33 bhasselfeld Exp $ $Author: bhasselfeld $ $Revision: 1.8 $ $Date: 2006/06/29 16:08:33 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MSRContentItem.hpp
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
//	$Revision: 1.8 $
//
//  = DATE RELEASED
//	$Date: 2006/06/29 16:08:33 $
//
//  = COMMENTS
//

#ifndef MSRContentItemISIN
#define MSRContentItemISIN

#include <iostream>
#include <string>

using namespace std;

class MSRContentItem;

typedef vector < MSRContentItem > MSRContentItemVector;

class MSRContentItem
// = TITLE
///	A DICOM SR Content Item.
//
// = DESCRIPTION
/**	This class provides get/set methods for a content item. */
{
public:
  // = The standard methods in this framework.
  MSRContentItem();
  ///< Default constructor
  MSRContentItem(const MSRContentItem& cpy);
  virtual ~MSRContentItem();
  virtual void printOn(ostream& s) const;
  /**<\brief This method is used in conjunction with the streaming operator <<
  	     to print the current state of MSRContentItem */

  virtual void streamIn(istream& s);
  
  // = Class specific methods.

  MString relationshipType( ) const;
  ///< Return the Relationship Type.

  MString valueType( ) const;
  ///< Return the Value Type;

  int nestLevel( ) const;
  ///< Return the nesting level of the item.

  void* objectReference( );
  ///< Return the object reference.

  void relationshipType(const MString& s);
  ///< Set the Relationship Type;

  void valueType(const MString& s);
  ///< Set the Value Type;

  void nestLevel(int l);
  ///< Set the nesting level of the item.

  void objectReference(void* p);
  ///< Set the object reference so we can pull out further attributes.

  bool isLeaf( ) const;
  ///< Return true if this is a leaf node; false otherwise.

  MSRContentItemVector& contentItemVector( );
  /**<\brief Returns a reference to a vector of content items contained
  	     by this content item. */

  bool isTypeEqual(const MSRContentItem& rhs) const;
  virtual bool isLevel1Equivalent(MSRContentItem* rhs, bool verbose = false) const;
  /**<\brief This method compares a content item to the content item in this
  	     object.  Level 1 equivalency is the form of the content item matches
	     and the content matches. */

  virtual bool isLevel2Equivalent(MSRContentItem* rhs, bool verbose = false) const;
  /**<\brief This method compares a content item to the content item in this
  	     object.  Level 2 equivalency is the form of the content item matches
	     but the content may differ.  For example, a reference to an image
	     can be different. */

private:
  MString mValueType;
  MString mRelationshipType;
  int mNestLevel;
  void* mObjectReference;
  MSRContentItemVector mContentItemVector;

};

inline ostream& operator<< (ostream& s, const MSRContentItem& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MSRContentItem& c) {
  c.streamIn(s);
  return s;
}

#endif
