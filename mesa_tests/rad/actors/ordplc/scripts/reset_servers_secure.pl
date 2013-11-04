#!/usr/local/bin/perl -w

# Sends reset messages to MESA servers.
use Env;
use Cwd;
use lib "scripts";
require ordplc;

$SIG{INT} = \&goodbye;

sub goodbye () {
  exit 0;
}

$C = "$MESA_TARGET/runtime/certificates/mesa_1.cert.pem";
$K = "$MESA_TARGET/runtime/certificates/mesa_1.key.pem";
$P = "$MESA_TARGET/runtime/certificates/test_list.cert";
$R = "$MESA_TARGET/runtime/certificates/randoms.dat";

print "$MESA_TARGET/bin/kill_hl7_secure -C $C -K $K -P $P -R $R -e RST localhost 2100 \n";
print `$MESA_TARGET/bin/kill_hl7_secure -C $C -K $K -P $P -R $R -e RST localhost 2100`;

$C = "$MESA_TARGET/runtime/certificates/test_sys_1.cert.pem";
$K = "$MESA_TARGET/runtime/certificates/test_sys_1.key.pem";
$P = "$MESA_TARGET/runtime/certificates/mesa_list.cert";
$R = "$MESA_TARGET/runtime/certificates/randoms.dat";

print "$MESA_TARGET/bin/kill_hl7_secure -C $C -K $K -P $P -R $R -e RST localhost 2200 \n";
print `$MESA_TARGET/bin/kill_hl7_secure -C $C -K $K -P $P -R $R -e RST localhost 2200`;

$dir = cwd();
chdir ("$MESA_TARGET/db");

print "Clearing Syslog database \n";
`perl ClearSyslogTables.pl syslog`;

chdir ($dir);

goodbye;


