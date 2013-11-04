#!/usr/local/bin/perl -w


# Self test for test 101.

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

#print `perl scripts/reset_servers.pl`;

# Order message for P1.
$x = ordfil::send_hl7("../../msgs/sched/101", "101.106.o01.hl7", "localhost", $imPortHL7);
ordfil::xmit_error("101.106.o01.hl7") if ($x != 0);

# A06 to change White to inpatient
$x = ordfil::send_hl7("../../msgs/adt/101", "101.128.a06.hl7", "localhost", $imPortHL7);
ordfil::xmit_error("101.128.a06.hl7") if ($x != 0);

# A03 to discharge White
$x = ordfil::send_hl7("../../msgs/adt/101", "101.132.a03.hl7", "localhost", $imPortHL7);
ordfil::xmit_error("101.132.a03.hl7") if ($x != 0);

# A40 to merge DOE with Temporary patient (Sunday)
$x = ordfil::send_hl7("../../msgs/adt/101", "101.161.a40.hl7", "localhost", $imPortHL7);
ordfil::xmit_error("101.161.a40.hl7") if ($x != 0);

# ORM to request P2
$x = ordfil::send_hl7("../../msgs/order/101", "101.162.o01.hl7", "localhost", $opPort);
ordfil::xmit_error("101.162.o01.hl7") if ($x != 0);

# ORM to Image Manager with scheduling for P2 (after the fact)
$x = ordfil::send_hl7("../../msgs/sched/101", "101.165.o01.hl7", "localhost", $imPortHL7);
ordfil::xmit_error("101.165.o01.hl7") if ($x != 0);

# A40 to merge WHITE with DOE
$x = ordfil::send_hl7("../../msgs/adt/101", "101.168.a40.hl7", "localhost", $imPortHL7);
ordfil::xmit_error("101.168.a40.hl7") if ($x != 0);

# Schedule P21 message to Image Manager
$x = ordfil::send_hl7("../../msgs/sched/101", "101.184.o01.hl7", "localhost", $imPortHL7);
ordfil::xmit_error("101.184.o01.hl7") if ($x != 0);

# Cancel message for P21 to Image Mgr
$x = ordfil::send_hl7("../../msgs/sched/101", "101.190.o01.hl7", "localhost", $imPortHL7);
ordfil::xmit_error("101.190.o01.hl7") if ($x != 0);

# Schedule P22 to Image Mgr
$x = ordfil::send_hl7("../../msgs/sched/101", "101.194.o01.hl7", "localhost", $imPortHL7);
ordfil::xmit_error("101.194.o01.hl7") if ($x != 0);

# Send one Image Availability query.
$x = ordfil::send_image_avail("$MESA_STORAGE/modality/P1/mpps.status", "localhost", $imPortDICOM);

goodbye;

