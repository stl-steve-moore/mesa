#!/usr/local/bin/perl
# This script changes an arbitrary field in an HL7 message.
# Arguments:
#		Input file
#		Segment name
#		Field number
#		New value
#		Optional: Index of repeated segment (1, 2, 3 ...)

use Env;

if (scalar(@ARGV) < 4 || scalar(@ARGV) > 5) {
  print "Usage: <input file> <segment> <field num> <value> [index]";
  exit 1
}

$SEGMENT = $ARGV[1];
$FIELD = $ARGV[2];
$VALUE = $ARGV[3];
$INDEX = 1;
if (scalar(@ARGV) == 5) {
 $INDEX = $ARGV[4];
}

if ($MESA_OS eq "WINDOWS_NT") {
  $x = "$MESA_TARGET\\bin\\hl7_set_value -d ihe -f $ARGV[0]  -i $INDEX $SEGMENT $FIELD 0 $VALUE";
} else {
  $x = "$MESA_TARGET/bin/hl7_set_value -d ihe -f $ARGV[0]  -i $INDEX $SEGMENT $FIELD 0 $VALUE";

}

print "$x \n";

print `$x`;

exit 1 if ($?);

exit 0;
