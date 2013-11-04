#!/usr/local/bin/perl -w


# Runs the Year 3:102 Order Filler exam interactively.

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
  print
"\n" .
"This is Order Filler Test 102 for subject Brown.\n\n";
}

sub send_CFIND_P1 {
  if ($MESA_OS eq "WINDOWS_NT") {
    $resultsDir = "102\\mwl_p1";
    $resultsDirMESA = "102\\mwl_p1_mesa";
  } else {
    $resultsDir = "102/mwl_p1";
    $resultsDirMESA = "102/mwl_p1_mesa";
  }

  ordfil::delete_directory($resultsDir);
  ordfil::delete_directory($resultsDirMESA);

  ordfil::create_directory($resultsDir);
  ordfil::create_directory($resultsDirMESA);

  $x = "$MESA_TARGET/bin/dcm_create_object -i mwl/mwlquery_brown.txt mwl/mwlquery_brown.dcm";
  print "$x\n";
  print `$x`;

  $x = "$MESA_TARGET/bin/mwlquery -a MODALITY1 -c $mwlAE -f mwl/mwlquery_brown.dcm " .
       "-o $resultsDir $mwlHost $mwlPort";
  print "$x\n";
  print `$x`;

  $x = "$MESA_TARGET/bin/mwlquery -a MODALITY1 -f mwl/mwlquery_brown.dcm " .
       "-o $resultsDirMESA localhost 2250";
  print "$x\n";
  print `$x`;
}

sub produce_P11_data {
  $x = "perl scripts/produce_scheduled_images.pl MR MODALITY1 ";
  $x .= " 583030 P11 P11 $mwlAE $mwlHost $mwlPort X1_A1 X11 MR/MR4/MR4S1";

  print "$x \n";
  print `$x`;
  if ($?) {
    print "Could not get MWL or produce images.\n";
    goodbye;
  }
}

sub announce_PPS_X11 {
  print "\n" .
"At the modality, we decide to perform X11 rather than X1.\n" .
" The MESA Modality will send MPPS messages to you at $mppsAE:$mppsHost:$mppsPort.\n" .
" You are expected to forward these to the MESA Image Mgr $host:$imPortDICOM\n" .
" Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub send_MPPS_X11 {
  ordfil::send_mpps("P11", "MODALITY1", $mppsAE, $mppsHost, $mppsPort);
  ordfil::send_mpps("P11", "MODALITY1", $mppsAE, "localhost", $imPortDICOM);
}

sub request_ImagesAvailable_X11 {
  print "\n" .
"This would be the logical time for your system to send DICOM C-Find\n" .
" requests for the Images Available query.  You have received MPPS \n" .
" events for (requested procedure P1 / performed procedure step X11), \n" .
" but we have not yet sent the images to the Image Manager.\n\n" .
" Press <enter> when ready to continue or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub send_CFIND_P21 {
  if ($MESA_OS eq "WINDOWS_NT") {
    $resultsDir = "102\\mwl_p21";
    $resultsDirMESA = "102\\mwl_p21_mesa";
  } else {
    $resultsDir = "102/mwl_p21";
    $resultsDirMESA = "102/mwl_p21_mesa";
  }
  ordfil::delete_directory($resultsDir);
  ordfil::delete_directory($resultsDirMESA);
  ordfil::create_directory($resultsDir);
  ordfil::create_directory($resultsDirMESA);

  `$MESA_TARGET/bin/dcm_create_object -i mwl/mwlquery_brown.txt mwl/mwlquery_brown.dcm`;

  $x = "$MESA_TARGET/bin/mwlquery -a MODALITY1 -c $mwlAE -f mwl/mwlquery_brown.dcm " .
       "-o $resultsDir $mwlHost $mwlPort";
  print "$x\n";
  print `$x`;

  $x = "$MESA_TARGET/bin/mwlquery -a MODALITY1 -f mwl/mwlquery_brown.dcm " .
       "-o $resultsDirMESA localhost 2250";
  print "$x\n";
  print `$x`;
}

sub request_P21_cancel {
  print "\n" .
"Your Order Filler should cancel the request for P21.  You send a cancel\n" .
" message to the MESA Order Placer at $host:$opPort and to the\n" .
" MESA Image Manager at $host:$imPortHL7 \n" .
" Press <enter> when done or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub cancel_P21
{
  $x = "$MESA_TARGET/bin/of_mwl_cancel -p A102Y\^MESA_ORDPLC ordfil";
  print "$x\n";
  print `$x`;
  if ($?) {
    print "Could not cancel P21 on MESA system.\n";
    exit 1;
  }
}

sub request_P22 {
  print "\n" .
"Your Order Filler should request P22 for BROWN by sending an ORM to the \n" .
" MESA Order Placer. Upon receipt of the ORM, the MESA Order Placer will \n" .
" send a separate ORR message with the Order Placer Number\n\n" .
" Press <enter> when done or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);

  if (! -e "$MESA_STORAGE/ordplc/1002.hl7") {
    print "The file $MESA_STORAGE/ordplc/1002.hl7 does not exist.\n" .
    " This is the ORM message we are expecting from you.  This script \n" .
    " will now die and you should rerun from the beginning.\n";
    exit 1;
  }

  $x = "$MESA_TARGET/bin/hl7_get_value -f $MESA_STORAGE/ordplc/1002.hl7 ORC 3 0";
  print "$x\n";

  $fillerOrderP22 = `$x`; chomp $fillerOrderP22;

  print
"We think your Filler Order Number is $fillerOrderP22 \n" .
" If this is correct, press <enter>.  If not, <q> and <enter> to quit. \n\n" .
" If this is not correct, you need to examine the message we used to\n" .
" extract this value: $MESA_STORAGE/ordplc/1002.hl7. \n" .
" Press <enter> to continue or <q> to quit: ";

  $response = <STDIN>;
  goodbye if ($response =~ /^q/);

#  $fillerOrderP22 = <STDIN>; chomp $fillerOrderP22;
#  print "Filler Order Number: $fillerOrderP22 \n";
}

sub request_X22 {
  print "\n" .
"You have received the ORR message with the Order Placer Number. \n" .
" You should now send the scheduling message for X22 to the MESA \n" .
" Image Manager at $host:$imPortHL7 \n\n" .
" Press <enter> when done or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub send_CFIND_P22 {
  if ($MESA_OS eq "WINDOWS_NT") {
    $resultsDir = "102\\mwl_p22";
    $resultsDirMESA = "102\\mwl_p22_mesa";
  } else {
    $resultsDir = "102/mwl_p22";
    $resultsDirMESA = "102/mwl_p22_mesa";
  }
  ordfil::delete_directory($resultsDir);
  ordfil::delete_directory($resultsDirMESA);
  ordfil::create_directory($resultsDir);
  ordfil::create_directory($resultsDirMESA);

  `$MESA_TARGET/bin/dcm_create_object -i mwl/mwlquery_brown.txt mwl/mwlquery_brown.dcm`;

  $x = "$MESA_TARGET/bin/mwlquery -a MODALITY1 -c $mwlAE -f mwl/mwlquery_brown.dcm " .
       "-o $resultsDir $mwlHost $mwlPort";
  print "$x\n";
  print `$x`;

  $x = "$MESA_TARGET/bin/mwlquery -a MODALITY1 -f mwl/mwlquery_brown.dcm " .
       "-o $resultsDirMESA localhost 2250";
  print "$x\n";
  print `$x`;
}

sub request_a03 {
  print "\n" .
"You are expected to send the A03 message to the MESA Image Manager at $host:$imPortHL7 \n" .
" Press <enter> when done or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}


# Main starts here

print "Test 102 is obsolete. Please do not use this test.\n";
exit 1;


print "\n";
print "------------ Starting ORDFIL exam ---------------\n";
print "(Running in verbose mode)\n" if $verbose;
print "(Running in debug mode)\n" if $debug;

($opPort, $ofPortHL7, $ofHostHL7,
 $mwlAE, $mwlHost, $mwlPort,
 $mppsAE, $mppsHost, $mppsPort,
 $imPortHL7, $imPortDICOM) = ordfil::read_config_params("ordfil_test.cfg");

clear_MESA;

announce_test;

ordfil::announce_a05("BROWN");

$x = ordfil::send_hl7("../../msgs/adt/102", "102.102.a05.hl7", $ofHostHL7, $ofPortHL7);
ordfil::xmit_error("102.102.a05.hl7") if ($x != 0);
$x = ordfil::send_hl7("../../msgs/adt/102", "102.102.a05.hl7", "localhost", "2200");
ordfil::xmit_error("102.102.a05.hl7") if ($x != 0);

ordfil::announce_order_orm("P1");

$x = ordfil::send_hl7("../../msgs/order/102", "102.104.o01.hl7", $ofHostHL7, $ofPortHL7);
ordfil::xmit_error("102.104.o01.hl7") if ($x != 0);
$x = ordfil::send_hl7("../../msgs/order/102", "102.104.o01.hl7", "localhost", "2200");
ordfil::xmit_error("102.104.o01.hl7") if ($x != 0);

ordfil::request_procedure(
	"You should now schedule X1 (MR) to fill the request for P1.",
	$host, $imPortHL7);
ordfil::local_scheduling_mr();

ordfil::announce_a01("BROWN");

$x = ordfil::send_hl7("../../msgs/adt/102", "102.108.a01.hl7", $ofHostHL7, $ofPortHL7);
ordfil::xmit_error("102.108.a01.hl7") if ($x != 0);
$x = ordfil::send_hl7("../../msgs/adt/102", "102.108.a01.hl7", "localhost", "2200");
ordfil::xmit_error("102.108.a01.hl7") if ($x != 0);

ordfil::announce_CFIND("P1");

send_CFIND_P1;
produce_P11_data;

announce_PPS_X11;
#$deltaFile = "102/pps_x11.del";
send_MPPS_X11;

request_ImagesAvailable_X11;
ordfil::announce_CSTORE("P1/X11");
ordfil::send_images("P11");
ordfil::announce_CSTORE_complete("P1/X11");

ordfil::announce_order_orm("P21");

$x = ordfil::send_hl7("../../msgs/order/102", "102.122.o01.hl7", $ofHostHL7, $ofPortHL7);
ordfil::xmit_error("102.122.o01.hl7") if ($x != 0);
$x = ordfil::send_hl7("../../msgs/order/102", "102.122.o01.hl7", "localhost", "2200");
ordfil::xmit_error("102.122.o01.hl7") if ($x != 0);

ordfil::request_procedure(
	"You should now schedule X21 (RT) to fill the request for P21.",
	$host, $imPortHL7);


ordfil::local_scheduling_rt();

ordfil::announce_CFIND("P21");
send_CFIND_P21;
request_P21_cancel;

cancel_P21;

request_P22;
ordfil::update_filler_order("../../msgs/order/102", "102.132.o02.hl7", $fillerOrderP22);

$x = ordfil::send_hl7("../../msgs/order/102", "102.131.o01.hl7", "localhost", "2200");
ordfil::xmit_error("102.131.o01.hl7") if ($x != 0);

$x = ordfil::send_hl7("../../msgs/order/102", "102.132.o02.hl7", $ofHostHL7, $ofPortHL7);
ordfil::xmit_error("102.132.o02.hl7") if ($x != 0);

request_X22;
ordfil::local_scheduling_rt();

ordfil::announce_CFIND("P22");

send_CFIND_P22;

ordfil::announce_a03("BROWN");
$x = ordfil::send_hl7("../../msgs/adt/102", "102.136.a03.hl7", $ofHostHL7, $ofPortHL7);
ordfil::xmit_error("102.136.a03.hl7") if ($x != 0);
request_a03;

goodbye;

