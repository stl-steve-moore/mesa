#include "MESA.hpp"
#include "MSRContentItemFactory.hpp"
#include "MDICOMWrapper.hpp"
#include "MSRContentItemCode.hpp"
#include "MSRContentItemContainer.hpp"
#include "MSRContentItemImage.hpp"
#include "MSRContentItemPName.hpp"
#include "MSRContentItemText.hpp"
#include "ctn_api.h"

static char rcsid[] = "$Id: MSRContentItemFactory.cpp,v 1.4 2001/07/25 18:59:46 smm Exp $";

MSRContentItemFactory::MSRContentItemFactory() 
{
}

MSRContentItemFactory::MSRContentItemFactory(const MSRContentItemFactory& cpy) 
{
}

MSRContentItemFactory::~MSRContentItemFactory()
{
}

void
MSRContentItemFactory::printOn(ostream& s) const
{
}

void
MSRContentItemFactory::streamIn(istream& s)
{
  //s >> this->member;
}

// Non boiler plate methods to follow

// Accessor

MSRContentItem*
MSRContentItemFactory::produceContentItem(MSRContentItem& item)
{
  MSRContentItem* i = 0;

  MString s = item.valueType();
  if (s == "CODE")
    i = this->produceContentItemCode(item);
  else if (s == "CONTAINER")
    i = this->produceContentItemContainer(item);
  else if (s == "IMAGE")
    i = this->produceContentItemImage(item);
  else if (s == "PNAME")
    i = this->produceContentItemPName(item);
  else if (s == "TEXT")
    i = this->produceContentItemText(item);

  return i;
}

// Private methods

MSRContentItem*
MSRContentItemFactory::produceContentItemCode(MSRContentItem& item)
{
  MSRContentItemCode *c = new MSRContentItemCode(item);

  DCM_OBJECT* obj = (DCM_OBJECT*)item.objectReference();
  MDICOMWrapper w(obj);

  MString s;
  s = w.getString(0x0040a043, 0x00080100);
  c->conceptNameValue(s);

  s = w.getString(0x0040a043, 0x00080102);
  c->conceptNameDesignator(s);

  s = w.getString(0x0040a043, 0x00080104);
  c->conceptNameMeaning(s);

  // Now add the Concept Code Sequence Values
  s = w.getString(0x0040A168, 0x00080100);
  c->codeNameValue(s);

  s = w.getString(0x0040A168, 0x00080102);
  c->codeNameDesignator(s);

  s = w.getString(0x0040A168, 0x00080104);
  c->codeNameMeaning(s);

  return c;
}

MSRContentItem*
MSRContentItemFactory::produceContentItemContainer(MSRContentItem& item)
{
  MSRContentItemContainer *c = new MSRContentItemContainer(item);

  DCM_OBJECT* obj = (DCM_OBJECT*)item.objectReference();
  MDICOMWrapper w(obj);

  MString s;
  s = w.getString(0x0040a043, 0x00080100);
  c->conceptNameValue(s);

  s = w.getString(0x0040a043, 0x00080102);
  c->conceptNameDesignator(s);

  s = w.getString(0x0040a043, 0x00080104);
  c->conceptNameMeaning(s);

  return c;
}

MSRContentItem*
MSRContentItemFactory::produceContentItemImage(MSRContentItem& item)
{
  MSRContentItemImage *c = new MSRContentItemImage(item);

  DCM_OBJECT* obj = (DCM_OBJECT*)item.objectReference();
  MDICOMWrapper w(obj);

  MString s;
  s = w.getString(0x00081199, 0x00081150);
  c->imageRefSOPClass(s);

  s = w.getString(0x00081199, 0x00081155);
  c->imageRefSOPInstance(s);

  return c;
}

MSRContentItem*
MSRContentItemFactory::produceContentItemPName(MSRContentItem& item)
{
  MSRContentItemPName *c = new MSRContentItemPName(item);

  DCM_OBJECT* obj = (DCM_OBJECT*)item.objectReference();
  MDICOMWrapper w(obj);

  MString s;
  s = w.getString(0x0040a043, 0x00080100);
  c->conceptNameValue(s);

  s = w.getString(0x0040a043, 0x00080102);
  c->conceptNameDesignator(s);

  s = w.getString(0x0040a043, 0x00080104);
  c->conceptNameMeaning(s);

  s = w.getString(0x0040a123);
  c->personName(s);

  return c;
}

MSRContentItem*
MSRContentItemFactory::produceContentItemText(MSRContentItem& item)
{
  MSRContentItemText *c = new MSRContentItemText(item);

  DCM_OBJECT* obj = (DCM_OBJECT*)item.objectReference();
  MDICOMWrapper w(obj);

  MString s;
  s = w.getString(0x0040a043, 0x00080100);
  c->conceptNameValue(s);

  s = w.getString(0x0040a043, 0x00080102);
  c->conceptNameDesignator(s);

  s = w.getString(0x0040a043, 0x00080104);
  c->conceptNameMeaning(s);

  s = w.getString(0x0040a160);
  c->text(s);

  return c;
}
