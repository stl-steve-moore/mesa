#!/usr/local/bin/perl -w

use Env;
use lib "..";
require rpt_crt;

$SIG{INT} = \&goodbye;

sub goodbye () {
  exit 1;
}

# End of subroutines, beginning of the main code

rpt_crt::make_dcm_object_japanese("sr_603cr.dcm", "sr_603cr.txt", "sr_603mr_j.txt");
rpt_crt::make_dcm_object_japanese("sr_603ct.dcm", "sr_603ct.txt", "sr_603mr_j.txt");
rpt_crt::make_dcm_object_japanese("sr_603mr.dcm", "sr_603mr.txt", "sr_603mr_j.txt");
rpt_crt::make_dcm_object_japanese("sr_603mr_one_ref.dcm", "sr_603mr_one_ref.txt", "sr_603mr_j.txt");
