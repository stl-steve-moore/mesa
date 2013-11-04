#!/usr/local/bin/perl -w


# Self test for test 1221.

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

$x = "$MESA_TARGET/bin/tls_client -c NULL-SHA $c/randoms.dat " .
	" $c/test_sys_1.key.pem $c/test_sys_1.cert.pem $c/mesa_list.cert " .
	" drno 4100";
print "$x \n";
print `$x`;

secure::tls_connect_error("localhost", "4100") if ($? != 0);

goodbye;

