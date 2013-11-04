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

// $Id: MDBIMClient.hpp,v 1.8 2006/06/29 16:08:29 bhasselfeld Exp $ $Author: bhasselfeld $ $Revision: 1.8 $ $Date: 2006/06/29 16:08:29 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MDBIMClient.hpp
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
//	$Revision: 1.8 $
//
//  = DATE RELEASED
//	$Date: 2006/06/29 16:08:29 $
//
//  = COMMENTS

#ifndef MDBIMClientISIN
#define MDBIMClientISIN

#include <iostream>
#include <string>

#include "MPatient.hpp"
#include "MStudy.hpp"
#include "MSeries.hpp"
#include "MSOPInstance.hpp"
#include "MPatientStudy.hpp"
#include "MWorkOrder.hpp"

using namespace std;

class MDBIMClient
// = TITLE
/**\brief	A base class which provides the methods for other
	classes to inherit and implement so that they can use the
	MDBImageManager.
*/
// = DESCRIPTION
/**	To use select functions of the MDBImageManager, override the
	virtual callback methods defined for this class.  These methods
	are invoked for each row retrieved from the database.
*/
{
public:
  // = The standard methods in this framework.
  MDBIMClient();
  ///< Default constructor
  MDBIMClient(const MDBIMClient& cpy);

 
 virtual ~MDBIMClient();
  virtual void printOn(ostream& s) const;
  /**<\brief This method is used in conjunction with the streaming operator <<
   to print the current state of MDBIMClient. */

  virtual void streamIn(istream& s);
  
  // = Class specific methods.

  virtual int selectCallback(const MPatient& patient, const MStudy& study,
			     const MSeries& series,
			     const MSOPInstance& sopInstance);
  /**<\brief This method defines the select callback when the MDBImageManager
   finds rows in the table which matches select criteria using the
   Patient root model. */  
  /**< Users override this method.  In the argument
   list, <{patient}>, <{study}>, <{series}> and <{sopInstance}> are
   filled in by the MDBImageManager and presented to the user.
   Your method should return 0 if the row is processed successfully
   and -1 if not. */

  virtual int selectCallback(const MPatientStudy& patientStudy,
			     const MSeries& series,
			     const MSOPInstance& sopInstance);
  /**<\brief This method defines the select callback when the MDBImageManager
   finds rows in the table which matches select criteria using the
   Study root model.  */
  /**< Users override this method.  In the argument
   list, <{patientStudy}>, <{series}> and <{sopInstance}> are
   filled in by the MDBImageManager and presented to the user.
   Your method shout return 0 if the row is processed successfully
   and -1 if not. */

  virtual int selectCallback(const MWorkOrder& workOrder);
  /**<\brief This method defines the select callback when the MDBImageManager
   finds rows in the Work Order table which matches select criteria */
  /**< Users override this method.  In the argument
   list, <{workOrder}> is
   filled in by the MDBImageManager and presented to the user.
   Your method shout return 0 if the row is processed successfully
   and -1 if not. */
private:
};

inline ostream& operator<< (ostream& s, const MDBIMClient& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MDBIMClient& c) {
  c.streamIn(s);
  return s;
}

#endif
