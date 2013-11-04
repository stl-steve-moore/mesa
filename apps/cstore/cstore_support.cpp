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
**			myExit
**			mwlCallback
** Author, Date:	Stephen M. Moore, 22-Mar-2000
** Intent:		This program sends C-Store commands to a server
**			for one or more DICOM composite objects.
** Last Update:		$Author: matt $, $Date: 2003/07/11 15:07:35 $
** Source File:		$RCSfile: cstore_support.cpp,v $
** Revision:		$Revision: 1.2 $
** Status:		$State: Exp $
*/

static char rcsid[] = "$Revision: 1.2 $ $RCSfile: cstore_support.cpp,v $";

#include "ctn_os.h"

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

typedef struct {
  char* c1;
  char* c2;
} STRING_MAP;

extern "C" {
DUL_PRESENTATIONCONTEXT *
SRVPRV_PresentationContext(
                   DUL_ASSOCIATESERVICEPARAMETERS * params, char *classUID);
};

void
loadFileVector(const MString& fileName,
	       bool recursionFlag, MStringVector& fileNameVector)
{
  MFileOperations f;

  int res = f.isDirectory(fileName);
  // res = 1 for directory, 0 for file, -1 in case of error.
  // If error, push it into fileNameVector where it will be dealt with
  // as an invalid filename.
  if (res == 1) {
    if (recursionFlag) {
      f.scanDirectory(fileName);
      int idx = 0;
      for (idx = 0; idx < f.filesInDirectory(); idx++) {
	MString x = f.fileName(idx);
	if (x == "." || x == "..")
	  continue;
	MString xx = fileName + "/" + x;
	loadFileVector(xx, recursionFlag, fileNameVector);
      }
    }
  } else {
    fileNameVector.push_back(fileName);
  }
}


MDICOMAssociation* newAssociation()
{
  MDICOMAssociation* a = 0;
  a = new MDICOMAssociation;
  if (a == 0) {
    MLogClient logClient;
    logClient.log(MLogClient::MLOG_ERROR,
    MString("cstore: unable to create new MDICOMAssociation instance"));
  }

  return a;
}

