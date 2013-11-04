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

static char rcsid[] = "$Revision: 1.4 $ $RCSfile: mesa_update_column.cpp,v $";


#include "MESA.hpp"

#include "MDBInterface.hpp"

static void
usageerror()
{
    char msg[] = "\
Usage: mesa_update_column [-c col val] <column> <value> <table> <db> \n\
\n\
  -c             Set criteria for search.  col is column name; val is value \n\
                 This switch can repeat if necessary\n\
\n\
  <column>       Update this column \n\
  <value>        New value for column \n\
  <table>        Update this table \n\
  <db>           Update this database ";

  cerr << msg << endl;
  ::exit(1);
}

static void
callback(MDomainObject& domainObj, void* ctx)
{
  const MDomainMap& m = domainObj.map();
  MDomainMap::const_iterator i = m.begin();

  MString v = (*i).second;

  char *c = v.strData();
  fprintf((FILE*)ctx, "%s\n", c);
  delete []c;
}


static MString
repairQuotes(MString v)
{
  MString c = v.subString(0, 1);
  if (c != "'") {
    return v;
  }
  int length = v.length();
  c = v.subString(1, length-2);
  return c;

}

static void 
updateCriteriaVector(MCriteriaVector& cv, MString colName, MString colValue)
{
  MCriteria c;
  c.attribute = repairQuotes(colName);
  c.oper      = TBL_EQUAL;
  c.value     = repairQuotes(colValue);
  cv.push_back(c);
}

int main(int argc, char **argv)
{
  MCriteriaVector criteria;

  while (--argc > 0 && (*++argv)[0] == '-') {
    switch (*(argv[0] + 1)) {
      case 'c':
 	argc--; argv++;
	if (argc < 2)
	  usageerror();
	updateCriteriaVector(criteria, argv[0], argv[1]);
	argc--; argv++;
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
  MString columnValue(argv[1]);
  MString tableName(argv[2]);
  MString dbName(argv[3]);

  columnName = repairQuotes(columnName);
  columnValue = repairQuotes(columnValue);
  tableName = repairQuotes(tableName);
  dbName = repairQuotes(dbName);

  MDBInterface dbInterface(dbName);

  MDomainObject domainObj;

  domainObj.tableName(tableName);

  MUpdate u;
  u.attribute = columnName;
  u.func = TBL_SET;
  u.value = columnValue;
  MUpdateVector updateVector;
  updateVector.push_back(u);

  int status = 0;
  status = dbInterface.update(domainObj, criteria, updateVector);

  if (status == 0) {
    return 0;
  } else {
    cout << "Unable to update database: " << dbName << endl;
    cout << " Table name: " << tableName << endl;
    return 1;
  }
}
