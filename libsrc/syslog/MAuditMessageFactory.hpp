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

// $Id: MAuditMessageFactory.hpp,v 1.14 2006/06/29 16:08:33 bhasselfeld Exp $ $Author: bhasselfeld $ $Revision: 1.14 $ $Date: 2006/06/29 16:08:33 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MAuditMessageFactory.hpp
//
//  = AUTHOR
//	Steve Moore
//
//  = COPYRIGHT
//	Copyright HIMSS, RSNA, Washington University: 2002
//
// ====================
//
//  = VERSION
//	$Revision: 1.14 $
//
//  = DATE RELEASED
//	$Date: 2006/06/29 16:08:33 $
//
//  = COMMENTS

#ifndef MAuditMessageFactoryISIN
#define MAuditMessageFactoryISIN

using namespace std;

class MAuditMessage;

class MAuditMessageFactory
// = TITLE
//	MAuditMessageFactory -
//
// = DESCRIPTION

{
public:
  // = The standard methods in this framework.

  MAuditMessageFactory();
  ///< Default constructor

  MAuditMessageFactory(const MAuditMessageFactory& cpy);
  ///< Copy constructor

  virtual ~MAuditMessageFactory();
  ///< Destructor

  virtual void printOn(ostream& s) const;
  /**<\brief This method is used in conjunction with the streaming operator <<
  	     to print the current state of MAuditMessageFactory */

  virtual void streamIn(istream& s);
  /**<\brief This method is used in conjuction with the streaming operator >>
  	     to read the current state of MAuditMessageFactory. */
  
  // = Class specific methods.

  MAuditMessage* produceMessage(const MString& messageType,
				const MString& fileName);

protected:

private:
  MAuditMessage* produceStartup(MStringMap& mp);
  MAuditMessage* produceActorConfig(MStringMap& mp);
  MAuditMessage* producePHIExport(const MString& fileName);
  MAuditMessage* producePHIPrint(const MString& fileName);
  MAuditMessage* producePHIImport(const MString& fileName);
  MAuditMessage* producePatientRecord(MStringMap& mp);
  MAuditMessage* produceOrderRecord(const MString& fileName);
  MAuditMessage* produceProcedureRecord(MStringMap& mp);
  MAuditMessage* produceModalityWorklistProvided(MStringMap& mp);
  MAuditMessage* produceBeginStoringInstances(MStringMap& mp);
  MAuditMessage* produceInstancesSent(MStringMap& m);
  MAuditMessage* produceInstancesUsed(MStringMap& m);
  MAuditMessage* produceInstancesDeleted(const MString& fileName);
  MAuditMessage* produceImageAvailabilityQuery(const MString& fileName);
  MAuditMessage* produceRetrieveInstances(const MString& fileName);
  MAuditMessage* produceStudyObject(const MString& fileName);
  MAuditMessage* produceStudyDeleted(const MString& fileName);
  MAuditMessage* produceInstancesStored(MStringMap& m);
  MAuditMessage* produceInstancesRetrieved(const MString& fileName);
  MAuditMessage* producePrintRequest(const MString& fileName);
  MAuditMessage* produceBegingStoringReports(const MString& fileName);
  MAuditMessage* produceReportsObject(const MString& fileName);
  MAuditMessage* produceQueryReports(const MString& fileName);
  MAuditMessage* produceExportReports(const MString& fileName);
  MAuditMessage* produceNodeAuthenticationFailure(const MString& fileName);
  MAuditMessage* produceUserAuthenticated(MStringMap& mp);
  MAuditMessage* produceAuditLogUsed(const MString& fileName);
  MAuditMessage* produceMobileMachine(const MString& fileName);
  MAuditMessage* produceQueryImages(MStringMap& mp);
  MAuditMessage* produceQueryPresentationStates(const MString& fileName);
  MAuditMessage* produceQueryKeyImageNotes(const MString& fileName);
  MAuditMessage* produceRetrieveImages(const MString& fileName);
  MAuditMessage* produceRetrievePresentationStates(const MString& fileName);
  MAuditMessage* produceRetrieveKeyImageNotes(const MString& fileName);
  MAuditMessage* produceRetrieveReports(const MString& fileName);
  MAuditMessage* produceDICOMQuery(MStringMap& mp);
  MAuditMessage* produceAtnaStartup(MStringMap& mp);
  MAuditMessage* produceAtnaActorConfig(MStringMap& mp);
  MAuditMessage* produceAtnaUserAuthenticated(MStringMap& mp);
  MAuditMessage* produceAtnaPatientRecord(MStringMap& mp);
};

inline ostream& operator<< (ostream& s, const MAuditMessageFactory& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MAuditMessageFactory& c) {
  c.streamIn(s);
  return s;
}

#endif
