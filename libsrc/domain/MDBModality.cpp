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
#include "MDBModality.hpp"

MDBModality::MDBModality() :
  mDBInterface(0)
{
}

MDBModality::MDBModality(const MDBModality& cpy)
{
}

MDBModality::~MDBModality()
{
}

void
MDBModality::printOn(ostream& s) const
{
  s << "MDBModality";
}

void
MDBModality::streamIn(istream& s)
{
  //s >> this->member;
}

// Now, the non-boiler plate methods will follow.

MDBModality::MDBModality(const string& databaseName)
{
  mDBInterface = new MDBInterface(databaseName);
}

void
MDBModality::openDatabase(const MString& databaseName)
{
  if (mDBInterface)
    delete mDBInterface;

  mDBInterface = new MDBInterface(databaseName);
}


MString
MDBModality::newStudyInstanceUID() const
{
  MString s;

  s = mIdentifier.dicomUID(MIdentifier::MUID_STUDY, *mDBInterface);

  return s;
}

MString
MDBModality::newSeriesInstanceUID() const
{
  MString s;

  s = mIdentifier.dicomUID(MIdentifier::MUID_SERIES, *mDBInterface);

  return s;
}

MString
MDBModality::newSOPInstanceUID() const
{
  MString s;

  s = mIdentifier.dicomUID(MIdentifier::MUID_SOPINSTANCE, *mDBInterface);

  return s;
}

MString
MDBModality::newTransactionUID() const
{
  MString s;

  s = mIdentifier.dicomUID(MIdentifier::MUID_TRANSACTION, *mDBInterface);

  return s;
}

MString
MDBModality::newPPSUID() const
{
  MString s;

  s = mIdentifier.dicomUID(MIdentifier::MUID_PPS, *mDBInterface);

  return s;
}

MString
MDBModality::newProcedureStepID() const
{
  MString s;

  s = mIdentifier.mesaID(MIdentifier::MID_PPSID, *mDBInterface);

  return s;
}

MString
MDBModality::newStudyID() const
{
  MString s;

  s = mIdentifier.mesaID(MIdentifier::MID_STUDYID, *mDBInterface);

  return s;
}
