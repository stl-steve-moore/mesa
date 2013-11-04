#!/usr/local/bin/perl -w


# Self test script for secure (client) nodes: 1227

use Env;
use File::Copy;
use lib "scripts";
require secure;
use lib "../common/scripts";
require mesa;


$SIG{INT} = \&goodbye;

sub goodbye {
  exit 0;
}

# Main starts here
print "Self test for Secure Node DICOM test 1227\n\n";

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


$x = "$MESA_TARGET/bin/cecho_secure " .
	" -C $c/test_sys_1.cert.pem " .
	" -K $c/test_sys_1.key.pem " .
	" -P $c/mesa_1.cert.pem " .
	" -R $c/randoms.dat " .
	" -Z $cipher " .
	" localhost 2351 ";
print "$x \n";
print `$x`;

secure::tls_connect_error("localhost", 2351) if ($? != 0);

mesa::dump_text_file("secure_test.cfg");
print "Self test 1227 complete - successful DICOM Verification with MESA server.\n";

goodbye;

