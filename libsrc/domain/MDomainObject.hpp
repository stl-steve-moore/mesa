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

// $Id: MDomainObject.hpp,v 1.15 2006/06/29 16:08:30 bhasselfeld Exp $ $Author: bhasselfeld $ $Revision: 1.15 $ $Date: 2006/06/29 16:08:30 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MDomainObject.hpp
//
//  = AUTHOR
//	Steve Moore
//
//  = COPYRIGHT
//	Copyright HIMSS, RSNA, Washington University: 1999, 2000
//
// ====================
//
//  = VERSION
//	$Revision: 1.15 $
//
//  = DATE RELEASED
//	$Date: 2006/06/29 16:08:30 $
//
//  = COMMENTS
//

#ifndef MDomainObjectISIN
#define MDomainObjectISIN

#include <iostream>
#include <map>
#include <set>
#include "MString.hpp" 

using namespace std;

typedef map < MString, MString, less <MString> > MDomainMap;
typedef pair < MString, MString > MDomainPair;
typedef set < MString, less <MString> > MDBAttributes;

typedef enum {
  GET_FIRST,
  GET_NEXT,
} MDOMAIN_FUNCTION;

class MDomainObject
// = TITLE
///	A base class for domain objects.
//
// = DESCRIPTION
/**	This class is a base class for domain objects.  It provides
	a string which identifies a table name in a relational database
	and a map of key words to values.  Specific domain objects will
	inherit from this class to provide mappings of specific attributes
	by names of methods. */
{
public:
  // = The standard methods in this framework.

  MDomainObject();
  ///< Default constructor.

  MDomainObject(const MDomainObject& cpy);
  ///< Copy constructor.

  virtual ~MDomainObject();

  virtual void printOn(ostream& s) const;

  virtual void streamIn(istream& s);

  // Class specific methods.

  MDomainObject(const MString& tableName, const MDomainMap& map);
  ///< Constructor.  
  /**< The domain object is mapped to a table named <{tableName}>
       in a relational database.  The <{map}> in the argument list is used
       to map values to key-words.  This map is copied into the domain object. */

  void exportAttributes(MDomainMap& m);
  ///< This method provides database values to an outsider.  
  /**< The caller provides an MDomainMap <{m}> which is filled by this method.  The method does
       <{not}> clear the MDomainMap before filling it. */

  MString tableName() const;
  ///< Return the name of the table associated with this domain object.

  const MDomainMap& map() const;
  ///< Return a reference to the internal map which links key-names with values.  
  /**< A <{const}> reference is returned, so the caller
       cannot modify the map. */

  MDBAttributes& dbAttributes();
  ///< Returns a reference to the set of attribute names for this domain object.

  void tableName(const MString& s);
  ///< This domain object corresponds to a table in a relational database.
  /**< In this method, set the name of the table according to the value in <{s}>. */

  void map(const MDomainMap& m);
  ///< Copy in an entire new domain map from the caller's map <{m}>.  
  /**< This map replaces all values currently stored in the internal map. */

  void dbAttributes(const MDBAttributes& a);
  ///< Copy in a new set of database attributes from the caller's set <{a}>. This method replaces all attribute names.

  bool mapEmpty() const;
  ///< Returns <{true}> if the internal map is empty (no attributes stored) and <{false}> if not.

  int mapSize() const;
  ///< Returns the number of value stored in the internal map.

  int numAttributes() const;
  ///< Returns the number of attributes which are defined for the domain object.  
  /**< This does not mean that all attributes have values, so this
       value can differ from that returned by <{mapSize()}>. */

  void insert(const MString& key, const MString& value);
  ///< Insert a DB attribute if it does not exist and assign it a value.
  /**< In the argument list, <{key}> is the name of the attribute. */

  void insert(const MString& key, int value);
  ///< Insert a DB attribute if it does not exist and assign it a value.
  /**< In the argument list, <{key}> is the name of the attribute. */

  void insert(const MString& key);
  ///< Insert the attribute with name <{key}> into the set of attributes managed by this domain object.  
  /**< Do not perform any action associated with the value for this key. */

  void remove(const MString& key);
  ///< Remove the value associated with <{key}> from the internal attribute map.

  MString value(const MString& key) const;
  ///< Returns the value associated with the attribute named by <{key}>.
  /**< If no such value exists, return the empty string (""). */

  void bindAttributeInteger(const MString& key);
  ///< Bind this attribute to an Integer type. Lower level database operations may care.

  MString attributeType(const MString& key);

private:

protected:
  MString mTableName;
  MDomainMap mMap; ///< contains mapping as <database attr, value>
  MDBAttributes mDBAttributes; ///< contains all the database attributes
  MStringMap mAttributeTypes;
};

inline ostream& operator<< (ostream& s, const MDomainObject& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MDomainObject& c) {
  c.streamIn(s);
  return s;
}

#endif
