#!/usr/local/bin/perl -w

use Env;
use lib "..";
require rpt_crt;

$SIG{INT} = \&goodbye;

sub goodbye () {
  exit 1;
}

# End of subroutines, beginning of the main code

rpt_crt::make_dcm_object_japanese("sr_602cr.dcm", "sr_602cr.txt", "sr_602mr_j.txt");
rpt_crt::make_dcm_object_japanese("sr_602ct.dcm", "sr_602ct.txt", "sr_602mr_j.txt");
rpt_crt::make_dcm_object_japanese("sr_602ct_add.dcm", "sr_602ct_add.txt", "sr_602mr_j.txt");
rpt_crt::make_dcm_object_japanese("sr_602mr.dcm", "sr_602mr.txt", "sr_602mr_j.txt");
