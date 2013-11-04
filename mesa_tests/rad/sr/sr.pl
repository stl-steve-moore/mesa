#!/usr/local/bin/perl

# This script creates SR documents from text files

use Env;

@SRFiles = ("sr_601cr",
	    "sr_601ct",
	    "sr_601mr",
	    "sr_602cr",
	    "sr_602ct",
	    "sr_602mr",
	    "sr_603cr",
	    "sr_603ct",
	    "sr_603mr");

foreach $f(@SRFiles) {
  print "$f \n";
  print "$MESA_TARGET/bin/dcm_create_object -i $f.txt $f.dcm \n";
  print `$MESA_TARGET/bin/dcm_create_object -i $f.txt $f.dcm`;
}

