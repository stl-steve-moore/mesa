#!/usr/local/bin/perl -w

use Env;

use lib "scripts";
require ordfil;

$verbose = grep /^-v/, @ARGV;

open LOG, ">1411/grade_1411.txt" or die "?!";
$diff = 0;

$dirBase = "1411/";
if ($MESA_OS eq "WINDOWS_NT") {
  $dirBase = "1411\\";
  $separator = "\\";
} else {
  $dirBase = "1411/";
  $separator = "/";
}

sub goodbye() {
  exit 1;
}

# Section of GPSPS response tests

#----------------------------------------------------------------
# Evaluate Worklist Provided
# Response to query for GP SPS for procedure X101MGCAD.
#----------------------------------------------------------------
sub eval_worklist_provided {

 print LOG "Order Filler 1411.1 \n";
 print LOG "Evaluating GPSPS response for procedure P101/X101/X101MGCAD \n";

 $result = "1411/gpsps_x101";
 $resultMESA = "1411/gpsps_x101_mesa";
 if ($MESA_OS eq "WINDOWS_NT") {
    $result =~ s(/)(\\)g;
    $resultMESA =~ s(/)(\\)g;
 }
 $procedure = "X101_MGCAD";

 $gpspsPath = ordfil::find_gpsps_with_matching_procedure( $result, $procedure);

 if ($gpspsPath eq "") {
   print LOG "Unable to locate GPSPS query results for sched proc $procedure\n";
   print LOG " You should examine the GPSPS results in $result \n";
   $diff += 1;
   return;
 }

 $gpspsPathMESA = ordfil::find_gpsps_with_matching_procedure(
                      $resultMESA, $procedure);

 if ($gpspsPathMESA eq "") {
   print LOG "MESA GPSPS does not include scheduled procedure $procedure \n";
   print LOG " This is an error in the test configuration/run \n";
   print LOG " You should examine the GPSPS results in $resultMESA \n";
   $diff += 1;
   return;
 }

 $diff += ordfil::evaluate_one_gpsps_resp(
            $verbose, $gpspsPath, $gpspsPathMESA);

 print LOG "\n";
}

#----------------------------------------------------------------
# Evaluate Workstatus Update
# Response to query for GP SPS for procedure X101MGCAD.
#----------------------------------------------------------------
sub eval_workstatus_update_pps_create {
 my $OF = shift(@_);             # AE Title of Order Filler
 my $MESA_OF = shift(@_);        # AE Title of MESA'sOrder Filler

 print LOG "Workstatus update \n";
 print LOG "Evaluating GPPPS NCreate forwarded to Image Mgr.\n";

 # $ppsSOPUID = ordfil::read_ppsSOPUID("1411/gppps_sopuid.txt");
 # chomp($ppsSOPUID);
 $ppsSOPUID = ordfil::getSOPUID("1411/ppscreate.dcm");
 chomp($ppsSOPUID);

 $resultDir = "$MESA_STORAGE/imgmgr/ppwf/$OF/$ppsSOPUID/";
 $resultDirMESA = "$MESA_STORAGE/imgmgr/ppwf/$MESA_OF/$ppsSOPUID/";

 opendir DIR, $resultDir or die "Unable to locate directory: $resultDir\n";
 @allfiles = readdir DIR;
 closedir DIR;

 foreach $file (@allfiles) {
    # we want the file that ends with .crt
    if( $file =~ /\.crt$/) {
      $fname = $file;
      last;
    }
 }
 $path = $resultDir . $fname;

 opendir DIR, $resultDirMESA or die "Unable to locate directory: $resultDirMESA\n";
 @allfiles = readdir DIR;
 closedir DIR;

 foreach $file (@allfiles) {
    # we want the file that ends with .crt
    if( $file =~ /\.crt$/) {
      $fname = $file;
      last;
    }
 }
 $pathMESA = $resultDirMESA . $fname;

 $x = "$MESA_TARGET/bin/evaluate_gppps $path $pathMESA";

 if ($MESA_OS eq "WINDOWS_NT") {
    $x =~ s(/)(\\)g;
 }

 print "$x\n";
 print LOG "$x\n";
 print LOG `$x`;

 print LOG "\n";

 return 1 if ($?);
 return 0;
}

#----------------------------------------------------------------
# Evaluate response to GP SPS status update to "COMPLETE".
#----------------------------------------------------------------
sub gpsps_status_update {

 print LOG "Order Filler 1411.2 \n";
 print LOG "Evaluating Workitem Completed \n";

 $path = "1411/gpsps_x101_2/msg1_result.dcm";
 if( $MESA_OS eq "WINDOWS_NT") {
    $path =~ s(/)(\\)g;
 }

 if( ! open FILE, $path) {
   print LOG "Unable to locate GPSPS query response $path\n";
   $diff += 1;
   return;
 }
 close FILE;

 # GP SPS status attribute
 $group = "0040";
 $element = "4001";

 $val = `$main::MESA_TARGET/bin/dcm_print_element $group $element $path`;
 chomp($val);

 print LOG "GP SPS status: $val\n";

 if( $val ne "COMPLETE") {
   print LOG "GPSPS status is not \"COMPLETE\"\n";
   $diff += 1;
   return;
 }
 print LOG "\n";
}


##### main

# evaluate worklist provided.
# GPSPS query results for X101
eval_worklist_provided ;

# evaluate workitem completed - check GPSPS status updated to "COMPLETE"
gpsps_status_update ;

# evaluate workstatus update.
# ordfil forwards PPS in progress/complete to Img Mgr.
eval_workstatus_update_pps_create("MESA_OF","MESA_OF") ;


print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 1411/grade_1411.txt \n";

exit $diff;
