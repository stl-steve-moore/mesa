#!/usr/local/bin/perl -w

# Runs the Year 3:109 Order Filler exam interactively.

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

  exit 0;
}

sub clear_MESA {
  print `perl scripts/reset_servers.pl`;
}

sub announce_test {
  print "\n" .
"This is test 109.  It covers the Exception Management option to SWF.\n" .
" The patient for this test is GREY^FRANK.\n\n";
}

sub send_CFIND_P1 {
  $resultsDir = "109/mwl_p1";
  $resultsDirMESA = "109/mwl_p1_mesa";

  ordfil::delete_directory($resultsDir);
  ordfil::delete_directory($resultsDirMESA);

  ordfil::create_directory($resultsDir);
  ordfil::create_directory($resultsDirMESA);

  $x = "$MESA_TARGET/bin/dcm_create_object -i mwl/mwlquery_grey.txt mwl/mwlquery_grey.dcm";
  print "$x\n";
  print `$x`;

  $x = "$MESA_TARGET/bin/mwlquery -a MODALITY1 -c $mwlAE -f mwl/mwlquery_grey.dcm " .
       "-o $resultsDir $mwlHost $mwlPort";
  print "$x\n";
  print `$x`;

  $x = "$MESA_TARGET/bin/mwlquery -a MODALITY1 -f mwl/mwlquery_grey.dcm " .
       "-o $resultsDirMESA localhost 2250";
  print "$x\n";
  print `$x`;
}

sub produce_P1_data {
  $x = "perl scripts/produce_abandoned_step.pl MR MODALITY1 ";
  $x .= " 583080 P1 T109 $mwlAE $mwlHost $mwlPort X1_A1 X1 MR/MR4/MR4S1 110513";

  print "$x \n";
  print `$x`;
  if ($?) {
    print "Could not get MWL or produce images.\n";
    goodbye;
  }
}


sub announce_PPS_X1 {
  print "\n" .
"The MESA Modality will send MPPS messages to you at $mppsHost:$mppsPort.\n" .
" You are expected to forward these to the MESA Image Mgr $host:$imPortDICOM\n" .
" Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub send_MPPS_X1 {
  ordfil::send_mpps("T109", "MODALITY1", $mppsAE, $mppsHost, $mppsPort);
  ordfil::send_mpps("T109", "MODALITY1", $mppsAE, "localhost", $imPortDICOM);
}

sub announce_end {
  print "\n" .
"This marks the end of Order Filler test 109.\n" .
" Edit the file 109/q109.txt and send the response to the Project Manager.\n";
}


# ===================================
# Main starts here

print "This script is retired. To run test 109: \n" .
      " perl scripts/ordfil_swf.pl 109 <log> \n";
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

clear_MESA;

announce_test;

ordfil::announce_a04("GREY^FRANK");

$x = ordfil::send_hl7("../../msgs/adt/109", "109.102.a04.hl7", $ofHostHL7, $ofPortHL7);
ordfil::xmit_error("109.102.a04.hl7") if ($x != 0);
$x = ordfil::send_hl7("../../msgs/adt/109", "109.102.a04.hl7", "localhost", "2200");
ordfil::xmit_error("109.102.a04.hl7") if ($x != 0);

ordfil::announce_order_orm("P1");

$x = ordfil::send_hl7("../../msgs/order/109", "109.104.o01.hl7", $ofHostHL7, $ofPortHL7);
ordfil::xmit_error("109.104.o01.hl7") if ($x != 0);
$x = ordfil::send_hl7("../../msgs/order/109", "109.104.o01.hl7", "localhost", "2200");
ordfil::xmit_error("109.104.o01.hl7") if ($x != 0);

ordfil::request_procedure(
	"You should now schedule X1 (MR) to fill the request for P1.",
	$host, $imPortHL7);
ordfil::local_scheduling_mr();

ordfil::announce_CFIND("P1");
send_CFIND_P1;
produce_P1_data;

ordfil::announce_PPS("P1/X1", $mppsHost, $mppsPort, $host, $imPortDICOM);
send_MPPS_X1;

announce_end;

goodbye;

