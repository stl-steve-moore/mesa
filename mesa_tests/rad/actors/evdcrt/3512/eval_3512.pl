#!/usr/local/bin/perl -w

use Env;
use lib "../../../common/scripts";
require "mesa_get.pm";
require "mesa_evaluate.pm";

#require "../../../common/scripts/mesa_get.pm";
#require "../../../common/scripts/mesa_evaluate.pm";

use lib "../common/scripts";
require "evaluate_fusion.pm";

sub goodbye() {
  exit 1;
}

# BSPS object

sub x_3512_1 {
 print LOG "\n\nCTX: Evidence Creator 3512.1 \n";
 print LOG "CTX:  Evaluating Spatial object\n";
 my ($y, @storedSOPInstance) = mesa_get::getSOPInstanceFileNames($logLevel, "imgmgr");

 my $x = mesa_evaluate::eval_spatial_evd_creator(
	$logLevel,
	"$MESA_STORAGE/FUSION/3512/SPATIAL/spatial.dcm",
	$storedSOPInstance[0],
    "$MESA_STORAGE/FUSION/3512/CT",
    "$MESA_STORAGE/FUSION/3512/PT",
	);

 return $x;
}

# Examine Storage Commitment
sub x_3512_2 {
 print LOG "\n\nCTX: Evidence Creator 3512.2 \n";
 print LOG "CTX:  Evaluating Storage Commitment\n";

  my ($status, @commitFiles) = mesa_get::getOpenSCRequests($logLevel, $titleStorageCommit);

  if ($status != 0) {
    print LOG "ERR: Unable to get list of open Storage Commit requests\n";
    return 1;
  }
  if (scalar(@commitFiles) != 1) {
    my $x = scalar(@commitFiles);
    print LOG "ERR: Expected 1 open storage commitment request; found $x\n";
    return 1;
  }

  my $f = $commitFiles[0];
  print "Open commit request $f\n";
  my ($x, @referencedSOP) = mesa_get::getReferencedSOPSequence($logLevel, $f);
  my ($y, @storedSOPInstance) = mesa_get::getSOPInstancesFromDB($logLevel, "imgmgr");

  if ($logLevel >= 3) {
    print LOG "CTX: Storage Commit referenced SOP Instances\n";
    foreach $sop(@referencedSOP) {
      print LOG "CTX:  $sop\n";
    }
    print LOG "CTX: Image Manager DB stored SOP Instances\n";
    foreach $sop(@storedSOPInstance) {
      print LOG "CTX: $sop\n";
    }
  }

  $x = scalar(@referencedSOP);
  $y = scalar(@storedSOPInstance);
  if ($x != $y) {
    print LOG "ERR: Number of referenced SOP Instances in open SC request: $x\n";
    print LOG "ERR: Number of SOP Instances in MESA Image Manager DB:      $y\n";
    print LOG "ERR: The values should be equal for storage commitment success\n";
    return 1;
  }

  foreach $sop(@referencedSOP) {
    my @tokens = split /:/, $sop;
    $instance = $tokens[0];
    $class    = $tokens[1];
    $h{$instance} = $class;
  }

  my $rtnValue = 0;
  foreach $sop(@storedSOPInstance) {
    $class = $h{$sop};
    if (!$class) {
      $rtnValue = 1;
      print LOG "ERR: No matching Storage Commit request for SOP Ins $sop\n";
    } elsif ($class eq "") {
      $rtnValue = 1;
      print LOG "ERR: No matching Storage Commit request for SOP Ins $sop\n";
    }
  }

 return $rtnValue;
}

### Main starts here

die "Usage: <log level: 1-4> <AE Title Storage Commit SCU>" if (scalar(@ARGV) < 2);

$logLevel = $ARGV[0];
$titleStorageCommit = $ARGV[1];
open LOG, ">3512/grade_3512.txt" or die "?!";
$diff = 0;

$diff += x_3512_1;
$diff += x_3512_2;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 3512/grade_3512.txt \n";

exit $diff;
