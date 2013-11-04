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

#include "MString.hpp"
#ifdef GCC4
#include "stdlib.h"
#endif



MString::MString()
{
}

MString::MString(const MString& cpy) :
  string(cpy)
{
}

MString::~MString()
{
}

void
MString::printOn(ostream& s) const
{
  s << "MString";
}

void
MString::streamIn(istream& s)
{
  //s >> this->member;
}

// Non-boilerplate methods to follow

MString::MString(const char* txt) :
  string(txt)
{
}

MString::MString(const string& txt) :
  string(txt)
{
}

void
MString::safeExport(char* target, size_t targetLength) const
{
  int l = this->length();

  if (l > targetLength - 1)
    l = targetLength - 1;

  ::strncpy(target, this->data(), l);
  target[l] = '\0';
}

bool
MString::tokenExists(char delim, int num)
{
  char* stringBuffer;
  stringBuffer = this->strData();

  int delimCounter = 1;
  int i = 0;
  if (num < 0)
    cerr << "MString::tokenExists Invalid token number\n";

  bool rtnValue = true;
  while((delimCounter <= num) && rtnValue) {
    if(stringBuffer[i] == delim)
      delimCounter++;
    if(stringBuffer[i] == '\0')
      rtnValue = false;
    i++;
  }
  delete []stringBuffer;
  return rtnValue;
}

MString 
MString::getToken(char delim, int num)
{
  char* tokenBuffer = new char[this->size()+1];

  char* stringBuffer;
  stringBuffer = this->strData();

  int delimCounter = 1;
  int i = 0;
  if (num < 0)
    cerr << "MString::getToken Invalid token number\n";

  while(delimCounter <= num){
    if(stringBuffer[i] == delim)
      delimCounter++;
    if(stringBuffer[i] == '\0')
      cerr << "MString::getToken at end of string\n";
    i++;
  }
  int j = 0;
  while((stringBuffer[i] != delim) && (stringBuffer[i] != '\0')){
    tokenBuffer[j++] = stringBuffer[i++];
  }
  tokenBuffer[j] = '\0';

  MString rtnValue(tokenBuffer);
  delete []stringBuffer;
  delete []tokenBuffer;
  return rtnValue;
}

#ifdef _WIN32
const char *index(const char* s, int c)
{
  while (*s != '\0') {
    if (*s == (char)c) {
      return s;
    }
    s++;
  }
  return NULL;
}
#endif

void
MString::getTokens( MStringVector& vec, const char *delim, char *line,
                            bool skipEmptyTokens)
{
  size_t lineLength = ::strlen(line) + 1;  // include the ending null.
  char* token = new char[lineLength];
  // examine every char, including ending null.
  for( int i = 0; i < lineLength; i++) {
      char c = line[i];
      if( ::index( delim, (int)c) == NULL && c != '\0') {
          // if c is not a delimiter and not the null char

          // add the char to the token.
          token[i] = line[i];

      }
      else {
          // c is a delimiter or the null char

          if( i == 0 && skipEmptyTokens) {
              // the token is empty and we're skipping empty tokens
              if( c != '\0')
                  // there are more tokens if not at the end of the line.
                  getTokens( vec, delim, line+i+1, skipEmptyTokens);
              break;
          }
          token[i] = '\0';
          MString mstring = MString(token);
          vec.push_back(mstring);
          if( c != '\0')
              getTokens( vec, delim, line+i+1, skipEmptyTokens);
          break;
      }
    }
    delete[] token;
}

bool
MString::containsCharacter(char c)
{
  int l = this->length();

  if (l <= 0) {
    return false;
  }

  const char* p = this->data();
  int i = 0;
  for (i = 0; i < l; i++) {
    if (p[i] == c) {
      return true;
    }
  }
  return false;
}


char* MString::strData() const
{
  char* str = new char[length()+1];
  
  ::strncpy( str, data(), length() );
  str[length()] = 0;
  
  return str;
}

int MString::intData() const
{
  char* str;
  str = this->strData();
  
  int rtnValue = atoi(str);
  delete [] str;

  return rtnValue;
}

float
MString::floatData() const
{
  char* str;
  str = this->strData();
  
  float rtnValue = atof(str);
  delete [] str;

  return rtnValue;
}

int
MString::substitute(char original, char replacement)
{
  int i;


  for (i = 0; i < length(); i++) {
    if ((*this)[i] == original)
      (*this)[i] = replacement;
  }

  return 0;
}

MString
MString::subString(int index, int max) const
{
  char* s = this->strData();
  if ((max != 0) && (index + max < strlen(s))) {
    s[index + max] = '\0';
  }

  MString rtn(&s[index]);

  delete []s;

  return rtn;
}

int
MString::stringCompare(int start, int length, const MString& s) const
{
#if defined (STRING_COMPARE_GCC_NON_STANDARD)
  return this->compare(s, start, length);
#else
  return this->compare(start, length, s);
#endif
}

int 
MString::compareCaseIns(const MString& s) const
{
  char *s1 = this->strData();
  char *s2 = s.strData();
  while (*s1 != '\0' && tolower(*s1) == tolower(*s2))
    {
      s1++;
      s2++;
    }

  return tolower(*(unsigned char *) s1) - tolower(*(unsigned char *) s2);

}

int 
MString::compareCaseIns(const char * s2) const
{
  char *s1 = this->strData();
  while (*s1 != '\0' && tolower(*s1) == tolower(*s2))
    {
      s1++;
      s2++;
    }

  return tolower(*(unsigned char *) s1) - tolower(*(unsigned char *) s2);

}
