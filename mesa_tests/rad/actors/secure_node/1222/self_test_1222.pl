#!/usr/local/bin/perl -w

# Self test for test 1222.

use Env;
use File::Copy;
use lib "scripts";
require secure;


$SIG{INT} = \&goodbye;

sub goodbye {
  exit 0;
}

($syslogPortMESA,
 $syslogHostTest, $syslogPortTest) = secure::read_config_params();

print "Illegal MESA Syslog Port: $syslogPortMESA \n" if ($syslogPortMESA == 0);
print "Illegal Test Syslog Host: $syslogHostTest \n" if ($syslogHostTest eq "");
print "Illegal Test Syslog Port: $syslogPortTest \n" if ($syslogPortTest == 0);

$c = "$MESA_TARGET/runtime/certificates";

$cipher = "NULL-SHA";
#$cipher = "DES-CBC3-SHA";

if (scalar(@ARGV) == 1) {
 $cipher = $ARGV[0];
}

$x = "$MESA_TARGET/bin/tls_client -a -c $cipher $c/randoms.dat " .
	" $c/test_sys_1.key.pem $c/test_sys_1.cert.pem $c/mesa_list.cert " .
	" localhost 4101";
print "$x \n";
print `$x`;

secure::tls_connect_error("localhost", "4101") if ($? != 0);

goodbye;

