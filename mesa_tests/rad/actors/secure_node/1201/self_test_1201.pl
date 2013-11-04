#!/usr/local/bin/perl -w


# Self test for test 1201.

use Env;
use File::Copy;
use lib "scripts";
require secure;


$SIG{INT} = \&goodbye;

sub goodbye {
  exit 0;
}

# Find hostname of this machine
$host = `hostname`; chomp $host;

($syslogPortMESA,
 $syslogHostTest, $syslogPortTest) = secure::read_config_params();

print "Illegal MESA Syslog Port: $syslogPortMESA \n" if ($syslogPortMESA == 0);
print "Illegal Test Syslog Host: $syslogHostTest \n" if ($syslogHostTest eq "");
print "Illegal Test Syslog Port: $syslogPortTest \n" if ($syslogPortTest == 0);

$x = "$MESA_TARGET/bin/ihe_audit_message -t STARTUP 1201/startup.txt 1201/startup.xml ";
print "$x \n";
print `$x`;

secure::audit_message_error("1201 STARTUP") if ($? != 0);

$x = "$MESA_TARGET/bin/syslog_client -t PID -f 10 -s 0 localhost $syslogPortMESA 1201/startup.xml";

print "$x \n";
print `$x`;

secure::transmit_error("1201/startup.xml", "localhost", $syslogPortMESA) if ($? != 0);

goodbye;

