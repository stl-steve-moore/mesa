#!/usr/local/bin/perl -w

# Self-test script for test 1502: Image Manager

use Env;
use Cwd;
use File::Copy;
use lib "scripts";
require imgmgr;

$SIG{INT} = \&goodbye;

sub goodbye {
  exit 0;
}

$dir = cwd();
chdir "$MESA_TARGET/db";
`perl ./ClearSyslogTables.pl syslog`;
chdir $dir;

# DICOM Query (C-Find request from Image Display)
imgmgr::create_send_audit("localhost", "4000",
	"../../msgs/audit/1502/1502.024", "DICOM_QUERY");

