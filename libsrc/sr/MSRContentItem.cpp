#include "MESA.hpp"
#include "MSRContentItem.hpp"

static char rcsid[] = "$Id: MSRContentItem.cpp,v 1.5 2001/07/20 18:17:19 smm Exp $";

MSRContentItem::MSRContentItem() :
  mNestLevel(1),
  mObjectReference(0)
{
}

MSRContentItem::MSRContentItem(const MSRContentItem& cpy) :
  mValueType(cpy.mValueType),
  mRelationshipType(cpy.mRelationshipType),
  mNestLevel(cpy.mNestLevel),
  mObjectReference(cpy.mObjectReference),
  mContentItemVector(cpy.mContentItemVector)

{
}

MSRContentItem::~MSRContentItem()
{
}

void
MSRContentItem::printOn(ostream& s) const
{
  char whiteSpace[128];
  int i = 0;
  for (i = 0; i < mNestLevel; i++)
    whiteSpace[i] = ' ';
  whiteSpace[i] = '\0';

  s << whiteSpace << "MSRContentItem: "
    << mRelationshipType << " "
    << mValueType << endl;
  if (mContentItemVector.size() != 0) {
    MSRContentItemVector::const_iterator v = mContentItemVector.begin();
    while (v != mContentItemVector.end()) {
      s << *v;
      v++;
    }
  }
}

void
MSRContentItem::streamIn(istream& s)
{
  //s >> this->member;
}

// Non boiler plate methods to follow

// Accessor

MString
MSRContentItem::relationshipType( ) const
{
  return mRelationshipType;
}

MString
MSRContentItem::valueType( ) const
{
  return mValueType;
}

int
MSRContentItem::nestLevel( ) const
{
  return mNestLevel;
}

void*
MSRContentItem::objectReference( )
{
  return mObjectReference;
}
bool
MSRContentItem::isLeaf( ) const
{
  if (mContentItemVector.size() == 0)
    return true;
  else
    return false;
}

MSRContentItemVector&
MSRContentItem::contentItemVector( )
{
  return mContentItemVector;
}

// Set methods

void
MSRContentItem::relationshipType(const MString& s)
{
  mRelationshipType = s;
}

void
MSRContentItem::valueType(const MString& s)
{
  mValueType = s;
}

void
MSRContentItem::nestLevel(int l)
{
  mNestLevel = l;
}

void
MSRContentItem::objectReference(void* p)
{
  mObjectReference = p;
}

bool
MSRContentItem::isTypeEqual(const MSRContentItem& rhs) const
{
  if (mRelationshipType != rhs.mRelationshipType)
    return false;

  if (mValueType != rhs.mValueType)
    return false;

  return true;
}

bool
MSRContentItem::isLevel1Equivalent(MSRContentItem* rhs, bool verbose) const
{
  return false;
}

bool
MSRContentItem::isLevel2Equivalent(MSRContentItem* rhs, bool verbose) const
{
  return false;
}
