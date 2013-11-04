/*
          Copyright (C) 1993, 1994, RSNA and Washington University

          The software and supporting documentation for the Radiological
          Society of North America (RSNA) 1993, 1994 Digital Imaging and
          Communications in Medicine (DICOM) Demonstration were developed
          at the
                  Electronic Radiology Laboratory
                  Mallinckrodt Institute of Radiology
                  Washington University School of Medicine
                  510 S. Kingshighway Blvd.
                  St. Louis, MO 63110
          as part of the 1993, 1994 DICOM Central Test Node project for, and
          under contract with, the Radiological Society of North America.

          THIS SOFTWARE IS MADE AVAILABLE, AS IS, AND NEITHER RSNA NOR
          WASHINGTON UNIVERSITY MAKE ANY WARRANTY ABOUT THE SOFTWARE, ITS
          PERFORMANCE, ITS MERCHANTABILITY OR FITNESS FOR ANY PARTICULAR
          USE, FREEDOM FROM ANY COMPUTER DISEASES OR ITS CONFORMITY TO ANY
          SPECIFICATION. THE ENTIRE RISK AS TO QUALITY AND PERFORMANCE OF
          THE SOFTWARE IS WITH THE USER.

          Copyright of the software and supporting documentation is
          jointly owned by RSNA and Washington University, and free access
          is hereby granted as a license to use this software, copy this
          software and prepare derivative works based upon this software.
          However, any distribution of this software source code or
          supporting documentation or derivative works (source code and
          supporting documentation) must include the three paragraphs of
          the copyright notice.
*/
/* Copyright marker.  Copyright will be inserted above.  Do not remove */
/*
**				MESA 1999
**		     Electronic Radiology Laboratory
**		   Mallinckrodt Institute of Radiology
**		Washington University School of Medicine
**
** Module Name(s):	main
**			usageerror
**			mwlCallback
** Author, Date:	Stephen M. Moore, 22-Mar-2000
** Intent:		This program sends a C-Store command to a server.
** Usage:
**	cstore [-a title] [-c title] [-p] [-v] node port
**  Options:
**	a	Application title of this application
**	c	Called AP title to use during Association setup
**	p	Dump service parameters after Association Request
**	v	Verbose mode for DUL facility
** Last Update:		$Author: smm $, $Date: 2001/12/26 19:49:02 $
** Source File:		$RCSfile: cecho.cpp,v $
** Revision:		$Revision: 1.3 $
** Status:		$State: Exp $
*/

static char rcsid[] = "$Revision: 1.3 $ $RCSfile: cecho.cpp,v $";

#include "ctn_os.h"
#include "MESA.hpp"
#include "ctn_api.h"
#include "MConnector.hpp"
#include "MDICOMAssociation.hpp"
#include "MDICOMReactor.hpp"
#include "MDICOMWrapper.hpp"
#include "MSOPHandler.hpp"
#include "MWrapperFactory.hpp"
#include "MLogClient.hpp"


static void
usageerror()
{
    char msg[] = "\
cecho [-a title] [-c title] [-l level] [-p] [-v] node port \n\
\n\
    a     Application title of this application\n\
    c     Called AP title to use during Association setup\n\
    l     Set the log level (0 default, 1-4 are other values)\n\
    p     Dump service parameters after Association Request\n\
    v     Verbose mode for DUL/SRV facilities\n\
\n\
    node  Node name of server\n\
    port  Port number of server\n";

    cout << msg;
    ::exit(1);
}

static void releaseAssociation(DUL_ASSOCIATIONKEY** association,
			       DUL_ASSOCIATESERVICEPARAMETERS* params)
{
  (void) ::DUL_ReleaseAssociation(association);
  (void) ::DUL_ClearServiceParameters(params);
  (void) ::COND_PopCondition(TRUE);
}

int
main(int argc, char **argv)
{
  CONDITION cond;
  DUL_NETWORKKEY* network = NULL;
  DUL_ASSOCIATIONKEY* association = NULL;
  DUL_ASSOCIATESERVICEPARAMETERS params;
  char
    *calledAPTitle = "CSTORE_SCP",
    *callingAPTitle = "MESA_CSTORE";

  int port;
  char* node;

  CTNBOOLEAN
    verbose = FALSE,
    abortFlag = FALSE,
    paramsFlag = FALSE;

  DUL_SC_ROLE
    role = DUL_SC_ROLE_DEFAULT;

  MLogClient::LOGLEVEL logLevel = MLogClient::MLOG_NONE;
  int tmp;

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
    case 'l':
      argc--; argv++;
      if (argc <= 0)
	usageerror();
      tmp = atoi(*argv);
      logLevel = (MLogClient::LOGLEVEL)tmp;
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

  ::THR_Init();
  ::DUL_Debug(verbose);
  ::SRV_Debug(verbose);
  MLogClient logClient;
  logClient.logLevel(logLevel);

  node = *argv++; argc--;
  port = atoi(*argv++); argc--;

  MConnector c;
  CTN_SOCKET sock;
  if (c.connectTCP(node, port, sock) != 0) {
    cout << "Could not connect to server at node: " << node
	 << " and port: " << port
	 << endl;
    return 1;
  }

  MDICOMAssociation assoc;
  int status;
  status = assoc.registerSOPClass(DICOM_SOPCLASSVERIFICATION, DUL_SC_ROLE_DEFAULT,
		DICOM_TRANSFERLITTLEENDIAN);
  if (status != 0) {
    return 1;
  }

  //status = assoc.requestAssociation(callingAPTitle, calledAPTitle, node, port);
  status = assoc.requestAssociation(sock, callingAPTitle, calledAPTitle);
  if (status != 0) {
    return 1;
  }

  MSOPHandler echoHandler;

  MDICOMReactor reactor;
  reactor.registerHandler(&echoHandler, DICOM_SOPCLASSVERIFICATION);

  status = echoHandler.sendCEchoRequest(assoc);

  reactor.processRequests(assoc, 1);

  assoc.releaseAssociation();

  ::THR_Shutdown();
  return 0;
}
