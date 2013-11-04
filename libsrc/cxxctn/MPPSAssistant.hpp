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

// $Id: MPPSAssistant.hpp,v 1.12 2006/06/29 16:08:29 bhasselfeld Exp $ $Author: bhasselfeld $ $Revision: 1.12 $ $Date: 2006/06/29 16:08:29 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MPPSAssistant.hpp
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
//	$Revision: 1.12 $
//
//  = DATE RELEASED
//	$Date: 2006/06/29 16:08:29 $
//
//  = COMMENTS

#ifndef MPPSAssistantISIN
#define MPPSAssistantISIN

#include <iostream>
#include <string>
#include "ctn_api.h"

using namespace std;

class MDICOMWrapper;

class MPPSAssistant
// = TITLE
///	Performs utility functions for MPPS implementations
//
// = DESCRIPTION
/**	This class performs some functions which are useful in the
	MPPS environment. */
{
public:
  // = The standard methods in this framework.

  MPPSAssistant();
  ///< Default constructor

  MPPSAssistant(const MPPSAssistant& cpy);
  ///< Copy constructor.

  virtual ~MPPSAssistant();
  ///< Destructor.

  virtual void printOn(ostream& s) const;
  /**<\brief This method is used in conjunction with the streaming operator <<
   to print the current state of MPPSAssistant. */

  virtual void streamIn(istream& s);
  /**<\brief This method is used in conjunction with the streaming operator >>
   to read the current state of MPPSAssistant. */

  // = Class specific methods.

  int validateNCreateDataSet(MDICOMWrapper& dataSet);
  /**<\brief Determine if the <{dataSet}> which is used in an MPPS N-Create
   operation is valid.  This method is unimplemented and returns 0. */

  int validateNSetDataSet(const MString& mppsObjectPath,
			  const MString& dataSetPath);
  /**<\brief Determine if the data set which would result from merging an existing
   data set with new data would be valid.
   This method is unimplemented and returns 0. */

  int mergeNSetDataSet(const MString& mppsObjectPath,
		       const MString& dataSetPath);
  /**<\brief This method is used to merge an existing MPPS state object with new
   data (typically received in an N-Set request).  */
  /**< In the argument list,
       <{mppsObjectPath}> is the full or relative path name to the existing
       MPPS state object.  <{dataSetPath}> is the path to the data to be updated
       (part of the N-Set command).  This method takes the attributes found
       in the file <{dataSetPath}> and places them in the file identified
       by <{mppsObjectPath}>.
       0 is returned on success.  -1 is returned on failure. */

  int mergeMWLPPSRelationship(MDICOMWrapper& mwl,
			      MDICOMWrapper& wrapper,
			      const MString& studyInstanceUID = "",
			      bool groupCaseFlag = false);
  /**<\brief This method is typically used by a modality.  It takes Modality
  // Worklist information found in <{mwl}> and merges it with information
  // already present in <{wrapper}>.  */
  /**< This method is specifically merging the information defined in the Performed Procedure Step Relationship
   Module (PS 3.3, C.14.3).
   If <{studyInstanceUID}> is not empty (""), then we use that
   Study Instance UID rather than the value found in the MWL.
   This may occur for IHE Group Case PPS.
   If <{groupCaseFlag}> is true, other differences based on
   the IHE Group Case are applied. */

  int mergeMWLPPSNCreate(MDICOMWrapper& mwl,
			 MDICOMWrapper& wrapper);
  ///< This method is unimplemented and returns 0.

  int addPerformedSeriesSequence(const MString& mppsObjectPath,
				 const MString& sopInstancePath);
  /**<\brief This method is typically used by a modality.  It adds Performed
   Series Sequence information (PS 3.3, C.14.5) to an existing MPPS
   object.  */
  /**< Call this method one time for each instancee to be included
     in the MPPS object.  In the argument list, <{mppsObjectPath}> is
     the full or relative path to the existing MPPS object.
     <{sopInstancePath}> is the path of the instance to be added to
     the PPS object.
     0 is returned on success.
    -1 is returned on failure. */

  void includePerformedProtocolCodes(bool flag);
  bool includePerformedProtocolCodes() const;

private:
  bool mIncludePerformedProtocolCodes;

  int mergeSimpleTags(DCM_TAG* tags, MDICOMWrapper& mppsWrapper,
		      MDICOMWrapper& dataSet);
  // For each tag in <{tags}>, merge the value from <{dataSet}> into
  // <{mppsWrapper}>.  Attribute must exist in <{mppsWrapper}> for
  // the merge to be successful.  (This is a set of an existing attribute.)

  int mergeSequences(DCM_TAG* tags, MDICOMWrapper& mppsWrapper,
		      MDICOMWrapper& dataSet);
  // For each tag in <{tags}>, take the sequence from <{dataSet}> and place
  // it in <{mppsWrapper}>.  Attributes must exist in <{mppsWrapper}> for
  // this to be successful.  This destroys the existing sequence in
  // <{mppsWrapper}> and also assumes ownership of the sequence items taken
  // from <{dataSet}>.  This is, this is a destructive operation on
  // <{dataSet}>.

  int addPerformedSeriesSequence(DCM_OBJECT** obj);
  // Add an empty Performed Series Sequence to <{obj}>.
  // 0 is returned on success.
  // The method exits with an error message on failure.

  int addPerformedSeriesSeqItem(DCM_OBJECT** mppsObj,
				DCM_OBJECT** sopObj);
  // Take information from <{sopObj}> and add Performed Series
  // Sequence information to <{mppsObj}>.

  int addRefImageSeq(DCM_OBJECT** target, DCM_OBJECT** src);
  // Create a Referenced Image Sequence in <{target}> if necessary
  // and enter reference SOP Instance information from <{src}>.

  int addRefStandaloneSOPSeq(DCM_OBJECT** target, DCM_OBJECT** src);
  // Add a Referenced Standalone SOP Sequence to <{target}>.
  // Needs to be completed to really supported Standalone SOP Instances.

  int addSeriesInformation(DCM_OBJECT** target, DCM_OBJECT** src);
  // Copy selected series attributes from <{src}> to <{target}>.

};

inline ostream& operator<< (ostream& s, const MPPSAssistant& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MPPSAssistant& c) {
  c.streamIn(s);
  return s;
}

#endif
