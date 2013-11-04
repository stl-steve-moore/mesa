#!/usr/local/bin/perl -w

# Script sends initial report to Report Manager for 8xx tests.

use Env;
use Cwd;
use lib "scripts";
require rpt_repos;

($rptHost, $rptPort, $rptAE) = rpt_repos::read_config_params("rptrepos_test.cfg");
print "Rpt Repos Host:  $rptHost \n";
print "Rpt Repos Port:  $rptPort \n";
print "Rpt Repos Title: $rptAE \n";

#`perl 80x/make_sr_80x.pl`;

rpt_repos::cstore("../../msgs/sr/601-j/sr_601cr.dcm", "", "$rptAE", "$rptHost", "$rptPort");
rpt_repos::cstore("../../msgs/sr/601-j/sr_601cr_v.dcm", "", "$rptAE", "$rptHost", "$rptPort");
rpt_repos::cstore("../../msgs/sr/601-j/sr_601ct.dcm", "", "$rptAE", "$rptHost", "$rptPort");
rpt_repos::cstore("../../msgs/sr/601-j/sr_601mr.dcm", "", "$rptAE", "$rptHost", "$rptPort");

rpt_repos::cstore("../../msgs/sr/601-j/sr_601cr.dcm", "", "REPORT_ARCHVE", "localhost", "2800");
rpt_repos::cstore("../../msgs/sr/601-j/sr_601cr_v.dcm", "", "REPORT_ARCHVE", "localhost", "2800");
rpt_repos::cstore("../../msgs/sr/601-j/sr_601ct.dcm", "", "REPORT_ARCHVE", "localhost", "2800");
rpt_repos::cstore("../../msgs/sr/601-j/sr_601mr.dcm", "", "REPORT_ARCHVE", "localhost", "2800");

