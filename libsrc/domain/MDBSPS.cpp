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
#include "MDBSPS.hpp"
#include "MSPS.hpp"
#include "ctn_api.h"

MDBSPS::MDBSPS()
{
}

MDBSPS::MDBSPS(const MDBSPS& cpy)
{
}

MDBSPS::~MDBSPS()
{
}

void
MDBSPS::printOn(ostream& s) const
{
  s << "MDBSPS";
}

void
MDBSPS::streamIn(istream& s)
{
  //s >> this->member;
}

// Non-boilerplate methods follow

MDBSPS::MDBSPS(const string& databaseName)
{
  this->open(databaseName, "sps");
}

typedef struct {
  char spStepID[21];
  char sStationAETitle[61];
  char spStepStartDate[13];
  char spStepStartTime[13];
  char modality[31];
  char sPerformingPhysicianName[61];
  char spStepDescription[101];
  char spStepLocation[31];
  char preMedication[31];
  char requestedContrastAgent[31];
} SCHEDULED_PROCEDURE_STEP_STRUCT;

MDBSPS::insert(const MSPS& schProcStep)
{
  SCHEDULED_PROCEDURE_STEP_STRUCT sps;
  TBL_FIELD f[] = {
    { "spsid", TBL_STRING, sizeof(sps.spStepID), sizeof(sps.spStepID), 0,
      sps.spStepID},
    { "schaet", TBL_STRING, sizeof(sps.sStationAETitle), sizeof(sps.sStationAETitle), 0,
      sps.sStationAETitle},
    { "spsstadat", TBL_STRING, sizeof(sps.spStepStartDate),
      sizeof(sps.spStepStartDate), 0, sps.spStepStartDate},
    { "spsstatim", TBL_STRING, sizeof(sps.spStepStartTime),
      sizeof(sps.spStepStartTime), 0, sps.spStepStartTime},
    { "mod", TBL_STRING, sizeof(sps.modality), sizeof(sps.modality), 0,
      sps.modality},
    { "schperphynam", TBL_STRING, sizeof(sps.sPerformingPhysicianName),
      sizeof(sps.sPerformingPhysicianName), 0, sps.sPerformingPhysicianName},
    { "spsdes", TBL_STRING, sizeof(sps.spStepDescription), 
      sizeof(sps.spStepDescription), 0, sps.spStepDescription},
    { "spsloc", TBL_STRING, sizeof(sps.spStepLocation),
      sizeof(sps.spStepLocation), 0, sps.spStepLocation},
    { "premed", TBL_STRING, sizeof(sps.preMedication), sizeof(sps.preMedication), 0,
      sps.preMedication},
    { "reqconage", TBL_STRING, sizeof(sps.requestedContrastAgent),
      sizeof(sps.requestedContrastAgent), 0, sps.requestedContrastAgent},
    { 0, TBL_STRING, 0, 0, 0, 0 }
  };

  this->safeExport(schProcStep.scheduledProcedureStepID(), sps.spStepID, 
                   sizeof(sps.spStepID));
  this->safeExport(schProcStep.scheduledAETitle(), sps.sStationAETitle, 
                   sizeof(sps.sStationAETitle));
  this->safeExport(schProcStep.sPSStartDate(), sps.spStepStartDate, 
                   sizeof(sps.spStepStartDate));
  this->safeExport(schProcStep.sPSStartTime(), sps.spStepStartTime, 
                   sizeof(sps.spStepStartTime));
  this->safeExport(schProcStep.modality(), sps.modality, sizeof(sps.modality));
  this->safeExport(schProcStep.scheduledPerformingPhysicianName(),
                   sps.sPerformingPhysicianName,
                   sizeof(sps.sPerformingPhysicianName));
  this->safeExport(schProcStep.sPSDescription(), sps.spStepDescription, 
                   sizeof(sps.spStepDescription));
  this->safeExport(schProcStep.sPSLocation(), sps.spStepLocation, 
                   sizeof(sps.spStepLocation));
  this->safeExport(schProcStep.preMedication(), sps.preMedication, 
                   sizeof(sps.preMedication));
  this->safeExport(schProcStep.requestedContrastAgent(), sps.requestedContrastAgent, 
                   sizeof(sps.requestedContrastAgent));

  this->insertRow(f);
}
