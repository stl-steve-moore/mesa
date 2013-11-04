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

#include <fstream>
#include <fcntl.h>
#include <stdio.h>
#ifndef _WIN32
#include <unistd.h>
#endif
#ifdef GCC4
#include <stdlib.h>
#endif

#include "MHL7Factory.hpp"
#include "MHL7Msg.hpp"
#include "MHL7MessageControlID.hpp"
#include "MFileOperations.hpp"
#include "MLogClient.hpp"

MHL7Factory::MHL7Factory() :
  mFlavor(0)
{
}

MHL7Factory::MHL7Factory(const MHL7Factory& cpy)
{
}

MHL7Factory::~MHL7Factory()
{
  if (mFlavor != 0) {
    HL7Drop(mFlavor);
    mFlavor = 0;
  }
}

void
MHL7Factory::printOn(ostream& s) const
{
  s << "MHL7Factory";
}

void
MHL7Factory::streamIn(istream& s)
{
  //s >> this->member;
}


// Non-boiler plate methods below

MHL7Factory::MHL7Factory(const MString& tablePath, const MString& version)
{
  char path[1024];
  char v[1024];

  tablePath.safeExport(path, sizeof(path));
  version.safeExport(v, sizeof(v));

  mFlavor = ::HL7Init(path, v);

  if (mFlavor == 0) {
    cerr << "Could not initialize HL7 toolkit with "
	 << tablePath << ":"
	 << version << endl;
    exit(1);
  }
}

MHL7Msg*
MHL7Factory::produce(const char* hl7Stream, int length)
{
  HL7MSG* pMsg = ::HL7Alloca(mFlavor);
  if (pMsg == 0) {
    cerr << "Could not allocate HL7 Message" << endl;
    exit(1);
  }

  MHL7Msg* msg = new MHL7Msg(pMsg, hl7Stream, length);
  //MASSERT((msg != 0));

  //int result = ::HL7ReadMsg(pMsg, hl7Stream);
  //MASSERT(result == HL7_OK);

  return msg;
}

MHL7Msg*
MHL7Factory::produce()
{
  HL7MSG* pMsg = ::HL7Alloca(mFlavor);
  if (pMsg == 0) {
    cerr << "Could not allocate HL7 Message" << endl;
    exit(1);
  }

  MHL7Msg* msg = new MHL7Msg(pMsg);
  return msg;
}

MHL7Msg*
MHL7Factory::readFromFile(const MString& fileName)
{
  char buf[163840];
  char *p;


  char ex[1024];
  fileName.safeExport(ex, sizeof(ex));

  ifstream f(ex);

  if (!f)
    return 0;

  p = buf;
  int length = sizeof(buf);

  while (f.getline(p, length)) {
    if (p[0] == '#')
      continue;

    p += f.gcount() - 1;
    length -= (f.gcount() - 1);
  }
  *p++ = 0x0d;
  *p = '\0';

  MHL7Msg* msg;

  p = buf;
  if (p[0] == 0x0b) {
    p++;
  }

  msg = this->produce(p, strlen(p));

  return msg;
}


MHL7Msg*
MHL7Factory::produceACK(MHL7Msg& msg, const MString& prefix,
	const MString& ackCode, const MString& errorCondition)
{
  
  HL7MSG* pMsg = ::HL7Alloca(mFlavor);
  if (pMsg == 0) {
    cerr << "Could not allocate HL7 Message" << endl;
    exit(1);
  }
  MHL7MessageControlID c;
  MString controlID = prefix + c.controlID();
  char p[512];
  controlID.safeExport(p, sizeof(p));

  ::HL7InsSegm(pMsg, "MSH");
  ::HL7PutFld(pMsg, "^~\\&", 2);
  ::HL7PutFld(pMsg, "ACK", 9);
  ::HL7PutFld(pMsg, p, 10);
  ::HL7PutFld(pMsg, "P", 11);
//  ::HL7PutFld(pMsg, "2.3.1", 12);

  ::HL7InsSegm(pMsg, "MSA");

  HL7_COPY_MAP m[] = {
    { "MSH", 5, "MSH", 3},     // Sending Application
    { "MSH", 6, "MSH", 4},     // Sending Facility
    { "MSH", 3, "MSH", 5},     // Receiving Application
    { "MSH", 4, "MSH", 6},     // Receiving Application
    { "MSH", 10,"MSA", 2},     // Message Control ID
    { "MSH", 12,"MSH", 12},    // Version ID
    { "", 0, "", 0}
  };

  this->copyFields(m, msg, pMsg);

  MHL7Msg* returnMsg = new MHL7Msg(pMsg);
  if (ackCode == "") {
    returnMsg->setValue("MSA", 1, 0, "AA");
  } else {
    returnMsg->setValue("MSA", 1, 0, ackCode);
  }
  if (errorCondition != "") {
    returnMsg->setValue("MSA", 6, 0, errorCondition);
  }

  return returnMsg;
}

MHL7Msg*
MHL7Factory::produceRSP(MHL7Msg& msg, const MString& prefix)
{
  HL7MSG* pMsg = ::HL7Alloca(mFlavor);
  if (pMsg == 0) {
    cerr << "Could not allocate HL7 Message" << endl;
    exit(1);
  }
  MHL7MessageControlID c;
  MString controlID = prefix + c.controlID();
  char p[512];
  controlID.safeExport(p, sizeof(p));

  ::HL7InsSegm(pMsg, "MSH");
  ::HL7PutFld(pMsg, "^~\\&", 2);
  ::HL7PutFld(pMsg, "RSP^K23", 9);
  ::HL7PutFld(pMsg, p, 10);
  ::HL7PutFld(pMsg, "P", 11);

  ::HL7InsSegm(pMsg, "MSA");
  ::HL7PutFld(pMsg, "AA", 1);
  ::HL7InsSegm(pMsg, "QAK");
  ::HL7InsSegm(pMsg, "QPD");

  HL7_COPY_MAP m[] = {
    { "MSH", 5, "MSH", 3},     // Sending Application
    { "MSH", 6, "MSH", 4},     // Sending Facility
    { "MSH", 3, "MSH", 5},     // Receiving Application
    { "MSH", 4, "MSH", 6},     // Receiving Application
    { "MSH", 12,"MSH", 12},    // Version number
    { "MSH", 10,"MSA", 2},     // Message Control ID
    { "QPD", 1, "QPD", 1},     // Message Query Name
    { "QPD", 2, "QPD", 2},     // Query Tag
    { "QPD", 3, "QPD", 3},     // Person Identifier
    { "QPD", 4, "QPD", 4},     // What Domains Returned
    { "QPD", 2, "QAK", 1},     // Query Tag
    { "", 0, "", 0}
  };

  this->copyFields(m, msg, pMsg);

  MHL7Msg* returnMsg = new MHL7Msg(pMsg);
  return returnMsg;
}

MHL7Msg*
MHL7Factory::produceRSPK22Baseline(MHL7Msg& msg, const MString& prefix)
{
  HL7MSG* pMsg = ::HL7Alloca(mFlavor);
  if (pMsg == 0) {
    cerr << "Could not allocate HL7 Message" << endl;
    exit(1);
  }
  MHL7MessageControlID c;
  MString controlID = prefix + c.controlID();
  char p[512];
  controlID.safeExport(p, sizeof(p));

  ::HL7InsSegm(pMsg, "MSH");
  ::HL7PutFld(pMsg, "^~\\&", 2);
  ::HL7PutFld(pMsg, "RSP^K22", 9);
  ::HL7PutFld(pMsg, p, 10);
  ::HL7PutFld(pMsg, "P", 11);

  ::HL7InsSegm(pMsg, "MSA");
  ::HL7PutFld(pMsg, "AA", 1);
  ::HL7InsSegm(pMsg, "QAK");
  ::HL7InsSegm(pMsg, "QPD");

  HL7_COPY_MAP m[] = {
    { "MSH", 5, "MSH", 3},     // Sending Application
    { "MSH", 6, "MSH", 4},     // Sending Facility
    { "MSH", 3, "MSH", 5},     // Receiving Application
    { "MSH", 4, "MSH", 6},     // Receiving Application
    { "MSH", 12,"MSH", 12},    // Version number
    { "MSH", 10,"MSA", 2},     // Message Control ID
    { "QPD", 1, "QPD", 1},     // Message Query Name
    { "QPD", 2, "QPD", 2},     // Query Tag
    { "QPD", 3, "QPD", 3},     // Person Identifier
    { "QPD", 8, "QPD", 8},     // What Domains Returned
    { "QPD", 2, "QAK", 1},     // Query Tag
    { "", 0, "", 0}
  };

  this->copyFields(m, msg, pMsg);

  MHL7Msg* returnMsg = new MHL7Msg(pMsg);
  return returnMsg;
}

int
MHL7Factory::appendRSPK22PatientIdentification(MHL7Msg& msg, MStringMap& m)
{
  MLogClient logClient;
  logClient.log(MLogClient::MLOG_VERBOSE,
	"", "MHL7Factor::appendRSPK22PatientIdentification",
	__LINE__, "Enter method");

  MString pID   = m["pid3"];
  MString pName = m["pid5"];
  MString pDOB  = m["pid7"];
  MString pSex  = m["pid8"];
  MString pAddr = m["pid11"];

  MString debugString = pID + ":" + pName + ":" + pDOB + ":" + pSex + ":" + pAddr;
  logClient.logTimeStamp(MLogClient::MLOG_VERBOSE, debugString);
//  cout << "Patient ID   " << pID   << endl;
//  cout << "Patient Name " << pName << endl;
//  cout << "Patient DOB  " << pDOB  << endl;
//  cout << "Patient Sex  " << pSex  << endl;
//  cout << "Patient Addr " << pAddr << endl;

  MString x = msg.firstSegment();
  while (x != "") {
    x = msg.nextSegment();
  }
  msg.insertSegment("PID");
  msg.setValue(3, 0, pID);
  msg.setValue(5, 0, pName);
  msg.setValue(7, 0, pDOB);
  msg.setValue(8, 0, pSex);
  msg.setValue(11, 0, pAddr);

  logClient.log(MLogClient::MLOG_VERBOSE,
	"", "MHL7Factor::appendRSPK22PatientIdentification",
	__LINE__, "Leave method");
  return 0;
}

int
MHL7Factory::appendContinuationText(MHL7Msg& msg, const MString& txt)
{
  MString x = msg.firstSegment();
  while (x != "") {
    x = msg.nextSegment();
  }
  msg.insertSegment("DSC");
  msg.setValue(1, 0, txt);
  msg.setValue(2, 0, "I");

  return 0;
}

MHL7Msg*
MHL7Factory::produceORR(MHL7Msg& ormMsg, const MString& orderControl,
	const MString& placerOrderNumber)
{

  HL7MSG* pMsg = ::HL7Alloca(mFlavor);
  if (pMsg == 0) {
    cerr << "Could not allocate HL7 Message" << endl;
    exit(1);
  }

  ::HL7InsSegm(pMsg, "MSH");
  ::HL7PutFld(pMsg, "^~\\&", 2);
  ::HL7PutFld(pMsg, "ORR^O02", 9);
  ::HL7PutFld(pMsg, "xxx", 10);
  ::HL7PutFld(pMsg, "P", 11);
  ::HL7PutFld(pMsg, "2.3.1", 12);

  ::HL7InsSegm(pMsg, "MSA");
  ::HL7PutFld(pMsg, "AA", 1);

  HL7_COPY_MAP m[] = {
    { "MSH", 5, "MSH", 3},     // Sending Application
    { "MSH", 6, "MSH", 4},     // Sending Facility
    { "MSH", 3, "MSH", 5},     // Receiving Application
    { "MSH", 4, "MSH", 6},     // Receiving Application
    { "MSH", 11,"MSA", 2},     // Message Control ID
    { "", 0, "", 0}
  };

  this->copyFields(m, ormMsg, pMsg);

  ormMsg.firstSegment();
  MString seg = ormMsg.nextSegment();
  char* ordCon = orderControl.strData();
  char placerOrderNumberText[100];
  placerOrderNumber.safeExport(placerOrderNumberText,
	sizeof(placerOrderNumberText));

  while(seg != "")
  {
    if ((seg == "PV1") || (seg == "PID")) {
      // ORR message does not contain PID or PV1 segment
      seg = ormMsg.nextSegment();
      continue;
    }

    char* cSeg = seg.strData();
    ::HL7InsSegm(pMsg, cSeg);
    this->copyFields(ormMsg, pMsg);
    delete [] cSeg;

    // if an ORC segment, then insert the order control that the caller wants
    if (seg == "ORC") {
      ::HL7PutFld(pMsg, ordCon, 1);
      if (placerOrderNumber != "") {
	::HL7PutFld(pMsg, placerOrderNumberText, 2);
      }
    } else if (seg == "OBR") {
      if (placerOrderNumber != "") {
	::HL7PutFld(pMsg, placerOrderNumberText, 2);
      }
    }
    seg = ormMsg.nextSegment();
  }

  delete [] ordCon;
  MHL7Msg* returnMsg = new MHL7Msg(pMsg);
  return returnMsg;
}

typedef struct {
  char* fieldName;
  int fieldNumber;
} FIELD_MAP;

MHL7Msg*
MHL7Factory::produceOnlyMSH(const MString& fileName,
	  const MString& messageType)
{
  HL7MSG* pMsg = ::HL7Alloca(mFlavor);
  if (pMsg == 0) {
    cerr << "Could not allocate HL7 Message" << endl;
    exit(1);
  }
  MStringMap m;
  MFileOperations f;
  int i = f.readParamsMap(fileName, m);
  if (i != 0) {
    ::HL7Free(pMsg);
    return 0;
  }
  ::HL7InsSegm(pMsg, "MSH");
  ::HL7PutFld(pMsg, "^~\\&", 2);
  MHL7Msg* msg = new MHL7Msg(pMsg);
  msg->firstSegment();
  msg->setValue(9, 0, messageType);

  FIELD_MAP fm [] = {
	  {"SENDING_APPLICATION",   3},
	  {"SENDING_FACILITY",      4},
	  {"RECEIVING_APPLICATION", 5},
	  {"RECEIVING_FACILITY",    6},
	  {"PROCESSING_ID",        11},
	  {"VERSION_ID",           12},
	  {"", 0}
  };

  for (i = 0; fm[i].fieldNumber != 0; i++) {
    MString v = m[fm[i].fieldName];
    if (v == "") {
      MLogClient log;
      log.log(MLogClient::MLOG_ERROR,
	      MString("Could not find variable for attribute: ") +
	      MString(m[fm[i].fieldName]) + MString(" in file ") +
	      fileName);
      delete msg;
      return 0;
    }
    msg->setValue(fm[i].fieldNumber, 0, v);
  }
  MHL7MessageControlID c;
  MString id = c.controlID();
  msg->setValue(10, 0, id);

#if 0
  ::HL7PutFld(pMsg, "ORR^O02", 9);
  ::HL7PutFld(pMsg, "xxx", 10);
  ::HL7PutFld(pMsg, "P", 11);
  ::HL7PutFld(pMsg, "2.3.1", 12);
#endif


  return msg;
}

// Private methods below
int
MHL7Factory::copyFields(HL7_COPY_MAP* copyMap, MHL7Msg& source, HL7MSG* target)
{
  while (copyMap->sourceSegment[0] != '\0') {
    MString v = source.getValue(copyMap->sourceSegment,
				copyMap->sourceField,
				0);
    char* cPtr = 0;

    ::HL7FirstSegm(target, &cPtr);
    ::HL7FindSegm(target, copyMap->targetSegment);

    char* vCpy = v.strData();

    ::HL7PutFld(target, vCpy, copyMap->targetField);

    delete []vCpy;
    copyMap++;
  }
  return 0;
}

int
MHL7Factory::copyFields(MHL7Msg& source, HL7MSG* target)
{
  // copy all the fields from the current segment of the source to the target
  int numFlds = source.numberOfFields();
  for (int inx = 1; inx <= numFlds; inx++)
  {
    MString v = source.getValue(inx, 0);
    char* vCpy = v.strData();
    ::HL7PutFld(target, vCpy, inx);
    delete []vCpy;
  }
  return 0;
}

