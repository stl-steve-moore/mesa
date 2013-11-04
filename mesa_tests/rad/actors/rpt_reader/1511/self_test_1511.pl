#!/usr/local/bin/perl -w

# Self-test script for test 1511: Report Reader

use Env;
use Cwd;
use File::Copy;
use lib "scripts";
use lib "../common/scripts";
require mesa;

$SIG{INT} = \&goodbye;

sub goodbye {
  exit 0;
}

$dir = cwd();
chdir "$MESA_TARGET/db";
`perl ./ClearSyslogTables.pl syslog`;
chdir $dir;

$syslogPortMESA = 4000;

# DICOM-instances-used
mesa::create_send_audit("localhost", $syslogPortMESA,
	"../../msgs/audit/1511/1511.022", "INSTANCES_USED");

