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
#include "MDBImageManagerStudy.hpp"
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
  mLogDir(cpy.mLogDir),
  mStorageDir(cpy.mStorageDir)
{
}

MLStorage::~MLStorage()
{
}

void
MLStorage::printOn(ostream& s) const
{
  s << "MLStorage: "
    << mLogDir << " " << mStorageDir;
}

void
MLStorage::streamIn(istream& s)
{
  //s >> this->member;
}

// Non-boiler plate methods to follow

MLStorage::MLStorage(MDBImageManager* manager, const MString& logDir,
		     const MString& storageDir) :
  mImageManager(manager),
  mLogDir(logDir),
  mStorageDir(storageDir)
{
}

int
MLStorage::initialize()
{
  MFileOperations f;
  f.createDirectory(mLogDir);
  f.createDirectory(mStorageDir);

  return 0;
}

CONDITION
MLStorage::handleCStoreCommand(DUL_PRESENTATIONCONTEXT* ctx,
			       MSG_C_STORE_REQ** message,
			       MSG_C_STORE_RESP* response,
			       DUL_ASSOCIATESERVICEPARAMETERS* params,
			       MString& fileName)
{
  fileName = mStorageDir + "/" + (*message)->instanceUID;

  MLogClient logClient;
  logClient.log(MLogClient::MLOG_VERBOSE,
		params->callingAPTitle,
		"MLStorage::handleCStoreCommand",
		__LINE__,
		"C-Store command; file stored in " + fileName);

  return 0;
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
  MString newDirectory;
  MString newFile;
  MPatient patient;
  MStudy study;
  MSeries series;
  MSOPInstance sopInstance;

  {
    MDICOMWrapper w(fileName);

    xlate.translateDICOM(w, patient);

    xlate.translateDICOM(w, study);

    xlate.translateDICOM(w, series);

    xlate.translateDICOM(w, sopInstance);

    MString sopInstanceUID = sopInstance.instanceUID();
    logClient.log(MLogClient::MLOG_VERBOSE,
		params->callingAPTitle,
		"MLStorage::handleCStoreDataSet",
		__LINE__,
		"SOP Instance UID: " + sopInstanceUID);

    MString slash("/");
    MString callingAPTitle(params->callingAPTitle);

    char x[65];
    sopInstance.instanceUID().safeExport(x, sizeof(x));
    if (x[0] == 'x') {	// Special case
      newDirectory = mStorageDir + slash + params->callingAPTitle
        + slash + study.studyInstanceUID();
    } else {
      newDirectory = mStorageDir + slash + params->callingAPTitle
        + slash + study.studyInstanceUID()
        + slash + series.seriesInstanceUID();
    }

    newFile = newDirectory
      + slash + sopInstance.instanceUID();

    sopInstance.fileName(newFile);
  }

  MFileOperations fileOp;
  fileOp.createDirectory(newDirectory);
  fileOp.unlink(newFile);
  fileOp.rename(fileName, newFile);

  logClient.log(MLogClient::MLOG_VERBOSE,
		params->callingAPTitle,
		"MLStorage::handleCStoreDataSet",
		__LINE__,
		"File Rename: " + newFile);

  if (sopInstance.instanceUID() != "x")
    mImageManager->enterSOPInstance(patient, study, series, sopInstance);

  logClient.log(MLogClient::MLOG_VERBOSE,
		params->callingAPTitle,
		"MLStorage::handleCStoreDataSet",
		__LINE__,
		"C-Store Data Set complete");

  return 0;
}
