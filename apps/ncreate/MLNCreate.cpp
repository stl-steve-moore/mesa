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
#include "MLNCreate.hpp"

MLNCreate::MLNCreate()
{
}

MLNCreate::MLNCreate(const MLNCreate& cpy)
{
}

MLNCreate::~MLNCreate()
{
}

void
MLNCreate::printOn(ostream& s) const
{
  s << "MLNCreate";
}

void
MLNCreate::streamIn(istream& s)
{
  //s >> this->member;
}

// Non-boilerplate methods to follow
// virtual
CONDITION
MLNCreate::handleNCreateResponse(DUL_PRESENTATIONCONTEXT* ctx,
				 MSG_N_CREATE_RESP** message,
				 DUL_ASSOCIATESERVICEPARAMETERS* params)
{
  ::MSG_DumpMessage(*message, stdout);

  if ((*message)->dataSetType != DCM_CMDDATANULL) {
    cout << "yada" << endl;
    ::DCM_DumpElements(&(*message)->dataSet, 1);
  }
  return SRV_NORMAL;
}
