#include <iostream>
#include <string>
#include "MPatient.hpp"
#include "MVisit.hpp"
#include "MPlacerOrder.hpp"

using namespace std;

int main(int argc, char** argv)
{
	string s(*argv);

	cout << s << endl;

	MPatient p;

	cout << p << endl;
	cin >> p;
	cout << p << endl;

  MPlacerOrder o;
  cout << o << endl;

  MVisit v;
  cout << v << endl;

  return 0;
}