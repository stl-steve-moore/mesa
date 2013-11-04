#!/usr/local/bin/perl -w

use Env;
use lib "..";
require rpt_crt;

$SIG{INT} = \&goodbye;

sub goodbye () {
  exit 1;
}

# End of subroutines, beginning of the main code

rpt_crt::convert_sr_to_hl7("../601-j/sr_601cr.dcm", "sr_661.hl7", "../msh.txt");

