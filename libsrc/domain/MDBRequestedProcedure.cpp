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
#include "MDBRequestedProcedure.hpp"
#include "MRequestedProcedure.hpp"
#include "ctn_api.h"

MDBRequestedProcedure::MDBRequestedProcedure()
{
}

MDBRequestedProcedure::MDBRequestedProcedure(const MDBRequestedProcedure& cpy)
{
}

MDBRequestedProcedure::~MDBRequestedProcedure()
{
}

void
MDBRequestedProcedure::printOn(ostream& s) const
{
  s << "MDBRequestedProcedure";
}

void
MDBRequestedProcedure::streamIn(istream& s)
{
  //s >> this->member;
}

// Non-boilerplate methods follow

MDBRequestedProcedure::MDBRequestedProcedure(const string& databaseName)
{
  this->open(databaseName, "reqprocedure");
}

typedef struct {
  char studyInstUID[71];
  char reqProcID[31];
  char fillOrdNum[31];
  char accNum[31];
  char qtyTiming[31];
  char evnReason[31];
  char reqDtTm[31];
  char specSrc[31];
  char ordProvider[31];
  char reqProcDesc[81];
  char reqProcCodeSeq[31];
  char occNum[31];
  char apptTimQty[31];
} REQUESTED_PROCEDURE_STRUCT;

int MDBRequestedProcedure::insert(const MRequestedProcedure& reqProc)
{
  REQUESTED_PROCEDURE_STRUCT rp;
  TBL_FIELD f[] = {
    { "stuinsuid", TBL_STRING, sizeof(rp.studyInstUID), sizeof(rp.studyInstUID), 0,
      rp.studyInstUID},
    { "reqproid", TBL_STRING, sizeof(rp.reqProcID), sizeof(rp.reqProcID), 0,
      rp.reqProcID},
    { "filordnum", TBL_STRING, sizeof(rp.fillOrdNum), sizeof(rp.fillOrdNum), 0,
      rp.fillOrdNum},
    { "accnum", TBL_STRING, sizeof(rp.accNum), sizeof(rp.accNum), 0,
      rp.accNum},
    { "quatim", TBL_STRING, sizeof(rp.qtyTiming), sizeof(rp.qtyTiming), 0,
      rp.qtyTiming},
    { "everea", TBL_STRING, sizeof(rp.evnReason), sizeof(rp.evnReason), 0,
      rp.evnReason},
    { "reqdattim", TBL_STRING, sizeof(rp.reqDtTm), sizeof(rp.reqDtTm), 0,
      rp.reqDtTm},
    { "spesou", TBL_STRING, sizeof(rp.specSrc), sizeof(rp.specSrc), 0,
      rp.specSrc},
    { "ordpro", TBL_STRING, sizeof(rp.ordProvider), sizeof(rp.ordProvider), 0,
      rp.ordProvider},
    { "reqprodes", TBL_STRING, sizeof(rp.reqProcDesc), sizeof(rp.reqProcDesc), 0,
      rp.reqProcDesc},
    { "reqprocod", TBL_STRING, sizeof(rp.reqProcCodeSeq), sizeof(rp.reqProcCodeSeq), 
      0, rp.reqProcCodeSeq},
    { "occnum", TBL_STRING, sizeof(rp.occNum), sizeof(rp.occNum), 0,
      rp.occNum},
    { "apptimqua", TBL_STRING, sizeof(rp.apptTimQty), sizeof(rp.apptTimQty), 0,
      rp.apptTimQty},
    { 0, TBL_STRING, 0, 0, 0, 0 }
  };

  this->safeExport(reqProc.studyInstanceUID(), rp.studyInstUID, 
                   sizeof(rp.studyInstUID));
  this->safeExport(reqProc.requestedProcedureID(), rp.reqProcID, 
                   sizeof(rp.reqProcID));
  this->safeExport(reqProc.fillerOrderNumber(), rp.fillOrdNum, 
                   sizeof(rp.fillOrdNum));
  this->safeExport(reqProc.accessionNumber(), rp.accNum, sizeof(rp.accNum));
  this->safeExport(reqProc.quantityTiming(), rp.qtyTiming, sizeof(rp.qtyTiming));
  this->safeExport(reqProc.eventReason(), rp.evnReason, sizeof(rp.evnReason));
  this->safeExport(reqProc.requestedDateTime(), rp.reqDtTm, sizeof(rp.reqDtTm));
  this->safeExport(reqProc.specimenSource(), rp.specSrc, sizeof(rp.specSrc));
  this->safeExport(reqProc.orderingProvider(), rp.ordProvider, 
                   sizeof(rp.ordProvider));
  this->safeExport(reqProc.requestedProcedureDescription(), rp.reqProcDesc, 
                   sizeof(rp.reqProcDesc));
  this->safeExport(reqProc.requestedProcedureCodeSeq(), rp.reqProcCodeSeq, 
                   sizeof(rp.reqProcCodeSeq));
  this->safeExport(reqProc.occurrenceNumber(), rp.occNum, sizeof(rp.occNum)); 
  this->safeExport(reqProc.appointmentTimingQuantity(), rp.apptTimQty, sizeof(rp.apptTimQty));

  this->insertRow(f);
  return 0;
}
