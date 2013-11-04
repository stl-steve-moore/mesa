#!/usr/local/bin/perl -w

# Self test for Secure Node test 11122.

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

$x = "$MESA_TARGET/bin/ihe_audit_message -t ATNA_CONFIGURATION 11122/configuration.txt 11122/configuration.xml ";
print "$x \n";
print `$x`;

secure::audit_message_error("11122 ATNA_CONFIGURATION") if ($? != 0);

$x = "$MESA_TARGET/bin/syslog_client -f 10 -s 0 localhost $syslogPortMESA 11122/configuration.xml";

print "$x \n";
print `$x`;

secure::transmit_error("11122/configuration.xml", "localhost", $syslogPortMESA) if ($? != 0);

goodbye;

