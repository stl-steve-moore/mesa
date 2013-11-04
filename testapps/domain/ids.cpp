#include <iostream>
#include <string>
#include "MESA.hpp"
#include "MDBOrderPlacer.hpp"
#include "MDBOrderFiller.hpp"

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
  MDBOrderPlacer orderPlacer(*argv);

  argc--; argv++;
  MDBOrderFiller orderFiller(*argv);

  MString s;
  s = orderPlacer.newPatientID();

  cout << s << endl;


  s = orderFiller.newStudyInstanceUID();
  cout << s << endl;
  return 0;
}
