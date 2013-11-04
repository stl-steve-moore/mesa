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

#include "MESA.hpp"
#include "MLMessenger.hpp"
#include "MHL7Msg.hpp"
#include "MHL7DomainXlate.hpp"
#include "MPatient.hpp"
#include "MVisit.hpp"
#include "MFillerOrder.hpp"
#include "MDBOrderFiller.hpp"

#if 0
MLMessenger::MLMessenger()
{
}
#endif

MLMessenger::MLMessenger(const MLMessenger& cpy) :
  MHL7Messenger(cpy.mFactory),
  mDatabase(cpy.mDatabase)
{
}

MLMessenger::~MLMessenger ()
{
}

void
MLMessenger::printOn(ostream& s) const
{
  s << "MLMessenger" << endl;
}

void
MLMessenger::streamIn(istream& s)
{
  //s >> this->member;
}

// Non-boiler plate methods follow below

MLMessenger::MLMessenger(MHL7Factory& factory, MDBOrderFiller& database) :
  MHL7Messenger(factory),
  mDatabase(database)
{
}

MLMessenger::acceptADT(MHL7Msg& message, const MString& event)
{
  MHL7DomainXlate xLate;
  MPatient patient;
  MVisit   visit;

  xLate.translateHL7(message, patient);
  xLate.translateHL7(message, visit);

  processInfo( event, patient, visit);

  cout << patient << endl;
  cout << visit << endl;

  return 0;  
}

MLMessenger::acceptORM(MHL7Msg& message, const MString& event)
{
  MHL7DomainXlate xLate;
  MPatient patient;
  MVisit visit;
//MFillerOrder fillerOrder;
  MFillerOrder fillerOrder("ID-00001", "Issuer", "PON-001", "FON-001", "ACC-001", "USID-001",
                           "NW", "PGN-001", "Status", "Quantity Timing", "Parent", "19991231120000",
                           "Saeed Akbani", "Ordering Provider", "Entering Organization",
                           "19991231120000");

  xLate.translateHL7(message, patient);
  cout << patient << endl;
  xLate.translateHL7(message, visit);
  cout << visit << endl;
//xlate.translateHL7(message, fillerOrder);
//cout << fillerOrder << endl;

  mDatabase.updateADTInfo(patient, visit);
  // send order control information down
  processInfo(event, message.getValue("ORC", 1, 1), patient, fillerOrder);

  cout << patient << endl;
  cout << fillerOrder << endl;

  return 0;  
}

void
MLMessenger::processInfo(const MString& event, const MPatient& patient, const MVisit& visit)
{
    if (event == "A01") 
        mDatabase.admitRegisterPatient(patient, visit);
    else if (event == "A02")
        ;
    else if (event == "A03")
        ;
    else
        processError("ADT", event, "");
}

void
MLMessenger::processInfo(const MString& event, const MString& orderControl,
                         const MPatient& patient, const MFillerOrder& fillerOrder)
{
  // There can be only two possibilities of trigger events:
  // O01: Order Message and O02: Order Response
  if (orderControl == "NW")
  {
    if (event == "O01") 
      mDatabase.enterOrder(patient, fillerOrder);
    else if (event == "O02")
      mDatabase.enterOrder(patient, fillerOrder);
    else
      orderError(event, orderControl);
  }  
  else if (orderControl == "OK")
    ;
  else if (orderControl == "UA")
    ;
  else if (orderControl == "CA")
    ;
  else if (orderControl == "OC")
  {
    if (event == "O01") 
      mDatabase.enterOrder(patient, fillerOrder);
    else if (event == "O02")
      mDatabase.enterOrder(patient, fillerOrder);
    else
      orderError(event, orderControl);
  }
  else if (orderControl == "CR")
    ;
  else if (orderControl == "UC")
    ;
  else
    orderError(event, orderControl);
}

void
MLMessenger::orderError(const MString& event, const MString& orderControl)
{
  MString additionalInfo("Order Control: ");
  additionalInfo += orderControl;
  
  processError("ORM", event, additionalInfo);
}

void
MLMessenger::processError(const MString& msgType, const MString& event, const MString& additionalInfo)
{
  cout << "(Messenger) Unknown Values HL7 Message";
  cerr << "Message Type: " << msgType << "Trigger Event: " << event << additionalInfo << endl;
}
