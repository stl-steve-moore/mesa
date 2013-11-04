#!/usr/local/bin/perl -w

# This script produces the 201 test data for Modalities

use Env;

print "This script has been retired and should not be used.\n";
print " Please use the 2xx/2xx.pl script instead.\n";
exit 1;

if (scalar(@ARGV) != 1) {
  print "This script takes one argument, the modality to test: CR, CT, MR, US...\n";
  exit 1;
}

$x = "perl scripts/produce_unscheduled_images.pl $ARGV[0] MODALITY1 583020 " .
     "  P1 T201 X1 MR/MR4/MR4S1 WHITE_CHARLES";

print "$x \n";
print `$x`;

$D = "$MESA_STORAGE/modality/T201";

$x = "$MESA_TARGET/bin/dcm_modify_object -i 201/201.del " .
	" $D/x1.dcm 201/x1.dcm ";
print "$x \n";
print `$x`;

$x = "$MESA_TARGET/bin/dcm_modify_object -i 201/201.del " .
	" $D/mpps.crt 201/mpps.crt";
print "$x \n";
print `$x`;


$x = "$MESA_TARGET/bin/dcm_modify_object -i 201/201.del " .
	" $D/mpps.status 201/mpps.status";
print "$x \n";
print `$x`;

