#!/usr/local/bin/perl
# This script changes the Study Instance UID in our Scheduling Message.
# Arguments:
#		Input file
#		UID

use Env;

if (scalar(@ARGV) != 2) {
  print "Usage: <input file> <sop instance UID> \n";
  exit 1;
}

if ($MESA_OS eq "WINDOWS_NT") {
  $x = "$MESA_TARGET\\bin\\hl7_set_value -d ihe -f $ARGV[0] -a ZDS 1 0 $ARGV[1]^100^Application^DICOM";
} else {
  $x = "$MESA_TARGET/bin/hl7_set_value -d ihe -f $ARGV[0] -a ZDS 1 0 $ARGV[1]^100^Application^DICOM";
}
print "$x \n";
print `$x`;

exit 1 if ($?);

exit 0;
