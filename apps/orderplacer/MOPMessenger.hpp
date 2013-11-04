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

// ====================
//  = FILENAME
//	MOPMessenger.hpp (Mesa Order Placer Messenger)
//
//  = AUTHOR
//	FDS
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
//	$Date: 2000/05/09 19:03:56 $
//
//  = COMMENTTEXT
// Serves as the HL7 message interface for the Order Placer. Extends the
// MHL7Messenger class.

#include "MESA.hpp"
#include "MHL7Msg.hpp"
#include "MHL7Factory.hpp"
#include "MHL7Messenger.hpp"

// Tools to translate and insert HL7 messages into the database
#include "MHL7DomainXlate.hpp"
#include "MPatient.hpp"
#include "MDBADT.hpp"
#include "MDomainObject.hpp"
#include "MDBInterface.hpp"

using namespace std;

class MOPMessenger : public MHL7Messenger
{
public:
  MOPMessenger(MHL7Factory& factory);
  // Constructor with no Database reference. Should only be used for debugging.
  MOPMessenger(MHL7Factory& factory, MDBInterface& database);
  // Complete constructor with database reference.
  ~MOPMessenger();
  MOPMessenger(const MOPMessenger& cpy);
  // Copy constructor
  MOPMessenger* clone();
  // Creates a new OrderPlacer messenger copy.

protected:
  acceptHL7Message(MHL7Msg& message);
  // Method which does most of the work. Accepts an HL7 message and processes it.

private:
  MDBInterface& mDatabase;
  // The database reference for storing messages.   
};  
