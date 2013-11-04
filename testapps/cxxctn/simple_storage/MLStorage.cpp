#include "MESA.hpp"
#include "MLStorage.hpp"

MLStorage::MLStorage()
{
}

MLStorage::MLStorage(const MLStorage& cpy)
{
}

MLStorage::~MLStorage()
{
}

void
MLStorage::printOn(ostream& s) const
{
  s << "MLStorage";
}

void
MLStorage::streamIn(istream& s)
{
  //s >> this->member;
}

// Non-boiler plate methods to follow

MLStorage::handleCStoreCommand(DUL_PRESENTATIONCONTEXT* ctx,
			       MSG_C_STORE_REQ** message,
			       MSG_C_STORE_RESP* response,
			       DUL_ASSOCIATESERVICEPARAMETERS* params,
			       MString& fileName)
{
  fileName = (*message)->instanceUID;

}
