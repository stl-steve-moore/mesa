#include "MESA.hpp"
#include "MSRContentItemText.hpp"

static char rcsid[] = "$Id: MSRContentItemText.cpp,v 1.3 2001/08/27 15:23:22 smm Exp $";

MSRContentItemText::MSRContentItemText()
{
}

MSRContentItemText::MSRContentItemText(const MSRContentItemText& cpy) :
  MSRContentItem(cpy) ,
  mConceptNameValue(cpy.mConceptNameValue),
  mConceptNameDesignator(cpy.mConceptNameDesignator),
  mConceptNameMeaning(cpy.mConceptNameMeaning),
  mText(cpy.mText)
{
}

MSRContentItemText::~MSRContentItemText()
{
}

void
MSRContentItemText::printOn(ostream& s) const
{
  MSRContentItem::printOn(s);
  s << this->mConceptNameValue
    << " " << this->mConceptNameDesignator
    << " " << this->mConceptNameMeaning
    << " " << this->mText;
}

void
MSRContentItemText::streamIn(istream& s)
{
  //s >> this->member;
}

// Non boiler plate methods to follow

MSRContentItemText::MSRContentItemText(const MSRContentItem& cpy) :
  MSRContentItem(cpy),
  mConceptNameValue(""),
  mConceptNameDesignator(""),
  mConceptNameMeaning(""),
  mText("")
{
}

void
MSRContentItemText::conceptNameValue(const MString& s)
{
  mConceptNameValue = s;
}

void
MSRContentItemText::conceptNameDesignator(const MString& s)
{
  mConceptNameDesignator = s;
}

void
MSRContentItemText::conceptNameMeaning(const MString& s)
{
  mConceptNameMeaning = s;
}

void
MSRContentItemText::text(const MString& s)
{
  mText = s;
}

MString
MSRContentItemText::conceptNameValue( ) const
{
  return mConceptNameValue;
}

MString
MSRContentItemText::conceptNameDesignator( ) const
{
  return mConceptNameDesignator;
}

MString
MSRContentItemText::conceptNameMeaning( ) const
{
  return mConceptNameMeaning;
}

MString
MSRContentItemText::text( ) const
{
  return mText;
}

bool
MSRContentItemText::isLevel1Equivalent(MSRContentItem* rhs, bool verbose ) const
{
  if (!this->isTypeEqual(*rhs))
    return false;

  MSRContentItemText* rhsP = (MSRContentItemText*)rhs;

  if (verbose) {
    cout << mConceptNameValue << ":"
	 << mConceptNameDesignator << ":"
	 << mConceptNameMeaning << ":"
	 << mText << endl;
    cout << rhsP->mConceptNameValue << ":"
	 << rhsP->mConceptNameDesignator << ":"
	 << rhsP->mConceptNameMeaning << ":"
	 << rhsP->mText << endl;
  }

  if (mConceptNameValue != rhsP->mConceptNameValue)
    return false;

  if (mConceptNameDesignator != rhsP->mConceptNameDesignator)
    return false;

  if (mConceptNameMeaning != rhsP->mConceptNameMeaning)
    return false;

  if (mText != rhsP->mText)
    return false;

  if (verbose) {
    cout << " Level 1 match" << endl;
  }

  return true;
}
