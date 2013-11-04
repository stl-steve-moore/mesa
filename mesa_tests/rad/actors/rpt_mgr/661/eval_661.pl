#!/usr/local/bin/perl -w

use Env;
use lib "scripts";
require rpt_mgr;

sub x_661_1 {
  print LOG "Rpt Manager 661.1\n";
  $diff += rpt_mgr::evaluate_hl7(
		$verbose,
		"../../msgs/sr/661", "sr_661.hl7",
		"$MESA_STORAGE/ordplc", "1001.hl7",
		"ini_files/oru_r01_format.ini", "ini_files/oru_r01_compare.ini");
  print LOG "\n";
}

sub x_661_1_errata {
  print LOG
" This report lists at least one failure. If the only failure \n" .
" concerns the SOP Instance UID of the new report, you may \n" .
" ignore that message. That will occur in OBX Field 5; the master \n" .
" value is: 1.113654.1.2001.30.2.1 \n" .
" This is a result of the software design. We have to evaluate \n" .
" OBX 5 for other OBX segments. \n" .
" If there are different errors, these may not be ignored. \n\n";
}

### Main starts here

open LOG, ">661/grade_661.txt" or die "?!";
$diff = 0;
$verbose = grep /^-v/, @ARGV;

x_661_1;

if ($diff != 0) {
  x_661_1_errata;
}

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";
print "Logs stored in 661/grade_661.txt \n";

exit $diff;
