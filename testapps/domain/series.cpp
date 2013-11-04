#include <iostream>
#include <string>
#include "MESA.hpp"
#include "MDBADT.hpp"
#include "MDomainObject.hpp"
#include "MDBInterface.hpp"
#include "MSeries.hpp"

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
  MSeries series("Study Instance UID",
           "Series Instance UID",
           "Modality",
           "SN-0001",
           "Protocol ABC",
           "No Description Avaliable");
  dbInterface.insert(series);
}

void remove(MDBInterface& dbInterface)
{
  MSeries series;
  MCriteriaVector cv;
  MCriteria c1, c2;

  c1.attribute = "stuinsuid";
  c1.oper = TBL_EQUAL;
  c1.value = "Study Instance UID";

  c2.attribute = "mod";
  c2.oper = TBL_EQUAL;
  c2.value = "Modality";

  cv.push_back(c1); 
  cv.push_back(c2); 

  dbInterface.remove(series, cv);
}

void update(MDBInterface& dbInterface)
{
  MSeries series;
  MCriteriaVector cv;
  MCriteria c1, c2;
  MUpdateVector uv;
  MUpdate u1, u2;

  c1.attribute = "stuinsuid";
  c1.oper = TBL_EQUAL;
  c1.value = "Study Instance UID";

  c2.attribute = "mod";
  c2.oper = TBL_EQUAL;
  c2.value = "Modality";

  cv.push_back(c1); 
  cv.push_back(c2); 

  u1.attribute = "sernum";
  u1.func = TBL_SET;
  u1.value = "SN-002";

  u2.attribute = "pronam";
  u2.func = TBL_SET;
  u2.value = "Protocol-XYZ";

  uv.push_back(u1); 
  uv.push_back(u2); 

  dbInterface.update(series, cv, uv);
}

void select(MDBInterface& dbInterface)
{
  MSeries series;
  MCriteriaVector cv;
  MCriteria c1, c2;

  c1.attribute = "stuinsuid";
  c1.oper = TBL_EQUAL;
  c1.value = "Study Instance UID";

  c2.attribute = "mod";
  c2.oper = TBL_EQUAL;
  c2.value = "Modality";

  cv.push_back(c1); 
  cv.push_back(c2); 

  dbInterface.select(series, cv, processRow);
}

void get(MDBInterface& dbInterface)
{
  MSeries series;
  MCriteriaVector cv;
  MCriteria c1, c2;

  c1.attribute = "stuinsuid";
  c1.oper = TBL_EQUAL;
  c1.value = "Study Instance UID";

  c2.attribute = "mod";
  c2.oper = TBL_EQUAL;
  c2.value = "Modality";

  cv.push_back(c1); 
  cv.push_back(c2); 

  dbInterface.select(series, cv, NULL);

  cout << "Attribute" << "\t" << "Value" << endl;
  MDomainMap& m = series.map();

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
