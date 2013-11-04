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
"This is test 111.  It covers the Performed Work Status Update.\n" .
" for a mammography case with post processing. \n" .
" The patient is admitted as PEACH^SARAH.\n";
}

sub send_CFIND_P101 {
  $resultsDir = "111/mwl_p101";
  $resultsDirMESA = "111/mwl_p101_mesa";

  ordfil::delete_directory($resultsDir);
  ordfil::delete_directory($resultsDirMESA);

  ordfil::create_directory($resultsDir);
  ordfil::create_directory($resultsDirMESA);

  $x = "$MESA_TARGET/bin/dcm_create_object -i mwl/mwlquery_peach.txt mwl/mwlquery_peach.dcm";
  print "$x\n";
  print `$x`;
  $x = "$MESA_TARGET/bin/mwlquery -a MODALITY1 -c $mwlAE " .
        " -f mwl/mwlquery_peach.dcm -o $resultsDir $mwlHost $mwlPort";
  print "$x\n";
  print `$x`;

  $x = "$MESA_TARGET/bin/mwlquery -a MODALITY1 -f mwl/mwlquery_peach.dcm " .
       "-o $resultsDirMESA localhost 2250";
  print "$x\n";
  print `$x`;
}


sub produce_P101_data {
  $x = "perl scripts/produce_scheduled_images.pl " .
	" MG MODALITY1 583095 P101 T111 $mwlAE $mwlHost $mwlPort X101_A1 X101 MG/MG1/MG1S1 ";

  print "$x\n";
  print `$x`;

  if ($?) {
    print "Could not produce P101 data.\n";
    goodbye;
  }
}


sub send_MPPS_X101 {
  ordfil::send_mpps("T111", "MODALITY1", $mppsAE, $mppsHost, $mppsPort);
  ordfil::send_mpps("T111", "MODALITY1", $mppsAE, "localhost", $imPortDICOM);
}

sub announce_end {
  print "\n" .
"This marks the end of Order Filler test 111.\n";
}

# =========================================
# Main starts here

print "\n";
print "Order Filler test 111 has been modified to use the SWF scripts.\n";
print "To use test 111, use this syntax:\n";
print "    perl scripts/ordfil_swf.pl 111 log-level\n";
exit 0;

print "\n";
print "------------ Starting ORDFIL exam ---------------\n";
print "(Running in verbose mode)\n" if $verbose;
print "(Running in debug mode)\n" if $debug;

# Set Machine names and port numbers

%varnames = mesa::get_config_params("ordfil_test.cfg");
if (ordfil::test_var_names(%varnames) != 0) {
  die "Some problem with the variables in ordfil_test.cfg\n";
}

$ofHostHL7 = $varnames{"TEST_HL7_HOST"};
$ofPortHL7 = $varnames{"TEST_HL7_PORT"};
$mwlAE     = $varnames{"TEST_MWL_AE"};
$mwlHost   = $varnames{"TEST_MWL_HOST"};
$mwlPort   = $varnames{"TEST_MWL_PORT"};
$mppsAE    = $varnames{"TEST_MPPS_AE"};   die "<$mppsAE>"   if !$mppsAE;
$mppsHost  = $varnames{"TEST_MPPS_HOST"}; die "<$mppsHost>" if !$mppsHost;
$mppsPort  = $varnames{"TEST_MPPS_PORT"}; die "<$mppsPort>" if !$mppsPort;

$imPortHL7 = $varnames{"MESA_IMG_MGR_PORT_HL7"}; die "<$imPortHL7>" if !$imPortHL7;
$imPortDICOM = $varnames{"MESA_IMG_MGR_PORT_DCM"}; die "<$imPortDICOM>" if !$imPortDICOM;

#($opPort, $ofPortHL7, $ofHostHL7,
# $mwlAE, $mwlHost, $mwlPort,
# $mppsAE, $mppsHost, $mppsPort,
# $imPortHL7, $imPortDICOM) = ordfil::read_config_params("ordfil_test.cfg");

#die "Empty Order Placer Port" if ($opPort eq "");
die "Empty Order Filler MWL AE" if ($mwlAE eq "");
die "Empty Order Filler MWL Host" if ($mwlHost eq "");
die "Empty Order FIller MWL Port" if ($mwlPort eq "");
die "Empty Image Manager HL7 port" if ($imPortHL7 eq "");
die "Empty Image Manager DICOM port" if ($imPortDICOM eq "");

clear_MESA;

announce_test;

ordfil::announce_a04("PEACH^SARAH");

$x = mesa::send_hl7("../../msgs/adt/111", "111.102.a04.hl7",
			"localhost", "2200");
ordfil::xmit_error("111.102.a04.hl7") if ($x != 0);

$x = mesa::send_hl7("../../msgs/adt/111", "111.104.a04.hl7",
			$ofHostHL7, $ofPortHL7);
ordfil::xmit_error("111.102.a04.hl7") if ($x != 0);

ordfil::announce_order_orm("P101");

$x = mesa::send_hl7("../../msgs/order/111", "111.106.o01.hl7",
			$ofHostHL7, $ofPortHL7);
ordfil::xmit_error("111.106.o01.hl7") if ($x != 0);
$x = mesa::send_hl7("../../msgs/order/111", "111.106.o01.hl7",
			"localhost", "2200");
ordfil::xmit_error("111.106.o01.hl7") if ($x != 0);


ordfil::request_procedure(
  "You should now schedule X101 (MG) to fill the request for P101.",
  $host, $imPortHL7);

ordfil::announce_CFIND("P101");

ordfil::local_scheduling_mg();

send_CFIND_P101;

produce_P101_data;

ordfil::announce_PPS (
	"X101",
	$mppsHost, $mppsPort,
	$host, $imPortDICOM);

send_MPPS_X101;

ordfil::announce_CSTORE("T111/X101");

ordfil::send_images("T111");

ordfil::announce_CSTORE_complete("P101/X101");

announce_end;

goodbye;

