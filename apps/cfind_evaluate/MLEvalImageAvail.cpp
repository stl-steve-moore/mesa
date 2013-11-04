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
#include "MLEvalImageAvail.hpp"
#include "MDICOMWrapper.hpp"
#include "MPatientStudy.hpp"
#include "MSeries.hpp"
#include "MSOPInstance.hpp"
#include "MDICOMDomainXlate.hpp"

#include <iomanip>

#if 0
MLEvalImageAvail::MLEvalImageAvail()
{
}
#endif

MLEvalImageAvail::MLEvalImageAvail(const MLEvalImageAvail& cpy) :
  MLEvalStudy(cpy)
{
}

MLEvalImageAvail::~MLEvalImageAvail()
{
}

void
MLEvalImageAvail::printOn(ostream& s) const
{
  s << "MLEvalImageAvail";
}

void
MLEvalImageAvail::streamIn(istream& s)
{
  //s >> this->member;
}

// Non-boiler plate methods to follow


MLEvalImageAvail::MLEvalImageAvail(MDICOMWrapper& testData) :
  MLEvalStudy(testData)
{
}

int
MLEvalImageAvail::run()
{
  MString level = mTestData.getString(DCM_IDQUERYLEVEL);

  if (level == "PATIENT") {
    cout << "Image Availability Query does not support PATIENT level query."
	 << endl;
    return 1;
  }

  if (level == "STUDY") {
    cout << "For Instance Availablity Query, you have specified a STUDY level query." << endl;
    cout << "We expect you to issue IMAGE level queries." << endl;
    return 1;
  }

  if (level == "SERIES") {
    cout << "For Instance Availablity Query, you have specified a SERIES level query." << endl;
    cout << "We expect you to issue IMAGE level queries." << endl;
    return 1;
  }

  if (level == "IMAGE") {
    return this->evalInstanceLevel();
  }

  {
    cout << "In Instance Availability Query, we do not recognize your "
	 << "query level attribte <" << level << ">" << endl;
    return 1;
  }

  return 1;
}

int
MLEvalImageAvail::evalInstanceLevel()
{
  int rtnStatus = 0;

  if (this->testForUniqueKeyStudyLevel() != 0)
    rtnStatus = 1;

  if (this->testForUniqueKeySeriesLevel() != 0)
    rtnStatus = 1;

  if (this->testInstanceLevelKeys() != 0)
    rtnStatus = 1;

  if (this->testInstanceLevelIAKeys() != 0)
    rtnStatus = 1;

  return rtnStatus;
}

int
MLEvalImageAvail::testInstanceLevelIAKeys()
{
  if (mVerbose) {
    cout << "Testing Instance Level attributes of C-Find: Image Availability."
	 << endl;
  }

  int rtnStatus = 0;

  DCM_TAG tags[] = {
	0x00200013,		// Instance Number
	0x00200022,		// Overlay Number
	0x00200024,		// Curve Number
	0x00200026,		// LUT Number
	0x00080016,		// SOP Class UID
	0x00280010,		// Rows
	0x00280011,		// Columns
	0
  };

  int idx = 0;
  for (idx = 0; tags[idx] != 0; idx++) {
    DCM_TAG t = tags[idx];

    if (mTestData.attributePresent(t)) {
      MString v  = mTestData.getString(t);
      cout << "Instance level attribute: "
           << hex << setw(8) << setfill('0') << t
	   << dec
           << " has value <" << v << ">"
           << " and (probably) should not be present." << endl;
      cout << "This constitutes a warning and not a failure." << endl;
    }
  }

  return rtnStatus;
}
