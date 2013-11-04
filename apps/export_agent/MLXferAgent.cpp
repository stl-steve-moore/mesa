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
#include "MLXferAgent.hpp"
#include "MDBImageManager.hpp"
#include "MCGIParser.hpp"

#include "MDICOMApp.hpp"
#include "MStorageAgent.hpp"
#include "MLogClient.hpp"

#if 0
MLXferAgent::MLXferAgent()
{
}
#endif

MLXferAgent::MLXferAgent(const MLXferAgent& cpy) :
  mImageManager(cpy.mImageManager)
{
}

MLXferAgent::~MLXferAgent()
{
}

void
MLXferAgent::printOn(ostream& s) const
{
  s << "MLXferAgent";
}

void
MLXferAgent::streamIn(istream& s)
{
  //s >> this->member;
}

// Non-boiler plate methods to follow

MLXferAgent::MLXferAgent(MDBImageManager& manager) :
  mImageManager(manager)
{
}

int
MLXferAgent::xmitStudy(const MString& params)
{
  MCGIParser parser;

  parser.parse(params);
  MString destAE = parser.getValue("destAE");
  MString studyUID = parser.getValue("studyUID");

  MDICOMApp dicomApp;
  if (mImageManager.selectDICOMApp(destAE, dicomApp) != 0) {
    return -1;
  }

  MString host = dicomApp.host();
  MString port = dicomApp.port();

  this->clearFileVector();

  int status;
  MPatientStudy patientStudy;
  MSeries series;
  MSOPInstance sopInstance;
  patientStudy.studyInstanceUID(studyUID);

  status = mImageManager.queryDICOMStudyRoot(
				patientStudy,
				series,
				sopInstance,
				"STUDY", "IMAGE",
				*this);

  if (status != 0) {
    cout << "Unable to query Image Manager" << endl;
    return 1;
  }

  status = this->xmitVectorOfImages("MESA", destAE,
	dicomApp.host(), dicomApp.port());

  return status;
}

int
MLXferAgent::xmitSeries(const MString& params)
{
  MCGIParser parser;

  parser.parse(params);
  MString destAE = parser.getValue("destAE");
  MString seriesUID = parser.getValue("seriesUID");

  MDICOMApp dicomApp;
  if (mImageManager.selectDICOMApp(destAE, dicomApp) != 0) {
    return -1;
  }

  MString host = dicomApp.host();
  MString port = dicomApp.port();

  this->clearFileVector();

  int status;
  MPatientStudy patientStudy;
  MSeries series;
  MSOPInstance sopInstance;
  series.seriesInstanceUID(seriesUID);

  status = mImageManager.queryDICOMStudyRoot(
				patientStudy,
				series,
				sopInstance,
				"SERIES", "IMAGE",
				*this);

  if (status != 0) {
    cout << "Unable to query Image Manager" << endl;
    return 1;
  }

  status = this->xmitVectorOfImages("MESA", destAE,
	dicomApp.host(), dicomApp.port());

  return status;
}


int
MLXferAgent::selectCallback(const MPatientStudy& patientStudy,
	const MSeries& series,
	const MSOPInstance& sopInstance)
{
  MString f = sopInstance.fileName();
  mFileNameVector.push_back(f);
}

// Private methods below here.

void
MLXferAgent::clearFileVector()
{
  MStringVector::iterator pStart = mFileNameVector.begin();
  MStringVector::iterator pEnd   = mFileNameVector.end();
  mFileNameVector.erase(pStart, pEnd);
}

int
MLXferAgent::xmitVectorOfImages(const MString& sourceAE,
	const MString& destAE,
	const MString& host,
	const MString& port)
{
  MStorageAgent agent;
  U16 result = 0;
  MString rtnMessage;
  int status;
  MLogClient logClient;

  logClient.log(MLogClient::MLOG_CONVERSATION,
	destAE,
	"MLXferAgent::xmitVectorOfImages",
	__LINE__,
	MString("About to export images to ") + host + MString(":") + port);

  MStringVector::iterator it = mFileNameVector.begin();
  for (; it != mFileNameVector.end(); it++) {
    status = agent.storeInstance(sourceAE, destAE,
		host, port.intData(),
		*it,
		result,
		rtnMessage);
    if (status != 0) {
      cout << "Unable to xfer: " << *it << endl;
      return 1;
    }
  }
  return 0;
}
