#include <iostream>
#include <string>
#include <stdio.h>
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

  m = f.produce();

  cin >> *m;

  char wire[1000];
  int len = 0;
  m->exportToWire(wire, sizeof(wire), len);
  ::fwrite(wire, 1, len, stdout);

  return 0;
}
