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

#include "MGPWorkitem.hpp"

MGPWorkitem::MGPWorkitem()
{
  tableName("gpworkitem");
  insert("sopinsuid");
  insert("sopclassuid");
  insert("status");
  insert("inputavailflag");
  insert("priority");
  insert("procstepid");
  insert("startdattim");
  insert("enddattim");
  insert("resultstuinsuid");
  insert("inputstuinsuid");
  insert("multcopyflag");
  insert("description");
  insert("patientid");
  insert("patientname");
  insert("birthdate");
  insert("sex");
  insert("workitemcodevalue");
  insert("workitemcodescheme");
  insert("workitemcodemeaning");
  insert("reqprocAccessionNum");
  insert("reqprocID");
  insert("reqprocDesc");
  insert("reqprocCodevalue");
  insert("reqprocCodemeaning");
  insert("reqprocCodescheme");
  insert("requestingPhys");
  insert("transactionUID");
}

MGPWorkitem::MGPWorkitem(const MGPWorkitem& cpy) :
  mSOPInstanceUID(cpy.mSOPInstanceUID),
  mSOPClassUID(cpy.mSOPClassUID),
  mStatus(cpy.mStatus),
  mInputAvailabilityFlag(cpy.mInputAvailabilityFlag),
  mPriority(cpy.mPriority),
  mProcedureStepID(cpy.mProcedureStepID),
  mStartDateTime(cpy.mStartDateTime),
  mEndDateTime(cpy.mEndDateTime),
  mResultStudyInstanceUID(cpy.mResultStudyInstanceUID),
  mInputStudyInstanceUID(cpy.mInputStudyInstanceUID),
  mMultipleCopiesFlag(cpy.mMultipleCopiesFlag),
  mDescription(cpy.mDescription),
  mPatientID(cpy.mPatientID),
  mPatientName(cpy.mPatientName),
  mPatientBirthDate(cpy.mPatientBirthDate),
  mPatientSex(cpy.mPatientSex),
  mWorkItemCodeValue(cpy.mWorkItemCodeValue),
  mWorkItemCodeScheme(cpy.mWorkItemCodeScheme),
  mWorkItemCodeMeaning(cpy.mWorkItemCodeMeaning),
  mRequestedProcAccessionNum(cpy.mRequestedProcAccessionNum),
  mRequestedProcID(cpy.mRequestedProcID),
  mRequestedProcDesc(cpy.mRequestedProcDesc),
  mRequestedProcCodevalue(cpy.mRequestedProcCodevalue),
  mRequestedProcCodemeaning(cpy.mRequestedProcCodemeaning),
  mRequestedProcCodescheme(cpy.mRequestedProcCodescheme),
  mRequestingPhysician(cpy.mRequestingPhysician),
  mTransactionUID(cpy.mTransactionUID)
{
  tableName("gpworkitem");
  insert("sopinsuid", mSOPInstanceUID);
  insert("sopclassuid", mSOPClassUID);
  insert("status", mStatus);
  insert("inputavailflag", mInputAvailabilityFlag);
  insert("priority", mPriority);
  insert("procstepid", mProcedureStepID);
  insert("startdattim", mStartDateTime);
  insert("enddattim", mEndDateTime);
  insert("resultstuinsuid", mResultStudyInstanceUID);
  insert("inputstuinsuid", mInputStudyInstanceUID);
  insert("multcopyflag", mMultipleCopiesFlag);
  insert("description", mDescription);
  insert("patientid", mPatientID);
  insert("patientname", mPatientName);
  insert("birthdate", mPatientBirthDate);
  insert("sex", mPatientSex);
  insert("workitemcodevalue", mWorkItemCodeValue);
  insert("workitemcodescheme", mWorkItemCodeScheme);
  insert("workitemcodemeaning", mWorkItemCodeMeaning);
  insert("reqprocAccessionNum", mRequestedProcAccessionNum);
  insert("reqprocID", mRequestedProcID);
  insert("reqprocDesc", mRequestedProcDesc);
  insert("reqprocCodevalue", mRequestedProcCodevalue);
  insert("reqprocCodemeaning", mRequestedProcCodemeaning);
  insert("reqprocCodescheme", mRequestedProcCodescheme);
  insert("requestingPhys", mRequestingPhysician);
  insert("transactionUID", mTransactionUID);
}

MGPWorkitem::~MGPWorkitem()
{
}

void
MGPWorkitem::printOn(ostream& s) const
{
  s << "MGPWorkitem:\n"
    << "  Workitem\n"
    << "    SOPInstanceUID:   " << mSOPInstanceUID << "\n"
    << "    SOPClassUID:      " << mSOPClassUID << "\n"
    << "    status:           " << mStatus << "\n"
    << "    inputavailflag:   " << mInputAvailabilityFlag << "\n"
    << "    priority:         " << mPriority << "\n"
    << "    proc step id:     " << mProcedureStepID << "\n"
    << "    start date/time:  " << mStartDateTime << "\n"
    << "    end date/time:    " << mEndDateTime << "\n"
    << "    result stuUID:    " << mResultStudyInstanceUID << "\n"
    << "    input stuUID:     " << mInputStudyInstanceUID << "\n"
    << "    multcopyflag:     " << mMultipleCopiesFlag << "\n"
    << "    description:      " << mDescription << "\n"
    << "    reqProcAccNum  :  " << mRequestedProcAccessionNum << "\n"
    << "    requestedProcID:  " << mRequestedProcID << "\n"
    << "    requestedProcDesc:" << mRequestedProcDesc << "\n"
    << "    reqProcCodeValue: " << mRequestedProcCodevalue << "\n"
    << "    reqProcCodemean:  " << mRequestedProcCodemeaning << "\n"
    << "    reqProcCodeschem: " << mRequestedProcCodescheme << "\n"
    << "    requestingPhys:   " << mRequestingPhysician << "\n"
    << "    transactionUID:   " << mTransactionUID << "\n"
    << "  Patient\n"
    << "    ID:               " << mPatientID << "\n"
    << "    Name:             " << mPatientName << "\n"
    << "    bday:             " << mPatientBirthDate << "\n"
    << "    sex:              " << mPatientSex << "\n"
    << "  Work Item Code\n"
    << "    value:            " << mWorkItemCodeValue << "\n"
    << "    scheme:           " << mWorkItemCodeScheme << "\n"
    << "    meaning:          " << mWorkItemCodeMeaning;
}

MGPWorkitem::MGPWorkitem(
	const MString& SOPInstanceUID,
	const MString& SOPClassUID,
	const MString& status,
	const MString& inputAvailabilityFlag,
	const MString& priority,
	const MString& procedureStepID,
	const MString& startDateTime,
	const MString& endDateTime,
	const MString& resultStudyInstanceUID,
	const MString& multipleCopiesFlag,
	const MString& description,
	const MString& patientID,
	const MString& patientName,
	const MString& patientBirthDate,
	const MString& patientSex,
	const MString& workItemCodeValue,
	const MString& workItemCodeScheme,
	const MString& workItemCodeMeaning,
	const MString& requestedProcAccessionNum,
	const MString& requestedProcID,
	const MString& requestedProcDesc,
	const MString& requestedProcCodevalue,
	const MString& requestedProcCodemeaning,
	const MString& requestedProcCodescheme,
	const MString& requestingPhysician,
	const MString& transactionUID):
  mSOPInstanceUID(SOPInstanceUID),
  mSOPClassUID(SOPClassUID),
  mStatus(status),
  mInputAvailabilityFlag(inputAvailabilityFlag),
  mPriority(priority),
  mProcedureStepID(procedureStepID),
  mStartDateTime(startDateTime),
  mEndDateTime(endDateTime),
  mResultStudyInstanceUID(resultStudyInstanceUID),
  mMultipleCopiesFlag(multipleCopiesFlag),
  mDescription(description),
  mPatientID(patientID),
  mPatientName(patientName),
  mPatientBirthDate(patientBirthDate),
  mPatientSex(patientSex),
  mWorkItemCodeValue(workItemCodeValue),
  mWorkItemCodeScheme(workItemCodeScheme),
  mWorkItemCodeMeaning(workItemCodeMeaning),
  mRequestedProcAccessionNum(requestedProcAccessionNum),
  mRequestedProcID(requestedProcID),
  mRequestedProcDesc(requestedProcDesc),
  mRequestedProcCodevalue(requestedProcCodevalue),
  mRequestedProcCodemeaning(requestedProcCodemeaning),
  mRequestedProcCodescheme(requestedProcCodescheme),
  mRequestingPhysician(requestingPhysician),
  mTransactionUID(transactionUID)

{
  tableName("gpworkitem");
  insert("sopinsuid", SOPInstanceUID);
  insert("sopclassuid", SOPClassUID);
  insert("status", status);
  insert("inputavailflag", inputAvailabilityFlag);
  insert("priority", priority);
  insert("procstepid", procedureStepID);
  insert("startdattim", startDateTime);
  insert("enddattim", endDateTime);
  insert("resultstuinsuid", resultStudyInstanceUID);
  insert("multcopyflag", multipleCopiesFlag);
  insert("description", description);
  insert("patientid", patientID);
  insert("patientname", patientName);
  insert("birthdate", patientBirthDate);
  insert("sex", patientSex);
  insert("workitemcodevalue", workItemCodeValue);
  insert("workitemcodescheme", workItemCodeScheme);
  insert("workitemcodemeaning", workItemCodeMeaning);
  insert("reqprocAccessionNum", requestedProcAccessionNum);
  insert("reqprocID", requestedProcID);
  insert("reqprocDesc", requestedProcDesc);
  insert("reqprocCodevalue", requestedProcCodevalue);
  insert("reqprocCodemeaning", requestedProcCodemeaning);
  insert("reqprocCodescheme", requestedProcCodescheme);
  insert("requestingPhys", requestingPhysician);
  insert("transactionUID", transactionUID);
}

void
MGPWorkitem::streamIn(istream& s)
{
  //s >> this->member;
}


MString 
MGPWorkitem::SOPInstanceUID() const
{
   return mSOPInstanceUID;
}

MString 
MGPWorkitem::SOPClassUID() const
{
   return mSOPClassUID;
}

MString 
MGPWorkitem::status() const
{
   return mStatus;
}

MString 
MGPWorkitem::inputAvailabilityFlag() const
{
   return mInputAvailabilityFlag;
}

MString 
MGPWorkitem::priority() const
{
   return mPriority;
}

MString 
MGPWorkitem::procedureStepID() const
{
   return mProcedureStepID;
}

MString 
MGPWorkitem::startDateTime() const
{
   return mStartDateTime;
}

MString 
MGPWorkitem::endDateTime() const
{
   return mEndDateTime;
}

MString 
MGPWorkitem::resultStudyInstanceUID() const
{
   return mResultStudyInstanceUID;
}

MString 
MGPWorkitem::inputStudyInstanceUID() const
{
   return mInputStudyInstanceUID;
}

MString 
MGPWorkitem::multipleCopiesFlag() const
{
   return mMultipleCopiesFlag;
}

MString 
MGPWorkitem::description() const
{
   return mDescription;
}

MString 
MGPWorkitem::patientID() const
{
   return mPatientID;
}

MString 
MGPWorkitem::patientName() const
{
   return mPatientName;
}

MString 
MGPWorkitem::patientBirthDate() const
{
   return mPatientBirthDate;
}

MString 
MGPWorkitem::patientSex() const
{
   return mPatientSex;
}

MString 
MGPWorkitem::workItemCodeValue() const
{
   return mWorkItemCodeValue;
}

MString 
MGPWorkitem::workItemCodeScheme() const
{
   return mWorkItemCodeScheme;
}

MString 
MGPWorkitem::workItemCodeMeaning() const
{
   return mWorkItemCodeMeaning;
}

MString 
MGPWorkitem::requestedProcAccessionNum() const 
{
   return mRequestedProcAccessionNum;
}

MString 
MGPWorkitem::requestedProcID() const
{
   return mRequestedProcID;
}

MString 
MGPWorkitem::requestedProcDesc() const
{
   return mRequestedProcDesc;
}

MString 
MGPWorkitem::requestedProcCodevalue() const
{
   return mRequestedProcCodevalue;
}

MString 
MGPWorkitem::requestedProcCodemeaning() const
{
   return mRequestedProcCodemeaning;
}

MString 
MGPWorkitem::requestedProcCodescheme() const
{
   return mRequestedProcCodescheme;
}

MString 
MGPWorkitem::requestingPhysician() const
{
   return mRequestingPhysician;
}

MString 
MGPWorkitem::transactionUID() const
{
   return mTransactionUID;
}


void 
MGPWorkitem::SOPInstanceUID(const MString& s) 
{
   mSOPInstanceUID = s;
   remove("sopinsuid");
   insert("sopinsuid", s);
}

void 
MGPWorkitem::SOPClassUID(const MString& s) 
{
   mSOPClassUID = s;
   remove("sopclassuid");
   insert("sopclassuid", s);
}

void 
MGPWorkitem::status(const MString& s) 
{
   mStatus = s;
   remove("status");
   insert("status", s);
}

void 
MGPWorkitem::inputAvailabilityFlag(const MString& s) 
{
   mInputAvailabilityFlag = s;
   remove("inputavailflag");
   insert("inputavailflag", s);
}

void 
MGPWorkitem::priority(const MString& s) 
{
   mPriority = s;
   remove("priority");
   insert("priority", s);
}

void 
MGPWorkitem::procedureStepID(const MString& s) 
{
   mProcedureStepID = s;
   remove("procstepid");
   insert("procstepid", s);
}

void 
MGPWorkitem::startDateTime(const MString& s) 
{
   mStartDateTime = s;
   remove("startdattim");
   insert("startdattim", s);
}

void 
MGPWorkitem::endDateTime(const MString& s) 
{
   mEndDateTime = s;
   remove("enddattim");
   insert("enddattim", s);
}

void 
MGPWorkitem::resultStudyInstanceUID(const MString& s) 
{
   mResultStudyInstanceUID = s;
   remove("resultstuinsuid");
   insert("resultstuinsuid", s);
}

void 
MGPWorkitem::inputStudyInstanceUID(const MString& s) 
{
   mInputStudyInstanceUID = s;
   remove("inputstuinsuid");
   insert("inputstuinsuid", s);
}

void 
MGPWorkitem::multipleCopiesFlag(const MString& s) 
{
   mMultipleCopiesFlag = s;
   remove("multcopyflag");
   insert("multcopyflag", s);
}

void 
MGPWorkitem::description(const MString& s) 
{
   mDescription = s;
   remove("description");
   insert("description", s);
}

void 
MGPWorkitem::patientID(const MString& s) 
{
   mPatientID = s;
   remove("patientid");
   insert("patientid", s);
}

void 
MGPWorkitem::patientName(const MString& s) 
{
   mPatientName = s;
   remove("patientname");
   insert("patientname", s);
}

void 
MGPWorkitem::patientBirthDate(const MString& s) 
{
   mPatientBirthDate = s;
   remove("birthdate");
   insert("birthdate", s);
}

void 
MGPWorkitem::patientSex(const MString& s) 
{
   mPatientSex = s;
   remove("sex");
   insert("sex", s);
}

void 
MGPWorkitem::workItemCodeValue(const MString& s) 
{
   mWorkItemCodeValue = s;
   remove("workitemcodevalue");
   insert("workitemcodevalue", s);
}

void 
MGPWorkitem::workItemCodeScheme(const MString& s) 
{
   mWorkItemCodeScheme = s;
   remove("workitemcodescheme");
   insert("workitemcodescheme", s);
}

void 
MGPWorkitem::workItemCodeMeaning(const MString& s) 
{
   mWorkItemCodeMeaning = s;
   remove("workitemcodemeaning");
   insert("workitemcodemeaning", s);
}

void 
MGPWorkitem::requestedProcAccessionNum(const MString& s) 
{
   mRequestedProcAccessionNum = s;
   remove("reqprocAccessionNum");
   insert("reqprocAccessionNum", s);
}

void 
MGPWorkitem::requestedProcID(const MString& s) 
{
   mRequestedProcID = s;
   remove("reqprocID");
   insert("reqprocID", s);
}

void 
MGPWorkitem::requestedProcDesc(const MString& s) 
{
   mRequestedProcDesc = s;
   remove("reqprocDesc");
   insert("reqprocDesc", s);
}

void 
MGPWorkitem::requestedProcCodevalue(const MString& s) 
{
   mRequestedProcCodevalue = s;
   remove("reqprocCodevalue");
   insert("reqprocCodevalue", s);
}

void 
MGPWorkitem::requestedProcCodemeaning(const MString& s) 
{
   mRequestedProcCodemeaning = s;
   remove("reqprocCodemeaning");
   insert("reqprocCodemeaning", s);
}

void 
MGPWorkitem::requestedProcCodescheme(const MString& s) 
{
   mRequestedProcCodescheme = s;
   remove("reqprocCodescheme");
   insert("reqprocCodescheme", s);
}

void 
MGPWorkitem::requestingPhysician(const MString& s) 
{
   mRequestingPhysician = s;
   remove("requestingPhys");
   insert("requestingPhys", s);
}

void 
MGPWorkitem::transactionUID(const MString& s) 
{
   mTransactionUID = s;
   remove("transactionUID");
   insert("transactionUID", s);
}


void MGPWorkitem::import(const MDomainObject& o)
{
  SOPInstanceUID(o.value("sopinsuid")); 
  SOPClassUID(o.value("sopclassuid")); 
  status(o.value("status")); 
  inputAvailabilityFlag(o.value("inputavailflag")); 
  priority(o.value("priority")); 
  procedureStepID(o.value("procstepid")); 
  startDateTime(o.value("startdattim")); 
  endDateTime(o.value("enddattim")); 
  resultStudyInstanceUID(o.value("resultstuinsuid")); 
  inputStudyInstanceUID(o.value("inputstuinsuid")); 
  multipleCopiesFlag(o.value("multcopyflag")); 
  description(o.value("description")); 
  patientID(o.value("patientid")); 
  patientName(o.value("patientname")); 
  patientBirthDate(o.value("birthdate")); 
  patientSex(o.value("sex")); 
  workItemCodeValue(o.value("workitemcodevalue")); 
  workItemCodeScheme(o.value("workitemcodescheme")); 
  workItemCodeMeaning(o.value("workitemcodemeaning")); 
  requestedProcAccessionNum(o.value("reqprocAccessionNum"));
  requestedProcID(o.value("reqprocID"));
  requestedProcDesc(o.value("reqprocDesc"));
  requestedProcCodevalue(o.value("reqprocCodevalue"));
  requestedProcCodemeaning(o.value("reqprocCodemeaning"));
  requestedProcCodescheme(o.value("reqprocCodescheme"));
  requestingPhysician(o.value("requestingPhys"));
  transactionUID(o.value("transactionUID"));
}
