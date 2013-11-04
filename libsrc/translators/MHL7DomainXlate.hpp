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

// $Id: MHL7DomainXlate.hpp,v 1.13 2006/06/29 16:08:33 bhasselfeld Exp $ $Author: bhasselfeld $ $Revision: 1.13 $ $Date: 2006/06/29 16:08:33 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MHL7DomainXlate.hpp
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
//	$Revision: 1.13 $
//
//  = DATE RELEASED
//	$Date: 2006/06/29 16:08:33 $
//
//  = COMMENTS
//

#ifndef MHL7DomainXlateISIN
#define MHL7DomainXlateISIN

#include <iostream>
#include <string>

using namespace std;

class MHL7Msg;
class MDomainObject;
class MPatient;
class MVisit;
class MPlacerOrder;
class MFillerOrder;
class MOrder;

class MHL7DomainXlate
// = TITLE
///	Translate between domain objects and HL7 messages.
//
// = DESCRIPTION
/**	This class serves as a factory which translates between
	domain objects and HL7 messages.  Translation is defined for
	both directions. */

{
public:
  // = The standard methods in this framework.

  MHL7DomainXlate();
  ///< Default constructor

  MHL7DomainXlate(const MHL7DomainXlate& cpy);

  virtual ~MHL7DomainXlate();

  virtual void printOn(ostream& s) const;
  /**<\brief This method is used in conjunction with the streaming operator <<
  	     to print the current state of MHL7DomainXlate. */

  virtual void streamIn(istream& s);
  /**<\brief This method is used in conjunction with the streaming operator >>
    	     to read the current state of MHL7DomainXlate. */
  
  // = Class specific methods.
  int translateHL7(MHL7Msg& hl7, MPatient& patient) const;
  ///< Translate data from this HL7 message into a domain <{patient}> object.
  /**< Take data from the PID segment to build the <{patient}> object. */

  int translateHL7(MHL7Msg& hl7, MVisit& visit) const;
  ///< Translate data from this HL7 message into a domain <{visit}> object.
  /**< Take data from the PID/PV1 segments to build the <{visit}> object. */

  int translateHL7(MHL7Msg& hl7, MPlacerOrder& placerOrder) const;
  ///< Translate data from this HL7 message into a domain Placer Order object.
  /**< Take data from the PID/ORC/OBR segments to build the
       <{placerOrder}>. */

  int translateHL7(MHL7Msg& hl7, MFillerOrder& fillerOrder) const;
  ///< Translate data from this HL7 message into a domain Filler Order object.
  /**< Take data from the PID/ORC/OBR segments to build the
       <{fillerOrder}>. */

  int translateHL7(MHL7Msg& hl7, MOrder& order) const;
  ///< Translate data from this HL7 message into a domain Order object.
  /**< Take data from the PID/ORC/OBR segments to build the <{order}>. */

  int translateHL7(MHL7Msg& hl7, int index, MOrder& Order) const;
  ///< Translate data from this HL7 message into a domain Order object.
  /**< Take data from the PID/ORC/OBR segments to construct the
       order.  This method is used for messages with multiple orders.
       <{index}> defines which order to use. */


  /**\brief The following methods (translateDomain(...)) do just the opposite of what
   their counterpart (translateHL7(..)) functions do.  That is they take a
   given MDomainObject and insert values found into an existing HL7 message.
   The existing values in the HL7 message are replaced */
  int translateDomain(const MPatient& patient, MHL7Msg& hl7);

  int translateDomain(MHL7Msg& hl7, const MVisit& visit);

  int translateDomain(MHL7Msg& hl7, const MPlacerOrder& placerOrder);

  int translateDomain(MHL7Msg& hl7, const MFillerOrder& fillerOrder);

  int translateDomain(MHL7Msg& hl7, const MOrder& Order);

  int translateDomain(MHL7Msg& hl7, int index, const MOrder& Order);

  int translatePDQQPD3(const MString& s, MPatient& patient) const;


  typedef struct {
    char attribute[100];
    char segment[10];
    int  field;
    int  component;
  } HL7_MAP;

  int translateHL7(MHL7Msg& hl7, HL7_MAP* m, MDomainObject& o) const;
  int translateHL7(MHL7Msg& hl7, int index, HL7_MAP* m, MDomainObject& o) const;

  int translateDomain(MHL7Msg& hl7, HL7_MAP* m, const MDomainObject& o);
  int translateDomain(MHL7Msg& hl7, int index, HL7_MAP* m, const MDomainObject& o);

  void issuer1(const MString& issuer);
  void issuer2(const MString& issuer);

  MString issuer1( ) const;
  MString issuer2( ) const;

private:
  void orderMap(HL7_MAP** mapArg) const;
  int setPatientIDAttributes(const MString& patientIDList,
			     MPatient& patient) const;
  MString getPatientID(MString s, const MString& issuer) const;

  MString mIssuer1;
  MString mIssuer2;
};

inline ostream& operator<< (ostream& s, const MHL7DomainXlate& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MHL7DomainXlate& c) {
  c.streamIn(s);
  return s;
}

#endif
