#!/usr/local/bin/perl -w

# Evaluation script for External Report Repository test 1011.

use Env;
use lib "scripts";
require rptrepos;

sub x_1011_1 {
  print LOG "External Report Repository Test 1011.1 \n";

  my $verbose = shift(@_);
  my $fileName = shift(@_);

  print LOG "$fileName\n" if $verbose;

  $x = "$MESA_TARGET/bin/mesa_sr_eval -t 2000:DCM ";
  $x .= " -v " if $verbose;
  $x .= $fileName;

  print LOG "$x\n";

  $rtnValue = 0;
  print LOG `$x`;

  $rtnValue = 1 if ($?);

  return $rtnValue;
}

### Main starts here

if (scalar(@ARGV) < 1) {
  print "This script takes one argument: <Patient ID> \n";
  exit 1;
}

$patientID = $ARGV[0];
$verbose = grep /^-v/, @ARGV;

open LOG, ">1011/grade_1011.txt" or die "?!";
$diff = 0;

@fileNames = rptrepos::lookup_sop_ins_files_by_patient_id($verbose, $patientID);
if (scalar(@fileNames) == 0) {
  print "Found no matching SOP Instances for patient ID $patientID\n";
  print LOG "Found no matching SOP Instances for patient ID $patientID\n";
  exit 1;
}

foreach $f (@fileNames) {
  $diff += x_1011_1($verbose, $f);
}

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 1011/grade_1011.txt \n";

exit $diff;
