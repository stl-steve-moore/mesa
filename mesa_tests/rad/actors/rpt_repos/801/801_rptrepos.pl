#!/usr/local/bin/perl -w

# Sends C-Find requests to Report Repository for 801 tests.

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
"This is MESA Report Repository test 801.  It sends C-Find requests " .
" for the attribute 0008 0061 Modalities in Study.\n";
}

sub produce_queries {
  print "Produce queries from text files.\n";

  rpt_repos::make_dcm_object("801/q801a");
  rpt_repos::make_dcm_object("801/q801b");
  rpt_repos::make_dcm_object("801/q801c");
  rpt_repos::make_dcm_object("801/q801d");
}

sub send_q801a {
  if ($MESA_OS eq "WINDOWS_NT") {
    $outDir = "801\\q801a";
    $outDirMESA = "801\\q801a_mesa";
  } else {
    $outDir = "801/q801a";
    $outDirMESA = "801/q801a_mesa";
  }
  rpt_repos::delete_directory($outDir);
  rpt_repos::delete_directory($outDirMESA);
  rpt_repos::create_directory($outDir);
  rpt_repos::create_directory($outDirMESA);

  rpt_repos::send_cfind("801/q801a.dcm", $rptAE, $rptHost, $rptPort, $outDir);
  rpt_repos::send_cfind("801/q801a.dcm", "MESA_RPT_REPOS", "localhost", "2800", $outDirMESA);

}

sub send_q801b {
  if ($MESA_OS eq "WINDOWS_NT") {
    $outDir = "801\\q801b";
    $outDirMESA = "801\\q801b_mesa";
  } else {
    $outDir = "801/q801b";
    $outDirMESA = "801/q801b_mesa";
  }
  rpt_repos::delete_directory($outDir);
  rpt_repos::delete_directory($outDirMESA);
  rpt_repos::create_directory($outDir);
  rpt_repos::create_directory($outDirMESA);

  rpt_repos::send_cfind("801/q801b.dcm", $rptAE, $rptHost, $rptPort, $outDir);
  rpt_repos::send_cfind("801/q801b.dcm", "MESA_RPT_REPOS", "localhost", "2800", $outDirMESA);

}

sub send_q801c {
  if ($MESA_OS eq "WINDOWS_NT") {
    $outDir = "801\\q801c";
    $outDirMESA = "801\\q801c_mesa";
  } else {
    $outDir = "801/q801c";
    $outDirMESA = "801/q801c_mesa";
  }
  rpt_repos::delete_directory($outDir);
  rpt_repos::delete_directory($outDirMESA);
  rpt_repos::create_directory($outDir);
  rpt_repos::create_directory($outDirMESA);

  rpt_repos::send_cfind("801/q801c.dcm", $rptAE, $rptHost, $rptPort, $outDir);
  rpt_repos::send_cfind("801/q801c.dcm", "MESA_RPT_REPOS", "localhost", "2800", $outDirMESA);

}

sub send_q801d {
  if ($MESA_OS eq "WINDOWS_NT") {
    $outDir = "801\\q801d";
    $outDirMESA = "801\\q801d_mesa";
  } else {
    $outDir = "801/q801d";
    $outDirMESA = "801/q801d_mesa";
  }
  rpt_repos::delete_directory($outDir);
  rpt_repos::delete_directory($outDirMESA);
  rpt_repos::create_directory($outDir);
  rpt_repos::create_directory($outDirMESA);

  rpt_repos::send_cfind("801/q801d.dcm", $rptAE, $rptHost, $rptPort, $outDir);
  rpt_repos::send_cfind("801/q801d.dcm", "MESA_RPT_REPOS", "localhost", "2800", $outDirMESA);

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

send_q801a;
send_q801b;
send_q801c;
send_q801d;

goodbye;
