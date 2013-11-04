#!/usr/local/bin/perl -w

use Env;
use lib "..";
require rpt_crt;

$SIG{INT} = \&goodbye;

sub goodbye () {
  exit 1;
}

# End of subroutines, beginning of the main code

rpt_crt::make_dcm_object_japanese("sr_601cr.dcm", "sr_601cr.txt", "sr_601mr_j.txt");
rpt_crt::make_dcm_object_japanese("sr_601cr_v.dcm", "sr_601cr_v.txt", "sr_601mr_j.txt");
rpt_crt::make_dcm_object_japanese("sr_601ct.dcm", "sr_601ct.txt", "sr_601mr_j.txt");
rpt_crt::make_dcm_object_japanese("sr_601mr.dcm", "sr_601mr.txt", "sr_601mr_j.txt");
