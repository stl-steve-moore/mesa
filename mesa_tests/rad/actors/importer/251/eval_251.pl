#!/usr/local/bin/perl -w

# Evaluate images, storage commitment and MPPS messages
# sent by a modality for test 251.

use Env;
use lib "../../../common/scripts";
use lib "scripts";
require mesa_common;
require imp;

sub goodbye {}

sub x_251_1 {
  print LOG "Importer Test 251.1 \n";
  print LOG " Association Negotiation for Storage Commitment \n";

  $rtnValue = 0;

  $x = "$MESA_TARGET/bin/sc_scp_association -v -a MESA_IMG_MGR -c $testStorageCommitmentAE";
  $x .= " $testStorageCommitmentHost $testStorageCommitmentPort";


  print LOG "$x\n";
  print LOG `$x`;
  $rtnValue = 1 if ($?);

  return $rtnValue;
}


### Main starts here
%varnames = mesa_get::get_config_params("imp_test.cfg");
if (imp::test_var_names(%varnames) != 0) {
  print "Some problem with the variables in imp_test.cfg\n";
  exit 1;
}


$testStorageCommitmentAE = $varnames{"TEST_IMPORTER_STORAGE_COMMITMENT_AE"};
$testStorageCommitmentHost = $varnames{"TEST_IMPORTER_STORAGE_COMMITMENT_HOST"};
$testStorageCommitmentPort = $varnames{"TEST_IMPORTER_STORAGE_COMMITMENT_PORT"};

die "No config value for TEST_IMPORTER_STORAGE_COMMITMENT_AE specified \n" if ($testStorageCommitmentAE eq "");
die "No config value for TEST_IMPORTER_STORAGE_COMMITMENT_HOST specified \n" if ($testStorageCommitmentHost eq "");
die "No config value for TEST_IMPORTER_STORAGE_COMMITMENT_PORT specified \n" if ($testStorageCommitmentPort eq "");


open LOG, ">251/grade_251.txt" or die "?!";
$diff = 0;

$diff += x_251_1();

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 251/grade_251.txt \n";

exit $diff;
