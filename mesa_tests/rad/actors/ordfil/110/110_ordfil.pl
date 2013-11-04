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
  print "Exiting...\n";
  exit;
}

sub clear_MESA {
  print `perl scripts/reset_servers.pl`;
}

sub announce_test {
  print "\n" .
"This is test 110.  It covers the Billing and Material Management Option.\n" .
" The patient is admitted as GOLD^LISA.\n";
}

sub send_CFIND_P1 {
  $resultsDir = "110/mwl_p1";
  $resultsDirMESA = "110/mwl_p1_mesa";

  ordfil::delete_directory($resultsDir);
  ordfil::delete_directory($resultsDirMESA);

  ordfil::create_directory($resultsDir);
  ordfil::create_directory($resultsDirMESA);

  $x = "$MESA_TARGET/bin/dcm_create_object -i mwl/mwlquery_gold.txt mwl/mwlquery_gold.dcm";
  print "$x\n";
  print `$x`;
  $x = "$MESA_TARGET/bin/mwlquery -a MODALITY1 -c $mwlAE " .
        " -f mwl/mwlquery_gold.dcm -o $resultsDir $mwlHost $mwlPort";
  print "$x\n";
  print `$x`;

  $x = "$MESA_TARGET/bin/mwlquery -a MODALITY1 -f mwl/mwlquery_gold.dcm " .
       "-o $resultsDirMESA localhost 2250";
  print "$x\n";
  print `$x`;
}


sub produce_P1_data {
  $x = "perl scripts/produce_scheduled_images.pl " .
	" MR MODALITY1 583090 P1 T110 $mwlAE $mwlHost $mwlPort X1_A1 X1 MR/MR4/MR4S1 ";

  print "$x\n";
  print `$x`;

  if ($?) {
    print "Could not produce P1 data.\n";
    goodbye;
  }
  ordfil::update_object("$MESA_STORAGE/modality/T110/mpps.crt",
	"110/110_delta_ncreate.txt");
  ordfil::update_object("$MESA_STORAGE/modality/T110/mpps.set",
	"110/110_delta_nset.txt");
  ordfil::update_object("$MESA_STORAGE/modality/T110/mpps.status",
	"110/110_delta_nset.txt");
}


sub send_MPPS_X1 {
  ordfil::send_mpps("T110", "MODALITY1", $mppsAE, $mppsHost, $mppsPort);
  ordfil::send_mpps("T110", "MODALITY1", $mppsAE, "localhost", $imPortDICOM);
}

sub announce_end {
  print "\n" .
"This marks the end of Order Filler test 110.\n" .
" Fill out the form in the file 110/q110.txt and send \n" .
" the response to the Project Manager.\n";
}

# =========================================
# Main starts here

print "This script is retired. To run test 110: \n" .
      " perl scripts/ordfil_swf.pl 110 <log> \n";
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
die "Empty Order Filler MWL AE" if ($mwlAE eq "");
die "Empty Order Filler MWL Host" if ($mwlHost eq "");
die "Empty Order FIller MWL Port" if ($mwlPort eq "");
die "Empty Image Manager HL7 port" if ($imPortHL7 eq "");
die "Empty Image Manager DICOM port" if ($imPortDICOM eq "");

clear_MESA;

announce_test;

ordfil::announce_a04("GOLD^LISA");

$x = ordfil::send_hl7("../../msgs/adt/110", "110.102.a04.hl7",
			"localhost", "2200");
ordfil::xmit_error("110.102.a04.hl7") if ($x != 0);

$x = ordfil::send_hl7("../../msgs/adt/110", "110.104.a04.hl7",
			$ofHostHL7, $ofPortHL7);
ordfil::xmit_error("110.102.a04.hl7") if ($x != 0);

ordfil::announce_order_orm("P1");

$x = ordfil::send_hl7("../../msgs/order/110", "110.106.o01.hl7",
			$ofHostHL7, $ofPortHL7);
ordfil::xmit_error("110.106.o01.hl7") if ($x != 0);
$x = ordfil::send_hl7("../../msgs/order/110", "110.106.o01.hl7",
			"localhost", "2200");
ordfil::xmit_error("110.106.o01.hl7") if ($x != 0);


ordfil::request_procedure(
  "You should now schedule X1 (MR) to fill the request for P1.",
  $host, $imPortHL7);

ordfil::announce_CFIND("P1");

ordfil::local_scheduling_mr();

send_CFIND_P1;

produce_P1_data;

ordfil::announce_PPS (
	"X1",
	$mppsHost, $mppsPort,
	$host, $imPortDICOM);

send_MPPS_X1;

ordfil::announce_CSTORE("T110/X1");

ordfil::send_images("T110");

ordfil::announce_CSTORE_complete("P1/X1");

announce_end;

goodbye;

