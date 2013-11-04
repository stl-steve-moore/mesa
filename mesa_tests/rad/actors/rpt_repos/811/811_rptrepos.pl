#!/usr/local/bin/perl -w

# Sends C-Move request to Report Repository for 811 tests.

use Env;
use lib "scripts";
require rpt_repos;

$SIG{INT} = \&goodbye;

sub goodbye () {
  print "Exiting...\n";

  exit 1;
}

sub announce_test {
  print "\n" .
"This is MESA Report Repository test 811.  It sends a C-Move request \n"; 
}

sub send_q811a {
  rpt_repos::send_cmove_study_uid("811/q811a", $rptAE, $rptHost,
	$rptPort, "1.113654.1.2001.20", "WORKSTATION1");
}

#Setup commands
$host = `hostname`; chomp $host;

($rptHost, $rptPort, $rptAE) = rpt_repos::read_config_params("rptrepos_test.cfg");
print "Rpt Repos Host:  $rptHost \n";
print "Rpt Repos Port:  $rptPort \n";
print "Rpt Repos Title: $rptAE \n";

print "Illegal Repository Port: $rptPort\n" if ($rptPort == 0);

announce_test;

`perl scripts/reset_wkstation.pl`;

send_q811a;

goodbye;
