//
//        Copyright (C) 1999 - 2002, HIMSS, RSNA and Washington University
//
//        The MESA test tools software and supporting documentation were
//        developed for the Integrating the Healthcare Enterprise (IHE)
//        initiative (1999-2002), under the sponsorship of the
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

// Author, Date:	Stephen M. Moore, 22-Mar-2000
// Intent:		This program sends C-Store commands to a server
//			for one or more DICOM composite objects.
// Last Update:		$Author: smm $, $Date: 2009/03/06 18:41:50 $
// Source File:		$RCSfile: cstore.cpp,v $
// Revision:		$Revision: 1.20 $
// Status:		$State: Exp $


static char rcsid[] = "$Revision: 1.20 $ $RCSfile: cstore.cpp,v $";

#include "ctn_os.h"
#include <strstream>

#include "MESA.hpp"
#include "ctn_api.h"
#include "MFileOperations.hpp"
#include "MDICOMProxyTCP.hpp"
#include "MDICOMAssociation.hpp"
#include "MDICOMReactor.hpp"
#include "MDICOMWrapper.hpp"
#include "MWrapperFactory.hpp"
#include "MLCStore.hpp"
#include "MLogClient.hpp"

void
loadFileVector(const MString& fileName, bool recursionFlag, MStringVector& fileNameVector);
MDICOMAssociation* newAssociation();

extern "C" {
DUL_PRESENTATIONCONTEXT *
SRVPRV_PresentationContext(
                   DUL_ASSOCIATESERVICEPARAMETERS * params, char *classUID);
};


/* usageerror
**
** Purpose:
**	Print the usage message for this program and exit.
**
** Parameter Dictionary:
**	None
**
** Return Values:
**	None
**
** Algorithm:
**	Description of the algorithm (optional) and any other notes.
*/

static void
usageerror()
{
    char msg[] = "\
cstore [-a title] [-c title] [-d delta] [-l level] [-n] [-p] [-r retain] [-v] node port file [file...]\n\
\n\
    a     Application title of this application\n\
    c     Called AP title to use during Association setup\n\
    d     Apply changes from file <delta> to objects before storage\n\
    l     Set the log level (0 default, 1-4 are other values)\n\
    n     Do not recurse through directories\n\
    p     Modify object by removing pixel data\n\
    r     Text file lists attributes to be retained;\n\
           other attributes are removed;\n\
           applied before delta file.\n\
    v     Verbose mode for DUL/SRV facilities\n\
\n\
    node  Node name of server\n\
    port  Port number of server\n\
    file  path to CTN-formatted file to be stored\n";

    fprintf(stderr, msg);
    exit(1);
}

static bool isEncapsulatedTransferSyntax(const MString& fileXferSyntax)
{
  char* xfer[] = {
    DICOM_TRANSFERLITTLEENDIAN,
    DICOM_TRANSFERLITTLEENDIANEXPLICIT,
    DICOM_TRANSFERBIGENDIANEXPLICIT
  };
  int index;

  if (fileXferSyntax == "")
    return false;

  for (index = 0; index < 3; index++) {
    if (fileXferSyntax == xfer[index])
      return false;
  }

  return true;
}

int main(int argc, char **argv)
{
  CONDITION cond;
  char
    *calledAPTitle = "CSTORE_SCP",
    *callingAPTitle = "MESA_CSTORE";

  char* port;
  char* node;

  CTNBOOLEAN
    verbose = FALSE,
    abortFlag = FALSE,
    paramsFlag = FALSE;
  char *deltaFile = 0;
  char* retainFile = 0;
  DUL_SC_ROLE
    role = DUL_SC_ROLE_DEFAULT;
  bool recursionFlag = true;
  MLogClient::LOGLEVEL logLevel = MLogClient::MLOG_NONE;
  int tmp;
  bool pixelFlag = false;
  char logTxt[1024] = "";

  while (--argc > 0 && (*++argv)[0] == '-') {
    switch (*(argv[0] + 1)) {
    case 'a':
      argc--;
      argv++;
      if (argc <= 0)
	usageerror();
      callingAPTitle = *argv;
      break;
    case 'c':
      argc--;
      argv++;
      if (argc <= 0)
	usageerror();
      calledAPTitle = *argv;
      break;
    case 'd':
      argc--;
      argv++;
      if (argc <= 0)
	usageerror();
      deltaFile = *argv;
      break;
    case 'l':
      argc--; argv++;
      if (argc <= 0)
	usageerror();
      tmp = atoi(*argv);
      logLevel = (MLogClient::LOGLEVEL)tmp;
      break;
    case 'n':
      recursionFlag = false;
      break;
    case 'p':
      pixelFlag = true;
      break;
    case 'r':
      argc--;
      argv++;
      if (argc <= 0)
	usageerror();
      retainFile = *argv;
      break;
    case 'v':
      verbose = TRUE;
      break;
    default:
      break;
    }
  } 

  MFileOperations f;
  char path[1024] = "";
  f.expandPath(path, "MESA_TARGET", "logs");
  MString logDir(path);

  if (argc < 3)
    usageerror();

  ::THR_Init();
  ::DUL_Debug(verbose);
  ::SRV_Debug(verbose);

  MLogClient logClient;
  if (logLevel != MLogClient::MLOG_NONE) {
    logClient.initialize(logLevel, logDir + "/cstore.log");

    logClient.log(MLogClient::MLOG_ERROR,
        "<no peer>", "send_hl7<main>", __LINE__,
        "Begin send cstore application");
    char tmp[256];
    strstream s (tmp, sizeof(tmp));
    s << "Command line arguments: "
      << argv[0] << " "
      << argv[1] << " "
      << argv[2] << '\0';
    logClient.log(MLogClient::MLOG_VERBOSE,
        "<no peer>", "send_hl7<main>", __LINE__,
        tmp);
  }


  node = *argv++; argc--;
  port = *argv++; argc--;

  MString sopClass("");
  bool firstTrip = true;

  MLCStore cStoreHandler;
  MDICOMReactor reactor;
  MStringVector fileNameVector;
  while (argc-- > 0) {
    loadFileVector(*argv, recursionFlag, fileNameVector);
    argv++;
  }

  int idx = 0;
  MDICOMProxy* p = 0;
  MDICOMAssociation* assoc = 0;

  for (idx = 0; idx < fileNameVector.size(); idx++) {
    MString f = fileNameVector[idx];
    MDICOMWrapper w;
    if (w.open(f) != 0) {
      strstream x(logTxt, sizeof(logTxt)-1);
      x << "Unable to open DICOM File: " << f << '\0';
      logClient.logTimeStamp(MLogClient::MLOG_ERROR, logTxt);
      return 1;
    }

    MWrapperFactory factory;
    if (retainFile != 0) {
      if (factory.retainTags(w, retainFile) != 0) {
	strstream x(logTxt, sizeof(logTxt)-1);
	x << "Unable to apply the retain tags file: " << retainFile
	  << " to: " << f << '\0';
	logClient.logTimeStamp(MLogClient::MLOG_ERROR, logTxt);
	return 1;
      }
    }

    if (deltaFile != 0) {
      if (factory.modifyWrapper(w, deltaFile) != 0) {
	strstream x(logTxt, sizeof(logTxt)-1);
	x << "Unable to apply delta file: " << deltaFile
	  << " to: " << f << '\0';
	logClient.logTimeStamp(MLogClient::MLOG_ERROR, logTxt);
	return 1;
      }
    }
    MString xferSyntax = DICOM_TRANSFERLITTLEENDIAN;
    if (w.groupPresent(0x0002) == 1) {
      if (isEncapsulatedTransferSyntax(w.getString(DCM_METATRANSFERSYNTAX))) {
	xferSyntax = w.getString(DCM_METATRANSFERSYNTAX);
      }
      w.removeGroup(0x0002);
    }

    if (pixelFlag)
      w.removeGroup(0x7fe0);

    MString s = w.getString(DCM_IDSOPCLASSUID);
    if (s != sopClass) {
      if (!firstTrip) {
	assoc->releaseAssociation();
	delete assoc;
	assoc = 0;
	delete p;
      }
      firstTrip = false;
      sopClass  = s;
      p = new MDICOMProxyTCP;
      if (p == 0) {
	strstream x(logTxt, sizeof(logTxt)-1);
	x << "Unable to create new MDICOMProxyTCP object" << '\0';
	logClient.logTimeStamp(MLogClient::MLOG_ERROR, logTxt);
	return 1;
      }

      assoc = newAssociation();
      if (assoc == 0) {
	logClient.logTimeStamp(MLogClient::MLOG_ERROR,
		"Unable to create new Association object");
	return 1;
      }
      int status;

      status = assoc->registerSOPClass(s, DUL_SC_ROLE_DEFAULT,
				xferSyntax);
      if (status != 0) {
	strstream x(logTxt, sizeof(logTxt)-1);
	x << "Unable to register SOP Class with Transfer Syntax "
	  << s << ":"
	  << xferSyntax << '\0';
	logClient.logTimeStamp(MLogClient::MLOG_ERROR, logTxt);
	return 1;
      }

      if (p->connect(node, port) != 0) {
	logClient.log(MLogClient::MLOG_ERROR,
		MString("cstore: unable to connect to node: ") + node);
	return 1;
      }

      status = assoc->requestAssociation(*p, callingAPTitle, calledAPTitle);
      if (status != 0) {
	logClient.log(MLogClient::MLOG_ERROR, "Association request failed");
	return 1;
      }

    }
    reactor.registerHandler(&cStoreHandler, sopClass);
    cond = cStoreHandler.sendCStoreRequest(*assoc, w);
    if (cond != 0) {
      strstream x(logTxt, sizeof(logTxt)-1);
      x << "Unable to transmit: " << f << '\0';
      logClient.log(MLogClient::MLOG_ERROR, logTxt);
      return 1;
    }

    reactor.processRequests(*assoc, 1);

    argv++;
  }
  if (assoc != 0) {
    assoc->releaseAssociation();
  }

  ::THR_Shutdown();
  return 0;
}
