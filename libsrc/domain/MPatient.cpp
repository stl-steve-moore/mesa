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

#include "MPatient.hpp"
  
MPatient::MPatient()
{
  tableName("patient");
  this->fillMap();
}

MPatient::MPatient(const MPatient& cpy) :
  mPatientID(cpy.mPatientID),
  mIssuerOfPatientID(cpy.mIssuerOfPatientID),
  mIdentifierType(cpy.mIdentifierType),
  mPatientID2(cpy.mPatientID2),
  mIssuerOfPatientID2(cpy.mIssuerOfPatientID2),
  mPatientName(cpy.mPatientName),
  mDateOfBirth(cpy.mDateOfBirth),
  mPatientSex(cpy.mPatientSex),
  mPriorIDList(cpy.mPriorIDList),
  mAddress(cpy.mAddress),
  mXRefKey(cpy.mXRefKey),
  mPatientAccountNumber(cpy.mPatientAccountNumber),
  mPatientRace(cpy.mPatientRace)
{
  tableName("patient");
  this->fillMap();
}

MPatient::~MPatient()
{
}

void
MPatient::printOn(ostream& s) const
{
  s << mPatientID << ":"
    << mIssuerOfPatientID << ":"
    << mPatientID2 << ":"
    << mIssuerOfPatientID2 << ":"
    << mPatientName << ":"
    << mDateOfBirth << ":"
    << mPatientSex << ":"
    << mAddress << ":"
    << mXRefKey << ":"
    << mPatientAccountNumber << ":"
    << mPatientRace;
}

MPatient::MPatient(const MString& patientID, const MString& issuerOfPatientID,
	  const MString& identifierType,
	  const MString& patientID2, const MString& issuerOfPatientID2,
	  const MString& patientName, const MString& dateOfBirth,
	  const MString& patientSex, const MString& address,
	  const MString& xRefKey,    const MString& patientAccountNumber,
	  const MString& patientRace) :
	  mPatientID(patientID),
	  mIssuerOfPatientID(issuerOfPatientID),
	  mPatientID2(patientID2),
	  mIssuerOfPatientID2(issuerOfPatientID2),
	  mPatientName(patientName),
	  mDateOfBirth(dateOfBirth),
	  mPatientSex(patientSex),
	  mAddress(address),
	  mXRefKey(xRefKey),
	  mPatientAccountNumber(patientAccountNumber),
	  mPatientRace(patientRace),
	  mIdentifierType("")
{
  tableName("patient");
  this->fillMap();
}

void
MPatient::streamIn(istream& s)
{
  s >> mPatientID;
}

MString
MPatient::patientID() const
{
  return mPatientID;
}

MString
MPatient::issuerOfPatientID() const
{
  return mIssuerOfPatientID;
}

MString
MPatient::identifierType() const
{
  return mIdentifierType;
}

MString
MPatient::patientID2() const
{
  return mPatientID2;
}

MString
MPatient::issuerOfPatientID2() const
{
  return mIssuerOfPatientID2;
}

MString
MPatient::patientName() const
{
  return mPatientName;
}

MString
MPatient::dateOfBirth() const
{
  return mDateOfBirth;
}

MString
MPatient::patientSex() const
{
  return mPatientSex;
}

MString
MPatient::priorIDList() const
{
  return mPriorIDList;
}

MString
MPatient::priorID(const MString& issuer) const
{
  int index = 0;
  MString s = mPriorIDList;
  for (index = 0; ; index++) {
    if (s.tokenExists('~', index)) {
      MString idString = s.getToken('~', index);
      MString x = idString.getToken('^', 3);
      if (issuer == x) {
	MString y = idString.getToken('^', 0);
	return y;
      }
    } else {
      return "";
    }
  }
  return "";
}

MString
MPatient::address() const
{
  return mAddress;
}

MString
MPatient::xRefKey() const
{
  return mXRefKey;
}

MString
MPatient::patientAccountNumber() const
{
  return mPatientAccountNumber;
}

MString
MPatient::patientRace() const
{
  return mPatientRace;
}

void
MPatient::patientID(const MString& s)
{
  mPatientID = s;
  insert("patid", s);
}

void
MPatient::issuerOfPatientID(const MString& s)
{
  mIssuerOfPatientID = s;
  insert("issuer", s);
}

void
MPatient::identifierType(const MString& s)
{
  mIdentifierType= s;
  insert("identifier_type", s);
}

void
MPatient::patientID2(const MString& s)
{
  mPatientID2 = s;
  insert("patid2", s);
}

void
MPatient::issuerOfPatientID2(const MString& s)
{
  mIssuerOfPatientID2 = s;
  insert("issuer2", s);
}

void
MPatient::patientName(const MString& s)
{
  mPatientName = s;
  insert("nam", s);
}

void
MPatient::dateOfBirth(const MString& s)
{
  mDateOfBirth = s;
  insert("datbir", s);
}

void
MPatient::patientSex(const MString& s)
{
  mPatientSex = s;
  insert("sex", s);
}

void
MPatient::priorIDList(const MString& s)
{
  mPriorIDList = s;
}

void
MPatient::address(const MString& s)
{
  mAddress = s;
  insert("addr", s);
}

void
MPatient::xRefKey(const MString& s)
{
  mXRefKey = s;
  insert("xrefkey", s);
}

void
MPatient::patientAccountNumber(const MString& s)
{
  mPatientAccountNumber = s;
  insert("pataccnum", s);
}

void
MPatient::patientRace(const MString& s)
{
  mPatientRace = s;
  insert("patrac", s);
}

void MPatient::import(const MDomainObject& o)
{
  patientID(o.value("patid"));
  issuerOfPatientID(o.value("issuer"));
  identifierType(o.value("identifier_type"));
  patientID2(o.value("patid2"));
  issuerOfPatientID2(o.value("issuer2"));
  patientName(o.value("nam"));
  dateOfBirth(o.value("datbir"));
  patientSex(o.value("sex"));
  priorIDList(o.value("prioridlist"));
  address(o.value("addr"));
  xRefKey(o.value("xrefkey"));
  patientAccountNumber(o.value("pataccnum"));
  patientRace(o.value("patrac"));
}

void
MPatient::fillMap()
{
  insert("patid", mPatientID);
  insert("issuer", mIssuerOfPatientID);
  insert("identifier_type", mIdentifierType);
  insert("patid2", mPatientID2);
  insert("issuer2", mIssuerOfPatientID2);
  insert("nam", mPatientName);
  insert("datbir", mDateOfBirth);
  insert("sex", mPatientSex);
  insert("addr", mAddress);
  insert("xrefkey", mXRefKey);
  insert("pataccnum", mPatientAccountNumber);
  insert("patrac", mPatientRace);
}
