#!/usr/local/bin/perl -w

use Env;
use lib "scripts";
require rpt_crt;

$SIG{INT} = \&goodbye;

sub goodbye () {
  #Kill the MESA servers and exit

  print "Exiting...\n";

  exit 1;
}

# End of subroutines, beginning of the main code

rpt_crt::mask_left("CR/CR3/CR3S1/CR3S1IM1.dcm", "60x/cr3_left.dcm", "1023");
rpt_crt::mask_right("CR/CR3/CR3S1/CR3S1IM1.dcm", "60x/cr3_right.dcm", "1023");

