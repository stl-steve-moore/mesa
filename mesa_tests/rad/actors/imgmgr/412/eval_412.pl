#!/usr/local/bin/perl -w

use Env;

use lib "scripts";
require imgmgr;

sub goodbye() {
  exit 1;
}

# Examine the C-Move Responses

sub x_412_1 {
  print LOG "Image Manager 412.1 \n";
  print LOG "Evaluating GSPS object (MLUT_P01) retrieved from Img Mgr\n";

  $rtnVal = imgmgr::evaluate_cmove_gsps_object ($verbose,
		"$MESA_STORAGE/disp_cons/mlut_p01.pre",
		"412/mask_412.txt");

  print LOG "\n";

  return $rtnVal;
}

sub x_412_2 {
  print LOG "Image Manager 412.2 \n";
  print LOG "Evaluating GSPS object (CPLX_P01) retrieved from Img Mgr\n";

  $rtnVal = imgmgr::evaluate_cmove_gsps_object ($verbose,
		"$MESA_STORAGE/disp_cons/cplx_p01.pre",
		"412/mask_412.txt");

  print LOG "\n";

  return $rtnVal;
}


$verbose = grep /^-v/, @ARGV;
open LOG, ">412/grade_412.txt" or die "?!";
$diff = 0;

$diff += x_412_1;
$diff += x_412_2;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 412/grade_412.txt \n";

exit $diff;
