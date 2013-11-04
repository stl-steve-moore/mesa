#!/usr/local/bin/perl -w

# Sends C-Find requests to Report Repository for 804-j tests.

use Env;
use lib "scripts";
require rpt_repos;

$SIG{INT} = \&goodbye;

sub goodbye () {
  print "Exiting...\n";

  exit 1;
}

sub announce_test {
  print "\n" .
"This is MESA Report Repository test 804-j.  It sends C-Find requests for the " .
" attributes 0040 A491 Completion Flag and 0040 A493 Verification Flag \n";
}

sub produce_queries {
  print "Produce queries from text files.\n";

  $srFile = "../../msgs/sr/601/sr_601ct.dcm";

  $x = "$MESA_TARGET/bin/dcm_print_element 0020 000D $srFile";
  $studyUID = `$x`; chomp $studyUID;

  $x = "$MESA_TARGET/bin/dcm_print_element 0020 000E $srFile";
  $seriesUID = `$x`; chomp $seriesUID;

  $x = "$MESA_TARGET/bin/dcm_print_element 0008 0018 $srFile";
  $sopinsUID = `$x`; chomp $sopinsUID;

  open F, ">804-j/q804a.txt" or die "Could not open output file for query\n";

  print F "0008 0052 IMAGE\n";
  print F "0020 000D $studyUID\n";
  print F "0020 000E $seriesUID\n";
  print F "0008 0018 $sopinsUID\n";
  print F "0040 A491 #\n";
  print F "0040 A493 #\n";

  close F;

  rpt_repos::make_dcm_object("804-j/q804a");
}

sub send_q804a {
  $outDir = "804-j/q804a";
  $outDirMESA = "804-j/q804a_mesa";

  rpt_repos::delete_directory($outDir);
  rpt_repos::delete_directory($outDirMESA);
  rpt_repos::create_directory($outDir);
  rpt_repos::create_directory($outDirMESA);

  rpt_repos::send_cfind("804-j/q804a.dcm", $rptAE, $rptHost, $rptPort, $outDir);
  rpt_repos::send_cfind("804-j/q804a.dcm", "MESA_RPT_REPOS", "localhost", "2800", $outDirMESA);
}

#Setup commands
$host = `hostname`; chomp $host;

($rptHost, $rptPort, $rptAE) = rpt_repos::read_config_params("rptrepos_test.cfg");
print "Rpt Repos Host:  $rptHost \n";
print "Rpt Repos Port:  $rptPort \n";
print "Rpt Repos Title: $rptAE \n";

print "Illegal Repository Port: $rptPort\n" if ($rptPort == 0);

announce_test;

produce_queries;

send_q804a;

goodbye;
