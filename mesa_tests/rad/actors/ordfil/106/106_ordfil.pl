#!/usr/local/bin/perl -w

# Runs the Year 3:106 Order Filler exam interactively.

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

sub announce_a04 {
  print "\n";
  print "The ADT system will send you an A04 to register Green\n";
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

sub request_X6_X7 {
  print "\n";
  print "You should now schedule X6 and X7 (MR) to fill the request for P6/P7.\n";
  print " These are two separate procedures, resulting in two separate studies \n";
  print " and two separate scheduling messages.\n";
  print " Your scheduling messages goes to the MESA Image Manager at $host : $mesaIMPortHL7 \n";
  print " Press <enter> when done or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub announce_P7 {
  print "\n";
  print "The MESA Order Placer will send you an ORM^O01 to request P7.\n";
  print " Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub request_X7 {
  print "\n";
  print "You should now schedule X7 (MR) to fill the request for P6.\n";
  print " Your scheduling message goes to the MESA Image Manager at $host : $mesaIMPortHL7 \n";
  print " Press <enter> when done or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub local_scheduling_mr {
  print `perl scripts/schedule_mr.pl`;
}

sub local_scheduling_rt {
  print `perl scripts/schedule_rt.pl`;
}

sub announce_CFIND_P6_P7 {
  print "\n" .
"The MESA Modality will send a C-Find to query for its worklist.\n" .
" This will also lead to image production, so this step may take some time.\n" .
" Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub send_CFIND_P6_P7 {
  $resultsDir = "106/mwl_p6_p7";
  $resultsDirMESA = "106/mwl_p6_p7_mesa";

  ordfil::delete_directory($resultsDir);
  ordfil::delete_directory($resultsDirMESA);

  ordfil::create_directory($resultsDir);
  ordfil::create_directory($resultsDirMESA);

  $x = "$MESA_TARGET/bin/dcm_create_object -i mwl/mwlquery_green.txt mwl/mwlquery_green.dcm";
  print "$x\n";
  print `$x`;
  $x = "$MESA_TARGET/bin/mwlquery -a MODALITY1 -c $mwlAE " .
	" -f mwl/mwlquery_green.dcm -o $resultsDir $mwlHost $mwlPort";
  print "$x\n";
  print `$x`;

  $x = "$MESA_TARGET/bin/mwlquery -a MODALITY1 -f mwl/mwlquery_green.dcm " .
       "-o $resultsDirMESA localhost 2250";
  print "$x\n";
  print `$x`;
}

sub produce_P6_P7_data {
  $x =  "perl scripts/produce_group_2rp.pl MR MODALITY1 583050 " .
	" T106 $mwlAE $mwlHost $mwlPort X6_A1 X7_A1 X6-7 MR/MR4/MR4S1";

  print "$x\n";
  print `$x`;
  die "Could not get MWL or produce T106 images \n" if ($?);
}

sub produce_P6_GSPS {
 $x = "perl scripts/produce_scheduled_gsps.pl PR MODALITY1 " .
	" 583050 P6 T106_gsps_x6 $mwlAE $mwlHost $mwlPort X6_A1 X6 " .
	" T106 106/options_x6.txt ";

  print "$x\n";
  print `$x`;
  die "Could not get MWL or produce GSPS objects (X6) \n" if ($?);
}

sub produce_P7_GSPS {
 $x = "perl scripts/produce_scheduled_gsps.pl PR MODALITY1 " .
	" 583050 P7 T106_gsps_x7 $mwlAE $mwlHost $mwlPort X7_A1 X7 " .
	" T106 106/options_x7.txt ";

  print "$x\n";
  print `$x`;
  die "Could not get MWL or produce GSPS objects (X7) \n" if ($?);


}

sub announce_PPS_X6_X7 {
  print "\n";
  print "The MESA Modality will send MPPS messages (for images)to you at $mppsHost:$mppsPort.\n";
  print " You are expected to forward these to the MESA Image Mgr at $host:$mesaIMPortDICOM \n";
  print " Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub announce_PPS_X6_X7_gsps {
  print "\n";
  print "The MESA Modality will send MPPS messages (for GSPS)to you at $mppsHost:$mppsPort.\n";
  print " You are expected to forward these to the MESA Image Mgr at $host:$mesaIMPortDICOM \n";
  print " Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub send_MPPS_X6_X7 {
  ordfil::send_mpps("T106", "MODALITY1", $mppsAE, $mppsHost, $mppsPort);
  ordfil::send_mpps("T106", "MODALITY1", $mppsAE, "localhost", $mesaIMPortDICOM);
}

sub send_MPPS_X6_gsps {
  ordfil::send_mpps("T106_gsps_x6", "MODALITY1", $mppsAE, $mppsHost, $mppsPort);
  ordfil::send_mpps("T106_gsps_x6", "MODALITY1", $mppsAE, "localhost", $mesaIMPortDICOM);
}

sub send_MPPS_X7_gsps {
  ordfil::send_mpps("T106_gsps_x7", "MODALITY1", $mppsAE, $mppsHost, $mppsPort);
  ordfil::send_mpps("T106_gsps_x7", "MODALITY1",
		$mppsAE, "localhost", $mesaIMPortDICOM);
}

sub announce_CSTORE_P6_P7 {
  print "\n" .
"Starting to send Images for P6/P7 to MESA Image Manager.\n" .
" Parameters are: localhost $mesaIMPortDICOM \n";
}

sub announce_CSTORE_P1_complete {
  print "\n";
  print "Images for P1 have been sent to Image Manager.\n";
  print " Maybe you want to send another C-Find request.\n";
  print " Press <enter> when ready to continue or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}


# Setup commands

# Set Machine names and port numbers

print "\n";
print "------------ Starting ORDFIL exam ---------------\n";
print "(Running in verbose mode)\n" if $verbose;
print "(Running in debug mode)\n" if $debug;
$logLevel = 1;
$logLevel = 3 if $debug;

%varnames = mesa::get_config_params("ordfil_test.cfg");
if (ordfil::test_var_names(%varnames) != 0) {
  print "Some problem with the variables in ordfil_test.cfg\n";
  exit 1;
}

$ofHostHL7 = $varnames{"TEST_HL7_HOST"};
$ofPortHL7 = $varnames{"TEST_HL7_PORT"};
$mwlAE     = $varnames{"TEST_MWL_AE"};
$mwlHost   = $varnames{"TEST_MWL_HOST"};
$mwlPort   = $varnames{"TEST_MWL_PORT"};
$mppsAE    = $varnames{"TEST_MPPS_AE"};
$mppsHost  = $varnames{"TEST_MPPS_HOST"};
$mppsPort  = $varnames{"TEST_MPPS_PORT"};

$mesaOrderFillerPortHL7 = $varnames{"MESA_ORD_FIL_PORT_HL7"};
#$mesaOrderPlacerPortHL7 = $varnames{"MESA_ORD_PLC_PORT_HL7"};
$mesaIMPortHL7 = $varnames{"MESA_IMG_MGR_PORT_HL7"};
$mesaIMPortDICOM = $varnames{"MESA_IMG_MGR_PORT_DCM"};
#$mesaOFPortDICOM = $varnames{"MESA_ORD_FIL_PORT_DCM"};

#($opPort, $ofPortHL7, $ofHostHL7,
# $mwlAE, $mwlHost, $mwlPort,
# $mppsAE, $mppsHost, $mppsPort,
# $imPortHL7, $imPortDICOM) = ordfil::read_config_params("ordfil_test.cfg");

clear_MESA;

#print "Illegal Image Mgr HL7 Port: $imPortHL7 \n" if ($imPortHL7 == 0);
#print "Illegal MESA Order Placer Port: $opPort \n" if ($opPort == 0);

announce_a04();

$x = mesa::send_hl7_log($logLevel,
	"../../msgs/adt/106", "106.102.a04.hl7", $ofHostHL7, $ofPortHL7);
ordfil::xmit_error("106.102.a04.hl7") if ($x != 0);
$x = mesa::send_hl7_log($logLevel,
	"../../msgs/adt/106", "106.102.a04.hl7",
	"localhost", $mesaOrderFillerPortHL7);
ordfil::xmit_error("106.102.a04.hl7") if ($x != 0);

announce_P6();
$x = mesa::send_hl7_log($logLevel,
	"../../msgs/order/106", "106.104.o01.hl7", $ofHostHL7, $ofPortHL7);
ordfil::xmit_error("106.104.o01.hl7") if ($x != 0);
$x = mesa::send_hl7_log($logLevel, "../../msgs/order/106", "106.104.o01.hl7",
	"localhost", $mesaOrderFillerPortHL7);
ordfil::xmit_error("106.104.o01.hl7") if ($x != 0);

announce_P7();
$x = mesa::send_hl7_log($logLevel, "../../msgs/order/106", "106.106.o01.hl7",
	$ofHostHL7, $ofPortHL7);
ordfil::xmit_error("106.106.o01.hl7") if ($x != 0);
$x = mesa::send_hl7_log($logLevel, "../../msgs/order/106", "106.106.o01.hl7",
	"localhost", $mesaOrderFillerPortHL7);
ordfil::xmit_error("106.106.o01.hl7") if ($x != 0);

request_X6_X7();
local_scheduling_mr;

announce_CFIND_P6_P7();

send_CFIND_P6_P7;

produce_P6_P7_data;

produce_P6_GSPS;

produce_P7_GSPS;

announce_PPS_X6_X7_gsps;
send_MPPS_X6_X7;

announce_PPS_X6_X7;
send_MPPS_X6_gsps;
send_MPPS_X7_gsps;

print
 "Transactions are now complete.  You should evaluate your messages: \n".
 " perl 106/eval_106.pl <AE Title of MPPS Mgr> [-v] \n";

goodbye;

