// $Id: MWrapperFactory.hpp,v 1.5 2006/06/29 16:08:29 bhasselfeld Exp $ $Author: bhasselfeld $ $Revision: 1.5 $ $Date: 2006/06/29 16:08:29 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MWrapperFactory.hpp
//
//  = AUTHOR
//	Steve Moore
//
//  = COPYRIGHT
//	Copyright Washington University, 1999
//
// ====================
//
//  = VERSION
//	$Revision: 1.5 $
//
//  = DATE RELEASED
//	$Date: 2006/06/29 16:08:29 $
//
//  = COMMENTS

#ifndef MWrapperFactoryISIN
#define MWrapperFactoryISIN

#include <iostream>
#include <string>
#include "ctn_api.h"
#include "MLogClient.hpp"

class MDICOMWrapper;

using namespace std;

typedef map < DCM_TAG, MString, less < DCM_TAG >  > MTagStringMap;
typedef vector < DCM_TAG  > MTagVector;

class MWrapperFactory
// = TITLE
///	A factory class which operates on DICOM Wrapper objects.
//
// = DESCRIPTION
{
public:
  // = The standard methods in this framework.

  MWrapperFactory();
  ///< Default constructor.

  MWrapperFactory(const MWrapperFactory& cpy);
  ///< Copy constructor

  virtual ~MWrapperFactory();
  ///< Destructor.

  virtual void printOn(ostream& s) const;
  /**<\brief This method is used in conjunction with the streaming operator <<
   to print the current state of MWrapperFactory. */

  virtual void streamIn(istream& s);
  /**<\brief This method is used in conjunction with the streaming operator >>
   to read the current state of MWrapperFactory. */

  // = Class specific methods.

  int modifyWrapper(MDICOMWrapper& w, const MString& fileName) const;
  /**<\brief For an existing wrapper, <{w}>, read the changes specified in the
   file <{fileName}> and apply the changes to the wrapper. */

  int retainTags(MDICOMWrapper& w, const MString& fileName) const;
  /**<\brief For an existing wrapper, <{w}>, read the tags specified in the
   file <{fileName}> and remove all tags not listed in the file.
   Tags are specified as gggg eeee, one per line. */

private:
  int processWrapperCommand(MDICOMWrapper& w, char* buf) const;
  //int apply(MDICOMWrapper& w, char* buf) const;
  int addAttribute(MDICOMWrapper& w, char* buf) const;
  int addSequence(MDICOMWrapper& w, char* buf) const;
  int addSequenceItem(MDICOMWrapper& w, char* buf) const;
  int removeAttribute(MDICOMWrapper& w, char* buf) const;
  int removeGroup(MDICOMWrapper& w, char* buf) const;
  int retainTags(MDICOMWrapper& w, MTagStringMap& m) const;
  int removePrivateGroups(MDICOMWrapper& w, char* buf) const;

};

inline ostream& operator<< (ostream& s, const MWrapperFactory& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MWrapperFactory& c) {
  c.streamIn(s);
  return s;
}

#endif
