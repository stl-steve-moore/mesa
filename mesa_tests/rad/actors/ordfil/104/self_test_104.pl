#!/usr/local/bin/perl -w

# Self test for Order Filler test 104.

use Env;
use File::Copy;
use lib "scripts";
require ordfil;

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

#print `perl scripts/reset_hl7.pl`;

$x = ordfil::send_hl7("../../msgs/sched/104", "104.106.o01.hl7", "localhost", $imPortHL7);
ordfil::xmit_error("104.106.o01.hl7") if ($x != 0);

$x = ordfil::send_hl7("../../msgs/order/104", "104.144.o01.hl7", "localhost", $opPort);
ordfil::xmit_error("104.144.o01.hl7") if ($x != 0);

# Send this to our Order Filler so we can log the order
$x = ordfil::send_hl7("../../msgs/order/104", "104.145.o01.hl7", "localhost", $ofPortHL7);
ordfil::xmit_error("104.144.o01.hl7") if ($x != 0);

$x = ordfil::send_hl7("../../msgs/sched/104", "104.148.o01.hl7", "localhost", $imPortHL7);
ordfil::xmit_error("104.148.o01.hl7") if ($x != 0);

$x = ordfil::send_hl7("../../msgs/adt/104", "104.184.a40.hl7", "localhost", $imPortHL7);
ordfil::xmit_error("104.184.a40.hl7") if ($x != 0);

goodbye;

