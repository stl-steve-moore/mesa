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
#include "MLQuery.hpp"
#include "MDICOMWrapper.hpp"

#if 0
MLQuery::MLQuery()
{
}
#endif

MLQuery::MLQuery(const MLQuery& cpy)
{
}

MLQuery::~MLQuery()
{
}

void
MLQuery::printOn(ostream& s) const
{
  s << "MLQuery";
}

void
MLQuery::streamIn(istream& s)
{
  //s >> this->member;
}

// Non-boilerplate methods to follow

MLQuery::MLQuery(const MString& path) :
  mMsgnum(1)
{
  mPath = path.strData();
}

void
MLQuery::setMessageNumber(int num) {
  mMsgnum = num;
}


// virtual
CONDITION
MLQuery::handleCFindResponse(DUL_PRESENTATIONCONTEXT* ctx,
				 MSG_C_FIND_RESP** message,
				 DUL_ASSOCIATESERVICEPARAMETERS* params,
				 const MString& queryLevel,
				 int index)
{
  if ((*message)->dataSetType != DCM_CMDDATANULL) {
    if (mPath != NULL && mPath[0] != 0) {
      char filename[256];
      sprintf(filename, "%s/msg%d_result.dcm", mPath, mMsgnum);
      ::DCM_WriteFile(&(*message)->identifier,
		    DCM_ORDERLITTLEENDIAN,
		    filename);
    }

    DCM_OBJECT* cpy = 0;
    ::DCM_CopyObject(&(*message)->identifier, &cpy);
    MDICOMWrapper* w = new MDICOMWrapper(cpy);
    mWrapperVector.push_back(w);
  }

  return SRV_NORMAL;
}

WRAPPERVector
MLQuery::wrapperVector() {
  return mWrapperVector;
}

void
MLQuery::clearVector() {
  WRAPPERVector::iterator b = mWrapperVector.begin();
  WRAPPERVector::iterator e = mWrapperVector.end();
  mWrapperVector.erase(b,e);
}
