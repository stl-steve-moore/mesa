#!/usr/local/bin/perl -w


# Test script for testing secure servers: 1226

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
print "Secure Server DICOM test 1226\n\n";

%varnames = mesa::get_config_params("secure_test.cfg");
$syslogPortMESA       = $varnames{"MESA_SYSLOG_PORT"};
$syslogHostTest       = $varnames{"TEST_SYSLOG_HOST"};
$syslogPortTest       = $varnames{"TEST_SYSLOG_PORT"};
$secureServerAETest   = $varnames{"TEST_SECURE_SERVER_AE"};
$secureServerHostTest = $varnames{"TEST_SECURE_SERVER_HOST"};
$secureServerPortTest = $varnames{"TEST_SECURE_SERVER_PORT"};

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
	" -c $secureServerAETest " .
	" -C $c/mesa_1.cert.pem " .
	" -K $c/mesa_1.key.pem " .
	" -P $c/test_list.cert " .
	" -R $c/randoms.dat " .
	" -Z $cipher " .
	" $secureServerHostTest $secureServerPortTest ";
print "$x \n";
print `$x`;

secure::tls_connect_error($secureServerHostTest, "$secureServerPortTest") if ($? != 0);

mesa::dump_text_file("secure_test.cfg");
print "Server test 1226 complete - successful DICOM Verification with your server.\n" .
      "Run this test again, capture this output and send to Project Manager \n" .
      "as validation for this test.\n";

goodbye;

