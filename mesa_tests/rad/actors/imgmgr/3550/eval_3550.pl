#!/usr/local/bin/perl -w

use Env;

use lib "../../../common/scripts";
require mesa_evaluate;

sub goodbye() {
  exit 1;
}

# CFind Response

sub x_3550_1 {
 print LOG "CTX: Image Manager 3550.1 \n";
 print LOG "CTX:  Evaluating CFind Response to query by SOP Class UID\n";

 my (@directoryList) = mesa_get::getDirectoryListFullPathByExtension(
	$logLevel, "dcm", "3550/cfind_q1/test");

 $x = scalar(@directoryList);
 if ($x != 1) {
  print LOG "ERR: Found wrong number of C-Find responses ($x), should be 1\n";
  return 1;
 }

 $testFile = $directoryList[0];

 (@directoryList) = mesa_get::getDirectoryListFullPathByExtension(
	$logLevel, "dcm", "3550/cfind_q1/mesa");

 $x = scalar(@directoryList);
 if ($x != 1) {
  print LOG "ERR: Found wrong number of MESA C-Find responses ($x), should be 1\n";
  print LOG "ERR: This is a runtime or configuration error; file a bug report\n";
  return 1;
 }

 $mesaFile = $directoryList[0];

 ($x, $testInstanceUID) = mesa_get::getDICOMValue($logLevel, $testFile,
	"", "0008 0018", 1);
 ($x, $mesaInstanceUID) = mesa_get::getDICOMValue($logLevel, $mesaFile,
	"", "0008 0018", 1);

 if ($logLevel >= 3) {
  print LOG "CTX: <TEST>0008 0018 $testInstanceUID\n";
  print LOG "CTX: <MESA>0008 0018 $mesaInstanceUID\n";
 }

 if ($testInstanceUID ne $mesaInstanceUID) {
  print LOG "CTX: <TEST>0008 0018 $testInstanceUID\n";
  print LOG "CTX: <MESA>0008 0018 $mesaInstanceUID\n";
  print LOG "CTX: SOP Instance UID in test response differs from MESA response\n";
  return 1;
 }

 return 0;
}

### Main starts here

die "Usage: <log level: 1-4> <AE Title Storage Commit SCU>" if (scalar(@ARGV) < 2);

$logLevel = $ARGV[0];
#$titleStorageCommit = $ARGV[1];
open LOG, ">3550/grade_3550.txt" or die "?!";
$diff = 0;

$diff += x_3550_1;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 3550/grade_3550.txt \n";

exit $diff;
