#!/usr/local/bin/perl -w

# Script sends initial report to Report Manager for 15xx tests.

use Env;
use Cwd;
use lib "scripts";
require rpt_repos;

($rptHost, $rptPort, $rptAE) = rpt_repos::read_config_params("rptrepos_secure.cfg");
print "Rpt Repos Host:  $rptHost \n";
print "Rpt Repos Port:  $rptPort \n";
print "Rpt Repos Title: $rptAE \n";

#`perl 80x/make_sr_80x.pl`;

rpt_repos::cstore_secure("../../msgs/sr/601/sr_601cr.dcm", "", "$rptAE", "$rptHost", "$rptPort",
	"randoms.dat", "mesa_1.key.pem", "mesa_1.cert.pem", "test_list.cert", "NULL-SHA");
rpt_repos::cstore_secure("../../msgs/sr/601/sr_601cr_v.dcm", "", "$rptAE", "$rptHost", "$rptPort",
	"randoms.dat", "mesa_1.key.pem", "mesa_1.cert.pem", "test_list.cert", "NULL-SHA");
rpt_repos::cstore_secure("../../msgs/sr/601/sr_601ct.dcm", "", "$rptAE", "$rptHost", "$rptPort",
	"randoms.dat", "mesa_1.key.pem", "mesa_1.cert.pem", "test_list.cert", "NULL-SHA");
rpt_repos::cstore_secure("../../msgs/sr/601/sr_601mr.dcm", "", "$rptAE", "$rptHost", "$rptPort",
	"randoms.dat", "mesa_1.key.pem", "mesa_1.cert.pem", "test_list.cert", "NULL-SHA");

rpt_repos::cstore_secure("../../msgs/sr/601/sr_601cr.dcm", "", "$rptAE", "localhost", "2800",
	"randoms.dat", "mesa_1.key.pem", "mesa_1.cert.pem", "test_list.cert", "NULL-SHA");
rpt_repos::cstore_secure("../../msgs/sr/601/sr_601cr_v.dcm", "", "$rptAE", "localhost", "2800",
	"randoms.dat", "mesa_1.key.pem", "mesa_1.cert.pem", "test_list.cert", "NULL-SHA");
rpt_repos::cstore_secure("../../msgs/sr/601/sr_601ct.dcm", "", "$rptAE", "localhost", "2800",
	"randoms.dat", "mesa_1.key.pem", "mesa_1.cert.pem", "test_list.cert", "NULL-SHA");
rpt_repos::cstore_secure("../../msgs/sr/601/sr_601mr.dcm", "", "$rptAE", "localhost", "2800",
	"randoms.dat", "mesa_1.key.pem", "mesa_1.cert.pem", "test_list.cert", "NULL-SHA");

