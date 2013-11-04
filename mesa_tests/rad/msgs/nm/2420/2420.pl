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
print "Generate static image pattern\n";
$? = nm::generate_pattern("1", "pixels.raw");

print "\nGenerate dcm object\n";
# Generate dcm object from raw pixel data and 2420.txt
nm::make_dcm_object("2420", "pixels.raw");

if ($?) {
  print "Could not create DCM object from $cfindTextFile \n";
} else {
  print "\nExtract NM frames from dcm object\n";
  # Extract NM frames from dcm object
  nm::extract_nm_frames("-p ENERGY=1 -p DETECTOR=2 -f 2420.params", "2420.dcm");
}

# Animate frames and dump it to file
print "\nAnimate frames..... \n";
nm::animate_frames("2420.params", "pixels", "MESA2420CINE.gif");
print "\nAnimated GIF file can be found at: $main::MESA_STORAGE/modality/NM/patterns/MESA2420CINE.gif\n";

