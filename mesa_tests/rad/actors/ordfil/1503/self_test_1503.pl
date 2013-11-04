#!/usr/local/bin/perl -w

# Self test for Order Filler test 1503.

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
 $imPortHL7, $imPortDICOM) = ordfil::read_config_params("ordfil_secure.cfg");

print "Illegal Image Mgr HL7 Port: $imPortHL7 \n" if ($imPortHL7 == 0);
print "Illegal MESA Order Placer Port: $opPort \n" if ($opPort == 0);
print "Illegal Order Filler host, port: $ofHostHL7 $ofPortHL7 \n" if ($ofPortHL7 == 0);
print "Illegal MWL AE, host, port: $mwlAE $mwlHost $mwlPort \n" if ($mwlPort == 0);
print "Illegal MPPS AE, host, port: $mppsAE $mppsHost $mppsPort \n" if ($mppsPort == 0);
print "Illegal Image Mgr DICOM Port: $imPortDICOM \n" if ($imPortDICOM == 0);

#print `perl scripts/reset_servers.pl`;

$x = mesa::send_hl7_secure("../../msgs/sched/103", "103.106.o01.hl7", "localhost", $imPortHL7,
	"randoms.dat", "test_sys_1.key.pem", "test_sys_1.cert.pem", "mesa_list.cert", "NULL-SHA");
ordfil::xmit_error("103.106.o01.hl7") if ($x != 0);

$x = mesa::send_hl7_secure("../../msgs/adt/103", "103.132.a08.hl7", "localhost", $imPortHL7,
	"randoms.dat", "test_sys_1.key.pem", "test_sys_1.cert.pem", "mesa_list.cert", "NULL-SHA");
ordfil::xmit_error("103.132.a08.hl7") if ($x != 0);

#$x = mesa::send_image_avail_secure("$MESA_STORAGE/modality/P11/mpps.status", "localhost", $imPortDICOM);

# Two messages from Order Filler to access the patient record
# and create a procedure record
$syslogPortMESA = 4000;
mesa::create_send_audit("localhost", $syslogPortMESA,
	"../../msgs/audit/1503/1503.012", "PATIENT_RECORD");

mesa::create_send_audit("localhost", $syslogPortMESA,
	"../../msgs/audit/1503/1503.014", "PROCEDURE_RECORD");

# One message from the Order Filler for a DICOM Query (MWL)
mesa::create_send_audit("localhost", $syslogPortMESA,
	"../../msgs/audit/1503/1503.016", "DICOM_QUERY");

goodbye;

