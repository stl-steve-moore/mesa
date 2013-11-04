#!/usr/local/bin/perl -w

use Env;
use lib "..";
require nm;

$SIG{INT} = \&goodbye;

sub goodbye () {
  exit 1;
}

# End of subroutines, beginning of the main code
# Generate static image patttern
print "Generate dynamic image pattern\n";
$? = nm::generate_pattern("2", "pixels.raw");

print "\nGenerate dcm object\n";
# Create dcm object from the raw data file - dynamic image data
$? = nm::make_dcm_object("2422", "pixels.raw");

if ($?) {
  print "Could not create DCM object from 2422.txt\n";
} else {
  print "\nExtract NM frames from dcm object\n";
  # Extract NM frames from dcm object
  nm::extract_nm_frames("-p ENERGY=1 -p DETECTOR=2 -p PHASE=1 -f 2422.params", "2422.dcm");
}

# Animate frames and dump it to file
print "\nAnimate frames..... \n";
nm::animate_frames("2422.params", "pixels", "MESA2422CINE.gif");
print "\nAnimated GIF file can be found at: $main::MESA_STORAGE/modality/NM/patterns/MESA2422CINE.gif\n";
