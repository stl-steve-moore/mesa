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

static char rcsid[] = "$Revision: 1.1 $ $RCSfile: mesa_load_db.cpp,v $";


#include "MESA.hpp"

#include "MDBInterface.hpp"
#include "MCharsetEncoder.hpp"

static void
usageerror()
{
    char msg[] = "\
Usage: mesa_load_db <db> <input file> \n\
\n\
  <db>           Load this database \n\
  <input file>   Text input file";

  cerr << msg << endl;
  ::exit(1);
}

int processInputFile(MDBInterface& dbInterface, FILE* f)
{

  char tableSpecification[1024];
  while (::fgets(tableSpecification, 1024, f) != 0) {
    if (tableSpecification[0] == '#') continue;
    if (tableSpecification[0] == '\r') continue;
    if (tableSpecification[0] == '\n') continue;
    if (tableSpecification[0] == '\0') continue;

    int len = ::strlen(tableSpecification);
    tableSpecification[len-1] = '\0';

    MString s(tableSpecification);
    MString tableName = s.getToken(' ', 0);

    MDomainObject domainObj;
    domainObj.tableName(tableName);
    int i = 0;
    MStringVector v;
    while(s.tokenExists(' ', i+1)) {
      MString colName = s.getToken(' ', i+1);
      v.push_back(colName);
      i++;
    }
    int columnCount = i;
    for(i = 0; i < columnCount; i++) {
      char txt[2048];
      ::fgets(txt, 2048, f);
      len = ::strlen(txt);
      txt[len-1] = '\0';
      char txtEUCJP[8192];
      MCharsetEncoder e;
      int status;
      int outputLength = 0;
      status = e.xlate(txtEUCJP, outputLength, (int)sizeof(txtEUCJP),
	txt, ::strlen(txt),
	"ISO2022JP", "EUC_JP");
      if (status != 0) {
	cout << "Unable to translate to EUCJP from " << txt << endl;
	return 1;
      }
      domainObj.insert(v[i], txtEUCJP);
    }
    dbInterface.insert(domainObj);
  }

  return 0;
}

main(int argc, char **argv)
{
  while (--argc > 0 && (*++argv)[0] == '-') {
    switch (*(argv[0] + 1)) {
      default:
	(void) fprintf(stderr, "Unrecognized option: %c\n", *(argv[0] + 1));
	break;
    }
  }

  if (argc < 2)
    usageerror();

  MString dbName(argv[0]);

  FILE* filePtr = fopen(argv[1], "r");
  if (filePtr == 0) {
    cerr << "Could not open input file: " << argv[1] << endl;
    return 1;
  }

  MDBInterface dbInterface(dbName);

  int status = 0;
  status = processInputFile(dbInterface, filePtr);

  fclose(filePtr);

  return status;

#if 0
  MDomainObject domainObj;

  domainObj.tableName(tableName);
  domainObj.insert(columnName);

  MCriteriaVector criteria;
  if (criteriaName != "") {
    MCriteria c;
    c.attribute = criteriaName;
    c.oper      = TBL_EQUAL;
    c.value     = criteriaValue;
    criteria.push_back(c);
  }
  dbInterface.select(domainObj, criteria, callback, filePtr);

  fclose(filePtr);

  return 0;
#endif
}
