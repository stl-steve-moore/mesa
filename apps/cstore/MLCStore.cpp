#include "MESA.hpp"
#include "MLCStore.hpp"

static char rcsid[] = "$Id: MLCStore.cpp,v 1.1 2000/06/02 03:08:57 smm Exp $";

MLCStore::MLCStore()
{
}

MLCStore::MLCStore(const MLCStore& cpy)
{
}

MLCStore::~MLCStore()
{
}

void
MLCStore::printOn(ostream& s) const
{
  s << "MLCStore";
}

void
MLCStore::streamIn(istream& s)
{
  //s >> this->member;
}

// Non boiler-plate below


CONDITION
MLCStore::handleCStoreResponse(DUL_PRESENTATIONCONTEXT* ctx,
			       MSG_C_STORE_RESP** message,
			       DUL_ASSOCIATESERVICEPARAMETERS* params)
{
  return SRV_NORMAL;
}
