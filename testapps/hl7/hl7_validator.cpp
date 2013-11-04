#include <iostream>
#include <string>
#include "MESA.hpp"
#include "MHL7Validator.hpp"
#include "MHL7Msg.hpp"

using namespace std;

int main(int argc, char** argv)
{
  argv++;
//MHL7Validator v("2.2","", *argv);
  MHL7Validator *v;
  
  v = new MHL7Validator("2.2","", *argv);

  ERROR_INFO errInfo;

  if (!v->validateHL7Message(&errInfo))
  {
    cout << "Invalid HL7 Message" << endl;
    cout << "Segment Name: " << errInfo.segName << endl;
    cout << "Field Number: " << errInfo.fldNum << endl;
    cout << "Component Number: " << errInfo.compNum << endl;
    cout << "Sub Component Number: " << errInfo.subCompNum << endl;
    cout << "Error Type: " << errInfo.errorType << endl;
  }

  return 0;
}
