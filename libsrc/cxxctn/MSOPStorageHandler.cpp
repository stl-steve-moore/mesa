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
#include "MSOPStorageHandler.hpp"

MSOPStorageHandler::MSOPStorageHandler()
{
}

MSOPStorageHandler::MSOPStorageHandler(const MSOPStorageHandler& cpy)
{
}

MSOPStorageHandler::~MSOPStorageHandler()
{
}

void
MSOPStorageHandler::printOn(ostream& s) const
{
  s << "MSOPStorageHandler";
}

void
MSOPStorageHandler::streamIn(istream& s)
{
  //s >> this->member;
}

// Non-boiler plate methods to follow below

// virtual
CONDITION
MSOPStorageHandler::handleCStoreCommand(DUL_PRESENTATIONCONTEXT* ctx,
					MSG_C_STORE_REQ** message,
					MSG_C_STORE_RESP* response,
					DUL_ASSOCIATESERVICEPARAMETERS* params,
					MString& fileName)
{
  cout << fileName << endl;

  return 0;
}

// virtual
CONDITION
MSOPStorageHandler::handleCStoreDataSet(DUL_PRESENTATIONCONTEXT* ctx,
					MSG_C_STORE_REQ** message,
					MSG_C_STORE_RESP* response,
					DUL_ASSOCIATESERVICEPARAMETERS* params,
					MString& fileName)
{
  cout << fileName << endl;

  return 0;
}