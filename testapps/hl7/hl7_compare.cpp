#include <iostream>
#include <string>
#include "MESA.hpp"
#include "MHL7Compare.hpp"
#include "MHL7Msg.hpp"

using namespace std;

int usage ()
{
  cout << "usage: hl7_compare [-b hl7 segment definition base] <existing file name> <new file name>" << endl;
  exit(1);
}

int main(int argc, char** argv)
{

  MString hl7Base("/opt/mesa/runtime/");
  MString hl7Definition(".ihe");

   while (--argc > 0 && (*++argv)[0] == '-') {
    switch(*(argv[0] + 1)) {
    case 'b':
      argc--; argv++;
      if (argc < 1)
	usage();
      hl7Base = MString(*argv) + "/";
      break;
    case 'd':
      argc--; argv++;
      if (argc < 1)
	usage();
      hl7Definition = MString(".") + *argv;
      break;
    default:
      break;
    }
  }
 
  if (argc < 2)
    usage();

  MHL7Compare *c;

//c = new MHL7Compare("ADT2", "ADT21");
  //c = new MHL7Compare(*(argv++), *(argv), hl7Base, hl7Definition);
  c = new MHL7Compare(hl7Base, hl7Definition);
  
  if ( (c.compare(*(argv++), *(argv))) == -1)
    exit (1);

  if (c->count())
  {
    cout << "There is (are) " << c->count() << " " << "difference(s)" << endl;
    MDiff mDiff = c->getDiff();
    for (MDiff::iterator i = mDiff.begin(); i != mDiff.end(); i++)
    {
      cout << "Segment Name: " << (*i).first << endl;
      cout << "Field Number: " << ((*i).second).fldNum << endl;
      cout << "Master Value: " << ((*i).second).existValue << endl;
      cout << "Test Value: " << ((*i).second).newValue << endl;
      cout << "Comment: " << ((*i).second).comment << endl << endl;
    }
  }
  else
    cout << "Test matches Master: Message OK" << endl;

  return 0;
}
