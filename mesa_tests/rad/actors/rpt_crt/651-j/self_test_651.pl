#!/usr/local/bin/perl -w

# Self test for Report Creator test 651.

use Env;
use Cwd;
use lib "scripts";
use lib "../lib/scripts";
require rpt_crt;
require mesa;

$storageDirectory = "$MESA_STORAGE/rpt_manager/instances";

mesa::delete_directory(1, $storageDirectory);
mesa::create_directory(1, $storageDirectory);

$dir = cwd();
chdir ("$MESA_TARGET/db");
print "Clearing Report Manager database \n";
print `perl ClearImgMgrTables.pl rpt_manager`;
chdir ($dir);

rpt_crt::cstore("../../msgs/sr/611-j/sr_611.dcm", "", "MESA_RPT_MGR", "localhost", "2700");
