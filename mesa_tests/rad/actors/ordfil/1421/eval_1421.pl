#!/usr/local/bin/perl -w

use Env;
use lib "scripts";
require ordfil;

sub exit_on_success {
  print "Test completed successfully.  See $gradefile for details.\n";
  exit(0);
}

sub exit_on_error {
  print "Test Failed.  See $gradefile for details.\n";
  exit(1);
}

$gradefile = "1421/grade_1421.txt";
open LOG, ">$gradefile" or die "?!";

#---------------------------------
# look at the first GPWL query and test for SPS status "SCHEDULED"
#---------------------------------

print LOG "Image Manager 1421.1\n";
print LOG "Evaluating GPWL query for procedure P102/X102/X102_3DRECON\n";

$result = "1421/gpsps_x102";
if( $MESA_OS eq "WINDOWS_NT") {
    $result =~ s(/)(\\)g;
}
$procedure = "X102_3DRECON";

$gpspsPath = ordfil::find_gpsps_with_matching_procedure( $result, $procedure);

if( $gpspsPath eq "") {
  print LOG "Unable to locate GPSPS query results for sched proc $procedure\n";
  print LOG "You should examine the GPSPS results in $result\n";
  exit_on_error();
}

$status = `$MESA_TARGET/bin/dcm_print_element "0040" "4001" $gpspsPath`;
chomp($status);

print LOG "GP SPS status: $status\n";

if( $status ne "SCHEDULED" ) {
  print LOG "Failed to find a scheduled post-processing workitem for\n" .
    "patient: DELAWARE\n" .
    "procedure: $procedure\n" .
    "with status of SCHEDULED\n";
  exit_on_error();
}

print LOG "Success. Found GPWL with status SCHEDULED.\n";


#---------------------------------
# look at response to first claim of the GP SPS.
#---------------------------------

print LOG "\nImage Manager 1421.2\n";
print LOG "Evaluating GP workitem claim response.\n";

$filename1 = "1421/results/claim1response.txt";
if( $MESA_OS eq "WINDOWS_NT") {
    $filename1 =~ s(/)(\\)g;
}
open INPUT1, $filename1 or die "couldn't open $filename1";

$status = "none";
while ( $line = <INPUT1>) {
  if( $line =~ "Status Information") {
    $status = <INPUT1>;
  }
}
close INPUT1;

if( ! ($status =~ "Successful operation")) {
  print LOG "PPM's response to workitem claim request indicates failure.\n";
  print LOG "response: $status\n";
  exit_on_error();
}

print LOG "Success. Workitem claim response was \"success\"\n";

#---------------------------------
# look at the second GPWL query and test for SPS status "IN PROGRESS"
#---------------------------------

print LOG "\nImage Manager 1421.3\n";
print LOG "Evaluating second GPWL query for procedure P102/X102/X102_3DRECON\n";

$result = "1421/gpsps_x102_2";
if( $MESA_OS eq "WINDOWS_NT") {
    $result =~ s(/)(\\)g;
}
$procedure = "X102_3DRECON";

$gpspsPath = ordfil::find_gpsps_with_matching_procedure( $result, $procedure);

if( $gpspsPath eq "") {
  print LOG "Unable to locate GPSPS query results for sched proc $procedure\n";
  print LOG "You should examine the GPSPS results in $result\n";
  exit_on_error();
}

$status = `$MESA_TARGET/bin/dcm_print_element "0040" "4001" $gpspsPath`;
chomp($status);

print LOG "GP SPS status: $status\n";

if( $status ne "IN PROGRESS" ) {
  print LOG "Failed to update scheduled post-processing workitem to\n" .
    "status of \"IN PROGRESS\"\n";
  exit_on_error();
}

print LOG "Success. Found GPWL with status \"IN PROGRESS\"\n";


#---------------------------------
# look at response to second claim of the GP SPS.
#---------------------------------

print LOG "\nImage Manager 1421.4\n";
print LOG "Evaluating second GP workitem claim response.\n";

$filename2 = "1421/results/claim2response.txt";
if( $MESA_OS eq "WINDOWS_NT") {
    $filename1 =~ s(/)(\\)g;
}
open INPUT2, $filename2 or die "couldn't open $filename2";

$status = "none";
while ( $line = <INPUT2>) {
  if( $line =~ "Status Information") {
    $status = <INPUT2>;
  }
}
close INPUT2;

if( !($status =~ "Refused: GP-SPS already in progress")) {
  print LOG "PPM's response to second workitem claim request failed to reject.\n";
  print LOG "response: $status\n";
  exit_on_error();
}

print LOG "Success. Second claim of GP Workitem was rejected\n";

print LOG "\nImage Manager Test 1421 was successfully completed.\n";

exit_on_success();

