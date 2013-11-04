#!/usr/local/bin/perl -w

use Env;
use lib "..";
require rpt_crt;

$SIG{INT} = \&goodbye;

sub goodbye () {
  exit 1;
}

# End of subroutines, beginning of the main code

rpt_crt::make_dcm_object_japanese("sr_611.dcm", "sr_611.txt", "sr_611_j.txt");
rpt_crt::make_dcm_object_japanese("sr_611_final.dcm", "sr_611_final.txt", "sr_611_j.txt");
