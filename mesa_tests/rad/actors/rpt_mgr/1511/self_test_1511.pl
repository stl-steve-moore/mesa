#!/usr/local/bin/perl -w

# Self-test script for test 1511: Report Manager

use Env;
use Cwd;
use File::Copy;
use lib "scripts";
use lib "../common/scripts";
require rpt_mgr;
require mesa;

$SIG{INT} = \&goodbye;

sub goodbye {
  exit 0;
}

$dir = cwd();
chdir "$MESA_TARGET/db";
`perl ./ClearSyslogTables.pl syslog`;
chdir $dir;

print `perl scripts/clear_report_repository.pl`;

$syslogPortMESA = 4000;

# DICOM-instances-used
mesa::create_send_audit("localhost", $syslogPortMESA,
	"../../msgs/audit/1511/1511.012", "INSTANCES_USED");

# Beging-storing-instances
mesa::create_send_audit("localhost", $syslogPortMESA,
	"../../msgs/audit/1511/1511.014", "BEGIN_STORING_INSTANCES");

mesa::cstore_secure("../../msgs/sr/601/sr_601cr_v.dcm", "", "MESA", "MESA_RPT_REPOS", "localhost", "2800",
	"randoms.dat", "test_sys_1.key.pem", "test_sys_1.cert.pem", "mesa_list.cert", "NULL-SHA");

