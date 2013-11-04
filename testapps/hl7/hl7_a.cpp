#include <iostream>
#include <fstream>
#include <string>
#include "MESA.hpp"
#include "MHL7Factory.hpp"
#include "MHL7Messenger.hpp"
#include "MHL7Msg.hpp"
#include "MHL7Handler.hpp"

#include "MPatient.hpp"
#include "MHL7DomainXlate.hpp"

using namespace std;

readFile(const char* fileName, char* txt, int length)
{
  ifstream f(fileName);

  char* p = txt;
  while(f.getline(p, length)) {
    if (p[0] == '#')
      continue;
    p += f.gcount() - 1;
    length -= (f.gcount() - 1);
  }
  *p++ = 0x0d;
  *p = '\0';
}

int main(int argc, char** argv)
{
  MHL7Factory factory("", ".v22");
  MHL7Msg* m;

  argv++;

  MHL7Messenger messenger(factory);

  char buf[8192];
  readFile(*argv, buf, sizeof(buf));

  MHL7Handler handler(messenger);
  handler.handleInput(buf, strlen(buf));

#if 0
  m = f.readFromFile(*argv);

  string s;

  s = m->firstSegment();

  while (s != "") {
    cerr << s << endl;
    s = m->nextSegment();
  }

  MHL7DomainXlate xLate;
  MPatient patient;

  xLate.translateHL7(*m, patient);
#endif
  return 0;
}
