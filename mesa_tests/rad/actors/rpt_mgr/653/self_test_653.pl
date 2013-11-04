#!/usr/local/bin/perl -w

# Self test for Report Manager test 653.

use Env;
use Cwd;
use lib "scripts";
require rpt_mgr;

print `perl scripts/clear_report_repository.pl`;

rpt_mgr::cstore("../../msgs/sr/603/sr_603mr_one_ref.dcm", "", "MESA_RPT_REPOS", "localhost", "2800");
