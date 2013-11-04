#!/usr/local/bin/perl -w


# Self test script for secure (client) nodes: 1226

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
print "Self test for Secure Node DICOM test 1226\n\n";

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
	" -i EXPIRED -C $c/test_sys_1.cert.pem " .
	" -K $c/test_sys_1.key.pem " .
	" -P $c/expired.cert " .
	" -R $c/randoms.dat " .
	" -Z $cipher " .
	" localhost 2352 ";
print "$x \n";
print `$x`;

secure::tls_connect_error("localhost", 2352) if ($? != 0);

print "\nSelf test 1228 - successful DICOM Verification with MESA server \n" .
      "ignoring expired certificates.\n\n";

$x = "$MESA_TARGET/bin/cecho_secure " .
	" -C $c/test_sys_1.cert.pem " .
	" -K $c/test_sys_1.key.pem " .
	" -P $c/expired.cert " .
	" -R $c/randoms.dat " .
	" -Z $cipher " .
	" localhost 2352 ";
print "$x \n";
print `$x`;

secure::tls_connect_error("localhost", 2352) if ($? != 0);

print "Self test 1228 - successful DICOM Verification with MESA server \n" .
      "NOT ignoring expired certificates.\n" .
      "This indicates a problem, the verifcation is supposed to fail.\n";

goodbye;

