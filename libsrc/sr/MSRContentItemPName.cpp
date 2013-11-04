#include "MESA.hpp"
#include "MSRContentItemPName.hpp"

static char rcsid[] = "$Id: MSRContentItemPName.cpp,v 1.5 2001/08/27 15:23:37 smm Exp $";

MSRContentItemPName::MSRContentItemPName()
{
}

MSRContentItemPName::MSRContentItemPName(const MSRContentItemPName& cpy) :
  MSRContentItem(cpy) ,
  mConceptNameValue(cpy.mConceptNameValue),
  mConceptNameDesignator(cpy.mConceptNameDesignator),
  mConceptNameMeaning(cpy.mConceptNameMeaning),
  mPersonName(cpy.mPersonName)
{
}

MSRContentItemPName::~MSRContentItemPName()
{
}

void
MSRContentItemPName::printOn(ostream& s) const
{
  MSRContentItem::printOn(s);
  s << this->mConceptNameValue
    << " " << this->mConceptNameDesignator
    << " " << this->mConceptNameMeaning
    << " " << this->mPersonName;
}

void
MSRContentItemPName::streamIn(istream& s)
{
  //s >> this->member;
}

// Non boiler plate methods to follow

MSRContentItemPName::MSRContentItemPName(const MSRContentItem& cpy) :
  MSRContentItem(cpy),
  mConceptNameValue(""),
  mConceptNameDesignator(""),
  mConceptNameMeaning(""),
  mPersonName("")
{
}

void
MSRContentItemPName::conceptNameValue(const MString& s)
{
  mConceptNameValue = s;
}

void
MSRContentItemPName::conceptNameDesignator(const MString& s)
{
  mConceptNameDesignator = s;
}

void
MSRContentItemPName::conceptNameMeaning(const MString& s)
{
  mConceptNameMeaning = s;
}

void
MSRContentItemPName::personName(const MString& s)
{
  mPersonName = s;
}

MString
MSRContentItemPName::conceptNameValue( ) const
{
  return mConceptNameValue;
}

MString
MSRContentItemPName::conceptNameDesignator( ) const
{
  return mConceptNameDesignator;
}

MString
MSRContentItemPName::conceptNameMeaning( ) const
{
  return mConceptNameMeaning;
}

MString
MSRContentItemPName::personName( ) const
{
  return mPersonName;
}

bool
MSRContentItemPName::isLevel1Equivalent(MSRContentItem* rhs, bool verbose ) const
{
  if (!this->isTypeEqual(*rhs))
    return false;

  MSRContentItemPName* rhsP = (MSRContentItemPName*)rhs;

  if (verbose) {
    cout << mConceptNameValue << ":"
	 << mConceptNameDesignator << ":"
	 << mConceptNameMeaning << ":"
	 << mPersonName << endl;
    cout << rhsP->mConceptNameValue << ":"
	 << rhsP->mConceptNameDesignator << ":"
	 << rhsP->mConceptNameMeaning << ":"
	 << rhsP->mPersonName << endl;
  }

  if (mConceptNameValue != rhsP->mConceptNameValue)
    return false;

  if (mConceptNameDesignator != rhsP->mConceptNameDesignator)
    return false;

  if (mConceptNameMeaning != rhsP->mConceptNameMeaning)
    return false;

  if (mPersonName != rhsP->mPersonName)
    return false;

  if (verbose) {
    cout << " Level 1 match" << endl;
  }

  return true;
}
