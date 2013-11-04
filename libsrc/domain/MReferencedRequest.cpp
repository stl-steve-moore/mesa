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

#include "MReferencedRequest.hpp"

MReferencedRequest::MReferencedRequest()
{
  tableName("referencedrequest");
  insert("stuinsuid");
  insert("refsopclass");
  insert("refsopinst");
  insert("accnum");
  insert("reqproccodeval");
  insert("reqproccodemean");
  insert("reqproccodescheme");
  insert("plaordnum");
  insert("filordnum");
  insert("reqproid");
  insert("reqprodesc");
  insert("reqproreason");
  insert("reqprocomment");
  insert("confidentiality");
  insert("reqphys");
  insert("refphys");
  insert("orddate");
  insert("ordtime");
}

MReferencedRequest::MReferencedRequest(const MReferencedRequest& cpy) :
  mStudyInstanceUID( cpy.mStudyInstanceUID),
  mRefSOPClassUID( cpy.mRefSOPClassUID),
  mRefSOPInstanceUID( cpy.mRefSOPInstanceUID),
  mAccessionNumber( cpy.mAccessionNumber),
  mReqProcCodeValue( cpy.mReqProcCodeValue),
  mReqProcCodeMeaning( cpy.mReqProcCodeMeaning),
  mReqProcCodeScheme( cpy.mReqProcCodeScheme),
  mPlacerOrderNumber( cpy.mPlacerOrderNumber),
  mFillerOrderNumber( cpy.mFillerOrderNumber),
  mReqProcID( cpy.mReqProcID),
  mReqProcDescription( cpy.mReqProcDescription),
  mReqProcReason( cpy.mReqProcReason),
  mReqProcComments( cpy.mReqProcComments),
  mConfidentiality( cpy.mConfidentiality),
  mRequestingPhysician( cpy.mRequestingPhysician),
  mReferringPhysician( cpy.mReferringPhysician),
  mOrderDate( cpy.mOrderDate),
  mOrderTime( cpy.mOrderTime)
{
  tableName("referencedrequest");
  insert("stuinsuid", cpy.mStudyInstanceUID);
  insert("refsopclass",  cpy.mRefSOPClassUID);
  insert("refsopinst", cpy.mRefSOPInstanceUID);
  insert("accnum", cpy.mAccessionNumber);
  insert("reqproccodeval", cpy.mReqProcCodeValue);
  insert("reqproccodemean", cpy.mReqProcCodeMeaning);
  insert("reqproccodescheme", cpy.mReqProcCodeScheme);
  insert("plaordnum", cpy.mPlacerOrderNumber);
  insert("filordnum", cpy.mFillerOrderNumber);
  insert("reqproid", cpy.mReqProcID);
  insert("reqprodesc", cpy.mReqProcDescription);
  insert("reqproreason", cpy.mReqProcReason);
  insert("reqprocomment", cpy.mReqProcComments);
  insert("confidentiality", cpy.mConfidentiality);
  insert("reqphys", cpy.mRequestingPhysician);
  insert("refphys", cpy.mReferringPhysician);
  insert("orddate", cpy.mOrderDate);
  insert("ordtime", cpy.mOrderTime);
}

MReferencedRequest::~MReferencedRequest()
{
}

void
MReferencedRequest::printOn(ostream& s) const
{
  s << "MReferencedRequest: \n"
    << "  mStudyInstanceUID: " << mStudyInstanceUID << "\n"
    << "  mRefSOPClassUID: " << mRefSOPClassUID << "\n"
    << "  mRefSOPInstanceUID: " << mRefSOPInstanceUID << "\n"
    << "  mAccessionNumber: " << mAccessionNumber << "\n"
    << "  mReqProcCodeValue: " << mReqProcCodeValue << "\n"
    << "  mReqProcCodeMeaning: " << mReqProcCodeMeaning << "\n"
    << "  mReqProcCodeScheme: " << mReqProcCodeScheme << "\n"
    << "  mPlacerOrderNumber: " << mPlacerOrderNumber << "\n"
    << "  mFillerOrderNumber: " << mFillerOrderNumber << "\n"
    << "  mReqProcID: " << mReqProcID << "\n"
    << "  mReqProcDescription: " << mReqProcDescription << "\n"
    << "  mReqProcReason: " << mReqProcReason << "\n"
    << "  mReqProcComments: " << mReqProcComments << "\n"
    << "  mConfidentiality: " << mConfidentiality << "\n"
    << "  mRequestingPhysician: " << mRequestingPhysician << "\n"
    << "  mReferringPhysician: " << mReferringPhysician << "\n"
    << "  mOrderDate: " << mOrderDate << "\n"
    << "  mOrderTime: " << mOrderTime << "\n";
}


void
MReferencedRequest::streamIn(istream& s)
{
  //s >> this->member;
}

MString MReferencedRequest::studyInstanceUID() const
{
   return mStudyInstanceUID;
}
MString MReferencedRequest::referencedSOPClassUID() const
{
   return mRefSOPClassUID;
}
MString MReferencedRequest::referencedSOPInstanceUID() const
{
   return mRefSOPInstanceUID;
}
MString MReferencedRequest::accessionNumber() const
{
   return mAccessionNumber;
}
MString MReferencedRequest::requestedProcedureCodeValue() const
{
   return mReqProcCodeValue;
}
MString MReferencedRequest::requestedProcedureCodeMeaning() const
{
   return mReqProcCodeMeaning;
}
MString MReferencedRequest::requestedProcedureCodeScheme() const
{
   return mReqProcCodeScheme;
}
MString MReferencedRequest::placerOrderNumber() const
{
   return mPlacerOrderNumber;
}
MString MReferencedRequest::fillerOrderNumber() const
{
   return mFillerOrderNumber;
}
MString MReferencedRequest::requestedProcedureID() const
{
   return mReqProcID;
}
MString MReferencedRequest::requestedProcedureDescription() const
{
   return mReqProcDescription;
}
MString MReferencedRequest::requestedProcedureReason() const
{
   return mReqProcReason;
}
MString MReferencedRequest::requestedProcedureComments() const
{
   return mReqProcComments;
}
MString MReferencedRequest::confidentiality() const
{
   return mConfidentiality;
}
MString MReferencedRequest::requestingPhysician() const
{
   return mRequestingPhysician;
}
MString MReferencedRequest::referringPhysician() const
{
   return mReferringPhysician;
}
MString MReferencedRequest::orderDate() const
{
   return mOrderDate;
}
MString MReferencedRequest::orderTime() const
{
   return mOrderTime;
}


void MReferencedRequest::studyInstanceUID( const MString& s) 
{
   mStudyInstanceUID = s;
   insert("stuinsuid", s);
}
void MReferencedRequest::referencedSOPClassUID( const MString& s) 
{
   mRefSOPClassUID = s;
   insert("refsopclass",  s);
}
void MReferencedRequest::referencedSOPInstanceUID( const MString& s) 
{
   mRefSOPInstanceUID = s;
   insert("refsopinst", s);
}
void MReferencedRequest::accessionNumber( const MString& s) 
{
   mAccessionNumber = s;
   insert("accnum", s);
}
void MReferencedRequest::requestedProcedureCodeValue( const MString& s) 
{
   mReqProcCodeValue = s;
   insert("reqproccodeval", s);
}
void MReferencedRequest::requestedProcedureCodeMeaning( const MString& s) 
{
   mReqProcCodeMeaning = s;
   insert("reqproccodemean", s);
}
void MReferencedRequest::requestedProcedureCodeScheme( const MString& s) 
{
   mReqProcCodeScheme = s;
   insert("reqproccodescheme", s);
}
void MReferencedRequest::placerOrderNumber( const MString& s) 
{
   mPlacerOrderNumber = s;
   insert("plaordnum", s);
}
void MReferencedRequest::fillerOrderNumber( const MString& s) 
{
   mFillerOrderNumber = s;
   insert("filordnum", s);
}
void MReferencedRequest::requestedProcedureID( const MString& s)
{
   mReqProcID = s;
   insert("reqproid", s);
}
void MReferencedRequest::requestedProcedureDescription( const MString& s)
{
   mReqProcDescription = s;
   insert("reqprodesc", s);
}
void MReferencedRequest::requestedProcedureReason( const MString& s)
{
   mReqProcReason = s;
   insert("reqproreason", s);
}
void MReferencedRequest::requestedProcedureComments( const MString& s)
{
   mReqProcComments = s;
   insert("reqprocomment", s);
}
void MReferencedRequest::confidentiality( const MString& s)
{
   mConfidentiality = s;
   insert("confidentiality", s);
}
void MReferencedRequest::requestingPhysician( const MString& s)
{
   mRequestingPhysician = s;
   insert("reqphys", s);
}
void MReferencedRequest::referringPhysician( const MString& s)
{
   mReferringPhysician = s;
   insert("refphys", s);
}
void MReferencedRequest::orderDate( const MString& s)
{
   mOrderDate = s;
   insert("orddate", s);
}
void MReferencedRequest::orderTime( const MString& s)
{
   mOrderTime = s;
   insert("ordtime", s);
}

