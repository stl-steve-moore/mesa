#!/usr/local/bin/perl -w

use Env;
use lib "..";
require rpt_crt;

$SIG{INT} = \&goodbye;

sub goodbye () {
  exit 1;
}

# End of subroutines, beginning of the main code

rpt_crt::make_dcm_object("sr_602cr");

rpt_crt::make_dcm_object("sr_602cr_v");

rpt_crt::make_dcm_object("sr_602ct");

rpt_crt::make_dcm_object("sr_602mr");

rpt_crt::make_dcm_object("sr_602ct_add");
