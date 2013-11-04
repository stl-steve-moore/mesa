#!/usr/local/bin/perl -w

use Env;

use lib "scripts";
require imgmgr;

sub goodbye() {
  exit 1;
}

# Examine the C-Move Responses

sub x_414_1 {
  print LOG "Image Manager 414.1 \n";
  print LOG "Evaluating the Key Object Note retrieved from Img Mgr\n";

  $diff += imgmgr::evaluate_cmove_key_object_note ($verbose,
		"../../msgs/sr/512/sr_512_ct.dcm",
		"414/sr_414_req.txt");

  print LOG "\n";
}


$verbose = grep /^-v/, @ARGV;
open LOG, ">414/grade_414.txt" or die "?!";
$diff = 0;

x_414_1;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 414/grade_414.txt \n";

exit $diff;
