#!/usr/local/bin/perl -w

# Self test for test 1503.

use Env;
use File::Copy;
use lib "scripts";
use lib "../common/scripts";
require rpt_repos;
require mesa;

$syslogPortMESA = 4000;

mesa::create_send_audit("localhost", $syslogPortMESA,
	"../../msgs/audit/1511/1511.016", "DICOM_QUERY");

