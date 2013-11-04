#include "MESA.hpp"
#include "MSRContentItemCode.hpp"

static char rcsid[] = "$Id: MSRContentItemCode.cpp,v 1.7 2005/03/04 22:08:15 smm Exp $";

MSRContentItemCode::MSRContentItemCode()
{
}

MSRContentItemCode::MSRContentItemCode(const MSRContentItemCode& cpy) :
  MSRContentItem(cpy) ,
  mConceptNameValue(cpy.mConceptNameValue),
  mConceptNameDesignator(cpy.mConceptNameDesignator),
  mConceptNameMeaning(cpy.mConceptNameMeaning),
  mCodeNameValue(cpy.mCodeNameValue),
  mCodeNameDesignator(cpy.mCodeNameDesignator),
  mCodeNameMeaning(cpy.mCodeNameMeaning)
{
}

MSRContentItemCode::~MSRContentItemCode()
{
}

void
MSRContentItemCode::printOn(ostream& s) const
{
  MSRContentItem::printOn(s);
  s << this->mConceptNameValue
    << " " << this->mConceptNameDesignator
    << " " << this->mConceptNameMeaning
    << this->mCodeNameValue
    << " " << this->mCodeNameDesignator
    << " " << this->mCodeNameMeaning;
}

void
MSRContentItemCode::streamIn(istream& s)
{
  //s >> this->member;
}

// Non boiler plate methods to follow

MSRContentItemCode::MSRContentItemCode(const MSRContentItem& cpy) :
  MSRContentItem(cpy),
  mConceptNameValue(""),
  mConceptNameDesignator(""),
  mConceptNameMeaning(""),
  mCodeNameValue(""),
  mCodeNameDesignator(""),
  mCodeNameMeaning("")
{
}

void
MSRContentItemCode::conceptNameValue(const MString& s)
{
  mConceptNameValue = s;
}

void
MSRContentItemCode::conceptNameDesignator(const MString& s)
{
  mConceptNameDesignator = s;
}

void
MSRContentItemCode::conceptNameMeaning(const MString& s)
{
  mConceptNameMeaning = s;
}

void
MSRContentItemCode::codeNameValue(const MString& s)
{
  mCodeNameValue = s;
}

void
MSRContentItemCode::codeNameDesignator(const MString& s)
{
  mCodeNameDesignator = s;
}

void
MSRContentItemCode::codeNameMeaning(const MString& s)
{
  mCodeNameMeaning = s;
}

MString
MSRContentItemCode::conceptNameValue( ) const
{
  return mConceptNameValue;
}

MString
MSRContentItemCode::conceptNameDesignator( ) const
{
  return mConceptNameDesignator;
}

MString
MSRContentItemCode::conceptNameMeaning( ) const
{
  return mConceptNameMeaning;
}

MString
MSRContentItemCode::codeNameValue( ) const
{
  return mCodeNameValue;
}

MString
MSRContentItemCode::codeNameDesignator( ) const
{
  return mCodeNameDesignator;
}

MString
MSRContentItemCode::codeNameMeaning( ) const
{
  return mCodeNameMeaning;
}

bool
MSRContentItemCode::isLevel1Equivalent(MSRContentItem* rhs, bool verbose) const
{
  if (!this->isTypeEqual(*rhs))
    return false;

  MSRContentItemCode* rhsP = (MSRContentItemCode*)rhs;

  if (verbose) {
    cout << mConceptNameValue << ":"
	 << mConceptNameDesignator << ":"
	 << mConceptNameMeaning << endl;
    cout << rhsP->mConceptNameValue
	 << ":" << rhsP->mConceptNameDesignator
	 << ":" << rhsP->mConceptNameMeaning << endl;
  }

  if (mConceptNameValue != rhsP->mConceptNameValue)
    return false;

  if (mConceptNameDesignator != rhsP->mConceptNameDesignator)
    return false;

  char b1[1024];
  char b2[1024];
  mConceptNameMeaning.safeExport(b1, sizeof(b1));
  rhsP->mConceptNameMeaning.safeExport(b2, sizeof(b2));

//  if (mConceptNameMeaning != rhsP->mConceptNameMeaning)
//    return false;

  if (verbose) {
    cout << " Level 1 match" << endl;
  }

  return true;
}

