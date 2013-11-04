#!/usr/local/bin/perl -w

# Runs the Year 3:103 Order Filler exam interactively.

use Env;
use File::Copy;
use lib "scripts";
use lib "../common/scripts";
require ordfil;
require mesa;

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
  print `perl scripts/reset_servers_secure.pl`;
}

sub announce_test {
  print "\n" .
"This is test 1503.  It covers the Unscheduled Patient Case 1.\n" .
" The patient arrives and is registered as DOE^J1.  The name is changed \n" .
" later to SILVERHEELS^JAY.\n\n" .
" This test uses the same sequence of events as test 103. It runs those \n" .
" events in secure mode.\n\n";
}

sub send_CFIND_P1 {
  $resultsDir = "1503/mwl_p1";
  $resultsDirMESA = "1503/mwl_p1_mesa";

  mesa::delete_directory($resultsDir);
  mesa::delete_directory($resultsDirMESA);

  mesa::create_directory($resultsDir);
  mesa::create_directory($resultsDirMESA);

  $x = "$MESA_TARGET/bin/dcm_create_object -i mwl/mwlquery_doej1.txt mwl/mwlquery_doej1.dcm";
  print "$x\n";
  print `$x`;

  $C = "$MESA_TARGET/runtime/certificates/mesa_1.cert.pem";
  $K = "$MESA_TARGET/runtime/certificates/mesa_1.key.pem";
  $P = "$MESA_TARGET/runtime/certificates/test_list.cert";
  $R = "$MESA_TARGET/runtime/certificates/randoms.dat";

  $x = "$MESA_TARGET/bin/mwlquery_secure -C $C -K $K -P $P -R $R -a MODALITY1 -c $mwlAE -f mwl/mwlquery_doej1.dcm " .
       "-o $resultsDir $mwlHost $mwlPort";
  print "$x\n";
  print `$x`;

  $x = "$MESA_TARGET/bin/mwlquery_secure -C $C -K $K -P $P -R $R -a MODALITY1 -f mwl/mwlquery_doej1.dcm " .
       "-o $resultsDirMESA localhost 2250";
  print "$x\n";
  print `$x`;
  if ($?) {
    print "Unable to send mwl query for DOE^J1 \n";
    exit;
  }
}

sub produce_P1_data {
  $x = "perl scripts/produce_scheduled_images_secure.pl MR MODALITY1 ";
  $x .= " 583295 P1 T1503 $mwlAE $mwlHost $mwlPort X1_A1 X1 MR/MR4/MR4S1";

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
  mesa::send_mpps_secure("T1503", "MODALITY1", $mppsAE, $mppsHost, $mppsPort,
	"randoms.dat", "mesa_1.key.pem", "mesa_1.cert.pem", "test_list.cert", "NULL-SHA");
  mesa::send_mpps_secure("T1503", "MODALITY1", $mppsAE, "localhost", $imPortDICOM,
	"randoms.dat", "test_sys_1.key.pem", "test_sys_1.cert.pem", "mesa_list.cert", "NULL-SHA");
}

sub request_ImagesAvailable_X1 {
  print "\n" .
"This would be the logical time for your system to send DICOM C-Find\n" .
" requests for the Images Available query.  You have received MPPS \n" .
" events for procedure P1/X1, but we have not yet sent the images to \n" .
" the Image Manager.\n\n" .
" Press <enter> when ready to continue or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub announce_a08 {
  print "\n" .
"The ADT system will send you an A08 to change DOE^J1 to SILVERHEELS\n" .
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
"This marks the end of Order Filler test 1503.\n" .
" To evaluate results: \n" .
"  perl 1503/eval_1503.pl <AE Title of MPPS Mgr> [-v] \n";
}


# ===================================
# Main starts here

print "\n";
print "------------ Starting ORDFIL exam ---------------\n";
print "(Running in verbose mode)\n" if $verbose;
print "(Running in debug mode)\n" if $debug;

# Set Machine names and port numbers

($opPort, $ofPortHL7, $ofHostHL7,
 $mwlAE, $mwlHost, $mwlPort,
 $mppsAE, $mppsHost, $mppsPort,
 $imPortHL7, $imPortDICOM) = ordfil::read_config_params("ordfil_secure.cfg");

die "Empty Order Placer Port" if ($opPort eq "");

clear_MESA;

announce_test;

ordfil::announce_a04("DOE^J1");

$x = mesa::send_hl7_secure("../../msgs/adt/103", "103.102.a04.hl7", $ofHostHL7, $ofPortHL7,
	"randoms.dat", "mesa_1.key.pem", "mesa_1.cert.pem", "test_list.cert", "NULL-SHA");
ordfil::xmit_error("103.102.a04.hl7") if ($x != 0);

$x = mesa::send_hl7_secure("../../msgs/adt/103", "103.102.a04.hl7", "localhost", "2200",
	"randoms.dat", "mesa_1.key.pem", "mesa_1.cert.pem", "test_list.cert", "NULL-SHA");
ordfil::xmit_error("103.102.a04.hl7") if ($x != 0);

ordfil::announce_order_orm("P1");

$x = mesa::send_hl7_secure("../../msgs/order/103", "103.104.o01.hl7", $ofHostHL7, $ofPortHL7,
	"randoms.dat", "mesa_1.key.pem", "mesa_1.cert.pem", "test_list.cert", "NULL-SHA");
ordfil::xmit_error("103.104.o01.hl7") if ($x != 0);

$x = mesa::send_hl7_secure("../../msgs/order/103", "103.104.o01.hl7", "localhost", "2200",
	"randoms.dat", "mesa_1.key.pem", "mesa_1.cert.pem", "test_list.cert", "NULL-SHA");
ordfil::xmit_error("103.104.o01.hl7") if ($x != 0);

ordfil::request_procedure(
	"You should now schedule X1 (MR) to fill the request for P1.",
	$host, $imPortHL7);
ordfil::local_scheduling_mr();

ordfil::announce_CFIND("P1");
send_CFIND_P1;
produce_P1_data;

announce_PPS_X1;
#$deltaFile = "103/pps_x1.del";
send_MPPS_X1;

ordfil::announce_CSTORE("P1/X1");
mesa::store_images_secure("T1503", "", "MODALITY1", "MESA", "localhost", $imPortDICOM, 1,
	"randoms.dat", "test_sys_1.key.pem", "test_sys_1.cert.pem", "mesa_list.cert", "NULL-SHA");
ordfil::announce_CSTORE_complete("P1/X1");

announce_a08;

$x = mesa::send_hl7_secure("../../msgs/adt/103", "103.130.a08.hl7", $ofHostHL7, $ofPortHL7,
	"randoms.dat", "mesa_1.key.pem", "mesa_1.cert.pem", "test_list.cert", "NULL-SHA");
ordfil::xmit_error("103.130.a08.hl7") if ($x != 0);
$x = mesa::send_hl7_secure("../../msgs/adt/103", "103.130.a08.hl7", "localhost", "2200",
	"randoms.dat", "mesa_1.key.pem", "mesa_1.cert.pem", "test_list.cert", "NULL-SHA");
ordfil::xmit_error("103.130.a08.hl7") if ($x != 0);

request_a08;

announce_end;

goodbye;

