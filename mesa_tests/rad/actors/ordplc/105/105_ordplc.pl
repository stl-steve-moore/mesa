#!/usr/local/bin/perl -w

#Runs the Order Placer 105 exam.
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
"This is test 105.  It covers the Unscheduled Patient Case 3.\n" .
" The patient is admitted as DOE^J4 and is later renamed to MUSTARD.\n\n";
}

sub announce_a04 {
  print "\n" .
"The ADT system will send an A04 to register DOE^J4 as an outpatient.\n\n" .
" Press <enter> when done or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub announce_P2 {
  print "\n" .
"The department performs procedure P2 without an electronic request.\n" .
" After the procedure is completed, the Order Filler will send the request \n" .
" for the procedure P2 to your Order Placer. \n\n" .
" We are now ready for the MESA Order Filler to send your system a request for \n" .
" procedure P2.\n" .
" Press <enter> when done or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub request_ORR {
  print "\n" .
"In the previous step, the MESA Order Filler requested procedure P2 \n" .
" for the patient DOE^J4.  You should respond with an ORR containing \n" .
" the Order Placer Number.\n" .
" Your ORR should go to the MESA Order filler on $host, port $ofPort.\n\n" .
" Press <enter> when done or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub announce_a08 {
  print "\n" .
"The ADT system will send an A08 to rename DOE^J3 to MUSTARD.\n\n" .
" Press <enter> when done or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub announce_end {
  print
"\nThis marks the end of Order Placer Test 105.\n" .
" To test your rests: \n" .
"    perl 105/eval_105.pl [-v] \n";
}


# Erase old Order Filler log files

sub clear_mesa {
  print "Clearing old messages from prior runs. \n";
  print `perl scripts/reset_servers.pl`;
}

# Main starts here.

print "This script is now deprecated. Please read the Order Placer test instructions\n";
print " about how to run test 105.\n";
print " To get on-line help: perl scripts/ordplc_swl.pl \n";
exit 1;

print "\n------------ Starting ORDPLC exam ---------------\n";
print "(Running in verbose mode)\n" if $verbose;
print "(Running in debug mode)\n" if $debug;

($ofPort, $opHost, $opPort) = ordplc::read_config_params("ordplc_test.cfg");

clear_mesa;

announce_test;
announce_a04;

$x = ordplc::send_hl7("../../msgs/adt/105", "105.102.a04.hl7", $opHost, $opPort);
ordplc::xmit_error("105.102.a04.hl7") if ($x == 0);

announce_P2;

$x = ordplc::send_hl7("../../msgs/order/105", "105.114.o01.hl7", $opHost, $opPort);
ordplc::xmit_error("105.114.o01.hl7") if ($x == 0);

request_ORR;

announce_a08;

$x = ordplc::send_hl7("../../msgs/adt/105", "105.120.a08.hl7", $opHost, $opPort);
ordplc::xmit_error("105.120.a08.hl7") if ($x == 0);

announce_end;

goodbye;
