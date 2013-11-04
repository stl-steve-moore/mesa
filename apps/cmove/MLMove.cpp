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
#include "MLMove.hpp"

MLMove::MLMove() :
  mVerbose(false),
  mCMoveStatus(0)
{
}

MLMove::MLMove(const MLMove& cpy) :
  mVerbose(cpy.mVerbose),
  mCMoveStatus(cpy.mCMoveStatus)
{
}

MLMove::~MLMove()
{
}

void
MLMove::printOn(ostream& s) const
{
  s << "MLMove";
}

void
MLMove::streamIn(istream& s)
{
  //s >> this->member;
}

// Non-boilerplate methods to follow

void
MLMove::verbose(bool v)
{
  mVerbose = v;
}

// virtual
CONDITION
MLMove::handleCMoveResponse(DUL_PRESENTATIONCONTEXT* ctx,
				 MSG_C_MOVE_RESP** message,
				 DUL_ASSOCIATESERVICEPARAMETERS* params,
				 const MString& queryLevel,
				 int index)
{
  if (mVerbose) {
    if ((*message)->conditionalFields & MSG_K_C_MOVE_REMAINING)
      cout << "Remaining operations: "
	   << (*message)->remainingSubOperations << endl;

    if ((*message)->conditionalFields & MSG_K_C_MOVE_COMPLETED)
      cout << "Completed operations: "
	   << (*message)->completedSubOperations << endl;

    if ((*message)->conditionalFields & MSG_K_C_MOVE_FAILED)
      cout << "   Failed operations: "
	   << (*message)->failedSubOperations << endl;

    if ((*message)->conditionalFields & MSG_K_C_MOVE_WARNING)
      cout << "  Warning operations: "
	   << (*message)->warningSubOperations << endl;
  }

  // a single cmove request can generate multiple responses, especially intermediate
  // responses giving number of suboperations remaining. The following conditional
  // detects those messages as failures.  The else clause is necessary to allow 
  // subsequent messages to restore the status to 0 if applicable.
  if ((((*message)->conditionalFields & MSG_K_C_MOVE_FAILED)!=0) && ((*message)->failedSubOperations != 0) ) {
    if (mVerbose) {
      cout << "MLMove::handleCMoveResponse setting status to 1 (failed)" << endl;
    }
    mCMoveStatus = 1;
  } else {
    if (mVerbose) {
      cout << "MLMove::handleCMoveResponse setting status to 0 (success)" << endl;
    }
    mCMoveStatus = 0;
  }
  return SRV_NORMAL;
}

int
MLMove::getStatus() const
{
  return mCMoveStatus;
}

