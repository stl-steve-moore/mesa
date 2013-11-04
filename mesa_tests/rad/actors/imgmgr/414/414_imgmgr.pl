#!/usr/local/bin/perl -w

# Sends C-Move request to Image Manager for 414 tests.

use Env;
use lib "scripts";
require imgmgr;

$SIG{INT} = \&goodbye;

sub goodbye () {
  print "Exiting...\n";

  exit 1;
}

sub announce_test {
  print "\n" .
"This is MESA Image Manager test 414.  It sends a C-Move request \n"; 
}

sub send_q414a {
  mesa::send_cmove_study_uid("414/q414a", $imCMoveAE, $imCMoveHost,
	$imCMovePort, "1.113654.1.2001.20", "WORKSTATION1");
}

#Setup commands
$host = `hostname`; chomp $host;

$x = $ENV{'MESA_OS'};
die "Env variable MESA_OS is not set; please read Installation Guide \n" if $x eq "";

%parms = imgmgr::read_config_params_hash();

$imCMoveHost = $parms{"TEST_CMOVE_HOST"};
$imCMovePort = $parms{"TEST_CMOVE_PORT"};
$imCMoveAE = $parms{"TEST_CMOVE_AE"};

announce_test;

`perl scripts/reset_wkstation.pl`;

send_q414a;

goodbye;
