#!/usr/local/bin/perl -w

# General package for MESA scripts.
# This file contains scripts get "get" values from files or databases.

use Env;

package mesa;
require Exporter;
@ISA = qw(Exporter);

# We do not wish to export any subroutines.
@EXPORT = qw(
);

# Usage: getFieldLog(log level, file name, segment name, field number,
#		component, field name)
# returns:
#  (0, value) on success
#  (1, "") on failure


sub getFieldLog {
  my ($logLevel, $hl7File, $seg, $field, $comp, $fieldName) = @_;

  my $x = "$main::MESA_TARGET/bin/hl7_get_value -d ihe-iti -f $hl7File $seg $field $comp";
  print "$x\n" if ($logLevel >= 3);
  my $y = `$x`;

  if ($?) {
    print "Could not get $fieldName from $hl7File \n";
    return (1, "");
  }

  chomp $y;
  return (0, $y);
}

sub getFieldRepeatedSegment {
  my ($logLevel, $hl7File, $seg, $segmentIndex, $field, $comp, $fieldName) = @_;

  my $x = "$main::MESA_TARGET/bin/hl7_get_value -i $segmentIndex -d ihe-iti -f $hl7File $seg $field $comp";
  print "$x\n" if ($logLevel >= 3);
  my $y = `$x`;

  if ($?) {
    print "Could not get $fieldName from $hl7File \n";
    return (1, "");
  }

  chomp $y;
  return (0, $y);
}

sub getMESAVersion {
  open(H, "< $main::MESA_TARGET/runtime/version.txt") || return "Unable to open $main::MESA_TARGET/runtime/version.txt";

  my $ v = <H>;
  chomp $v;
  return $v;
}

1;
