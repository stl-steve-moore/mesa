#include <iostream>
#include <string>
#include "MESA.hpp"
#include "MDBADT.hpp"
#include "MDomainObject.hpp"
#include "MDBInterface.hpp"
#include "MSPS.hpp"

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
  MSPS sps("Step ID",
           "AE Title",
           "19990101",
           "08:00:00",
           "Modality",
           "Jack Kevorkian",
           "No Description Available",
           "Good Location",
           "PreMedication",
           "ContrastAgent");
  dbInterface.insert(sps);
}

void remove(MDBInterface& dbInterface)
{
  MSPS sps;
  MCriteriaVector cv;
  MCriteria c1, c2;

  c1.attribute = "spsid";
  c1.oper = TBL_EQUAL;
  c1.value = "Step ID";

  c2.attribute = "schperphynam";
  c2.oper = TBL_EQUAL;
  c2.value = "Jack Kevorkian";

  cv.push_back(c1); 
  cv.push_back(c2); 

  dbInterface.remove(sps, cv);
}

void update(MDBInterface& dbInterface)
{
  MSPS sps;
  MCriteriaVector cv;
  MCriteria c1, c2;
  MUpdateVector uv;
  MUpdate u1, u2;

  c1.attribute = "spsid";
  c1.oper = TBL_EQUAL;
  c1.value = "Step ID";

  c2.attribute = "schperphynam";
  c2.oper = TBL_EQUAL;
  c2.value = "Jack Kevorkian";

  cv.push_back(c1); 
  cv.push_back(c2); 

  u1.attribute = "schperphynam";
  u1.func = TBL_SET;
  u1.value = "Steve Moore";

  u2.attribute = "spsdes";
  u2.func = TBL_SET;
  u2.value = "Description is Avaliable";

  uv.push_back(u1); 
  uv.push_back(u2); 

  dbInterface.update(sps, cv, uv);
}

void select(MDBInterface& dbInterface)
{
  MSPS sps;
  MCriteriaVector cv;
  MCriteria c1, c2;

  c1.attribute = "spsid";
  c1.oper = TBL_EQUAL;
  c1.value = "Step ID";

  c2.attribute = "schperphynam";
  c2.oper = TBL_EQUAL;
  c2.value = "Jack Kevorkian";

  cv.push_back(c1); 
  cv.push_back(c2); 

  dbInterface.select(sps, cv, processRow);
}

void get(MDBInterface& dbInterface)
{
  MSPS sps;
  MCriteriaVector cv;
  MCriteria c1, c2;

  c1.attribute = "spsid";
  c1.oper = TBL_EQUAL;
  c1.value = "Step ID";

  c2.attribute = "schperphynam";
  c2.oper = TBL_EQUAL;
  c2.value = "Jack Kevorkian";

  cv.push_back(c1); 
  cv.push_back(c2); 

  dbInterface.select(sps, cv, NULL);

  cout << "Attribute" << "\t" << "Value" << endl;
  MDomainMap& m = sps.map();

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
