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

// $Id: MFileOperations.hpp,v 1.23 2006/06/29 20:05:12 bhasselfeld Exp $ $Author: bhasselfeld $ $Revision: 1.23 $ $Date: 2006/06/29 20:05:12 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MFileOperations.hpp
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
//	$Date: 2006/06/29 20:05:12 $
//
//  = COMMENTS

#ifndef MFileOperationsISIN
#define MFileOperationsISIN

#include <iostream>
#include <string>

using namespace std;

class MFileOperations
// = TITLE
///	Provides a set of wrappers for simple file operations used routinely by this framework.
//
// = DESCRIPTION
/**	This class provides a set of directory operations that are useful
	in the MESA framework.  Some of the methods work together
	(for example, opening and reading a directory), while other methods
	are defined independently.
	This class does not provide low-level file I/O. */

{
public:
  // = The standard methods in this framework.

  MFileOperations();
  ///< Default constructor

  MFileOperations(const MFileOperations& cpy);
  ///< Copy constructor

  virtual ~MFileOperations();
  ///< Destructor

  virtual void printOn(ostream& s) const;
  /**<\brief This method is used in conjunction with the streaming operator <<
   to print the current state of MFileOperations */

  virtual void streamIn(istream& s);
  /**<\brief This method is used in conjuction with the streaming operator >>
   to read the current state of MFileOperations. */
  
  // = Class specific methods.

  int expandPath(char* result, const MString& prefix,
		 const MString& directory);

  ///<This method expands a path which consists of an environment variable as a prefix and a path as a suffix.  
  /**The method expands the environment
   variable passed in the argument <{prefix}> and appends the
   value passed in the argument <{directory}>.  The method includes
   the separator / between the two values.  The result is stored in the
   caller's <{result}> argument.
   The method assumes the caller has allocated sufficient space for the
   result.
   0 is returned on success.
   -1 is returned on failure (environment variable is undefined). */

  int createDirectory(const MString& directory);

  /**<\brief Creates a directory as specified by the path included in the
   <{directory}> argument.
   0 is returned on success.
   -1 is returned on failure */

  int createDirectory(const MString& prefix, const MString& directory);

  ///< Creates a directory which contatenation of the caller's arguments.
  /**< The <{prefix}> argument is assumed to contain an environement variable
   and is expanded.  The second argument (<{directory}>) is appended to
   the expanded environment variable.  The method attempts to create
   the directory which results.
   0 is returned on success.
   -1 is returned on failure (environment variable could not be expanded,
   or directory operation failed). */

  MString uniqueFile(const MString& prefix, const MString& directory,
		     const MString& extension);

  ///< Create a unique file name for a specified directory.
  /**< The <{prefix}> argument is assumed to contain an environement variable
   and is expanded.  The second argument (<{directory}>) is appended to
   the expanded environment variable.  The method attempts to create
   a unique file name for that directory.  The method has an algorithm for
   the file name (not published in the documentation).  The file
   extension is the caller's <{extension}> argument.
   The method returns the unique file name or "" if the method fails.
   Note: The method does not actually create the file in the directory.
   The caller should do so and needs to provide synchronization methods
   so that two callers do not allocate the same file name. */

  MString uniqueFile(const MString& directory,
		     const MString& extension = "");

  ///< Create a unique file name for a specified directory.
  /**< The caller's <{directory}> argument gives the name of the directory to use.
   The method attempts to create a unique file name for the directory.
   The method has an algorithm for the file name (not published in the
   documentation).  The file extension is the caller's <{extension}> argument.
   The method returns the unique file name or "" if the method fails.
   Note: The method does not actually create the file in the directory.
   The caller should do so and needs to provide synchronization methods
   so that two callers do not allocate the same file name. */

  int rename(const MString& source, const MString& target);

  ///< Rename one file or directory to a different name.  
  /**<	The argument <{source}> identifies the original name. The argument <{target}> identifies
   	the new name of the file or directory.
	0 is returned on success.
	-1 is returned on failure. */

  int scanDirectory(const MString& directory);
  ///< The initialization method use to scan a directory of file names.
  /**< This method scans the directory indicated by the caller and
   retains state information.  The caller may use other methods to
   extract names from the directory.
   Note: Only one scan may be active at a time.  If nested scans are
   required, the caller needs to use separate objects.
   0 is returned on success.
   -1 is returned on failure. */

  int scanDirectorySuffix(const MString& directory, const MString& suffix);
  ///< The initialization method use to scan a directory of file names.
  /**< This method scans the directory indicated by the caller and
   retains state information.  The caller may use other methods to
   extract names from the directory.
   <{suffix}> is a string used to match the suffix of the files in
   <{directory}>.  Only files having the same suffix are retained.
   Note: Only one scan may be active at a time.  If nested scans are
   required, the caller needs to use separate objects.
   0 is returned on success.
   -1 is returned on failure. */

  int filesInDirectory() const;

  ///< Returns the number of files that were found in the directory by the scanDirectory method.  
  /**<Included in the count are "." and ".." entries.
   A positive number is returned on success.
   -1 is returned on failure (original scan failed, no scan performed). */

  MString fileName(int index) const;

  ///< Find and return one file name that was scanned by the scanDirectory method.  
  /**<The caller indicates which name to be returned by using the
   <{index}> argument (numbered starting from 0).
   A legal file (or directory) name is returned on success.
   The empty string ("") is returned on failure.
   Note: This method will return the directory names "." and "..".
   This method does not sort the names which are scanned. */

  int isDirectory(const MString& candidate);

  ///< Examine a path and indicate if the path names a directory.
  /** 1 is returned if the path indicated by <{candidate}> is a directory.
   0 is returned if the path is not a directory or the file does
   not exist. */

  int unlink(const MString& dirName, const MString& fileName);

  ///< Delete or unlink the file <{dirName}> / <{fileName}>.
  ///< Return 0 on success, -1 on failure.

  int unlink(const MString& path);

  ///< Delete or unlink the file <{path}>.
  ///< Return 0 on success, -1 on failure.

  int readParamsMap(const MString& path, MStringMap& m, char substitute = ' ');
  ///< Read the file specified by <{path}>.  
  /**< The file is expected to contain entries of the form VAR = VALUE.  Parse the
   file and fill the map <{m}> with all values.
   <{substitute}> indicates a substitution character.  If provided, the
   method will change all values of <{substitute}> to " ".
   If you don't do this, you will not get character strings with spaces.
   Return 0 on success, -1 on failure. */

  int timeLastModified(const MString& path, time_t& t);
  /**<\brief For the file or directory specified by <{path}>, find the
   time the object was last modified and place that time in <{t}>. */
  ///< Return 0 on success and -1 on failure.

  char* readAllText(const MString& path);

  static int fileExists(const char* path);

  static int fileExists(const MString& path);

  static long fileLength(const char* path);

private:
  MStringVector mFileVector;

};

inline ostream& operator<< (ostream& s, const MFileOperations& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MFileOperations& c) {
  c.streamIn(s);
  return s;
}

#endif
