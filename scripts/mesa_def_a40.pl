#!/usr/local/bin/perl -w
use strict;
# A40

# This script is require'd by the mesa_construct_hl7.pl script.
# contains definitions specific to the A40 HL7 message.

# return an array of queries.
sub getQueries {
    my $param = shift or die "param not passed";

    my $query1 = "SELECT patid, issuer, nam, datbir, sex, addr, pataccnum, patrac " . 
                "FROM patient WHERE patient_key = '".$param->{"patient_key"}."'";
    my $query2 = "SELECT patid AS old_patid, nam AS old_nam, issuer as old_issuer " .
        "FROM patient WHERE patient_key = '".$param->{"old_patient_key"}."'";
    return ($query1, $query2);
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
# MRG 
\$PRIOR_PATIENT_ID_LIST\$ = $param->{"oldPatidIssuer"}
\$PRIOR_PATIENT_ID\$ = $param->{"oldPatidIssuer"}
\$PRIOR_PATIENT_NAME\$ = $dbdata->{"old_nam"}
DATATEXT
    return $datatext;
}

1;
