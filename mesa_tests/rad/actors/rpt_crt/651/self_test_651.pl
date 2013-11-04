#!/usr/local/bin/perl -w

# Self test for Report Creator test 651.

use Env;
use Cwd;
use lib "scripts";
require rpt_crt;

$storageDirectory = "$MESA_STORAGE/rpt_manager/instances";

rpt_crt::delete_directory($storageDirectory);
rpt_crt::create_directory($storageDirectory);

$dir = cwd();
chdir ("$MESA_TARGET/db");
print "Clearing Report Manager database \n";
print `perl ClearImgMgrTables.pl rpt_manager`;
chdir ($dir);

rpt_crt::cstore("../../msgs/sr/611/sr_611.dcm", "", "MESA_RPT_MGR", "localhost", "2700");
