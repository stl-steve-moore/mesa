#!/usr/local/bin/perl -w

# Sends reset messages to MESA servers.
use Env;
use Cwd;
use lib "scripts";
require ordfil;

$SIG{INT} = \&goodbye;

sub goodbye () {
  exit 0;
}

($opPort, $ofPort, $ofHost,
 $mwlAE, $mwlHost, $mwlPort,
 $mppsAE, $mppsHost, $mppsPort,
 $imPortHL7, $imPortDICOM) = ordfil::read_config_params("ordfil_test.cfg");
print ("Bad placer host, port $ofHost $ofPort \n") if ($ofPort == 0);
print ("Bad MWLAE, MWLhost, port $mwlAE $mwlHost $mwlPort \n") if ($mwlPort == 0);
print ("Bad Img Mgr port $imPortHL7 \n") if ($imPortHL7 == 0);
print ("Bad MPPS AE, host, port $mppsAE $mppsHost $mppsPort \n") if ($mppsPort == 0);
print ("Bad IM DICOM Port: $imPortDICOM \n") if ($imPortDICOM == 0);

print `$MESA_TARGET/bin/kill_hl7 -e RST "localhost" $opPort`;
print `$MESA_TARGET/bin/kill_hl7 -e RST "localhost" $ofPort`;
print `$MESA_TARGET/bin/kill_hl7 -e RST "localhost" $imPortHL7`;

goodbye;

