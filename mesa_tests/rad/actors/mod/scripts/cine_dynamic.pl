#!/usr/local/bin/perl -w

# This script takes a NM image and produces a CINE
# loop of the image in GIF format.

use Env;
use lib "scripts";
require mod;

sub produce_cine {
  my ($logLevel, $outputFile, $inputFile, $idx, $energyWindow, $detector, $phase, $timeSlice) = @_;
  if ($MESA_OS eq "WINDOWS_NT") {
    $outputFile =~ s(\\)(\/)g;
  }
  my ($dir, $fileName) = split ("/", $outputFile);
  $fileName =~ m/22\d+cine(\d+)/;
#  my $idx = $1;

  print "CTX: Creating output cine file $outputFile.gif\n" if ($logLevel >= 3);
  $bitsPerPixel = `$main::MESA_TARGET/bin/dcm_print_element 0028 0100 $inputFile`;
  chomp $bitsPerPixel;
  print "\$bitsPerPixel: $bitsPerPixel\n";
  if ($bitsPerPixel != 8) {
    print "CTX: Bits/Pixel greater than 8\n";
    print "CTX: Running dcm_map_to_8 on input file\n";
    $tempFile = $dir ."/" . $dir .$idx . "mapto8.dcm";
    my $xx = "$main::MESA_TARGET/bin/dcm_map_to_8 -Z $inputFile $tempFile";
    `$xx`;
    die "Could not execute $xx\n" if $?;
    $inputFile = $tempFile;
  }
  print "CTX: Extract NM frames from dcm object\n";

  # Extract NM frames from dcm object
  mod::extract_nm_frames("-p ENERGY=$energyWindow -p DETECTOR=$detector -p PHASE=$phase -p TIMESLICE=$timeSlice -f $dir/$fileName.params", "$inputFile", "$dir/pixels");

  # Animate frames and dump it to file
  print "CTX: Animate frames..... \n";
  mod::animate_frames("$dir/$fileName.params", "$dir/pixels", "$outputFile.gif");

  print "CTX: Creating output cine file $outputFile.gif\n" if ($logLevel >= 3);
  print "CTX: Energy Window: $energyWindow\n";
  print "CTX: Detector:      $detector\n";
  print "CTX: Phase:         $phase\n";
  print "CTX: Time Slice:    $timeSlice\n";
  $rtnValue = 0;

  return $rtnValue;
}

### Main starts here

if (scalar(@ARGV) < 7) {
  print "Usage: <log level> <input file> <file base> <Energy Window> <Detector> <Phase> <Time Slice>\n";
  exit 1;
}

my $logLevel     = $ARGV[0];
my $inputFile    = $ARGV[1];
my $fileBase     = $ARGV[2];
my $energyWindow = $ARGV[3];
my $detector     = $ARGV[4];
my $phase        = $ARGV[5];
my $timeSlice    = $ARGV[6];

my $imageType  = "DYNAMIC";

  my $idx = 101;
  my $t = mod::get_NM_image_type($logLevel, $inputFile);
  print "Image Type from candidate file: $t\n" if ($logLevel >= 3);
  if ($t eq $imageType) {
    my $x = produce_cine($logLevel, "$fileBase$idx", $inputFile, $idx, $energyWindow, $detector, $phase, $timeSlice);
    die "Could not produce cine image from $inputFile\n" if $x != 0;
    $foundAtLeastOneFlag = 1;
  }

die "Found no matching images for type $imageType\n" if ($foundAtLeastOneFlag == 0);
