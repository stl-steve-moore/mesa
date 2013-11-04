#!/usr/local/bin/perl -w

use Env;
use lib "../../../common/scripts";
require "mesa_evaluate.pm";

# 311: 

sub x_311_1 {
 print LOG "\n\nCTX: Evidence Creator: 311.1 \n";
 print LOG "CTX: Look for one SOP Instance\n";
 
 my ($x, @fileNames) = mesa_get::getSOPInstanceFileNames($logLevel, "imgmgr");
 if (scalar(@fileNames) == 0) {
  print LOG "ERR: No SOP Instances found in imgmgr DB\n";
  return  "";
 }

 if (scalar(@fileNames) != 1) {
  $x = scalar(@fileNames);
  print LOG "ERR: Detected $x SOP instances; test requires one SOP instance only\n";
  print LOG "ERR: Please clear the Image Manager and send a single Encapsulated PDF document\n";

  return "";
 }

 return $fileNames[0];
}

sub x_311_2 {
 print LOG "\n\nCTX: Evidence Creator: 311.2 \n";
 print LOG "CTX: Evaluate Encapsulated PDF file\n";

 my ($logLevel, $f) = @_;
 print LOG "CTX: File name: $f\n" if ($logLevel >= 3);

 my ($x, $sopClass) = mesa_get::getDICOMValue($logLevel, $f, "", "0008 0016", 0);
 if ($x != 0) {
  print LOG "ERR: Could not get 0018 0016 from $f\n";
  return 1;
 }

 print LOG "CTX: SOP Class UID from file <$sopClass>\n" if ($logLevel >= 3);

 $expected = "1.2.840.10008.5.1.4.1.1.104.1";
 if ($sopClass ne $expected) {
  print LOG "ERR: SOP class from file ($sopClass) is not class for Encapsulated PDF ($expected)\n";
  print LOG "ERR: File name ins MESA_STORAGE: $f\n";
  return 1;
 }

 ($x, $mimeType) = mesa_get::getDICOMValue($logLevel, $f, "", "0042 0012", 0);
 if ($x != 0) {
  print LOG "ERR: Could not get 0042 0012 from $f\n";
  return 1;
 }

 print LOG "CTX: MIME type from file <$mimeType>\n" if ($logLevel >= 3);

 $expected = "application/pdf";
 if ($mimeType ne $expected) {
  print LOG "ERR: MIME type from file ($mimeType) is not ($expected)\n";
  print LOG "ERR: File name ins MESA_STORAGE: $f\n";
  return 1;
 }

 return 0;
}

sub x_311_3 {
 print LOG "\nCTX: Evidence Creator: 311.3 \n";
 print LOG "CTX: Dump Encapsulated PDF to a file\n";

 my ($logLevel, $f) = @_;

 my $x = "$MESA_TARGET/bin/dcm_dump_element 0042 0011 $f 311/311.pdf";
 `$x`;
 if ($?) {
  print LOG "ERR: Could not dump Encapsulated PDF to file\n";
  print LOG "ERR: Failed: $x\n";
  return 1;
 }
}
 

### Main starts here

die "Usage: <log level: 1-4> " if (scalar(@ARGV) < 1);
$logLevel = $ARGV[0];
open LOG, ">311/grade_311.txt" or die "Could not open 311/grade_311.txt";
my $mesaVersion = mesa_get::getMESAVersion();
my ($x, $date, $timeToMinute, $timeToSec) = mesa_get::getDateTime(0);
print LOG "CTX: Evidence Creator test 311\n";
print LOG "CTX: $mesaVersion \n";
print LOG "CTX: current date/time $date $timeToMinute\n";
print LOG "CTX: Log level: $logLevel\n";

$diff = 0;

my $fileName = x_311_1;
if ($fileName eq "") {
  print LOG "\nERR: Did not find a file for this test\n";
  $diff = 1;
} else {
  print LOG "CTX: Will evaluate $fileName\n";
  $diff += x_311_2($logLevel, $fileName);
  $diff += x_311_3($logLevel, $fileName);
}

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 311/grade_311.txt \n";

exit $diff;
