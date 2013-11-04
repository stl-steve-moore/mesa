#include <iostream>
#include <string>
#include "MESA.hpp"
//#include "ctn_api.h"
#include "MSPS.hpp"
#include "MActionItem.hpp"
#include "MDICOMDomainXlate.hpp"
#include "MDICOMWrapper.hpp"

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
  if (argc < 1)
    usage();

  argc--; argv++;
  DCM_OBJECT* obj;
  CONDITION cond = ::DCM_OpenFile(*argv, DCM_ORDERLITTLEENDIAN, &obj);

  MDICOMWrapper w(obj);

  MDICOMDomainXlate xlate;

  MSPS sps;
  MActionItemVector v;
  xlate.translateDICOM(w, sps, v);

  cout << sps << endl;

  MActionItemVector::iterator vi = v.begin();
  while (vi != v.end()) {
    cout << (*vi).codeValue() << endl;

    vi++;
  }

  DCM_OBJECT* obj2;

  ::DCM_CreateObject(&obj2, 0);

  xlate.translateDICOM(sps, v, obj, obj2);

  ::DCM_DumpElements(&obj2, 1);

  return 0;
}
