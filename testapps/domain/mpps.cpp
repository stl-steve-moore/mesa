#include <iostream>
#include <string>
#include "MESA.hpp"
#include "MDBADT.hpp"
#include "MDomainObject.hpp"
#include "MDBInterface.hpp"
#include "MMPPS.hpp"

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
  MMPPS mpps("Saeed Akbani",
           "ID-0001",
           "19661013",
           "M",
           "ID-PPS001",
           "AE Title",
           "No Name",
           "Good Location",
           "19990520",
           "120000",
           "Good Status",
           "No Description Available",
           "Type Description also not Available",
           "19991231",
           "000000",
           "Modality",
           "Study ID",
           "Performed Series Sequence",
           "Scheduled Step Attributes Sequence",
           "Referenced Study Component Sequence");
  dbInterface.insert(mpps);
}

void remove(MDBInterface& dbInterface)
{
  MMPPS mpps;
  MCriteriaVector cv;
  MCriteria c1, c2;

  c1.attribute = "patnam";
  c1.oper = TBL_EQUAL;
  c1.value = "Saeed Akbani";

  c2.attribute = "patsex";
  c2.oper = TBL_EQUAL;
  c2.value = "M";

  cv.push_back(c1); 
  cv.push_back(c2); 

  dbInterface.remove(mpps, cv);
}

void update(MDBInterface& dbInterface)
{
  MMPPS mpps;
  MCriteriaVector cv;
  MCriteria c1, c2;
  MUpdateVector uv;
  MUpdate u1, u2;

  c1.attribute = "patnam";
  c1.oper = TBL_EQUAL;
  c1.value = "Saeed Akbani";

  c2.attribute = "patsex";
  c2.oper = TBL_EQUAL;
  c2.value = "M";

  cv.push_back(c1); 
  cv.push_back(c2); 

  u1.attribute = "patnam";
  u1.func = TBL_SET;
  u1.value = "Steve Moore";

  u2.attribute = "ppsdes";
  u2.func = TBL_SET;
  u2.value = "Description is Avaliable";

  uv.push_back(u1); 
  uv.push_back(u2); 

  dbInterface.update(mpps, cv, uv);
}

void select(MDBInterface& dbInterface)
{
  MMPPS mpps;
  MCriteriaVector cv;
  MCriteria c1, c2;

  c1.attribute = "patnam";
  c1.oper = TBL_EQUAL;
  c1.value = "Saeed Akbani";

  c2.attribute = "patsex";
  c2.oper = TBL_EQUAL;
  c2.value = "M";

  cv.push_back(c1); 
  cv.push_back(c2); 

  dbInterface.select(mpps, cv, processRow);
}

void get(MDBInterface& dbInterface)
{
  MMPPS mpps;
  MCriteriaVector cv;
  MCriteria c1, c2;

  c1.attribute = "patnam";
  c1.oper = TBL_EQUAL;
  c1.value = "Saeed Akbani";

  c2.attribute = "patsex";
  c2.oper = TBL_EQUAL;
  c2.value = "M";

  cv.push_back(c1); 
  cv.push_back(c2); 

  dbInterface.select(mpps, cv, NULL);

  cout << "Attribute" << "\t" << "Value" << endl;
  MDomainMap& m = mpps.map();

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
