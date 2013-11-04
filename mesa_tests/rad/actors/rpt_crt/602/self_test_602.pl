#!/usr/local/bin/perl -w

# Self test for Report Creator test 602.

use Env;
use Cwd;
use lib "scripts";
require rpt_crt;

if ($MESA_OS eq "WINDOWS_NT") {
  $storageDirectory = "$MESA_STORAGE\\rpt_manager\\instances";
} else {
  $storageDirectory = "$MESA_STORAGE/rpt_manager/instances";
}

rpt_crt::delete_directory($storageDirectory);
rpt_crt::create_directory($storageDirectory);

$dir = cwd();
chdir ("$MESA_TARGET/db");
print "Clearing Report Manager database \n";
print `perl ClearImgMgrTables.pl rpt_manager`;
chdir ($dir);

rpt_crt::cstore("../../msgs/sr/602/sr_602cr.dcm", "", "MESA_RPT_MGR", "localhost", "2700");
rpt_crt::cstore("../../msgs/sr/602/sr_602ct.dcm", "", "MESA_RPT_MGR", "localhost", "2700");
rpt_crt::cstore("../../msgs/sr/602/sr_602mr.dcm", "", "MESA_RPT_MGR", "localhost", "2700");
