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
#include "MDBPostProcMgr.hpp"
#include "MGPWorkitemObject.hpp"
#include "MDBPostProcMgrClient.hpp"

MDBPostProcMgr::MDBPostProcMgr() : mDBInterface(NULL)
{
}

MDBPostProcMgr::MDBPostProcMgr(const MDBPostProcMgr& cpy) : mDBInterface(cpy.mDBInterface)
{
}

MDBPostProcMgr::~MDBPostProcMgr()
{
  if (mDBInterface)
    delete mDBInterface;
}

void
MDBPostProcMgr::printOn(ostream& s) const
{
  s << "MDBPostProcMgr";
}

void
MDBPostProcMgr::streamIn(istream& s)
{
  //s >> this->member;
}

MDBPostProcMgr::MDBPostProcMgr(const MString& databaseName)
{
  if (databaseName == "")
    mDBInterface = 0;
  else
    mDBInterface = new MDBInterface(databaseName);
}

int
MDBPostProcMgr::openDatabase(const MString& databaseName)
{
  if (mDBInterface)
    delete mDBInterface;

  if (databaseName == "")
    mDBInterface = 0;
  else
    mDBInterface = new MDBInterface(databaseName);

  return 0;
}

int
MDBPostProcMgr::addToVector(const MGPWorkitem& workitem)
{
  mGPWorkitemVector.push_back(workitem);

  return 0;
}

void
workitemCallback(MDomainObject& domainObj, void* ctx)
{
  MDBPostProcMgr* ppmgr = (MDBPostProcMgr*)ctx;

  MGPWorkitem workitem;
  workitem.import(domainObj);

  ppmgr->addToVector(workitem);
}

void
workitemCallback2(MDomainObject& domainObj, void* ctx)
{
  MGPWorkitem * wi = (MGPWorkitem*)ctx;
  (*wi).import(domainObj);
}

void
ppsWorkitemCallback(MDomainObject& domainObj, void* ctx)
{
  MGPPPSWorkitem * wi = (MGPPPSWorkitem*)ctx;
  (*wi).import(domainObj);
}

void
stationNameCallback(MDomainObject& domainObj, void* ctx)
{
  MStationNameVector * snv = (MStationNameVector*)ctx;
  MStationName sn;
  sn.import(domainObj);
  (*snv).push_back(sn);
}

void
stationClassCallback(MDomainObject& domainObj, void* ctx)
{
  MStationClassVector * snv = (MStationClassVector*)ctx;
  MStationClass sn;
  sn.import(domainObj);
  (*snv).push_back(sn);
}

void
inputInfoCallback(MDomainObject& domainObj, void* ctx)
{
  MInputInfoVector * iiv = (MInputInfoVector*)ctx;
  MInputInfo ii;
  ii.import(domainObj);
  (*iiv).push_back(ii);
}

int
MDBPostProcMgr::queryPostProcWorkList( MGPWorkitemObject& wio, 
			MDBPostProcMgrClient& client)
{
  if (!mDBInterface)
    return 0;

  //clear the MGPWorkitemVector
  MGPWorkitemVector::iterator objIt = mGPWorkitemVector.end();
  for (; objIt != mGPWorkitemVector.begin(); objIt--) {
    mGPWorkitemVector.pop_back();
  }   

  //set up the search criteria
  char* searchCriteria[] = {
    "sopinsuid",
    // "sopclassuid",
    "inputavailflag",
    "priority",
    "procstepid",
    "patientid",
    "patientname",
    "reqprocAccessionNum",
    "reqprocID",
    // "reqprocDesc",
    // "reqprocCodevalue",
    // "reqprocCodescheme",
    // "reqprocCodemeaning",
    // "requestingPhys",
    "workitemcodevalue",
    "workitemcodescheme",
    "status",
    "startdattim",
  };

  int i;
  MCriteriaVector criteriaVec;

  MGPWorkitem workitem = wio.workitem();
  const MDomainMap& wi_map = workitem.map();
  for(i = 0; i < (int)DIM_OF(searchCriteria); i++) {
    MDomainMap::const_iterator iDomain = wi_map.find(searchCriteria[i]);
    MString s = (*iDomain).second;

    // MString s = wi_map[searchCriteria[i]];

    if (s != "") {
      if (searchCriteria[i] == "startdattim") {
	MString lrange = s.getToken('-',0);
	MString hrange;
	if(s.tokenExists('-',1))
	  hrange = s.getToken('-',1);
	else
	  hrange = "";
	if ((lrange != "") && s.tokenExists('-',1)){
	  TBL_OPERATOR oper = TBL_GREATER_EQUAL;
	  MCriteria c;
	  c.attribute = searchCriteria[i];
	  c.oper      = oper;
	  c.value     = lrange;
	  criteriaVec.push_back(c);
	}
	if (hrange != ""){
	  TBL_OPERATOR oper = TBL_LESS_EQUAL;
	  MCriteria c;
	  c.attribute = searchCriteria[i];
	  c.oper      = oper;
	  c.value     = hrange;
	  criteriaVec.push_back(c);
	}
	if ((lrange != "") && !(s.tokenExists('-',1))){
	  TBL_OPERATOR oper = TBL_EQUAL;
	  if (s.find("*") != string::npos) {
	    s.substitute('*', '%');
	    oper = TBL_LIKE;
	  }
	  MCriteria c;
	  c.attribute = searchCriteria[i];
	  c.oper      = oper;
	  c.value     = s;
	  criteriaVec.push_back(c);
	}
      } else {
	TBL_OPERATOR oper = TBL_EQUAL;
	if (s.find("*") != string::npos) {
	  s.substitute('*', '%');
	  oper = TBL_LIKE;
	}
	MCriteria c;
	c.attribute = searchCriteria[i];
	c.oper      = oper;
	c.value     = s;
	criteriaVec.push_back(c);
      }  
    }
  }
  
  MGPWorkitem retGPWorkitemValues;

  mDBInterface->select(retGPWorkitemValues, criteriaVec,workitemCallback, this);

//cout << "results after wi match\n";
  MGPWorkitemObjectVector results;
  for (MGPWorkitemVector::iterator workitemIter = mGPWorkitemVector.begin();
		workitemIter != mGPWorkitemVector.end();
		workitemIter++) {
     MGPWorkitem wi = *workitemIter;
     MGPWorkitemObject wio1(wi);
     results.push_back(wio1);
//cout << wio1;
  }
//cout << "finished results after wi match\n";
//cout << "found " << results.size() << " workitems\n";

//cout << "query object after wi match before sn match \n";
//cout << wio;
//cout << "finished query object after wi match before sn match \n";

  results = selectStationName( wio, results);
//cout << "found " << results.size() << " station names\n";

//cout << "query object after sn match before sc match \n";
//cout << wio;
//cout << "finished query object after sn match before sc match \n";

  results = selectStationClass( wio, results);
//cout << "found " << results.size() << " station classes\n";

  fillInputInfo( results);

  for (MGPWorkitemObjectVector::iterator wioIter = results.begin();
		wioIter != results.end(); wioIter++) {
       client.selectCallback(*wioIter);
  }

  return 0;
}

MGPWorkitemObjectVector
MDBPostProcMgr::selectStationName( 
    MGPWorkitemObject& q_wio,            // original query object
    MGPWorkitemObjectVector& prev_wio)   // results from previous queries.
{
  MGPWorkitemObjectVector results;
  char* sn_searchCriteria[] = {
    "codval",
    "codschdes"
  };

  MStationNameVector q_snv = q_wio.stationNameVector();
  for (MGPWorkitemObjectVector::iterator qwioIter = prev_wio.begin();
                qwioIter != prev_wio.end();
                qwioIter++) {

    MGPWorkitem q_wi = (*qwioIter).workitem();

    MStationNameVector r_snv;

    // should only be one value in the vector. ignore others if more than one.
    if( q_snv.size() > 0) {

       MStationName& sn = q_snv[0];
       MCriteriaVector cv1;
       MCriteria c1;
       c1.attribute = "workitemkey";
       c1.oper      = TBL_EQUAL;
       c1.value     = q_wi.SOPInstanceUID();
       cv1.push_back(c1);

       const MDomainMap& sn_map = sn.map();
       for(int i = 0; i < (int)DIM_OF(sn_searchCriteria); i++) {
         MDomainMap::const_iterator snDomain = sn_map.find(sn_searchCriteria[i])
;
         MString s = (*snDomain).second;
         if( s != "") {
           TBL_OPERATOR oper = TBL_EQUAL;
           if (s.find("*") != string::npos) {
             s.substitute('*', '%');
             oper = TBL_LIKE;
           }
           MCriteria c;
           c.attribute = sn_searchCriteria[i];
           c.oper      = oper;
           c.value     = s;
           cv1.push_back(c);
         }
       }

       MStationName sn1;
       int nmatches = mDBInterface->select(sn1, cv1,stationNameCallback,&r_snv);
       if( nmatches > 0) {
          //MGPWorkitemObject wio = MGPWorkitemObject(q_wi);
          MGPWorkitemObject wio(*qwioIter);
          wio.stationNameVector(r_snv);
          results.push_back(wio);
       }
    }
    else {

       //MGPWorkitemObject wio = MGPWorkitemObject(q_wi);
       MGPWorkitemObject wio(*qwioIter);
       wio.stationNameVector(r_snv);
       results.push_back(wio);
    }
  }
  return results;
}

MGPWorkitemObjectVector
MDBPostProcMgr::selectStationClass(
    MGPWorkitemObject& q_wio,            // original query object
    MGPWorkitemObjectVector& prev_wio)   // results from previous queries.
{
  MGPWorkitemObjectVector results;
  char* searchCriteria[] = {
    "codval",
    "codschdes"
  };

  MStationClassVector q_scv = q_wio.stationClassVector();
  if( q_scv.size() > 0) {
     MStationClass& sc = q_scv[0];

     for (MGPWorkitemObjectVector::iterator qwioIter = prev_wio.begin();
                qwioIter != prev_wio.end();
                qwioIter++) {

        MGPWorkitem q_wi = (*qwioIter).workitem();
        MStationClassVector r_scv;

        MCriteriaVector cv1;
        MCriteria c1;
        c1.attribute = "workitemkey";
        c1.oper      = TBL_EQUAL;
        c1.value     = q_wi.SOPInstanceUID();
        cv1.push_back(c1);

        const MDomainMap& dmap = sc.map();
        for(int i = 0; i < (int)DIM_OF(searchCriteria); i++) {
           MDomainMap::const_iterator scDomain = dmap.find(searchCriteria[i])
;
           MString s = (*scDomain).second;
           if( s != "") {
              TBL_OPERATOR oper = TBL_EQUAL;
              if (s.find("*") != string::npos) {
                 s.substitute('*', '%');
                 oper = TBL_LIKE;
              }
              MCriteria c;
              c.attribute = searchCriteria[i];
              c.oper      = oper;
              c.value     = s;
              cv1.push_back(c);
           }
        }

        MStationClass sc1;
        int nmatches = mDBInterface->select(sc1, cv1, stationClassCallback,&r_scv);
        if( nmatches > 0) {
           MGPWorkitemObject wio(*qwioIter);
           wio.stationClassVector(r_scv);
           results.push_back(wio);
        }
     }
   }
   else {
      results = prev_wio;
   }
  return results;
}

/*
 * Fill in the Input Info for each of the specified results.  We don't
 * match on any Input Info, just fill in appropriate values.
 */
void
MDBPostProcMgr::fillInputInfo(
    MGPWorkitemObjectVector& prev_wio)   // results from previous queries.
{
  for (MGPWorkitemObjectVector::iterator wioIter = prev_wio.begin();
             wioIter != prev_wio.end();
             wioIter++) {

     MGPWorkitem wi = (*wioIter).workitem();
     MInputInfoVector iiv;

     MCriteriaVector cv1;
     MCriteria c1;
     c1.attribute = "workitemkey";
     c1.oper      = TBL_EQUAL;
     c1.value     = wi.SOPInstanceUID();
     cv1.push_back(c1);

     MInputInfo ii;
     int nmatches = mDBInterface->select(ii, cv1, inputInfoCallback,&iiv);

     if( nmatches > 0) {
        (*wioIter).inputInfoVector(iiv);
     }
  }
}

int
MDBPostProcMgr::findPPS(const MString& sopinsuid, MGPPPSObject *pps)
{
  if (!mDBInterface)
    return -1;

  MCriteriaVector cv;
  MCriteria c;
  c.attribute = "sopinsuid";
  c.oper      = TBL_EQUAL;
  c.value     = sopinsuid;

  cv.push_back(c);

  MGPPPSWorkitem wi = pps->workitem();

  //int nrows = mDBInterface->select(wi, cv, NULL);
  int nrows = mDBInterface->select(wi, cv, ppsWorkitemCallback, &wi);

//cout << wi;

  if( nrows > 0) {
     pps->workitem(wi);
  }
  return nrows;
}

MString
MDBPostProcMgr::PPSstatus(const MString& sopinsuid)
{
  if (!mDBInterface)
    return NULL;

  MCriteriaVector cv;
  MCriteria c;
  c.attribute = "sopinsuid";
  c.oper      = TBL_EQUAL;
  c.value     = sopinsuid;

  cv.push_back(c);

  MGPPPSWorkitem wi;

  int nrows = mDBInterface->select(wi, cv, ppsWorkitemCallback, &wi);

  if( nrows > 0) {
    return wi.status();
  }
  MString s;
  return s;
}

void
MDBPostProcMgr::PPSstatus(const MString& sopinsuid, const MString& s)
{
  if (!mDBInterface)
    return;

  MCriteriaVector cv;
  MCriteria c;
  c.attribute = "sopinsuid";
  c.oper      = TBL_EQUAL;
  c.value     = sopinsuid;
  cv.push_back(c);

  MUpdateVector   uv;
  MUpdate         u;
  u.attribute = "status";
  u.func      = TBL_SET;
  u.value     = s;
  uv.push_back(u);

  MGPPPSWorkitem wi;
  mDBInterface->update( wi, cv, uv);
}

int
MDBPostProcMgr::findWorkitem(
    const MString& instanceUID,
    MGPWorkitem *result_wi)
{
  MGPWorkitem wi;
  wi.SOPInstanceUID(instanceUID);
  MCriteriaVector cv1;
  setCriteria( wi, cv1);

  int nmatches = mDBInterface->select(wi, cv1, workitemCallback2, result_wi);

  return nmatches;
}

void
MDBPostProcMgr::updateStatus(
    MGPWorkitem& result_wi,
    MGPWorkitem& msg_wi)
{
  MGPWorkitem wi;
  wi.SOPInstanceUID(result_wi.SOPInstanceUID());
  MCriteriaVector cv;
  setCriteria( wi, cv);

  result_wi.status(msg_wi.status());
  result_wi.transactionUID(msg_wi.transactionUID());
  MUpdateVector   uv;
  setCriteria( result_wi, uv);

  mDBInterface->update(result_wi, cv, uv);
}

void
MDBPostProcMgr::createPPS(
    MGPPPSObject& pps)
{
   pps.insert(*mDBInterface);
}

#if 0
void
MDBPostProcMgr::updatePPS(
    MGPPPSObject& pps)
{
   pps.update(*mDBInterface);
}
#endif


// **********************************************************************************************
// FOLLOWING ARE PRIVATE FUNCTIONS ONLY MEANT TO BE USED BY THE CLASS MEMBER FUNCTIONS THEMSELVES
// **********************************************************************************************

void
MDBPostProcMgr::addWorkitem(const MGPWorkitem& workitem)
{
  mDBInterface->insert(workitem);
}

void
MDBPostProcMgr::deleteRecord(const MGPWorkitem& workitem)
{
  MCriteriaVector cv;

  setCriteria(workitem, cv);
  mDBInterface->remove(workitem, cv);
}

void
MDBPostProcMgr::updateRecord(const MGPWorkitem& workitem)
{
  MCriteriaVector cv;
  MUpdateVector   uv;

  setCriteria(workitem, cv);
  setCriteria(workitem, uv);

  mDBInterface->update(workitem, cv, uv);
}

void
MDBPostProcMgr::setPPS( MGPPPSObject& pps)
{
  // we can update the scalar values in the workitem...
  MGPPPSWorkitem wi = pps.workitem();
  wi.update(mDBInterface);

  // but the easiest way to update the vector values is to remove and insert.
  // this is OK because the standard says that sequence items in the NSET
  // must always have a complete list of items. So, it ain't our fault if
  // we lose info.
  MOutputInfo oi;
  oi.workitemkey(wi.SOPInstanceUID());
  oi.dbremove(mDBInterface);
  
  MOutputInfoVector oiv = pps.outputInfoVector();
  for( MOutputInfoVector::iterator it = oiv.begin(); it != oiv.end(); it++) {
    //MOutputInfo *item = it;
    it->dbinsert(mDBInterface);
  }

  MReqSubsWorkitem rswi;
  rswi.workitemkey(wi.SOPInstanceUID());
  rswi.dbremove(mDBInterface);
  
  MReqSubsWorkitemVector rswiv = pps.reqSubsWorkitemVector();
  for( MReqSubsWorkitemVector::iterator it1 = rswiv.begin(); it1 != rswiv.end(); it1++) {
    //MReqSubsWorkitem *item = it1;
    it1->dbinsert(mDBInterface);
  }

  MNonDCMOutput ndo;
  ndo.workitemkey(wi.SOPInstanceUID());
  ndo.dbremove(mDBInterface);
  
  MNonDCMOutputVector ndov = pps.nonDCMOutputVector();
  for( MNonDCMOutputVector::iterator it2 = ndov.begin(); it2 != ndov.end(); it2++) {
    //MNonDCMOutput *item = it2;
    it2->dbinsert(mDBInterface);
  }

/*
  MCriteriaVector cv;

  MCriteria c;
  c.attribute = "workitemkey";
  c.oper      = TBL_EQUAL;
  c.value     = wi.SOPInstanceUID();
  cv.push_back(c);

  mDBInterface->remove(oi, cv);
*/
}

void
MDBPostProcMgr::setCriteria(const MGPWorkitem& workitem, MCriteriaVector& cv)
{
  MCriteria c;
  
  c.attribute = "sopinsuid";
  c.oper      = TBL_EQUAL;
  c.value     = workitem.SOPInstanceUID();
  cv.push_back(c);

}

void
MDBPostProcMgr::setCriteria(const MDomainObject& domainObject, MUpdateVector& uv)
{
  MUpdate u;
  MDomainMap m = domainObject.map();
  for (MDomainMap::iterator i = m.begin(); i != m.end(); i++)
  {
    u.attribute = (*i).first;
    u.func      = TBL_SET;
    u.value     = (*i).second;
    uv.push_back(u);
  }
}


/*
MString
MDBPostProcMgr::newStudyInstanceUID() const
{
  MString s;

  s = mIdentifier.dicomUID(MIdentifier::MUID_STUDY, *mDBInterface);

  return s;
}
*/
