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
#include "MLStorage.hpp"
#include "MDBImageManager.hpp"
#include "MDICOMWrapper.hpp"
#include "MDICOMDomainXlate.hpp"
#include "MPatient.hpp"
#include "MStudy.hpp"
#include "MSeries.hpp"
#include "MSOPInstance.hpp"
#include "MFileOperations.hpp"
#include "MLogClient.hpp"

#if 0
MLStorage::MLStorage()
{
}
#endif

MLStorage::MLStorage(const MLStorage& cpy) :
  mImageManager(cpy.mImageManager),
  mLogDir(cpy.mLogDir)
{
}

MLStorage::~MLStorage()
{
}

void
MLStorage::printOn(ostream& s) const
{
  s << "MLStorage";
}

void
MLStorage::streamIn(istream& s)
{
  //s >> this->member;
}

// Non-boiler plate methods to follow

MLStorage::MLStorage(MDBImageManager& manager, const MString& logDir) :
  mImageManager(manager),
  mLogDir(logDir + "/images")
{
}

int
MLStorage::initialize()
{
  MFileOperations f;
  f.createDirectory(mLogDir);
}

CONDITION
MLStorage::handleCStoreCommand(DUL_PRESENTATIONCONTEXT* ctx,
			       MSG_C_STORE_REQ** message,
			       MSG_C_STORE_RESP* response,
			       DUL_ASSOCIATESERVICEPARAMETERS* params,
			       MString& fileName)
{
  fileName = mLogDir + "/" + (*message)->instanceUID;

  MLogClient logClient;
  logClient.log(MLogClient::MLOG_VERBOSE,
		params->callingAPTitle,
		"MLStorage::handleCStoreCommand",
		__LINE__,
		"C-Store command; file stored in " + fileName);
}

CONDITION
MLStorage::handleCStoreDataSet(DUL_PRESENTATIONCONTEXT* ctx,
			       MSG_C_STORE_REQ** message,
			       MSG_C_STORE_RESP* response,
			       DUL_ASSOCIATESERVICEPARAMETERS* params,
			       MString& fileName)
{
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_VERBOSE,
		params->callingAPTitle,
		"MLStorage::handleCStoreDataSet",
		__LINE__,
		"About to translate and store SOP Instance");
  logClient.log(MLogClient::MLOG_VERBOSE,
		params->callingAPTitle,
		"MLStorage::handleCStoreDataSet",
		__LINE__,
		"File is: " + fileName);

  MDICOMDomainXlate xlate;

  MDICOMWrapper w((*message)->dataSet);

  MPatient patient;
  xlate.translateDICOM(w, patient);
  patient.issuerOfPatientID("OF1");

  MStudy study;
  xlate.translateDICOM(w, study);

  MSeries series;
  xlate.translateDICOM(w, series);

  MSOPInstance sopInstance;
  xlate.translateDICOM(w, sopInstance);

  MString sopInstanceUID = sopInstance.instanceUID();
  logClient.log(MLogClient::MLOG_VERBOSE,
		params->callingAPTitle,
		"MLStorage::handleCStoreDataSet",
		__LINE__,
		"SOP Instance UID: " + sopInstanceUID);

  MString slash("/");
  MString callingAPTitle(params->callingAPTitle);

  MString newDirectory;
  MString newFile;

  char x[65];
  sopInstance.instanceUID().safeExport(x, sizeof(x));
  if (x[0] == 'x') {	// Special case
    newDirectory = mLogDir + slash + params->callingAPTitle
      + slash + study.studyInstanceUID();
  } else {
    newDirectory = mLogDir + slash + params->callingAPTitle
      + slash + study.studyInstanceUID()
      + slash + series.seriesInstanceUID();
  }

  newFile = newDirectory
    + slash + sopInstance.instanceUID();

  sopInstance.fileName(newFile);

  MFileOperations fileOp;
  fileOp.createDirectory(newDirectory);
  fileOp.rename(fileName, newFile);

  logClient.log(MLogClient::MLOG_VERBOSE,
		params->callingAPTitle,
		"MLStorage::handleCStoreDataSet",
		__LINE__,
		"File Rename: " + newFile);

  if (sopInstance.instanceUID() != "x")
    mImageManager.enterSOPInstance(patient, study, series, sopInstance);

  logClient.log(MLogClient::MLOG_VERBOSE,
		params->callingAPTitle,
		"MLStorage::handleCStoreDataSet",
		__LINE__,
		"C-Store Data Set complete");
}
