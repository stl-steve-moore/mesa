// $Id: MLCStore.hpp,v 1.1 2000/06/02 03:08:57 smm Exp $ $Author: smm $ $Revision: 1.1 $ $Date: 2000/06/02 03:08:57 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MLCStore.hpp
//
//  = AUTHOR
//	Steve Moore
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
//	$Date: 2000/06/02 03:08:57 $
//
//  = COMMENTS
//

#ifndef MLCStoreISIN
#define MLCStoreISIN

#include <iostream>
#include <string>

#include "MSOPHandler.hpp"

using namespace std;

class MLCStore : public MSOPHandler
// = TITLE
//	Short title/description
//
// = DESCRIPTION
//	Describe the class and how to use it
{
public:
  // = The standard methods in this framework.
  MLCStore();
  // Default constructor
  MLCStore(const MLCStore& cpy);
  virtual ~MLCStore();
  virtual void printOn(ostream& s) const;
  // This method is used in conjunction with the streaming operator <<
  // to print the current state of MLCStore

  virtual void streamIn(istream& s);
  
  // = Class specific methods.

  CONDITION handleCStoreResponse(DUL_PRESENTATIONCONTEXT* ctx,
				 MSG_C_STORE_RESP** message,
				 DUL_ASSOCIATESERVICEPARAMETERS* params);
private:
};

inline ostream& operator<< (ostream& s, const MLCStore& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MLCStore& c) {
  c.streamIn(s);
  return s;
}

#endif
