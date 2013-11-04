#!/usr/local/bin/perl -w

# Sends C-Find requests to Report Repository for 1511 tests.

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
"This is MESA Report Repository test 1511.  It sends C-Find requests \n" .
" for the attribute 0008 0061 Modalities in Study.\n".
" Communication is performed in secure mode (TLS).\n\n";
}

sub produce_queries {
  print "Produce queries from text files.\n";

  rpt_repos::make_dcm_object("801/q801a");
  rpt_repos::make_dcm_object("801/q801b");
  rpt_repos::make_dcm_object("801/q801c");
  rpt_repos::make_dcm_object("801/q801d");
}

sub send_q1511a {
  if ($MESA_OS eq "WINDOWS_NT") {
    $outDir = "1511\\q1511a";
    $outDirMESA = "1511\\q1511a_mesa";
  } else {
    $outDir = "1511/q1511a";
    $outDirMESA = "1511/q1511a_mesa";
  }
  rpt_repos::delete_directory($outDir);
  rpt_repos::delete_directory($outDirMESA);
  rpt_repos::create_directory($outDir);
  rpt_repos::create_directory($outDirMESA);

  rpt_repos::send_cfind_secure("801/q801a.dcm", $rptAE, $rptHost, $rptPort, $outDir,
	"randoms.dat", "mesa_1.key.pem", "mesa_1.cert.pem", "test_list.cert", "NULL-SHA");
  rpt_repos::send_cfind_secure("801/q801a.dcm", "MESA_RPT_REPOS", "localhost", "2800", $outDirMESA,
	"randoms.dat", "mesa_1.key.pem", "mesa_1.cert.pem", "test_list.cert", "NULL-SHA");
}

#Setup commands
$host = `hostname`; chomp $host;

($rptHost, $rptPort, $rptAE) = rpt_repos::read_config_params("rptrepos_secure.cfg");
print "Rpt Repos Host:  $rptHost \n";
print "Rpt Repos Port:  $rptPort \n";
print "Rpt Repos Title: $rptAE \n";

print "Illegal Repository Port: $rptPort\n" if ($rptPort == 0);

announce_test;

produce_queries;

send_q1511a;

goodbye;
