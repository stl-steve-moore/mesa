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

// $Id: MHL7Msg.hpp,v 1.18 2006/06/29 16:08:32 bhasselfeld Exp $ $Author: bhasselfeld $ $Revision: 1.18 $ $Date: 2006/06/29 16:08:32 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MHL7Msg.hpp
//
//  = AUTHOR
//	Saeed Akbani
//
//  = COPYRIGHT
//	Copyright HIMSS, RSNA, Washington University: 1999, 2000
//
// ====================
//
//  = VERSION
//	$Revision: 1.18 $
//
//  = DATE RELEASED
//	$Date: 2006/06/29 16:08:32 $
//
//  = COMMENTS
//

#ifndef MHL7MsgISIN
#define MHL7MsgISIN

#include <iostream>
#include <MString.hpp>

#include "hl7_api.h"

using namespace std;

class MHL7Msg
// = TITLE
///	A class which holds an HL7 Message.
//
// = DESCRIPTION
/**	This class holds HL7 messages and is built on top of the
	HL7IMEXA toolkit.  Thus, it uses the table driven software
	in HL7IMEXA.  The class provides mechanisms for building and
	parsing HL7 messages. */
{
public:
  // = The standard methods in this framework.

  //MHL7Msg();
  // Default constructor

  MHL7Msg(const MHL7Msg& cpy);

  virtual ~MHL7Msg();

  virtual void printOn(ostream& s) const;
  /**<\brief This method is used in conjunction with the streaming operator <<
   to print the current state of MHL7Msg. */

  virtual void streamIn(istream& s);
  /**<\brief This method is used in conjunction with the streaming operator >>
   to read the current state of MHL7Msg. */

  // = Class specific methods.

  MHL7Msg(HL7MSG* toolkitMsg, const char* wire, int length);
  /// This constructor takes an existing HL7IMEXA HL7MSG in <{toolkitMsg}>.
  /** The <{wire}> and <{length}> values describe a stream of characters
   which are copied by the constructor and used to form the HL7 message
   managed by this object.
   The object assumes ownership of <{toolkitMsg}> but not <{wire}>. */

  MHL7Msg(HL7MSG* toolkitMsg);
  ///< This constructor takes an existing HL7IMEXA HL7MSG in <{toolkitMsg}>.
  /** The HL7 message will be empty.
   The object assumes ownership of <{toolkitMsg}>. */

  MString firstSegment( );
  ///< Set internal pointers to first segment and retrieve first segment.

  MString nextSegment( );
  ///< Advance to next segment and return segment name;

  MString getValue(int field, int component);
  ///< Return a copy of a value for a particular <{field}> and <{component}>.
  /**< If <{component}> is 0, return the entire field.
   If the value does not exist, return the empty string.
   This method assumes the caller has already positioned the internal
   pointers to the desired segment. */

  MString getValue(const char* segment, int field, int component);
  ///< Return a copy of a value for a particular <{field}> and <{component}> found in the segment named by <{segment}>.
  /**< If <{component}> is 0, return the entire field.
   If the value does not exist, return the empty string. */

  MString getValue(int index, const char* segment, int field, int component);
  ///< This method returns a value for a field/component in a segment that might repeat.  
  /**< In the argument list,
   <{segment}> is the name of the segment to search for the value.
   <{index}> tells which occurrence of the segment to use (1, 2, ...).
   <{field}> and <{component}> indicate the specific value inside the
   segment.  If <{component}> is 0, return the entire field.
   If the value is not found, return the empty string. */

  void insertSegment(const char* segment);

  void setValue(int field, int component, const char* value);
  ///< This method sets the value for a field in a segment.  
  /**< The method assumes the caller has already positioned the internal pointers to the
   proper segment.
   <{field}> and <{component}> identify the attribute to set.  If
   <{component}> is 0, set the entire field.
   <{value}> contains the new value to set. */

  void setValue(int field, int component, const MString& value);
  ///< This method sets the value for a field in a segment.  
  /**< The method assumes the caller has already positioned the internal pointers to the
   proper segment.
   <{field}> and <{component}> identify the attribute to set.  If
   <{component}> is 0, set the entire field.
   <{value}> contains the new value to set. */

  void setValue(const char* segment, int field, int component,
                const char* value);
  ///< This method sets the value for a field in a segment.
  /**< <{segment}> is the name of the segment where the value is set.
   <{field}> and <{component}> identify the attribute to set.  If
   <{component}> is 0, set the entire field.
   <{value}> contains the new value to set. */

  void setValue(const char* segment, int field, int component,
                const MString& value);
  ///< This method sets the value for a field in a segment.
  /** <{segment}> is the name of the segment where the value is set.
   <{field}> and <{component}> identify the attribute to set.  If
   <{component}> is 0, set the entire field.
   <{value}> contains the new value to set. */

  void setValue(int index, const char* segment, int field, int component,
                const char* value);
  ///< This method is used to set a value in a segment that can repeat.
  /** <{segment}> is the name of the segment where the value is set.
   <{index}> defines which occurrence of the segment to use (1, 2, ...).
   <{field}> and <{component}> identify the attribute to set.  If
   <{component}> is 0, set the entire field.
   <{value}> contains the new value to set. */

  int numberOfFields();
  ///< Return number of fields in the current segment.

  void streamOut(ostream& s);
  /**<\brief Send an ASCII representation of the HL7 message to the ostream <{s}>.
   This is not the same as a "streamed HL7 message". */

  void exportToWire(char* wire,  size_t size, int& exportedLength);
  ///< Export the HL7 message into stream format for storage/transmission.
  /**< The stream of characters is returned in the caller's <{wire}> argument.
   <{size}> gives the amount of space allocated for <{wire}>;
   <{exportedLength}> is filled in with the actual number of bytes exported. */

  int validateField(int field, MString& errorText);
  ///< Validate an HL7 field. Returns 0 on success, -1 on failure.

  int saveAs(const MString& path);
  ///< Write the HL7 message to the file specified by <{path}>. Return 0 on success, -1 on failure.

  HL7MSG* getNativeMsg();

private:
  HL7MSG* mToolkitMsg;
  char* mWire;
};

inline ostream& operator<< (ostream& s, const MHL7Msg& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MHL7Msg& c) {
  c.streamIn(s);
  return s;
};

#endif
