#include "MESA.hpp"
#include "MSRContentItemImage.hpp"

static char rcsid[] = "$Id: MSRContentItemImage.cpp,v 1.2 2001/08/27 15:24:10 smm Exp $";

MSRContentItemImage::MSRContentItemImage()
{
}

MSRContentItemImage::MSRContentItemImage(const MSRContentItemImage& cpy) :
  MSRContentItem(cpy) ,
  mImageRefSOPClass(cpy.mImageRefSOPClass),
  mImageRefSOPInstance(cpy.mImageRefSOPInstance)
{
}

MSRContentItemImage::~MSRContentItemImage()
{
}

void
MSRContentItemImage::printOn(ostream& s) const
{
  MSRContentItem::printOn(s);
  s << this->mImageRefSOPClass
    << " " << this->mImageRefSOPInstance;
}

void
MSRContentItemImage::streamIn(istream& s)
{
  //s >> this->member;
}

// Non boiler plate methods to follow

MSRContentItemImage::MSRContentItemImage(const MSRContentItem& cpy) :
  MSRContentItem(cpy),
  mImageRefSOPClass(""),
  mImageRefSOPInstance("")
{
}

void
MSRContentItemImage::imageRefSOPClass(const MString& s)
{
  mImageRefSOPClass = s;
}

void
MSRContentItemImage::imageRefSOPInstance(const MString& s)
{
  mImageRefSOPInstance = s;
}

MString
MSRContentItemImage::imageRefSOPClass( ) const
{
  return mImageRefSOPClass;
}

MString
MSRContentItemImage::imageRefSOPInstance( ) const
{
  return mImageRefSOPInstance;
}

bool
MSRContentItemImage::isLevel1Equivalent(MSRContentItem* rhs, bool verbose) const
{
  if (!this->isTypeEqual(*rhs))
    return false;

  MSRContentItemImage* rhsP = (MSRContentItemImage*)rhs;

  if (verbose) {
    cout << mImageRefSOPClass << ":"
	 << mImageRefSOPInstance << endl;
    cout << rhsP->mImageRefSOPClass
	 << ":" << rhsP->mImageRefSOPInstance << endl;
  }

  if (mImageRefSOPClass != rhsP->mImageRefSOPClass)
    return false;

  if (mImageRefSOPInstance != rhsP->mImageRefSOPInstance)
    return false;

  if (verbose) {
    cout << " Level 1 match" << endl;
  }
  return true;
}


bool
MSRContentItemImage::isLevel2Equivalent(MSRContentItem* rhs, bool verbose) const
{
  if (!this->isTypeEqual(*rhs))
    return false;

  MSRContentItemImage* rhsP = (MSRContentItemImage*)rhs;

  if (verbose) {
    cout << rhsP->mImageRefSOPClass
	 << ":" << rhsP->mImageRefSOPInstance << endl;
  }

  if (rhsP->mImageRefSOPClass == "")
    return false;

  if (rhsP->mImageRefSOPInstance == "")
    return false;

  if (verbose) {
    cout << " Level 2 match" << endl;
  }
  return true;
}
