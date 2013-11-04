#include "MESA.hpp"
#include "MString.hpp"

//test driver for the getToken method in MString, 
//which will be used to retrieve specific components from 
//HL7 values

using namespace std;
usage()
{
  char msg[] = "\nUsage: <string> <delimiter> <token number>\n";
  cerr << msg << endl;
  exit(1);
}

int main(int argc, char** argv)
{
  if (argc < 3)
    usage();
  argc--; argv++;
  MString testString(*argv);
  argc--; argv++;
  char delimiter = **argv;
  argc--; argv++;
  int num = atoi(*argv);
  cout << "Retrieving token number " << num << " from "
       << testString << " with delimiter " << delimiter << endl;
  cout << "--> " << testString.getToken(delimiter, (num-1)) << endl;
}
