#!/usr/local/bin/perl -w

use Env;
use lib "..";
require rpt_crt;

$SIG{INT} = \&goodbye;

sub goodbye () {
  exit 1;
}

# End of subroutines, beginning of the main code

rpt_crt::convert_sr_to_hl7("../603/sr_603mr.dcm", "sr_663.hl7", "../msh.txt");

