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
#include "MOrder.hpp"
#include "MPlacerOrder.hpp"
#include "MPatient.hpp"
#include "MFillerOrder.hpp"
#include "MCodeItem.hpp"
#include "MSchedule.hpp"
#include "MActionItem.hpp"
#include "MIdentifier.hpp"
#include "MMWL.hpp"

using namespace std;

static void usage()
{
  char msg[] = "\
Usage: mesa_identifier <database> <identifier>\n\
\n\
  database     Name of database to use\n\
  identifier   Use one of: \n\
               accnum       Accession Number \n\
               account      Account number \n\
               fon          Filler Order Number \n\
               pid          Patient ID \n\
               pon          Placer Order Number \n\
               pps          Performed Procedure Step \n\
               req_proc_id  Requested Procedure ID \n\
               sps_id       Scheduled Procedure Step ID \n\
               visit        Visit Number \n\
               mcid         Message Control ID\n\
               appt         Appointment ID\n\
\n\
               transact_uid Transaction UID \n\
               sop_inst_uid SOP Instance UID\n\
               pps_uid      Performed Procedure Step UID\n\
               patient_uid  \n\
               visit_uid    \n\
               study_uid    \n\
               results_uid  \n\
               interp_uid   \n\
               printer_uid  \n\
               device_uid   \n\
               studycomponent_uid \n\
               series_uid   \n";

  cout << msg << endl;
  exit(1);
}

static MString getDate(void)
{
  char date[128] = "";
  ::UTL_GetDicomDate(date);
  date[8] = '\0';
  return date;
}

static MString getTime(void)
{
  char time[128] = "";
  ::UTL_GetDicomTime(time);
  time[6] = '\0';
  return time;
}

int main(int argc, char** argv)
{ 
  

   while (--argc > 0 && (*++argv)[0] == '-') {
    switch(*(argv[0] + 1)) {
    case 'a':
      break;
    default:
      break;
    }
  }
  if (argc < 2)
    usage();

  //scheduling will be done in the specified database
  MDBInterface dbInterface(*argv);
//  dbInterface = MDBInterface(*argv);
  argv++;
  
  MString name(*argv);
  MString f;
  MIdentifier id;

  if (name == "accnum") {
    f = id.mesaID(MIdentifier::MID_FILLERORDERNUMBER, dbInterface);
  } else if (name == "account") {
    f = id.mesaID(MIdentifier::MID_ACCOUNTNUMBER, dbInterface);
  } else if (name == "fon") {
    f = id.mesaID(MIdentifier::MID_FILLERORDERNUMBER, dbInterface);
  } else if (name == "pid") {
    f = id.mesaID(MIdentifier::MID_PATIENT, dbInterface);
  } else if (name == "pon") {
    f = id.mesaID(MIdentifier::MID_PLACERORDERNUMBER, dbInterface);
  } else if (name == "pps") {
    f = id.mesaID(MIdentifier::MID_PPSID, dbInterface);
  } else if (name == "appt") {
    f = id.mesaID(MIdentifier::MID_FILLERAPPOINTMENTID, dbInterface);
  } else if (name == "req_proc_id") {
    f = id.mesaID(MIdentifier::MID_REQUESTEDPROCEDURE, dbInterface);
  } else if (name == "sps_id") {
    f = id.mesaID(MIdentifier::MID_SPSID, dbInterface);
  } else if (name == "visit") {
    f = id.mesaID(MIdentifier::MID_VISITNUMBER, dbInterface);
  } else if (name == "mcid") {
    f = id.mesaID(MIdentifier::MID_MESSAGECONTROLID, dbInterface);
  } else if (name == "sop_inst_uid") {
    f = id.dicomUID(MIdentifier::MUID_SOPINSTANCE, dbInterface);
  } else if (name == "transact_uid") {
    f = id.dicomUID(MIdentifier::MUID_TRANSACTION, dbInterface);
  } else if (name == "pps_uid") {
    f = id.dicomUID(MIdentifier::MUID_PPS, dbInterface);
  } else if (name == "patient_uid") {
    f = id.dicomUID(MIdentifier::MUID_PATIENT , dbInterface);
  } else if (name == "visit_uid") {
    f = id.dicomUID(MIdentifier::MUID_VISIT, dbInterface);
  } else if (name == "study_uid") {
    f = id.dicomUID(MIdentifier::MUID_STUDY, dbInterface);
  } else if (name == "results_uid") {
    f = id.dicomUID(MIdentifier::MUID_RESULTS, dbInterface);
  } else if (name == "interp_uid") {
    f = id.dicomUID(MIdentifier::MUID_INTERP, dbInterface);
  } else if (name == "printer_uid") {
    f = id.dicomUID(MIdentifier::MUID_PRINTER, dbInterface);
  } else if (name == "device_uid") {
    f = id.dicomUID(MIdentifier::MUID_DEVICE, dbInterface);
  } else if (name == "studycomponent_uid") {
    f = id.dicomUID(MIdentifier::MUID_STUDYCOMPONENT, dbInterface);
  } else if (name == "series_uid") {
    f = id.dicomUID(MIdentifier::MUID_SERIES, dbInterface);
  } else if (name == "date") {
    f = getDate();
  } else if (name == "time") {
    f = getTime();
  } else {
    usage();
  }

  cout << f << endl;

  return 0;
}
