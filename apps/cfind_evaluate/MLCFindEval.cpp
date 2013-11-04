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
#include "MLCFindEval.hpp"
#include "MDICOMWrapper.hpp"
#include "ctn_api.h"

#include <iomanip>

#if 0
MLCFindEval::MLCFindEval()
{
}
#endif

MLCFindEval::MLCFindEval(const MLCFindEval& cpy) :
  mVerbose(cpy.mVerbose),
  mTestData(cpy.mTestData)
{
}

MLCFindEval::~MLCFindEval()
{
}

void
MLCFindEval::printOn(ostream& s) const
{
  s << "MLCFindEval";
}

void
MLCFindEval::streamIn(istream& s)
{
  //s >> this->member;
}

// Non-boiler plate methods to follow

MLCFindEval::MLCFindEval(MDICOMWrapper& testData) :
  mVerbose(false),
  mTestData(testData)
{
}

void
MLCFindEval::verbose(bool flag)
{
  mVerbose = flag;
}


