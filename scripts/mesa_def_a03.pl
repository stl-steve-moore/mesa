#!/usr/local/bin/perl -w
use strict;
# A03

# This script is require'd by the mesa_construct_hl7.pl script.
# contains definitions specific to the A03 HL7 message.

# return an array of queries.
sub getQueries {
    my $param = shift or die "param not passed";

    my $query = "SELECT patid, nam, issuer, datbir, sex, addr, pataccnum, " .
        "patrac, visnum, patcla, asspatloc, attdoc, admdoc, admdat, admtim, refdoc " .
        "FROM patient_visit WHERE viskey = '".$param->{"viskey"}."'";
    return ($query);
}

sub getDatatext {
    my $dest = shift or die "dest not passed";
    my $dbdata = shift or die "dbdata not passed";
    my $param = shift or die "param not passed";

    my $datatext = <<DATATEXT;
# MSH 
\$SENDING_APP\$ = $param->{"sending_app"}
\$SENDING_FACILITY\$ = $param->{"sending_fac"}
\$RECEIVING_APP\$ = $dest->{"rec_app"}
\$RECEIVING_FACILITY\$ = $dest->{"rec_fac_nam"}
\$MESSAGE_CONTROL_ID\$ = $param->{"msg_id"}
#
# EVN 
\$EVN_RECORDED_DATE_TIME\$ = $param->{"nowDateTime"}
\$EVN_EVENT_OCCURRED\$ = $param->{"nowDateTime"}
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
\$HOSPITAL_SERVICE\$ = $param->{"hospital_service"}
\$REFERRING_DOCTOR\$ = $dbdata->{"refdoc"}
\$VISIT_NUMBER\$ = $dbdata->{"visnum"}
\$DISCHARGE_DATE_TIME\$ = $param->{"nowDateTime"}
DATATEXT
    return $datatext;
}
1;
