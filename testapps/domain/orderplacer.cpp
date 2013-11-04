#include <iostream>
#include <string>
#include "MESA.hpp"
#include "MDBADT.hpp"
#include "MDBOrderPlacer.hpp"

void insert( MDBOrderPlacer& op );
void remove( MDBOrderPlacer& op );
void update( MDBOrderPlacer& op );
void select( MDBOrderPlacer& op );
void get( MDBOrderPlacer& op ); // gets only one row
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

  MDBOrderPlacer orderPlacer(*argv);

  switch(func)
  {
    case 'i':
        insert(orderPlacer);
        break;
    case 'r':
        remove(orderPlacer);
        break;
    case 'u':
        update(orderPlacer);
        break;
    case 's':
        select(orderPlacer);
        break;
    case 'g':
        get(orderPlacer);
        break;
    default:
        usage();
        break;
  }  //endcase

  return 0;
}

void insert(MDBOrderPlacer& op)
{
  MPatient p("0000ID1", "Issuer", "0000ID2", "Issuer2", "Steve Moore", "19990102", "M");
  MVisit v("V-0001", "0000ID1", "Issuer", "Low Class", "Good Location", "Doctor Kevorkian", "19991231", "12:00:00");
  op.admitRegisterPatient(p,v);
}

void remove(MDBOrderPlacer& op)
{ /*
  MPatient p;
  MCriteriaVector cv;
  MCriteria c1, c2;

  c1.attribute = "nam";
  c1.oper = TBL_EQUAL;
  c1.value = "Steve Moore";

  c2.attribute = "datbir";
  c2.oper = TBL_EQUAL;
  c2.value = "19990102";

  cv.push_back(c1); 
  cv.push_back(c2); 

  op.remove(p, cv); */
}

void update(MDBOrderPlacer& op)
{
  MPatient p;
//p.patientID("0000ID1");
  p.patientID("0000ID2");
  p.issuerOfPatientID("Issuer");
  p.patientName("Saeed Akbani");
  op.updatePatient(p);
}

void select(MDBOrderPlacer& op)
{ /*
  MPatient p;
  MCriteriaVector cv;
  MCriteria c1, c2;

  c1.attribute = "nam";
  c1.oper = TBL_EQUAL;
  c1.value = "Steve Moore";

  c2.attribute = "datbir";
  c2.oper = TBL_EQUAL;
  c2.value = "19990102";

  cv.push_back(c1); 
  cv.push_back(c2); 

  op.select(p, cv, processRow); */
}

void get(MDBOrderPlacer& op)
{ /*
  MPatient p;
  MCriteriaVector cv;
  MCriteria c1, c2;

  c1.attribute = "nam";
  c1.oper = TBL_EQUAL;
  c1.value = "Steve Moore";

  c2.attribute = "datbir";
  c2.oper = TBL_EQUAL;
  c2.value = "19990102";

  cv.push_back(c1); 
  cv.push_back(c2); 

  op.select(p, cv, NULL);

  cout << "Attribute" << "\t" << "Value" << endl;
  MDomainMap& m = p.map();

  for (MDomainMap::iterator i = m.begin(); i != m.end(); i++)
    cout << (*i).first << "\t\t" << (*i).second << endl;
 */
} 

void processRow(MDomainObject& o)
{
  MDomainMap& m = o.map();

  cout << "Attribute" << "\t" << "Value" << endl;

  for (MDomainMap::iterator i = m.begin(); i != m.end(); i++)
    cout << (*i).first << "\t\t" << (*i).second << endl;

  cout << endl;
}
