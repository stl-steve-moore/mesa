#!/usr/local/bin/perl -w

use Env;
use lib "..";
require nm;

my %RR  = ( 
	    "RR1" => 1,
	    "RR2" => 2,
	    "RR3" => 3,
	  );

$SIG{INT} = \&goodbye;

sub goodbye () {
  exit 1;
}

# End of subroutines, beginning of the main code
# Generate static image patttern
print "Generate dynamic image pattern\n";
$? = nm::generate_pattern("3", "pixels.raw");

print "\nGenerate dcm object\n";
# Create dcm object from the raw data file - dynamic image data
$? = nm::make_dcm_object("2423", "pixels.raw");

foreach my $rr (keys %RR) {
 if ($?) {
  print "Could not create DCM object from 2423.txt\n";
 } else {
  print "\nExtract NM frames from dcm object with RR=$RR{$rr}\n";
  # Extract NM frames from dcm object
  nm::extract_nm_frames("-p ENERGY=1 -p DETECTOR=1 -p RR=$RR{$rr} -f 2423.params", "2423.dcm");
 }

 # Animate frames and dump it to file
 print "\nAnimate frames..... \n";
 nm::animate_frames("2423.params", "pixels", "MESA2423". $rr . "CINE.gif");
 print "\nAnimated GIF file can be found at: $main::MESA_STORAGE/modality/NM/patterns/MESA2423". $rr ."CINE.gif\n";
}
