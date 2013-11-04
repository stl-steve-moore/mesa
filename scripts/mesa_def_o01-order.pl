#!/usr/local/bin/perl -w
use strict;
# O01

# This script is require'd by the mesa_construct_hl7.pl script.
# contains definitions specific to the O01 HL7 message.

# return an array of queries.
sub getQueries {
    my $param = shift or die "param not passed";

    my $query1 = "SELECT plaordnum, filordnum, uniserid, visnum, ordcon, plagronum, " . 
        "ordsta, messta, quatim, par, dattimtra, entby, ordpro, " .
        "ordeffdattim, entorg, spesou, ordcalphonum, traarrres, reaforstu, obsval, " .
        "dancod, relcliinf FROM ordr WHERE orduid = '".$param->{"orduid"}."'";    
    my $query2 = "SELECT patid, nam, issuer, datbir, sex, patrac, addr, pataccnum, " .
        "patcla, asspatloc, attdoc, refdoc, admdoc, admdat, admtim FROM " .
        "patient_visit_order WHERE orduid = '".$param->{"orduid"}."'";    
    return ($query1, $query2);
}

sub getDatatext {
    my $dest = shift or die "dest not passed";
    my $dbdata = shift or die "dbdata not passed";
    my $param = shift or die "param not passed";

# Remember to change back to...
#\$QUANTITY_TIMING\$ = $dbdata->{"quatim"}

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
\$UNIVERSAL_SERVICE_ID\$ = $dbdata->{"uniserid"}
\$RELEVANT_CLINICAL_INFO\$ = $dbdata->{"relcliinf"}
\$SPECIMEN_SOURCE\$ = $dbdata->{"spesou"}
\$ORDERING_PROVIDER\$ = $dbdata->{"ordpro"}
\$QUANTITY_TIMING\$ = 1^once^^^^S
\$TRANSPORTATION_MODE\$ = 
\$REASON_FOR_STUDY\$ = $dbdata->{"reaforstu"}
\$TRANSPORT_ARRANGED\$ = $dbdata->{"traarrres"}
DATATEXT
    return $datatext;
}
1;
