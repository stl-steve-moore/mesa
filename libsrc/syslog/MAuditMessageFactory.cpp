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

#include "ctn_os.h"
#include "MESA.hpp"
#include "MAuditMessageFactory.hpp"
#include "MAuditMessage.hpp"
#include "MFileOperations.hpp"
#include "MDateTime.hpp"
#include "MLogClient.hpp"

#include <strstream>

static char rcsid[] = "$Id: MAuditMessageFactory.cpp,v 1.26 2004/11/05 16:17:59 ssurul01 Exp $";

MAuditMessageFactory::MAuditMessageFactory()
{
}

MAuditMessageFactory::MAuditMessageFactory(const MAuditMessageFactory& cpy)
{
}

MAuditMessageFactory::~MAuditMessageFactory()
{
}

void
MAuditMessageFactory::printOn(ostream& s) const
{
  s << "MAuditMessageFactory";
}

void
MAuditMessageFactory::streamIn(istream& s)
{
  //s >> this->member;
}

// Non boiler plate methods follow

MAuditMessage*
MAuditMessageFactory::produceMessage(const MString& msgType, const MString& fileName)
{
  MFileOperations f;
  MStringMap mp;
  if (f.readParamsMap(fileName, mp, '_') != 0) {
    MLogClient logClient;
    logClient.log(MLogClient::MLOG_ERROR, "",
	"MAuditMessageFactory::produceMessage", __LINE__,
	MString("Unable to produce message of type: " + msgType),
	MString(" ;could not read file: ") + fileName);
    return 0;
  }

  if (msgType == "STARTUP") {
    return this->produceStartup(mp);
  } else if (msgType == "CONFIGURATION") {
    return this->produceActorConfig(mp);
  } else if (msgType == "PATIENT_RECORD") {
    return this->producePatientRecord(mp);
  } else if (msgType == "PROCEDURE_RECORD") {
    return this->produceProcedureRecord(mp);
  } else if (msgType == "MWL_PROVIDED") {
    return this->produceModalityWorklistProvided(mp);
  } else if (msgType == "BEGIN_STORING_INSTANCES") {
    return this->produceBeginStoringInstances(mp);
  } else if (msgType == "INSTANCES_SENT") {
    return this->produceInstancesSent(mp);
  } else if (msgType == "INSTANCES_USED") {
    return this->produceInstancesUsed(mp);
  } else if (msgType == "NODE_AUTHENTICATION_FAILURE") {
    return this->produceNodeAuthenticationFailure(fileName);
  } else if (msgType == "USER_AUTHENTICATED") {
    return this->produceUserAuthenticated(mp);
  } else if (msgType == "DICOM_QUERY") {
    return this->produceDICOMQuery(mp);
  } else if (msgType == "INSTANCES_STORED") {
    return this->produceInstancesStored(mp);
  } else if (msgType == "ATNA_STARTUP") {
    return this->produceAtnaStartup(mp);
  } else if (msgType == "ATNA_CONFIGURATION") {
    return this->produceAtnaActorConfig(mp);
  } else if (msgType == "ATNA_USER_AUTHENTICATED") {
    return this->produceAtnaUserAuthenticated(mp);
  } else if (msgType == "ATNA_PATIENT_RECORD") {
    return this->produceAtnaPatientRecord(mp);
  } else {
    return 0;
  }
}

// Private methods appear below this line

#define MESSAGE_SIZE 1024
#define AUDIT_MESSAGE_NAME "IHEYr4"

MAuditMessage*
MAuditMessageFactory::produceStartup(MStringMap& mp)
{
  char buffer[MESSAGE_SIZE+1];
  strstream s(buffer, sizeof(buffer));

  MString actorName = mp["ACTOR_NAME"];
  MString localUser = mp["LOCAL_USER"];
  MString host = mp["HOST"];

  MDateTime dt;
  MString timeStamp = "";
  dt.formatXSDateTime(timeStamp);

  s << "<" << AUDIT_MESSAGE_NAME << ">" << endl;

  s << " <ActorStartStop>" << endl;
  s << "  <ActorName>" << actorName << "</ActorName>" << endl;
  s << "  <ApplicationAction>Start</ApplicationAction>" << endl;
  s << "  <User><LocalUser>" << localUser << "</LocalUser></User>" << endl;
  s << " </ActorStartStop>" << endl;

  s << " <Host>" << host << "</Host>" << endl;
  s << " <TimeStamp>" << timeStamp << "</TimeStamp>" << endl;
  s << "</" << AUDIT_MESSAGE_NAME << ">" << endl;
  s << '\0';

  MAuditMessage* m = new MAuditMessage(buffer);

  return m;
}

MAuditMessage*
MAuditMessageFactory::produceActorConfig(MStringMap& mp)
{
  char buffer[MESSAGE_SIZE+1];
  strstream s(buffer, sizeof(buffer));

  //MString action = mp["ACTION"];
  MString description = mp["DESCRIPTION"];
  MString localUser = mp["LOCAL_USER"];
  MString host = mp["HOST"];
  MString configType = mp["CONFIG_TYPE"];

  MDateTime dt;
  MString timeStamp = "";
  dt.formatXSDateTime(timeStamp);

  s << "<" << AUDIT_MESSAGE_NAME << ">" << endl;

  s << " <ActorConfig>" << endl;
  s << "  <Description>" << description << "</Description>" << endl;
  s << "  <User><LocalUser>" << localUser << "</LocalUser></User>" << endl;
  s << "  <ConfigType>" << configType << "</ConfigType>" << endl;
  s << " </ActorConfig>" << endl;

  s << " <Host>" << host << "</Host>" << endl;
  s << " <TimeStamp>" << timeStamp << "</TimeStamp>" << endl;
  s << "</" << AUDIT_MESSAGE_NAME << ">" << endl;
  s << '\0';

  MAuditMessage* m = new MAuditMessage(buffer);

  return m;
}

MAuditMessage*
MAuditMessageFactory::producePatientRecord(MStringMap& mp)
{
  char buffer[MESSAGE_SIZE+1];
  strstream s(buffer, sizeof(buffer));

  MString action = mp["OBJECT_ACTION"];
  MString patientID = mp["PATIENT_ID"];
  MString patientName = mp["PATIENT_NAME"];
  MString localUser = mp["LOCAL_USER"];
  MString host = mp["HOST"];

  MDateTime dt;
  MString timeStamp = "";
  dt.formatXSDateTime(timeStamp);

  s << "<" << AUDIT_MESSAGE_NAME << ">" << endl;

  s << " <PatientRecord>" << endl;
  s << "  <ObjectAction>" << action << "</ObjectAction>" << endl;
  s << "  <Patient>" << endl;
  s << "   <PatientID>" << patientID << "</PatientID>" << endl;
  s << "   <PatientName>" << patientName << "</PatientName>" << endl;
  s << "  </Patient>" << endl;
  s << "  <User><LocalUser>" << localUser << "</LocalUser></User>" << endl;
  s << " </PatientRecord>" << endl;

  s << " <Host>" << host << "</Host>" << endl;
  s << " <TimeStamp>" << timeStamp << "</TimeStamp>" << endl;
  s << "</" << AUDIT_MESSAGE_NAME << ">" << endl;
  s << '\0';

  MAuditMessage* m = new MAuditMessage(buffer);

  return m;
}

MAuditMessage*
MAuditMessageFactory::produceProcedureRecord(MStringMap& mp)
{
  char buffer[MESSAGE_SIZE+1];
  strstream s(buffer, sizeof(buffer));


  MString objectAction = mp["OBJECT_ACTION"];
  MString placerOrderNumber = mp["PLACER_ORDER_NUMBER"];
  MString fillerOrderNumber= mp["FILLER_ORDER_NUMBER"];
  MString studyUID = mp["STUDY_UID"];
  MString accessionNumber = mp["ACCESSION_NUMBER"];
  MString patientID = mp["PATIENT_ID"];
  MString patientName = mp["PATIENT_NAME"];

  MString localUser = mp["LOCAL_USER"];
  MString host = mp["HOST"];

  MDateTime dt;
  MString timeStamp = "";
  dt.formatXSDateTime(timeStamp);

  s << "<" << AUDIT_MESSAGE_NAME << ">" << endl;

  s << " <ProcedureRecord>" << endl;
  s << "  <ObjectAction>" << objectAction << "</ObjectAction>" << endl;
  s << "  <PlacerOrderNumber>" << placerOrderNumber << "</PlacerOrderNumber>" << endl;
  s << "  <FillerOrderNumber>" << fillerOrderNumber << "</FillerOrderNumber>" << endl;
  s << "  <SUID>" << studyUID << "</SUID>" << endl;
  s << "  <AccessionNumber>" << accessionNumber << "</AccessionNumber>" << endl;

  s << "  <Patient>" << endl;
  s << "   <PatientID>" << patientID << "</PatientID>" << endl;
  s << "   <PatientName>" << patientName << "</PatientName>" << endl;
  s << "  </Patient>" << endl;

  s << "  <User><LocalUser>" << localUser << "</LocalUser></User>" << endl;
  s << " </ProcedureRecord>" << endl;

  s << " <Host>" << host << "</Host>" << endl;
  s << " <TimeStamp>" << timeStamp << "</TimeStamp>" << endl;
  s << "</" << AUDIT_MESSAGE_NAME << ">" << endl;
  s << '\0';

  MAuditMessage* m = new MAuditMessage(buffer);

  return m;
}

MAuditMessage*
MAuditMessageFactory::produceModalityWorklistProvided(MStringMap& mp)
{
  char buffer[MESSAGE_SIZE+1];
  strstream s(buffer, sizeof(buffer));


  MString action = mp["OBJECT_ACTION"];
  MString placerOrderNumber = mp["PLACER_ORDER_NUMBER"];
  MString fillerOrderNumber= mp["FILLER_ORDER_NUMBER"];
  MString studyUID = mp["STUDY_UID"];
  MString accessionNumber = mp["ACCESSION_NUMBER"];
  MString patientID = mp["PATIENT_ID"];
  MString patientName = mp["PATIENT_NAME"];

  MString localUser = mp["LOCAL_USER"];
  MString hostName = mp["HOST_NAME"];

  s << "<" << AUDIT_MESSAGE_NAME << ">" << endl;

  s << " <Modality-worklist-provided>" << endl;
#if 0
  s << "  <Object-Action>" << action << "</Object-Action>" << endl;
  s << "  <Placer-order-number>" << placerOrderNumber << "</Placer-order-number>" << endl;
  s << "  <Filler-order-number>" << fillerOrderNumber << "</Filler-order-number>" << endl;
  s << "  <Study-uid>" << studyUID << "</Study-uid>" << endl;
  s << "  <Accession-number>" << accessionNumber << "</Accession-number>" << endl;

  s << "  <Patient-info>" << endl;
  s << "   <Patient-ID>" << patientID << "</Patient-ID>" << endl;
  s << "   <Patient-name>" << patientName << "</Patient-name>" << endl;
  s << "  </Patient-info>" << endl;

  s << "  <User><local-User>" << localUser << "</local-User></User>" << endl;
#endif

  s << " </Modality-worklist-provided>" << endl;

  s << " <Hostname>" << hostName << "</Hostname>" << endl;
  s << "</" << AUDIT_MESSAGE_NAME << ">" << endl;
  s << '\0';

  MAuditMessage* m = new MAuditMessage(buffer);

  return m;
}

MAuditMessage*
MAuditMessageFactory::produceBeginStoringInstances(MStringMap& mp)
{
  char buffer[MESSAGE_SIZE+1];
  strstream s(buffer, sizeof(buffer));

  MString remoteIPAddress = mp["REMOTE_IP_ADDRESS"];
  MString remoteHostname = mp["REMOTE_HOSTNAME"];
  MString remoteAETitle = mp["REMOTE_AE_TITLE"];

  MString objectAction = mp["OBJECT_ACTION"];
  MString accessionNumber = mp["ACCESSION_NUMBER"];
  MString studyUID = mp["STUDY_UID"];
  MString patientID = mp["PATIENT_ID"];
  MString patientName = mp["PATIENT_NAME"];
  MString localUser = mp["LOCAL_USER"];
  MString sopClassUID = mp["SOP_CLASS_UID"];
  //MString numberOfInstances = mp["NUMBER_OF_INSTANCES"];
  MString mppsUID = mp["MPPS_UID"];

  MString host = mp["HOST"];

  MDateTime dt;
  MString timeStamp = "";
  dt.formatXSDateTime(timeStamp);

  s << "<" << AUDIT_MESSAGE_NAME << ">" << endl;

  s << " <BeginStoringInstances>" << endl;
  s << "  <RNode>" << endl;
  s << "   <IP>" << remoteIPAddress << "</IP>" << endl;
  s << "   <Hname>" << remoteHostname << "</Hname>" << endl;
  s << "   <AET>" << remoteAETitle << "</AET>" << endl;
  s << "  </RNode>" << endl;

  s << "  <InstanceActionDescription>" << endl;
  s << "   <ObjectAction>" << objectAction << "</ObjectAction>" << endl;
  s << "   <AccessionNumber>" << accessionNumber << "</AccessionNumber>" << endl;
  s << "   <SUID>" << studyUID << "</SUID>" << endl;

  s << "   <Patient>" << endl;
  s << "    <PatientID>" << patientID << "</PatientID>" << endl;
  s << "    <PatientName>" << patientName << "</PatientName>" << endl;
  s << "   </Patient>" << endl;

  s << "   <User><LocalUser>" << localUser << "</LocalUser></User>" << endl;
  s << "   <CUID>" << sopClassUID << "</CUID>" << endl;
//  s << "   <NumberOfInstances>" << numberOfInstances << "</NumberOfInstances>" << endl;
  s << "   <MPPSUID>" << mppsUID << "</MPPSUID>" << endl;
  s << "  </InstanceActionDescription>" << endl;

  s << " </BeginStoringInstances>" << endl;

  s << " <Host>" << host << "</Host>" << endl;
  s << " <TimeStamp>" << timeStamp << "</TimeStamp>" << endl;
  s << "</" << AUDIT_MESSAGE_NAME << ">" << endl;
  s << '\0';

  MAuditMessage* m = new MAuditMessage(buffer);

  return m;
}

MAuditMessage*
MAuditMessageFactory::produceInstancesSent(MStringMap& mp)
{
  char buffer[MESSAGE_SIZE+1];
  strstream s(buffer, sizeof(buffer));

  MString remoteIPAddress = mp["REMOTE_IP_ADDRESS"];
  MString remoteHostname = mp["REMOTE_HOSTNAME"];
  MString remoteAETitle = mp["REMOTE_AE_TITLE"];

  MString objectAction = mp["OBJECT_ACTION"];
  MString accessionNumber = mp["ACCESSION_NUMBER"];
  MString studyUID = mp["STUDY_UID"];
  MString patientID = mp["PATIENT_ID"];
  MString patientName = mp["PATIENT_NAME"];
  MString localUser = mp["LOCAL_USER"];
  MString sopClassUID = mp["SOP_CLASS_UID"];
  MString numberOfInstances = mp["NUMBER_OF_INSTANCES"];
  MString mppsUID = mp["MPPS_UID"];

  MDateTime dt;
  MString timeStamp = "";
  dt.formatXSDateTime(timeStamp);

  MString host = mp["HOST"];

  s << "<" << AUDIT_MESSAGE_NAME << ">" << endl;

  s << " <InstancesSent>" << endl;
  s << "  <RNode>" << endl;
  s << "   <IP>" << remoteIPAddress << "</IP>" << endl;
  s << "   <Hname>" << remoteHostname << "</Hname>" << endl;
  s << "   <AET>" << remoteAETitle << "</AET>" << endl;
  s << "  </RNode>" << endl;

  s << "  <InstanceActionDescription>" << endl;
  s << "   <ObjectAction>" << objectAction << "</ObjectAction>" << endl;
  s << "   <AccessionNumber>" << accessionNumber << "</AccessionNumber>" << endl;
  s << "   <SUID>" << studyUID << "</SUID>" << endl;

  s << "   <Patient>" << endl;
  s << "    <PatientID>" << patientID << "</PatientID>" << endl;
  s << "    <PatientName>" << patientName << "</PatientName>" << endl;
  s << "   </Patient>" << endl;

  s << "   <User><LocalUser>" << localUser << "</LocalUser></User>" << endl;
  s << "   <CUID>" << sopClassUID << "</CUID>" << endl;
  s << "   <NumberOfInstances>" << numberOfInstances << "</NumberOfInstances>" << endl;
  if (mppsUID != "") {
    s << "   <MPPSUID>" << mppsUID << "</MPPSUID>" << endl;
  }
  s << "  </InstanceActionDescription>" << endl;

  s << " </InstancesSent>" << endl;

  s << " <Host>" << host << "</Host>" << endl;
  s << " <TimeStamp>" << timeStamp << "</TimeStamp>" << endl;
  s << "</" << AUDIT_MESSAGE_NAME << ">" << endl;
  s << '\0';

  MAuditMessage* m = new MAuditMessage(buffer);

  return m;
}

MAuditMessage*
MAuditMessageFactory::produceInstancesUsed(MStringMap& mp)
{
  char buffer[MESSAGE_SIZE+1];
  strstream s(buffer, sizeof(buffer));

  MString objectAction = mp["OBJECT_ACTION"];
  MString accessionNumber = mp["ACCESSION_NUMBER"];
  MString studyUID = mp["STUDY_UID"];
  MString patientID = mp["PATIENT_ID"];
  MString patientName = mp["PATIENT_NAME"];
  MString localUser = mp["LOCAL_USER"];
  MString sopClassUID = mp["SOP_CLASS_UID"];
  //MString numberOfInstances = mp["NUMBER_OF_INSTANCES"];
  MString mppsUID = mp["MPPS_UID"];

  MString host = mp["HOST"];

  MDateTime dt;
  MString timeStamp = "";
  dt.formatXSDateTime(timeStamp);

  s << "<" << AUDIT_MESSAGE_NAME << ">" << endl;

  s << " <DICOMInstancesUsed>" << endl;
  s << "  <ObjectAction>" << objectAction << "</ObjectAction>" << endl;
  s << "  <AccessionNumber>" << accessionNumber << "</AccessionNumber>" << endl;
  s << "  <SUID>" << studyUID << "</SUID>" << endl;

  s << "  <Patient>" << endl;
  s << "   <PatientID>" << patientID << "</PatientID>" << endl;
  s << "   <PatientName>" << patientName << "</PatientName>" << endl;
  s << "  </Patient>" << endl;

  s << "  <User><LocalUser>" << localUser << "</LocalUser></User>" << endl;
  s << "  <CUID>" << sopClassUID << "</CUID>" << endl;
//  s << "  <number-of-instances>" << numberOfInstances << "</number-of-instances>" << endl;
  s << "  <MPPSUID>" << mppsUID << "</MPPSUID>" << endl;

  s << " </DICOMInstancesUsed>" << endl;

  s << " <Host>" << host << "</Host>" << endl;
  s << " <TimeStamp>" << timeStamp << "</TimeStamp>" << endl;
  s << "</" << AUDIT_MESSAGE_NAME << ">" << endl;
  s << '\0';

  MAuditMessage* m = new MAuditMessage(buffer);

  return m;
}

MAuditMessage*
MAuditMessageFactory::produceNodeAuthenticationFailure(const MString& fileName)
{
  char buffer[MESSAGE_SIZE+1];

  strstream s(buffer, sizeof(buffer));

  s << "<" << AUDIT_MESSAGE_NAME << ">" << endl;
  s << " <Node-authentication-failure>" << endl;
  s << " </Node-authentication-failure>" << endl;
  s << "</" << AUDIT_MESSAGE_NAME << ">" << endl;
  s << '\0';

  MAuditMessage* m = new MAuditMessage(buffer);

  return m;
}

MAuditMessage*
MAuditMessageFactory::produceUserAuthenticated(MStringMap& mp)
{
  char buffer[MESSAGE_SIZE+1];
  strstream s(buffer, sizeof(buffer));

  MString localUser = mp["LOCAL_USER"];
  MString host  = mp["HOST"];
  MString action    = mp["ACTION"];

  MDateTime dt;
  MString timeStamp = "";
  dt.formatXSDateTime(timeStamp);

  s << "<" << AUDIT_MESSAGE_NAME << ">" << endl;

  s << " <UserAuthenticated>" << endl;
  s << "  <LocalUsername>" << localUser << "</LocalUsername>" << endl;
  s << "  <Action>" << action << "</Action>" << endl;
  s << " </UserAuthenticated>" << endl;

  s << " <Host>" << host << "</Host>" << endl;
  s << " <TimeStamp>" << timeStamp << "</TimeStamp>" << endl;
  s << "</" << AUDIT_MESSAGE_NAME << ">" << endl;
  s << '\0';

  MAuditMessage* m = new MAuditMessage(buffer);

  return m;
}

MAuditMessage*
MAuditMessageFactory::produceDICOMQuery(MStringMap& mp)
{
  char buffer[MESSAGE_SIZE+1];
  strstream s(buffer, sizeof(buffer));

  MString queryKeys = mp["QUERY_KEYS"];

  MString remoteIPAddress = mp["REMOTE_IP_ADDRESS"];
  MString remoteHostname = mp["REMOTE_HOSTNAME"];
  MString remoteAETitle = mp["REMOTE_AE_TITLE"];

  MString sopClassUID = mp["SOP_CLASS_UID"];

  MString host = mp["HOST"];

  MDateTime dt;
  MString timeStamp = "";
  dt.formatXSDateTime(timeStamp);

  s << "<" << AUDIT_MESSAGE_NAME << ">" << endl;

  s << " <DicomQuery>" << endl;
  s << "  <Keys>" << queryKeys << "</Keys>" << endl;

  s << "  <Requestor>" << endl;
  s << "   <IP>" << remoteIPAddress << "</IP>" << endl;
  s << "   <Hname>" << remoteHostname << "</Hname>" << endl;
  s << "   <AET>" << remoteAETitle << "</AET>" << endl;
  s << "  </Requestor>" << endl;

  s << "  <CUID>" << sopClassUID << "</CUID>" << endl;

  s << " </DicomQuery>" << endl;

  s << " <Host>" << host << "</Host>" << endl;
  s << " <TimeStamp>" << timeStamp << "</TimeStamp>" << endl;
  s << "</" << AUDIT_MESSAGE_NAME << ">" << endl;
  s << '\0';

  MAuditMessage* m = new MAuditMessage(buffer);

  return m;
}

MAuditMessage*
MAuditMessageFactory::produceInstancesStored(MStringMap& mp)
{
  char buffer[MESSAGE_SIZE+1];
  strstream s(buffer, sizeof(buffer));

  MString queryKeys = mp["QUERY_KEYS"];

  MString remoteIPAddress = mp["REMOTE_IP_ADDRESS"];
  MString remoteHostname = mp["REMOTE_HOSTNAME"];
  MString remoteAETitle = mp["REMOTE_AE_TITLE"];

  MString objectAction = "Create";
  MString accessionNumber = mp["ACCESSION_NUMBER"];
  MString studyUID = mp["STUDY_UID"];
  MString patientID = mp["PATIENT_ID"];
  MString patientName = mp["PATIENT_NAME"];
  MString sopClassUID = mp["SOP_CLASS_UID"];
  MString numberOfInstances = mp["NUMBER_OF_INSTANCES"];

  MString host = mp["HOST"];

  MDateTime dt;
  MString timeStamp = "";
  dt.formatXSDateTime(timeStamp);

  s << "<" << AUDIT_MESSAGE_NAME << ">" << endl;

  s << " <InstancesStored>" << endl;

  s << "  <RemoteNode>" << endl;
  s << "   <IP>" << remoteIPAddress << "</IP>" << endl;
  s << "   <Hname>" << remoteHostname << "</Hname>" << endl;
  s << "   <AET>" << remoteAETitle << "</AET>" << endl;
  s << "  </RemoteNode>" << endl;

  s << "  <InstanceActionDescription>" << endl;
  s << "   <ObjectAction>"      << objectAction << "</ObjectAction>" << endl;
  s << "   <AccessionNumber>"   << accessionNumber << "</AccessionNumber>" << endl;
  s << "   <SUID>"              << studyUID << "</SUID>" << endl;
  s << "   <Patient>"           << endl;
  s << "    <PatientID>"         << patientID << "</PatientID>" << endl;
  s << "    <PatientName>"       << patientName << "</PatientName>" << endl;
  s << "   </Patient>"          << endl;
  s << "   <User>"              << endl;
  s << "    <RemoteNode>"        << endl;
  s << "     <IP>"                << remoteIPAddress << "</IP>" << endl;
  s << "     <Hname>"             << remoteHostname << "</Hname>" << endl;
  s << "     <AET>"               << remoteAETitle << "</AET>" << endl;
  s << "    </RemoteNode>"       << endl;
  s << "   </User>"             << endl;
  s << "   <CUID>"              << sopClassUID << "</CUID>" << endl;
  s << "   <NumberOfInstances>" << numberOfInstances << "</NumberOfInstances>" << endl;
  s << "  </InstanceActionDescription>" << endl;

  s << " </InstancesStored>" << endl;

  s << " <Host>" << host << "</Host>" << endl;
  s << " <TimeStamp>" << timeStamp << "</TimeStamp>" << endl;
  s << "</" << AUDIT_MESSAGE_NAME << ">" << endl;
  s << '\0';

  MAuditMessage* m = new MAuditMessage(buffer);

  return m;
}

MAuditMessage*
MAuditMessageFactory::produceAtnaStartup(MStringMap& mp)
{
  char buffer[MESSAGE_SIZE+1];
  strstream s(buffer, sizeof(buffer));

  MString applicationId = mp["APPLICATION_ID"];
  MString aeTitle = mp["AE_TITLE"];

  MString personId = mp["PERSON_ID"];
  MString personName = mp["PERSON_NAME"];

  MDateTime dt;
  MString timeStamp = "";
  dt.formatXSDateTime(timeStamp);

  s << "<AuditMessage>" << endl;
  s << " <EventIdentification EventActionCode=\"E\" EventDateTime=\"" << timeStamp << "\" EventOutcomeIndicator=\"0\">" << endl;
  s << "  <EventID code=\"110100\" codeSystemName=\"DCM\" displayName=\"Application Activity\" />" << endl;
  s << "  <EventTypeCode code=\"110120\" codeSystemName=\"DCM\" displayName=\"Application Start\" />" << endl;
  s << " </EventIdentification>" << endl;
  s << " <ActiveParticipant UserID=\"" << applicationId << "\" AlternativeUserID=\"" << aeTitle << "\" UserIsRequestor=\"false\">" << endl;
  s << "  <RoleIDCode code=\"110150\" codeSystemName=\"DCM\" displayName=\"Application\"/>" << endl;
  s << " </ActiveParticipant>" << endl;
  s << " <ActiveParticipant UserID=\"" << personId << "\" UserName=\"" << personName << "\" UserIsRequestor=\"true\">" << endl;
  s << "  <RoleIDCode code=\"110151\" codeSystemName=\"DCM\" displayName=\"Application Launcher\"/>" << endl;
  s << " </ActiveParticipant>" << endl;
  s << " <AuditSourceIdentification AuditEnterpriseSiteID=\"Hospital\" AuditSourceID=\"ReadingRoom\">" << endl;
  s << "  <AuditSourceTypeCode code=\"1\"/>" << endl;
  s << " </AuditSourceIdentification>" << endl;
  s << "</AuditMessage>" << endl;

  s << '\0';

  MAuditMessage* m = new MAuditMessage(buffer);

  return m;
}

MAuditMessage*
MAuditMessageFactory::produceAtnaActorConfig(MStringMap& mp)
{
  char buffer[MESSAGE_SIZE+1];
  strstream s(buffer, sizeof(buffer));

  MString applicationId = mp["APPLICATION_ID"];
  MString aeTitle = mp["AE_TITLE"];

  MString personId = mp["PERSON_ID"];
  MString personName = mp["PERSON_NAME"];
  MString displayName = mp["DISPLAY_NAME"];

  MDateTime dt;
  MString timeStamp = "";
  dt.formatXSDateTime(timeStamp);

  s << "<AuditMessage>" << endl;
  s << " <EventIdentification EventActionCode=\"E\" EventDateTime=\"" << timeStamp << "\" EventOutcomeIndicator=\"0\">" << endl;
  s << "  <EventID code=\"110100\" codeSystemName=\"DCM\" displayName=\"Application Activity\" />" << endl;
  s << "  <EventTypeCode code=\"110131\" codeSystemName=\"DCM\" displayName=\"" << displayName << "\" />" << endl;
  s << " </EventIdentification>" << endl;
  s << " <ActiveParticipant UserID=\"" << applicationId << "\" AlternativeUserID=\"" << aeTitle << "\" UserIsRequestor=\"false\">" << endl;
  s << "  <RoleIDCode code=\"110150\" codeSystemName=\"DCM\" displayName=\"Application\"/>" << endl;
  s << " </ActiveParticipant>" << endl;
  s << " <ActiveParticipant UserID=\"" << personId << "\" UserName=\"" << personName << "\" UserIsRequestor=\"true\">" << endl;
  s << "  <RoleIDCode code=\"110151\" codeSystemName=\"DCM\" displayName=\"Application Launcher\"/>" << endl;
  s << " </ActiveParticipant>" << endl;
  s << " <AuditSourceIdentification AuditEnterpriseSiteID=\"Hospital\" AuditSourceID=\"ReadingRoom\">" << endl;
  s << "  <AuditSourceTypeCode code=\"1\"/>" << endl;
  s << " </AuditSourceIdentification>" << endl;
  s << "</AuditMessage>" << endl;

  s << '\0';

  MAuditMessage* m = new MAuditMessage(buffer);

  return m;
}

MAuditMessage*
MAuditMessageFactory::produceAtnaUserAuthenticated(MStringMap& mp)
{
  char buffer[MESSAGE_SIZE+1];
  strstream s(buffer, sizeof(buffer));

  MString userId = mp["USER_ID"];
  MString userName = mp["USER_NAME"];
  MString nodeId = mp["NODE_ID"];
  MString networkID = mp["NETWORK_ID"];

  MDateTime dt;
  MString timeStamp = "";
  dt.formatXSDateTime(timeStamp);

  s << "<AuditMessage>" << endl;
  s << " <EventIdentification EventActionCode=\"E\" EventDateTime=\"" << timeStamp << "\" EventOutcomeIndicator=\"0\">" << endl;
  s << "  <EventID code=\"110114\" codeSystemName=\"DCM\" displayName=\"User Authentication\" />" << endl;
  s << "  <EventTypeCode code=\"110122\" codeSystemName=\"DCM\" displayName=\"Login\" />" << endl;
  s << " </EventIdentification>" << endl;
  s << " <ActiveParticipant UserID=\"" << userId << "\" UserName=\"" << userName << "\" UserIsRequestor=\"true\" NetworkAccessPointID=\"" << networkID << "\" NetworkAccessPointTypeCode=\"2\">" << endl;
  s << " </ActiveParticipant>" << endl;
  s << " <ActiveParticipant UserID=\"" << nodeId << "\" UserIsRequestor=\"false\">" << endl;
  s << "  <RoleIDCode code=\"110151\" codeSystemName=\"DCM\" displayName=\"Application Launcher\"/>" << endl;
  s << " </ActiveParticipant>" << endl;
  s << " <AuditSourceIdentification AuditEnterpriseSiteID=\"Hospital\" AuditSourceID=\"ReadingRoom\">" << endl;
  s << "  <AuditSourceTypeCode code=\"1\"/>" << endl;
  s << " </AuditSourceIdentification>" << endl;
  s << "</AuditMessage>" << endl;

  s << '\0';

  MAuditMessage* m = new MAuditMessage(buffer);

  return m;
}

MAuditMessage*
MAuditMessageFactory::produceAtnaPatientRecord(MStringMap& mp)
{
  char buffer[MESSAGE_SIZE+1];
  strstream s(buffer, sizeof(buffer));

  MString userId = mp["USER_ID"];
  MString patientId = mp["PATIENT_ID"];
  MString patientName = mp["PATIENT_NAME"];

  MDateTime dt;
  MString timeStamp = "";
  dt.formatXSDateTime(timeStamp);

  s << "<AuditMessage>" << endl;
  s << " <EventIdentification EventActionCode=\"C\" EventDateTime=\"" << timeStamp << "\" EventOutcomeIndicator=\"0\">" << endl;
  s << "  <EventID code=\"110110\" codeSystemName=\"DCM\" displayName=\"Patient Record\" />" << endl;
  s << " </EventIdentification>" << endl;
  s << " <ActiveParticipant UserID=\"" << userId << "\" UserIsRequestor=\"true\">" << endl;
  s << " </ActiveParticipant>" << endl;
  s << " <AuditSourceIdentification AuditEnterpriseSiteID=\"Hospital\" AuditSourceID=\"ReadingRoom\">" << endl;
  s << "  <AuditSourceTypeCode code=\"1\"/>" << endl;
  s << " </AuditSourceIdentification>" << endl;
  s << " <ParticipantObjectIdentification ParticipantObjectID=\"" << patientId << "\" ParticipantObjectTypeCode=\"1\" ParticipantObjectTypeCodeRole=\"1\">" << endl;
  s << "  <ParticipantObjectIDTypeCode code=\"2\" />" << endl;
  s << "  <ParticipantObjectName>\"" << patientName << "\"</ParticipantObjectName>" << endl;
  s << " </ParticipantObjectIdentification>" << endl;
  s << "</AuditMessage>" << endl;

  s << '\0';

  MAuditMessage* m = new MAuditMessage(buffer);

  return m;
}
