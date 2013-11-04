
// $Id: MRequestAttribute.hpp,v 1.2 2006/06/29 16:08:31 bhasselfeld Exp $ $Author: bhasselfeld $ $Revision: 1.2 $ $Date: 2006/06/29 16:08:31 $ $State: Exp $
//
// ====================
//  = AUTHOR
//	Steve Moore
//
//  = COPYRIGHT
//	Copyright Washington University, 1999
//
// ====================
//
//  = VERSION
//	$Revision: 1.2 $
//
//  = DATE RELEASED
//	$Date: 2006/06/29 16:08:31 $
//
//  = COMMENTS

#ifndef MRequestAttributeISIN
#define MRequestAttributeISIN

#include <iostream>
#include "MDomainObject.hpp"

class MRequestAttribute;
typedef vector < MRequestAttribute > MRequestAttributeVector;

using namespace std;

class MRequestAttribute : public MDomainObject
// = TITLE
///	A domain object that corresponds to a DICOM Request Attribute sequence item.
//
// = DESCRIPTION
{
public:
  // = The standard methods in this framework.

  MRequestAttribute();
  ///< Default constructor

  MRequestAttribute(const MRequestAttribute& cpy);

  virtual ~MRequestAttribute();

  virtual void printOn(ostream& s) const;
  /**<\brief This method is used in conjunction with the streaming operator <<
  	     to print the current state of MRequestAttribute. */

  virtual void streamIn(istream& s);
  /**<\brief This method is used in conjunction with the streaming operator >>
  	     to read the current state of MRequestAttribute. */

  // = Class specific methods.

  MRequestAttribute(const MString& studyInstanceUID,
          const MString& requestedProcedureID,
	  const MString& scheduledProcedureStepID);
  /**<\brief This constructor takes a variable for each attribute that is managed
  	     by this object.  The values of the variables are copied to the internal
             state of the object. */

  void import(const MDomainObject& o);
  ///< This method imports the key-value pairs from the MDomainObject <{o}>.
  /** The values are copied from <{o}> and stored in the internal state
      maintained by this object. */

  // A number of get methods that return values.  Use the method name
  // as a guide to the attribute.
  MString seriesInstanceUID() const;
  MString requestedProcedureID() const;
  MString scheduledProcedureStepID() const;

  // A number of set methods that set one attribute value.  Use the method
  // name as a guide to the attribute.
  void seriesInstanceUID(const MString& s);
  void requestedProcedureID(const MString& s);
  void scheduledProcedureStepID(const MString& s);

private:
  MString mSeriesInstanceUID;
  MString mRequestedProcedureID;
  MString mScheduledProcedureStepID;
};

inline ostream& operator<< (ostream& s, const MRequestAttribute& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MRequestAttribute& c) {
  c.streamIn(s);
  return s;
}

#endif
