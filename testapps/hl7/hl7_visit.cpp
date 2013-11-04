#include <iostream>
#include <string>
#include "MESA.hpp"
#include "MHL7Factory.hpp"
#include "MHL7Msg.hpp"

#include "MPatient.hpp"
#include "MVisit.hpp"
#include "MHL7DomainXlate.hpp"

using namespace std;

int main(int argc, char** argv)
{
  MHL7Factory f("", ".v22");
  MHL7Msg* m;

  argv++;
  m = f.readFromFile(*argv);

  MHL7DomainXlate xLate;
  MVisit visit;

  xLate.translateHL7(*m, visit);
  cout << visit << endl;
  return 0;
}
