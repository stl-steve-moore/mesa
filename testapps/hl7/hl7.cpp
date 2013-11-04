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

  string s;

  s = m->firstSegment();

  while (s != "") {
    cout << s << endl;
    s = m->nextSegment();
  }

  m->streamOut(cout);

  MHL7DomainXlate xLate;
  MPatient patient;

  xLate.translateHL7(*m, patient);
  return 0;
}
