#!/usr/local/bin/perl -w

use Env;
use lib "..";
require rpt_crt;

$SIG{INT} = \&goodbye;

sub goodbye () {
  exit 1;
}

# End of subroutines, beginning of the main code

rpt_crt::make_dcm_object("sr_604cr");

rpt_crt::make_dcm_object("sr_604ct");

rpt_crt::make_dcm_object("sr_604mr");

rpt_crt::make_dcm_object("sr_604ct_modified");
