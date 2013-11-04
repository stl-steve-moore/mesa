#!/usr/local/bin/perl -w

# Test script for test 1591: Modality / secure node tests.

use Env;
use Cwd;
use File::Copy;
use lib "scripts";
require mod;

$SIG{INT} = \&goodbye;

sub goodbye {
  exit 0;
}

$dir = cwd();
chdir "$MESA_TARGET/db";
`perl ./ClearSyslogTables.pl syslog`;
chdir $dir;

$syslogPortMESA = 4000;

#mod::create_send_audit("localhost", $syslogPortMESA,
#	"../../msgs/audit/1591/1591.010", "BEGIN_STORING_INSTANCES");

goodbye;

