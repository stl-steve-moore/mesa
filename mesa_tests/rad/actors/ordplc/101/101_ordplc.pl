#!/usr/local/bin/perl -w

# Runs the Order Placer 101 exam.
use Env;
use lib "scripts";
require ordplc;

$host = `hostname`; chomp $host;
# Setup debug and verbose modes
# (debug mode is selected over verbose if both are present)
$debug = grep /^-.*d/, @ARGV;
$verbose = grep /^-.*v/, @ARGV  if not $debug;

$SIG{INT} = \&goodbye;

sub goodbye () {
  print "Exiting...\n";

  exit 0;
}


sub announce_test {
  print
"\n" .
"This is Order Placer test 101: subject is WHITE.\n";
}

sub announce_a04 {
  print
"\n" .
"MESA ADT system will send your Order Placer an A04 to register WHITE.\n" .
" Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub request_P1 {
  print "\n";
  print "In this step, we request that you order Procedure P1 for White\n";
  print " See message 101.102.o01.hl7.\n";
  print " Your ORM should go to the MESA Order filler on $host, port $ofPort.\n\n";
  print " Press <enter> when done or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub announce_a06 {
  print "\n";
  print "The ADT system will now send you an A06 to change White to an inpatient\n";
  print " Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub announce_a03 {
  print "\n";
  print "The ADT system will now send you an A03 to discharge White\n";
  print " Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub announce_a04_doe {
  print "\n";
  print "The ADT system will now send you an A04 to register DOE^J2 \n";
  print " Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub announce_P2_doe {
  print "\n";
  print "The Order Filler will now send you an ORM to order procedure P2 \n";
  print " for DOE^J2.  You are expected to ACK that message and then send \n";
  print " an ORR with the appropriate Order Placer Number.\n";
  print " Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub announce_a40 {
  print "\n";
  print "The ADT system will now send you an A40 to merge DOE^J2 with White.\n";
  print " Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub request_P21_and_cancel {
  print "\n";
  print "In this step, we request that you order Procedure P21 for White.\n";
  print " See message 101.141.o01.hl7.\n";
  print " Your ORM should go to the MESA Order filler on $host, port $ofPort.\n";
  print " After you order P21, please send a cancel message.\n\n";
  print " Press <enter> when done with both messages or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub request_P22 {
  print "\n";
  print "In this step, we request that you order Procedure P22 for White.\n";
  print " See message 101.192.o01.hl7.\n";
  print " Your ORM should go to the MESA Order filler on $host, port $ofPort.\n";
  print " Press <enter> when done with both messages or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub announce_end {
  print
"\n" .
"That marks the end of all transactions for Order Placer test 101.\n" .
" You may evaluate your messages as follows: perl 101/eval_101.pl\n";
}

# Erase old Order Filler log files

sub clear_mesa {
  `perl scripts/reset_servers.pl`;
}

#Set Machine names and port numbers

die "Order Placer test 101 is retired as of May, 2003\n";

print "\n------------ Starting ORDPLC exam ---------------\n";
print "(Running in verbose mode)\n" if $verbose;
print "(Running in debug mode)\n" if $debug;

($ofPort, $opHost, $opPort) = ordplc::read_config_params("ordplc_test.cfg");

clear_mesa;

announce_test;
announce_a04;

$x = ordplc::send_hl7("../../msgs/adt/101", "101.102.a04.hl7", $opHost, $opPort);
ordplc::xmit_error("101.102.a04.hl7") if ($x == 0);

request_P1;
announce_a06;

$x = ordplc::send_hl7("../../msgs/adt/101", "101.126.a06.hl7", $opHost, $opPort);
ordplc::xmit_error("101.126.a06.hl7") if ($x == 0);

announce_a03;

$x = ordplc::send_hl7("../../msgs/adt/101", "101.130.a03.hl7", $opHost, $opPort);
ordplc::xmit_error("101.130.a03.hl7") if ($x == 0);

announce_a04_doe;
$x = ordplc::send_hl7("../../msgs/adt/101", "101.160.a04.hl7", $opHost, $opPort);
ordplc::xmit_error("101.160.a04.hl7") if ($x == 0);

announce_P2_doe;
$x = ordplc::send_hl7("../../msgs/order/101", "101.162.o01.hl7", $opHost, $opPort);
ordplc::xmit_error("101.162.o01.hl7") if ($x == 0);

announce_a40;
$x = ordplc::send_hl7("../../msgs/adt/101", "101.166.a40.hl7", $opHost, $opPort);
ordplc::xmit_error("101.166.a40.hl7") if ($x == 0);

request_P21_and_cancel;

request_P22;

announce_end;

goodbye;
