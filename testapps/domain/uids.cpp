/* Copyright marker.  Copyright will be inserted above.  Do not remove */
/*
** @$=@$=@$=
*/
/*
**				MESA
**		     Electronic Radiology Laboratory
**		   Mallinckrodt Institute of Radiology
**		Washington University School of Medicine
**
** Module Name(s):	main
** Author, Date:	Stephen M. Moore, 23-Jun-99
** Intent:		This program is used to construct MPPS objects
**			which can be translated using the MPPS SOP Class.
** Usage:		
** Last Update:		$Author: smm $, $Date: 1999/07/30 14:36:55 $
** Source File:		$RCSfile: uids.cpp,v $
** Revision:		$Revision: 1.1 $
** Status:		$State: Exp $
*/

static char rcsid[] = "$Revision: 1.1 $ $RCSfile: uids.cpp,v $";


#include "MESA.hpp"
#include "MDICOMWrapper.hpp"
#include "ctn_api.h"
#include "MDBModality.hpp"
#include "MFileOperations.hpp"

#include <vector>
#include <set>

typedef vector < MString > MStringVector;
typedef set < MString > MStringSet;
typedef map < MString, MString, less<MString> > MStringMap;

/* usageerror
**
** Purpose:
**	Print the usage text for this program and exit
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
  char usage[] = "\
Usage: mod_newuids file1 [file2...]\n";

  cerr << usage;
  ::exit(1);
}

main(int argc, char **argv)
{
  ::THR_Init();

  MString seriesUID;
  MDBModality modalityDB("mod1");

  seriesUID = modalityDB.newSeriesInstanceUID();
  cout << seriesUID << endl;

  seriesUID = modalityDB.newSeriesInstanceUID();
  cout << seriesUID << endl;

  MString s;
  s = modalityDB.newSOPInstanceUID();
  cout << s << endl;
  s = modalityDB.newSOPInstanceUID();
  cout << s << endl;

  s = modalityDB.newTransactionUID();
  cout << s << endl;
  s = modalityDB.newTransactionUID();
  cout << s << endl;

  return 0;
}
