#!/usr/local/bin/perl -w


# Runs the Year 3:107 Order Filler exam interactively.

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
"This is Order Filler test 107.  It tests your ability to send \n" .
" Order Status Update message.  The patient name for this test is ROSE \n\n";
}

sub announce_a04 {
  print "\n";
  print "The ADT system will send you an A04 to register ROSE\n";
  print " Press <enter> when ready or <q> to quit: ";
  my $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub announce_P6 {
  print "\n";
  print "The MESA Order Placer will send you an ORM^O01 to request P6.\n";
  print " Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub request_X6 {
  print "\n";
  print "You should now schedule X6 (MR) to fill the request for P6.\n";
  print " Your scheduling message goes to the MESA Image Manager at $host : $imPortHL7 \n";
  print " Press <enter> when done or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub announce_CFIND_P6 {
  print "\n" .
"The MESA Modality will send a C-Find to query for its worklist.\n" .
" This will also lead to image production, so this step may take some time.\n" .
" Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub send_CFIND_P6 {
  $resultsDir = "107/mwl_p6";
  $resultsDirMESA = "107/mwl_p6_mesa";

  ordfil::delete_directory($resultsDir);
  ordfil::delete_directory($resultsDirMESA);

  ordfil::create_directory($resultsDir);
  ordfil::create_directory($resultsDirMESA);

  $x = "$MESA_TARGET/bin/dcm_create_object -i mwl/mwlquery_rose.txt mwl/mwlquery_rose.dcm";
  print "$x\n";
  print `$x`;
  $x = "$MESA_TARGET/bin/mwlquery -a MODALITY1 -c $mwlAE " .
	" -f mwl/mwlquery_rose.dcm -o $resultsDir $mwlHost $mwlPort";
  print "$x\n";
  print `$x`;

  $x = "$MESA_TARGET/bin/mwlquery -a MODALITY1 -f mwl/mwlquery_rose.dcm " .
       "-o $resultsDirMESA localhost 2250";
  print "$x\n";
  print `$x`;
}

sub produce_P6_data {
  $x = "perl scripts/produce_scheduled_images.pl MR MODALITY1 583060 P6 T107 " .
	" $mwlAE $mwlHost $mwlPort X6_A1 X6 MR/MR4/MR4S1";
  print `$x`;
  if ($?) {
    print "Could not get MWL or produce images.\n";
    goodbye;
  }
}

sub announce_PPS_X6 {
  print "\n" .
"The MESA Modality will send MPPS messages to you at $mppsHost:$mppsPort.\n" .
" You are expected to forward these to the MESA Image Mgr at $host:$imPortDICOM \n" .
" Press <enter> when ready or <q> to quit: ";

  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub request_status_inprogress {
  print "\n" .
"You have received both the MPPS in progress and MPPS complete messages. \n".
" The in progress message should trigger an Order Status Update \n" .
" message to the MESA Order Placer at $host:$opPort \n" .
" The Order Status should be IP (In Progress) \n" .
" If your Order Filler has not already sent that Status Update message, \n" .
" please do so now. \n" .
" Press <enter> when ready or <q> to quit: ";

  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub request_status_complete {
  print "\n" .
"We now assume the procedure is complete.  According to the IHE TF: \n" .
" (Section 6.3.4.2.3) the complete, verified report is available for the \n" .
" given order. \n" .
" Please send the Order Status Update message to the MESA Order Placer. \n".
" The Order Status should be CM (Order is completed) \n" .
" Press <enter> when ready or <q> to quit: ";

  $response = <STDIN>;
}

sub announce_end {
  print
"Transactions are now complete.  You should evaluate your messages: \n".
" perl 107/eval_107.pl <AE Title of MPPS Mgr> [-v] \n";
}

# Main starts here.

print "This script is now deprecated. Please read the Order Filler test instructions\n";
print " about how to run test 107.\n";
print " To get on-line help: perl scripts/ordfil_swl.pl \n";
exit 1;

print "\n";
print "------------ Starting ORDFIL exam ---------------\n";
print "(Running in verbose mode)\n" if $verbose;
print "(Running in debug mode)\n" if $debug;

#($opPort, $ofPortHL7, $ofHostHL7,
# $mwlAE, $mwlHost, $mwlPort,
# $mppsAE, $mppsHost, $mppsPort,
# $imPortHL7, $imPortDICOM) = ordfil::read_config_params("ordfil_test.cfg");

clear_MESA;

print "Illegal Image Mgr HL7 Port: $imPortHL7 \n" if ($imPortHL7 == 0);
print "Illegal MESA Order Placer Port: $opPort \n" if ($opPort == 0);

announce_test();
announce_a04();

$x = ordfil::send_hl7("../../msgs/adt/107", "107.102.a04.hl7", $ofHostHL7, $ofPortHL7);
ordfil::xmit_error("107.102.a04.hl7") if ($x != 0);
$x = ordfil::send_hl7("../../msgs/adt/107", "107.102.a04.hl7", "localhost", "2200");
ordfil::xmit_error("107.102.a04.hl7") if ($x != 0);

announce_P6();
$x = ordfil::send_hl7("../../msgs/order/107", "107.104.o01.hl7", $ofHostHL7, $ofPortHL7);
ordfil::xmit_error("107.104.o01.hl7") if ($x != 0);
$x = ordfil::send_hl7("../../msgs/order/107", "107.104.o01.hl7", "localhost", "2200");
ordfil::xmit_error("107.104.o01.hl7") if ($x != 0);

request_X6();
announce_CFIND_P6();

ordfil::local_scheduling_mr();

send_CFIND_P6;

produce_P6_data();

announce_PPS_X6;
$mppsAE = "MPPS_MGR";
ordfil::send_mpps("T107", "MESA_MODALITY", $mppsAE, $mppsHost, $mppsPort);
ordfil::send_mpps("T107", "MESA_MODALITY", "MESA", "localhost", $imPortDICOM);

request_status_inprogress;
request_status_complete;

announce_end;
goodbye;

