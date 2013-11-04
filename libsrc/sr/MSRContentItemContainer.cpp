#include "MESA.hpp"
#include "MSRContentItemContainer.hpp"

static char rcsid[] = "$Id: MSRContentItemContainer.cpp,v 1.3 2001/07/20 18:17:19 smm Exp $";

MSRContentItemContainer::MSRContentItemContainer()
{
}

MSRContentItemContainer::MSRContentItemContainer(const MSRContentItemContainer& cpy) :
  MSRContentItem(cpy) ,
  mConceptNameValue(cpy.mConceptNameValue),
  mConceptNameDesignator(cpy.mConceptNameDesignator),
  mConceptNameMeaning(cpy.mConceptNameMeaning)
{
}

MSRContentItemContainer::~MSRContentItemContainer()
{
}

void
MSRContentItemContainer::printOn(ostream& s) const
{
  MSRContentItem::printOn(s);
  s << this->mConceptNameValue
    << " " << this->mConceptNameDesignator
    << " " << this->mConceptNameMeaning;
}

void
MSRContentItemContainer::streamIn(istream& s)
{
  //s >> this->member;
}

// Non boiler plate methods to follow

MSRContentItemContainer::MSRContentItemContainer(const MSRContentItem& cpy) :
  MSRContentItem(cpy),
  mConceptNameValue(""),
  mConceptNameDesignator(""),
  mConceptNameMeaning("")
{
}

void
MSRContentItemContainer::conceptNameValue(const MString& s)
{
  mConceptNameValue = s;
}

void
MSRContentItemContainer::conceptNameDesignator(const MString& s)
{
  mConceptNameDesignator = s;
}

void
MSRContentItemContainer::conceptNameMeaning(const MString& s)
{
  mConceptNameMeaning = s;
}

MString
MSRContentItemContainer::conceptNameValue( ) const
{
  return mConceptNameValue;
}

MString
MSRContentItemContainer::conceptNameDesignator( ) const
{
  return mConceptNameDesignator;
}

MString
MSRContentItemContainer::conceptNameMeaning( ) const
{
  return mConceptNameMeaning;
}


bool
MSRContentItemContainer::isLevel1Equivalent(MSRContentItem* rhs, bool verbose ) const
{
  if (!this->isTypeEqual(*rhs))
    return false;

  MSRContentItemContainer* rhsP = (MSRContentItemContainer*)rhs;

  // These three tests examine the Title of the Container
  if (mConceptNameValue != rhsP->mConceptNameValue)
    return false;

  if (mConceptNameDesignator != rhsP->mConceptNameDesignator)
    return false;

  if (mConceptNameMeaning != rhsP->mConceptNameMeaning)
    return false;

   return true;
}

bool
MSRContentItemContainer::isLevel2Equivalent(MSRContentItem* rhs, bool verbose ) const
{
  return false;
}
