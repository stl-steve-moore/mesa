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

static char rcsid[] = "$Revision: 1.17 $ $RCSfile: mwlquery.cpp,v $";

#include "ctn_os.h"

#include "MESA.hpp"
#include "ctn_api.h"
#include "MDICOMProxyTCP.hpp"
#include "MDICOMAssociation.hpp"
#include "MDICOMWrapper.hpp"
#include "MWrapperFactory.hpp"
#include "MDICOMReactor.hpp"
#include "MSOPHandler.hpp"
#include "MLQuery.hpp"

DCM_OBJECT * createQueryObject(const char *fileName);


static void
usageerror()
{
    char msg[] = "\
mwlquery [-a title] [-c title] [-f file] [-n num] [-o path] [-p] [-v] node port\n\
\n\
    a     Application title of this application\n\
    c     Called AP title to use during Association setup\n\
    f     File containing a dcm object with query\n\
    n     Message logs begin with num.  Defaults to 1.\n\
    o     If specified, logs query results to .DCM messages in path\n\
    p     Dump service parameters after Association Request\n\
    v     Verbose mode for DUL/SRV facilities\n\
\n\
    node  Node name of server\n\
    port  Port number of server\n";

    fprintf(stderr, msg);
    exit(1);
}

int main(int argc, char **argv)
{
    CONDITION			/* Return values from DUL and ACR routines */
	cond;
    char
       *calledAPTitle = "MWL_SCP",
       *callingAPTitle = "MWL_SCU";

    int
        port;			/* TCP port used to establish Association */
    char
       *node;			/* The node we are calling */

    int
        num = 1;		/* The starting message number for logs */
    char
       *outputPath = "";	/* The path for output logs */

    int temp;
    char* deltaFile = 0;	// A set of deltas to apply to query

    vector<MString> filenames;  /* Filenames of queries */


    CTNBOOLEAN
	verbose = FALSE,
	abortFlag = FALSE,
	paramsFlag = FALSE;

    DUL_SC_ROLE
	role = DUL_SC_ROLE_DEFAULT;

    MSG_C_FIND_REQ findRequest = {MSG_K_C_FIND_REQ, 0, 0,
	DCM_CMDDATAIDENTIFIER,
	0, NULL,
    DICOM_SOPMODALITYWORKLIST_FIND};

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
	case 'f':
	    argc--;
	    argv++;
	    if (argc <= 0)
		usageerror();
	    filenames.push_back(*argv);
	    break;
	case 'n':
	    argc--;
	    argv++;
	    if (argc <= 0)
		usageerror();
	    temp = atoi(*argv);
	    if (temp > 0)
                num = temp;
	    break;
	case 'o':
	    argc--;
  	    argv++;
            if (argc <= 0)
  		usageerror();
	    outputPath = *argv;
	    break;
	case 'p':
	    paramsFlag = TRUE;
	    break;
	case 'v':
	    verbose = TRUE;
	    break;
	default:
	    break;
	}
    }
    if (argc < 2)
	usageerror();

    if (filenames.empty())
        usageerror();

    ::THR_Init();
    DUL_Debug(verbose);
    SRV_Debug(verbose);

    node = *argv;
    if (sscanf(*++argv, "%d", &port) != 1)
	usageerror();

    MDICOMAssociation assoc;
    int status;
    status = assoc.registerSOPClass(DICOM_SOPMODALITYWORKLIST_FIND,
		DUL_SC_ROLE_DEFAULT, DICOM_TRANSFERLITTLEENDIAN);
    if (status != 0) {
      cout << "Unable to register SOP Class: " << DICOM_SOPMODALITYWORKLIST_FIND << endl;
      return 1;
    }


    MDICOMProxy* proxy = new MDICOMProxyTCP;

    if (proxy->connect(node, port) != 0) {
      cout << "Unable to connect to " << node << endl;
    }

    status = assoc.requestAssociation(*proxy, callingAPTitle, calledAPTitle);
    if (status != 0) {
      cout << "Unable to establish association with: "
	<< node << " "
	<< port << " "
	<< calledAPTitle
	<< endl;
      return 1;
    }

    MString outputPathStr(outputPath);
    MLQuery qHandler(outputPathStr);
    qHandler.setMessageNumber(num);
    MDICOMReactor reactor;

    reactor.registerHandler(&qHandler, DICOM_SOPMODALITYWORKLIST_FIND);

    for (vector<MString>::iterator i = filenames.begin(); i != filenames.end(); i++) {
      char *tempStr = (*i).strData();
      DCM_OBJECT* queryObj = createQueryObject(tempStr);
      delete [] tempStr;

      MDICOMWrapper w(queryObj);
      if (deltaFile != 0) {
	MWrapperFactory factory;
	if (factory.modifyWrapper(w, deltaFile) != 0) {
	  cerr  << "Unable to apply delta file: " << deltaFile
		<< " to: " << *argv << endl;
	  return 1;
	}
      }

      qHandler.sendCFindRequest(assoc,
			      DICOM_SOPMODALITYWORKLIST_FIND, w);
      reactor.processRequests(assoc, 1);
      ::DCM_CloseObject(&queryObj);
    }
    
    assoc.releaseAssociation();

    ::THR_Shutdown();
    return 0;
}

