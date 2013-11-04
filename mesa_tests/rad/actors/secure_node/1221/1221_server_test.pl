#!/usr/local/bin/perl -w


# Test script for testing secure servers: 1221

use Env;
use File::Copy;
use lib "scripts";
require secure;


$SIG{INT} = \&goodbye;

sub goodbye {
  exit 0;
}

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


$x = "$MESA_TARGET/bin/tls_client -l 3 -c $cipher $c/randoms.dat " .
	" $c/mesa_1.key.pem $c/mesa_1.cert.pem $c/test_list.cert " .
	" $secureServerHostTest $secureServerPortTest ";
print "$x \n";
print `$x`;

secure::tls_connect_error($secureServerHostTest, "$secureServerPortTest") if ($? != 0);

goodbye;

