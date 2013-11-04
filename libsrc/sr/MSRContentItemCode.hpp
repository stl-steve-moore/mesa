// $Id: MSRContentItemCode.hpp,v 1.5 2006/06/29 16:08:33 bhasselfeld Exp $ $Author: bhasselfeld $ $Revision: 1.5 $ $Date: 2006/06/29 16:08:33 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MSRContentItemCode.hpp
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
//	$Revision: 1.5 $
//
//  = DATE RELEASED
//	$Date: 2006/06/29 16:08:33 $
//
//  = COMMENTS
//

#ifndef MSRContentItemCodeISIN
#define MSRContentItemCodeISIN

#include "MSRContentItem.hpp"

using namespace std;

class MSRContentItemCode;

class MSRContentItemCode : public MSRContentItem
// = TITLE
///	A DICOM SR Content Item.
//
// = DESCRIPTION
/**	This class provides get/set methods for a content item. */
{
public:
  // = The standard methods in this framework.
  MSRContentItemCode();
  ///< Default constructor
  MSRContentItemCode(const MSRContentItemCode& cpy);
  virtual ~MSRContentItemCode();
  virtual void printOn(ostream& s) const;
  /**<\brief This method is used in conjunction with the streaming operator <<
	     to print the current state of MSRContentItemCode */

  virtual void streamIn(istream& s);
  
  // = Class specific methods.
  MSRContentItemCode(const MSRContentItem& contentItem);
  void conceptNameValue(const MString& s);
  void conceptNameDesignator(const MString& s);
  void conceptNameMeaning(const MString& s);
  void codeNameValue(const MString& s);
  void codeNameDesignator(const MString& s);
  void codeNameMeaning(const MString& s);

  MString conceptNameValue( ) const;
  MString conceptNameDesignator( ) const;
  MString conceptNameMeaning( ) const;
  MString codeNameValue( ) const;
  MString codeNameDesignator( ) const;
  MString codeNameMeaning( ) const;

  bool isLevel1Equivalent(MSRContentItem* rhs, bool verbose = false) const;

private:
  MString mConceptNameValue;
  MString mConceptNameDesignator;
  MString mConceptNameMeaning;

  MString mCodeNameValue;
  MString mCodeNameDesignator;
  MString mCodeNameMeaning;
};

inline ostream& operator<< (ostream& s, const MSRContentItemCode& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MSRContentItemCode& c) {
  c.streamIn(s);
  return s;
}

#endif
