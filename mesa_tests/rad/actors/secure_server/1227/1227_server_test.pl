#!/usr/local/bin/perl -w


# Test script for testing secure servers: 1227

use Env;
use File::Copy;
use lib "../secure_node/scripts";
require secure;
use lib "../common/scripts";
require mesa;


$SIG{INT} = \&goodbye;

sub goodbye {
  exit 0;
}

# Main starts here

print "Secure server DICOM Test 1227 \n";

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

mesa::dump_text_file("secure_test.cfg");

$x = "$MESA_TARGET/bin/cecho_secure " .
	" -C $c/unregistered.cert " .
	" -K $c/unregistered.key " .
	" -P $c/test_list.cert " .
	" -R $c/randoms.dat " .
	" -Z $cipher " .
	" $secureServerHostTest $secureServerPortTest ";
print "$x \n";
print `$x`;

secure::tls_connect_error($secureServerHostTest, "$secureServerPortTest") if ($? != 0);

print "Server test 1227 complete - successful DICOM Verification with your server.\n";

goodbye;

