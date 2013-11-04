#!/usr/local/bin/perl -w

# Self test for Order Filler test 1301.

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

$SIG{INT} = \&goodbye;

sub goodbye {
  exit 0;
}

($opPort, $ofPortHL7, $ofHostHL7,
 $mwlAE, $mwlHost, $mwlPort,
 $mppsAE, $mppsHost, $mppsPort,
 $imPortHL7, $imPortDICOM) = ordfil::read_config_params("ordfil_test.cfg");

print "Illegal Image Mgr HL7 Port: $imPortHL7 \n" if ($imPortHL7 == 0);
print "Illegal MESA Order Placer Port: $opPort \n" if ($opPort == 0);
print "Illegal Order Filler host, port: $ofHostHL7 $ofPortHL7 \n" if ($ofPortHL7 == 0);
print "Illegal MWL AE, host, port: $mwlAE $mwlHost $mwlPort \n" if ($mwlPort == 0);
print "Illegal MPPS AE, host, port: $mppsAE $mppsHost $mppsPort \n" if ($mppsPort == 0);
print "Illegal Image Mgr DICOM Port: $imPortDICOM \n" if ($imPortDICOM == 0);

print `perl scripts/reset_servers.pl`;

$x = mesa::send_hl7("../../msgs/sched/1301", "1301.112.o01.hl7", "localhost", $imPortHL7);
mesa::xmit_error("1301.112.o01.hl7") if ($x != 0);

$x = mesa::send_hl7("../../msgs/chg/1301", "1301.126.p03.hl7", "localhost", "2150");
mesa::xmit_error("1301.126.p03.hl7") if ($x != 0);

$x = mesa::send_hl7("../../msgs/chg/1301", "1301.128.p03.hl7", "localhost", "2150");
mesa::xmit_error("1301.128.p03.hl7") if ($x != 0);

goodbye;

