#!/usr/local/bin/perl -w

# General package for MESA scripts.  This file contains all the announcments.

use Env;

package mesa_evaluate;
require Exporter;
@ISA = qw(Exporter);

# validate_xml_schema
#  Args:	output level (1-4)
#		schema file: pointer to a file
#		xmlFile: the file to be evaluated

sub validate_xml_schema {
  my $level = shift(@_);
  my $schema = shift(@_);
  my $xmlFile = shift(@_);

  $rtnValueEval = 1;

  print "\nEvaluating $xmlFile\n";
  print main::LOG "\nEvaluating $xmlFile\n";
  my $x = "$main::MESA_TARGET/bin/mesa_xml_eval ";
  $x .= " -l $level ";
  $x .= " -s $schema ";
  $x .= " $xmlFile";

  print main::LOG "$x \n";
  print main::LOG `$x`;
  if ($? == 0) {
    $rtnValueEval = 0;
  } else {
    print main::LOG "XML document $xmlFile does not pass schema validation.\n";
  }

  return $rtnValueEval;
}

1;

