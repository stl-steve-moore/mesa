#!/usr/local/bin/perl -w

# Self test for Rpt Manager Test 663.

use Env;
use lib "scripts";
require rpt_mgr;

$SIG{INT} = \&goodbye;

sub goodbye () {
  print "Exiting...\n";

  exit 0;
}

print `perl scripts/reset_servers.pl`;

$x = rpt_mgr::send_hl7("../../msgs/sr/663", "sr_663.hl7", "localhost", "3300");
rpt_mgr::xmit_error("sr_663.hl7") if ($x == 0);

goodbye;
