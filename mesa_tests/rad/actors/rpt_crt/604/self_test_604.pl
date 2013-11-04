#!/usr/local/bin/perl -w

# Self test for Report Creator test 604.

use Env;
use Cwd;
use lib "scripts";
use lib "../../../common/scripts";
require rpt_crt;
require mesa_common;

$storageDirectory = "$MESA_STORAGE/rpt_manager/instances";

mesa::delete_directory(0, $storageDirectory);
mesa::create_directory(0, $storageDirectory);

$dir = cwd();
chdir ("$MESA_TARGET/db");
print "Clearing Report Manager database \n";
print `perl ClearImgMgrTables.pl rpt_manager`;
chdir ($dir);

rpt_crt::cstore("../../msgs/sr/604/sr_604cr.dcm", "", "MESA_RPT_MGR", "localhost", "2700");
rpt_crt::cstore("../../msgs/sr/604/sr_604ct.dcm", "", "MESA_RPT_MGR", "localhost", "2700");
rpt_crt::cstore("../../msgs/sr/604/sr_604mr.dcm", "", "MESA_RPT_MGR", "localhost", "2700");
