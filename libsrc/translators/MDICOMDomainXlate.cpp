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

#include "MDICOMDomainXlate.hpp"
#include "MString.hpp"

#include "MDICOMWrapper.hpp"
#include "MDomainObject.hpp"
#include "MPatient.hpp"
#include "MVisit.hpp"
#include "MPlacerOrder.hpp"
#include "MFillerOrder.hpp"
#include "MOrder.hpp"
#include "MStudy.hpp"
#include "MSeries.hpp"
#include "MSOPInstance.hpp"
#include "MPatientStudy.hpp"
#include "MSPS.hpp"
#include "MMWL.hpp"
#include "MUPS.hpp"
#include "MStorageCommitRequest.hpp"
#include "MStorageCommitResponse.hpp"
#include "MDICOMFileMeta.hpp"
#include "MDICOMDir.hpp"
#include "MGPWorkitem.hpp"
#include "MGPPPSWorkitem.hpp"
#include "MStationName.hpp"
#include "MLogClient.hpp"

MDICOMDomainXlate::MDICOMDomainXlate()
{
}

MDICOMDomainXlate::MDICOMDomainXlate(const MDICOMDomainXlate& cpy)
{
}

MDICOMDomainXlate::~MDICOMDomainXlate()
{
}

void
MDICOMDomainXlate::printOn(ostream& s) const
{
  s << "MDICOMDomainXlate";
}

void
MDICOMDomainXlate::streamIn(istream& s)
{
  //s >> this->member;
}

// Non-boilerplate methods to follow



int
MDICOMDomainXlate::translateDICOM(MDICOMWrapper& dcm, MPatient& patient) const
{
  DICOM_MAP m[] = {
    { "patid",  DCM_PATID },
    { "issuer",  DCM_MAKETAG(0x0010, 0x0021)},
    { "nam", DCM_PATNAME },
    { "datbir", DCM_PATBIRTHDATE },
    { "sex", DCM_PATSEX },
#if 0
    { "issuer", "PID",  2, 4 },
    { "patid2",  "PID",  3, 1 },
    { "issuer2", "PID",  3, 4 },
    { "nam",     "PID",  5, 0 },
    { "datbir",     "PID",  7, 0 },
    { "sex",     "PID",  8, 0 },
    { "race",    "PID",  9, 0 },
    { "addr",    "PID", 10, 0 },
    { "acctnum", "PID", 18, 1 },
#endif

    { "", 0 }
  };
  MDomainObject domainObject;

  this->translateDICOM(dcm, m, domainObject);
  patient.import(domainObject);

  return 0;
}

int
MDICOMDomainXlate::translateDICOM(MDICOMWrapper& dcm, MMWL& mwl) const
{
  //**NOTE**
  //it may turn out that only matching keys
  //are translated

    DICOM_MAP m[] = {
    
    //Patient
    { "patid",  DCM_PATID },
    { "nam", DCM_PATNAME },
    { "datbir", DCM_PATBIRTHDATE },
    { "sex", DCM_PATSEX },
    { "issuer", DCM_ISSUERPATIENTID },
    
    //Requested Procedure
    { "reqproid", DCM_PRCREQUESTEDPROCEDUREID },
    { "stuinsuid", DCM_RELSTUDYINSTANCEUID },
    //{ "filordnum", SOMETHING_HERE },
    { "accnum", DCM_IDACCESSIONNUMBER },
    { "quatim", DCM_PRCREQUESTEDPROCPRIORITY },
    { "reqprodes", DCM_SDYREQUESTEDPRODESCRIPTION },

    //Scheduled Procedure Step
    { "spsid", DCM_PRCSCHEDULEDPROCSTEPID },
    { "schaet", DCM_PRCSCHEDULEDSTATIONAETITLE },
    { "spsstadat", DCM_PRCSCHEDULEDPROCSTEPSTARTDATE },
    { "spsstatim", DCM_PRCSCHEDULEDPROCSTEPSTARTTIME },
    { "mod", DCM_IDMODALITY },
    { "schperphynam", DCM_PRCSCHEDULEDPERFORMINGPHYSNAME },
    { "spsdes", DCM_PRCSCHEDULEDPROCSTEPDESCRIPTION },
    { "schstanam", DCM_PRCSCHEDULEDSTATIONNAME },
    { "spsloc", DCM_PRCSCHEDULEDPROCSTEPLOCATION },
    { "premed", DCM_PRCPREMEDICATION },
    {"", 0}
    };
    MDomainObject domainObject;
    this->translateDICOM(dcm, m, domainObject);
  return 0;
}

int
MDICOMDomainXlate::translateDICOM(MDICOMWrapper& dcm, MUPS& ups) const
{
  //**NOTE**
  //it may turn out that only matching keys
  //are translated

    DICOM_MAP m[] = {
    //SOP Common
    { "specharset",  0x00080005},
    { "sopclauid",  0x00080016},
    { "sopinsuid",  0x00080018},

    // Unified Procedure Step Scheduled Procedure Information
    { "spspri",  0x00741200},
    { "spsmoddattim",  0x00404010},
    { "prostelbl",  0x00741204},
    { "worlbl",  0x00741202},
    { "spsstadattim",  0x00404005},
    { "expcomdattim",  0x00404011},
    { "stuinsuid", DCM_RELSTUDYINSTANCEUID },

    // Unified Procedure Step Relationship Module
    { "nam", DCM_PATNAME },
    { "patid",  DCM_PATID },
    { "issuer", DCM_ISSUERPATIENTID },
    { "datbir", DCM_PATBIRTHDATE },
    { "sex", DCM_PATSEX },
    { "admid", 0x00380010},
    { "issueradmid", 0x00380011},
    { "admdiagdes",  0x00081080},
    { "upsstate",  0x00741000},
    
    //Patient
    
    //Requested Procedure
    { "reqproid", DCM_PRCREQUESTEDPROCEDUREID },
    //{ "filordnum", SOMETHING_HERE },
    { "accnum", DCM_IDACCESSIONNUMBER },
    { "quatim", DCM_PRCREQUESTEDPROCPRIORITY },
    { "reqprodes", DCM_SDYREQUESTEDPRODESCRIPTION },

    //Scheduled Procedure Step
    { "spsid", DCM_PRCSCHEDULEDPROCSTEPID },
    { "schaet", DCM_PRCSCHEDULEDSTATIONAETITLE },
    { "spsstadat", DCM_PRCSCHEDULEDPROCSTEPSTARTDATE },
    { "spsstatim", DCM_PRCSCHEDULEDPROCSTEPSTARTTIME },
    { "mod", DCM_IDMODALITY },
    { "schperphynam", DCM_PRCSCHEDULEDPERFORMINGPHYSNAME },
    { "spsdes", DCM_PRCSCHEDULEDPROCSTEPDESCRIPTION },
    { "schstanam", DCM_PRCSCHEDULEDSTATIONNAME },
    { "spsloc", DCM_PRCSCHEDULEDPROCSTEPLOCATION },
    { "premed", DCM_PRCPREMEDICATION },
    {"", 0}
    };
    MDomainObject domainObject;
    this->translateDICOM(dcm, m, domainObject);
  return 0;
}

int
MDICOMDomainXlate::translateDICOM(MDICOMWrapper& dcm, MGPWorkitem& gpwi) const
{
    DICOM_MAP m[] = {
      { "sopinsuid",  DCM_IDSOPINSTANCEUID }, 
      { "sopclassuid",  DCM_IDSOPCLASSUID },
      { "status",  DCM_PRCGPSPSSTATUS },
      { "inputavailflag",  DCM_PRCINPUTAVAILFLAG },
      { "priority",  DCM_PRCGPSPSPRIORITY },
      { "procstepid",  DCM_PRCSCHEDULEDPROCSTEPID },
      { "startdattim",  DCM_PRCGPSPSSTARTDATETIME },
      { "enddattim",  DCM_PRCGPSPSEXPECTEDCOMPLETEDATETIME },
      { "resultstuinsuid",  DCM_RELSTUDYINSTANCEUID },
      { "multcopyflag",  DCM_PRCGPSPSMULTIPLECOPIESFLAG },
      //{ "description",  DCM_ },
      { "patientid",  DCM_PATID },
      { "patientname",  DCM_PATNAME },
      { "birthdate",  DCM_PATBIRTHDATE },
      { "sex",  DCM_PATSEX },
      { "transactionUID",  DCM_IDTRANSACTIONUID },
      {"", 0}
    };
    MDomainObject domainObject;

  /* note this is the referenced Request sequence though it seems to be named
     referenced document sequenced in dicom_objects.h
  */
  DICOM_SEQMAP refreq_map[] = {
    {"reqprocDesc",        0x0040A370, DCM_SDYREQUESTEDPRODESCRIPTION},
    {"reqprocAccessionNum",0x0040A370, DCM_IDACCESSIONNUMBER},
    {"reqprocID",          0x0040A370, DCM_PRCREQUESTEDPROCEDUREID },
    {"requestingPhys",     0x0040A370, DCM_SDYREQUESTINGPHYSICIAN},
    { "", 0, 0 }
  };

  this->translateDICOM(dcm, m, domainObject);
  this->translateDICOM(dcm, refreq_map, domainObject);
  gpwi.import(domainObject);
  return 0;
}

int
MDICOMDomainXlate::translateDICOM(MDICOMWrapper& dcm,MGPPPSObject& pps) const
{
   MGPPPSWorkitem wi;
   translateDICOM( dcm, wi);
   pps.workitem(wi );

   MActHumanPerformersVector ahp;
   translateDICOM( dcm, ahp);
   pps.actualHumanPerformersVector(ahp);

   MPerfStationNameVector psn;
   translateDICOM( dcm, psn);
   pps.performedStationNameVector(psn);

   MPerfStationClassVector psc;
   translateDICOM( dcm, psc);
   pps.performedStationClassVector(psc);

   MPerfStationLocationVector psl;
   translateDICOM( dcm, psl);
   pps.performedStationLocationVector(psl);

   MPerfProcAppsVector ppa;
   translateDICOM( dcm, ppa);
   pps.performedProcAppsVector(ppa);

   MPerfWorkitemVector pw;
   translateDICOM( dcm, pw);
   pps.performedWorkitemVector(pw);

   MReqSubsWorkitemVector rsw;
   translateDICOM( dcm, rsw);
   pps.reqSubsWorkitemVector(rsw);

   MNonDCMOutputVector ndo;
   translateDICOM( dcm, ndo);
   pps.nonDCMOutputVector(ndo);

   MOutputInfoVector oi;
   translateDICOM( dcm, oi);
   pps.outputInfoVector(oi);

   MRefGPSPSVector sps;
   translateDICOM( dcm, sps);
   pps.refGPSPSVector(sps);

   return 0;
}

int
MDICOMDomainXlate::translateDICOM(MDICOMWrapper& dcm,MGPPPSWorkitem& gpwi) const
{
    DICOM_MAP m[] = {
      { "sopinsuid",  DCM_IDSOPINSTANCEUID },
      //{ "sopclassuid",  DCM_IDSOPCLASSUID },
      { "patientid",  DCM_PATID },
      { "patientname",  DCM_PATNAME },
      { "birthdate",  DCM_PATBIRTHDATE },
      { "sex",  DCM_PATSEX },
      { "procstepid", DCM_PRCPPSID }, 
      { "status",  DCM_PRCGPPPSSTATUS },
      { "startdate",  DCM_PRCPPSSTARTDATE },
      { "starttime",  DCM_PRCPPSSTARTTIME },
      { "enddate",  DCM_PRCPPSENDDATE },
      { "endtime", DCM_PRCPPSENDTIME },
      { "description",  DCM_PRCPPSDESCRIPTION },
      {"", 0}
    };
    MDomainObject domainObject;

  // note this is the referenced Request sequence though it seems to be named
  // referenced document sequence in dicom_objects.h
  DICOM_MAP m2[] = {
    {"reqprocDesc",DCM_SDYREQUESTEDPRODESCRIPTION},
    {"reqprocAccessionNum",DCM_IDACCESSIONNUMBER},
    {"reqprocID", DCM_PRCREQUESTEDPROCEDUREID },
    { "", 0 }
  };

  DICOM_MAP m3[] = {
    {"reqprocCodevalue",0x00080100},
    {"reqprocCodemeaning",0x00080104},
    {"reqprocCodescheme", 0x00080102 },
    { "", 0 }
  };

  this->translateDICOM(dcm, m, domainObject);
  MDICOMWrapper *w = dcm.getSequenceWrapper(0x0040a370,1);
  if( w != 0) {
     this->translateDICOM(*w, m2, domainObject);
     w = w->getSequenceWrapper(0x00321064,1);
     if( w != 0) {
        this->translateDICOM(*w, m3, domainObject);
     }
  }

  gpwi.import(domainObject);
  return 0;
}

int
MDICOMDomainXlate::translateDICOM(MDICOMWrapper& dcm,
				  MStationNameVector& snv) const
{
  MDomainObject domainObject;

  DCM_OBJECT* obj = dcm.getNativeObject();

  LST_HEAD* l1;
  CONDITION cond;

  cond = ::DCM_GetSequenceList(&obj, DCM_PRCSCHEDSTATIONNAMECODESEQ, &l1);

  if (cond != DCM_NORMAL) {
    ::COND_PopCondition(TRUE);
    return 0;
  }

  DCM_SEQUENCE_ITEM* item;
  item = (DCM_SEQUENCE_ITEM*) ::LST_Head(&l1);
  if (item == 0)
    return 0;

  (void) ::LST_Position(&l1, item);

  DICOM_MAP m[] = {
    { "codval", DCM_IDCODEVALUE},
    { "codschdes",  DCM_IDCODINGSCHEMEDESIGNATOR},
    { "codmea", DCM_IDCODEMEANING},
    { "", 0}
  };

  while (item != NULL) {
    MDICOMWrapper w(item->object);
    MStationName sn;
    MDomainObject domainObject;
    this->translateDICOM(w, m, domainObject);
    sn.import(domainObject);
    snv.push_back(sn);
    item = (DCM_SEQUENCE_ITEM*)LST_Next(&l1);
  }
  return 0;
}

int
MDICOMDomainXlate::translateDICOM(MDICOMWrapper& dcm,
                                  MPerfStationNameVector& v) const
{
  MDomainObject domainObject;

  DCM_OBJECT* obj = dcm.getNativeObject();

  LST_HEAD* l1;
  CONDITION cond;

  cond = ::DCM_GetSequenceList(&obj, DCM_PRCPERFORMEDSTATIONNAMECODESEQ, &l1);

  if (cond != DCM_NORMAL) {
    ::COND_PopCondition(TRUE);
    return 0;
  }

  DCM_SEQUENCE_ITEM* item;
  item = (DCM_SEQUENCE_ITEM*) ::LST_Head(&l1);
  if (item == 0)
    return 0;

  (void) ::LST_Position(&l1, item);

  DICOM_MAP m[] = {
    { "codval", DCM_IDCODEVALUE},
    { "codschdes",  DCM_IDCODINGSCHEMEDESIGNATOR},
    { "codmea", DCM_IDCODEMEANING},
    { "", 0}
  };

  while (item != NULL) {
    MDICOMWrapper w(item->object);
    MPerfStationName sn;
    MDomainObject domainObject;
    this->translateDICOM(w, m, domainObject);
    sn.import(domainObject);
    v.push_back(sn);
    item = (DCM_SEQUENCE_ITEM*)LST_Next(&l1);
  }
  return 0;
}

int
MDICOMDomainXlate::translateDICOM(MDICOMWrapper& dcm,
                                  MStationClassVector& scv) const
{
  MDomainObject domainObject;

  DCM_OBJECT* obj = dcm.getNativeObject();

  LST_HEAD* l1;
  CONDITION cond;

  cond = ::DCM_GetSequenceList(&obj, DCM_PRCSCHEDSTATIONCLASSCODESEQ, &l1);

  if (cond != DCM_NORMAL) {
    ::COND_PopCondition(TRUE);
    return 0;
  }

  DCM_SEQUENCE_ITEM* item;
  item = (DCM_SEQUENCE_ITEM*) ::LST_Head(&l1);
  if (item == 0)
    return 0;

  (void) ::LST_Position(&l1, item);

  DICOM_MAP m[] = {
    { "codval", DCM_IDCODEVALUE},
    { "codschdes",  DCM_IDCODINGSCHEMEDESIGNATOR},
    { "codmea", DCM_IDCODEMEANING},
    { "", 0}
  };

  while (item != NULL) {
    MDICOMWrapper w(item->object);
    MStationClass sc;
    MDomainObject domainObject;
    this->translateDICOM(w, m, domainObject);
    sc.import(domainObject);
    scv.push_back(sc);
    item = (DCM_SEQUENCE_ITEM*)LST_Next(&l1);
  }
  return 0;
}

int
MDICOMDomainXlate::translateDICOM(MDICOMWrapper& dcm,
                                  MPerfStationClassVector& scv) const
{
  MDomainObject domainObject;

  DCM_OBJECT* obj = dcm.getNativeObject();

  LST_HEAD* l1;
  CONDITION cond;

  cond = ::DCM_GetSequenceList(&obj, DCM_PRCPERFORMEDSTATIONCLASSCODESEQ, &l1);

  if (cond != DCM_NORMAL) {
    ::COND_PopCondition(TRUE);
    return 0;
  }

  DCM_SEQUENCE_ITEM* item;
  item = (DCM_SEQUENCE_ITEM*) ::LST_Head(&l1);
  if (item == 0)
    return 0;

  (void) ::LST_Position(&l1, item);

  DICOM_MAP m[] = {
    { "codval", DCM_IDCODEVALUE},
    { "codschdes",  DCM_IDCODINGSCHEMEDESIGNATOR},
    { "codmea", DCM_IDCODEMEANING},
    { "", 0}
  };

  while (item != NULL) {
    MDICOMWrapper w(item->object);
    MPerfStationClass sc;
    MDomainObject domainObject;
    this->translateDICOM(w, m, domainObject);
    sc.import(domainObject);
    scv.push_back(sc);
    item = (DCM_SEQUENCE_ITEM*)LST_Next(&l1);
  }
  return 0;
}

int
MDICOMDomainXlate::translateDICOM(MDICOMWrapper& dcm,
                                  MStationLocationVector& v) const
{
  MDomainObject domainObject;

  DCM_OBJECT* obj = dcm.getNativeObject();

  LST_HEAD* l1;
  CONDITION cond;

  cond = ::DCM_GetSequenceList(&obj, DCM_PRCSCHEDSTATIONLOCCODESEQ, &l1);

  if (cond != DCM_NORMAL) {
    ::COND_PopCondition(TRUE);
    return 0;
  }

  DCM_SEQUENCE_ITEM* item;
  item = (DCM_SEQUENCE_ITEM*) ::LST_Head(&l1);
  if (item == 0)
    return 0;

  (void) ::LST_Position(&l1, item);

  DICOM_MAP m[] = {
    { "codval", DCM_IDCODEVALUE},
    { "codschdes",  DCM_IDCODINGSCHEMEDESIGNATOR},
    { "codmea", DCM_IDCODEMEANING},
    { "", 0}
  };

  while (item != NULL) {
    MDICOMWrapper w(item->object);
    MStationLocation sl;
    MDomainObject domainObject;
    this->translateDICOM(w, m, domainObject);
    sl.import(domainObject);
    v.push_back(sl);
    item = (DCM_SEQUENCE_ITEM*)LST_Next(&l1);
  }
  return 0;
}

int
MDICOMDomainXlate::translateDICOM(MDICOMWrapper& dcm,
                                  MPerfStationLocationVector& v) const
{
  MDomainObject domainObject;

  DCM_OBJECT* obj = dcm.getNativeObject();

  LST_HEAD* l1;
  CONDITION cond;

  cond = ::DCM_GetSequenceList(&obj, DCM_PRCPERFORMEDSTATIONLOCCODESEQ, &l1);

  if (cond != DCM_NORMAL) {
    ::COND_PopCondition(TRUE);
    return 0;
  }

  DCM_SEQUENCE_ITEM* item;
  item = (DCM_SEQUENCE_ITEM*) ::LST_Head(&l1);
  if (item == 0)
    return 0;

  (void) ::LST_Position(&l1, item);

  DICOM_MAP m[] = {
    { "codval", DCM_IDCODEVALUE},
    { "codschdes",  DCM_IDCODINGSCHEMEDESIGNATOR},
    { "codmea", DCM_IDCODEMEANING},
    { "", 0}
  };

  while (item != NULL) {
    MDICOMWrapper w(item->object);
    MPerfStationLocation sl;
    MDomainObject domainObject;
    this->translateDICOM(w, m, domainObject);
    sl.import(domainObject);
    v.push_back(sl);
    item = (DCM_SEQUENCE_ITEM*)LST_Next(&l1);
  }
  return 0;
}

int
MDICOMDomainXlate::translateDICOM(MDICOMWrapper& dcm,
                                  MPerfProcAppsVector& v) const
{
  MDomainObject domainObject;

  DCM_OBJECT* obj = dcm.getNativeObject();

  LST_HEAD* l1;
  CONDITION cond;

  cond = ::DCM_GetSequenceList(&obj, DCM_PRCPERFORMEDPROCAPPCODESEQ, &l1);

  if (cond != DCM_NORMAL) {
    ::COND_PopCondition(TRUE);
    return 0;
  }

  DCM_SEQUENCE_ITEM* item;
  item = (DCM_SEQUENCE_ITEM*) ::LST_Head(&l1);
  if (item == 0)
    return 0;

  (void) ::LST_Position(&l1, item);

  DICOM_MAP m[] = {
    { "codval", DCM_IDCODEVALUE},
    { "codschdes",  DCM_IDCODINGSCHEMEDESIGNATOR},
    { "codmea", DCM_IDCODEMEANING},
    { "", 0}
  };

  while (item != NULL) {
    MDICOMWrapper w(item->object);
    MPerfProcApps app;
    MDomainObject domainObject;
    this->translateDICOM(w, m, domainObject);
    app.import(domainObject);
    v.push_back(app);
    item = (DCM_SEQUENCE_ITEM*)LST_Next(&l1);
  }
  return 0;
}

int
MDICOMDomainXlate::translateDICOM(MDICOMWrapper& dcm,
                                  MPerfWorkitemVector& v) const
{
  MDomainObject domainObject;

  DCM_OBJECT* obj = dcm.getNativeObject();

  LST_HEAD* l1;
  CONDITION cond;

  cond = ::DCM_GetSequenceList(&obj, DCM_PRCPERFORMEDWORKITEMCODESEQ, &l1);

  if (cond != DCM_NORMAL) {
    ::COND_PopCondition(TRUE);
    return 0;
  }

  DCM_SEQUENCE_ITEM* item;
  item = (DCM_SEQUENCE_ITEM*) ::LST_Head(&l1);
  if (item == 0)
    return 0;

  (void) ::LST_Position(&l1, item);

  DICOM_MAP m[] = {
    { "codval", DCM_IDCODEVALUE},
    { "codschdes",  DCM_IDCODINGSCHEMEDESIGNATOR},
    { "codmea", DCM_IDCODEMEANING},
    { "", 0}
  };

  while (item != NULL) {
    MDICOMWrapper w(item->object);
    MPerfWorkitem wi;
    MDomainObject domainObject;
    this->translateDICOM(w, m, domainObject);
    wi.import(domainObject);
    v.push_back(wi);
    item = (DCM_SEQUENCE_ITEM*)LST_Next(&l1);
  }
  return 0;
}

int
MDICOMDomainXlate::translateDICOM(MDICOMWrapper& dcm,
                                  MReqSubsWorkitemVector& v) const
{
  MDomainObject domainObject;

  DCM_OBJECT* obj = dcm.getNativeObject();

  LST_HEAD* l1;
  CONDITION cond;

  cond = ::DCM_GetSequenceList(&obj, DCM_PRCREQSUBSWORKITEMCODESEQ, &l1);

  if (cond != DCM_NORMAL) {
    ::COND_PopCondition(TRUE);
    return 0;
  }

  DCM_SEQUENCE_ITEM* item;
  item = (DCM_SEQUENCE_ITEM*) ::LST_Head(&l1);
  if (item == 0)
    return 0;

  (void) ::LST_Position(&l1, item);

  DICOM_MAP m[] = {
    { "codval", DCM_IDCODEVALUE},
    { "codschdes",  DCM_IDCODINGSCHEMEDESIGNATOR},
    { "codmea", DCM_IDCODEMEANING},
    { "", 0}
  };

  while (item != NULL) {
    MDICOMWrapper w(item->object);
    MReqSubsWorkitem wi;
    MDomainObject domainObject;
    this->translateDICOM(w, m, domainObject);
    wi.import(domainObject);
    v.push_back(wi);
    item = (DCM_SEQUENCE_ITEM*)LST_Next(&l1);
  }
  return 0;
}

int
MDICOMDomainXlate::translateDICOM(MDICOMWrapper& dcm,
                                  MRefGPSPSVector& v) const
{
  MDomainObject domainObject;

  DCM_OBJECT* obj = dcm.getNativeObject();

  LST_HEAD* l1;
  CONDITION cond;

  cond = ::DCM_GetSequenceList(&obj, DCM_PRCREFERENCEDGPSCHEDPROCSTEPSEQ, &l1);

  if (cond != DCM_NORMAL) {
    ::COND_PopCondition(TRUE);
    return 0;
  }

  DCM_SEQUENCE_ITEM* item;
  item = (DCM_SEQUENCE_ITEM*) ::LST_Head(&l1);
  if (item == 0)
    return 0;

  (void) ::LST_Position(&l1, item);

  DICOM_MAP m[] = {
    { "sopclassuid", DCM_IDREFERENCEDSOPCLASSUID},
    { "sopinstanceuid",  DCM_IDREFERENCEDSOPINSTUID},
    { "transactionuid", DCM_PRCREFERENCEDGPSPSTRANSACTIONUID},
    { "", 0}
  };

  while (item != NULL) {
    MDICOMWrapper w(item->object);
    MRefGPSPS o;
    MDomainObject domainObject;
    this->translateDICOM(w, m, domainObject);
    o.import(domainObject);
    v.push_back(o);
    item = (DCM_SEQUENCE_ITEM*)LST_Next(&l1);
  }
  return 0;
}

int
MDICOMDomainXlate::translateDICOM(MDICOMWrapper& dcm,
                                  MNonDCMOutputVector& v) const
{
  MDomainObject domainObject;

  DCM_OBJECT* obj = dcm.getNativeObject();

  LST_HEAD* l1;
  CONDITION cond;

  cond = ::DCM_GetSequenceList(&obj, DCM_PRCNONDICOMOUTPUTCODESEQ, &l1);

  if (cond != DCM_NORMAL) {
    ::COND_PopCondition(TRUE);
    return 0;
  }

  DCM_SEQUENCE_ITEM* item;
  item = (DCM_SEQUENCE_ITEM*) ::LST_Head(&l1);
  if (item == 0)
    return 0;

  (void) ::LST_Position(&l1, item);

  DICOM_MAP m[] = {
    { "codval", DCM_IDCODEVALUE},
    { "codschdes",  DCM_IDCODINGSCHEMEDESIGNATOR},
    { "codmea", DCM_IDCODEMEANING},
    { "", 0}
  };

  while (item != NULL) {
    MDICOMWrapper w(item->object);
    MNonDCMOutput o;
    MDomainObject domainObject;
    this->translateDICOM(w, m, domainObject);
    o.import(domainObject);
    v.push_back(o);
    item = (DCM_SEQUENCE_ITEM*)LST_Next(&l1);
  }
  return 0;
}

int
MDICOMDomainXlate::translateDICOM(MDICOMWrapper& dcm,
                                  MActHumanPerformersVector& ahpv) const
{
  MDomainObject domainObject;

  DICOM_MAP m[] = {
    { "codval", DCM_IDCODEVALUE},
    { "codschdes",  DCM_IDCODINGSCHEMEDESIGNATOR},
    { "codmea", DCM_IDCODEMEANING},
    { "", 0}
  };

  DCM_OBJECT* obj = dcm.getNativeObject();

  LST_HEAD* l1;
  LST_HEAD* l2;
  CONDITION cond;

  cond = ::DCM_GetSequenceList(&obj, DCM_PRCACTUALHUMANPERFORMERSSEQ, &l1);

  if (cond != DCM_NORMAL) {
    ::COND_PopCondition(TRUE);
    return 0;
  }

  int n = 1;
  MDICOMWrapper *w_hpc;
  while( (w_hpc = dcm.getSequenceWrapper(DCM_PRCACTUALHUMANPERFORMERSSEQ,n)) != 0) {
    n++;
    MActHumanPerformers ahp;
    MDICOMWrapper *w =w_hpc->getSequenceWrapper(DCM_PRCHUMANPERFORMERCODESEQ,1);
    if( w != 0) {
       MDomainObject domainObject;
       this->translateDICOM(*w, m, domainObject);
       ahp.import(domainObject);
       ahpv.push_back(ahp);
    }
  }
  return 0;
}

int
MDICOMDomainXlate::translateDICOM(MDICOMWrapper& dcm,
                                  MOutputInfoVector& v) const
{
  MDomainObject domainObject;

  DICOM_MAP m1[] = {
    { "studyinsuid", DCM_RELSTUDYINSTANCEUID},
    { "", 0}
  };

  DICOM_MAP m2[] = {
    { "seriesinsuid", DCM_RELSERIESINSTANCEUID},
    { "retrieveAEtitle", DCM_IDRETRIEVEAETITLE},
    { "", 0}
  };

  DICOM_MAP m3[] = {
    { "sopclassuid", DCM_IDREFERENCEDSOPCLASSUID},
    { "sopinsuid",  DCM_IDREFERENCEDSOPINSTUID},
    { "", 0}
  };

  DCM_OBJECT* obj = dcm.getNativeObject();

  LST_HEAD* l1;
  LST_HEAD* l2;
  LST_HEAD* l3;
  CONDITION cond;

  cond = ::DCM_GetSequenceList(&obj, DCM_PRCOUTPUTINFOSEQ, &l1);

  if (cond != DCM_NORMAL) {
    ::COND_PopCondition(TRUE);
    return 0;
  }

  DCM_SEQUENCE_ITEM* item1 = (DCM_SEQUENCE_ITEM*) ::LST_Head(&l1);
  (void) ::LST_Position(&l1, item1);
  while( item1 != NULL) {

    cond = ::DCM_GetSequenceList(&item1->object,
                                 DCM_IDREFERENCEDSERIESSEQ, &l2);

    if (cond != DCM_NORMAL) {
      ::COND_PopCondition(TRUE);
      return 0;
    }

    MDICOMWrapper w1(item1->object);

    DCM_SEQUENCE_ITEM* item2 = (DCM_SEQUENCE_ITEM*) ::LST_Head(&l2);
    (void) ::LST_Position(&l2, item2);
    while( item2 != NULL) {

      cond = ::DCM_GetSequenceList(&item2->object,
                                 DCM_IDREFERENCEDSOPSEQUENCE, &l3);

      if (cond != DCM_NORMAL) {
        ::COND_PopCondition(TRUE);
        return 0;
      }

      MDICOMWrapper w2(item2->object);

      DCM_SEQUENCE_ITEM* item3 = (DCM_SEQUENCE_ITEM*) ::LST_Head(&l3);
      (void) ::LST_Position(&l3, item3);
      while (item3 != NULL) {
        MDICOMWrapper w3(item3->object);
        MOutputInfo oi;
        MDomainObject domainObject;
        this->translateDICOM(w1, m1, domainObject);
        this->translateDICOM(w2, m2, domainObject);
        this->translateDICOM(w3, m3, domainObject);
        oi.import(domainObject);
        v.push_back(oi);
        item3 = (DCM_SEQUENCE_ITEM*)LST_Next(&l3);
      }
      item2 = (DCM_SEQUENCE_ITEM*)LST_Next(&l2);
    }
    item1 = (DCM_SEQUENCE_ITEM*)LST_Next(&l1);
  }
  return 0;
}

int
MDICOMDomainXlate::translateDICOM(MDICOMWrapper& dcm,
                                  MInputInfoVector& v) const
{
  MDomainObject domainObject;

  DICOM_MAP m1[] = {
    { "studyinsuid", DCM_RELSTUDYINSTANCEUID},
    { "", 0}
  };

  DICOM_MAP m2[] = {
    { "seriesinsuid", DCM_RELSERIESINSTANCEUID},
    { "retrieveAEtitle", DCM_IDRETRIEVEAETITLE},
    { "", 0}
  };

  DICOM_MAP m3[] = {
    { "sopclassuid", DCM_IDREFERENCEDSOPCLASSUID},
    { "sopinsuid",  DCM_IDREFERENCEDSOPINSTUID},
    { "", 0}
  };

  DCM_OBJECT* obj = dcm.getNativeObject();

  LST_HEAD* l1;
  LST_HEAD* l2;
  LST_HEAD* l3;
  CONDITION cond;

  cond = ::DCM_GetSequenceList(&obj, DCM_PRCINPUTINFOSEQ, &l1);

  if (cond != DCM_NORMAL) {
    ::COND_PopCondition(TRUE);
    return 0;
  }

  DCM_SEQUENCE_ITEM* item1 = (DCM_SEQUENCE_ITEM*) ::LST_Head(&l1);
  (void) ::LST_Position(&l1, item1);
  while( item1 != NULL) {

    cond = ::DCM_GetSequenceList(&item1->object,
                                 DCM_IDREFERENCEDSERIESSEQ, &l2);

    if (cond != DCM_NORMAL) {
      ::COND_PopCondition(TRUE);
      return 0;
    }

    MDICOMWrapper w1(item1->object);

    DCM_SEQUENCE_ITEM* item2 = (DCM_SEQUENCE_ITEM*) ::LST_Head(&l2);
    (void) ::LST_Position(&l2, item2);
    while( item2 != NULL) {

      cond = ::DCM_GetSequenceList(&item2->object,
                                 DCM_IDREFERENCEDSOPSEQUENCE, &l3);

      if (cond != DCM_NORMAL) {
        ::COND_PopCondition(TRUE);
        return 0;
      }

      MDICOMWrapper w2(item2->object);

      DCM_SEQUENCE_ITEM* item3 = (DCM_SEQUENCE_ITEM*) ::LST_Head(&l3);
      (void) ::LST_Position(&l3, item3);
      while (item3 != NULL) {
        MDICOMWrapper w3(item3->object);
        MInputInfo ii;
        MDomainObject domainObject;
        this->translateDICOM(w1, m1, domainObject);
        this->translateDICOM(w2, m2, domainObject);
        this->translateDICOM(w3, m3, domainObject);
        ii.import(domainObject);
        v.push_back(ii);
        item3 = (DCM_SEQUENCE_ITEM*)LST_Next(&l3);
      }
      item2 = (DCM_SEQUENCE_ITEM*)LST_Next(&l2);
    }
    item1 = (DCM_SEQUENCE_ITEM*)LST_Next(&l1);
  }
  return 0;
}

int
MDICOMDomainXlate::translateDICOM(MDICOMWrapper& dcm, MStudy& study) const
{
  DICOM_MAP m[] = {
    { "patid", DCM_PATID },
    { "issuer",  DCM_MAKETAG(0x0010, 0x0021)},
    { "stuinsuid", DCM_RELSTUDYINSTANCEUID },
    { "stuid", DCM_RELSTUDYID},
    { "studat", DCM_IDSTUDYDATE },
    { "stutim", DCM_IDSTUDYTIME },
    { "accnum", DCM_IDACCESSIONNUMBER },
//    { "reqphynam", DCM_SDYREQUESTINGPHYSICIAN },
    { "refphynam", DCM_IDREFERRINGPHYSICIAN },
    { "studes", DCM_IDSTUDYDESCRIPTION },
    { "patage", DCM_PATAGE },
    { "patsiz", DCM_PATSIZE },
    { "patsex", DCM_PATSEX },
    { "modinstu", DCM_IDMODALITIESINSTUDY},
    { "numser", DCM_RELNUMBERSTUDYRELATEDSERIES },
    { "numins", DCM_RELNUMBERSTUDYRELATEDIMAGES },
    { "", 0 }
  };
  MDomainObject domainObject;

  this->translateDICOM(dcm, m, domainObject);
  study.import(domainObject);
  return 0;
}

int
MDICOMDomainXlate::translateDICOM(MDICOMWrapper& dcm, MSeries& series) const
{
  DICOM_MAP m[] = {
    { "stuinsuid", DCM_RELSTUDYINSTANCEUID },
    { "serinsuid", DCM_RELSERIESINSTANCEUID},
    { "mod", DCM_IDMODALITY },
    { "sernum", DCM_RELSERIESNUMBER },
    { "pronam", DCM_ACQPROTOCOLNAME },
    { "serdes", DCM_IDSERIESDESCR },
    { "serdat", DCM_IDSERIESDATE},
    { "numins", DCM_RELNUMBERSERIESRELATEDINST },
    { "", 0 }
  };
  MDomainObject domainObject;

  this->translateDICOM(dcm, m, domainObject);
  series.import(domainObject);

  // Now, translate from Request Attribute Sequence (0040 0275)
  DCM_OBJECT* obj = dcm.getNativeObject();

  LST_HEAD* l1;
  CONDITION cond;

  cond = ::DCM_GetSequenceList(&obj,
			       DCM_PRCREQUESTATTRIBUTESSEQ,
			       &l1);

  if (cond != DCM_NORMAL) {
    ::COND_PopCondition(TRUE);
    return 0;
  }

  DCM_SEQUENCE_ITEM* item;
  item = (DCM_SEQUENCE_ITEM*) ::LST_Head(&l1);
  if (item == 0)
    return 0;

  DICOM_MAP m1[] = {
    { "reqproid", DCM_PRCREQUESTEDPROCEDUREID},
    { "schprosteid", DCM_PRCSCHEDULEDPROCSTEPID},
    { "", 0}
  };

  while (item != NULL) {
    MDICOMWrapper w(item->object);
    MRequestAttribute requestAttribute;
    MDomainObject domainObject;
    this->translateDICOM(w, m1, domainObject);
    requestAttribute.import(domainObject);
    series.addRequestAttribute(requestAttribute);

    item = (DCM_SEQUENCE_ITEM*)LST_Next(&l1);
  }
  return 0;
}

int
MDICOMDomainXlate::translateDICOM(MDICOMWrapper& dcm,
				  MSOPInstance& sopInstance) const
{
  DICOM_MAP m[] = {
    { "serinsuid", DCM_RELSERIESINSTANCEUID},
    { "clauid", DCM_IDSOPCLASSUID},
    { "insuid", DCM_IDSOPINSTANCEUID},
    { "imanum", DCM_RELIMAGENUMBER},

    // Image Specific
    { "row", DCM_IMGROWS},
    { "col", DCM_IMGCOLUMNS},
    { "bitall", DCM_IMGBITSALLOCATED},
    { "numfrm", DCM_IMGNUMBEROFFRAMES},

    // Presentation State Specific
    { "prelbl", DCM_MAKETAG(0x0070, 0x0080)},
    { "predes", DCM_MAKETAG(0x0070, 0x0081)},
    { "precredat", DCM_MAKETAG(0x0070, 0x0082)},
    { "precretim", DCM_MAKETAG(0x0070, 0x0083)},
    { "precrenam", DCM_MAKETAG(0x0070, 0x0084)},

    // SR Specific
    { "comflg", DCM_MAKETAG(0x0040, 0xa491)},
    { "verflg", DCM_MAKETAG(0x0040, 0xa493)},
    { "condat", DCM_MAKETAG(0x0008, 0x0023)},
    { "contim", DCM_MAKETAG(0x0008, 0x0033)},
    { "obsdattim", DCM_MAKETAG(0x0040, 0xa032)},
    { "doctitle", DCM_MAKETAG(0x0042, 0x0010)},

    { "", 0 }
  };
  DICOM_SEQMAP seqMap[] = {
    { "conceptval", 0x0040a043, 0x00080100},
    { "conceptschm", 0x0040a043, 0x00080102},
    { "conceptvers", 0x0040a043, 0x00080103},
    { "conceptmean", 0x0040a043, 0x00080104},
    { "", 0, 0}
  };

  MDomainObject domainObject;

  this->translateDICOM(dcm, m, domainObject);

  // If the sequence exists, we have to play a game here.
  // We copy the sequence items into a separate DICOM Wrapper.
  // A byproduct is that we insert empty attributes if they
  // are not present in the sequence. This forces later code
  // to fill in those attributes as return keys.

  if (dcm.attributePresent(0x0040a043)) {
    MDICOMWrapper w;
    DCM_TAG t;
    int i = 0;

    for (t = seqMap[i].seqTag; t != 0x00000000; t = seqMap[++i].seqTag) {
      MString v;
      v = dcm.getString(t, seqMap[i].itemTag);
      w.setString(t, seqMap[i].itemTag, v, 1);
    }
    this->translateDICOM(w, seqMap, domainObject);
  }

  sopInstance.import(domainObject);
  return 0;
}


int
MDICOMDomainXlate::translateDICOM(MDICOMWrapper& dcm,
				  MPatientStudy& patientStudy) const
{
  DICOM_MAP m[] = {
    { "patid",  DCM_PATID },
    { "issuer",  DCM_MAKETAG(0x0010, 0x0021)},
    { "nam", DCM_PATNAME },
    { "datbir", DCM_PATBIRTHDATE },
    { "sex", DCM_PATSEX },
    { "stuinsuid", DCM_RELSTUDYINSTANCEUID },
    { "stuid", DCM_RELSTUDYID},
    { "studat", DCM_IDSTUDYDATE },
    { "stutim", DCM_IDSTUDYTIME },
    { "accnum", DCM_IDACCESSIONNUMBER },
//    { "reqphynam", DCM_SDYREQUESTINGPHYSICIAN },
    { "refphynam", DCM_IDREFERRINGPHYSICIAN },
    { "studes", DCM_IDSTUDYDESCRIPTION },
    { "patage", DCM_PATAGE },
    { "patsiz", DCM_PATSIZE },
    { "modinstu", DCM_IDMODALITIESINSTUDY},
    { "numser", DCM_RELNUMBERSTUDYRELATEDSERIES },
    { "numins", DCM_RELNUMBERSTUDYRELATEDIMAGES },

    { "", 0 }
  };
  MDomainObject domainObject;

  this->translateDICOM(dcm, m, domainObject);
  patientStudy.import(domainObject);
  return 0;
}




int
MDICOMDomainXlate::translateDICOM(MDICOMWrapper& dcm,
				  MMWL& modalityWorkList,
				  MActionItemVector& actionItemVector) const
{
  DICOM_MAP m0[] = {
    // Imaging Service Request
	  {"reqphynam", DCM_SDYREQUESTINGPHYSICIAN },
    { "refphynam", DCM_IDREFERRINGPHYSICIAN },
    { "reqphynam", DCM_SDYREQUESTINGPHYSICIAN },

    //Patient
    { "patid",  DCM_PATID },
    { "nam", DCM_PATNAME },
    { "datbir", DCM_PATBIRTHDATE },
    { "sex", DCM_PATSEX },
    { "issuer", DCM_ISSUERPATIENTID },
    
    //Requested Procedure
    { "reqproid", DCM_PRCREQUESTEDPROCEDUREID },
    { "stuinsuid", DCM_RELSTUDYINSTANCEUID },
    //{ "filordnum", SOMETHING_HERE },
    { "accnum", DCM_IDACCESSIONNUMBER },
    { "quatim", DCM_PRCREQUESTEDPROCPRIORITY },
    { "reqprodes", DCM_SDYREQUESTEDPRODESCRIPTION },
    { "", 0 }
  };


  DICOM_SEQMAP m[] = {
    { "spsid", DCM_PRCSCHEDULEDPROCSTEPSEQ, DCM_PRCSCHEDULEDPROCSTEPID },
    { "schaet", DCM_PRCSCHEDULEDPROCSTEPSEQ, DCM_PRCSCHEDULEDSTATIONAETITLE },
    { "spsstadat", DCM_PRCSCHEDULEDPROCSTEPSEQ, DCM_PRCSCHEDULEDPROCSTEPSTARTDATE },
    { "spsstatim", DCM_PRCSCHEDULEDPROCSTEPSEQ, DCM_PRCSCHEDULEDPROCSTEPSTARTTIME },
    { "mod", DCM_PRCSCHEDULEDPROCSTEPSEQ, DCM_IDMODALITY },
    { "schperphynam", DCM_PRCSCHEDULEDPROCSTEPSEQ, DCM_PRCSCHEDULEDPERFORMINGPHYSNAME },
    { "spsdes", DCM_PRCSCHEDULEDPROCSTEPSEQ, DCM_PRCSCHEDULEDPROCSTEPDESCRIPTION },
    { "schstanam", DCM_PRCSCHEDULEDPROCSTEPSEQ, DCM_PRCSCHEDULEDSTATIONNAME },
    { "spsloc", DCM_PRCSCHEDULEDPROCSTEPSEQ, DCM_PRCSCHEDULEDPROCSTEPLOCATION },
    { "premed", DCM_PRCSCHEDULEDPROCSTEPSEQ, DCM_PRCPREMEDICATION },

    { "refstusopcla", DCM_IDREFERENCEDSTUDYSEQ, DCM_IDREFERENCEDSOPCLASSUID },
    { "refstusopins", DCM_IDREFERENCEDSTUDYSEQ, DCM_IDREFERENCEDSOPINSTUID },

    { "codval", DCM_SDYREQUESTEDPROCODESEQ, DCM_IDCODEVALUE },
    { "codmea", DCM_SDYREQUESTEDPROCODESEQ, DCM_IDCODEMEANING},
    { "codschdes",  DCM_SDYREQUESTEDPROCODESEQ, DCM_IDCODINGSCHEMEDESIGNATOR},

    { "", 0, 0 }
  };
  MDomainObject domainObject;

  this->translateDICOM(dcm, m0, domainObject);
  this->translateDICOM(dcm, m, domainObject);
  modalityWorkList.import(domainObject);

  DCM_OBJECT* obj = dcm.getNativeObject();

  LST_HEAD* l1;
  LST_HEAD* l2;
  CONDITION cond;

  cond = ::DCM_GetSequenceList(&obj,
			       DCM_PRCSCHEDULEDPROCSTEPSEQ,
			       &l1);

  DCM_SEQUENCE_ITEM* item;
  item = (DCM_SEQUENCE_ITEM*) ::LST_Head(&l1);
  if (item == 0)
    return 0;

  cond = ::DCM_GetSequenceList(&item->object,
			       DCM_PRCSCHEDULEDACTIONITEMCODESEQ,
			       &l2);

  if (cond != DCM_NORMAL) {
    ::COND_PopCondition(TRUE);
    return 0;
  }

  item = (DCM_SEQUENCE_ITEM*) ::LST_Head(&l2);
  if (item == 0)
    return 0;

  (void) ::LST_Position(&l2, item);

  DICOM_MAP m1[] = {
    { "codval", DCM_IDCODEVALUE},
    { "", 0}
  };

  while (item != NULL) {
    MDICOMWrapper w(item->object);
    MActionItem actionItem;
    MDomainObject domainObject;
    this->translateDICOM(w, m1, domainObject);
    actionItem.import(domainObject);
    actionItemVector.push_back(actionItem);
    item = (DCM_SEQUENCE_ITEM*)LST_Next(&l2);
  }
  return 0;
}

int
MDICOMDomainXlate::translateDICOM(MDICOMWrapper& dcm,
				  MUPS& ups,
				  MUWLScheduledStationNameCodeVector& schedStationNameCodeVector) const
{
  DICOM_MAP m0[] = {
    //SOP Common
    { "specharset",  0x00080005},
    { "sopclauid",  0x00080016},
    { "sopinsuid",  0x00080018},

    // Unified Procedure Step Scheduled Procedure Information
    { "spspri",  0x00741200},
    { "spsmoddattim",  0x00404010},
    { "prostelbl",  0x00741204},
    { "worlbl",  0x00741202},
    { "spsstadattim",  0x00404005},
    { "expcomdattim",  0x00404011},
    { "stuinsuid", DCM_RELSTUDYINSTANCEUID },

    // Unified Procedure Step Relationship
    { "nam", DCM_PATNAME },
    { "patid",  DCM_PATID },
    { "issuer", DCM_ISSUERPATIENTID },
    { "datbir", DCM_PATBIRTHDATE },
    { "sex", DCM_PATSEX },
    { "admid", 0x00380010},
    { "issueradmid", 0x00380011},
    { "admdiagdes",  0x00081080},
    { "upsstate",  0x00741000},

    // Imaging Service Request
	  {"reqphynam", DCM_SDYREQUESTINGPHYSICIAN },
    { "refphynam", DCM_IDREFERRINGPHYSICIAN },
    { "reqphynam", DCM_SDYREQUESTINGPHYSICIAN },

    //Patient
    
    //Requested Procedure
    { "reqproid", DCM_PRCREQUESTEDPROCEDUREID },
    //{ "filordnum", SOMETHING_HERE },
    { "accnum", DCM_IDACCESSIONNUMBER },
    { "quatim", DCM_PRCREQUESTEDPROCPRIORITY },
    { "reqprodes", DCM_SDYREQUESTEDPRODESCRIPTION },
    { "", 0 }
  };


  DICOM_SEQMAP m[] = {
    { "spsid", DCM_PRCSCHEDULEDPROCSTEPSEQ, DCM_PRCSCHEDULEDPROCSTEPID },
    { "schaet", DCM_PRCSCHEDULEDPROCSTEPSEQ, DCM_PRCSCHEDULEDSTATIONAETITLE },
    { "spsstadat", DCM_PRCSCHEDULEDPROCSTEPSEQ, DCM_PRCSCHEDULEDPROCSTEPSTARTDATE },
    { "spsstatim", DCM_PRCSCHEDULEDPROCSTEPSEQ, DCM_PRCSCHEDULEDPROCSTEPSTARTTIME },
    { "mod", DCM_PRCSCHEDULEDPROCSTEPSEQ, DCM_IDMODALITY },
    { "schperphynam", DCM_PRCSCHEDULEDPROCSTEPSEQ, DCM_PRCSCHEDULEDPERFORMINGPHYSNAME },
    { "spsdes", DCM_PRCSCHEDULEDPROCSTEPSEQ, DCM_PRCSCHEDULEDPROCSTEPDESCRIPTION },
    { "schstanam", DCM_PRCSCHEDULEDPROCSTEPSEQ, DCM_PRCSCHEDULEDSTATIONNAME },
    { "spsloc", DCM_PRCSCHEDULEDPROCSTEPSEQ, DCM_PRCSCHEDULEDPROCSTEPLOCATION },
    { "premed", DCM_PRCSCHEDULEDPROCSTEPSEQ, DCM_PRCPREMEDICATION },

    { "refstusopcla", DCM_IDREFERENCEDSTUDYSEQ, DCM_IDREFERENCEDSOPCLASSUID },
    { "refstusopins", DCM_IDREFERENCEDSTUDYSEQ, DCM_IDREFERENCEDSOPINSTUID },

    { "codval", DCM_SDYREQUESTEDPROCODESEQ, DCM_IDCODEVALUE },
    { "codmea", DCM_SDYREQUESTEDPROCODESEQ, DCM_IDCODEMEANING},
    { "codschdes",  DCM_SDYREQUESTEDPROCODESEQ, DCM_IDCODINGSCHEMEDESIGNATOR},

    { "", 0, 0 }
  };
  MDomainObject domainObject;

  this->translateDICOM(dcm, m0, domainObject);
  this->translateDICOM(dcm, m, domainObject);
  ups.import(domainObject);

  DCM_OBJECT* obj = dcm.getNativeObject();

//  LST_HEAD* l1;
  LST_HEAD* l2 = 0;
  CONDITION cond;

/*
  cond = ::DCM_GetSequenceList(&obj,
			       DCM_PRCSCHEDULEDPROCSTEPSEQ,
			       &l1);

  item = (DCM_SEQUENCE_ITEM*) ::LST_Head(&l1);
  if (item == 0)
    return 0;
*/

  cond = ::DCM_GetSequenceList(&obj,
			       DCM_MAKETAG(0x004, 4025),
			       &l2);

  if (cond != DCM_NORMAL) {
    ::COND_PopCondition(TRUE);
    return 0;
  }

  DCM_SEQUENCE_ITEM* item;
  item = (DCM_SEQUENCE_ITEM*) ::LST_Head(&l2);
  if (item == 0)
    return 0;

  (void) ::LST_Position(&l2, item);

  DICOM_MAP m1[] = {
    { "codval", DCM_IDCODEVALUE},
    { "", 0}
  };

  while (item != NULL) {
    MDICOMWrapper w(item->object);
    MUWLScheduledStationNameCode x;
    MDomainObject domainObject;
    this->translateDICOM(w, m1, domainObject);
    x.import(domainObject);
    schedStationNameCodeVector.push_back(x);
    item = (DCM_SEQUENCE_ITEM*)LST_Next(&l2);
  }
  return 0;
}

int
MDICOMDomainXlate::translateDICOM(MDICOMWrapper& dcm,
				  MStorageCommitRequest& request)
{
  MString transactionUID;

  transactionUID = dcm.getString(DCM_IDTRANSACTIONUID);
  request.transactionUID(transactionUID);

  MString s;
  s = dcm.getString(DCM_IDRETRIEVEAETITLE);
  request.retrieveAETitle(s);

  DICOM_MAP m[] = {
    { "sopcla", DCM_IDSOPCLASSUID},
    { "sopins", DCM_IDSOPINSTANCEUID},
    { "trauid", DCM_IDTRANSACTIONUID},
    { "", 0 }
  };

  int index = 1;
  while(1) {
    MStorageCommitItem item;
    s = dcm.getString(DCM_IDREFERENCEDSOPSEQUENCE,
		      DCM_IDREFERENCEDSOPCLASSUID,
		      index);
    if (s == "")
      break;

    item.sopClass(s);
    s = dcm.getString(DCM_IDREFERENCEDSOPSEQUENCE,
		      DCM_IDREFERENCEDSOPINSTUID,
		      index);
    item.sopInstance(s);

    item.status("0");

    item.transactionUID(transactionUID);

    request.addItem(item);
    index++;
  }

  return 0;
}


int
MDICOMDomainXlate::translateDICOM(MDICOMWrapper& dcm,
				  MDICOMFileMeta& fileMeta) const
{
  DICOM_MAP m[] = {
    { "mediasopclassuid",  0x00020002 },
    { "mediasopinsuid",    0x00020003 },
    { "xfersyntuid",       0x00020010 },
    { "impclassuid",       0x00020012 },
    { "impversname",       0x00020013 },
    { "sourceaetitle",     0x00020016 },
    { "privinfocrtuid",    0x00020100 },

    { "", 0 }
  };
  MDomainObject domainObject;

  this->translateDICOM(dcm, m, domainObject);
  fileMeta.import(domainObject);
  return 0;
}

int
MDICOMDomainXlate::translateDICOM(MDICOMWrapper& dcm,
				  MDICOMDir& dir) const
{
  DCM_OBJECT* obj = dcm.getNativeObject();
  LST_HEAD* lst = LST_Create();

  CONDITION cond = DDR_GetPatientList(&obj, &lst);
  if (cond != DDR_NORMAL) {
    cout << "Could not get patient list" << endl;
    ::exit(1);
  }

  DDR_PATIENT* p = (DDR_PATIENT*)LST_Dequeue(&lst);
  while (p != NULL) {
    MPatient patient;
    patient.patientID(p->PatientID);
    patient.patientName(p->PatientName);
    patient.dateOfBirth(p->BirthDate);
    patient.patientSex(p->Sex);

    dir.addPatient(patient);
    CTN_FREE(p);
    p = (DDR_PATIENT*)LST_Dequeue(&lst);
  }

  LST_Destroy(&lst);

  return 0;
}

int
MDICOMDomainXlate::translateDICOM(const MPatient& patient,
				  DCM_OBJECT* templateObj,
				  DCM_OBJECT* target)
{
  DICOM_MAP m[] = {
    { "patid",  DCM_PATID },
    { "issuer",  DCM_MAKETAG(0x0010, 0x0021)},
    { "nam", DCM_PATNAME },
    { "datbir", DCM_PATBIRTHDATE },
    { "sex", DCM_PATSEX },
    { "", 0 }
  };

  this->translateDICOM(m, patient, templateObj, target);
  return 0;
}

int
MDICOMDomainXlate::translateDICOM(const MPatient& patient, const U32* tags,
				  DCM_OBJECT* target)
{
  DICOM_MAP m[] = {
    { "patid",  DCM_PATID },
    { "issuer",  DCM_MAKETAG(0x0010, 0x0021)},
    { "nam", DCM_PATNAME },
    { "datbir", DCM_PATBIRTHDATE },
    { "sex", DCM_PATSEX },
    { "", 0 }
  };

  this->translateDICOM(m, patient, tags, target);
  return 0;
}

int
MDICOMDomainXlate::translateDICOM(const MStudy& study,
				  DCM_OBJECT* templateObj,
				  DCM_OBJECT* target)
{
  DICOM_MAP m[] = {
    { "stuinsuid", DCM_RELSTUDYINSTANCEUID },
    { "stuid", DCM_RELSTUDYID},
    { "studat", DCM_IDSTUDYDATE },
    { "stutim", DCM_IDSTUDYTIME },
    { "accnum", DCM_IDACCESSIONNUMBER },
    { "refphynam", DCM_IDREFERRINGPHYSICIAN },
    { "studes", DCM_IDSTUDYDESCRIPTION },
    { "patage", DCM_PATAGE },
    { "patsiz", DCM_PATSIZE },
    { "modinstu", DCM_IDMODALITIESINSTUDY},
    { "numser", DCM_RELNUMBERSTUDYRELATEDSERIES },
    { "numins", DCM_RELNUMBERSTUDYRELATEDIMAGES },
    { "", 0 }
  };

  this->translateDICOM(m, study, templateObj, target);
  return 0;
}

int
MDICOMDomainXlate::translateDICOM(const MSeries& series,
				  DCM_OBJECT* templateObj,
				  DCM_OBJECT* target)
{
  DICOM_MAP m[] = {
    { "stuinsuid", DCM_RELSTUDYINSTANCEUID },
    { "serinsuid", DCM_RELSERIESINSTANCEUID},
    { "mod", DCM_IDMODALITY },
    { "sernum", DCM_RELSERIESNUMBER },
    { "pronam", DCM_ACQPROTOCOLNAME },
    { "serdes", DCM_IDSERIESDESCR },
    { "numins", DCM_RELNUMBERSERIESRELATEDINST },
    { "", 0 }
  };

  this->translateDICOM(m, series, templateObj, target);
  return 0;
}


int
MDICOMDomainXlate::translateDICOM(const MSOPInstance& sopInstance,
				  DCM_OBJECT* templateObj,
				  DCM_OBJECT* target)
{
  DICOM_MAP m[] = {
    { "clauid", DCM_IDSOPCLASSUID},
    { "insuid", DCM_IDSOPINSTANCEUID},
    { "imanum", DCM_RELIMAGENUMBER},

    // Image Specific
    { "row", DCM_IMGROWS},
    { "col", DCM_IMGCOLUMNS},
    { "bitall", DCM_IMGBITSALLOCATED},
    { "numfrm", DCM_IMGNUMBEROFFRAMES},

    // Presentation State Specific
    { "prelbl", DCM_MAKETAG(0x0070, 0x0080)},
    { "predes", DCM_MAKETAG(0x0070, 0x0081)},
    { "precredat", DCM_MAKETAG(0x0070, 0x0082)},
    { "precretim", DCM_MAKETAG(0x0070, 0x0083)},
    { "precrenam", DCM_MAKETAG(0x0070, 0x0084)},

    // SR Specific
    { "comflg", DCM_MAKETAG(0x0040, 0xa491)},
    { "verflg", DCM_MAKETAG(0x0040, 0xa493)},
    { "condat", DCM_MAKETAG(0x0008, 0x0023)},
    { "contim", DCM_MAKETAG(0x0008, 0x0033)},
    { "obsdattim", DCM_MAKETAG(0x0040, 0xa032)},
    { "doctitle", DCM_MAKETAG(0x0042, 0x0010)},
    { "", 0 }
  };
  DICOM_SEQMAP seqMap[] = {
    { "conceptval", 0x0040a043, 0x00080100},
    { "conceptschm", 0x0040a043, 0x00080102},
    { "conceptvers", 0x0040a043, 0x00080103},
    { "conceptmean", 0x0040a043, 0x00080104},
    { "", 0, 0}
  };

  this->translateDICOM(m, sopInstance, templateObj, target);

  // If the sequence exists, we have to play a game here.
  // We copy the sequence items into a separate DICOM Wrapper.
  // A byproduct is that we insert empty attributes if they
  // are not present in the sequence. This forces later code
  // to fill in those attributes as return keys.

  MDICOMWrapper dcm(templateObj);
  if (dcm.attributePresent(0x0040a043)) {
    MDICOMWrapper w;
    DCM_TAG t;
    int i = 0;

    for (t = seqMap[i].seqTag; t != 0x00000000; t = seqMap[++i].seqTag) {
      MString v;
      v = dcm.getString(t, seqMap[i].itemTag);
      w.setString(t, seqMap[i].itemTag, v, 1);
    }
    DCM_OBJECT *localTemplate = w.getNativeObject();
    this->translateDICOM(seqMap, sopInstance, localTemplate, target, 1);
  }

  return 0;
}


int
MDICOMDomainXlate::translateDICOM(const MPatientStudy& patientStudy,
				  DCM_OBJECT* templateObj,
				  DCM_OBJECT* target)
{
  DICOM_MAP m[] = {
    { "patid",  DCM_PATID },
    { "issuer",  DCM_MAKETAG(0x0010, 0x0021)},
    { "nam", DCM_PATNAME },
    { "datbir", DCM_PATBIRTHDATE },
    { "sex", DCM_PATSEX },

    { "stuinsuid", DCM_RELSTUDYINSTANCEUID },
    { "stuid", DCM_RELSTUDYID},
    { "studat", DCM_IDSTUDYDATE },
    { "stutim", DCM_IDSTUDYTIME },
    { "accnum", DCM_IDACCESSIONNUMBER },
    { "refphynam", DCM_IDREFERRINGPHYSICIAN },
    { "studes", DCM_IDSTUDYDESCRIPTION },
    { "patage", DCM_PATAGE },
    { "patsiz", DCM_PATSIZE },
    { "modinstu", DCM_IDMODALITIESINSTUDY},
    { "numser", DCM_RELNUMBERSTUDYRELATEDSERIES },
    { "numins", DCM_RELNUMBERSTUDYRELATEDIMAGES },
    { "", 0 }
  };

  this->translateDICOM(m, patientStudy, templateObj, target);
  return 0;
}

// Translate from domain objects to a DCM_OBJECT.
// The template object is used to indicate those fields
// that should be included in the output.
int
MDICOMDomainXlate::translateDICOM(const MMWL& modalityWorkList,
				  MActionItemVector& v,
				  DCM_OBJECT* templateObj, DCM_OBJECT* target)
{
  DICOM_MAP m0[] = {
    // Imaging Service Request
    { "refphynam", DCM_IDREFERRINGPHYSICIAN },
    { "reqphynam", DCM_SDYREQUESTINGPHYSICIAN },
    { "plaordnum", 0x00402016 },
    { "filordnum", 0x00402017 },
//    { "ordpro", DCM_SDYREQUESTINGPHYSICIAN },

    // Visit Identification
    { "admid", DCM_VISADMISSIONID},

    // Visit Status
    { "curpatloc", DCM_VISCURRENTPATIENTLOCATION },

    //Patient
    { "patid",  DCM_PATID },
    { "issuer",  DCM_MAKETAG(0x0010, 0x0021)},
    { "nam", DCM_PATNAME },
    { "datbir", DCM_PATBIRTHDATE },
    { "sex", DCM_PATSEX },
    { "xxx", DCM_PATWEIGHT },
    { "xxx", 	DCM_PRCCONFIDIENTIALITYCONSTRAINTPATIENTDATADES },
    { "issuer", DCM_ISSUERPATIENTID },

    // Patient Medical
    { "xxx", DCM_VISPATIENTSTATE },
    { "pregstat", DCM_PATPREGNANCYSTATUS },
    { "xxx", DCM_PATMEDICALALERTS },
    { "xxx", DCM_PATCONTRASTALLERGIES },
    { "xxx", DCM_VISSPECIALNEEDS },
    
    //Requested Procedure
    { "reqproid", DCM_PRCREQUESTEDPROCEDUREID },
    { "stuinsuid", DCM_RELSTUDYINSTANCEUID },
    //{ "filordnum", SOMETHING_HERE },
    { "accnum", DCM_IDACCESSIONNUMBER },
    { "quatim", DCM_PRCREQUESTEDPROCPRIORITY },
    { "reqprodes", DCM_SDYREQUESTEDPRODESCRIPTION },
    { "xxx", DCM_PRCREQUESTEDPROCPRIORITY },
    { "xxx", DCM_PRCPATIENTTRANSPORTARRANGEMENTS },
    { "", 0 }
  };

  DICOM_SEQMAP m1[] = {
    { "codval", DCM_SDYREQUESTEDPROCODESEQ, DCM_IDCODEVALUE },
    { "codmea", DCM_SDYREQUESTEDPROCODESEQ, DCM_IDCODEMEANING},
    { "codschdes",  DCM_SDYREQUESTEDPROCODESEQ, DCM_IDCODINGSCHEMEDESIGNATOR},


    { "schstanam", DCM_PRCSCHEDULEDPROCSTEPSEQ, DCM_PRCSCHEDULEDSTATIONNAME },
    { "spsid", DCM_PRCSCHEDULEDPROCSTEPSEQ, DCM_PRCSCHEDULEDPROCSTEPID },
    { "schaet", DCM_PRCSCHEDULEDPROCSTEPSEQ, DCM_PRCSCHEDULEDSTATIONAETITLE },
    { "spsstadat", DCM_PRCSCHEDULEDPROCSTEPSEQ, DCM_PRCSCHEDULEDPROCSTEPSTARTDATE },
    { "spsstatim", DCM_PRCSCHEDULEDPROCSTEPSEQ, DCM_PRCSCHEDULEDPROCSTEPSTARTTIME },
    { "mod", DCM_PRCSCHEDULEDPROCSTEPSEQ, DCM_IDMODALITY },
    { "schperphynam", DCM_PRCSCHEDULEDPROCSTEPSEQ, DCM_PRCSCHEDULEDPERFORMINGPHYSNAME },
    { "spsdes", DCM_PRCSCHEDULEDPROCSTEPSEQ, DCM_PRCSCHEDULEDPROCSTEPDESCRIPTION },

    { "spsloc", DCM_PRCSCHEDULEDPROCSTEPSEQ, DCM_PRCSCHEDULEDPROCSTEPLOCATION },
    { "premed", DCM_PRCSCHEDULEDPROCSTEPSEQ, DCM_PRCPREMEDICATION },


    { "refstusopcla", DCM_IDREFERENCEDSTUDYSEQ, DCM_IDREFERENCEDSOPCLASSUID },
    { "refstusopins", DCM_IDREFERENCEDSTUDYSEQ, DCM_IDREFERENCEDSOPINSTUID },

    //{ "xxx", DCM_IDREFERENCEDPATIENTSEQ, DCM_IDREFERENCEDSOPCLASSUID },
    //{ "xxx", DCM_IDREFERENCEDPATIENTSEQ, DCM_IDREFERENCEDSOPINSTUID },


    { "", 0, 0 }
  };

   DICOM_SEQMAP m2[] = {
    { "codmea", DCM_PRCSCHEDULEDACTIONITEMCODESEQ, DCM_IDCODEMEANING },
    { "codschdes", DCM_PRCSCHEDULEDACTIONITEMCODESEQ, DCM_IDCODINGSCHEMEDESIGNATOR },
    { "codval", DCM_PRCSCHEDULEDACTIONITEMCODESEQ, DCM_IDCODEVALUE },
    { "", 0, 0 }
  };

  DICOM_SEQMAP m3[] = {
    { "refpatclass", DCM_IDREFERENCEDPATIENTSEQ, DCM_IDREFERENCEDSOPCLASSUID },
    { "refpatsopins", DCM_IDREFERENCEDPATIENTSEQ, DCM_IDREFERENCEDSOPINSTUID },

    { "", 0, 0 }
  };

  this->translateDICOM(m0, modalityWorkList, templateObj, target);
  this->translateDICOM(m1, modalityWorkList, templateObj, target);

  MMWL dummyWorklist;
  dummyWorklist.insert("refpatclass", DICOM_SOPCLASSDETACHEDPATIENTMGMT);

  {
    char temp1[128];
    strcpy (temp1, "1.2.840.113654.");
    char temp2[128];
    MString x = modalityWorkList.value("patid");
    x.safeExport(temp2, sizeof(temp2));
    char *p1 = temp1;
    p1 += ::strlen(p1);
    char *p2 = temp2;

    while (*p2 != '\0') {
      if (isdigit(*p2)) {
	*p1 ++ = *p2;
      }
      p2++;
    }
    *p1 = '\0';
    dummyWorklist.insert("refpatsopins", temp1);
  }

  this->translateDICOM(m3, dummyWorklist, templateObj, target);

  MActionItemVector::iterator objIt = v.begin();

  LST_HEAD* l1;
  CONDITION cond;
  cond = ::DCM_GetSequenceList(&templateObj, DCM_PRCSCHEDULEDPROCSTEPSEQ, &l1);
  if (cond != DCM_NORMAL) {
    ::COND_PopCondition(TRUE);
    return 0;
  }
  DCM_SEQUENCE_ITEM* item1;
  item1 = (DCM_SEQUENCE_ITEM*)LST_Head(&l1);
  if (item1 == 0)
    return 0;

  LST_HEAD* l2;
  cond = ::DCM_GetSequenceList(&target, DCM_PRCSCHEDULEDPROCSTEPSEQ, &l2);
  if (cond != DCM_NORMAL) {
    ::COND_PopCondition(TRUE);
    return 0;
  }
  DCM_SEQUENCE_ITEM* item2;
  item2 = (DCM_SEQUENCE_ITEM*)LST_Head(&l2);
  if (item2 == 0)
    return 0;

  int index = 1;
  for(; objIt != v.end(); objIt++, index++)
    this->translateDICOM(m2, (*objIt),
			 item1->object, item2->object,
			 index);

  return 0;
}

int
MDICOMDomainXlate::translateDICOM(const MUPS& ups,
				  MUWLScheduledStationNameCodeVector& v,
				  DCM_OBJECT* templateObj, DCM_OBJECT* target)
{
  DICOM_MAP m0[] = {
    //SOP Common
    { "specharset",  0x00080005},
    { "sopclauid",  0x00080016},
    { "sopinsuid",  0x00080018},

    // Unified Procedure Step Scheduled Procedure Information
    { "spspri",  0x00741200},
    { "spsmoddattim",  0x00404010},
    { "prostelbl",  0x00741204},
    { "worlbl",  0x00741202},
    { "spsstadattim",  0x00404005},
    { "expcomdattim",  0x00404011},
    { "stuinsuid", DCM_RELSTUDYINSTANCEUID },

    // Unified Procedure Step Relationship
    { "nam", DCM_PATNAME },
    { "patid",  DCM_PATID },
    { "issuer",  DCM_MAKETAG(0x0010, 0x0021)},
    { "datbir", DCM_PATBIRTHDATE },
    { "sex", DCM_PATSEX },
    { "admid", 0x00380010},
    { "issueradmid", 0x00380011},
    { "admdiagdes",  0x00081080},
    { "upsstate",  0x00741000},

    // Imaging Service Request
    { "refphynam", DCM_IDREFERRINGPHYSICIAN },
    { "reqphynam", DCM_SDYREQUESTINGPHYSICIAN },
    { "plaordnum", 0x00402016 },
    { "filordnum", 0x00402017 },
//    { "ordpro", DCM_SDYREQUESTINGPHYSICIAN },

    // Visit Status
    { "curpatloc", DCM_VISCURRENTPATIENTLOCATION },

    //Patient
    { "xxx", DCM_PATWEIGHT },
    { "xxx", 	DCM_PRCCONFIDIENTIALITYCONSTRAINTPATIENTDATADES },
    { "issuer", DCM_ISSUERPATIENTID },

    // Patient Medical
    { "xxx", DCM_VISPATIENTSTATE },
    { "pregstat", DCM_PATPREGNANCYSTATUS },
    { "xxx", DCM_PATMEDICALALERTS },
    { "xxx", DCM_PATCONTRASTALLERGIES },
    { "xxx", DCM_VISSPECIALNEEDS },
    
    //Requested Procedure
    { "reqproid", DCM_PRCREQUESTEDPROCEDUREID },
    //{ "filordnum", SOMETHING_HERE },
    { "accnum", DCM_IDACCESSIONNUMBER },
    { "quatim", DCM_PRCREQUESTEDPROCPRIORITY },
    { "reqprodes", DCM_SDYREQUESTEDPRODESCRIPTION },
    { "xxx", DCM_PRCREQUESTEDPROCPRIORITY },
    { "xxx", DCM_PRCPATIENTTRANSPORTARRANGEMENTS },
    { "", 0 }
  };

  DICOM_SEQMAP m1[] = {
    { "codval", DCM_SDYREQUESTEDPROCODESEQ, DCM_IDCODEVALUE },
    { "codmea", DCM_SDYREQUESTEDPROCODESEQ, DCM_IDCODEMEANING},
    { "codschdes",  DCM_SDYREQUESTEDPROCODESEQ, DCM_IDCODINGSCHEMEDESIGNATOR},


    { "schstanam", DCM_PRCSCHEDULEDPROCSTEPSEQ, DCM_PRCSCHEDULEDSTATIONNAME },
    { "spsid", DCM_PRCSCHEDULEDPROCSTEPSEQ, DCM_PRCSCHEDULEDPROCSTEPID },
    { "schaet", DCM_PRCSCHEDULEDPROCSTEPSEQ, DCM_PRCSCHEDULEDSTATIONAETITLE },
    { "spsstadat", DCM_PRCSCHEDULEDPROCSTEPSEQ, DCM_PRCSCHEDULEDPROCSTEPSTARTDATE },
    { "spsstatim", DCM_PRCSCHEDULEDPROCSTEPSEQ, DCM_PRCSCHEDULEDPROCSTEPSTARTTIME },
    { "mod", DCM_PRCSCHEDULEDPROCSTEPSEQ, DCM_IDMODALITY },
    { "schperphynam", DCM_PRCSCHEDULEDPROCSTEPSEQ, DCM_PRCSCHEDULEDPERFORMINGPHYSNAME },
    { "spsdes", DCM_PRCSCHEDULEDPROCSTEPSEQ, DCM_PRCSCHEDULEDPROCSTEPDESCRIPTION },

    { "spsloc", DCM_PRCSCHEDULEDPROCSTEPSEQ, DCM_PRCSCHEDULEDPROCSTEPLOCATION },
    { "premed", DCM_PRCSCHEDULEDPROCSTEPSEQ, DCM_PRCPREMEDICATION },


    { "refstusopcla", DCM_IDREFERENCEDSTUDYSEQ, DCM_IDREFERENCEDSOPCLASSUID },
    { "refstusopins", DCM_IDREFERENCEDSTUDYSEQ, DCM_IDREFERENCEDSOPINSTUID },

    //{ "xxx", DCM_IDREFERENCEDPATIENTSEQ, DCM_IDREFERENCEDSOPCLASSUID },
    //{ "xxx", DCM_IDREFERENCEDPATIENTSEQ, DCM_IDREFERENCEDSOPINSTUID },


    { "", 0, 0 }
  };

   DICOM_SEQMAP m2[] = {
    { "codmea", DCM_MAKETAG(0x0040, 0x4025), DCM_IDCODEMEANING },
    { "codschdes", DCM_MAKETAG(0x0040, 0x4025), DCM_IDCODINGSCHEMEDESIGNATOR },
    { "codval", DCM_MAKETAG(0x0040, 0x4025), DCM_IDCODEVALUE },
    { "", 0, 0 }
  };

  DICOM_SEQMAP m3[] = {
    { "refpatclass", DCM_IDREFERENCEDPATIENTSEQ, DCM_IDREFERENCEDSOPCLASSUID },
    { "refpatsopins", DCM_IDREFERENCEDPATIENTSEQ, DCM_IDREFERENCEDSOPINSTUID },

    { "", 0, 0 }
  };

  this->translateDICOM(m0, ups, templateObj, target);
  this->translateDICOM(m1, ups, templateObj, target);

  MUPS dummyWorklist;
  dummyWorklist.insert("refpatclass", DICOM_SOPCLASSDETACHEDPATIENTMGMT);

  {
    char temp1[128];
    strcpy (temp1, "1.2.840.113654.");
    char temp2[128];
    MString x = ups.value("patid");
    x.safeExport(temp2, sizeof(temp2));
    char *p1 = temp1;
    p1 += ::strlen(p1);
    char *p2 = temp2;

    while (*p2 != '\0') {
      if (isdigit(*p2)) {
	*p1 ++ = *p2;
      }
      p2++;
    }
    *p1 = '\0';
    dummyWorklist.insert("refpatsopins", temp1);
  }

  this->translateDICOM(m3, dummyWorklist, templateObj, target);


  MUWLScheduledStationNameCodeVector::iterator objIt = v.begin();

/*
  LST_HEAD* l1;
  CONDITION cond;
  cond = ::DCM_GetSequenceList(&templateObj, 0x00404025, &l1);
  if (cond != DCM_NORMAL) {
    ::COND_PopCondition(TRUE);
    return 0;
  }
  DCM_SEQUENCE_ITEM* item1;
  item1 = (DCM_SEQUENCE_ITEM*)LST_Head(&l1);
  if (item1 == 0)
    return 0;

  LST_HEAD* l2;
  cond = ::DCM_GetSequenceList(&target, 0x00404025, &l2);
  if (cond != DCM_NORMAL) {
    ::COND_PopCondition(TRUE);
    return 0;
  }
  DCM_SEQUENCE_ITEM* item2;
  item2 = (DCM_SEQUENCE_ITEM*)LST_Head(&l2);
  if (item2 == 0)
    return 0;
*/

  int index = 1;
  for(; objIt != v.end(); objIt++, index++)
    this->translateDICOM(m2, (*objIt),
		    	 templateObj, target,
//			 item1->object, item2->object,
			 index);

  return 0;
}

int
MDICOMDomainXlate::translateDICOM(const MActHumanPerformersVector& ahpv,
                                  DCM_OBJECT* target)
{
  CONDITION cond;
  MDICOMWrapper w_target = MDICOMWrapper(target);

  // put actual human performers sequence into the target.
  LST_HEAD* l1 = 0;
  w_target.createSequence(DCM_PRCACTUALHUMANPERFORMERSSEQ);
  cond = ::DCM_GetSequenceList(&target,
                               DCM_PRCACTUALHUMANPERFORMERSSEQ,
                               &l1);
  if (cond != DCM_NORMAL) {
     return 1;
  }

  MActHumanPerformers ahp;
  for( int i = 0; i < ahpv.size(); i++) {
    ahp = ahpv[i];
// cout << "ahp: " << ahp << endl;
    DCM_OBJECT* x;
    cond = DCM_CreateObject(&x, 0);
    MDICOMWrapper h(x);
    h.setString(0x00404009, 0x00080100, ahp.codeValue(), 1);
    h.setString(0x00404009, 0x00080102, ahp.codeSchemeDesignator(), 1);
    h.setString(0x00404009, 0x00080104, ahp.codeMeaning(), 1);
    // Don't have name or org in ahp domain object yet.
    //h.setString(0x00404037, "Human Performer Name");
    //h.setString(0x00404036, "Human Perforer Organization");

    DCM_SEQUENCE_ITEM* item = (DCM_SEQUENCE_ITEM*)malloc(sizeof(*item));
    item->object = x;
    LST_Enqueue(&l1, item);
  }
  return 0;
}

int
MDICOMDomainXlate::translateDICOM(const MInputInfoVector& iiv,
				  DCM_OBJECT* templateObj, DCM_OBJECT* target)
{
  DICOM_SEQMAP study_map[] = {
    { "studyinsuid", DCM_PRCINPUTINFOSEQ, DCM_RELSTUDYINSTANCEUID},
    { "", 0, 0 }
  };
  DICOM_SEQMAP series_map[] = {
    { "seriesinsuid", DCM_IDREFERENCEDSERIESSEQ, DCM_RELSERIESINSTANCEUID},
    { "retrieveAEtitle", DCM_IDREFERENCEDSERIESSEQ, DCM_IDRETRIEVEAETITLE},
    { "", 0, 0 }
  };
  DICOM_SEQMAP sop_map[] = {
    { "sopclassuid", DCM_IDREFERENCEDSOPSEQUENCE, DCM_IDREFERENCEDSOPCLASSUID},
    { "sopinsuid", DCM_IDREFERENCEDSOPSEQUENCE, DCM_IDREFERENCEDSOPINSTUID},
    { "", 0, 0 }
  };
  CONDITION cond;

  // if template object does not have Input Info Seq, 
  // return without doing anything.
  LST_HEAD* iiseq_lst;
  cond = ::DCM_GetSequenceList(&templateObj, DCM_PRCINPUTINFOSEQ, &iiseq_lst);
  if (cond != DCM_NORMAL) {
    ::COND_PopCondition(TRUE);
    return 0;
  }

  // insert the study instance UID

  // put study values into the target seq (empty if no matches)
  MInputInfo ii;
  if( iiv.size() > 0) {
     ii = iiv[0];
  }
  this->translateDICOM(study_map, ii, templateObj, target, 1);

  // insert referenced series seq in input info seq.

  // continue if template object has Referenced Series Seq, 
  // otherwise, return.
  DCM_SEQUENCE_ITEM* iiseq_item;
  iiseq_item = (DCM_SEQUENCE_ITEM*)LST_Head(&iiseq_lst);
  if (iiseq_item == 0)
    return 0;
  LST_HEAD* serseq_tmp_lst;
  cond = ::DCM_GetSequenceList(&(iiseq_item->object), 
                  DCM_IDREFERENCEDSERIESSEQ, &serseq_tmp_lst);
  if (cond != DCM_NORMAL) {
    ::COND_PopCondition(TRUE);
    return 0;
  }

  // get the input info seq from the target.
  LST_HEAD* iiseq_trgt_lst;
  cond = ::DCM_GetSequenceList(&target, DCM_PRCINPUTINFOSEQ, &iiseq_trgt_lst);
  if (cond != DCM_NORMAL) {
    ::COND_PopCondition(TRUE);
    return 0;
  }
  DCM_SEQUENCE_ITEM* iiseq_trgt_item;
  iiseq_trgt_item = (DCM_SEQUENCE_ITEM*)LST_Head(&iiseq_trgt_lst);
  if (iiseq_trgt_item == 0)
    return 0;

  // put series values into the target seq (empty if no matches)
  //MInputInfo ii;
  ii = MInputInfo();
  if( iiv.size() > 0) {
     ii = iiv[0];
  }
  this->translateDICOM(series_map, ii, iiseq_item->object, 
              iiseq_trgt_item->object, 1);


  // continue if template object has Referenced SOP Seq, 
  // otherwise, return.
  DCM_SEQUENCE_ITEM* series_seq_item;
  series_seq_item = (DCM_SEQUENCE_ITEM*)LST_Head(&serseq_tmp_lst);
  if (series_seq_item == 0)
    return 0;

  // get the input series seq from the target.
  LST_HEAD* series_seq_trgt_lst;
  cond = ::DCM_GetSequenceList(&iiseq_trgt_item->object, 
                 DCM_IDREFERENCEDSERIESSEQ, &series_seq_trgt_lst);
  if (cond != DCM_NORMAL) {
    ::COND_PopCondition(TRUE);
    return 0;
  }
  DCM_SEQUENCE_ITEM* series_seq_trgt_item;
  series_seq_trgt_item = (DCM_SEQUENCE_ITEM*)LST_Head(&series_seq_trgt_lst);
  if (series_seq_trgt_item == 0)
    return 0;


  // put values into the target seq (empty if no matches)
  if( iiv.size() == 0) {
     MInputInfo ii;
     this->translateDICOM(sop_map, ii, series_seq_item->object, 
              series_seq_trgt_item->object, 1);
  }
  else {
     MInputInfoVector::const_iterator objIt = iiv.begin();
     for(int index = 1; objIt != iiv.end(); objIt++, index++) {
        this->translateDICOM(sop_map, (*objIt), series_seq_item->object, 
              series_seq_trgt_item->object, index);
     }
  }

  return 0;
}

int
MDICOMDomainXlate::translateDICOM(const MOutputInfoVector& oiv,
				  DCM_OBJECT* templateObj, DCM_OBJECT* target)
{
  DICOM_SEQMAP study_map[] = {
    { "studyinsuid", DCM_PRCOUTPUTINFOSEQ, DCM_RELSTUDYINSTANCEUID},
    { "", 0, 0 }
  };
  DICOM_SEQMAP series_map[] = {
    { "seriesinsuid", DCM_IDREFERENCEDSERIESSEQ, DCM_RELSERIESINSTANCEUID},
    { "retrieveAEtitle", DCM_IDREFERENCEDSERIESSEQ, DCM_IDRETRIEVEAETITLE},
    { "", 0, 0 }
  };
  DICOM_SEQMAP sop_map[] = {
    { "sopclassuid", DCM_IDREFERENCEDSOPSEQUENCE, DCM_IDREFERENCEDSOPCLASSUID},
    { "sopinsuid", DCM_IDREFERENCEDSOPSEQUENCE, DCM_IDREFERENCEDSOPINSTUID},
    { "", 0, 0 }
  };
  CONDITION cond;

  // if template object does not have Output Info Seq, 
  // return without doing anything.
  LST_HEAD* oiseq_lst;
  cond = ::DCM_GetSequenceList(&templateObj, DCM_PRCOUTPUTINFOSEQ, &oiseq_lst);
  if (cond != DCM_NORMAL) {
    ::COND_PopCondition(TRUE);
    return 0;
  }

  // insert the study instance UID

  // put study values into the target seq (empty if no matches)
  MOutputInfo oi;
  if( oiv.size() > 0) {
     oi = oiv[0];
  }
  this->translateDICOM(study_map, oi, templateObj, target, 1);

  // insert referenced series seq in output info seq.

  // continue if template object has Referenced Series Seq, 
  // otherwise, return.
  DCM_SEQUENCE_ITEM* oiseq_item;
  oiseq_item = (DCM_SEQUENCE_ITEM*)LST_Head(&oiseq_lst);
  if (oiseq_item == 0)
    return 0;
  LST_HEAD* serseq_tmp_lst;
  cond = ::DCM_GetSequenceList(&(oiseq_item->object), 
                  DCM_IDREFERENCEDSERIESSEQ, &serseq_tmp_lst);
  if (cond != DCM_NORMAL) {
    ::COND_PopCondition(TRUE);
    return 0;
  }

  // get the output info seq from the target.
  LST_HEAD* oiseq_trgt_lst;
  cond = ::DCM_GetSequenceList(&target, DCM_PRCOUTPUTINFOSEQ, &oiseq_trgt_lst);
  if (cond != DCM_NORMAL) {
    ::COND_PopCondition(TRUE);
    return 0;
  }
  DCM_SEQUENCE_ITEM* oiseq_trgt_item;
  oiseq_trgt_item = (DCM_SEQUENCE_ITEM*)LST_Head(&oiseq_trgt_lst);
  if (oiseq_trgt_item == 0)
    return 0;

  // put series values into the target seq (empty if no matches)
  oi = MOutputInfo();
  if( oiv.size() > 0) {
     oi = oiv[0];
  }
  this->translateDICOM(series_map, oi, oiseq_item->object, 
              oiseq_trgt_item->object, 1);


  // continue if template object has Referenced SOP Seq, 
  // otherwise, return.
  DCM_SEQUENCE_ITEM* series_seq_item;
  series_seq_item = (DCM_SEQUENCE_ITEM*)LST_Head(&serseq_tmp_lst);
  if (series_seq_item == 0)
    return 0;

  // get the output series seq from the target.
  LST_HEAD* series_seq_trgt_lst;
  cond = ::DCM_GetSequenceList(&oiseq_trgt_item->object, 
                 DCM_IDREFERENCEDSERIESSEQ, &series_seq_trgt_lst);
  if (cond != DCM_NORMAL) {
    ::COND_PopCondition(TRUE);
    return 0;
  }
  DCM_SEQUENCE_ITEM* series_seq_trgt_item;
  series_seq_trgt_item = (DCM_SEQUENCE_ITEM*)LST_Head(&series_seq_trgt_lst);
  if (series_seq_trgt_item == 0)
    return 0;


  // put values into the target seq (empty if no matches)
  if( oiv.size() == 0) {
     MOutputInfo oi;
     this->translateDICOM(sop_map, oi, series_seq_item->object, 
              series_seq_trgt_item->object, 1);
  }
  else {
     MOutputInfoVector::const_iterator objIt = oiv.begin();
     for(int index = 1; objIt != oiv.end(); objIt++, index++) {
        this->translateDICOM(sop_map, (*objIt), series_seq_item->object, 
              series_seq_trgt_item->object, index);
     }
  }

  return 0;
}

int
MDICOMDomainXlate::translateDICOM(const MGPWorkitem& workitem,
				  DCM_OBJECT* templateObj, DCM_OBJECT* target)
{
  DICOM_MAP m0[] = {
    { "sopinsuid",  DCM_IDSOPINSTANCEUID }, 
    { "sopclassuid",  DCM_IDSOPCLASSUID },
    { "status",  DCM_PRCGPSPSSTATUS },
    { "inputavailflag",  DCM_PRCINPUTAVAILFLAG },
    { "priority",  DCM_PRCGPSPSPRIORITY },
    { "procstepid",  DCM_PRCSCHEDULEDPROCSTEPID },
    { "startdattim",  DCM_PRCGPSPSSTARTDATETIME },
    { "enddattim",  DCM_PRCGPSPSEXPECTEDCOMPLETEDATETIME },
    { "resultstuinsuid",  DCM_RELSTUDYINSTANCEUID },
    { "multcopyflag",  DCM_PRCGPSPSMULTIPLECOPIESFLAG },
    //{ "description",  DCM_ },
    { "patientid",  DCM_PATID },
    { "patientname",  DCM_PATNAME },
    { "birthdate",  DCM_PATBIRTHDATE },
    { "sex",  DCM_PATSEX },
    { "transactionUID",  DCM_IDTRANSACTIONUID },
    {"", 0}
  };
  DICOM_SEQMAP wicode_map[] = {
    { "workitemcodevalue", DCM_PRCSCHEDWORKITEMCODESEQ, DCM_IDCODEVALUE },
    { "workitemcodescheme",  DCM_PRCSCHEDWORKITEMCODESEQ, DCM_IDCODINGSCHEMEDESIGNATOR},
    { "workitemcodemeaning", DCM_PRCSCHEDWORKITEMCODESEQ, DCM_IDCODEMEANING},
    { "", 0, 0 }
  };
  DICOM_SEQMAP refreq_map[] = {
    {"reqprocDesc",DCM_PRCREFERENCEDDOCUMENTSSEQ,DCM_SDYREQUESTEDPRODESCRIPTION},
    {"reqprocAccessionNum",DCM_PRCREFERENCEDDOCUMENTSSEQ,DCM_IDACCESSIONNUMBER},
    {"reqprocID", DCM_PRCREFERENCEDDOCUMENTSSEQ, DCM_PRCREQUESTEDPROCEDUREID },
    {"requestingPhys",DCM_PRCREFERENCEDDOCUMENTSSEQ,DCM_SDYREQUESTINGPHYSICIAN},
    { "", 0, 0 }
  };

  this->translateDICOM(m0, workitem, templateObj, target);

  // put the sched work item code into the sequence.
  this->translateDICOM(wicode_map, workitem, templateObj, target);

  this->translateDICOM(refreq_map, workitem, templateObj, target);

  return 0;
}

int
MDICOMDomainXlate::translateDICOM( MStationNameVector& snv,
				  DCM_OBJECT* templateObj, DCM_OBJECT* target)
{
  DICOM_SEQMAP m[] = {
    { "codval", DCM_PRCSCHEDSTATIONNAMECODESEQ, DCM_IDCODEVALUE },
    { "codschdes", DCM_PRCSCHEDSTATIONNAMECODESEQ,DCM_IDCODINGSCHEMEDESIGNATOR},
    { "codmea", DCM_PRCSCHEDSTATIONNAMECODESEQ, DCM_IDCODEMEANING},
    { "", 0, 0 }
  };

  MStationNameVector::iterator objIt = snv.begin();

  int index = 1;
  for(; objIt != snv.end(); objIt++, index++)
    this->translateDICOM(m, (*objIt), templateObj, target, index);

  return 0;
}

int
MDICOMDomainXlate::translateDICOM( MPerfStationNameVector& snv,
				  DCM_OBJECT* templateObj, DCM_OBJECT* target)
{
  DICOM_SEQMAP m[] = {
    { "codval", DCM_PRCPERFORMEDSTATIONNAMECODESEQ, DCM_IDCODEVALUE },
    { "codschdes", DCM_PRCPERFORMEDSTATIONNAMECODESEQ,DCM_IDCODINGSCHEMEDESIGNATOR},
    { "codmea", DCM_PRCPERFORMEDSTATIONNAMECODESEQ, DCM_IDCODEMEANING},
    { "", 0, 0 }
  };

  MPerfStationNameVector::iterator objIt = snv.begin();

  int index = 1;
  for(; objIt != snv.end(); objIt++, index++)
    this->translateDICOM(m, (*objIt), templateObj, target, index);

  return 0;
}

int
MDICOMDomainXlate::translateDICOM( MStationClassVector& scv,
				  DCM_OBJECT* templateObj, DCM_OBJECT* target)
{
  DICOM_SEQMAP m[] = {
    { "codval", DCM_PRCSCHEDSTATIONCLASSCODESEQ, DCM_IDCODEVALUE },
    { "codschdes",DCM_PRCSCHEDSTATIONCLASSCODESEQ,DCM_IDCODINGSCHEMEDESIGNATOR},
    { "codmea", DCM_PRCSCHEDSTATIONCLASSCODESEQ, DCM_IDCODEMEANING},
    { "", 0, 0 }
  };

  MStationClassVector::iterator objIt = scv.begin();

  int index = 1;
  for(; objIt != scv.end(); objIt++, index++)
    this->translateDICOM(m, (*objIt), templateObj, target, index);

  return 0;
}

int
MDICOMDomainXlate::translateDICOM( MPerfStationClassVector& scv,
				  DCM_OBJECT* templateObj, DCM_OBJECT* target)
{
  DICOM_SEQMAP m[] = {
    { "codval", DCM_PRCPERFORMEDSTATIONCLASSCODESEQ, DCM_IDCODEVALUE },
    { "codschdes",DCM_PRCPERFORMEDSTATIONCLASSCODESEQ,DCM_IDCODINGSCHEMEDESIGNATOR},
    { "codmea", DCM_PRCPERFORMEDSTATIONCLASSCODESEQ, DCM_IDCODEMEANING},
    { "", 0, 0 }
  };

  MPerfStationClassVector::iterator objIt = scv.begin();

  int index = 1;
  for(; objIt != scv.end(); objIt++, index++)
    this->translateDICOM(m, (*objIt), templateObj, target, index);

  return 0;
}

int
MDICOMDomainXlate::translateDICOM( MStationLocationVector& slv,
				  DCM_OBJECT* templateObj, DCM_OBJECT* target)
{
  DICOM_SEQMAP m[] = {
    { "codval", DCM_PRCSCHEDSTATIONLOCCODESEQ, DCM_IDCODEVALUE },
    { "codschdes",DCM_PRCSCHEDSTATIONLOCCODESEQ,DCM_IDCODINGSCHEMEDESIGNATOR},
    { "codmea", DCM_PRCSCHEDSTATIONLOCCODESEQ, DCM_IDCODEMEANING},
    { "", 0, 0 }
  };

  MStationLocationVector::iterator objIt = slv.begin();

  int index = 1;
  for(; objIt != slv.end(); objIt++, index++)
    this->translateDICOM(m, (*objIt), templateObj, target, index);

  return 0;
}

int
MDICOMDomainXlate::translateDICOM( MPerfStationLocationVector& slv,
				  DCM_OBJECT* templateObj, DCM_OBJECT* target)
{
  DICOM_SEQMAP m[] = {
    { "codval", DCM_PRCPERFORMEDSTATIONLOCCODESEQ, DCM_IDCODEVALUE },
    { "codschdes",DCM_PRCPERFORMEDSTATIONLOCCODESEQ,DCM_IDCODINGSCHEMEDESIGNATOR},
    { "codmea", DCM_PRCPERFORMEDSTATIONLOCCODESEQ, DCM_IDCODEMEANING},
    { "", 0, 0 }
  };

  MPerfStationLocationVector::iterator objIt = slv.begin();

  int index = 1;
  for(; objIt != slv.end(); objIt++, index++)
    this->translateDICOM(m, (*objIt), templateObj, target, index);

  return 0;
}

int
MDICOMDomainXlate::translateDICOM( MPerfProcAppsVector& pav,
				  DCM_OBJECT* templateObj, DCM_OBJECT* target)
{
  DICOM_SEQMAP m[] = {
    { "codval", DCM_PRCPERFORMEDPROCAPPCODESEQ, DCM_IDCODEVALUE },
    { "codschdes",DCM_PRCPERFORMEDPROCAPPCODESEQ,DCM_IDCODINGSCHEMEDESIGNATOR},
    { "codmea", DCM_PRCPERFORMEDPROCAPPCODESEQ, DCM_IDCODEMEANING},
    { "", 0, 0 }
  };

  MPerfProcAppsVector::iterator objIt = pav.begin();

  int index = 1;
  for(; objIt != pav.end(); objIt++, index++)
    this->translateDICOM(m, (*objIt), templateObj, target, index);

  return 0;
}

int
MDICOMDomainXlate::translateDICOM( MPerfWorkitemVector& pwiv,
				  DCM_OBJECT* templateObj, DCM_OBJECT* target)
{
  DICOM_SEQMAP m[] = {
    { "codval", DCM_PRCPERFORMEDWORKITEMCODESEQ, DCM_IDCODEVALUE },
    { "codschdes",DCM_PRCPERFORMEDWORKITEMCODESEQ,DCM_IDCODINGSCHEMEDESIGNATOR},
    { "codmea", DCM_PRCPERFORMEDWORKITEMCODESEQ, DCM_IDCODEMEANING},
    { "", 0, 0 }
  };

  MPerfWorkitemVector::iterator objIt = pwiv.begin();

  int index = 1;
  for(; objIt != pwiv.end(); objIt++, index++)
    this->translateDICOM(m, (*objIt), templateObj, target, index);

  return 0;
}

int
MDICOMDomainXlate::translateDICOM( MReqSubsWorkitemVector& rswiv,
				  DCM_OBJECT* templateObj, DCM_OBJECT* target)
{
  DICOM_SEQMAP m[] = {
    { "codval", DCM_PRCREQSUBSWORKITEMCODESEQ, DCM_IDCODEVALUE },
    { "codschdes",DCM_PRCREQSUBSWORKITEMCODESEQ,DCM_IDCODINGSCHEMEDESIGNATOR},
    { "codmea", DCM_PRCREQSUBSWORKITEMCODESEQ, DCM_IDCODEMEANING},
    { "", 0, 0 }
  };

  MReqSubsWorkitemVector::iterator objIt = rswiv.begin();

  int index = 1;
  for(; objIt != rswiv.end(); objIt++, index++)
    this->translateDICOM(m, (*objIt), templateObj, target, index);

  return 0;
}

int
MDICOMDomainXlate::translateDICOM( MNonDCMOutputVector& ndov,
				  DCM_OBJECT* templateObj, DCM_OBJECT* target)
{
  DICOM_SEQMAP m[] = {
    { "codval", DCM_PRCNONDICOMOUTPUTCODESEQ, DCM_IDCODEVALUE },
    { "codschdes",DCM_PRCNONDICOMOUTPUTCODESEQ,DCM_IDCODINGSCHEMEDESIGNATOR},
    { "codmea", DCM_PRCNONDICOMOUTPUTCODESEQ, DCM_IDCODEMEANING},
    { "", 0, 0 }
  };

  MNonDCMOutputVector::iterator objIt = ndov.begin();

  int index = 1;
  for(; objIt != ndov.end(); objIt++, index++)
    this->translateDICOM(m, (*objIt), templateObj, target, index);

  return 0;
}

int
MDICOMDomainXlate::translateDICOM( MRefGPSPSVector& spsv,
				  DCM_OBJECT* templateObj, DCM_OBJECT* target)
{
  DICOM_SEQMAP m[] = {
    { "sopclassuid", DCM_PRCREFERENCEDGPSCHEDPROCSTEPSEQ, 
	    DCM_IDREFERENCEDSOPCLASSUID },
    { "sopinstanceuid",DCM_PRCREFERENCEDGPSCHEDPROCSTEPSEQ,
	    DCM_IDREFERENCEDSOPINSTUID},
    { "transactionuid", DCM_PRCREFERENCEDGPSCHEDPROCSTEPSEQ, 
	    DCM_PRCREFERENCEDGPSPSTRANSACTIONUID},
    { "", 0, 0 }
  };

  MRefGPSPSVector::iterator objIt = spsv.begin();

  int index = 1;
  for(; objIt != spsv.end(); objIt++, index++)
    this->translateDICOM(m, (*objIt), templateObj, target, index);

  return 0;
}

/*
int
MDICOMDomainXlate::translateDICOM(MGPPPSWorkitem& gpwi,
				  DCM_OBJECT* templateObj, DCM_OBJECT* target)
{
    DICOM_MAP m[] = {
      { "sopinsuid",  DCM_IDSOPINSTANCEUID },
      //{ "sopclassuid",  DCM_IDSOPCLASSUID },
      { "patientid",  DCM_PATID },
      { "patientname",  DCM_PATNAME },
      { "birthdate",  DCM_PATBIRTHDATE },
      { "sex",  DCM_PATSEX },
      { "procstepid", DCM_PRCPPSID }, 
      { "status",  DCM_PRCGPPPSSTATUS },
      { "startdate",  DCM_PRCPPSSTARTDATE },
      { "starttime",  DCM_PRCPPSSTARTTIME },
      { "enddate",  DCM_PRCPPSENDDATE },
      { "endtime", DCM_PRCPPSENDTIME },
      { "description",  DCM_PRCPPSDESCRIPTION },
      {"", 0}
    };

  // note this is the referenced Request sequence though it seems to be named
  // referenced document sequence in dicom_objects.h
  DICOM_SEQMAP m2[] = {
    {"reqprocDesc",DCM_PRCREFERENCEDDOCUMENTSSEQ,DCM_SDYREQUESTEDPRODESCRIPTION}
,
    {"reqprocAccessionNum",DCM_PRCREFERENCEDDOCUMENTSSEQ,DCM_IDACCESSIONNUMBER},
    {"reqprocID", DCM_PRCREFERENCEDDOCUMENTSSEQ, DCM_PRCREQUESTEDPROCEDUREID },
    { "", 0, 0 }
  };

  this->translateDICOM(m, gpwi, templateObj, target);
  this->translateDICOM(m2, gpwi, templateObj, target,1);
  return 0;
}
*/

int
MDICOMDomainXlate::translateDICOM(MGPPPSWorkitem& gpwi,
				  DCM_OBJECT* templateObj, DCM_OBJECT* target)
{
    DICOM_MAP m[] = {
      { "sopinsuid",  DCM_IDSOPINSTANCEUID },
      //{ "sopclassuid",  DCM_IDSOPCLASSUID },
      { "patientid",  DCM_PATID },
      { "patientname",  DCM_PATNAME },
      { "birthdate",  DCM_PATBIRTHDATE },
      { "sex",  DCM_PATSEX },
      { "procstepid", DCM_PRCPPSID }, 
      { "status",  DCM_PRCGPPPSSTATUS },
      { "startdate",  DCM_PRCPPSSTARTDATE },
      { "starttime",  DCM_PRCPPSSTARTTIME },
      { "enddate",  DCM_PRCPPSENDDATE },
      { "endtime", DCM_PRCPPSENDTIME },
      { "description",  DCM_PRCPPSDESCRIPTION },
      {"", 0}
    };

  /* note this is the referenced Request sequence though it seems to be named
     referenced document sequence in dicom_objects.h
  */
  DICOM_SEQMAP m2[] = {
    {"reqprocDesc",DCM_PRCREFERENCEDDOCUMENTSSEQ,DCM_SDYREQUESTEDPRODESCRIPTION}
,
    {"reqprocAccessionNum",DCM_PRCREFERENCEDDOCUMENTSSEQ,DCM_IDACCESSIONNUMBER},
    {"reqprocID", DCM_PRCREFERENCEDDOCUMENTSSEQ, DCM_PRCREQUESTEDPROCEDUREID },
    { "", 0, 0 }
  };

  this->translateDICOM(m, gpwi, templateObj, target);
  this->translateDICOM(m2, gpwi, templateObj, target, 1);

  LST_HEAD* l1 = 0;
  CONDITION cond = ::DCM_GetSequenceList(&target,
                               DCM_PRCREFERENCEDDOCUMENTSSEQ,
                               &l1);
  if (cond != DCM_NORMAL) {
     return 1;
  }

    DCM_OBJECT* x;
    cond = DCM_CreateObject(&x, 0);
    MDICOMWrapper h(x);
    h.setString(0x00321064, 0x00080100, gpwi.requestedProcCodevalue(), 1);
    h.setString(0x00321064, 0x00080102, gpwi.requestedProcCodescheme(), 1);
    h.setString(0x00321064, 0x00080104, gpwi.requestedProcCodemeaning(), 1);

    DCM_SEQUENCE_ITEM* item = (DCM_SEQUENCE_ITEM*)malloc(sizeof(*item));
    item->object = x;
    LST_Enqueue(&l1, item);
  return 0;
}

/*
int
MDICOMDomainXlate::translateDICOM(const MActHumanPerformersVector& ahpv,
                                  DCM_OBJECT* target)
{
  CONDITION cond;
  MDICOMWrapper w_target = MDICOMWrapper(target);

  // put actual human performers sequence into the target.
  LST_HEAD* l1 = 0;
  w_target.createSequence(DCM_PRCACTUALHUMANPERFORMERSSEQ);
  cond = ::DCM_GetSequenceList(&target,
                               DCM_PRCACTUALHUMANPERFORMERSSEQ,
                               &l1);
  if (cond != DCM_NORMAL) {
     return 1;
  }

  MActHumanPerformers ahp;
  for( int i = 0; i < ahpv.size(); i++) {
    ahp = ahpv[i];
// cout << "ahp: " << ahp << endl;
    DCM_OBJECT* x;
    cond = DCM_CreateObject(&x, 0);
    MDICOMWrapper h(x);
    h.setString(0x00404009, 0x00080100, ahp.codeValue(), 1);
    h.setString(0x00404009, 0x00080102, ahp.codeSchemeDesignator(), 1);
    h.setString(0x00404009, 0x00080104, ahp.codeMeaning(), 1);
    // Don't have name or org in ahp domain object yet.
    //h.setString(0x00404037, "Human Performer Name");
    //h.setString(0x00404036, "Human Perforer Organization");

    DCM_SEQUENCE_ITEM* item = (DCM_SEQUENCE_ITEM*)malloc(sizeof(*item));
    item->object = x;
    LST_Enqueue(&l1, item);
  }
  return 0;
}
*/

int
MDICOMDomainXlate::translateDICOM(MGPPPSObject& pps,
				  DCM_OBJECT* templateObj, DCM_OBJECT* target)
{
   MGPPPSWorkitem wi = pps.workitem();
   translateDICOM( wi, templateObj, target);

   MActHumanPerformersVector ahp = pps.actualHumanPerformersVector();
   translateDICOM( ahp, target);

   MPerfStationNameVector psn = pps.performedStationNameVector();
   translateDICOM( psn, templateObj, target);

   MPerfStationClassVector psc = pps.performedStationClassVector();
   translateDICOM( psc, templateObj, target);

   MPerfStationLocationVector psl = pps.performedStationLocationVector();
   translateDICOM( psl, templateObj, target);

   MPerfProcAppsVector ppa = pps.performedProcAppsVector();
   translateDICOM( ppa, templateObj, target);

   MPerfWorkitemVector pw = pps.performedWorkitemVector();
   translateDICOM( pw, templateObj, target);

   MReqSubsWorkitemVector rsw = pps.reqSubsWorkitemVector();
   translateDICOM( rsw, templateObj, target);

   MNonDCMOutputVector ndo = pps.nonDCMOutputVector();
   translateDICOM( ndo, templateObj, target);

   MOutputInfoVector oi = pps.outputInfoVector();
   translateDICOM( oi, templateObj, target);

   MRefGPSPSVector sps = pps.refGPSPSVector();
   translateDICOM( sps, templateObj, target);

   return 0;
}

int
MDICOMDomainXlate::translateDICOM(const MStorageCommitResponse& response,
				  DCM_OBJECT* target)
{
  MString s;
  MDICOMWrapper w(target);

  s = response.transactionUID();
  w.setString(DCM_IDTRANSACTIONUID, s);

  s = response.retrieveAETitle();
  if (s != "")
    w.setString(DCM_IDRETRIEVEAETITLE, s);

  int index = 1;
  MStorageCommitItem item;
  if (response.successItemCount() > 0) {
    LST_HEAD* l1 = ::LST_Create();

    for (index = 0; index < response.successItemCount(); index++) {
      item = response.successItem(index);
      DCM_OBJECT* o1 = 0;
      ::DCM_CreateObject(&o1, 0);
      MDICOMWrapper wo1(o1);
      s = item.sopClass();
      wo1.setString(DCM_IDREFERENCEDSOPCLASSUID, s);
      s = item.sopInstance();
      wo1.setString(DCM_IDREFERENCEDSOPINSTUID, s);

      DCM_SEQUENCE_ITEM* sq = (DCM_SEQUENCE_ITEM*)::malloc(sizeof(*sq));
      sq->object = o1;
      ::LST_Enqueue(&l1, sq);
    }
    DCM_ELEMENT e = { DCM_IDREFERENCEDSOPSEQUENCE, DCM_SQ, "", 1, 0, 0};
    e.d.ot = l1;
    ::DCM_AddSequenceElement(&target, &e);
  }

  if (response.failureItemCount() > 0) {
    LST_HEAD* l2 = ::LST_Create();
    for (index = 0; index < response.failureItemCount(); index++) {
      item = response.failureItem(index);
      DCM_OBJECT* o2 = 0;
      ::DCM_CreateObject(&o2, 0);
      MDICOMWrapper wo2(o2);
      s = item.sopClass();
      wo2.setString(DCM_IDREFERENCEDSOPCLASSUID, s);
      s = item.sopInstance();
      wo2.setString(DCM_IDREFERENCEDSOPINSTUID, s);

      s = item.status();
      wo2.setString(DCM_IDFAILUREREASON, s);

      DCM_SEQUENCE_ITEM* sq = (DCM_SEQUENCE_ITEM*)::malloc(sizeof(*sq));
      sq->object = o2;
      ::LST_Enqueue(&l2, sq);
    }
    DCM_ELEMENT e = { DCM_IDFAILEDSOPSEQUENCE, DCM_SQ, "", 1, 0, 0};
    e.d.ot = l2;
    ::DCM_AddSequenceElement(&target, &e);
  }
#if 0


  int index = 1;
  while(1) {
    MStorageCommitItem item;
    s = dcm.getString(DCM_IDREFERENCEDSOPSEQUENCE,
		      DCM_IDREFERENCEDSOPCLASSUID,
		      index);
    if (s == "")
      break;

    item.sopClass(s);
    s = dcm.getString(DCM_IDREFERENCEDSOPSEQUENCE,
		      DCM_IDREFERENCEDSOPINSTUID,
		      index);
    item.sopInstance(s);

    item.status(0);

    request.addItem(item);
    index++;
  }
#endif

  return 0;
}

int
MDICOMDomainXlate::translateDICOM(const MDICOMFileMeta& f,
				  DCM_OBJECT* target)
{
  MDICOMWrapper w(target);
  return this->translateDICOM(f, w);
}

int
MDICOMDomainXlate::translateDICOM(const MDICOMFileMeta& f,
				  MDICOMWrapper& targetWrapper)
{
  DICOM_MAP m[] = {
    { "mediasopclassuid",  0x00020002 },
    { "", 0 }
  };

  //this->translateDICOM(m, (const MDomainObject&)f, targetWrapper);
  this->translateDICOM(m, f, targetWrapper);

  return 0;
}
// Private methods defined below

int
MDICOMDomainXlate::translateDICOM(DICOM_MAP* m,
				  const MDomainObject& domainObj,
				  DCM_OBJECT* templateObj,
				  DCM_OBJECT* target)
{
  MDICOMWrapper targetWrapper(target);
  while (m->attribute[0] != '\0') {
    MString s(m->attribute);
    CONDITION cond;

    U32 length = 0;
    DCM_ELEMENT e = { m->tag, DCM_US, "", 1, 0, 0};

    cond = ::DCM_GetElement(&templateObj, m->tag, &e);
    if (cond == DCM_NORMAL) {
      MString v = domainObj.value(s);
      targetWrapper.setString(m->tag, v);
      //e.d.string = v.strData();
      //::DCM_ModifyElements(&target, &e, 1, 0, 0, 0);

      //delete [] e.d.string;
    }
    ::COND_PopCondition(TRUE);
    m++;
  }

  return 0;
}

int
MDICOMDomainXlate::translateDICOM(DICOM_SEQMAP* m,
				  const MDomainObject& domainObj,
				  DCM_OBJECT* templateObj,
				  DCM_OBJECT* target)
{
  for (; m->attribute[0] != '\0'; m++) {
    MString s(m->attribute);
    CONDITION cond;

    U32 length = 0;

    LST_HEAD* l1 = 0;
    cond = ::DCM_GetSequenceList(&templateObj, m->seqTag, &l1);
    if (cond != DCM_NORMAL) {
      ::COND_PopCondition(TRUE);
      continue;
    }

    DCM_SEQUENCE_ITEM* seqItem;
    seqItem = (DCM_SEQUENCE_ITEM*) ::LST_Head(&l1);
    if (seqItem == 0)
      continue;

    DCM_ELEMENT e = { m->itemTag, DCM_US, "", 1, 0, 0};
    cond = ::DCM_GetElement(&seqItem->object, m->itemTag, &e);
    if (cond != DCM_NORMAL) {
      ::COND_PopCondition(TRUE);
      continue;
    }

    MString v = domainObj.value(s);
    e.d.string = v.strData();

    LST_HEAD* l2 = 0;
    cond = ::DCM_GetSequenceList(&target, m->seqTag, &l2);
    if (cond != DCM_NORMAL) {
      ::COND_PopCondition(TRUE);
      l2 = (LST_HEAD*) ::LST_Create();
      DCM_SEQUENCE_ITEM* s = (DCM_SEQUENCE_ITEM*)malloc(sizeof(*s));
      ::DCM_CreateObject(&s->object, 0);
      ::LST_Enqueue(&l2, s);

      DCM_ELEMENT eSeq = { m->seqTag, DCM_SQ, "", 1, 0, 0 };
      eSeq.d.sq = l2;
      ::DCM_AddSequenceElement(&target, &eSeq);
    }

    DCM_SEQUENCE_ITEM* s1 = (DCM_SEQUENCE_ITEM*) ::LST_Head(&l2);

    ::DCM_ModifyElements(&s1->object, &e, 1, 0, 0, 0);

      delete [] e.d.string;

    ::COND_PopCondition(TRUE);
  }
  return 0;
}


int
MDICOMDomainXlate::translateDICOM(DICOM_SEQMAP* m,
				  const MDomainObject& domainObj,
				  DCM_OBJECT* templateObj,
				  DCM_OBJECT* target,
				  int index)
{
  for (; m->attribute[0] != '\0'; m++) {
    MString s(m->attribute);
    CONDITION cond;

    U32 length = 0;

    // If sequence not in the template, skip it
    LST_HEAD* l1 = 0;
    cond = ::DCM_GetSequenceList(&templateObj, m->seqTag, &l1);
    if (cond != DCM_NORMAL) {
      ::COND_PopCondition(TRUE);
      continue;
    }

    // If the sub item not in the template, skip it
    DCM_SEQUENCE_ITEM* seqItem;
    seqItem = (DCM_SEQUENCE_ITEM*) ::LST_Head(&l1);
    if (seqItem == 0)
      continue;

    DCM_ELEMENT e = { m->itemTag, DCM_US, "", 1, 0, 0};
    cond = ::DCM_GetElement(&seqItem->object, m->itemTag, &e);
    if (cond != DCM_NORMAL) {
      ::COND_PopCondition(TRUE);
      continue;
    }

    // Start the copy operation
    MString v = domainObj.value(s);
    e.d.string = v.strData();

    // If the sequence does not exist in the target,
    // create it.
    LST_HEAD* l2 = 0;
    cond = ::DCM_GetSequenceList(&target, m->seqTag, &l2);
    if (cond != DCM_NORMAL) {
      ::COND_PopCondition(TRUE);
      l2 = (LST_HEAD*) ::LST_Create();

      DCM_ELEMENT eSeq = { m->seqTag, DCM_SQ, "", 1, 0, 0 };
      eSeq.d.sq = l2;
      ::DCM_AddSequenceElement(&target, &eSeq);
    }

    // Find the proper sequence item in the target, or
    // make a new sequence item.

    DCM_SEQUENCE_ITEM* s1 = (DCM_SEQUENCE_ITEM*) ::LST_Head(&l2);
    (void) ::LST_Position(&l2, s1);
    int localIndex = index;
    while ((localIndex-- > 1) && (s1 != 0)) {
      s1 = (DCM_SEQUENCE_ITEM*) ::LST_Next(&l2);
    }

    if (s1 == 0) {
      s1 = (DCM_SEQUENCE_ITEM*)malloc(sizeof(*s1));
      ::DCM_CreateObject(&s1->object, 0);
      ::LST_Enqueue(&l2, s1);
    }

    // Place the string in the sequence item.
    ::DCM_ModifyElements(&s1->object, &e, 1, 0, 0, 0);

    delete [] e.d.string;

    ::COND_PopCondition(TRUE);
  }

  return 0;
}

int
MDICOMDomainXlate::translateDICOM(DICOM_MAP* m,
				  const MDomainObject& domainObj,
				  const U32* tags,
				  DCM_OBJECT* target)
{
  while (tags[0] != 0x00000000) {
    int index;
    for (index = 0; m[index].attribute[0] != '\0'; index++) {
      if (tags[0] == m[index].tag) {
	MString s(m[index].attribute);
	CONDITION cond;

	U32 length = 0;
	DCM_ELEMENT e = { m[index].tag, DCM_US, "", 1, 0, 0};

	cond = ::DCM_LookupElement(&e);
	if (cond == DCM_NORMAL) {
	  MString v = domainObj.value(s);
	  e.d.string = v.strData();
	  e.length = v.size();
	  ::DCM_ModifyElements(&target, &e, 1, 0, 0, 0);
	  delete [] e.d.string;
	}
      }
    }
    ::COND_PopCondition(TRUE);
    tags++;
  }

  return 0;
}

#if 0
int
MDICOMDomainXlate::translateDICOM(MDICOMWrapper& hl7, MVisit& visit) const
{
  DICOM_MAP m[] = {
    { "visnum",  "PV1",  19, 1 },
    { "patid",  "PID",  2, 1 },
    { "issuer", "PID",  2, 4 },
    { "patclass", "PV1",  2, 0 },
    { "asspatloc",  "PV1",  3, 0 },
    { "attdoc",     "PV1",  7, 0 },
    { "admdat",     "PV1",  44, 0 },
    { "admtim",     "PV1",  44, 0 },
    { "", "", 0,0 }
  };
  MDomainObject domainObject;

  this->translateDICOM(hl7, m, domainObject);
  visit.import(domainObject);
}

int
MDICOMDomainXlate::translateDICOM(MDICOMWrapper& hl7, MPlacerOrder& placerOrder) const
{
  DICOM_MAP m[] = {
    { "plaordnum",  "ORC",  2, 0 },
    { "filordnum", "ORC", 3, 0 },
    { "patid",  "PID",  2, 1 },
    { "issuer", "PID",  2, 4 },
#if 0
    { "ordcon", "ORC", 1, 0 },
    { "plagronum", "ORC", 4, 0 },
    { "ordsta", "ORC", 5, 0 },
    { "quatim", "ORC", 7, 0 },
    { "par", "ORC", 8, 0 },
    { "dattimtra", "ORC", 9, 0 },
    { "entby", "ORC", 10, 0 },
    { "ordpro", "ORC", 12, 0 },
    { "ordeffdattim", 15, 0 },
    { "entorg", 17, 0 },
#endif
    { "", "", 0,0 }
  };
  DICOM_MAP mapOrder[] = {
    { "plaordnum",  "ORC",  2, 0 },
    { "filordnum", "ORC", 3, 0 },
    { "ordcon", "ORC", 1, 0 },
    { "plagronum", "ORC", 4, 0 },
    { "ordsta", "ORC", 5, 0 },
    { "quatim", "ORC", 7, 0 },
    { "par", "ORC", 8, 0 },
    { "dattimtra", "ORC", 9, 0 },
    { "entby", "ORC", 10, 0 },
    { "ordpro", "ORC", 12, 0 },
    { "ordeffdattim", 15, 0 },
    { "entorg", 17, 0 },
    { "", "", 0,0 }
  };
  MDomainObject domainObject;

  this->translateDICOM(hl7, m, domainObject);
  placerOrder.import(domainObject);

  MString s = hl7.firstSegment();
  int numberOrders = 0;
  while (s != "") {
    if (s == "ORC")
      numberOrders++;

    s = hl7.nextSegment();
  }

  int index = 1;
  for (; index <= numberOrders; index++) {
    MOrder order;
    MDomainObject orderDomain;
    this->translateDICOM(hl7, index, mapOrder, orderDomain);
    order.import(orderDomain);
    placerOrder.add(order);
  }
}


int
MDICOMDomainXlate::translateDICOM(MDICOMWrapper& hl7, MFillerOrder& fillerOrder) const
{
  DICOM_MAP m[] = {
    { "visnum",  "PV1",  19, 1 },
    { "patid",  "PID",  2, 1 },
    { "issuer", "PID",  2, 4 },
    { "patclass", "PV1",  2, 0 },
    { "asspatloc",  "PV1",  3, 0 },
    { "attdoc",     "PV1",  7, 0 },
    { "admdat",     "PV1",  44, 0 },
    { "admtim",     "PV1",  44, 0 },
    { "", "", 0,0 }
  };
  MDomainObject domainObject;

  this->translateDICOM(hl7, m, domainObject);
  fillerOrder.import(domainObject);
}

int
MDICOMDomainXlate::translateDICOM(MDICOMWrapper& hl7, MOrder& order) const
{
  DICOM_MAP m[] = {
    { "plaordnum",  "ORC",  2, 0 },
    { "filordnum", "ORC", 3, 0 },
    { "ordcon", "ORC", 1, 0 },
    { "plagronum", "ORC", 4, 0 },
    { "ordsta", "ORC", 5, 0 },
    { "quatim", "ORC", 7, 0 },
    { "par", "ORC", 8, 0 },
    { "dattimtra", "ORC", 9, 0 },
    { "entby", "ORC", 10, 0 },
    { "ordpro", "ORC", 12, 0 },
    { "ordeffdattim", 15, 0 },
    { "entorg", 17, 0 },
    { "", "", 0,0 }
  };
  MDomainObject domainObject;

  this->translateDICOM(hl7, m, domainObject);
  order.import(domainObject);
}
#endif


int
MDICOMDomainXlate::translateDICOM(MDICOMWrapper& dcm, DICOM_MAP* m,
			      MDomainObject& o) const
{
  MString key;

  for (key = m->attribute; key != ""; key = (++m)->attribute) {
    MString v;
    v = dcm.getString(m->tag);

    o.insert(key, v);
  }

  return 0;
}

int
MDICOMDomainXlate::translateDICOM(MDICOMWrapper& dcm, DICOM_SEQMAP* m,
			      MDomainObject& o) const
{
  MString key;

  for (key = m->attribute; key != ""; key = (++m)->attribute) {
    MString v;
    v = dcm.getString(m->seqTag, m->itemTag);

    o.insert(key, v);
  }

  return 0;
}
#if 0
int
MDICOMDomainXlate::translateDICOM(MDICOMWrapper& hl7, int index, DICOM_MAP* m,
			      MDomainObject& o) const
{
  MString key;

  for (key = m->attribute; key != ""; key = (++m)->attribute) {
    MString v;
    v = hl7.getValue(index,
		     m->segment,
		     m->field,
		     m->component);
    o.insert(key, v);
  }
}
#endif

int
MDICOMDomainXlate::translateDICOM(DICOM_MAP* m,
				  const MDomainObject& domainObj,
				  MDICOMWrapper& targetWrapper)
{
  while (m->attribute[0] != '\0') {
    MString s(m->attribute);

    targetWrapper.setString(m->tag, s);
    m++;
  }

  return 0;
}
