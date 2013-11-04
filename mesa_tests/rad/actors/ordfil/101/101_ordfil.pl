#!/usr/local/bin/perl -w


# Runs the Year 3:101 Order Filler exam interactively.

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


sub send_CFIND_P1 {
  if ($MESA_OS eq "WINDOWS_NT") {
    $resultsDir = "101\\mwl_p1";
    $resultsDirMESA = "101\\mwl_p1_mesa";
  } else {
    $resultsDir = "101/mwl_p1";
    $resultsDirMESA = "101/mwl_p1_mesa";
  }

  ordfil::delete_directory($resultsDir);
  ordfil::delete_directory($resultsDirMESA);

  ordfil::create_directory($resultsDir);
  ordfil::create_directory($resultsDirMESA);

  $x = "$MESA_TARGET/bin/dcm_create_object -i mwl/mwlquery_white.txt mwl/mwlquery_white.dcm";
  print "$x\n";
  print `$x`;
  $x = "$MESA_TARGET/bin/mwlquery -a MODALITY1 -c $mwlAE " .
	" -f mwl/mwlquery_white.dcm -o $resultsDir $mwlHost $mwlPort";
  print "$x\n";
  print `$x`;

  $x = "$MESA_TARGET/bin/mwlquery -a MODALITY1 -f mwl/mwlquery_white.dcm " .
       "-o $resultsDirMESA localhost 2250";
  print "$x\n";
  print `$x`;
}

sub produce_P1_data {
  print `perl scripts/produce_scheduled_images.pl MR MODALITY1 583020 P1 P1 $mwlAE $mwlHost $mwlPort X1_A1 X1 MR/MR4/MR4S1 `;
  if ($?) {
    print "Could not get MWL or produce images.\n";
    goodbye;
  }
}

sub send_MPPS_X1 {
  ordfil::send_mpps("P1", "MODALITY1", $mppsAE, $mppsHost, $mppsPort);
  ordfil::send_mpps("P1", "MODALITY1", $mppsAE, "localhost", $imPortDICOM);
}

sub request_ImagesAvailable_X1 {
  print "\n";
  print "This would be the logical time for your system to send DICOM C-Find\n";
  print " requests for the Images Available query.  You have received MPPS \n";
  print " events for procedure P1, but we have not yet sent the images to \n";
  print " the Image Manager.\n\n";
  print " Press <enter> when ready to continue or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub announce_a06 {
  print "\n";
  print "The ADT system will now send you an A06 to change White to an inpatient \n";
  print " Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub request_a06 {
  print "\n";
  print "You are expected to send the A06 message to the MESA Image Manager at $host:$imPortHL7 \n";
  print " Press <enter> when done or <q> to quit: ";
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

sub request_a03 {
  print "\n";
  print "You are expected to send the A03 message to the MESA Image Manager at $host:$imPortHL7 \n";
  print " Press <enter> when done or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub announce_X2 {
  print "\n" .
"We are about to start Unidentified Patient Case 5 with Procedure P2/X2.\n" .
" For this test, we assume the temporary patient ID used at the modality\n" .
" comes from a pre-assigned list which is maintained by your system. \n" .
" We will ask you for a temporary ID.  When you have entered that ID, \n" .
" the MESA Modality will send you PPS messages that you are expected to \n" .
" forward to the MESA Image Manager.\n" .
" Once we obtain the temporary ID, the scripts will take a few moments\n" .
" to generate image data\n".
" We also assume the temporary patient name is SUNDAY^J1.\n" .
"  Please enter this temporary ID to be assigned to SUNDAY^J1: ";

  $doePatientID = <STDIN>; chomp $doePatientID;
  print "Temp ID for patient SUNDAY: $doePatientID\n";
}

sub produce_P2_data {
  $x = "scripts/produce_unscheduled_images.pl";
  print `perl $x MR MODALITY1 $doePatientID P2 P2 X2 MR/MR4/MR4S1 SUNDAY_J1 `;
  if ($?) {
    print "Could not produce P2 data.\n";
    goodbye;
  }
}


sub send_MPPS_X2 {
  ordfil::send_mpps("P2", "MODALITY1", $mppsAE, $mppsHost, $mppsPort);
  ordfil::send_mpps("P2", "MODALITY1", $mppsAE, "localhost", $imPortDICOM);
}

sub request_ImagesAvailable_X2 {
  print "\n";
  print "This would be the logical time for your system to send DICOM C-Find\n";
  print " requests for the Images Available query.  You have received MPPS \n";
  print " events for procedure P2, but we have not yet sent the images to \n";
  print " the Image Manager.\n\n";
  print " Press <enter> when ready to continue or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub request_a40_doe {
  print "\n" .
  "Now that you have a registration event for DOE^J2, you need to update \n" .
  " the Image Manager for the patient (SUNDAY) with ID $doePatientID. \n" .
  " That is, you are merging your temporary patient (SUNDAY) with the \n" .
  " patient registered with the ADT system (DOE). \n" .
  " Please send an ADT^A40 message to the Image Manager to merge that patient. \n\n" .
  " Press <enter> when done or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub request_P2 {
  print
"\n" .
"Your Order Filler should request P2 for DOE^J2 by sending an ORM to the \n" .
" MESA Order Placer. Upon receipt of the ORM, the MESA Order Placer will \n" .
" send a separate ORR message with the Order Placer Number\n\n" .
"\n" .
  " Press <enter> when done or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);

  if (! -e "$MESA_STORAGE/ordplc/1001.hl7") {
    print "The file $MESA_STORAGE/ordplc/1001.hl7 does not exist.\n" .
    " This is the ORM message we are expecting from you.  This script \n" .
    " will now die and you should rerun from the beginning.\n";
    exit 1;
  }


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
  " You should now send the scheduling message for X2 (DOE^J2) to the MESA \n" .
  " Image Manager at $host:$imPortHL7 \n\n" .
  " Press <enter> when done or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub announce_a40 {
  print "\n" .
  "The ADT system will now send you an A40 to merge DOE^J2 with White.\n" .
  " Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub request_a40_doe_white {
  print "\n" .
  "You need to inform the Image Manager that DOE^J2 was merged with White \n" .
  " Please send an ADT^A40 message to the MESA Image Manager to update \n" .
  " that patient \n" .
  " Press <enter> when done or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub send_CFIND_P21 {
  if ($MESA_OS eq "WINDOWS_NT") {
    $resultsDir = "101\\mwl_p21";
    $resultsDirMESA = "101\\mwl_p21_mesa";
  } else {
    $resultsDir = "101/mwl_p21";
    $resultsDirMESA = "101/mwl_p21_mesa";
  }

  ordfil::delete_directory($resultsDir);
  ordfil::delete_directory($resultsDirMESA);

  ordfil::create_directory($resultsDir);
  ordfil::create_directory($resultsDirMESA);

  $x = "$MESA_TARGET/bin/dcm_create_object -i mwl/mwlquery_white.txt mwl/mwlquery_white.dcm";
  print "$x\n";
  print `$x`;
  $x = "$MESA_TARGET/bin/mwlquery -a MODALITY1 -c $mwlAE " .
	" -f mwl/mwlquery_white.dcm -o $resultsDir $mwlHost $mwlPort";
  print "$x\n";
  print `$x`;

  $x = "$MESA_TARGET/bin/mwlquery -a MODALITY1 -f mwl/mwlquery_white.dcm " .
       "-o $resultsDirMESA localhost 2250";
  print "$x\n";
  print `$x`;
}

sub announce_P21_cancel {
  print "\n" .
  "The MESA Order Placer will cancel P21.\n" .
  " Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub request_X21_cancel {
  print "\n" .
  "Send the cancel message (X21) to the Image Manager.\n" .
  " Your message goes to the MESA Image Manager at $host:$imPortHL7 \n" .
  " Press <enter> when done or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub cancel_P21
{
  $x = "$MESA_TARGET/bin/of_mwl_cancel -p A101X\^MESA_ORDPLC ordfil";
  print "$x\n";
  print `$x`;
  if ($?) {
    print "Could not cancel P21 on MESA system.\n";
    exit 1;
  }
}

sub send_CFIND_P22 {
  if ($MESA_OS eq "WINDOWS_NT") {
    $resultsDir = "101\\mwl_p22";
    $resultsDirMESA = "101\\mwl_p22_mesa";
  } else {
    $resultsDir = "101/mwl_p22";
    $resultsDirMESA = "101/mwl_p22_mesa";
  }

  ordfil::delete_directory($resultsDir);
  ordfil::delete_directory($resultsDirMESA);

  ordfil::create_directory($resultsDir);
  ordfil::create_directory($resultsDirMESA);

  $x = "$MESA_TARGET/bin/dcm_create_object -i mwl/mwlquery_white.txt mwl/mwlquery_white.dcm";
  print "$x\n";
  print `$x`;
  $x = "$MESA_TARGET/bin/mwlquery -a MODALITY1 -c $mwlAE " .
	" -f mwl/mwlquery_white.dcm -o $resultsDir $mwlHost $mwlPort";
  print "$x\n";
  print `$x`;

  $x = "$MESA_TARGET/bin/mwlquery -a MODALITY1 -f mwl/mwlquery_white.dcm " .
       "-o $resultsDirMESA localhost 2250";
  print "$x\n";
  print `$x`;
}


# Setup commands

# Set Machine names and port numbers

die "Order Filler test 101 is retired as of May, 2003.\n";

print "\n";
print "------------ Starting ORDFIL exam ---------------\n";
print "(Running in verbose mode)\n" if $verbose;
print "(Running in debug mode)\n" if $debug;

($opPort, $ofPortHL7, $ofHostHL7,
 $mwlAE, $mwlHost, $mwlPort,
 $mppsAE, $mppsHost, $mppsPort,
 $imPortHL7, $imPortDICOM) = ordfil::read_config_params("ordfil_test.cfg");

clear_MESA;

print "Illegal Image Mgr HL7 Port: $imPortHL7 \n" if ($imPortHL7 == 0);
print "Illegal MESA Order Placer Port: $opPort \n" if ($opPort == 0);

ordfil::announce_a04("WHITE");

$x = ordfil::send_hl7("../../msgs/adt/101", "101.102.a04.hl7", $ofHostHL7, $ofPortHL7);
ordfil::xmit_error("101.102.a04.hl7") if ($x != 0);
$x = ordfil::send_hl7("../../msgs/adt/101", "101.102.a04.hl7", "localhost", "2200");
ordfil::xmit_error("101.102.a04.hl7") if ($x != 0);

ordfil::announce_order_orm("P1");
$x = ordfil::send_hl7("../../msgs/order/101", "101.104.o01.hl7", $ofHostHL7, $ofPortHL7);
ordfil::xmit_error("101.104.o01.hl7") if ($x != 0);
$x = ordfil::send_hl7("../../msgs/order/101", "101.104.o01.hl7", "localhost", "2200");
ordfil::xmit_error("101.104.o01.hl7") if ($x != 0);

ordfil::request_procedure(
	"You should now schedule X1 (MR) to fill the request for P1.",
	$host, $imPortHL7);

ordfil::announce_CFIND("P1");

ordfil::local_scheduling_mr();

send_CFIND_P1;

produce_P1_data();

ordfil::announce_PPS (
	"X1",
	$mppsHost, $mppsPort,
	$host, $imPortDICOM);


$deltaFile = "101/pps_a.del";
send_MPPS_X1;

request_ImagesAvailable_X1;

ordfil::announce_CSTORE("P1/X1");
ordfil::send_images("P1");
ordfil::announce_CSTORE_complete("P1/X1");

announce_a06;
$x = ordfil::send_hl7("../../msgs/adt/101", "101.126.a06.hl7", $ofHostHL7, $ofPortHL7);
ordfil::xmit_error("101.126.a06.hl7") if ($x != 0);
$x = ordfil::send_hl7("../../msgs/adt/101", "101.126.a06.hl7", "localhost", "2200");
ordfil::xmit_error("101.126.a06.hl7") if ($x != 0);

request_a06;

announce_a03;
$x = ordfil::send_hl7("../../msgs/adt/101", "101.130.a03.hl7", $ofHostHL7, $ofPortHL7);
ordfil::xmit_error("101.130.a03.hl7") if ($x != 0);
$x = ordfil::send_hl7("../../msgs/adt/101", "101.130.a03.hl7", "localhost", "2200");
ordfil::xmit_error("101.130.a03.hl7") if ($x != 0);
request_a03;

announce_X2;
produce_P2_data;
$deltaFile = "101/pps_b.del";
send_MPPS_X2;

request_ImagesAvailable_X2;
ordfil::announce_CSTORE("P2/X2");
ordfil::send_images("P2");
ordfil::announce_CSTORE_complete("P2/X2");

ordfil::announce_a04("DOE^J2");
$x = ordfil::send_hl7("../../msgs/adt/101", "101.160.a04.hl7", $ofHostHL7, $ofPortHL7);
ordfil::xmit_error("101.160.a04.hl7") if ($x != 0);
$x = ordfil::send_hl7("../../msgs/adt/101", "101.160.a04.hl7", "localhost", "2200");
ordfil::xmit_error("101.160.a04.hl7") if ($x != 0);
request_a40_doe;

request_P2;
ordfil::update_filler_order("../../msgs/order/101", "101.164.o02.hl7", $fillerOrderP2);

$x = ordfil::send_hl7("../../msgs/order/101", "101.164.o02.hl7", $ofHostHL7, $ofPortHL7);
ordfil::xmit_error("101.164.o02.hl7") if ($x != 0);
$x = ordfil::send_hl7("../../msgs/order/101", "101.164.o02.hl7", "localhost", "2200");
ordfil::xmit_error("101.164.o02.hl7") if ($x != 0);
request_X2;

announce_a40;
$x = ordfil::send_hl7("../../msgs/adt/101", "101.166.a40.hl7", $ofHostHL7, $ofPortHL7);
ordfil::xmit_error("101.166.a40.hl7") if ($x != 0);
$x = ordfil::send_hl7("../../msgs/adt/101", "101.166.a40.hl7", "localhost", "2200");
ordfil::xmit_error("101.166.a40.hl7") if ($x != 0);
request_a40_doe_white;

ordfil::announce_order_orm("P21");
$x = ordfil::send_hl7("../../msgs/order/101", "101.182.o01.hl7", $ofHostHL7, $ofPortHL7);
ordfil::xmit_error("101.182.o01.hl7") if ($x != 0);
$x = ordfil::send_hl7("../../msgs/order/101", "101.182.o01.hl7", "localhost", "2200");
ordfil::xmit_error("101.182.o01.hl7") if ($x != 0);

ordfil::request_procedure(
	"You should now schedule X21 (RT) to fill the request for P21.",
	$host, $imPortHL7);
ordfil::announce_CFIND("P21");

ordfil::local_scheduling_rt();

send_CFIND_P21;

#$x = ordfil::send_mwl("mwlquery_white", "mwl_P21", $mwlAE, $mwlHost, $mwlPort);

announce_P21_cancel;
$x = ordfil::send_hl7("../../msgs/order/101", "101.188.o01x.hl7", $ofHostHL7, $ofPortHL7);
ordfil::xmit_error("101.188.o01x.hl7") if ($x != 0);
$x = ordfil::send_hl7("../../msgs/order/101", "101.188.o01x.hl7", "localhost", "2200");
ordfil::xmit_error("101.188.o01x.hl7") if ($x != 0);

request_X21_cancel;

cancel_P21;

ordfil::announce_order_orm("P22");
$x = ordfil::send_hl7("../../msgs/order/101", "101.192.o01.hl7", $ofHostHL7, $ofPortHL7);
ordfil::xmit_error("101.192.o01.hl7") if ($x != 0);
$x = ordfil::send_hl7("../../msgs/order/101", "101.192.o01.hl7", "localhost", "2200");
ordfil::xmit_error("101.192.o01.hl7") if ($x != 0);

ordfil::request_procedure(
	"You should now schedule X22 (RT) to fill the request for P22.",
	$host, $imPortHL7);
ordfil::local_scheduling_rt();

ordfil::announce_CFIND("P22");
send_CFIND_P22;

print
 "Transactions are now complete.  You should evaluate your messages: \n".
 " perl 101/eval_101.pl <AE Title of MPPS Mgr> [-v] \n";

goodbye;

