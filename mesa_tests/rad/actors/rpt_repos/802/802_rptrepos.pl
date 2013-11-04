#!/usr/local/bin/perl -w

# Sends C-Find requests to Report Repository for 802 tests.

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
"This is MESA Report Repository test 802.  It sends C-Find requests " .
" for the attributes 0020 1206, 0020 1208, 0020 1209. \n";
}

sub produce_queries {
  print "Produce queries from text files.\n";

  rpt_repos::make_dcm_object("802/q802a");
  rpt_repos::make_dcm_object("802/q802b");
}

sub send_q802a {
  if ($MESA_OS eq "WINDOWS_NT") {
    $outDir = "802\\q802a";
    $outDirMESA = "802\\q802a_mesa";
  } else {
    $outDir = "802/q802a";
    $outDirMESA = "802/q802a_mesa";
  }
  rpt_repos::delete_directory($outDir);
  rpt_repos::delete_directory($outDirMESA);
  rpt_repos::create_directory($outDir);
  rpt_repos::create_directory($outDirMESA);

  rpt_repos::send_cfind("802/q802a.dcm", $rptAE, $rptHost, $rptPort, $outDir);
  rpt_repos::send_cfind("802/q802a.dcm", "MESA_RPT_REPOS", "localhost", "2800", $outDirMESA);

}

sub send_q802b {
  if ($MESA_OS eq "WINDOWS_NT") {
    $outDir = "802\\q802b";
    $outDirMESA = "802\\q802b_mesa";
  } else {
    $outDir = "802/q802b";
    $outDirMESA = "802/q802b_mesa";
  }
  rpt_repos::delete_directory($outDir);
  rpt_repos::delete_directory($outDirMESA);
  rpt_repos::create_directory($outDir);
  rpt_repos::create_directory($outDirMESA);

  rpt_repos::send_cfind("802/q802b.dcm", $rptAE, $rptHost, $rptPort, $outDir);
  rpt_repos::send_cfind("802/q802b.dcm", "MESA_RPT_REPOS", "localhost", "2800", $outDirMESA);

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

send_q802a;
send_q802b;

goodbye;
