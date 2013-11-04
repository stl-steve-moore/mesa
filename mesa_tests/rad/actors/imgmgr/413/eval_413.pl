#!/usr/local/bin/perl -w

# Evaluation script for Image Manager test 413.

use Env;

use lib "scripts";
require imgmgr;

sub goodbye() {
  exit 1;
}


# Examine the MPPS messages forwarded by the Image Manager

sub x_413_1 {
  print LOG "Image Manager 413.1 \n";
  print LOG "Count the responses to Key Object Note query \n";

  my $testCount = mesa::count_files_in_directory("413/results/a/imgmgr");
  my $mesaCount = mesa::count_files_in_directory("413/results/a/mesa");

  if ($testCount != 1) {
    print LOG "Found $testCount responses from your system, expected 1\n";
    print LOG " This is a failure and will abort the test\n";
    return 1;
  }

  if ($mesaCount != 1) {
    print LOG "Found $mesaCount responses from MESA system, expected 1\n";
    print LOG " This will abort the test. It implies that the MESA \n";
    print LOG " software failed. Make sure the proper data was loaded \n";
    print LOG " with the load scripts. Contact the Project Manager \n";
    print LOG " for assistance.\n";
    return 1;
  }

  print LOG "\n";
  return 0;
}

sub x_413_2 {
 print LOG "Image Manager 413.2 \n";
 print LOG "Evaluate Content Date (0008 0023) \n";

 my $testValue = imgmgr::get_dicom_attribute(
	"413/results/a/imgmgr/msg1_result.dcm", "0008", "0023");

 my $mesaValue = imgmgr::get_dicom_attribute(
	"413/results/a/mesa/msg1_result.dcm", "0008", "0023");

 print LOG " MESA $mesaValue test $testValue \n" if $verbose;

 if ($testValue ne $mesaValue) {
  print LOG "0008 0023 Content Date\n";
  print LOG " MESA <$mesaValue> Your Value <$testValue> \n";
  print LOG " This is a failure.\n\n";
  return 1;
 }

 print LOG "\n";
 return 0;
}

sub x_413_3 {
 print LOG "Image Manager 413.3 \n";
 print LOG "Evaluate Content Date (0008 0033) \n";

 my $testValue = imgmgr::get_dicom_attribute(
	"413/results/a/imgmgr/msg1_result.dcm", "0008", "0033");

 my $mesaValue = imgmgr::get_dicom_attribute(
	"413/results/a/mesa/msg1_result.dcm", "0008", "0033");

 print LOG " MESA $mesaValue test $testValue \n" if $verbose;

 if ($testValue ne $mesaValue) {
  print LOG "0008 0033 Content Time\n";
  print LOG " MESA <$mesaValue> Your Value <$testValue> \n";
  print LOG " This is a failure.\n\n";
  return 1;
 }

 print LOG "\n";
 return 0;
}

sub x_413_4 {
 print LOG "Image Manager 413.4 \n";
 print LOG "Evaluate Content Date (0040 A032) \n";

 my $testValue = imgmgr::get_dicom_attribute(
	"413/results/a/imgmgr/msg1_result.dcm", "0040", "a032");

 my $mesaValue = imgmgr::get_dicom_attribute(
	"413/results/a/mesa/msg1_result.dcm", "0040", "a032");

 print LOG " MESA $mesaValue test $testValue \n" if $verbose;

 if ($testValue ne $mesaValue) {
  print LOG "0040 A032 Content Time\n";
  print LOG " MESA <$mesaValue> Your Value <$testValue> \n";
  print LOG " This is a failure.\n\n";
  return 1;
 }

 print LOG "\n";
 return 0;
}

sub x_413_5 {
 print LOG "Image Manager 413.5 \n";
 print LOG "Evaluate Concept Name Code Seq (0040 A043), Code Value (0008 0100) \n";

 my $testValue = imgmgr::get_dicom_seq_attribute(
	"413/results/a/imgmgr/msg1_result.dcm",
	"0040", "A043", "0008", "0100");

 my $mesaValue = imgmgr::get_dicom_seq_attribute(
	"413/results/a/mesa/msg1_result.dcm",
	"0040", "A043", "0008", "0100");

 print LOG " MESA $mesaValue test $testValue \n" if $verbose;

 if ($testValue ne $mesaValue) {
  print LOG "0040 A043 0008 0100 Concept Name Code Seq: Code Value\n";
  print LOG " MESA <$mesaValue> Your Value <$testValue> \n";
  print LOG " This is a failure.\n\n";
  return 1;
 }

 print LOG "\n";
 return 0;
}

sub x_413_6 {
 print LOG "Image Manager 413.6 \n";
 print LOG "Evaluate Concept Name Code Seq (0040 A043), Code Scheme (0008 0102) \n";

 my $testValue = imgmgr::get_dicom_seq_attribute(
	"413/results/a/imgmgr/msg1_result.dcm",
	"0040", "A043", "0008", "0102");

 my $mesaValue = imgmgr::get_dicom_seq_attribute(
	"413/results/a/mesa/msg1_result.dcm",
	"0040", "A043", "0008", "0102");

 print LOG " MESA $mesaValue test $testValue \n" if $verbose;

 if ($testValue ne $mesaValue) {
  print LOG "0040 A043 0008 0102 Concept Name Code Seq: Code Scheme Desig\n";
  print LOG " MESA <$mesaValue> Your Value <$testValue> \n";
  print LOG " This is a failure.\n\n";
  return 1;
 }

 print LOG "\n";
 return 0;
}

sub x_413_7 {
 print LOG "Image Manager 413.7 \n";
 print LOG "Evaluate Concept Name Code Seq (0040 A043), Code Meaning (0008 0104) \n";

 my $testValue = imgmgr::get_dicom_seq_attribute(
	"413/results/a/imgmgr/msg1_result.dcm",
	"0040", "A043", "0008", "0104");

 my $mesaValue = imgmgr::get_dicom_seq_attribute(
	"413/results/a/mesa/msg1_result.dcm",
	"0040", "A043", "0008", "0104");

 print LOG " MESA $mesaValue test $testValue \n" if $verbose;

 if ($testValue ne $mesaValue) {
  print LOG "0040 A043 0008 0104 Concept Name Code Seq: Code Meaning\n";
  print LOG " MESA <$mesaValue> Your Value <$testValue> \n";
  print LOG " This is a failure.\n\n";
  return 1;
 }

 print LOG "\n";
 return 0;
}

# Main starts here

if (scalar(@ARGV) < 1) {
  print "This script requires one argument: <AE Title of your MPPS Mgr> \n";
  exit 1;
}

#$titleMPPSMgr = $ARGV[0];
$verbose = grep /^-v/, @ARGV;

open LOG, ">413/grade_413.txt" or die "?!";
$diff = 0;

$diff += x_413_1;
if ($diff == 0) {
 $diff += x_413_2;
 $diff += x_413_3;
 $diff += x_413_4;
 $diff += x_413_5;
 $diff += x_413_6;
 $diff += x_413_7;
}

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 413/grade_413.txt \n";

exit $diff;
