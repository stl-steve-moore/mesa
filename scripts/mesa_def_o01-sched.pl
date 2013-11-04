#!/usr/local/bin/perl -w
use strict;
# O01 schedule

# This script is require'd by the mesa_construct_hl7.pl script.
# contains definitions specific to the O01 HL7 schedule message for Order Filler.

# return an array of queries.
sub getQueries {
    my $param = shift or die "param not passed";

    my $query = "SELECT mwl.nam, mwl.datbir, mwl.sex, mwl.patrac, " .
        "addr, mwl.pataccnum, mwl.patid, mwl.issuer, patcla, " .
        "asspatloc, attdoc, refdoc, visnum, admdoc, ordcon, " .
        "dattimtra, entby, ordcalphonum, admdat, admtim, " .
        "ordeffdattim, entorg, plaordnum, filordnum, " .
        "relcliinf, spesou, patient_visit_order.ordpro as ordpro, " .
        "accnum, reqproid, spsid, mod, traarrres, uniserid, stuinsuid, " .
        "actionitem.codval as act_codval, actionitem.codmea as act_codmea, " .
        "actionitem.codschdes as act_codschdes " .
        "FROM patient_visit_order JOIN mwl USING (orduid) " .
        "JOIN actionitem USING (spsindex) " .
        "WHERE mwl_key = '".$param->{"mwl_key"}."'";    

# The query was as below; however, of_schedule is bad and mangles ordpro.
# We want to get the ordpro from patient_visit_order, rather than mwl.
#    my $query = "SELECT * FROM patient_visit_order JOIN mwl USING (orduid) " .
#        "WHERE mwl_key = '".$param->{"mwl_key"}."'";    
    return ($query);
}


sub getDatatext {
    my $dest = shift or die "dest not passed";
    my $dbdata = shift or die "dbdata not passed";
    my $param = shift or die "param not passed";

# Remember to change back to...
#\$QUANTITY_TIMING\$ = $dbdata->{"quatim"}
#\$ORDER_STATUS\$ = $dbdata->{"ordsta"}

#    foreach my $k (keys %$dbdata) {
#        print "\t$k = $dbdata->{$k}\n";
#    }

    my $datatext = <<DATATEXT;
# MSH 
\$SENDING_APP\$ = $param->{"sending_app"}
\$SENDING_FACILITY\$ = $param->{"sending_fac"}
\$RECEIVING_APP\$ = $dest->{"rec_app"}
\$RECEIVING_FACILITY\$ = $dest->{"rec_fac_nam"}
\$MESSAGE_CONTROL_ID\$ = $param->{"msg_id"}
#
# PID 
\$PATIENT_ID\$ = $param->{"patidIssuer"}
\$PATIENT_NAME\$ = $dbdata->{"nam"}
\$DATE_TIME_BIRTH\$ = $dbdata->{"datbir"}
\$SEX\$ = $dbdata->{"sex"}
\$RACE\$ = $dbdata->{"patrac"}
\$PATIENT_ADDRESS\$ = $dbdata->{"addr"}
\$PATIENT_ACCOUNT_NUM\$ = $dbdata->{"pataccnum"}
#
# PV1
\$PATIENT_CLASS\$ = $dbdata->{"patcla"}
\$PATIENT_LOCATION\$ = $dbdata->{"asspatloc"}
\$ATTENDING_DOCTOR\$ = $dbdata->{"attdoc"}
\$REFERRING_DOCTOR\$ = $dbdata->{"refdoc"}
\$VISIT_NUMBER\$ = $dbdata->{"visnum"}
\$ADMIT_DATE_TIME\$ = $param->{"admitDateTime"}
\$VISIT_INDICATOR\$ = V
\$HOSPITAL_SERVICE\$ = $param->{"hospital_service"}
\$ADMITTING_DOCTOR\$ = $dbdata->{"admdoc"}
# ORC
\$ORDER_CONTROL\$ = $dbdata->{"ordcon"}
\$PLACER_ORDER_NUMBER\$ = $dbdata->{"plaordnum"}
\$FILLER_ORDER_NUMBER\$ = $dbdata->{"filordnum"}
\$ORDER_STATUS\$ = SC
\$QUANTITY_TIMING\$ = 1^once^^^^S
\$DATE_TIME\$ = $dbdata->{"dattimtra"}
\$ENTERED_BY\$ = $dbdata->{"entby"}
\$ORDERING_PROVIDER\$ = $dbdata->{"ordpro"}
\$CALL_BACK_PHONE_NUMBER\$ = $dbdata->{"ordcalphonum"}
\$ORDER_EFFECTIVE_DATE\$ = $dbdata->{"ordeffdattim"}
\$ENTERING_ORGANIZATION\$ = $dbdata->{"entorg"}
# OBR
\$SETID_OBR\$ = 1
\$PLACER_ORDER_NUMBER\$ = $dbdata->{"plaordnum"}
\$FILLER_ORDER_NUMBER\$ = $dbdata->{"filordnum"}
\$UNIVERSAL_SERVICE_ID\$ = $param->{"uniserid_composite"}
\$RELEVANT_CLINICAL_INFO\$ = $dbdata->{"relcliinf"}
\$SPECIMEN_SOURCE\$ = $dbdata->{"spesou"}
\$ORDERING_PROVIDER\$ = $dbdata->{"ordpro"}
\$ACCESSION_NUMBER\$ = $dbdata->{"accnum"}
\$REQUESTED_PROCEDURE_ID\$ = $dbdata->{"reqproid"}
\$SCHEDULED_PROCEDURE_STEP_ID\$ = $dbdata->{"spsid"}
\$DIAG_SERV_SECT\$ = $dbdata->{"mod"}
\$QUANTITY_TIMING\$ = 1^once^^^^S
\$TRANSPORTATION_MODE\$ = 
\$TRANSPORT_ARRANGED\$ = $dbdata->{"traarrres"}
\$PROCEDURE_CODE\$ = $dbdata->{"uniserid"}
# ZDS
\$STUDY_INSTANCE_UID\$ = $dbdata->{"stuinsuid"}
DATATEXT
    return $datatext;
}
1;
