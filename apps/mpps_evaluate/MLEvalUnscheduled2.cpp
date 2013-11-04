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
#include "MLEvalUnscheduled2.hpp"
#include "MDICOMWrapper.hpp"

#if 0
MLEvalUnscheduled2::MLEvalUnscheduled2()
{
}
#endif

MLEvalUnscheduled2::MLEvalUnscheduled2(const MLEvalUnscheduled2& cpy) :
  MLMPPSEvaluator(cpy)
{
}

MLEvalUnscheduled2::~MLEvalUnscheduled2()
{
}

void
MLEvalUnscheduled2::printOn(ostream& s) const
{
  s << "MLEvalUnscheduled2";
}

void
MLEvalUnscheduled2::streamIn(istream& s)
{
  //s >> this->member;
}

// Non-boiler plate methods to follow


MLEvalUnscheduled2::MLEvalUnscheduled2(MDICOMWrapper& testData,
			     MDICOMWrapper& standardData) :
  MLMPPSEvaluator(testData, standardData)
{
}

int
MLEvalUnscheduled2::run(const MString& dataSource, const MString& operation)
{

  int status = 0;
  int finalStatus = 0;

  status = this->evalPPSRelationshipScheduled(dataSource, operation);
  if (status != 0)
    finalStatus = status;

  status = this->evalPPSInformationScheduled(dataSource, operation);
  if (status != 0)
    finalStatus = status;

  status = this->evalPPSImageAcqScheduled(dataSource, operation);
  if (status != 0)
    finalStatus = status;

  return finalStatus;
}
