#!/usr/local/bin/perl -w

# Evaluate images, storage commitment and MPPS messages
# sent by a modality for test 106.

use Env;
use lib "scripts";
require mod;

sub x_106_1 {
  print LOG "Modality Test 106.1 \n";
  print LOG " Evaluation of Composite Object \n";
  print LOG " PPS X6/X6_A1, X7/X7_A1 \n";

  my $verbose = shift(@_);

  my $masterFile = "$MESA_STORAGE/modality/T106/x1.dcm";

  print LOG " Patient ID: 583050\n";

  my @testImages = mod::find_images_by_patient_no_gsps_no_key_images($verbose,
			"583050");

  $count = scalar(@testImages);
  print LOG "Found $count images for Patient ID 583050\n" if $verbose;

  if (scalar(@testImages) == 0) {
    print LOG "No images are found for Patient ID 583050\n";
    print LOG "Failure for Performed Procedure X6/X6_A1, X7/X7_A1 \n";
    return 1;
  }

  $testFile = $testImages[0];
  print LOG "$testFile \n" if $verbose;

  $rtnValue = mod::eval_image_scheduled_group_case($logLevel, $verbose, $masterFile, $testFile);

  print LOG "\n";
  return $rtnValue;
}

sub x_106_2 {
  print LOG "Modality Test 106.2 \n";
  print LOG " MPPS Group Case, two requested procedures, two SPS \n";

  my $verbose    = shift(@_);
  my $aet        = shift(@_);

  my $masterFile = "$MESA_STORAGE/modality/T106/mpps.status";

  my @mpps = mod::find_mpps_dir_by_patient_id_no_gsps($verbose, $aet, "583050");
  $count = scalar(@mpps);
  if ($count != 1) {
    print LOG "Found $count MPPS directories for patient ID 583050 and AE Title $aet \n";
    print LOG "Expected to find exactly 1 MPPS directory.\n";
    print LOG "You should clear the MESA Image Manager and resend images/MPPS events.\n";
    return 1;
  }

  $testFile = "$mpps[0]/mpps.dcm";

  my $rtnValue = mod::eval_mpps_group($verbose, $aet, $masterFile, $testFile);

  print LOG "\n";
  return $rtnValue;
}

sub x_106_3 {
  print LOG "Modality Test 106.3 \n";
  print LOG " Evaluation of Composite Object (GSPS) \n";
  print LOG " PPS X6/X6_A1\n";

  my $verbose = shift(@_);

  my $masterFile = "$MESA_STORAGE/modality/T106_gsps_x6/gsps.dcm";

  $x = "$MESA_TARGET/bin/dcm_print_element -s 0040 0275 0040 0009 $masterFile";
  print LOG "$x\n" if $verbose;
  my $spsID = `$x`;
  chomp $spsID;
  print LOG " Patient ID: 583050, SPS ID: $spsID \n";


  my @testImages = mod::find_gsps_by_patient_sps_id($verbose,
			"583050", $spsID);

  $count = scalar(@testImages);
  print LOG "Found $count GSPS objects for Patient ID 583050, SPS ID $spsID\n" if $verbose;

  if (scalar(@testImages) == 0) {
    print LOG "No GSPS objects are found for Patient ID 583050, SPS ID $spsID\n";
    print LOG "Failure for Performed Procedure X6/X6_A1\n";
    return 1;
  }

  $testFile = $testImages[0];
  print LOG "$testFile \n" if $verbose;

  $rtnValue = mod::eval_image_scheduled_group_case($logLevel, $verbose, $masterFile, $testFile);

  print LOG "\n";
  return $rtnValue;
}

sub x_106_4 {
  print LOG "Modality Test 106.4 \n";
  print LOG " Evaluation of Composite Object (GSPS) \n";
  print LOG " PPS X7/X7_A1\n";

  my $verbose = shift(@_);

  my $masterFile = "$MESA_STORAGE/modality/T106_gsps_x7/gsps.dcm";

  $x = "$MESA_TARGET/bin/dcm_print_element -s 0040 0275 0040 0009 $masterFile";
  print LOG "$x\n" if $verbose;
  my $spsID = `$x`;
  chomp $spsID;
  print LOG " Patient ID: 583050, SPS ID: $spsID \n";


  my @testImages = mod::find_gsps_by_patient_sps_id($verbose,
			"583050", $spsID);

  $count = scalar(@testImages);
  print LOG "Found $count GSPS objects for Patient ID 583050, SPS ID $spsID\n" if $verbose;

  if (scalar(@testImages) == 0) {
    print LOG "No GSPS objects are found for Patient ID 583050, SPS ID $spsID\n";
    print LOG "Failure for Performed Procedure X7/X7_A1\n";
    return 1;
  }

  $testFile = $testImages[0];
  print LOG "$testFile \n" if $verbose;

  $rtnValue = mod::eval_image_scheduled_group_case($logLevel, $verbose, $masterFile, $testFile);

  print LOG "\n";
  return $rtnValue;
}

sub x_106_5 {
  print LOG "Modality Test 106.5 \n";
  print LOG " MPPS for GSPS, procedure X6\n";

  my $verbose    = shift(@_);
  my $aet        = shift(@_);
  my $masterFile = "$MESA_STORAGE/modality/T106_gsps_x6/mpps.status";

  $x = "$MESA_TARGET/bin/dcm_print_element -s 0040 0260 0008 0100 $masterFile";
  $aiCode = `$x`; chomp $aiCode;

  my @mpps = mod::find_mpps_dir_by_patient_id_perf_ai_modality(
	$verbose, $aet, "583050", $aiCode, "PR");
  $count = scalar(@mpps);
  if ($count != 1) {
    print LOG "Found $count MPPS directories for patient ID 583050 and AI code $aiCode \n";
    print LOG "Expected to find exactly 1 MPPS directory.\n";
    print LOG "You should clear the MESA Image Manager and resend images/MPPS events.\n";
    return 1;
  }

  $testFile = "$mpps[0]/mpps.dcm";

  my $rtnValue = mod::eval_mpps_scheduled($logLevel, $verbose, $aet, $masterFile, $testFile);

  print LOG "\n";
  return $rtnValue;
}

sub x_106_6 {
  print LOG "Modality Test 106.6 \n";
  print LOG " MPPS for GSPS, procedure X7\n";

  my $verbose    = shift(@_);
  my $aet        = shift(@_);
  my $masterFile = "$MESA_STORAGE/modality/T106_gsps_x7/mpps.status";

  $x = "$MESA_TARGET/bin/dcm_print_element -s 0040 0260 0008 0100 $masterFile";
  $aiCode = `$x`; chomp $aiCode;

  my @mpps = mod::find_mpps_dir_by_patient_id_perf_ai_modality(
	$verbose, $aet, "583050", $aiCode, "PR");
  $count = scalar(@mpps);
  if ($count != 1) {
    print LOG "Found $count MPPS directories for patient ID 583050 and AI code $aiCode \n";
    print LOG "Expected to find exactly 1 MPPS directory.\n";
    print LOG "You should clear the MESA Image Manager and resend images/MPPS events.\n";
    return 1;
  }

  $testFile = "$mpps[0]/mpps.dcm";

  my $rtnValue = mod::eval_mpps_scheduled($logLevel, $verbose, $aet, $masterFile, $testFile);

  print LOG "\n";
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
$logLevel = 4 if ($verbose);

open LOG, ">106/grade_106.txt" or die "Could not open log file 106/grade_106.txt";
my $mesaVersion = mesa::getMESAVersion();
print LOG "CTX: $mesaVersion \n";
$diff = 0;

$diff += x_106_1($verbose);

$diff += x_106_2($verbose, $aeTitle);

$diff += x_106_3($verbose);

$diff += x_106_4($verbose);

$diff += x_106_5($verbose, $aeTitle);

$diff += x_106_6($verbose, $aeTitle);

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 106/grade_106.txt \n";

exit $diff;
