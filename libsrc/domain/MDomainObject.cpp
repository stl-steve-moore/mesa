//
//        Copyright (C) 1999, 2000, HIMSS, RSNA and Washington University
//
//        The MESA test tools software and supporting documentation were
//        developed for the Integrating the Healthcare Enterprise (IHE)
//        initiative Year 1 (1999-2000), under the sponsorship of the
//        Healthcare Information and Management Systems Society (HIMSS)
//        and the Radiological Society of North America (RSNA) by:
//                Electronic Radiology Laboratory
//                Mallinckrodt Institute of Radiology
//                Washington University School of Medicine
//                510 S. Kingshighway Blvd.
//                St. Louis, MO 63110
//        
//        THIS SOFTWARE IS MADE AVAILABLE, AS IS, AND NEITHER HIMSS, RSNA NOR
//        WASHINGTON UNIVERSITY MAKE ANY WARRANTY ABOUT THE SOFTWARE, ITS
//        PERFORMANCE, ITS MERCHANTABILITY OR FITNESS FOR ANY PARTICULAR
//        USE, FREEDOM FROM ANY DEFECTS OR COMPUTER DISEASES OR ITS CONFORMITY 
//        TO ANY SPECIFICATION. THE ENTIRE RISK AS TO QUALITY AND PERFORMANCE OF
//        THE SOFTWARE IS WITH THE USER.
//
//        Copyright of the software and supporting documentation is
//        jointly owned by HIMSS, RSNA and Washington University, and free
//        access is hereby granted as a license to use this software, copy
//        this software and prepare derivative works based upon this software.
//        However, any distribution of this software source code or supporting
//        documentation or derivative works (source code and supporting
//        documentation) must include the three paragraphs of this copyright
//        notice.

#include "MDomainObject.hpp"

#include <stdio.h>

MDomainObject::MDomainObject()
{
}
 
MDomainObject::MDomainObject(const MDomainObject& cpy)
{
}

MDomainObject::MDomainObject(const MString& tableName, const MDomainMap& map):
               mTableName(tableName), mMap(map)
{
  for( MDomainMap::iterator i = mMap.begin(); i!= mMap.end(); i++ )
    mDBAttributes.insert((*i).first);
}

MDomainObject::~MDomainObject()
{
}

void
MDomainObject::printOn(ostream& s) const
{
  s << "MDomainObject";
}

void
MDomainObject::streamIn(istream& s)
{
  //s >> this->member;
}

void
MDomainObject::tableName( const MString& s)
{
  mTableName = s;
}

void
MDomainObject::map( const MDomainMap& m)
{
  mMap = m;
}

void
MDomainObject::dbAttributes( const MDBAttributes& a)
{
  mDBAttributes = a;
}

MString
MDomainObject::tableName() const
{
  return mTableName;
}

const MDomainMap&
MDomainObject::map() const
{
  return mMap;
}

MDBAttributes&
MDomainObject::dbAttributes()
{
  return mDBAttributes;
}


// Non-boiler plate methods to follow

void
MDomainObject::insert(const MString& key)
{
  mDBAttributes.insert(key);
};

void
MDomainObject::insert(const MString& key, const MString& value)
{
  mDBAttributes.insert(key);  // if attribute is already present, this attempt will be ignored
  mMap[key] = value;
};

void
MDomainObject::insert(const MString& key, int value)
{
  mDBAttributes.insert(key);  // if attribute is already present, this attempt will be ignored

  char buf[128];
  ::sprintf(buf, "%-d", value);
  mMap[key] = buf;

  mAttributeTypes[key] = "integer"; 
};

void
MDomainObject::remove(const MString& key)
{
  mMap.erase(key);
  mDBAttributes.erase(key);
  return;
};

MString
MDomainObject::value(const MString& key) const
{
  MDomainMap::const_iterator t = mMap.find(key);
  if (t == mMap.end())
    return "";
  else
    return (*t).second;
  //return mMap[key];
}


void MDomainObject::exportAttributes(MDomainMap& m)
{
  for ( MDomainMap::iterator i = mMap.begin(); i != mMap.end(); i++ )
    m[(*i).first] = (*i).second;
}

bool MDomainObject::mapEmpty() const
{
  return mMap.empty();
}

int MDomainObject::mapSize() const
{
  return mMap.size();
}

int MDomainObject::numAttributes() const
{
  return mDBAttributes.size();
}

void
MDomainObject::bindAttributeInteger(const MString& key)
{
  mAttributeTypes[key] = "integer"; 
}

MString
MDomainObject::attributeType(const MString& key)
{
  MString s = mAttributeTypes[key];
  if (s == "") {
    s = "string";
  }

  return s;
}


#if 0
MDomainPair& MDomainObject::domainPair(const MDOMAIN_FUNCTION getWhat) const
{
  MDomainMap::iterator i;

  switch(getWhat)
  {
    case GET_FIRST:
            i = mMap.begin();
            break;
    case GET_NEXT:
            i++;
            break;
    default:
            break;
  }

  if (i == mMap.end())
    return 0;
  else
    return *i;
}
#endif
