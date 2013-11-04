#!/usr/local/bin/perl -w

# Runs Order Filler exam 1301 interactively.

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
  print `perl scripts/reset_servers.pl`;
}

sub announce_test {
  print "\n" .
"This is test 1301.  It covers Charge Processing.\n" .
" The patient is ALABAMA^MONTGOMERY.\n";
}

sub produce_P1_data {
  $x = "perl scripts/produce_scheduled_images.pl MR MODALITY1 ";
  $x .= " C1301 P1 T1301 $mwlAE $mwlHost $mwlPort X1_A1 X1 MR/MR4/MR4S1";

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
  ordfil::send_mpps("T1301", "MODALITY1", $mppsAE, $mppsHost, $mppsPort);
  ordfil::send_mpps("T1301", "MODALITY1", $mppsAE, "localhost", $imPortDICOM);
}

sub announce_end {
  print "\n" .
"This marks the end of Order Filler test 1301.\n" .
" To evaluate results: \n" .
"  perl 1301/eval_1301.pl <AE Title of MPPS Mgr> [-v] \n";
}


# ===================================
# Main starts here

print "\n";
print "------------ Starting ORDFIL exam ---------------\n";
print "(Running in verbose mode)\n" if $verbose;
print "(Running in debug mode)\n" if $debug;

# Set Machine names and port numbers

print "Order Filler test 1301 is retired as the Order Filler actor does\n" .
	"not participate in transaction 36.\n";
exit 1;

($opPort, $ofPortHL7, $ofHostHL7,
 $mwlAE, $mwlHost, $mwlPort,
 $mppsAE, $mppsHost, $mppsPort,
 $imPortHL7, $imPortDICOM) = ordfil::read_config_params("ordfil_test.cfg");

die "Empty Order Placer Port" if ($opPort eq "");

clear_MESA;

announce_test;

ordfil::announce_p01("ALABAMA^MONTGOMERY");
$x = mesa::send_hl7("../../msgs/chg/1301", "1301.104.p01.hl7", $ofHostHL7, $ofPortHL7);
mesa::xmit_error("1301.104.p01.hl7") if ($x != 0);

ordfil::announce_a01("ALABAMA^MONTGOMERY");

$x = ordfil::send_hl7("../../msgs/adt/1301", "1301.106.a01.hl7", $ofHostHL7, $ofPortHL7);
ordfil::xmit_error("1301.106.a01.hl7") if ($x != 0);
$x = ordfil::send_hl7("../../msgs/adt/1301", "1301.106.a01.hl7", "localhost", "2200");
ordfil::xmit_error("1301.106.a01.hl7") if ($x != 0);

ordfil::announce_order_orm("P1");

$x = ordfil::send_hl7("../../msgs/order/1301", "1301.108.o01.hl7", $ofHostHL7, $ofPortHL7);
ordfil::xmit_error("1301.108.o01.hl7") if ($x != 0);
$x = ordfil::send_hl7("../../msgs/order/1301", "1301.108.o01.hl7", "localhost", "2200");
ordfil::xmit_error("1301.108.o01.hl7") if ($x != 0);

ordfil::request_procedure(
	"You should now schedule X1 (MR) to fill the request for P1.",
	$host, $imPortHL7);
ordfil::local_scheduling_mr();

produce_P1_data;

announce_PPS_X1;
send_MPPS_X1;

ordfil::announce_CSTORE("P1/X1");
ordfil::send_images("T1301");
ordfil::announce_CSTORE_complete("P1/X1");

ordfil::request_dft("ALABAMA", "Technical", "MR1001^MRI HEAD^IHEDEMO");

ordfil::request_dft("ALABAMA", "Professional", "DX1001^MRI HEAD Interpretation^IHEDEMO");

announce_end;

goodbye;

