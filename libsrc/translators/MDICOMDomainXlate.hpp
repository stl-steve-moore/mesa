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

// $Id: MDICOMDomainXlate.hpp,v 1.27 2008/03/19 20:46:34 smm Exp $ $Author: smm $ $Revision: 1.27 $ $Date: 2008/03/19 20:46:34 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MDICOMDomainXlate.hpp
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
//	$Revision: 1.27 $
//
//  = DATE RELEASED
//	$Date: 2008/03/19 20:46:34 $
//
//  = COMMENTS
//

#ifndef MDICOMDomainXlateISIN
#define MDICOMDomainXlateISIN

#include <iostream>
#include <string>
#include "MActionItem.hpp"
#include "ctn_api.h"
#include "MGPPPSObject.hpp"
#include "MStationName.hpp"
#include "MPerfStationName.hpp"
#include "MStationClass.hpp"
#include "MPerfStationClass.hpp"
#include "MStationLocation.hpp"
#include "MPerfStationLocation.hpp"
#include "MPerfProcApps.hpp"
#include "MPerfWorkitem.hpp"
#include "MReqSubsWorkitem.hpp"
#include "MNonDCMOutput.hpp"
#include "MActHumanPerformers.hpp"
#include "MOutputInfo.hpp"
#include "MInputInfo.hpp"
#include "MRefGPSPS.hpp"
#include "MUWLScheduledStationNameCode.hpp"

using namespace std;

class MDICOMWrapper;
class MDomainObject;
class MPatient;
class MVisit;
class MPlacerOrder;
class MFillerOrder;
class MOrder;
class MStudy;
class MSeries;
class MSOPInstance;
class MPatientStudy;
class MMWL;
class MUPS;
class MUWLScheduledStationNameCode;
class MGPWorkitem;
class MGPPPSWorkitem;
class MSPS;
class MStorageCommitRequest;
class MStorageCommitResponse;
class MDICOMFileMeta;
class MDICOMDir;

class MDICOMDomainXlate
// = TITLE
///	Translate between domain objects and DICOM wrappers
//
// = DESCRIPTION
/**	This class serves as a factory which translates between
	domain objects and DICOM wrappers.  Translation is defined for
	both directions. 	*/

{
public:
  // = The standard methods in this framework.

  MDICOMDomainXlate();
  ///< Default constructor

  MDICOMDomainXlate(const MDICOMDomainXlate& cpy);

  virtual ~MDICOMDomainXlate();

  virtual void printOn(ostream& s) const;
  /**<\brief This method is used in conjunction with the streaming operator <<
  	     to print the current state of MDICOMDomainXlate. */

  virtual void streamIn(istream& s);
  /**<\brief This method is used in conjunction with the streaming operator <<
  	     to print the current state of MDICOMDomainXlate. */
  
  // = Class specific methods.

  /**<\brief A number of translation methods which translate from a DICOM wrapper
  	     to an MDomainObject.  Look at the signature of the method to identify
   	     the domain object. */
  int translateDICOM(MDICOMWrapper& dcm, MPatient& patient) const;

  int translateDICOM(MDICOMWrapper& dcm, MMWL& mwl) const;
  int translateDICOM(MDICOMWrapper& dcm, MUPS& ups) const;

  int translateDICOM(MDICOMWrapper& dcm, MGPWorkitem& workitem) const;

  int translateDICOM(MDICOMWrapper& dcm, MGPPPSWorkitem& workitem) const;

  int translateDICOM(MDICOMWrapper& dcm, MGPPPSObject& pps) const;

  int translateDICOM(MDICOMWrapper& dcm, MStudy& study) const;

  int translateDICOM(MDICOMWrapper& dcm, MSeries& series) const;

  int translateDICOM(MDICOMWrapper& dcm, MSOPInstance& sopInstance) const;

  int translateDICOM(MDICOMWrapper& dcm, MPatientStudy& patientStudy) const;

  int translateDICOM(MDICOMWrapper& dcm, MMWL& modalityWorkList,
		     MActionItemVector& actionItemVector) const;
  int translateDICOM(MDICOMWrapper& dcm, MUPS& ups,
		     MUWLScheduledStationNameCodeVector& schedStationNameCodeVector) const;

  int translateDICOM(MDICOMWrapper& dcm, MStationNameVector& snv) const;

  int translateDICOM(MDICOMWrapper& dcm, MPerfStationNameVector& snv) const;

  int translateDICOM(MDICOMWrapper& dcm, MStationClassVector& scv) const;

  int translateDICOM(MDICOMWrapper& dcm, MPerfStationClassVector& scv) const;

  int translateDICOM(MDICOMWrapper& dcm, MStationLocationVector& scv) const;

  int translateDICOM(MDICOMWrapper& dcm, MPerfStationLocationVector& scv) const;

  int translateDICOM(MDICOMWrapper& dcm, MPerfProcAppsVector& scv) const;

  int translateDICOM(MDICOMWrapper& dcm, MPerfWorkitemVector& scv) const;

  int translateDICOM(MDICOMWrapper& dcm, MReqSubsWorkitemVector& scv) const;

  int translateDICOM(MDICOMWrapper& dcm, MRefGPSPSVector& scv) const;

  int translateDICOM(MDICOMWrapper& dcm, MNonDCMOutputVector& scv) const;

  int translateDICOM(MDICOMWrapper& dcm, MActHumanPerformersVector& v) const;

  int translateDICOM(MDICOMWrapper& dcm, MOutputInfoVector& v) const;

  int translateDICOM(MDICOMWrapper& dcm, MInputInfoVector& v) const;

  int translateDICOM(MDICOMWrapper& dcm, MStorageCommitRequest& request);

  int translateDICOM(MDICOMWrapper& dcm, MStorageCommitResponse& response);

  int translateDICOM(MDICOMWrapper& dcm, MDICOMFileMeta& fileMeta) const;

  int translateDICOM(MDICOMWrapper& dcm, MDICOMDir& dir) const;

  /**<\brief A number of translation methods which translate from a domain object
  	     to a CTN DCM_OBJECT.   */
  /**< In the methods below, the user supplies both
       a template and a target.  The template defines which attributes are
       translated from the domain object.  This is useful for DICOM Q/R
       where the SCU's query object defines the return keys. */
  int translateDICOM(const MPatient& patient, DCM_OBJECT* templateObj,
		     DCM_OBJECT* target);

  int translateDICOM(const MStudy& study, DCM_OBJECT* templateObj,
		     DCM_OBJECT* target);

  int translateDICOM(const MSeries& series, DCM_OBJECT* templateObj,
		     DCM_OBJECT* target);

  int translateDICOM(const MSOPInstance& sopInstance, DCM_OBJECT* templateObj,
		     DCM_OBJECT* target);

  int translateDICOM(const MPatientStudy& patientStudy, DCM_OBJECT* templateObj,
		     DCM_OBJECT* target);

  int translateDICOM(const MMWL& modalityWorkList,
		     MActionItemVector& v,
		     DCM_OBJECT* templateObj, DCM_OBJECT* target);
  int translateDICOM(const MUPS& ups,
		     MUWLScheduledStationNameCodeVector& v,
		     DCM_OBJECT* templateObj, DCM_OBJECT* target);

  int translateDICOM(const MActHumanPerformersVector& v,
		     DCM_OBJECT* target);

  int translateDICOM(const MInputInfoVector& iiv,
		     DCM_OBJECT* templateObj, DCM_OBJECT* target);

  int translateDICOM(const MOutputInfoVector& iiv,
		     DCM_OBJECT* templateObj, DCM_OBJECT* target);

  int translateDICOM(const MGPWorkitem& workitem,
		     DCM_OBJECT* templateObj, DCM_OBJECT* target);

  int translateDICOM( MStationNameVector& snv,
		     DCM_OBJECT* templateObj, DCM_OBJECT* target);

  int translateDICOM( MPerfStationNameVector& snv,
		     DCM_OBJECT* templateObj, DCM_OBJECT* target);

  int translateDICOM( MStationClassVector& scv,
		     DCM_OBJECT* templateObj, DCM_OBJECT* target);

  int translateDICOM( MPerfStationClassVector& scv,
		     DCM_OBJECT* templateObj, DCM_OBJECT* target);

  int translateDICOM( MStationLocationVector& slv,
		     DCM_OBJECT* templateObj, DCM_OBJECT* target);

  int translateDICOM( MPerfStationLocationVector& slv,
		     DCM_OBJECT* templateObj, DCM_OBJECT* target);

  int translateDICOM( MPerfProcAppsVector& pav,
		     DCM_OBJECT* templateObj, DCM_OBJECT* target);

  int translateDICOM( MPerfWorkitemVector& pwiv,
		     DCM_OBJECT* templateObj, DCM_OBJECT* target);

  int translateDICOM( MReqSubsWorkitemVector& wiv,
		     DCM_OBJECT* templateObj, DCM_OBJECT* target);

  int translateDICOM( MNonDCMOutputVector& v,
		     DCM_OBJECT* templateObj, DCM_OBJECT* target);

  int translateDICOM( MRefGPSPSVector& v,
		     DCM_OBJECT* templateObj, DCM_OBJECT* target);

  int translateDICOM( MGPPPSWorkitem& workitem,
		     DCM_OBJECT* templateObj, DCM_OBJECT* target);

  int translateDICOM( MGPPPSObject& pps,
		     DCM_OBJECT* templateObj, DCM_OBJECT* target);

  int translateDICOM(const MPatient& patient, const U32* tags,
		 DCM_OBJECT* target);

  int translateDICOM(const MStorageCommitResponse& response,
		     DCM_OBJECT* target);

  int translateDICOM(const MDICOMFileMeta& f, DCM_OBJECT* target);
  int translateDICOM(const MDICOMFileMeta& f, MDICOMWrapper& targetWrapper);

  typedef struct {
    char attribute[100];
    U32 tag;
  } DICOM_MAP;

  typedef struct {
    char attribute[100];
    U32 seqTag;
    U32 itemTag;
  } DICOM_SEQMAP;

private:

  int translateDICOM(MDICOMWrapper& dcm, DICOM_MAP* m, MDomainObject& o) const;
  int translateDICOM(MDICOMWrapper& dcm, DICOM_SEQMAP* m, MDomainObject& o) const;

  int translateDICOM(DICOM_MAP* m, const MDomainObject& domainObj,
		     DCM_OBJECT* templateObj, DCM_OBJECT* target);

  int translateDICOM(DICOM_SEQMAP* m, const MDomainObject& domainObj,
		     DCM_OBJECT* templateObj, DCM_OBJECT* target);

  int translateDICOM(DICOM_SEQMAP* m, const MDomainObject& domainObj,
		     DCM_OBJECT* templateObj, DCM_OBJECT* target,
		     int index);

  int translateDICOM(DICOM_MAP* m, const MDomainObject& domainObj,
		     const U32* tags, DCM_OBJECT* target);
  int translateDICOM(DICOM_MAP* m, const MDomainObject& domainObj,
		     MDICOMWrapper& targetWrapper);

};

inline ostream& operator<< (ostream& s, const MDICOMDomainXlate& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MDICOMDomainXlate& c) {
  c.streamIn(s);
  return s;
}

#endif
