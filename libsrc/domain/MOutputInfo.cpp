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
#include "MOutputInfo.hpp"

MOutputInfo::MOutputInfo()
{
  tableName("outputinfo");
  insert("studyinsuid");
  // Referenced series sequence
  insert("seriesinsuid");
  insert("retrieveAEtitle");
  // Referenced SOP Sequence
  insert("sopclassuid");
  insert("sopinsuid");
  insert("workitemkey");

}

MOutputInfo::MOutputInfo(const MOutputInfo& cpy) :
  mStudyInstanceUID(cpy.mStudyInstanceUID),
  mSeriesInstanceUID(cpy.mSeriesInstanceUID),
  mRetrieveAETitle(cpy.mRetrieveAETitle),
  mSOPClassUID(cpy.mSOPClassUID),
  mSOPInstanceUID(cpy.mSOPInstanceUID),
  mWorkitemkey(cpy.mWorkitemkey)
{
  tableName("outputinfo");
  insert("studyinsuid", mStudyInstanceUID);
  insert("seriesinsuid", mSeriesInstanceUID);
  insert("retrieveAEtitle", mRetrieveAETitle);
  insert("sopclassuid", mSOPClassUID);
  insert("sopinsuid", mSOPInstanceUID);
  insert("workitemkey", mWorkitemkey);
}

MOutputInfo::~MOutputInfo()
{
}

void
MOutputInfo::printOn(ostream& s) const
{
  s << "MOutputInfo:\n"
    << "    StudyInstanceUID:   " << mStudyInstanceUID << "\n"
    << "    SeriesInstanceUID:   " << mSeriesInstanceUID << "\n"
    << "    RetrieveAETitle:   " << mRetrieveAETitle << "\n"
    << "    SOPClassUID:      " << mSOPClassUID << "\n"
    << "    SOPInstanceUID:   " << mSOPInstanceUID << "\n"
    << "    Workitemkey:   " << mWorkitemkey << "\n";
}

MOutputInfo::MOutputInfo(
	const MString& studyInstanceUID,
	const MString& seriesInstanceUID,
	const MString& retrieveAETitle,
	const MString& SOPClassUID,
	const MString& SOPInstanceUID,
	const MString& workitemkey):
  mStudyInstanceUID(studyInstanceUID),
  mSeriesInstanceUID(seriesInstanceUID),
  mRetrieveAETitle(retrieveAETitle),
  mSOPClassUID(SOPClassUID),
  mSOPInstanceUID(SOPInstanceUID),
  mWorkitemkey(workitemkey)
{
  tableName("outputinfo");
  insert("studyinsuid", studyInstanceUID);
  insert("seriesinsuid", seriesInstanceUID);
  insert("retrieveAEtitle", retrieveAETitle);
  insert("sopclassuid", SOPClassUID);
  insert("sopinsuid", SOPInstanceUID);
  insert("workitemkey", workitemkey);
}

#if 0
int
MOutputInfo::equals(const MOutputInfo& tst)
{
  if( mStudyInstanceUID  != tst.studyInstanceUID())  return 0;
  if( mSeriesInstanceUID != tst.seriesInstanceUID()) return 0;
  if( mRetrieveAETitle   != tst.retrieveAETitle())   return 0;
  if( mSOPClassUID       != tst.SOPClassUID())       return 0;
  if( mSOPInstanceUID    != tst.SOPInstanceUID())    return 0;
  return 1;
}
#endif

void
MOutputInfo::streamIn(istream& s)
{
  //s >> this->member;
}


MString 
MOutputInfo::SOPInstanceUID() const
{
   return mSOPInstanceUID;
}

MString 
MOutputInfo::SOPClassUID() const
{
   return mSOPClassUID;
}

MString 
MOutputInfo::studyInstanceUID() const
{
   return mStudyInstanceUID;
}

MString 
MOutputInfo::seriesInstanceUID() const
{
   return mSeriesInstanceUID;
}

MString 
MOutputInfo::retrieveAETitle() const
{
   return mRetrieveAETitle;
}

MString 
MOutputInfo::workitemkey() const
{
   return mWorkitemkey;
}


void 
MOutputInfo::SOPInstanceUID(const MString& s) 
{
   mSOPInstanceUID = s;
   remove("sopinsuid");
   insert("sopinsuid", s);
}

void 
MOutputInfo::SOPClassUID(const MString& s) 
{
   mSOPClassUID = s;
   remove("sopclassuid");
   insert("sopclassuid", s);
}

void 
MOutputInfo::studyInstanceUID(const MString& s) 
{
   mStudyInstanceUID = s;
   remove("studyinsuid");
   insert("studyinsuid", s);
}

void 
MOutputInfo::seriesInstanceUID(const MString& s) 
{
   mSeriesInstanceUID = s;
   remove("seriesinsuid");
   insert("seriesinsuid", s);
}

void 
MOutputInfo::retrieveAETitle(const MString& s) 
{
   mRetrieveAETitle = s;
   remove("retrieveAEtitle");
   insert("retrieveAEtitle", s);
}

void 
MOutputInfo::workitemkey(const MString& s) 
{
   mWorkitemkey = s;
   remove("workitemkey");
   insert("workitemkey", s);
}


void MOutputInfo::import(const MDomainObject& o)
{
  SOPInstanceUID(o.value("sopinsuid")); 
  SOPClassUID(o.value("sopclassuid")); 
  studyInstanceUID(o.value("studyinsuid")); 
  seriesInstanceUID(o.value("seriesinsuid")); 
  retrieveAETitle(o.value("retrieveAEtitle")); 
  workitemkey(o.value("workitemkey")); 
}

void MOutputInfo::update( MDBInterface &db)
{
  MCriteriaVector cv;
  MCriteria c;
  c.attribute = "workitemkey";
  c.oper      = TBL_EQUAL;
  c.value     = mWorkitemkey;
  cv.push_back(c);

  MUpdateVector   uv;
  MUpdate         u1;
  u1.attribute = "sopinsuid";
  u1.func      = TBL_SET;
  u1.value     = mSOPInstanceUID;
  uv.push_back(u1);
  MUpdate         u2;
  u2.attribute = "sopclassuid";
  u2.func      = TBL_SET;
  u2.value     = mSOPClassUID;
  uv.push_back(u2);
  MUpdate         u3;
  u3.attribute = "studyinsuid";
  u3.func      = TBL_SET;
  u3.value     = mStudyInstanceUID;
  uv.push_back(u3);
  MUpdate         u4;
  u4.attribute = "seriesinsuid";
  u4.func      = TBL_SET;
  u4.value     = mSeriesInstanceUID;
  uv.push_back(u4);
  MUpdate         u5;
  u5.attribute = "retrieveAEtitle";
  u5.func      = TBL_SET;
  u5.value     = mRetrieveAETitle;
  uv.push_back(u5);

cout << "Outputinfo update workitemkey: " << mWorkitemkey << "\n";

  db.update( *this, cv, uv);
  //db.insert( *this);
}

void MOutputInfo::dbremove( MDBInterface *db)
{
  MCriteriaVector cv;
  MCriteria c;
  c.attribute = "workitemkey";
  c.oper      = TBL_EQUAL;
  c.value     = mWorkitemkey;
  cv.push_back(c);

  db->remove( *this, cv);
}

void MOutputInfo::dbinsert( MDBInterface *db)
{

  db->insert( *this);
}
