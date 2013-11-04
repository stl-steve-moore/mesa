// $Id: MCompositeObjectFactory.hpp,v 1.2 2006/06/29 16:08:29 bhasselfeld Exp $ $Author: bhasselfeld $ $Revision: 1.2 $ $Date: 2006/06/29 16:08:29 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MCompositeObjectFactory.hpp
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
//	$Revision: 1.2 $
//
//  = DATE RELEASED
//	$Date: 2006/06/29 16:08:29 $
//
//  = COMMENTS

#ifndef MCompositeObjectFactoryISIN
#define MCompositeObjectFactoryISIN

#include <iostream>
#include <string>
#include "ctn_api.h"
#include "MLogClient.hpp"

class MDICOMWrapper;

using namespace std;

class MCompositeObjectFactory
// = TITLE
/**\brief	A factory class the operates on DICOM Composite
//		objects and knows something about what a Composite
//		Object should contain.
*/
// = DESCRIPTION
{
public:
  // = The standard methods in this framework.

  MCompositeObjectFactory();
  ///< Default constructor.

  MCompositeObjectFactory(const MCompositeObjectFactory& cpy);
  ///< Copy constructor

  virtual ~MCompositeObjectFactory();
  ///< Destructor.

  virtual void printOn(ostream& s) const;
  /**<\brief This method is used in conjunction with the streaming operator <<
   to print the current state of MCompositeObjectFactory. */

  virtual void streamIn(istream& s);
  /**<\brief This method is used in conjunction with the streaming operator >>
  to read the current state of MCompositeObjectFactory. */

  // = Class specific methods.

  int copyPatient(MDICOMWrapper& src, MDICOMWrapper& target);
  ///< Copy the Patient Module attributes from <{src}> to <{target}>.

  int copyGeneralStudy(MDICOMWrapper& target, MDICOMWrapper& src);
  ///< Copy the General Study Module attributes from <{src}> to <{target}>.

  int copyPatientStudy(MDICOMWrapper& target, MDICOMWrapper& src);
  ///< Copy the Patient Study Module attributes from <{src}> to <{target}>.

  int copyGeneralSeries(MDICOMWrapper& target, MDICOMWrapper& src);
  ///< Copy the General Series Module attributes from <{src}> to <{target}>.

  int copyGeneralEquipment(MDICOMWrapper& target, MDICOMWrapper& src);
  ///< Copy the General Equipment Module attributes from <{src}> to <{target}>.

  int setSOPCommon(MDICOMWrapper& target,
	const MString& classUID, const MString& instanceUID,
	const MString& charSet = "",  const MString& creationDate = "",
	const MString& creationtime = "", const MString& creatorUID = "");
  ///< Set attributes of the SOP Common module.  
  /**<The values <{classUID}> and <{instanceUID}>.  
  Other optional values are not set in the target if the user passes them as empty strings. */

  int setPresentationState(MDICOMWrapper& target,
	const MString& instanceNumber, const MString& presentationLabel,
	const MString& presentationDescription, const MString& creatorsName,
	const MStringVector& imageFiles);

  int addReferencedSeriesSequence(MDICOMWrapper& target,
	const MStringVector& imageFiles);

private:
  int copyAttributes(MDICOMWrapper& target, MDICOMWrapper& src,
	DCM_TAG* tags, int count);
  int addReferencedImage(MDICOMWrapper& target, const MString& seriesUID,
	const MString& sopClass, const MString& sopInstance);

};

inline ostream& operator<< (ostream& s, const MCompositeObjectFactory& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MCompositeObjectFactory& c) {
  c.streamIn(s);
  return s;
}

#endif
