#!/usr/local/bin/perl -w

# Runs the Year 3:104 Order Filler exam interactively.

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
"This is test 104.  It covers the Unscheduled Patient Case 2.\n" .
" The patient is admitted as BLUE and has a normal encounter.\n" .
" In the second half of the test, we go through Unidentified Case #2.\n\n";
}

sub send_CFIND_P4 {
  $resultsDir = "104/mwl_p4";
  $resultsDirMESA = "104/mwl_p4_mesa";

  ordfil::delete_directory($resultsDir);
  ordfil::delete_directory($resultsDirMESA);

  ordfil::create_directory($resultsDir);
  ordfil::create_directory($resultsDirMESA);

  $x = "$MESA_TARGET/bin/dcm_create_object -i mwl/mwlquery_blue.txt mwl/mwlquery_blue.dcm";
  print "$x\n";
  print `$x`;

  $x = "$MESA_TARGET/bin/mwlquery -a MODALITY1 -c $mwlAE -f mwl/mwlquery_blue.dcm " .
       "-o $resultsDir $mwlHost $mwlPort";
  print "$x\n";
  print `$x`;

  $x = "$MESA_TARGET/bin/mwlquery -a MODALITY1 -f mwl/mwlquery_blue.dcm " .
       "-o $resultsDirMESA localhost 2250";
  print "$x\n";
  print `$x`;
}

sub produce_P4_data {
  $x = "perl scripts/produce_scheduled_images.pl MR MODALITY1 ";
  $x .= " 583040 P4 P4a $mwlAE $mwlHost $mwlPort X4A_A1 X4A MR/MR5/MR5S1";

  print "$x \n";
  print `$x`;
  if ($?) {
    print "Could not get MWL or produce images.\n";
    goodbye;
  }

  $x = "perl scripts/produce_scheduled_images.pl MR MODALITY1 ";
  $x .= " 583040 P4 P4b $mwlAE $mwlHost $mwlPort X4B_A1 X4B MR/MR5/MR5S2";

  print "$x \n";
  print `$x`;
  if ($?) {
    print "Could not get MWL or produce images.\n";
    goodbye;
  }
}

sub announce_PPS_X4 {
  print "\n" .
"The MESA Modality will send MPPS messages to you at $mppsHost:$mppsPort.\n" .
" You are expected to forward these to the MESA Image Mgr $host:$imPortDICOM\n" .
" Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub send_MPPS_X4 {
  ordfil::send_mpps("P4a", "MODALITY1", $mppsAE, $mppsHost, $mppsPort);
  ordfil::send_mpps("P4a", "MODALITY1", $mppsAE, "localhost", $imPortDICOM);
  ordfil::send_mpps("P4b", "MODALITY1", $mppsAE, $mppsHost, $mppsPort);
  ordfil::send_mpps("P4b", "MODALITY1", $mppsAE, "localhost", $imPortDICOM);
}

sub request_ImagesAvailable_X4 {
  print "\n" .
"This would be the logical time for your system to send DICOM C-Find\n" .
" requests for the Images Available query.  You have received MPPS \n" .
" events for procedure P4, but we have not yet sent the images to \n" .
" the Image Manager.\n\n" .
" Press <enter> when ready to continue or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub announce_second_half {
  print "\n" .
" -- We now start the second half of the 104 exam.  This begins the \n" .
"    Unidentified Patient Case #2.\n\n";
}

sub request_P1 {
  print
"\n" .
"Your Order Filler should request P1 for DOE^J3 by sending an ORM to the \n" .
" MESA Order Placer. Upon receipt of the ORM, the MESA Order Placer will \n" .
" send a separate ORR message with the Placer Order Number\n\n" .
" Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);

  if (! -e "$MESA_STORAGE/ordplc/1001.hl7") {
    print "The file $MESA_STORAGE/ordplc/1001.hl7 does not exist.\n" .
    " This is supposed to be the ORM message that we just requested.\n" .
    " This script will now exit; you should run it again from the start.\n";
    exit 1;
  }
  $x = "$MESA_TARGET/bin/hl7_get_value -f $MESA_STORAGE/ordplc/1001.hl7 ORC 3 0";
  print "$x\n";

  $fillerOrderP1 = `$x`; chomp $fillerOrderP1;

  print
"We think your Filler Order Number is $fillerOrderP1 \n" .
" If this is correct, press <enter>.  If not, <q> and <enter> to quit. \n\n" .
" If this is not correct, you need to examine the message we used to\n" .
" extract this value: $MESA_STORAGE/ordplc/1001.hl7. \n" .
" Press <enter> to continue or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}


sub request_X1 {
  print "\n" .
  "You have received the ORR message with the Order Placer Number. \n" .
  " You should now send the scheduling message for X1 (DOE^J3) to the MESA \n" .
  " Image Manager at $host:$imPortHL7 \n\n" .
  " Press <enter> when done or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub send_CFIND_P1 {
  $resultsDir = "104/mwl_p1";
  $resultsDirMESA = "104/mwl_p1_mesa";

  ordfil::delete_directory($resultsDir);
  ordfil::delete_directory($resultsDirMESA);

  ordfil::create_directory($resultsDir);
  ordfil::create_directory($resultsDirMESA);

  $x = "$MESA_TARGET/bin/dcm_create_object -i mwl/mwlquery_doej3.txt mwl/mwlquery_doej3.dcm";
  print "$x\n";
  print `$x`;

  $x = "$MESA_TARGET/bin/mwlquery -a MODALITY1 -c $mwlAE -f mwl/mwlquery_doej3.dcm " .
       "-o $resultsDir $mwlHost $mwlPort";
  print "$x\n";
  print `$x`;

  $x = "$MESA_TARGET/bin/mwlquery -a MODALITY1 -f mwl/mwlquery_doej3.dcm " .
       "-o $resultsDirMESA localhost 2250";
  print "$x\n";
  print `$x`;
}

sub produce_P1_data {
  $x = "perl scripts/produce_scheduled_images.pl MR MODALITY1 ";
  $x .= " 583045 P1 P1 $mwlAE $mwlHost $mwlPort X1_A1 X1 MR/MR4/MR4S1";

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
  ordfil::send_mpps("P1", "MODALITY1", $mppsAE, $mppsHost, $mppsPort);
  ordfil::send_mpps("P1", "MODALITY1", $mppsAE, "localhost", $imPortDICOM);
}

sub request_ImagesAvailable_X1 {
  print "\n" .
"This would be the logical time for your system to send DICOM C-Find\n" .
" requests for the Images Available query.  You have received MPPS \n" .
" events for procedure P1, but we have not yet sent the images to \n" .
" the Image Manager.\n\n" .
" Press <enter> when ready to continue or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub announce_a40 {
  print "\n" .
"The ADT system will send an A40 to merge BLUE/DOE^J3.\n\n" .
" Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub request_a40 {
  print "\n";
  print "You are expected to send the A40 message to the MESA Image Manager at $host:$imPortHL7 \n";
  print " Press <enter> when done or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub announce_end {
  print "\n" .
"This marks the end of Order Filler test 104.\n" .
" To evaluate results: \n" .
"  perl 104/eval_104.pl <AE Title of MPPS Mgr> [-v] \n";
}

# =========================================
# Main starts here

print "Test 104 has been replaced by other tests. Please do not use this test.\n";
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

ordfil::announce_a04("BLUE");

$x = ordfil::send_hl7("../../msgs/adt/104", "104.102.a04.hl7", $ofHostHL7, $ofPortHL7);
ordfil::xmit_error("104.102.a04.hl7") if ($x != 0);
$x = ordfil::send_hl7("../../msgs/adt/104", "104.102.a04.hl7", "localhost", "2200");
ordfil::xmit_error("104.102.a04.hl7") if ($x != 0);

ordfil::announce_order_orm("P4");
$x = ordfil::send_hl7("../../msgs/order/104", "104.104.o01.hl7", $ofHostHL7, $ofPortHL7);
ordfil::xmit_error("104.104.o01.hl7") if ($x != 0);
$x = ordfil::send_hl7("../../msgs/order/104", "104.104.o01.hl7", "localhost", "2200");
ordfil::xmit_error("104.104.o01.hl7") if ($x != 0);

ordfil::request_procedure(
	"You should now schedule X4 (MR) to fill the request for P4.\n" .
	" This procedure has 2 SPS and 3 action items. ",
	$host, $imPortHL7);

ordfil::local_scheduling_mr();

ordfil::announce_CFIND("P4");
send_CFIND_P4;
produce_P4_data;

announce_PPS_X4;
$deltaFile = "104/pps_x4.del";
send_MPPS_X4;

ordfil::announce_CSTORE("P4/X4");
ordfil::send_images("P4a");
ordfil::send_images("P4b");

ordfil::announce_CSTORE_complete("P4/X4");

announce_second_half;
ordfil::announce_a04("DOE^J3");

$x = ordfil::send_hl7("../../msgs/adt/104", "104.142.a04.hl7", $ofHostHL7, $ofPortHL7);
ordfil::xmit_error("104.142.a04.hl7") if ($x != 0);
$x = ordfil::send_hl7("../../msgs/adt/104", "104.142.a04.hl7", "localhost", "2200");
ordfil::xmit_error("104.142.a04.hl7") if ($x != 0);

request_P1;
ordfil::update_filler_order("../../msgs/order/104", "104.146.o02.hl7", $fillerOrderP1);

$x = ordfil::send_hl7("../../msgs/order/104", "104.146.o02.hl7", $ofHostHL7, $ofPortHL7);
ordfil::xmit_error("104.146.o02.hl7") if ($x != 0);
$x = ordfil::send_hl7("../../msgs/order/104", "104.146.o02.hl7", "localhost", "2200");
ordfil::xmit_error("104.146.o02.hl7") if ($x != 0);

request_X1;
ordfil::local_scheduling_mr();

ordfil::announce_CFIND("P1");
send_CFIND_P1;
produce_P1_data;

announce_PPS_X1;
$deltaFile = "104/pps_x1.del";
send_MPPS_X1;

#request_ImagesAvailable_X1;
ordfil::announce_CSTORE("P1/X1");
ordfil::send_images("P1");
ordfil::announce_CSTORE_complete("P1/X1");
#
announce_a40;
#send_adt("104.182.a40.hl7");
$x = ordfil::send_hl7("../../msgs/adt/104", "104.182.a40.hl7", $ofHostHL7, $ofPortHL7);
ordfil::xmit_error("104.142.a04.hl7") if ($x != 0);
$x = ordfil::send_hl7("../../msgs/adt/104", "104.182.a40.hl7", "localhost", "2200");
ordfil::xmit_error("104.142.a04.hl7") if ($x != 0);

request_a40;

announce_end;

goodbye;

