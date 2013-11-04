#!/usr/local/bin/perl -w

# Self test for Report Creator test 603-j.

use Env;
use Cwd;
use lib "scripts";
use lib "../common/scripts";
require rpt_crt;
require mesa;

if ($MESA_OS eq "WINDOWS_NT") {
  $storageDirectory = "$MESA_STORAGE\\rpt_manager\\instances";
} else {
  $storageDirectory = "$MESA_STORAGE/rpt_manager/instances";
}

mesa::delete_directory(1, $storageDirectory);
mesa::create_directory(1, $storageDirectory);

$dir = cwd();
chdir ("$MESA_TARGET/db");
print "Clearing Report Manager database \n";
print `perl ClearImgMgrTables.pl rpt_manager`;
chdir ($dir);

rpt_crt::cstore("../../msgs/sr/603-j/sr_603cr.dcm", "", "MESA_RPT_MGR", "localhost", "2700");
rpt_crt::cstore("../../msgs/sr/603-j/sr_603ct.dcm", "", "MESA_RPT_MGR", "localhost", "2700");
rpt_crt::cstore("../../msgs/sr/603-j/sr_603mr.dcm", "", "MESA_RPT_MGR", "localhost", "2700");
