#include <iostream>
#include <string>
#include "MESA.hpp"
#include "MDBADT.hpp"
#include "MDomainObject.hpp"
#include "MDBInterface.hpp"
#include "MVisit.hpp"

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
  MVisit v("1", "Patient ID", "Issuer", "High Class", "Location", "Doctor", "19990102", "14:00:00");
  dbInterface.insert(v);
}

void remove(MDBInterface& dbInterface)
{
  MVisit v;
  MCriteriaVector cv;
  MCriteria c1, c2;

  c1.attribute = "patid";
  c1.oper = TBL_EQUAL;
  c1.value = "Patient ID";

  c2.attribute = "asspatloc";
  c2.oper = TBL_EQUAL;
  c2.value = "Location";

  cv.push_back(c1); 
  cv.push_back(c2); 

  dbInterface.remove(v, cv);
}

void update(MDBInterface& dbInterface)
{
  MVisit v;
  MCriteriaVector cv;
  MCriteria c1, c2;
  MUpdateVector uv;
  MUpdate u1, u2;

  c1.attribute = "patid";
  c1.oper = TBL_EQUAL;
  c1.value = "Patient ID";

  c2.attribute = "admdat";
  c2.oper = TBL_EQUAL;
  c2.value = "19990102";

  cv.push_back(c1); 
  cv.push_back(c2); 

  u1.attribute = "issuer";
  u1.func = TBL_SET;
  u1.value = "Issuer1";

  u2.attribute = "attdoc";
  u2.func = TBL_SET;
  u2.value = "Kevorkian";

  uv.push_back(u1); 
  uv.push_back(u2); 

  dbInterface.update(v, cv, uv);
}

void select(MDBInterface& dbInterface)
{
  MVisit v;
  MCriteriaVector cv;
  MCriteria c1, c2;

  c1.attribute = "patid";
  c1.oper = TBL_EQUAL;
  c1.value = "Patient ID";

  c2.attribute = "admdat";
  c2.oper = TBL_EQUAL;
  c2.value = "19990102";

  cv.push_back(c1); 
  cv.push_back(c2); 

  dbInterface.select(v, cv, processRow);
}

void get(MDBInterface& dbInterface)
{
  MVisit v;
  MCriteriaVector cv;
  MCriteria c1, c2;

  c1.attribute = "patid";
  c1.oper = TBL_EQUAL;
  c1.value = "Patient ID";

  c2.attribute = "admdat";
  c2.oper = TBL_EQUAL;
  c2.value = "19990102";

  cv.push_back(c1); 
  cv.push_back(c2); 

  dbInterface.select(v, cv, NULL);

  cout << "Attribute" << "\t" << "Value" << endl;
  MDomainMap& m = v.map();

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
