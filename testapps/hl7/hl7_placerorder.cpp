#include <iostream>
#include <string>
#include "MESA.hpp"
#include "MHL7Factory.hpp"
#include "MHL7Msg.hpp"

#include "MPatient.hpp"
#include "MVisit.hpp"
#include "MPlacerOrder.hpp"
#include "MOrder.hpp"
#include "MHL7DomainXlate.hpp"

using namespace std;

int main(int argc, char** argv)
{
  MHL7Factory f("", ".v22");
  MHL7Msg* m;

  argv++;
  m = f.readFromFile(*argv);

  MHL7DomainXlate xLate;
  MPlacerOrder placerOrder;

  xLate.translateHL7(*m, placerOrder);
  cout << placerOrder << endl;

  MOrder& order = placerOrder.order(0);
  cout << order << endl;

  return 0;
}
