#!/usr/local/bin/perl -w

use Env;
use File::Copy;
use lib "scripts";
require ordfil;

# Find hostname of this machine
$host = `hostname`; chomp $host;
# Setup debug and verbose modes
# (debug mode is selected over verbose if both are present)
$debug = grep /^-.*d/, @ARGV;
$verbose = grep /^-.*v/, @ARGV  if not $debug;


$SIG{INT} = \&goodbye;

sub goodbye () {
  #Kill the MESA servers and exit
  print "Exiting...\n";

  exit;
}

sub clear_MESA{
  print `perl scripts/reset_servers.pl`;
}

sub announce_test {
  print "\n" .
"This is test 105.  It covers the Unscheduled Patient Case 3.\n" .
" The patient is admitted as DOE^J4 and is later changed to MUSTARD.\n";
}


sub produce_P2_data {
  $x = "perl scripts/produce_unscheduled_images.pl " .
	" MR MODALITY1 583085 P2 P2 X2 MR/MR4/MR4S1 DOE_J4";

  print "$x\n";
  print `$x`;

  if ($?) {
    print "Could not produce P2 data.\n";
    goodbye;
  }
}

sub announce_PPS_X2 {
  print "\n" .
"The MESA Modality will send MPPS messages to you at $mppsHost:$mppsPort.\n" .
" You are expected to forward these to the MESA Image Mgr $host:$imPortDICOM\n" .
" Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub send_MPPS_X2 {
  ordfil::send_mpps("P2", "MODALITY1", $mppsAE, $mppsHost, $mppsPort);
  ordfil::send_mpps("P2", "MODALITY1", $mppsAE, "localhost", $imPortDICOM);
}

sub request_P2 {
  print
"\n" .
"Your Order Filler should request P2 for DOE^J4 by sending an ORM to the \n" .
" MESA Order Placer. Upon receipt of the ORM, the MESA Order Placer will \n" .
" send a separate ORR message with the Placer Order Number\n\n" .
" Press <enter> when ready or <q> to quit: ";

  $response = <STDIN>;
  goodbye if ($response =~ /^q/);

  $x = "$MESA_TARGET/bin/hl7_get_value -f $MESA_STORAGE/ordplc/1001.hl7 ORC 3 0";
  print "$x\n";

  $fillerOrderP2 = `$x`; chomp $fillerOrderP2;

  print
"We think your Filler Order Number is $fillerOrderP2 \n" .
" If this is correct, press <enter>.  If not, <q> and <enter> to quit. \n\n" .
" If this is not correct, you need to examine the message we used to\n" .
" extract this value: $MESA_STORAGE/ordplc/1001.hl7. \n" .
" Press <enter> to continue or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub request_X2 {
  print "\n" .
  "You have received the ORR message with the Order Placer Number. \n" .
  " You should now send the scheduling message for X2 (DOE^J4) to the MESA \n" .
  " Image Manager at $host:$imPortHL7 \n\n" .
  " Press <enter> when done or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub announce_a08 {
  print "\n" .
"The ADT system will send you an A08 to change DOE^J4 to MUSTARD\n" .
" Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub request_a08 {
  print "\n" .
"You are expected to forward the A08 message to the MESA Image Manager\n" .
" at $host:$imPortHL7.\n" .
" Press <enter> when done or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub announce_end {
  print "\n" .
"This marks the end of Order Filler test 105.\n" .
" To evaluate results: \n" .
"  perl 105/eval_105.pl <AE Title of MPPS Mgr> [-v] \n";
}

# =========================================
# Main starts here

print "This script is now deprecated. Please read the Order Filler test instructions\n";
print " about how to run test 105.\n";
print " To get on-line help: perl scripts/ordfil_swl.pl \n";
exit 1;


print "\n";
print "------------ Starting ORDFIL exam ---------------\n";
print "(Running in verbose mode)\n" if $verbose;
print "(Running in debug mode)\n" if $debug;

# Set Machine names and port numbers

($opPort, $ofPortHL7, $ofHostHL7,
 $mwlAE, $mwlHost, $mwlPort,
 $mppsAE, $mppsHost, $mppsPort,
 $imPortHL7, $imPortDICOM) = ordfil::read_config_params("ordfil_test.cfg");

die "Empty Order Placer Port" if ($opPort eq "");
die "Empty Order Placer Port" if ($mwlAE eq "");
die "Empty Order Placer Port" if ($mwlHost eq "");
die "Empty Order Placer Port" if ($mwlPort eq "");

clear_MESA;

announce_test;

ordfil::announce_a04("DOE^J4");

$x = ordfil::send_hl7("../../msgs/adt/105", "105.102.a04.hl7", $ofHostHL7, $ofPortHL7);
ordfil::xmit_error("105.102.a04.hl7") if ($x != 0);
$x = ordfil::send_hl7("../../msgs/adt/105", "105.102.a04.hl7", "localhost", "2200");
ordfil::xmit_error("105.102.a04.hl7") if ($x != 0);

produce_P2_data;
announce_PPS_X2;
send_MPPS_X2;

ordfil::announce_CSTORE("P2/X2");
ordfil::send_images("P2");

request_P2;
ordfil::update_filler_order("../../msgs/order/105", "105.116.o02.hl7", $fillerOrderP2);

$x = ordfil::send_hl7("../../msgs/order/105", "105.116.o02.hl7", $ofHostHL7, $ofPortHL7);
ordfil::xmit_error("105.116.o02.hl7") if ($x != 0);
$x = ordfil::send_hl7("../../msgs/order/105", "105.116.o02.hl7", "localhost", "2200");
ordfil::xmit_error("105.116.o02.hl7") if ($x != 0);
request_X2;

announce_a08;
#send_adt("105.120.a08.hl7");

$x = ordfil::send_hl7("../../msgs/adt/105", "105.120.a08.hl7", $ofHostHL7, $ofPortHL7);
ordfil::xmit_error("105.120.a08.hl7") if ($x != 0);
$x = ordfil::send_hl7("../../msgs/adt/105", "105.120.a08.hl7", "localhost", "2200");
ordfil::xmit_error("105.120.a08.hl7") if ($x != 0);

request_a08;

announce_end;

goodbye;

