#!/usr/local/bin/perl -w

use Env;
use lib "scripts";
require rptrepos;

sub query_1001_a {
  my $patientID = shift(@_);

  rptrepos::delete_directory("1001/results/a");
  rptrepos::create_directory("1001/results/a");
  rptrepos::make_object("1001/q1001a");

  rptrepos::send_cfind_patient_id("1001/q1001a.dcm", $reposCFindAE,
	$reposCFindHost, $reposCFindPort,
	$patientID, "1001/results/a");
}

sub query_1001_b {
  my $patientID = shift(@_);

  rptrepos::delete_directory("1001/results/b");
  rptrepos::create_directory("1001/results/b");
  rptrepos::make_object("1001/q1001b");

  rptrepos::send_cfind_patient_id("1001/q1001b.dcm", $reposCFindAE,
	$reposCFindHost, $reposCFindPort,
	$patientID, "1001/results/b");
}

sub query_1001_c {
  rptrepos::delete_directory("1001/results/c");
  rptrepos::create_directory("1001/results/c");
  rptrepos::make_object("1001/q1001c");

  rptrepos::send_cfind("1001/q1001b.dcm", $reposCFindAE,
	$reposCFindHost, $reposCFindPort,
	"1001/results/b");
}

#================
# Main starts here

if (scalar(@ARGV) < 1) {
  print "This script requires one argument: <Patient ID> \n";
  exit 1;
}

($reposCFindAE, $reposCFindHost, $reposCFindPort) =
	rptrepos::read_config_params();

query_1001_a($ARGV[0]);
query_1001_b($ARGV[0]);
query_1001_c;

exit 0;
