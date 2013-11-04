#!/usr/local/bin/perl -w

use Env;
use lib "../../../common/scripts";
require "mesa_evaluate.pm";
require "mesa_common.pm";

# 301: Evaluate Images Stored and Storage Commitment Request

sub x_301_1 {
 my $errorCount = 0;
 print LOG "\n\nCTX: Evidence Creator: 301.1 \n";
 print LOG "CTX: Storage Commitment Requests \n";
 
 $errorCount = mesa_evaluate::eval_storage_commit_SCU_requests(
					$logLevel,
					"$MESA_STORAGE/imgmgr/commit/$scAETitle",
					"imgmgr"
					);
 return $errorCount;
}

### Main starts here

die "Usage: <log level: 1-4> <Storage Commit SCU AE Title> " if (scalar(@ARGV) < 2);
$logLevel = $ARGV[0];
open LOG, ">301/grade_301.txt" or die "Could not open 301/grade_301.txt";
my $mesaVersion = mesa_get::getMESAVersion();
my ($x, $date, $timeToMinute, $timeToSec) = mesa_get::getDateTime(0);
print LOG "CTX: Evidence Creator test 301\n";
print LOG "CTX: $mesaVersion \n";
print LOG "CTX: current date/time $date $timeToMinute\n";
print LOG "CTX: Log level: $logLevel\n";

$scAETitle = $ARGV[1];

$diff = 0;

$diff += x_301_1;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 301/grade_301.txt \n";

exit $diff;
