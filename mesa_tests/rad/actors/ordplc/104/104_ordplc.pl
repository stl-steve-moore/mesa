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
  #Kill the MESA servers and exit
  print "Exiting...\n";

  exit 0;
}

sub announce_test {
  print "\n" .
"This is test 104.  It covers the Unscheduled Patient Case 2.\n" .
" The patient is admitted as BLUE and has a normal encounter.\n" .
" In the second half of the test, we go through Unidentified Case #2.\n\n";
}

sub announce_a04 {
  print "\n" .
"The ADT system will send an A04 to register BLUE as an outpatient.\n\n" .
" Press <enter> when done or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub request_P4 {
  print "\n" .
"In this step, we request that you order Procedure P4 for BLUE\n" .
" See message 104.104.o01.hl7.\n" .
" Your ORM should go to the MESA Order filler on $host, port $ofPort.\n\n" .
" Press <enter> when done or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub announce_a04_doe {
  print "\n" .
"The ADT system will send an A04 to register DOE^J3 as an outpatient.\n\n" .
" Press <enter> when done or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub announce_P1 {
  print "\n" .
"The MESA Order Filler will send your system a request for procedure P1.\n" .
" Press <enter> when done or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub request_ORR {
  print "\n" .
"In the previous step, the MESA Order Filler requested procedure P1 \n" .
" for the patient DOE^J3.  You should respond with an ORR containing \n" .
" the Order Placer Number.\n" .
" Your ORR should go to the MESA Order filler on $host, port $ofPort.\n\n" .
" Press <enter> when done or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub announce_a40 {
  print "\n" .
"The ADT system will send an A40 to merge BLUE/DOE^J3.\n\n" .
" Press <enter> when done or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub announce_end {
  print
"\nThis marks the end of Order Placer Test 104.\n" .
" To test your rests: \n" .
"    perl 104/eval_104.pl [-v] \n";
}


# Erase old Order Filler log files

sub clear_mesa {
  print "Clearing old messages from prior runs. \n";
  print `perl scripts/reset_servers.pl`;
}

# Main starts here.

print "Test 104 has been replaced by other tests. Please do not use this test.\n";
exit 1;

print "\n------------ Starting ORDPLC exam ---------------\n";
print "(Running in verbose mode)\n" if $verbose;
print "(Running in debug mode)\n" if $debug;

($ofPort, $opHost, $opPort) = ordplc::read_config_params("ordplc_test.cfg");

clear_mesa;

announce_test;
announce_a04;

$x = ordplc::send_hl7("../../msgs/adt/104", "104.102.a04.hl7", $opHost, $opPort);
ordplc::xmit_error("104.102.a04.hl7") if ($x == 0);

request_P4;

announce_a04_doe;

$x = ordplc::send_hl7("../../msgs/adt/104", "104.142.a04.hl7", $opHost, $opPort);
ordplc::xmit_error("104.142.a04.hl7") if ($x == 0);

#send_adt("104.142.a04.hl7");

announce_P1;

$x = ordplc::send_hl7("../../msgs/order/104", "104.144.o01.hl7", $opHost, $opPort);
ordplc::xmit_error("104.144.o01.hl7") if ($x == 0);

#send_orm("104.144.o01.hl7");

request_ORR;

announce_a40;

$x = ordplc::send_hl7("../../msgs/adt/104", "104.182.a40.hl7", $opHost, $opPort);
ordplc::xmit_error("104.182.a40.hl7") if ($x == 0);

announce_end;

goodbye;
