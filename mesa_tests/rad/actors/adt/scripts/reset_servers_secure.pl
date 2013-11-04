#!/usr/local/bin/perl -w

# Sends reset messages to MESA servers.
use Env;
use Cwd;
use lib "scripts";
require adt;

$SIG{INT} = \&goodbye;

sub goodbye () {
  print "Exiting...\n";

  exit 0;
}

sub xmit_error {
  my $f = shift(@_);

  print "Unable to send message: $f \n";
  exit 1;
}

%varnames = mesa::get_config_params("adt_test_secure.cfg");
$mesaOrderFillerPortHL7     = $varnames{"MESA_ORD_FIL_PORT_HL7"};
$mesaOrderPlacerPortHL7     = $varnames{"MESA_ORD_PLC_PORT_HL7"};


$C = "$MESA_TARGET/runtime/certificates/test_sys_1.cert.pem";
$K = "$MESA_TARGET/runtime/certificates/test_sys_1.key.pem";
$P = "$MESA_TARGET/runtime/certificates/mesa_1.cert.pem";
$R = "$MESA_TARGET/runtime/certificates/randoms.dat";

$x = "$MESA_TARGET/bin/kill_hl7_secure -C $C -K $K -P $P -R $R -e RST " .
     " localhost $mesaOrderPlacerPortHL7";
print `$x`;
$x = "$MESA_TARGET/bin/kill_hl7_secure -C $C -K $K -P $P -R $R -e RST " .
     " localhost $mesaOrderFillerPortHL7";
print `$x`;

$dir = cwd();
chdir ("$MESA_TARGET/db");
print "Clearing Syslog database \n";
`perl ClearSyslogTables.pl syslog`;
chdir ($dir);

adt::rm_file("$MESA_TARGET/logs/syslog/last_log.txt");
adt::rm_file("$MESA_TARGET/logs/syslog/last_log.xml");

goodbye;
