#!/usr/local/bin/perl -w

use Env;
use lib "scripts";
require rpt_mgr;

$SIG{INT} = \&goodbye;

sub goodbye () {
  exit 1;
}

# End of subroutines, beginning of the main code

rpt_mgr::make_dcm_object("601/sr_601cr");
rpt_mgr::make_dcm_object("601/sr_601cr_v");

