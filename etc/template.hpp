// $Id: template.hpp,v 1.1 1999/04/28 04:03:47 smm Exp $ $Author: smm $ $Revision: 1.1 $ $Date: 1999/04/28 04:03:47 $ $State: Exp $
//
// ====================
//  = LIBRARY
//	xxx
//
//  = FILENAME
//	template.hpp
//
//  = AUTHOR
//	Author Name
//
//  = COPYRIGHT
//	Copyright Washington University, 1999
//
// ====================
//
//  = VERSION
//	$Revision: 1.1 $
//
//  = DATE RELEASED
//	$Date: 1999/04/28 04:03:47 $
//
//  = COMMENTTEXT
//	Comments

#ifndef CLASSISIN
#define CLASSISIN

#include <iostream>
#include <string>

using namespace std;

class CLASS
// = TITLE
//	Short title/description
//
// = DESCRIPTION
//	Describe the class and how to use it
{
public:
  // = The standard methods in this framework.
  CLASS();
  // Default constructor
  CLASS(const CLASS& cpy);
  virtual ~CLASS();
  virtual void printOn(ostream& s) const;
  // This method is used in conjunction with the streaming operator <<
  // to print the current state of CLASS

  virtual void streamIn(istream& s);
  
  // = Class specific methods.
private:
};

inline ostream& operator<< (ostream& s, const CLASS& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, CLASS& c) {
  c.streamIn(s);
  return s;
}

#endif
