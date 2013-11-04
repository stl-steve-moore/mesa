#include <iostream>
#include <string>
#include "MESA.hpp"
#include "MHL7Factory.hpp"
#include "MHL7Msg.hpp"

using namespace std;

int main(int argc, char** argv)
{
  MHL7Factory f("", ".v22");
  MHL7Msg* m;

  argv++;
  m = f.readFromFile(*argv);

  MHL7Msg* ack = f.produceACK(*m);

  ack->streamOut(cout);

  char buf[8192];
  int length = 0;

  ack->exportToWire(buf, sizeof(buf), length);
  cout << "Message Length: " << length << endl;
  cout << buf << endl;

  return 0;
}
