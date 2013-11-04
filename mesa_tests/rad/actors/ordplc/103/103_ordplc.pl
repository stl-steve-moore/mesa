#!/usr/local/bin/perl -w

#Runs the Order Placer 103 exam.
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
"This is test 103.  It covers the Unscheduled Patient Case 1.\n" .
" The patient arrives and is registered as DOE^J1.  The name is changed \n" .
" later to SILVERHEELS^JAY.\n\n";
}

sub announce_a04 {
  print "\n" .
"The ADT system will send an A04 to register DOE^J1 as an outpatient.\n\n" .
" Press <enter> when done or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
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
"\nThis marks the end of Order Placer Test 103.\n" .
" To test your rests: \n" .
"    perl 103/eval_103.pl [-v] \n";
}


# Erase old Order Filler log files

sub clear_mesa {
  print "Clearing old messages from prior runs. \n";
  print `perl scripts/reset_servers.pl`;
}

# Main starts here.

print "This script is now deprecated. Please read the Order Placer test instructions\n";
print " about how to run test 103.\n";
print " To get on-line help: perl scripts/ordplc_swl.pl \n";
exit 1;


print "\n------------ Starting ORDPLC exam ---------------\n";
print "(Running in verbose mode)\n" if $verbose;
print "(Running in debug mode)\n" if $debug;


($ofPort, $opHost, $opPort) = ordplc::read_config_params("ordplc_test.cfg");

clear_mesa;

announce_test;
announce_a04;

$x = ordplc::send_hl7("../../msgs/adt/103", "103.102.a04.hl7", $opHost, $opPort);
ordplc::xmit_error("103.102.a04.hl7") if ($x == 0);

request_P1;

announce_a08;

$x = ordplc::send_hl7("../../msgs/adt/103", "103.130.a08.hl7", $opHost, $opPort);
ordplc::xmit_error("103.130.a08.hl7") if ($x == 0);

announce_end;

goodbye;
