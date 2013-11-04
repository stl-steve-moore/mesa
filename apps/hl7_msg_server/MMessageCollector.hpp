
// $Id: MMessageCollector.hpp,v 1.1 2006/06/30 13:48:50 bhasselfeld Exp $ $Author: bhasselfeld $ $Revision: 1.1 $ $Date: 2006/06/30 13:48:50 $ $State: Exp $
// ====================
//  = LIBRARY
//	hl7
//
//  = FILENAME
//	MMessageCollector.hpp
//
//  = AUTHOR
//	Brian Hasselfeld
//
//  = COPYRIGHT
//	
//
// ====================
//
//  = VERSION
//	$v $
//
//  = DATE RELEASED
//	$Date: 2006/06/30 13:48:50 $
//
//  = COMMENTTEXT

#ifndef MMessageCollector_ISIN
#define MMessageCollector_ISIN

#include <iostream>

#include "MHL7Dispatcher.hpp"
#include "MDBHL7Notification.hpp" 

class MPatient;
class MVisit;
class MPlacerOrder;
class MFillerOrder;

using namespace std;


// = TITLE
///	A dispatcher to handle received HL7 messages.
//
// = DESCRIPTION
/**	This class is a dispatcher which accepts HL7 messages and saves them to a unique file path
	It then processes the message, storing the filepath into a table: hl7_file_index
	It inherits from MHL7Dispatcher  **/



class MMessageCollector : public MHL7Dispatcher
{
public:
  //MMessageCollector();
  /// Default constructor
  MMessageCollector(const MMessageCollector& cpy);
  ~MMessageCollector();

  ///prints current state of class
  /** This method is used in conjunction with the streaming operator <<
  to print the current state of MMessageCollector **/ 
  virtual void printOn(ostream& s) const;


  virtual void streamIn(istream& s);

  // = Class specific methods.
  /// Constructor used by application
  MMessageCollector(MHL7Factory& factory, MDBHL7Notification* database,
	      const MString& logDir, const MString& storageDir,
	      bool analysisMode, int& shutdownFlag);

  void logHL7Stream(const char* txt, int len);

  ///accept an ADT type hl7 message
  virtual int acceptADT(MHL7Msg& message, const MString& event);

  ///accept an ORM type hl7 message
  virtual int acceptORM(MHL7Msg& message, const MString& event);

  ///accept an ORU type hl7 message
  virtual int acceptORU(MHL7Msg& mesage, const MString& event);

  ///accept an ORR type hl7 message
  virtual int acceptORR(MHL7Msg& message, const MString& event);
  
  

protected:

private:
  bool mAnalysisMode;
  MString mLogDir;
  MString mStorageDir;
  int& mShutdownFlag;

  MDBHL7Notification* mDatabase;

  /// The database reference for storing messages. Saves the message to the specified file path 
  void processInfo(const MHL7Msg& message, const MString& file_path, const MString& event);

};  

inline istream& operator >> (istream& s, MMessageCollector& c) {
  c.streamIn(s);
  return s;
}

#endif
