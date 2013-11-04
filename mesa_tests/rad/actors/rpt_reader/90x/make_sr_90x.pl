#!/usr/local/bin/perl -w

use Env;
use lib "scripts";
require rpt_reader;

$SIG{INT} = \&goodbye;

sub goodbye () {
  exit 1;
}

# End of subroutines, beginning of the main code

rpt_reader::make_dcm_object("90x/sr_901cr");
rpt_reader::make_dcm_object("90x/sr_901cr_v");
rpt_reader::make_dcm_object("90x/sr_901ct");
rpt_reader::make_dcm_object("90x/sr_901mr");

