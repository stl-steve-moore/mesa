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

// 
#include "MESA.hpp"
#include "MDomainObject.hpp"
#include "MDBInterface.hpp"
#include "MIdentifier.hpp"
#include "ctn_api.h"
#include "MGPWorkitemObject.hpp"
#include "MGPPPSObject.hpp"
#include "MGPPPSWorkitem.hpp"
#include "MDICOMDomainXlate.hpp"

#include <fstream>

using namespace std;

static void usage()
{
  //char msg[] = "Usage: ppm_sched_gppps -s <sps SOP Instance UID> -t <gpppsfile template (dicom object)> [-o <pps_sopinsuid_outputfile>] <ppwf_database>";
  char msg[] = 
     "Usage: ppm_sched_gppps \n \
     -s <referenced GP SPS SOP Instance UID> \n \
     -t <gpppsfile template (dicom object)> \n \
     -o <pps_outputfile> \n \
     -i <pps_sopinsuid_outputfile> \n \
     <ppwf_database>  (name of database containing the ppwf tables \n \
     <identifiers_database> (name of database containing the identifiers table";

  cerr << msg << endl;
  exit(1);
}

typedef struct {
  MDBInterface ordfil_dbInterface;
  MDBInterface ppwf_dbInterface;
  MGPWorkitemVector wiv;
  MGPWorkitemObject wio;
  MGPPPSObject pps;
} st_dbInterface;
  

void getSpecificGPWorkitem(MDomainObject& o, void* ctx)
{
  st_dbInterface * db = (st_dbInterface*)ctx;
  MGPWorkitem wi;
  wi.import(o);
  db->wiv.push_back(wi);
}


static void
createPPS_old( st_dbInterface& db, MString& spsUID ) 
{
  MGPWorkitem sps_wi;
  MString query = spsUID + "%";
  MCriteriaVector cv;
  MCriteria c;
  c.attribute = "sopinsuid";
  c.oper = TBL_LIKE;
  c.value = query;
  cv.push_back(c);

  db.ppwf_dbInterface.select(sps_wi, cv, getSpecificGPWorkitem, &db);

  int nWorkitems = db.wiv.size();
  if( nWorkitems == 0) {
     cout << "Error: No general purpose SPSs with instance UID: ";
     cout << spsUID << "\n";
     exit(1);
  }
  if( nWorkitems > 1) {
     cout << "Error: multiple general purpose SPSs with same instance UID: ";
     cout << spsUID << "\n";
     exit(1);
  }

  sps_wi = (MGPWorkitem) db.wiv[0];

//cout << sps_wi;

  MGPPPSWorkitem pps_wi = db.pps.workitem();

  MIdentifier identifier;
  MString s;

  s = identifier.mesaID(MIdentifier::MID_PPSID, db.ordfil_dbInterface);
  //s = identifier.mesaID(MIdentifier::MID_REQUESTEDPROCEDURE, db.ordfil_dbInterface);
  pps_wi.procedureStepID(s);

  pps_wi.patientName(sps_wi.patientName());
  pps_wi.patientID(sps_wi.patientID());
  pps_wi.patientBirthDate(sps_wi.patientBirthDate());
  pps_wi.patientSex(sps_wi.patientSex());
  
  db.pps.workitem(pps_wi);

  MRefGPSPS refSPS;
  refSPS.sopClassUID(sps_wi.SOPClassUID());
  refSPS.sopInstanceUID(sps_wi.SOPInstanceUID());
  refSPS.transactionUID(sps_wi.transactionUID());
  MRefGPSPSVector v;
  v.push_back(refSPS);
  db.pps.refGPSPSVector(v);

  s = identifier.dicomUID(MIdentifier::MUID_GPPPS, db.ordfil_dbInterface);
  db.pps.SOPInstanceUID(s);

//cout << db.pps;

  db.pps.insert(db.ppwf_dbInterface);
}

static int
createPPS( st_dbInterface& db, MString& spsUID, MDICOMWrapper& w,
		MString& ppsInstanceUID,
		MDICOMWrapper& workItem,
		MDICOMWrapper& claimFile)
{
#if 0
  MGPWorkitem sps_wi;
  MString query = spsUID + "%";
  MCriteriaVector cv;
  MCriteria c;
  c.attribute = "sopinsuid";
  c.oper = TBL_LIKE;
  c.value = query;
  cv.push_back(c);

  db.ppwf_dbInterface.select(sps_wi, cv, getSpecificGPWorkitem, &db);

  int nWorkitems = db.wiv.size();
  if( nWorkitems == 0) {
     cout << "Error: No general purpose SPSs with instance UID: ";
     cout << spsUID << "\n";
     exit(1);
  }
  if( nWorkitems > 1) {
     cout << "Error: multiple general purpose SPSs with same instance UID: ";
     cout << spsUID << "\n";
     exit(1);
  }

  sps_wi = (MGPWorkitem) db.wiv[0];

//cout << sps_wi;

  MGPPPSWorkitem pps_wi = db.pps.workitem();
#endif

  MIdentifier identifier;
  MString s;
  DCM_TAG tag, seqtag;

  // Referenced Request Sequence
  //s = sps_wi.inputStudyInstanceUID();		// Study Instance UID
  s = workItem.getString(0x0020000d);
  w.setString(0x0040a370, 0x0020000D, s);

  //s = sps_wi.requestedProcAccessionNum();	// Accession Number
  s = workItem.getString(0x0040a370, 0x00080050);	// Accession Number
  w.setString(0x0040a370, 0x00080050, s);

  //s = sps_wi.requestedProcID();		// Procedure ID
  s = workItem.getString(0x0040a370, 0x00401001);		// Procedure ID
  w.setString(0x0040a370, 0x00401001, s);

  // PPS ID
  s = identifier.mesaID(MIdentifier::MID_PPSID, db.ordfil_dbInterface);
  tag = 0x00400253;
  w.setString( tag, s);

  // Patient Name
  tag = 0x00100010;
  s = workItem.getString(tag);
  w.setString( tag, s );
  //w.setString( tag, sps_wi.patientName());

  // Patient ID
  tag = 0x00100020;
  s = workItem.getString(tag);
  w.setString( tag, s );

  // Patient Birthdate
  tag = 0x00100030;
  s = workItem.getString(tag);
  w.setString( tag, s );
  //w.setString( tag, sps_wi.patientBirthDate());

  // Patient Sex
  tag = 0x00100040;
  s = workItem.getString(tag);
  w.setString( tag, s );
  //w.setString( tag, sps_wi.patientSex());

  // Referenced SPS Seq
  s = workItem.getString(0x00080016);
  seqtag = 0x00404016;
  tag = 0x00081150;     // Referenced SOP Class UID
  w.setString( seqtag, tag, s, 1);
  //w.setString( seqtag, tag, sps_wi.SOPClassUID(), 1);

  s = workItem.getString(0x00080018);
  tag = 0x00081155;     // Referenced SOP Instance UID
  w.setString( seqtag, tag, s, 1);
  //w.setString( seqtag, tag, sps_wi.SOPInstanceUID(), 1);

  s = claimFile.getString(0x00081195);
  tag = 0x00404023;     // Referenced GPSPS Transaction UID
  //w.setString( seqtag, tag, sps_wi.transactionUID(), 1);
  w.setString( seqtag, tag, s, 1);

  // GP PPS SOP Instance UID
  s = identifier.dicomUID(MIdentifier::MUID_GPPPS, db.ordfil_dbInterface);
  ppsInstanceUID = s;
  //tag = 0x00080018;
  //w.setString( tag, s);
  return 0;
}

int main(int argc, char** argv)
{ 
  
  st_dbInterface db;

  MString spsUID;      // SOP Instanceu UID of SPS to which this PPS applies.
  MString pps_fname;   // GPPPS dicom object file with input values.
  MString id_fname;    // file to record SOPinstanceUID of created GPPPS
  MString out_fname;   // output file for GP PPS object.
  MString workItemFileName;	// Response file with scheduled workitem.
  MString claimFileName;	// NAction file with claim request

  while (--argc > 0 && (*++argv)[0] == '-') {
    switch(*(argv[0] + 1)) {
    case 'c':
      argc--; argv++;
      if (argc < 1)
	usage();
      claimFileName = MString(*argv);
      break;
    case 'i':
      argc--; argv++;
      if (argc < 1)
	usage();
      id_fname = MString(*argv);
      break;
    case 'o':
      argc--; argv++;
      if (argc < 1)
	usage();
      out_fname = MString(*argv);
      break;
    case 's':
      argc--; argv++;
      if (argc < 1)
	usage();
      spsUID = MString(*argv);
      break;
    case 't':
      argc--; argv++;
      if (argc < 1)
	usage();
      pps_fname = MString(*argv);
      break;
    case 'w':
      argc--; argv++;
      if (argc < 1)
	usage();
      workItemFileName = MString(*argv);
      break;
    default:
      break;
    }
  }
  if (argc < 2)
    usage();

  //scheduling will be done in the specified database
  db.ppwf_dbInterface = MDBInterface(*argv++);
  db.ordfil_dbInterface = MDBInterface(*argv);

  MDICOMWrapper w(pps_fname);
  MDICOMWrapper workItem;
  if (workItem.open(workItemFileName) != 0) {
    cout << "Unable to open work item file from GPWL query: " << workItemFileName << endl;
    return 1;
  }
  MDICOMWrapper claimFile;
  if (claimFile.open(claimFileName) != 0) {
    cout << "Unable to open NAction request with claim: " << claimFileName << endl;
    return 1;
  }

  MString ppsInstanceUID;
  if (createPPS( db, spsUID, w, ppsInstanceUID, workItem, claimFile ) != 0) {
    cout << "Unable to create PPS object" << endl;
    return 1;
  }

  if( out_fname != "") {
     w.saveAs(out_fname);
  }

  if( id_fname != "") {
     ofstream os(id_fname.strData());
     os << ppsInstanceUID;
  }

  return 0;
}

