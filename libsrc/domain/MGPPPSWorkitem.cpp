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
#include "MGPPPSWorkitem.hpp"
#include "MDBInterface.hpp"

MGPPPSWorkitem::MGPPPSWorkitem()
{
  tableName("gpppsworkitem");
  insert("sopinsuid");
  insert("reqprocAccessionNum");
  insert("reqprocID");
  insert("reqprocDesc");
  insert("reqprocCodevalue");
  insert("reqprocCodemeaning");
  insert("reqprocCodescheme");
  insert("patientid");
  insert("patientname");
  insert("birthdate");
  insert("sex");
  insert("procstepid");
  insert("status");
  insert("startdate");
  insert("starttime");
  insert("enddate");
  insert("endtime");
  insert("description");
}

MGPPPSWorkitem::MGPPPSWorkitem(const MGPPPSWorkitem& cpy) :
  mSOPInstanceUID(cpy.mSOPInstanceUID),
  mStatus(cpy.mStatus),
  mProcedureStepID(cpy.mProcedureStepID),
  mStartDate(cpy.mStartDate),
  mStartTime(cpy.mStartTime),
  mEndDate(cpy.mEndDate),
  mEndTime(cpy.mEndTime),
  mDescription(cpy.mDescription),
  mPatientID(cpy.mPatientID),
  mPatientName(cpy.mPatientName),
  mPatientBirthDate(cpy.mPatientBirthDate),
  mPatientSex(cpy.mPatientSex),
  mRequestedProcAccessionNum(cpy.mRequestedProcAccessionNum),
  mRequestedProcID(cpy.mRequestedProcID),
  mRequestedProcDesc(cpy.mRequestedProcDesc),
  mRequestedProcCodevalue(cpy.mRequestedProcCodevalue),
  mRequestedProcCodemeaning(cpy.mRequestedProcCodemeaning),
  mRequestedProcCodescheme(cpy.mRequestedProcCodescheme)
{
  tableName("gpppsworkitem");
  insert("sopinsuid", mSOPInstanceUID);
  insert("status", mStatus);
  insert("procstepid", mProcedureStepID);
  insert("startdate", mStartDate);
  insert("starttime", mStartTime);
  insert("enddate", mEndDate);
  insert("endtime", mEndTime);
  insert("description", mDescription);
  insert("patientid", mPatientID);
  insert("patientname", mPatientName);
  insert("birthdate", mPatientBirthDate);
  insert("sex", mPatientSex);
  insert("reqprocAccessionNum", mRequestedProcAccessionNum);
  insert("reqprocID", mRequestedProcID);
  insert("reqprocDesc", mRequestedProcDesc);
  insert("reqprocCodevalue", mRequestedProcCodevalue);
  insert("reqprocCodemeaning", mRequestedProcCodemeaning);
  insert("reqprocCodescheme", mRequestedProcCodescheme);
}

MGPPPSWorkitem::~MGPPPSWorkitem()
{
}

void
MGPPPSWorkitem::printOn(ostream& s) const
{
  s << "MGPPPSWorkitem:\n"
    << "  Workitem\n"
    << "    sop ins uid:      " << mSOPInstanceUID << "\n"
    << "    status:           " << mStatus << "\n"
    << "    proc step id:     " << mProcedureStepID << "\n"
    << "    start date:       " << mStartDate << "\n"
    << "    start time:       " << mStartTime << "\n"
    << "    end date:         " << mEndDate << "\n"
    << "    end time:         " << mEndTime << "\n"
    << "    description:      " << mDescription << "\n"
    << "    reqProcAccNum  :  " << mRequestedProcAccessionNum << "\n"
    << "    requestedProcID:  " << mRequestedProcID << "\n"
    << "    requestedProcDesc:" << mRequestedProcDesc << "\n"
    << "    reqProcCodeValue: " << mRequestedProcCodevalue << "\n"
    << "    reqProcCodemean:  " << mRequestedProcCodemeaning << "\n"
    << "    reqProcCodeschem: " << mRequestedProcCodescheme << "\n"
    << "  Patient\n"
    << "    ID:               " << mPatientID << "\n"
    << "    Name:             " << mPatientName << "\n"
    << "    bday:             " << mPatientBirthDate << "\n"
    << "    sex:              " << mPatientSex << "\n";
}

MGPPPSWorkitem::MGPPPSWorkitem(
	const MString& sopinsuid,
	const MString& status,
	const MString& procedureStepID,
	const MString& startDate,
	const MString& startTime,
	const MString& endDate,
	const MString& endTime,
	const MString& description,
	const MString& patientID,
	const MString& patientName,
	const MString& patientBirthDate,
	const MString& patientSex,
	const MString& requestedProcAccessionNum,
	const MString& requestedProcID,
	const MString& requestedProcDesc,
	const MString& requestedProcCodevalue,
	const MString& requestedProcCodemeaning,
	const MString& requestedProcCodescheme):
  mSOPInstanceUID(sopinsuid),
  mStatus(status),
  mProcedureStepID(procedureStepID),
  mStartDate(startDate),
  mStartTime(startTime),
  mEndDate(endDate),
  mEndTime(endTime),
  mDescription(description),
  mPatientID(patientID),
  mPatientName(patientName),
  mPatientBirthDate(patientBirthDate),
  mPatientSex(patientSex),
  mRequestedProcAccessionNum(requestedProcAccessionNum),
  mRequestedProcID(requestedProcID),
  mRequestedProcDesc(requestedProcDesc),
  mRequestedProcCodevalue(requestedProcCodevalue),
  mRequestedProcCodemeaning(requestedProcCodemeaning),
  mRequestedProcCodescheme(requestedProcCodescheme)

{
  tableName("gpppsworkitem");
  insert("sopinsuid", sopinsuid);
  insert("status", status);
  insert("procstepid", procedureStepID);
  insert("startdate", startDate);
  insert("starttime", startTime);
  insert("enddate", endDate);
  insert("endtime", endTime);
  insert("description", description);
  insert("patientid", patientID);
  insert("patientname", patientName);
  insert("birthdate", patientBirthDate);
  insert("sex", patientSex);
  insert("reqprocAccessionNum", requestedProcAccessionNum);
  insert("reqprocID", requestedProcID);
  insert("reqprocDesc", requestedProcDesc);
  insert("reqprocCodevalue", requestedProcCodevalue);
  insert("reqprocCodemeaning", requestedProcCodemeaning);
  insert("reqprocCodescheme", requestedProcCodescheme);
}

void
MGPPPSWorkitem::streamIn(istream& s)
{
  //s >> this->member;
}


MString 
MGPPPSWorkitem::SOPInstanceUID() const
{
   return mSOPInstanceUID;
}

MString 
MGPPPSWorkitem::status() const
{
   return mStatus;
}

MString 
MGPPPSWorkitem::procedureStepID() const
{
   return mProcedureStepID;
}

MString 
MGPPPSWorkitem::startDate() const
{
   return mStartDate;
}

MString 
MGPPPSWorkitem::startTime() const
{
   return mStartTime;
}

MString 
MGPPPSWorkitem::endDate() const
{
   return mEndDate;
}

MString 
MGPPPSWorkitem::endTime() const
{
   return mEndTime;
}

MString 
MGPPPSWorkitem::description() const
{
   return mDescription;
}

MString 
MGPPPSWorkitem::patientID() const
{
   return mPatientID;
}

MString 
MGPPPSWorkitem::patientName() const
{
   return mPatientName;
}

MString 
MGPPPSWorkitem::patientBirthDate() const
{
   return mPatientBirthDate;
}

MString 
MGPPPSWorkitem::patientSex() const
{
   return mPatientSex;
}

MString 
MGPPPSWorkitem::requestedProcAccessionNum() const 
{
   return mRequestedProcAccessionNum;
}

MString 
MGPPPSWorkitem::requestedProcID() const
{
   return mRequestedProcID;
}

MString 
MGPPPSWorkitem::requestedProcDesc() const
{
   return mRequestedProcDesc;
}

MString 
MGPPPSWorkitem::requestedProcCodevalue() const
{
   return mRequestedProcCodevalue;
}

MString 
MGPPPSWorkitem::requestedProcCodemeaning() const
{
   return mRequestedProcCodemeaning;
}

MString 
MGPPPSWorkitem::requestedProcCodescheme() const
{
   return mRequestedProcCodescheme;
}


void 
MGPPPSWorkitem::SOPInstanceUID(const MString& s) 
{
   mSOPInstanceUID = s;
   remove("sopinsuid");
   insert("sopinsuid", s);
}

void 
MGPPPSWorkitem::status(const MString& s) 
{
   mStatus = s;
   remove("status");
   insert("status", s);
}

void 
MGPPPSWorkitem::procedureStepID(const MString& s) 
{
   mProcedureStepID = s;
   remove("procstepid");
   insert("procstepid", s);
}

void 
MGPPPSWorkitem::startDate(const MString& s) 
{
   mStartDate = s;
   remove("startdate");
   insert("startdate", s);
}

void 
MGPPPSWorkitem::startTime(const MString& s) 
{
   mStartTime = s;
   remove("starttime");
   insert("starttime", s);
}

void 
MGPPPSWorkitem::endDate(const MString& s) 
{
   mEndDate = s;
   remove("enddate");
   insert("enddate", s);
}

void 
MGPPPSWorkitem::endTime(const MString& s) 
{
   mEndTime = s;
   remove("endtime");
   insert("endtime", s);
}

void 
MGPPPSWorkitem::description(const MString& s) 
{
   mDescription = s;
   remove("description");
   insert("description", s);
}

void 
MGPPPSWorkitem::patientID(const MString& s) 
{
   mPatientID = s;
   remove("patientid");
   insert("patientid", s);
}

void 
MGPPPSWorkitem::patientName(const MString& s) 
{
   mPatientName = s;
   remove("patientname");
   insert("patientname", s);
}

void 
MGPPPSWorkitem::patientBirthDate(const MString& s) 
{
   mPatientBirthDate = s;
   remove("birthdate");
   insert("birthdate", s);
}

void 
MGPPPSWorkitem::patientSex(const MString& s) 
{
   mPatientSex = s;
   remove("sex");
   insert("sex", s);
}

void 
MGPPPSWorkitem::requestedProcAccessionNum(const MString& s) 
{
   mRequestedProcAccessionNum = s;
   remove("reqprocAccessionNum");
   insert("reqprocAccessionNum", s);
}

void 
MGPPPSWorkitem::requestedProcID(const MString& s) 
{
   mRequestedProcID = s;
   remove("reqprocID");
   insert("reqprocID", s);
}

void 
MGPPPSWorkitem::requestedProcDesc(const MString& s) 
{
   mRequestedProcDesc = s;
   remove("reqprocDesc");
   insert("reqprocDesc", s);
}

void 
MGPPPSWorkitem::requestedProcCodevalue(const MString& s) 
{
   mRequestedProcCodevalue = s;
   remove("reqprocCodevalue");
   insert("reqprocCodevalue", s);
}

void 
MGPPPSWorkitem::requestedProcCodemeaning(const MString& s) 
{
   mRequestedProcCodemeaning = s;
   remove("reqprocCodemeaning");
   insert("reqprocCodemeaning", s);
}

void 
MGPPPSWorkitem::requestedProcCodescheme(const MString& s) 
{
   mRequestedProcCodescheme = s;
   remove("reqprocCodescheme");
   insert("reqprocCodescheme", s);
}


void MGPPPSWorkitem::import(const MDomainObject& o)
{
  SOPInstanceUID(o.value("sopinsuid"));
  requestedProcAccessionNum(o.value("reqprocAccessionNum"));
  requestedProcID(o.value("reqprocID"));
  requestedProcDesc(o.value("reqprocDesc"));
  requestedProcCodevalue(o.value("reqprocCodevalue"));
  requestedProcCodemeaning(o.value("reqprocCodemeaning"));
  requestedProcCodescheme(o.value("reqprocCodescheme"));
  patientName(o.value("patientname")); 
  patientID(o.value("patientid")); 
  patientBirthDate(o.value("birthdate")); 
  patientSex(o.value("sex")); 
  procedureStepID(o.value("procstepid")); 
  startDate(o.value("startdate")); 
  startTime(o.value("starttime")); 
  status(o.value("status")); 
  description(o.value("description")); 
  endDate(o.value("enddate")); 
  endTime(o.value("endtime")); 
}

void MGPPPSWorkitem::update( MDBInterface *db) {

  MCriteriaVector cv;
  MCriteria c;
  c.attribute = "sopinsuid";
  c.oper      = TBL_EQUAL;
  c.value     = mSOPInstanceUID;
  cv.push_back(c);

  MUpdateVector   uv;
  MUpdate         u1;
  u1.attribute = "status";
  u1.func      = TBL_SET;
  u1.value     = mStatus;
  uv.push_back(u1);
  MUpdate         u2;
  u2.attribute = "description";
  u2.func      = TBL_SET;
  u2.value     = mDescription;
  uv.push_back(u2);
  MUpdate         u3;
  u3.attribute = "enddate";
  u3.func      = TBL_SET;
  u3.value     = mEndDate;
  uv.push_back(u3);
  MUpdate         u4;
  u4.attribute = "endtime";
  u4.func      = TBL_SET;
  u4.value     = mEndTime;
  uv.push_back(u4);

  db->update( *this, cv, uv);
}
