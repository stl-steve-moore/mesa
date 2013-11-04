#!/usr/local/bin/perl -w

# Script sends initial report to Report Manager for test 1511.

use Env;
use Cwd;
use lib "scripts";
use lib "../common/scripts";
require rpt_mgr;
require mesa;

($rptHost, $rptPort, $rptAE) = rpt_mgr::read_config_params("rptmgr_secure.cfg");
print "Rpt Mgr Host:  $rptHost \n";
print "Rpt Mgr Port:  $rptPort \n";
print "Rpt Mgr Title: $rptAE \n";

mesa::cstore_secure("../../msgs/sr/601/sr_601cr.dcm", "", "MESA", "$rptAE", "$rptHost", "$rptPort",
	"randoms.dat", "mesa_1.key.pem", "mesa_1.cert.pem", "test_list.cert", "NULL-SHA");

