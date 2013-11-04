#!/usr/local/bin/perl -w

use Env;

use lib "scripts";
use lib "../common/scripts";
require rpt_mgr;
require mesa;

sub goodbye() {
  exit 1;
}

# Search for all SR objects that match on accession number

sub find_candidate_files {
  my $tag = shift(@_);
  my $val = shift(@_);
  print LOG "Report Manager 601\n";
  print LOG " Tag = $tag, val = $val \n";

 @srFiles = rpt_mgr::find_matching_composite_objs ($verbose, $tag, $val);

 $s = scalar(@srFiles);
 print LOG "Matching SR files: $s\n";
 if ($s == 0) {
  print "No files found in MESA Report Repository that match $tag $val \n";
  print LOG "No files found in MESA Report Repository that match $tag $val \n";
 }

 print LOG "\n";
}

sub evaluate_candidate_files {
  $rtnValueEval = 1;
  $rtnValueCompare = 1;

  foreach $f (@srFiles) {
    print LOG "\nEvaluating $f\n";
    $x = "$MESA_TARGET/bin/mesa_sr_eval ";
    $x .= " -v " if $verbose;
    $x .= " -r 601/sr_601_req.txt -o PREDECESSOR ";
    $x .= " -p ../../msgs/sr/601/sr_601cr_v.dcm -t 2000:DCMR $f";

    print LOG "$x \n";
    print LOG `$x`;
    if ($? == 0) {
      $rtnValueEval = 0;
    } else {
      print LOG "SR object $f does not pass SR evaluation.\n";
    }

    $x = "$MESA_TARGET/bin/compare_dcm -m 601/sr_601.ini";
    $x .= " -o " if $verbose;
    $x .= " ../../msgs/sr/601/sr_601cr_v.dcm $f";
    print LOG "$x \n";
    print LOG `$x`;
    if ($? == 0) {
      $rtnValueCompare = 0;
    } else {
      print LOG "SR object $f does not pass SR compare test.\n";
    }

    print LOG "\n";

  }

  $diff += $rtnValueEval + $rtnValueCompare;
}

sub x_1511_1 {
  print LOG "Rpt Manager 1511.1 \n";
  print LOG "Audit Record Messages \n";
  mesa::clear_syslog_files();
  mesa::extract_syslog_messages();
  my $xmlCount = mesa::count_syslog_xml_files();
  if ($xmlCount < 1) {
    print LOG "We expect at least 2 audit messages from your Report Manager System.\n";
    print LOG " We received $xmlCount messages \n";
    print LOG " That is a failure; we will evaluate any messages found\n";
    $diff += 1;
  }
  $diff += mesa::evaluate_all_xml_files();
}


$verbose = grep /^-v/, @ARGV;

open LOG, ">1511/grade_1511.txt" or die "?!";
$diff = 0;

find_candidate_files("0008 0050", "2001C30");
evaluate_candidate_files;
x_1511_1;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 1511/grade_1511.txt \n";

exit $diff;
