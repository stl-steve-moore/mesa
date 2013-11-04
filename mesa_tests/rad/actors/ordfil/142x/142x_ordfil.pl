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
  $x = "perl scripts/reset_servers.pl";
  if( $MESA_OS eq "WINDOWS_NT") {
     $x =~ s(/)(\\)g;
  }
  print `$x`;
}

sub announce_test {
  print "\n" .
    "This is test script 142x. It prepares the Order FIller for the 142x \n" .
    "series of Post Processing Workflow tests. A CT exam for patient \n" .
    "DELAWARE is generated and a CAD step is scheduled.\n\n" .
    "Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
  print "\n\n";
  goodbye if ($response =~ /^q/);
}

sub send_CFIND_P102 {
  if ($MESA_OS eq "WINDOWS_NT") {
    $resultsDir = "142x\\mwl_p102";
    $resultsDirMESA = "142x\\mwl_p102_mesa";
  } else {
    $resultsDir = "142x/mwl_p102";
    $resultsDirMESA = "142x/mwl_p102_mesa";
  }

  ordfil::delete_directory($resultsDir);
  ordfil::delete_directory($resultsDirMESA);

  ordfil::create_directory($resultsDir);
  ordfil::create_directory($resultsDirMESA);

  $x = "$MESA_TARGET/bin/dcm_create_object -i mwl/mwlquery_delaware.txt " .
        " mwl/mwlquery_delaware.dcm";
  if( $MESA_OS eq "WINDOWS_NT") {
     $x =~ s(/)(\\)g;
  }
  print "$x\n";
  print `$x`;

 $x = "$MESA_TARGET/bin/mwlquery -a MODALITY1 -c $mwlAE " .
       " -f mwl/mwlquery_delaware.dcm -o $resultsDir $mwlHost $mwlPort";
  if( $MESA_OS eq "WINDOWS_NT") {
     $x =~ s(/)(\\)g;
  }
  print "$x\n";
  print `$x`;

  $x = "$MESA_TARGET/bin/mwlquery -a MODALITY1 -f mwl/mwlquery_delaware.dcm " .
       "-o $resultsDirMESA localhost 2250";
  if( $MESA_OS eq "WINDOWS_NT") {
     $x =~ s(/)(\\)g;
  }
  print "$x\n";
  print `$x`;
}


sub produce_P102_data {
  $x = "perl scripts/produce_scheduled_images.pl " .
	" CT MODALITY1 901421 P102 P102 $mwlAE $mwlHost $mwlPort X102_A1 " .
        " X102 CT/CT1/CT1S1 ";

  if( $MESA_OS eq "WINDOWS_NT") {
     $x =~ s(/)(\\)g;
  }
  print "$x\n";
  print `$x`;

  if ($?) {
    print "Could not produce P102 data.\n";
    goodbye;
  }
}


# =========================================
# Main starts here

print "\n";
print "------------ Starting ORDFIL exam ---------------\n";
print "(Running in verbose mode)\n" if $verbose;
print "(Running in debug mode)\n" if $debug;

# Set Machine names and port numbers

($opPort, $ofPortHL7, $ofHostHL7,
 $mwlAE, $mwlHost, $mwlPort,
 $mppsAE, $mppsHost, $mppsPort,
 $imPortHL7, $imPortDICOM, 
 ) = ordfil::read_config_params("ordfil_test.cfg");
 # $ppwfAE, $ppwfHost, $ppwfPort,
 # $ppwfPortDICOM) = ordfil::read_config_params("ordfil_test.cfg");

die "Empty Order Placer Port" if ($opPort eq "");
die "Empty Order Filler MWL AE" if ($mwlAE eq "");
die "Empty Order Filler MWL Host" if ($mwlHost eq "");
die "Empty Order FIller MWL Port" if ($mwlPort eq "");
die "Empty Image Manager HL7 port" if ($imPortHL7 eq "");
die "Empty Image Manager DICOM port" if ($imPortDICOM eq "");
# die "Empty Post Processing Manager DICOM port" if ($ppwfPortDICOM eq "");

clear_MESA;

announce_test;

ordfil::announce_a04("DELAWARE^DOVER");

$x = ordfil::send_hl7("../../msgs/adt/142x", "142x.102.a04.hl7",
			"localhost", "2200");
ordfil::xmit_error("142x.102.a04.hl7") if ($x != 0);

$x = ordfil::send_hl7("../../msgs/adt/142x", "142x.104.a04.hl7",
		 $ofHostHL7, $ofPortHL7);
ordfil::xmit_error("142x.102.a04.hl7") if ($x != 0);


ordfil::announce_order_orm("P102");

$x = ordfil::send_hl7("../../msgs/order/142x", "142x.106.o01.hl7",
			$ofHostHL7, $ofPortHL7);
ordfil::xmit_error("142x.106.o01.hl7") if ($x != 0);

$x = ordfil::send_hl7("../../msgs/order/142x", "142x.106.o01.hl7",
			"localhost", "2200");
ordfil::xmit_error("142x.106.o01.hl7") if ($x != 0);


ordfil::request_procedure(
  "You should now schedule X102 to fill the request for P102.",
  $host, $imPortHL7);

$x = "$MESA_TARGET/bin/of_schedule -t MODALITY1 -m CT -s STATION1 ordfil";
if( $MESA_OS eq "WINDOWS_NT") {
   $x =~ s(/)(\\)g;
}
print `$x`;

ordfil::announce_CFIND("P102");

send_CFIND_P102;

produce_P102_data;

ordfil::announce_PPS (
	"X102", $mppsHost, $mppsPort,
	$host, $imPortDICOM);

ordfil::send_mpps("P102", "MODALITY1", $mppsAE, $mppsHost, $mppsPort);
ordfil::send_mpps("P102", "MODALITY1", $mppsAE, "localhost", $imPortDICOM);


ordfil::announce_CSTORE("P102/X102");

ordfil::send_images("P102");

ordfil::announce_CSTORE_complete("P102/X102");

print "\n" .
  "You should now schedule post-processing proc step: X102_3DRECON \n" .
  "station names: CT_3DRECON1\n" .
  "station class: CT_3DRECON\n" .
  "station locations: East\n" .
  "start date/time: 20021010^1300\n" .
  " Press <enter> when ready to continue or <q> to quit: ";
$response = <STDIN>;
goodbye if ($response =~ /^q/);


ordfil::local_scheduling_postprocessing( 
	"A1421Z^MESA_ORDPLC",
	"X102_3DRECON^ihe^ihe",
	"../../msgs/ppm/142x/spscreate.txt");

print "\n" .
  "This completes 142x, setup for 142x series of tests.\n" .
  "Please continue with specific 142x tests, 1421, 1422.\n" ;

goodbye;

