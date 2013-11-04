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

// $Id: MDICOMWrapper.hpp,v 1.35 2006/08/16 03:55:53 smm Exp $ $Author: smm $ $Revision: 1.35 $ $Date: 2006/08/16 03:55:53 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MDICOMWrapper.hpp
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
//	$Revision: 1.35 $
//
//  = DATE RELEASED
//	$Date: 2006/08/16 03:55:53 $
//
//  = COMMENTS
//	Should eventually be replaced by a full C++ implementation.

#ifndef MDICOMWrapperISIN
#define MDICOMWrapperISIN

#include <iostream>
#include <string>
#include "ctn_api.h"
#include "MLogClient.hpp"

using namespace std;

class MDICOMWrapper
// = TITLE
///	Wrapper around CTN DCM object to provide access to attributes in the DICOM object.
//
// = DESCRIPTION
/**	Use the MDICOMWrapper to open a DICOM file or to take ownership
	of an existing CTN DCM object.  Once the object is opened or owned,
	this wrapper can be used to get and set attributes.  A fuller
	implementation would have many more features. */
{
public:
  // = The standard methods in this framework.

  /// Default constructor.
  MDICOMWrapper();

  MDICOMWrapper(const MDICOMWrapper& cpy);
  ///< Copy constructor

  virtual ~MDICOMWrapper();
  ///< Destructor.

  virtual void printOn(ostream& s) const;
  /**<\brief This method is used in conjunction with the streaming operator <<
   to print the current state of MDICOMWrapper. */

  virtual void streamIn(istream& s);
  /**<\brief This method is used in conjunction with the streaming operator >>
   to read the current state of MDICOMWrapper. */

  // = Class specific methods.

  MDICOMWrapper(const MString& fileName,
		unsigned long options = DCM_ORDERLITTLEENDIAN);
  ///< Open a DICOM file and maintain a handle to all of the attributes.
  /**< In the argument list, <{fileName}> specifies a full or relative path to
   a DICOM file (CTN format or DICOM Part 10).  The <{options}> argument
   specifies options to be used when opening the file.  Refer to CTN
   documentation. */

  int open(const MString& fileName,
		unsigned long options = DCM_ORDERLITTLEENDIAN);
  ///< Open a DICOM file and maintain a handle to all of the attributes.
  /**< In the argument list, <{fileName}> specifies a full or relative path to
   a DICOM file (CTN format or DICOM Part 10).  The <{options}> argument
   specifies options to be used when opening the file.  Refer to CTN
   documentation.  Returns 0 on success and -1 otherwise. */

  int openTrySupportedFormats(const MString& fileName);
  ///< Open a DICOM file and maintain a handle to all of the attributes.
  /**< In the argument list, <{fileName}> specifies a full or relative path to
   a DICOM file (stored in a supported format). */

  MDICOMWrapper(DCM_OBJECT* obj);
  ///< Grab the caller's reference to a CTN object.  Use that reference to change values.  
  ///<Caller still owns the CTN object and should close it after the destructor to this object is invoked.

  void close();
  // Close the object and release all resources. The destructor will take care
  // of this as well, but sometimes you want to free the resources.

  int saveAs(const MString& fileName,
	     unsigned long options = DCM_ORDERLITTLEENDIAN);
  ///< Save the current object in a DICOM file.  
  /**<Default format is CTN format,
   but Part 10 files can be saved with the proper options.
   In the argument list, <{fileName}> gives an absolute or relative path
   for the output.  The <{options}> argument indicates how the file
   should be saved.  Refer to CTN documentation for use of this parameter. */

  MString getString(DCM_TAG tag);
  ///< Return the string value found in the attribute identified by <{tag}>.
  /**< Returns the empty string ("") if the attribute is not found or is of
   0-length. */

  MString getString(DCM_TAG seqTag, DCM_TAG seqItem, int itemNumber = 1);
  ///< Return the string value found in a sequence attribute.  
  /**<Returns the empty string ("") if the attribute is not found or is of 0-length.
   In the argument list, <{seqTag}> is the tag of the sequence.
   <{seqItem}> is the tag of the attribute inside the sequence to locate.
   <{itemNumber}> identifies which occurrence of the attribute to locate;
   indexing begins at 1. */

  MString getSequenceString(DCM_TAG seqTag1, DCM_TAG seqTag2, DCM_TAG seqItem, int itemNumber = 1);
  ///< Return the string value found in a sequence attribute.  
  /**<Returns the empty string ("") if the attribute is not found or is of 0-length.
   In the argument list, <{seqTag1}> is the tag of the outer sequence.
   <{seqTag2}> is the tag of the next, inner sequence.
   <{seqItem}> is the tag of the attribute inside the sequence to locate.
   <{itemNumber}> identifies which occurrence of the attribute to locate;
   indexing begins at 1. */

  MString getSequenceString(DCM_TAG seqTag1, DCM_TAG seqTag2, DCM_TAG seqTag3, DCM_TAG seqItem, int itemNumber = 1);

  MStringVector getStrings(DCM_TAG seqTag, DCM_TAG seqItem);
  ///< Return the vector of string values found in a sequence attribute.
  /**< Returns an empty vector if the attribute is not found. The vector 
   contains empty strings ("") if the attribute is 0-length.
   In the argument list, <{seqTag}> is the tag of the sequence.
   <{seqItem}> is the tag of the attribute inside the sequence to locate. */

  U16 getU16(DCM_TAG tag);
  U32 getU32(DCM_TAG tag);

  int getVector(int& vectorLength, U16*& v, DCM_TAG tag);

  int numberOfItems(DCM_TAG seqTag);
  ///< Return the number of items contained in the specified sequence.
  ///< In the argument list, <{seqTag}> is the tag of the sequence.

  int attributePresent(DCM_TAG tag);
  ///< Returns an integer value indicating if the attribute identified by <{tag}> exists in the DICOM object.
  /**< 1 is returned if the attribute exists (may be 0-length).
   0 is returned if the attribute does not exist. */

  int attributePresent(DCM_TAG tagSequence, DCM_TAG tag);
  // Returns an integer value indicating if the attribute identified by
  // <{tagSequence}, {tag}> exists in the DICOM object.
  // 1 is returned if the attribute exists (may be 0-length).
  // 0 is returned if the attribute does not exist.

  int attributePresent(DCM_TAG tagSequence1, DCM_TAG tagSequence0, DCM_TAG tag);
  // Returns an integer value indicating if the attribute identified by
  // <{tagSequence1}, {tagSequence0}, {tag}> exists in the DICOM object.
  // 1 is returned if the attribute exists (may be 0-length).
  // 0 is returned if the attribute does not exist.

  int groupPresent(U16 group);
  ///< Returns an integer value indicating if the group identified by <{group}> exists in the DICOM object.
  /**< 1 is returned if the group exists (may be 0-length).
   0 is returned if the group does not exist. */

  int setString(DCM_TAG tag, const MString& value);
  ///< Set the value of the attribute identified by <{tag}> using the value passed in <{value}>.  
  /**< If the attribute is of string type, the method
   copies the string as is (without regard to DICOM VR).  If the attribute
   is of numeric type, the method converts the <{value}> to the proper
   numeric type before setting the attribute. */

  int setString(DCM_TAG tag, const MString& value, const MString& vr);
  ///< Set the value of the attribute identified by <{tag}> using the value passed in <{value}>.  
  /**< The <{vr}> parameter specifies the value representation
   of the element. This is intended for private elements. */

  int setString(DCM_TAG seqTag, DCM_TAG tag, const MString& value,
		int index = 1);
  ///< Set a string inside of a sequence.
  /**< In the argument list, <{seqTag}> identifies the sequence and <{tag}>
   identifies the specific attribute.  <{index}> indicates which occurrence
   of the attribute to set; numbering starts at 1.
   If the attribute is of string type, the method copies the string as is
   (without regard to DICOM VR).  If the attribute is of numeric type, the
   method converts the <{value}> to the proper numeric type before setting
   the attribute.
   0 is returned on success.
   -1 is returned on failure. */

  int setString(DCM_TAG seqTag1, DCM_TAG seqTag2, DCM_TAG tag, const MString& value,
		int index = 1);

  int setSequenceString(DCM_TAG seqTag1, DCM_TAG seqTag2, DCM_TAG seqTag3, DCM_TAG tag, const MString& value,
		int index = 1);

  int setNumeric(DCM_TAG tag, int value);
  ///< Set a numeric value for the attribute identified by <{tag}>.  
  /**< This method determines the proper DICOM VR for the attribute 
       and converts <{value}> before setting the attribute.
       0 is returned on success.
      -1 is returned on failure. */

  int createSequence(DCM_TAG tag);
  ///< Create an empty sequence for the attribute identified by <{tag}>.
  /**< 0 is returned on success.
      -1 is returned on failure. */

  DCM_OBJECT* getNativeObject();
  ///< Return a reference to the CTN native object.  
  /**< This object maintains its reference to the same native object, so the 
       user needs to be aware of synchronization problems.  This method is 
       normally invoked to carry out a CTN function not supported by this wrapper class. */

  MDICOMWrapper* getSequenceWrapper(DCM_TAG tag, int index);
  ///< Return a new MDICOMWrapper that is extracted from within a sequence.
  /**< <{tag}> identifies the sequence and <{index}> identifies the
       item within the sequence to be returned.
       <{index}> starts at 1.
       This method returns a wrapper to a copy of the sequence item.
       This method returns 0 if the item does not exist within the sequence. */

  MDICOMWrapper* getSequenceWrapperOriginal(DCM_TAG tag, int index);
  ///< Return a MDICOMWrapper that is extracted from within a sequence.
  /**< <{tag}> identifies the sequence and <{index}> identifies the
       item within the sequence to be returned.
       <{index}> starts at 1.
       This method returns a wrapper to the original sequence, not a copy.
       This method returns 0 if the item does not exist within the sequence. */

  void log(MLogClient client, MLogClient::LOGLEVEL level);
  /**<\brief Scan through all of the attributes in the underlying object and log
    a message with the caller's <{client}> for each attribute with the
    DICOM tag and value.  
  /**< For now, we only log the text values.  We should
   probably log all values (or add more options).
   The <{level}> argument is passed to MLogClient::log. */

  int importAttributes(MDICOMWrapper& w, const DCM_TAG* t);
  ///< Import a set of attributes from an existing wrapper object (<{w}>.
  /**< The caller passes an array of DICOM tags <{t}> which is terminated
   with a tag value of 0.  For each attribute, this method copies the
   value from <{w}> and sets the value in this object.
   This method is not designed to handle sequences and will fail.
   0 is returned on success.
   -1 is returned on failure. */

  int removeGroup(U16 group);
  ///< Remove the group whose number is passed in the argument <{group}>.
  /**< All attributes with this group number are removed.
   0 is returned on success.
   -1 is returned on failure. */

  int removePrivateGroups();
  ///< Remove all private groups.
  /**< 0 is returned on success.
      -1 is returned on failure. */

  int removeElement(DCM_TAG tag);
  ///< Remove one element whose tag is passed in the argument <{tag}>.
  /**< If the element is a sequence, this implies that all sequence items are also removed.
       0 is returned on success.
      -1 is returned on failure. */

  CONDITION getElement(DCM_TAG tag, DCM_ELEMENT* e, void *buffer, int bufSize);
  ///< Get the value of a given element.  
  /**< If the element exists, returns DCM_NORMAL and the element values are filled in e.
       If the element does not exist, DCM_ELEMENTNOTFOUND is
       returned.  (Other error conditions may also occur)
       The DCM_ELEMENT and buffer must be allocated, and the size
       of the buffer is passed in bufSize. */

CONDITION getElements(
        CONDITION(*callback) (const DCM_ELEMENT* e, void* ctx), void* ctx); 
  ///< Returns the value of all elements in an object, but does not recurse into sequences.  
  /**< The callback function is called
       for every element.  getElements() returns after all of the
       callbacks have been completed. */

  static bool isSequence(DCM_TAG tag);
  // Returns a flag indicating if the attribute represented by 
  // <{tag}> is of VR sequence.

  unsigned long getFileOptions() const;
  // Returns the options flag that was used to open the file.

protected:
  DCM_OBJECT* mObj;
  bool mAmOwner;

private:
  unsigned long mFileOptions;
};

inline ostream& operator<< (ostream& s, const MDICOMWrapper& c) {
	  c.printOn(s);
	  return s;
};

inline istream& operator >> (istream& s, MDICOMWrapper& c) {
  c.streamIn(s);
  return s;
}

#endif
