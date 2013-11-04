#include <iostream>
#include <string>
#include "MESA.hpp"
#include "MHL7Factory.hpp"
#include "MHL7Msg.hpp"

#include "MPatient.hpp"
#include "MHL7DomainXlate.hpp"

using namespace std;

int main(int argc, char** argv)
{
  MHL7Factory f("", ".v22");
  MHL7Msg* m;

  argv++;
  m = f.readFromFile(*argv);

  m->streamOut(cout);

  return 0;
}
