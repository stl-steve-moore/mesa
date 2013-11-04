#!/usr/local/bin/perl -w

#Runs the Order Placer 107 exam.
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
"This is test 107.  It covers Order Status Update from the Order Filler.\n" .
" The patient name is ROSE \n\n";
}

sub announce_a04 {
  print "\n" .
"The ADT system will send an A04 to register ROSE as an outpatient.\n\n" .
" Press <enter> when done or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub request_P6 {
  print "\n";
  print "In this step, we request that you order Procedure P6 for ROSE\n";
  print " See message 107.104.o01.hl7.\n";
  print " Your ORM should go to the MESA Order filler on $host, port $ofPort.\n\n";
  print " Press <enter> when done or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub update_placer_number {
  my $placerOrderNumber = shift(@_);

  $x = "perl scripts/change_hl7_field.pl " .
	" ../../msgs/status/107/107.112.o01.hl7 ORC 2 $placerOrderNumber";
  print `$x`;

  $x = "perl scripts/change_hl7_field.pl " .
	" ../../msgs/status/107/107.116.o01.hl7 ORC 2 $placerOrderNumber";
  print `$x`;
}

sub announce_P6_status_inprogress {
  print "\n" .
"The MESA Order Filler will now send a Status Update message to indicate \n" .
" the procedure has started.\n\n" .
" Press <enter> when done or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}
sub announce_P6_status_complete {
  print "\n" .
"The MESA Order Filler will now send a Status Update message to indicate \n" .
" the procedure has completed (and all reporting done).\n\n" .
" Press <enter> when done or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub announce_end {
  print
"\nThis marks the end of Order Placer Test 107.\n" .
" There are no results to test.  You should have been able to receive \n" .
" and process the Status Update messages from the MESA Order Filler\n";
}


# Erase old Order Filler log files

sub clear_mesa {
  print "Clearing old messages from prior runs. \n";
  print `perl scripts/reset_servers.pl`;
}

# Main starts here.

print "This script is now deprecated. Please read the Order Placer test instructions\n";
print " about how to run test 107.\n";
print " To get on-line help: perl scripts/ordplc_swf.pl \n";
exit 1;

print "\n------------ Starting ORDPLC exam ---------------\n";
print "(Running in verbose mode)\n" if $verbose;
print "(Running in debug mode)\n" if $debug;

($ofPort, $opHost, $opPort) = ordplc::read_config_params("ordplc_test.cfg");

clear_mesa;

announce_test;
announce_a04;

$x = ordplc::send_hl7("../../msgs/adt/107", "107.102.a04.hl7", $opHost, $opPort);
ordplc::xmit_error("107.102.a04.hl7") if ($x == 0);

request_P6;

$placerNumber = ordplc::get_placer_number("$MESA_STORAGE/ordfil/1001.hl7");
update_placer_number($placerNumber);

announce_P6_status_inprogress;

$x = ordplc::send_hl7("../../msgs/status/107", "107.112.o01.hl7",
			$opHost, $opPort);
ordplc::xmit_error("107.112.o01.hl7") if ($x == 0);

announce_P6_status_complete;

$x = ordplc::send_hl7("../../msgs/status/107", "107.116.o01.hl7",
			$opHost, $opPort);
ordplc::xmit_error("107.116.o01.hl7") if ($x == 0);

announce_end;

goodbye;
