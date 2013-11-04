#!/usr/local/bin/perl -w

# Self test for Report Manager test 654.

use Env;
use Cwd;
use lib "scripts";
require rpt_mgr;

print `perl scripts/clear_report_repository.pl`;

rpt_mgr::cstore("../../msgs/sr/604-j/sr_604ct_modified.dcm", "", "MESA_RPT_REPOS", "localhost", "2800");
