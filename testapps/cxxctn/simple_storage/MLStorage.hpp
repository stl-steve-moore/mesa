// $Id: MLStorage.hpp,v 1.2 1999/06/25 22:13:33 smm Exp $ $Author: smm $ $Revision: 1.2 $ $Date: 1999/06/25 22:13:33 $ $State: Exp $
//
// ====================
//  = LIBRARY
//	xxx
//
//  = FILENAME
//	MLStorage.hpp
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
//	$Revision: 1.2 $
//
//  = DATE RELEASED
//	$Date: 1999/06/25 22:13:33 $
//
//  = COMMENTTEXT
//	Comments

#ifndef MLStorageISIN
#define MLStorageISIN

#include <iostream>
#include <string>

#include "MESA.hpp"
#include "MSOPStorageHandler.hpp"

using namespace std;

class MLStorage : public MSOPStorageHandler
// = TITLE
//	Short title/description
//
// = DESCRIPTION
//	Describe the class and how to use it
{
public:
  // = The standard methods in this framework.
  MLStorage();
  // Default constructor
  MLStorage(const MLStorage& cpy);
  virtual ~MLStorage();
  virtual void printOn(ostream& s) const;
  // This method is used in conjunction with the streaming operator <<
  // to print the current state of MLStorage

  virtual void streamIn(istream& s);

  handleCStoreCommand(DUL_PRESENTATIONCONTEXT* ctx,
		      MSG_C_STORE_REQ** message,
		      MSG_C_STORE_RESP* response,
		      DUL_ASSOCIATESERVICEPARAMETERS* params,
		      MString& fileName);
  
  // = Class specific methods.
private:
};

inline ostream& operator<< (ostream& s, const MLStorage& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MLStorage& c) {
  c.streamIn(s);
  return s;
}

#endif
