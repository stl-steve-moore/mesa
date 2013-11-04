#!/usr/local/bin/perl -w

# Evaluate images, storage commitment and MPPS messages
# sent by a modality for test 1591.

use Env;
use lib "scripts";
require mod;

sub x_211_1 {
  print LOG "Modality Test 1591.1 \n";
  print LOG " Evaluation of Composite Object \n";
  print LOG " PPS X1/X1_A1 \n";

  my $verbose = shift(@_);

  my $masterFile = "$MESA_STORAGE/modality/T1591/x1.dcm";

  $x = "$MESA_TARGET/bin/dcm_print_element -s 0040 0275 0040 0009 $masterFile";
  print LOG "$x\n" if $verbose;
  my $spsID = `$x`;
  chomp $spsID;
  print LOG " Patient ID: MM211, SPS ID: $spsID \n";

  my @testImages = mod::find_images_by_patient_sps_id($verbose, "MM211", $spsID);

  $count = scalar(@testImages);
  print LOG "Found $count images for Patient ID MM211, SPS ID $spsID \n" if $verbose;

  if (scalar(@testImages) == 0) {
    print LOG "No images are found for Patient ID MM211, SPS ID $spsID \n";
    print LOG "Failure for Performed Procedure X1/X1_A1 \n";
    return 1;
  }

  $testFile = $testImages[0];
  print LOG "$testFile \n" if $verbose;

  $rtnValue = mod::eval_image_scheduled($logLevel, $verbose, $masterFile, $testFile);

  print LOG "\n";
  return $rtnValue;
}

sub x_211_2 {
  print LOG "Modality Test 1591.2 \n";

  my $verbose    = shift(@_);
  my $aet        = shift(@_);

  my $masterFile = "$MESA_STORAGE/modality/T1591/mpps.status";
  my @mpps = mod::find_mpps_dir_by_patient_id($verbose, $aet, "MM211");
  $count = scalar(@mpps);
  if ($count != 1) {
    print LOG "Found $count MPPS directories for patient ID MM211 and AE Title $aet \n";
    print LOG "Expected to find exactly 1 MPPS directory.\n";
    print LOG "You should clear the MESA Image Manager and resend images/MPPS events.\n";
    return 1;
  }

  $testFile = "$mpps[0]/mpps.dcm";

  my $rtnValue = mod::eval_mpps_scheduled($logLevel, $verbose, $aet, $masterFile, $testFile);

  print LOG "\n";
  return $rtnValue;
}

sub x_1591_3 {
  print LOG "Acquisition Modality 1591.3 \n";
  print LOG "Audit Record Messages \n";

  my $rtnValue = 0;
  mod::clear_syslog_files();
  mod::extract_syslog_messages();
  my $xmlCount = mod::count_syslog_xml_files();
  if ($xmlCount < 1) {
    print LOG "No Audit Messages found in syslog database \n";
    $rtnValue = 1;
    return $rtnValue;
  }
  $rtnValue = mod::evaluate_all_xml_files();
  return $rtnValue;
}


### Main starts here

if (scalar(@ARGV) < 1) {
  print "This script takes one argument: <AE title of modality> \n";
  exit 1;
}

$aeTitle = $ARGV[0];
$verbose = grep /^-v/, @ARGV;
$logLevel = 1;
$logLevel = 4 if ($verbose == 1);

open LOG, ">1591/grade_1591.txt" or die "?!";
$diff = 0;

$diff += x_211_1($verbose);

$diff += x_211_2($verbose, $aeTitle);

$diff += x_1591_3($verbose);

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 1591/grade_1591.txt \n";

exit $diff;
