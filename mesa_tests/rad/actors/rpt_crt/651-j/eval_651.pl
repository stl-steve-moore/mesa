#!/usr/local/bin/perl -w

use Env;

use lib "scripts";
use lib "../common/scripts";
require rpt_crt;
require mesa;

sub goodbye() {
  exit 1;
}

# Search for all SR objects that match on Patient ID

sub find_candidate_files {
  my $tag = shift(@_);
  my $val = shift(@_);
  print LOG "Report Creator 651-j\n";
  print LOG " Tag = $tag, val = $val \n";

 @srFiles = rpt_crt::find_matching_composite_objs ($verbose, $tag, $val);

 $s = scalar(@srFiles);
 print LOG "Matching SR files: $s\n";
 if ($s == 0) {
  print "No files found in MESA Report Manager that match $tag $val \n";
  print LOG "No files found in MESA Report Manager that match $tag $val \n";
 }

 print LOG "\n";
}

sub evaluate_candidate_files {
  $rtnValueEval = 1;

  foreach $f (@srFiles) {
    print LOG "\nEvaluating $f\n";
    my $x = "$MESA_TARGET/bin/mesa_sr_eval ";
    $x .= " -v " if $verbose;
    $x .= " -t 2000:DCMR $f";

    print LOG "$x \n";
    print LOG `$x`;
    if ($? == 0) {
      $rtnValueEval = 0;
    } else {
      print LOG "SR object $f does not pass SR evaluation.\n";
    }
  }

  $diff += $rtnValueEval;
  return 0;
}

if (scalar(@ARGV) < 1) {
  print "This script requires one argument: \n" .
        "    <Patient ID>\n";
  exit 1;
}

$patientID = $ARGV[0];


$verbose = grep /^-v/, @ARGV;

open LOG, ">651-j/grade_651.txt" or die "?!";
$diff = 0;

find_candidate_files("0010 0020", $patientID);
evaluate_candidate_files;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 651-j/grade_651.txt \n";

exit $diff;
