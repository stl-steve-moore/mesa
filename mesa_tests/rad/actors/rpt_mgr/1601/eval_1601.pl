#!/usr/local/bin/perl -w

use Env;

use lib "scripts";
require rpt_mgr;

sub goodbye() {
  exit 1;
}

# Section of GPSPS response tests

#----------------------------------------------------------------
# Evaluate Worklist Provided
# Response to query for GP SPS for procedure X101MGCAD.
#----------------------------------------------------------------
sub eval_worklist_provided {
 my $logLevel = shift(@_);
 $verbose = 1 if( $logLevel > 1);
 my $diff = 0;

 print LOG "Evaluating RWL query response.\n";

 $result = "1601/rwl_q1/test/msg1_result.dcm";
 $resultMESA = "1601/rwl_q1/mesa/msg1_result.dcm";
 if ($MESA_OS eq "WINDOWS_NT") {
    $result =~ s(\/)(\\)g;
    $resultMESA =~ s(\/)(\\)g;
 }

 if( ! -e $result ) {
   print LOG "Unable to locate RWL query results from rpt_mgr under test: $result\n";
   $diff += 1;
   return $diff;
 }

 if( ! -e $resultMESA ) {
   print LOG "Unable to locate RWL query results from MESA rpt_mgr: $resultMESA\n";
   $diff += 1;
   return $diff;
 }

 $diff += rpt_mgr::evaluate_one_gpsps_resp( $verbose, $result, $resultMESA);

 print LOG "\n";
 return $diff;
}

sub read_ppsSOPUID {
  my $fname = shift(@_);

  open FILE, $fname or die "Unable to find PPS SOP UID file: $fname\n";

  $uid = <FILE>;
  return $uid;
}

#----------------------------------------------------------------
# Evaluate Workstatus Update
# GP PPS Ncreate.
#----------------------------------------------------------------
sub eval_workstatus_update_pps_create {
 my $logLevel = shift(@_);
 my $OF = shift(@_);             # AE Title of Report Manager
 my $MESA_OF = shift(@_);        # AE Title of MESA's Report Manager
 my $ppsSOPUIDpath = shift(@_);  # Root of path to PPS SOPUID file

 print LOG "\nWorkstatus update \n";
 print LOG "Evaluating GPPPS NCreate.\n";

 $verbose = 1 if( $logLevel > 1) ;

 $ppsSOPUIDfname = $ppsSOPUIDpath . "test/gppps_sopuid.txt";
 $ppsSOPUID = read_ppsSOPUID($ppsSOPUIDfname);
 chomp($ppsSOPUID);

 print LOG "ppsSOPUID: $ppsSOPUID\n" if( $verbose);

 $resultDir = "$MESA_STORAGE/imgmgr/ppwf/$OF/$ppsSOPUID/";
 $resultDirMESA = "$MESA_STORAGE/imgmgr/ppwf/$MESA_OF/$ppsSOPUID/";

 opendir DIR, $resultDir or die "Unable to locate directory: $resultDir\n";
 @allfiles = readdir DIR;
 closedir DIR;

 # find files that end with .crt
 @crtfiles = grep /\.crt$/, @allfiles;
 $nfiles = @crtfiles;
 if( $nfiles == 0) {
   print LOG "Failed to find GPPPS Ncreate in $resultDir\n";
   return 1;
 }
 if( $nfiles > 1) {
   print LOG "Error: found multiple GPPPS Ncreates in $resultDir\n";
   return 1;
 }

 $path = $resultDir . $crtfiles[0];

 #print "path: $path\n";

 opendir DIR, $resultDirMESA or die "Unable to locate directory: $resultDirMESA\n";
 @allfiles = readdir DIR;
 closedir DIR;

 # find files that end with .crt
 @crtfiles = grep /\.crt$/, @allfiles;
 $nfiles = @crtfiles;
 if( $nfiles == 0) {
   print LOG "Failed to find GPPPS Ncreate in $resultDirMESA\n";
   return 1;
 }
 if( $nfiles > 1) {
   print LOG "Error: found multiple GPPPS Ncreates in $resultDirMESA\n";
   return 1;
 }

 $pathMESA = $resultDirMESA . $crtfiles[0];

 #print "pathMESA: $pathMESA\n";

 $x = "$MESA_TARGET/bin/evaluate_gppps";
 $x .= " -v" if( $verbose);
 $x .= " $path $pathMESA";

 if ($MESA_OS eq "WINDOWS_NT") {
    $x =~ s(\/)(\\)g;
 }

 print LOG "\n$x\n\n";
 print LOG `$x`;

 print LOG "\n";

 return 1 if ($?);
 return 0;
}

#----------------------------------------------------------------
# Evaluate Workstatus Update
# This evaluates the final GPPPS object, the object that results
# from the initial create and all nsets in order.
#----------------------------------------------------------------
sub eval_workstatus_update_pps_composite {
 my $logLevel = shift(@_);
 my $OF = shift(@_);             # AE Title of Report Manager
 my $MESA_OF = shift(@_);        # AE Title of MESA's Report Manager
 my $ppsSOPUIDpath = shift(@_);  # Root of path to PPS SOPUID file

 print LOG "\nWorkstatus update \n";
 print LOG "Evaluating composite GPPPS.\n";

 $verbose = 1 if( $logLevel > 1) ;

 $ppsSOPUIDfname = $ppsSOPUIDpath . "test/gppps_sopuid.txt";
 $ppsSOPUID = read_ppsSOPUID($ppsSOPUIDfname);
 chomp($ppsSOPUID);

 #print "ppsSOPUID: $ppsSOPUID\n";

 $resultDir = "$MESA_STORAGE/imgmgr/ppwf/$OF/$ppsSOPUID/";
 $resultDirMESA = "$MESA_STORAGE/imgmgr/ppwf/$MESA_OF/$ppsSOPUID/";

 $pps_tmplt = "$MESA_TARGET/testsuite/y3_actor/msgs/rwf/common/gppps_tmplt.dcm";

 mesa::create_directory( $logLevel, $ppsSOPUIDpath . "/test");
 mesa::create_directory( $logLevel, $ppsSOPUIDpath . "/mesa");
 $test_gppps = "$ppsSOPUIDpath/test/composite_gppps.dcm";
 $mesa_gppps = "$ppsSOPUIDpath/mesa/composite_gppps.dcm";

 $ndiff = rpt_mgr::make_composite_gppps($verbose, 
                           $resultDir, $pps_tmplt, $test_gppps);
 if( $ndiff != 0) { return 1; }
 $ndiff = rpt_mgr::make_composite_gppps($verbose, 
                           $resultDirMESA, $pps_tmplt, $mesa_gppps);
 if( $ndiff != 0) { return 1; }

 $x = "$MESA_TARGET/bin/evaluate_gppps";
 $x .= " -v" if( $verbose);
 $x .= " $test_gppps $mesa_gppps";

 if ($MESA_OS eq "WINDOWS_NT") {
    $x =~ s(\/)(\\)g;
 }

  #print "$x\n";
 print LOG "\n$x\n\n";
 print LOG `$x`;

 print LOG "\n";

 return 1 if ($?);
 return 0;
}

#----------------------------------------------------------------
# Evaluate response to GP SPS status update to "COMPLETE".
#----------------------------------------------------------------
sub gpsps_status_update {

 print LOG "Order Filler 1601.2 \n";
 print LOG "Evaluating Workitem Completed \n";

 $path = "1601/gpsps_x101_2/msg1_result.dcm";
 if( $MESA_OS eq "WINDOWS_NT") {
    $path =~ s(\/)(\\)g;
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

die "Usage <log level: 1-4>" if (scalar(@ARGV) < 1);

$logLevel     = $ARGV[0];
open LOG, ">1601/grade_1601.txt" or die "?!";
$diff = 0;

# $verbose = grep /^-v/, @ARGV;
$verbose = 0;
$verbose = 1 if ($logLevel > 2);

%varnames = mesa::get_config_params("rptmgr_test.cfg");
if (rpt_mgr::test_var_names(%varnames) != 0) {
  print "Some problem with the variables in rptmgr_test.cfg\n";
  exit 1;
}

$rptmgr_AE  = $varnames{"TEST_MANAGER_AE"};
$mesa_rptmgrRWL_AE  = $varnames{"MESA_RPT_MGR_RWL_AE"};
 #print "test: $rptmgr_AE\n";
 #print "mesa: $mesa_rptmgrRWL_AE\n";

# evaluate worklist provided.
print "\nEvaluate worklist provided.\n";
print LOG "\nEvaluate worklist provided.\n";
$ndiff = eval_worklist_provided($logLevel) ;
$diff += $ndiff;
print "Differences: $ndiff\n";
print LOG "Differences: $ndiff\n";


# evaluate workitem completed - check GPSPS status updated to "COMPLETE"
# we can't do this because can't rely on RptMgr to return completed 
# worklist items.
# gpsps_status_update ;

# evaluate workstatus update.
# rptmgr forwards PPS in progress/complete to Img Mgr.
print "\nEvaluate Workstatus Update (PPS Ncreate: Interpretation)\n";
print LOG "\nEvaluate Workstatus Update (PPS Ncreate: Interpretation)\n";
$ppsSOPUIDpath = "1601/pps/interpretation/";
$ndiff = eval_workstatus_update_pps_create($logLevel,
          $rptmgr_AE,
          $mesa_rptmgrRWL_AE,
          $ppsSOPUIDpath) ;
$diff += $ndiff;
print "Differences: $ndiff\n";
print LOG "Differences: $ndiff\n";

print "\nEvaluate Workstatus Update (Completed PPS: Interpretation)\n";
print LOG "\nEvaluate Workstatus Update (Completed PPS: Interpretation)\n";
$ndiff = eval_workstatus_update_pps_composite($logLevel,
          $rptmgr_AE,
          $mesa_rptmgrRWL_AE,
          $ppsSOPUIDpath) ;
$diff += $ndiff;
print "Differences: $ndiff\n";
print LOG "Differences: $ndiff\n";

print "\nEvaluate Workstatus Update (PPS Ncreate: Transcription)\n";
print LOG "\nEvaluate Workstatus Update (PPS Ncreate: Transcription)\n";
$ppsSOPUIDpath = "1601/pps/transcription/";
$ndiff = eval_workstatus_update_pps_create($logLevel,
          $rptmgr_AE,
          $mesa_rptmgrRWL_AE,
          $ppsSOPUIDpath) ;
$diff += $ndiff;
print "Differences: $ndiff\n";
print LOG "Differences: $ndiff\n";

print "\nEvaluate Workstatus Update (Completed PPS: Transcription)\n";
print LOG "\nEvaluate Workstatus Update (Completed PPS: Transcription)\n";
$ndiff = eval_workstatus_update_pps_composite($logLevel,
          $rptmgr_AE,
          $mesa_rptmgrRWL_AE,
          $ppsSOPUIDpath) ;
$diff += $ndiff;
print "Differences: $ndiff\n";
print LOG "Differences: $ndiff\n";

print "\nEvaluate Workstatus Update (PPS Ncreate: Verification)\n";
print LOG "\nEvaluate Workstatus Update (PPS Ncreate: Verification)\n";
$ppsSOPUIDpath = "1601/pps/verification/";
$ndiff = eval_workstatus_update_pps_create($logLevel,
          $rptmgr_AE,
          $mesa_rptmgrRWL_AE,
          $ppsSOPUIDpath) ;
$diff += $ndiff;
print "Differences: $ndiff\n";
print LOG "Differences: $ndiff\n";

print "\nEvaluate Workstatus Update (Completed PPS: Verification)\n";
print LOG "\nEvaluate Workstatus Update (Completed PPS: Verification)\n";
$ndiff = eval_workstatus_update_pps_composite($logLevel,
          $rptmgr_AE,
          $mesa_rptmgrRWL_AE,
          $ppsSOPUIDpath) ;
$diff += $ndiff;
print "Differences: $ndiff\n";
print LOG "Differences: $ndiff\n";

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 1601/grade_1601.txt \n";

exit $diff;
