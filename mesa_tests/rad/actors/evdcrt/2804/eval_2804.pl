#!/usr/local/bin/perl -w

# Evaluate DICOM NMI objects

use Env;
use lib "../../../common/scripts";
use lib "../common/scripts";
require mesa_common;
require mesa_evaluate;
require mesa_dicom_eval;

sub goodbye {}

sub x_2804_1 {
  print LOG "\nCTX: Evidence Creator 2804.1 \n";
  print LOG "CTX: Export Results Test Conversion Type\n";

  my ($logLevel, $path) = @_;

  my ($x, $conversionType) = mesa_get::getDICOMValue($logLevel, $path, "", "0008 0064", "");
  print LOG "CTX: Conversion Type <$conversionType>\n" if ($logLevel >= 3);

  if ($conversionType ne "WSD") {
   print LOG "ERR: Conversion type (0008 0064) was <$conversionType>\n";
   print LOG "ERR: Conversion type should be WSD\n";
   return 1;
  }
  return 0;
}

sub x_2804_2 {
  print LOG "\nCTX: Evidence Creator 2804.2 \n";
  print LOG "CTX: Export Results Test Series Description\n";

  my ($logLevel, $path) = @_;

  my ($x, $seriesDescription) = mesa_get::getDICOMValue($logLevel, $path, "", "0008 103E", "");
  print LOG "CTX: Series Description 0008 103E <$seriesDescription>\n";

  if ($seriesDescription eq "") {
   print LOG "ERR: Series Description (0008 103E) was empty\n";
   print LOG "ERR: Series Description should include indication these are result screens\n";
   return 1;
  }
  return 0;
}

sub x_2804_3 {
  print LOG "\nCTX: Evidence Creator 2804.3 \n";
  print LOG "CTX: Export Results Test Derivation Description\n";

  my ($logLevel, $path) = @_;

  my ($status, $x) = mesa_get::getDICOMValue($logLevel, $path, "", "0008 2111", "");
  print LOG "CTX: Derivation Description 0008 2111 <$x>\n";

  if ($x eq "") {
   print LOG "ERR: Derivation Description (0008 2111) was empty\n";
   print LOG "ERR: Derivation Description should include description of the nature of the resuts and/or processing that generated them\n";
   return 1;
  }
  return 0;
}

sub x_2804_4 {
  print LOG "\nCTX: Evidence Creator 2804.4 \n";
  print LOG "CTX: Export Results Test Preferred Playback Sequencing\n";

  my ($logLevel, $path) = @_;

  my ($status, $x) = mesa_get::getDICOMValue($logLevel, $path, "", "0018 1244", "");
  print LOG "CTX: Preferred Playback Sequencing 0018 1244 <$x>\n" if ($logLevel >= 3);

  if ($x ne "0") {
   print LOG "ERR: Preferred Playback Sequencing (0018 1244) was <$x>\n";
   print LOG "ERR: Preferred Playback Sequencing should be 0\n";
   return 1;
  }
  return 0;
}

sub x_2804_5 {
  print LOG "\nCTX: Evidence Creator 2804.5 \n";
  print LOG "CTX: Export Results Frame Time\n";

  my ($logLevel, $path) = @_;

  my ($status, $x) = mesa_get::getDICOMValue($logLevel, $path, "", "0018 1063", "");
  print LOG "CTX: Frame Time 0018 1063 <$x>\n";

  if ($x eq "") {
   print LOG "ERR: Frame Time (0018 1063) was empty\n";
   return 1;
  }
  return 0;
}

sub x_2804_6 {
  print LOG "\nCTX: Evidence Creator 2804.6 \n";
  print LOG "CTX: Export Results Cine Rate\n";

  my ($logLevel, $path) = @_;
  my $rtnValue = 0;

  ($x, $cineRate) = mesa_get::getDICOMValue($logLevel, $path, "", "0018 0040", "");
  print LOG "CTX: Cine Rate 0018 0040 <$cineRate>\n";

  if ($cineRate eq "") {
   print LOG "ERR: Cine Rate (0018 0040) was empty\n";
   $rtnValue = 1;
  }

  ($x, $recommendedDispFrameRate) = mesa_get::getDICOMValue($logLevel, $path, "", "0008 2144", "");
  print LOG "CTX: Recommended Display Frame Rate <$recommendedDispFrameRate>\n";

  if ($recommendedDispFrameRate eq "") {
   print LOG "ERR: Recommended Display Frame Rate (0008 2144) was empty\n";
   $rtnValue = 1;
  }

  if ($cineRate ne $recommendedDispFrameRate) {
   print LOG "ERR: Cine Rate (0018 0040) differs from Recommended Display Frame Rate (0008 2144)\n";
   print LOG "ERR: 0018 0040 <$cineRate>\n";
   print LOG "ERR: 0008 2144 <$recommendedDispFrameRate>\n";
   $rtnValue = 1;
  }
  return $rtnValue;
}

### Main starts here
 die "Usage: <log level> path \n" if (scalar(@ARGV) < 2);

 my $outputLevel = $ARGV[0];
 my $path = $ARGV[1];

 open LOG, ">2804/grade_2804.txt" or die "?!";
 my $mesaVersion = mesa_get::getMESAVersion();
 my ($x, $date, $timeToMinute, $timeToSec) = mesa_get::getDateTime(0);
 print LOG "CTX: $mesaVersion \n";
 print LOG "CTX: current date/time $date $timeToMinute\n";

 $diff = 0;
 $diff += x_2804_1($outputLevel, $path);
 $diff += x_2804_2($outputLevel, $path);
 $diff += x_2804_3($outputLevel, $path);
 $diff += x_2804_4($outputLevel, $path);
 $diff += x_2804_5($outputLevel, $path);
 $diff += x_2804_6($outputLevel, $path);

 print LOG "2804: Total errors: $diff\n";
 print "2804: Total errors: $diff\n";

 print "Logs stored in 2804/grade_2804.txt \n";

 exit $diff;

