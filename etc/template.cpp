#include "MESA.hpp"
#include "CLASS.hpp"

static char rcsid[] = "$Id: template.cpp,v 1.3 1999/06/01 20:29:32 smm Exp $";

CLASS::CLASS()
{
}

CLASS::CLASS(const CLASS& cpy)
{
}

CLASS::~CLASS()
{
}

void
CLASS::printOn(ostream& s) const
{
  s << "CLASS";
}

void
CLASS::streamIn(istream& s)
{
  //s >> this->member;
}
