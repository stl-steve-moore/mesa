#!/usr/local/bin/perl -w

use Env;
use lib "..";
require nm;

$SIG{INT} = \&goodbye;

sub goodbye () {
  exit 1;
}

$patternDir = "$main::MESA_STORAGE/modality/NM/patterns/";

# End of subroutines, beginning of the main code
# Generate static image patttern
print "Generate static image pattern\n";
nm::generate_pattern("6", "pixels.raw");

print "\nGenerate dcm object\n";
# Generate dcm object from raw pixel data and 2405.txt
nm::make_dcm_object("2405", "pixels.raw");

print "CTX: Running dcm_map_to_8 on input file\n";
$tempFile = $patternDir. "2405mapto8.dcm";
system("$main::MESA_TARGET/bin/dcm_map_to_8 $patternDir/2405.dcm $patternDir/2405mapto8.dcm");

if ($?) {
  print "Could not create DCM object from $cfindTextFile \n";
} else {
  print "\nExtract NM frames from dcm object\n";
  # Extract NM frames from dcm object
  nm::extract_nm_frames("-p ENERGY=0 -p DETECTOR=0 -f 2405.params", "2405mapto8.dcm");
}

# Animate frames and dump it to file
print "\nAnimate frames..... \n";
nm::animate_frames("2405.params", "pixels", "MESA2405.gif");
print "\nAnimated GIF file can be found at: $main::MESA_STORAGE/modality/NM/patterns/MESA2405.gif\n";

# Move DCM map_to_8 file to DCM file
rename($tempFile, "$patternDir/2405.dcm") || die "Cannot rename file: $!\n";
