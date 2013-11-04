#!/usr/local/bin/perl -w

use Env;
use lib "scripts";
require rptrepos;

sub query_1002_a {
  my $patientID = shift(@_);

  rptrepos::delete_directory("1002/results/a");
  rptrepos::create_directory("1002/results/a");
  rptrepos::make_object("1002/q1002a");

  rptrepos::send_cfind_patient_id("1002/q1002a.dcm", $reposCFindAE,
	$reposCFindHost, $reposCFindPort,
	$patientID, "1002/results/a");
}

#================
# Main starts here

if (scalar(@ARGV) < 1) {
  print "This script requires one argument: <Patient ID> \n";
  exit 1;
}

($reposCFindAE, $reposCFindHost, $reposCFindPort) =
	rptrepos::read_config_params();

query_1002_a($ARGV[0]);

exit 0;
