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

// $Id: MString.hpp,v 1.23 2006/08/02 21:51:15 drm Exp $ $Author: drm $ $Revision: 1.23 $ $Date: 2006/08/02 21:51:15 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MString.hpp
//
//  = AUTHOR
//	Steve Moore
//
//  = COPYRIGHT
//	Copyright HIMSS, RSNA, Washington University: 1999, 2000
//
// ====================
//
//  = VERSION
//	$Revision: 1.23 $
//
//  = DATE RELEASED
//	$Date: 2006/08/02 21:51:15 $
//
//  = COMMENTS

#ifndef MStringISIN
#define MStringISIN

//using namespace std;

#include <iostream>
#ifdef GCC4
#include <cstring>
#else
#include <string>
#endif
#include <vector>
#include <map>
#include <ctype.h>

using namespace std;

class MString;
typedef vector < MString > MStringVector;
typedef map < MString, MString, less < MString > > MStringMap;

class MString : public string
// = TITLE
///	A simple string class.
//
// = DESCRIPTION
/**	This class extends the string class found in STL.
	It provides some extra methods that we found useful in MESA. */
{
public:
  // = The standard methods in this framework.

  MString();
  ///< Default constructor

  MString(const MString& cpy);
  ///< Copy constructor.

  virtual ~MString();
  ///< Default destructor.

  virtual void printOn(ostream& s) const;
  /**<\brief This method is used in conjunction with the streaming operator <<
   to print the current state of MString. */

  virtual void streamIn(istream& s);
  /**<\brief This method is used in conjunction with the streaming operator >>
   to read the current state of MString. */
  
  // = Class specific methods.

  MString(const string& txt);
  ///< Construct an MString from another string;

  MString(const char* txt);
  ///< Construct an MString from a text buffer;
  
  MString getToken(char delim, int num);

  ///< This method returns a token which is defined to exist between the <{delimiter}> character defined by the caller.  
  /**< The caller defines the delimiter and the number of the token to return.  
     The value for <{num}> starts at 0.
     An <{MString}> is returned with the requested token.
     Behavior is not defined if the method fails to find the token. */

  static void getTokens( MStringVector& vec, const char *delim, char *string,
                         bool skipEmptyTokens);
  ///< Find all tokens in the string between any of the supplied delimiters. Flag specifies if empty tokens are to be included.

  bool tokenExists(char delim, int num);

  ///< This method uses the same algorithm as <{getToken}> to define the placement of a token in the string.  
  /**< If a token is found at the position indicated
       by <{num}>, this method returns true.  Otherwise, the method returns false. */

  bool containsCharacter(char c) ;
  ///< This method returns true if the string contains the character indicated by the parameter c.

  char* strData() const;
  ///< Returns a pointer to a null terminated string
  /**< Returns a pointer to a null terminated string (newly allocated) which the
   user must destroy.  This is one method for exporting the string to a
   different format. */

  void safeExport(char* target, size_t targetSize) const;

  ///< Export characters to a <{target}> array of <{targetSize}>.  
  ///< Exported string will be null-terminated, but may be truncated.

  int intData() const;

  // Performs an <{atoi}> conversion on the data in the string and returns the
  // result.  Does not evaluate or test the contents of the string before the
  // call to <{atoi}>, so the return value may be unexpected.

  float floatData() const;

  ///< Performs an <{atof}> conversion on the data in the string and returns the result.  
  /**Does not evaluate or test the contents of the string before the 
   call to <{atof}>, so the return value may be unexpected. */

  int substitute(char original, char replacement);

  /**<\brief Finds all occurrences of the character <{original}> in the string and
   replaces with <{replacement}>. */
  /**< 0 is returned on success (which should be always).
   -1 is returned on failure. */

  MString subString(int index, int max = 0) const;

  ///< Extract the substring starting at position <{index}> (first char = 0)
  /**< Return a string up to <{max}> characters in length;
   If <{max}> is 0, return entire substring from <{index}> to the
   end of the original string. */

  int stringCompare(int start, int length, const MString& s) const;
  /**<\brief Compare a substring of the current string with the
   same substring (position-wise) of the input string <{s}>. */
  /**< <{start}> is the index of the first character in
   the compare; <{length}> is the number of characters to compare. */

  int compareCaseIns(const MString& s) const;
  ///< Compare this with MString s ignoring case. Uses code based on Linux's strcasecmp.
  ///< Return 0 if the strings are equal (ignoring case).

  int compareCaseIns(const char * s2) const;
  ///< Overloaded case insensitive string comparison to take a char * instead of another MString.

private:
};

#if 0
inline ostream& operator<< (ostream& s, const MString& c) {
	  c.printOn(s);
	  return s;
};
#endif

inline istream& operator >> (istream& s, MString& c) {
  c.streamIn(s);
  return s;
}

#endif
