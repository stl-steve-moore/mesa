#!/usr/local/bin/perl -w

#Runs the Order Placer 1503 exam.

use Env;
use lib "scripts";
require ordplc;

$host = `hostname`; chomp $host;
$debug = grep /^-.*d/, @ARGV;
$verbose = grep /^-.*v/, @ARGV  if not $debug;


$SIG{INT} = \&goodbye;

sub goodbye () {
  print "Exiting...\n";
  exit 0;
}

sub announce_test {
  print "\n" .
"This is test 1503.  It covers the Unscheduled Patient Case 1.\n" .
" The patient arrives and is registered as DOE^J1.  The name is changed \n" .
" later to SILVERHEELS^JAY.\n" .
" This test uses the same messages and sequence as Order Placer test 103.\n" .
" This test adds the Basic Security profile.\n\n";
}

sub request_P1 {
  print "\n" .
"In this step, we request that you order Procedure P1 for DOE^J1.\n" .
" See message 103.104.o01.hl7.\n" .
" Your ORM should go to the MESA Order filler on $host, port $ofPort.\n\n" .
" Press <enter> when done or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub announce_a08 {
  print "\n" .
"The ADT system will send an A08 to update the patient name.\n" .
" The updated name is SILVERHEELS.\n\n" .
" Press <enter> when done or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub announce_end {
  print
"\nThis marks the end of Order Placer Test 1503.\n" .
" To test your rests: \n" .
"    perl 1503/eval_1503.pl [-v] \n";
}


# Erase old Order Filler log files

sub clear_mesa {
  print "Clearing old messages from prior runs. \n";
  print `perl scripts/reset_servers_secure.pl`;
}

#Set Machine names and port numbers

print "\n------------ Starting ORDPLC exam ---------------\n";
print "(Running in verbose mode)\n" if $verbose;
print "(Running in debug mode)\n" if $debug;


($ofPort, $opHost, $opPort) = ordplc::read_config_params("ordplc_test_secure.cfg");

clear_mesa;

announce_test;
ordplc::announce_a04("DOE^J1", $opHost, $opHost);

$x = ordplc::send_hl7_secure("../../msgs/adt/103", "103.102.a04.hl7", $opHost, $opPort,
	"randoms.dat", "mesa_1.key.pem", "mesa_1.cert.pem", "test_list.cert", "NULL-SHA");
ordplc::xmit_error("103.102.a04.hl7") if ($x == 0);

request_P1;

announce_a08;

$x = ordplc::send_hl7_secure("../../msgs/adt/103", "103.130.a08.hl7", $opHost, $opPort,
	"randoms.dat", "mesa_1.key.pem", "mesa_1.cert.pem", "test_list.cert", "NULL-SHA");
ordplc::xmit_error("103.130.a08.hl7") if ($x == 0);

announce_end;

goodbye;
