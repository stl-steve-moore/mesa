#!/usr/local/bin/perl -w

# Script sends initial report to Report Manager for test 603.

use Env;
use Cwd;
use lib "scripts";
require rpt_mgr;

($rptHost, $rptPort, $rptAE) = rpt_mgr::read_config_params("rptmgr_test.cfg");
print "Rpt Mgr Host:  $rptHost \n";
print "Rpt Mgr Port:  $rptPort \n";
print "Rpt Mgr Title: $rptAE \n";

rpt_mgr::cstore("../../msgs/sr/603-j/sr_603mr.dcm", "", "$rptAE", "$rptHost", "$rptPort");

