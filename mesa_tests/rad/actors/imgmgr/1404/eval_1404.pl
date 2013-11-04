#!/usr/local/bin/perl -w

use Env;

use lib "scripts";
require imgmgr;

sub goodbye() {
  exit 1;
}

# Examine the C-Move Responses

sub x_1404_1 {
  print LOG "Image Manager 1404.1 \n";
  print LOG "Evaluating Evidence document object retrieved from Img Mgr\n";

  $rtnVal = imgmgr::evaluate_cmove_gsps_object ($verbose,
		"$MESA_TARGET/mesa_tests/rad/msgs/sr/1402/sr_1402_1.dcm",
		"1404/mask_1404.txt");

  print LOG "\n";

  return $rtnVal;
}


$verbose = grep /^-v/, @ARGV;
open LOG, ">1404/grade_1404.txt" or die "?!";
$diff = 0;

$diff += x_1404_1;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 1404/grade_1404.txt \n";

exit $diff;
