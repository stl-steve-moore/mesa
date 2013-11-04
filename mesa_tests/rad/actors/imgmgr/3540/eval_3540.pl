#!/usr/local/bin/perl -w

use Env;

use lib "scripts";
use lib "../../../common/scripts";
require imgmgr;
require mesa_get;

sub goodbye() {
  exit 1;
}

# These are the tests for Storage Commitment

sub x_3540_1 {
  print LOG "CTX: Image Manager 3540.1 \n";
  print LOG "CTX: Test for Storage Commitment\n";

  %neventHashTEST = mesa_get::getStorageCommitNEventHash(1, "wkstation/commit/st_comm/$titleSC");
  @neventArrayMESA = mesa_get::getStorageCommitNEventArray(1, "wkstation/commit/st_comm/MESA");

  my $rtnValue = 0;
  MESSAGE: foreach $message (@neventArrayMESA) {
    next MESSAGE if ($message eq ".");
    next MESSAGE if ($message eq "..");

    $uid = `$main::MESA_TARGET/bin/dcm_print_element 0008 1195 $message`;
    chomp $uid;
    if ($uid eq "") {
      print main::LOG "ERR: Could not get transaction UID for $message \n";
      $rtnValue = 1;
      next MESSAGE;
    }

    print main::LOG "CTX: $uid \n" if ($logLevel >= 3);

    $testFile = $neventHashTEST{$uid};
    if ($testFile eq "") {
      print main::LOG "ERR: No matching test file for $uid \n";
      $rtnValue = 1;
      next MESSAGE;
    }

    print main::LOG "CTX: $testFile \n";

    $x = "$main::MESA_TARGET/bin/evaluate_storage_commitment $message $testFile";
    print main::LOG "CTX: $x\n" if ($logLevel >= 3);

    print main::LOG `$x`;
    if ($? != 0) {
      $rtnValue = 1;
    }
  }
  return $rtnValue;

}

die "Usage <log level: 1-4> <AE Title Storage Commit SCP>" if (scalar(@ARGV) < 2);

$logLevel     = $ARGV[0];
$titleSC      = $ARGV[1];
open LOG, ">3540/grade_3540.txt" or die "Could not open output file: 3540/grade_3540.txt";
my $mesaVersion = mesa::getMESAVersion();
print LOG "CTX: $mesaVersion \n";

$diff = 0;

x_3540_1;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 3540/grade_3540.txt \n";

exit $diff;
