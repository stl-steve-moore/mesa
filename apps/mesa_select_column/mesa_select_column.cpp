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

static char rcsid[] = "$Revision: 1.6 $ $RCSfile: mesa_select_column.cpp,v $";


#include "MESA.hpp"

#include "MDBInterface.hpp"
#include "MCharsetEncoder.hpp"

static MString charEncoding = "";

static void
usageerror()
{
    char msg[] = "\
Usage: mesa_select_column [-c col val] [-e encoding] <column> <table> <db> <output file> \n\
\n\
  -c             Set criteria for search.  col is column name; val is value \n\
  -e             Specify output encoding (ISO2022JP) \n\
\n\
  <column>       Search this column \n\
  <table>        Search this table \n\
  <db>           Search this database \n\
  <output file>  Place output in this file ";

  cerr << msg << endl;
  ::exit(1);
}

static void
callback(MDomainObject& domainObj, void* ctx)
{
  const MDomainMap& m = domainObj.map();
  MDomainMap::const_iterator i = m.begin();

  MString v = (*i).second;

  char* c = v.strData();
  char* p = c;
  char txtISO2022JP[4096];

  if (charEncoding == "ISO2022JP") {
    MCharsetEncoder e;
    int outputLength = 0;
    e.xlate(txtISO2022JP, outputLength, (int)sizeof(txtISO2022JP),
	c, ::strlen(c),
	"EUC_JP", "ISO2022JP");
    p = c;
  }
  fprintf((FILE*)ctx, "%s\n", p);
  delete []c;
}

int main(int argc, char **argv)
{
  MString criteriaName("");
  MString criteriaValue("");
  MCriteriaVector criteria;
  MCriteria c;

  while (--argc > 0 && (*++argv)[0] == '-') {
    switch (*(argv[0] + 1)) {
      case 'c':
 	argc--; argv++;
	if (argc < 2)
	  usageerror();
	criteriaName  = argv[0];
	argc--; argv++;
	criteriaValue = argv[0];
	c.attribute = criteriaName;
	c.oper      = TBL_EQUAL;
	c.value     = criteriaValue;
	criteria.push_back(c);
	break;
      case 'e':
	argc--; argv++;
	if (argc < 1)
	  usageerror();
	charEncoding = *argv;
	break;
      case 'z':
	break;
      default:
	(void) fprintf(stderr, "Unrecognized option: %c\n", *(argv[0] + 1));
	break;
    }
  }

  if (argc < 4)
    usageerror();

  MString columnName(argv[0]);
  MString tableName(argv[1]);
  MString dbName(argv[2]);

  FILE* filePtr = fopen(argv[3], "w");
  if (filePtr == 0) {
    cerr << "Could not open output file: " << argv[3] << endl;
    return 1;
  }

  MDBInterface dbInterface(dbName);

  MDomainObject domainObj;

  domainObj.tableName(tableName);
  domainObj.insert(columnName);

  dbInterface.select(domainObj, criteria, callback, filePtr);

  fclose(filePtr);

  return 0;
}
