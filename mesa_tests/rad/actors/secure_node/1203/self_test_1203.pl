#!/usr/local/bin/perl -w

# Self test for Secure Node test 1203.

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

$x = "$MESA_TARGET/bin/ihe_audit_message -t USER_AUTHENTICATED 1203/authentication.txt 1203/authentication.xml ";
print "$x \n";
print `$x`;

secure::audit_message_error("1203 USER AUTHENTICATION") if ($? != 0);

$x = "$MESA_TARGET/bin/syslog_client -f 10 -s 0 localhost $syslogPortMESA 1203/authentication.xml";

print "$x \n";
print `$x`;

secure::transmit_error("1203/authentication.xml", "localhost", $syslogPortMESA) if ($? != 0);

goodbye;

