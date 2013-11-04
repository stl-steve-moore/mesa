#!/usr/local/bin/perl -w

# This script takes a NM image and produces a CINE
# loop of the image in GIF format.

use Env;
use lib "scripts";
require mod;

sub produce_cine {
  my ($logLevel, $outputFile, $inputFile, $idx) = @_;

  if ($MESA_OS eq "WINDOWS_NT") {
    $outputFile =~ s(\\)(\/)g;
  }

  my ($dir, $fileName) = split ('/', $outputFile);

  $fileName =~ m/22\d+cine(\d+)/;

  print "CTX: Finding bits/pixel on dcm object\n";
  $bitsPerPixel = `$main::MESA_TARGET/bin/dcm_print_element 0028 0100 $inputFile`;
  chomp $bitsPerPixel;
  print "\$bitsPerPixel: $bitsPerPixel\n";
  if ($bitsPerPixel != 8) {
    print "CTX: Bits/Pixel greater than 8\n";
    print "CTX: Running dcm_map_to_8 on input file\n";
    $tempFile = $dir ."/". $dir . $idx . "mapto8.dcm";
    my $xx = "$main::MESA_TARGET/bin/dcm_map_to_8 -Z $inputFile $tempFile";
    `$xx`;
    die "Could not execute $xx\n" if $?;
#    system($xx);
#    system("$main::MESA_TARGET/bin/dcm_map_to_8 -Z $inputFile $tempFile");
    $inputFile = $tempFile;
  }
  print "CTX: Extract NM frames from dcm object\n";

  # Extract NM frames from dcm object
  mod::extract_nm_frames("-p ENERGY=0 -p DETECTOR=0 -p PHASE=0 -p TIMESLICE=0 -f $dir/$dir$idx.params", "$inputFile", "$dir/pixels");

  # Animate frames and dump it to file
  print "CTX: Animate frames..... \n";
  mod::animate_frames("$dir/$dir$idx.params", "$dir/pixels", "$outputFile.gif");
  print "CTX: Creating output cine file $outputFile.gif\n" if ($logLevel >= 3);
  $rtnValue = 0;

  return $rtnValue;
}

### Main starts here

if (scalar(@ARGV) < 4) {
  print "Usage: <log level> <input file> <type> <file base>\n";
  exit 1;
}

$logLevel   = $ARGV[0];
$inputImage = $ARGV[1];
$imageType  = $ARGV[2];
$fileBase   = $ARGV[3];

#@fileNames = mod::lookup_all_images($logLevel);
#
#if (scalar(@fileNames) == 0) {
#  print     "Found no Images for image type $imageType\n";
#  exit 1;
#}

my $idx = 101;
my $foundAtLeastOneFlag = 0;
#foreach $f(@fileNames) {
  my $f = $inputImage;
  my $t = mod::get_NM_image_type($logLevel, $f);
  print "Image Type from candidate file: $t\n" if ($logLevel >= 3);
  if ($t eq $imageType) {
    my $x = produce_cine($logLevel, "$fileBase$idx", $f, $idx);
    die "Could not produce cine image from $f\n" if $x != 0;
    $idx++;
    $foundAtLeastOneFlag = 1;
  }
#}

die "Found no matching images for type $imageType\n" if ($foundAtLeastOneFlag == 0);
