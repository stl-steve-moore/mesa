#!/usr/local/bin/perl -w

use Env;
use lib "..";
require rpt_crt;

$SIG{INT} = \&goodbye;

sub goodbye () {
  exit 1;
}

# End of subroutines, beginning of the main code

rpt_crt::make_dcm_object_japanese("sr_605mr.dcm", "sr_605mr.txt", "sr_605mr_j.txt");
