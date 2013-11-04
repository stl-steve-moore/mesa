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

#include "MESA.hpp"
#include "MHL7Msg.hpp"

#include <stdlib.h>
#include <fstream>

#if 0
MHL7Msg::MHL7Msg()
{
}
#endif

MHL7Msg::MHL7Msg(const MHL7Msg& cpy)
{
}

MHL7Msg::~MHL7Msg()
{
  if (mToolkitMsg != 0)
    ::HL7Free(mToolkitMsg);

  if (mWire)
    delete [] mWire;
}

void
MHL7Msg::printOn(ostream& s) const
{
  s << "MHL7Msg of length " << strlen(mWire) << endl;
}

void
MHL7Msg::streamIn(istream& s)
{
  char buf[1024];
  while (s.getline(buf, sizeof(buf))) {
    if (buf[0] == '#' || buf[0] == '\0')
      continue;

    int index;
    if ((index = atoi(buf)) == 0) {
      ::HL7InsSegm(mToolkitMsg, buf);
    } else {
      char* c = strtok(buf, " \t");
      c = strtok(NULL, "\n");
      if (c == 0)
	c = "";

      ::HL7PutFld(mToolkitMsg, c, index);
    }
  }

  char wire[10000];
  size_t len = 0;
  ::HL7WriteMsg(mToolkitMsg, wire, 10000, &len);
  mWire = new char[len + 1];
  memcpy(mWire, wire, len);
  mWire[len] = '\0';
}

// Non-boiler plate methods to follow below

MHL7Msg::MHL7Msg(HL7MSG* toolkitMsg, const char* wire, int length) :
  mToolkitMsg(toolkitMsg)
{
  mWire = new char[strlen(wire) + 1];
  //MASSERT(mWire != 0);
  ::strcpy(mWire, wire);

  int result = ::HL7ReadMesg(mToolkitMsg, mWire, length);
  //MASSERT(result = HL7OK);
}

MHL7Msg::MHL7Msg(HL7MSG* toolkitMsg) :
  mToolkitMsg(toolkitMsg),
  mWire(0)
{
}

MString
MHL7Msg::firstSegment( )
{
  char* segment = 0;

  int rslt = ::HL7FirstSegm(mToolkitMsg, &segment);
  if (segment == 0)
    segment = "<No Segment>";

  return MString(segment);
}

MString
MHL7Msg::nextSegment( )
{
  char* segment;

  int rslt = ::HL7NextSegm(mToolkitMsg, &segment);
  if (rslt == HL7_END_OF_STRUCT || rslt == HL7_EMPTY_STRUCT)
    return "";

  return MString(segment);
}

MString
MHL7Msg::getValue(int field, int component)
{
  char *s;

  if (component == 0)
    s = ::HL7GetFld(mToolkitMsg, field);
  else
    s = ::HL7GetComp(mToolkitMsg, field, 1, component);
  //MASSERT( s != 0);

  if (s == 0)
    return MString("");
  else
    return MString(s);
}

MString
MHL7Msg::getValue(const char* segment, int field, int component)
{
  int rslt;
  char *s;

  rslt = ::HL7FirstSegm(mToolkitMsg, &s);
  //MASSERT (rslt == HL7_OK);
  rslt = ::HL7FindSegm(mToolkitMsg, segment);
  //MASSERT (rslt == HL7_OK);

  if (component == 0)
    s = ::HL7GetFld(mToolkitMsg, field);
  else
    s = ::HL7GetComp(mToolkitMsg, field, 1, component);
  //MASSERT( s != 0);

  if (s == 0)
    return MString("");
  else
    return MString(s);
}

MString
MHL7Msg::getValue(int index, const char* segment, int field, int component)
{
  int rslt;
  char *s;
  MString x = segment;

  rslt = ::HL7FirstSegm(mToolkitMsg, &s);
  //MASSERT (rslt == HL7_OK);
  if (x == "MSH") {
    ;	// We found the segment we want; MSH is first by definition
  } else {
    while (index-- > 0) {
      rslt = ::HL7FindSegm(mToolkitMsg, segment);
//      if (rslt != HL7_OK && rslt != HL7_END_OF_STRUCT) {
      if (rslt != HL7_OK) {
	return MString("");
      }
      //MASSERT (rslt == HL7_OK);
    }
  }

  if (component == 0)
    s = ::HL7GetFld(mToolkitMsg, field);
  else
    s = ::HL7GetComp(mToolkitMsg, field, 1, component);
  //MASSERT( s != 0);

  if (s == 0)
    return MString("");
  else
    return MString(s);
}

void
MHL7Msg::insertSegment(const char* segment)
{
  ::HL7InsSegm(mToolkitMsg, segment);
}

void
MHL7Msg::setValue(int field, int component, const char* value)
{
  int rslt;
  char *s;

  if (!value)
    return;

  s = new char[strlen(value)+1];
  strcpy(s, value);

  if (component == 0)
    rslt = ::HL7PutFld(mToolkitMsg, s, field);
  else
    rslt = ::HL7PutCompN(mToolkitMsg, s, field, component);
  //MASSERT( rslt == 0);

  delete [] s;
}

void
MHL7Msg::setValue(int field, int component, const MString& value)
{
  char *s = value.strData();
  this->setValue(field, component, s);

  delete [] s;
};

void
MHL7Msg::setValue(const char* segment, int field, int component,
                  const char* value)
{
  int rslt;
  char *s;

  if (!value)
    return;

  rslt = ::HL7FirstSegm(mToolkitMsg, &s);
  if (rslt != HL7_OK)
    return;

  if (strcmp(s, segment) != 0) {
    rslt = ::HL7FindSegm(mToolkitMsg, segment);
    if (rslt != HL7_OK)
      return;
  }

  s = new char[strlen(value)+1];
  strcpy(s, value);

  if (component == 0)
    rslt = ::HL7PutFld(mToolkitMsg, s, field);
  else
    rslt = ::HL7PutCompN(mToolkitMsg, s, field, component);
  //MASSERT( rslt == 0);

  delete [] s;
}

void
MHL7Msg::setValue(const char* segment, int field, int component,
		  const MString& value)
{
  char *s = value.strData();
  this->setValue(segment, field, component, s);
  delete [] s;
};

void
MHL7Msg::setValue(int index, const char* segment, int field, int component,
                  const char* value)
{
  int rslt;
  char *s;

  if (!value)
    return;

  rslt = ::HL7FirstSegm(mToolkitMsg, &s);
  //MASSERT (rslt == HL7_OK);
  while (index-- > 0) {
    rslt = ::HL7FindSegm(mToolkitMsg, segment);
    if (rslt != HL7_OK)
      break;
  }

  // insert a new segment if one pointed to by index does not exist
  if (!index)
  {
    s = new char[strlen(segment)+1];
    strcpy(s, segment);
    ::HL7InsSegm(mToolkitMsg, s);
    delete [] s;
  }

  s = new char[strlen(value)+1];
  strcpy(s, value);

  if (component == 0)
    rslt = ::HL7PutFld(mToolkitMsg, s, field);
  else
    rslt = ::HL7PutCompN(mToolkitMsg, s, field, component);
  //MASSERT( s != 0);

  delete [] s;
}

int
MHL7Msg::numberOfFields()
{
  return ::HL7GetNmbrOfFlds(mToolkitMsg);
}

void
MHL7Msg::streamOut(ostream& s)
{
  MString segment;
  for (segment = this->firstSegment();
       segment != "";
       segment = this->nextSegment()) {
    s << segment << endl;

    int count = this->numberOfFields();
    int i;
    for (i = 1; i <= count; i++) {
      char* c = ::HL7GetFld(mToolkitMsg, i);
      if (c == 0)
	c = "";
      s << " " << i <<  " " << c << endl;
    }
  }
}

void
MHL7Msg::exportToWire(char *wire, size_t size, int& exportedLength)
{
  int status;
  size_t len;
  // In future, need to dynamically allocate wire size based on MHL7Msg size.

  status = ::HL7WriteMsg(mToolkitMsg, wire, size, &len);
  //MASSERT (status == HL7_OK);
  exportedLength = (int) len;
}

int
MHL7Msg::validateField(int field, MString& errorText)
{
  errorText = "";

  int rslt = ::HL7ValidateFld(mToolkitMsg, field);

  if (rslt == HL7_OK) {
    return 0;
  } else {
    errorText = ::HL7ErrTxt(mToolkitMsg, rslt);
    return -1;
  }
}

int
MHL7Msg::saveAs(const MString& path)
{
  if (mToolkitMsg == 0)
    return -1;

  char wire[10240];
  char *ptr;
  size_t exportedLength = 0;
  ptr = wire;

  int status = ::HL7WriteMsg(mToolkitMsg, wire, sizeof(wire), &exportedLength);
  //MASSERT (status == HL7_OK);
  if (status != HL7_OK) {
    ptr = new char[102400];
    if (ptr == 0)
      return -1;
    status = ::HL7WriteMsg(mToolkitMsg, ptr, 102400, &exportedLength);
    if (status != HL7_OK) {
      cout << "MHL7Msg::saveAs HL7 toolkit error: " << mToolkitMsg->ErrorMessage << endl;
      cout << " Unable to save HL7 Message in file: " << path << endl;

      delete []ptr;
      return -1;
    }
  }

  char p[1024];
  path.safeExport(p, sizeof(p));

  ofstream f(p, ios::out | ios::trunc | ios::binary);
  if (!f)
    return -1;

  f.write(ptr, exportedLength);

  return 0;
}

HL7MSG*
MHL7Msg::getNativeMsg()
{
  return mToolkitMsg;
}
