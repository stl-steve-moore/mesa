#!/usr/local/bin/perl -w


# Test script for testing secure servers: 1226

use Env;
use File::Copy;
use lib "scripts";
require secure;


$SIG{INT} = \&goodbye;

sub goodbye {
  exit 0;
}

# Main starts here

print "This script is deprecated in this directory.\n";
print "If you are testing secure servers,\n";
print "you belong in the secure_server directory.\n";

exit 1;

($syslogPortMESA,
 $syslogHostTest, $syslogPortTest,
 $secureServerHostTest, $secureServerPortTest) = secure::read_config_params();

print "Illegal MESA Syslog Port: $syslogPortMESA \n" if ($syslogPortMESA == 0);
print "Illegal Test Syslog Host: $syslogHostTest \n" if ($syslogHostTest eq "");
print "Illegal Test Syslog Port: $syslogPortTest \n" if ($syslogPortTest == 0);
print "Illegal Test Secure Server Host: $secureServerHostTest \n" if ($secureServerHostTest eq "");
print "Illegal Test Secure Server Port: $secureServerPortTest \n" if ($secureServerPortTest == 0);

$c = "$MESA_TARGET/runtime/certificates";

$cipher = "NULL-SHA";

if (scalar(@ARGV) == 1) {
 $cipher = $ARGV[0];
}


$x = "$MESA_TARGET/bin/cecho_secure -C $c/mesa_1.cert.pem " .
	" -K $c/mesa_1.key.pem " .
	" -P $c/test_list.cert " .
	" -R $c/randoms.dat " .
	" -Z $cipher " .
	" $secureServerHostTest $secureServerPortTest ";
print "$x \n";
print `$x`;

secure::tls_connect_error($secureServerHostTest, "$secureServerPortTest") if ($? != 0);

goodbye;

