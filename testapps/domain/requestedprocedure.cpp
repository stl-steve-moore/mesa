#include <iostream>
#include <string>
#include "MESA.hpp"
#include "MDBADT.hpp"
#include "MDomainObject.hpp"
#include "MDBInterface.hpp"
#include "MRequestedProcedure.hpp"

void insert( MDBInterface& dbInterface );
void remove( MDBInterface& dbInterface );
void update( MDBInterface& dbInterface );
void select( MDBInterface& dbInterface );
void get( MDBInterface& dbInterface ); // gets only one row
void processRow( MDomainObject& o);

using namespace std;
usage()
{
  char msg[] = "\n
Usage: <function> [i,r,u,s,g] <databaseName>";

  cerr << msg << endl;
  exit(1);
}

int main(int argc, char** argv)
{
  if (argc < 3)
    usage();

  argc--; argv++;
  char func = *argv[0];
  argc--; argv++;

  MDBInterface dbInterface(*argv);

  switch(func)
  {
    case 'i':
        insert(dbInterface);
        break;
    case 'r':
        remove(dbInterface);
        break;
    case 'u':
        update(dbInterface);
        break;
    case 's':
        select(dbInterface);
        break;
    case 'g':
        get(dbInterface);
        break;
    default:
        usage();
        break;
  }  //endcase

  return 0;
}

void insert(MDBInterface& dbInterface)
{
  MRequestedProcedure rp("Study Instance UID",
                         "Requested Procedure ID",
                         "Filler Order Number",
                         "Accession Number",
                         "Quantity Timing",
                         "Event Reason",
                         "19990102 14:00:00",
                         "Specimen Source",
                         "Ordering Provider",
                         "Requested Procedure Description",
                         "Requested Procedure Code Sequence",
                         "Occurrence Number",
                         "Appointment Timing Quantity");
  dbInterface.insert(rp);
}

void remove(MDBInterface& dbInterface)
{
  MRequestedProcedure rp;
  MCriteriaVector cv;
  MCriteria c1, c2;

  c1.attribute = "reqproid";
  c1.oper = TBL_EQUAL;
  c1.value = "Requested Procedure ID";

  c2.attribute = "filordnum";
  c2.oper = TBL_EQUAL;
  c2.value = "Filler Order Number";

  cv.push_back(c1); 
  cv.push_back(c2); 

  dbInterface.remove(rp, cv);
}

void update(MDBInterface& dbInterface)
{
  MRequestedProcedure rp;
  MCriteriaVector cv;
  MCriteria c1, c2;
  MUpdateVector uv;
  MUpdate u1, u2;

  c1.attribute = "reqproid";
  c1.oper = TBL_EQUAL;
  c1.value = "Requested Procedure ID";

  c2.attribute = "filordnum";
  c2.oper = TBL_EQUAL;
  c2.value = "Filler Order Number";

  cv.push_back(c1); 
  cv.push_back(c2); 

  u1.attribute = "accnum";
  u1.func = TBL_SET;
  u1.value = "ACC 0001";

  u2.attribute = "occnum";
  u2.func = TBL_SET;
  u2.value = "OCC 0001";

  uv.push_back(u1); 
  uv.push_back(u2); 

  dbInterface.update(rp, cv, uv);
}

void select(MDBInterface& dbInterface)
{
  MRequestedProcedure rp;
  MCriteriaVector cv;
  MCriteria c1, c2;

  c1.attribute = "reqproid";
  c1.oper = TBL_EQUAL;
  c1.value = "Requested Procedure ID";

  c2.attribute = "filordnum";
  c2.oper = TBL_EQUAL;
  c2.value = "Filler Order Number";

  cv.push_back(c1); 
  cv.push_back(c2); 

  dbInterface.select(rp, cv, processRow);
}

void get(MDBInterface& dbInterface)
{
  MRequestedProcedure rp;
  MCriteriaVector cv;
  MCriteria c1, c2;

  c1.attribute = "reqproid";
  c1.oper = TBL_EQUAL;
  c1.value = "Requested Procedure ID";

  c2.attribute = "filordnum";
  c2.oper = TBL_EQUAL;
  c2.value = "Filler Order Number";

  cv.push_back(c1); 
  cv.push_back(c2); 

  dbInterface.select(rp, cv, NULL);

  cout << "Attribute" << "\t" << "Value" << endl;
  MDomainMap& m = rp.map();

  for (MDomainMap::iterator i = m.begin(); i != m.end(); i++)
    cout << (*i).first << "\t\t" << (*i).second << endl;
}

void processRow(MDomainObject& o)
{
  MDomainMap& m = o.map();

  cout << "Attribute" << "\t" << "Value" << endl;

  for (MDomainMap::iterator i = m.begin(); i != m.end(); i++)
    cout << (*i).first << "\t\t" << (*i).second << endl;

  cout << endl;
}
