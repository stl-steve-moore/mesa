#!/usr/local/bin/perl -w

use Env;
use lib "..";
require rpt_crt;

$SIG{INT} = \&goodbye;

sub goodbye () {
  exit 1;
}

# End of subroutines, beginning of the main code

rpt_crt::make_dcm_object_japanese("sr_604ct_modified.dcm", "sr_604ct_modified.txt", "sr_604mr_j.txt");
rpt_crt::make_dcm_object_japanese("sr_604mr.dcm", "sr_604mr.txt", "sr_604mr_j.txt");
