#!/usr/local/bin/perl -w

use Env;
use lib "scripts";
require rptrepos;

sub query_1011_a {
  my $patientID = shift(@_);

  rptrepos::delete_directory("1011/results/a");
  rptrepos::create_directory("1011/results/a");
  rptrepos::make_object("1011/q1011a");

  rptrepos::send_cfind_patient_id("1011/q1011a.dcm", $reposCFindAE,
	$reposCFindHost, $reposCFindPort,
	$patientID, "1011/results/a");
}

sub cmove_1011_b {

  @cfindResponses = rptrepos::find_responses("1011/results/a");
  $x = scalar(@cfindResponses);

  if ($x == 0) {
    print "Found no responses to 1011.a query \n";
    print "That is a failure \n";
    exit 1;
  }

  foreach $response(@cfindResponses) {
    $x ="$MESA_TARGET/bin/dcm_print_element 0020 000D 1011/results/a/$response";
    $uid = `$x`; chomp $uid;

    rptrepos::send_cmove_study_uid("1011/q1011b", $reposCFindAE,
	$reposCFindHost, $reposCFindPort,
	$uid, "WORKSTATION1");
  }
}

#================
# Main starts here

if (scalar(@ARGV) < 1) {
  print "This script requires one argument: <Patient ID> \n";
  exit 1;
}

open LOG, ">1011/log_1011.txt" or die "Could not open log file\n";

($reposCFindAE, $reposCFindHost, $reposCFindPort) =
	rptrepos::read_config_params();

query_1011_a($ARGV[0]);
cmove_1011_b($ARGV[0]);

close LOG;

exit 0;
