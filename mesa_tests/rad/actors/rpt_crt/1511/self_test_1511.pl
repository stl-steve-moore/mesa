#!/usr/local/bin/perl -w

# Self-test script for test 1511: Report Creator

use Env;
use Cwd;
use File::Copy;
use lib "scripts";
require rpt_crt;

$SIG{INT} = \&goodbye;

sub goodbye {
  exit 0;
}

$dir = cwd();
chdir "$MESA_TARGET/db";
`perl ./ClearSyslogTables.pl syslog`;
chdir $dir;

# Begin-storing-instances
rpt_crt::create_send_audit("localhost", "4000",
	"../../msgs/audit/1511/1511.010", "BEGIN_STORING_INSTANCES");

