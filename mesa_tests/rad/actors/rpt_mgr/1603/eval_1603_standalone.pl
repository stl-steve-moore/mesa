#!/usr/local/bin/perl -w

use Env;

use lib "scripts";
require rpt_mgr;

sub goodbye() {
  exit 1;
}


#----------------------------------------------------------------
# Evaluate Worklist Provided
#----------------------------------------------------------------

sub x_1603_1 {
 print LOG "CTX: Report Manager (standalone) 1603.1 \n";
 print LOG "CTX: Evaluating GPWL response after original scheduling\n";
 my $x = 0;

 print LOG "Evaluating RWL query response.\n";

 $result = "1603/rwl_q1/test/msg1_result.dcm";
 $resultMESA = "1603/rwl_q1/mesa/msg1_result.dcm";

 if( ! -e $result ) {
   print LOG "Unable to locate RWL query results from rpt_mgr under test: $result\n";
   return 1;
 }

 if( ! -e $resultMESA ) {
   print LOG "Unable to locate RWL query results from MESA rpt_mgr: $resultMESA\n";
   print LOG "This indicates a bug; please log a bug report.\n";
   return 1;
 }

 $x = rpt_mgr::evaluate_one_gpsps_resp( $logLevel, $result, $resultMESA);

 print LOG "\n";
 return $x;
}

sub x_1603_2 {
 print LOG "CTX: Report Manager (standalone) 1603.2 \n";
 print LOG "CTX: Evaluating GPWL response after workitem claimed\n";
 my $x = 0;

 print LOG "Evaluating RWL query response.\n";

 $result = "1603/rwl_q2/test/msg1_result.dcm";
 $resultMESA = "1603/rwl_q2/mesa/msg1_result.dcm";

 if( ! -e $result ) {
   print LOG "Unable to locate RWL query results from rpt_mgr under test: $result\n";
   return 1;
 }

 if( ! -e $resultMESA ) {
   print LOG "Unable to locate RWL query results from MESA rpt_mgr: $resultMESA\n";
   print LOG "This indicates a bug; please log a bug report.\n";
   return 1;
 }

 $x = rpt_mgr::evaluate_one_gpsps_resp( $logLevel, $result, $resultMESA);

 print LOG "\n";
 return $x;
}

sub x_1603_3 {
 print LOG "CTX: Report Manager (standalone) 1603.3 \n";
 print LOG "CTX: Evaluating GPWL response after workitem claimed\n";
 my $x = 0;

 print LOG "Evaluating RWL query response.\n";

 $result = "1603/rwl_q3/test/msg1_result.dcm";
 $resultMESA = "1603/rwl_q3/mesa/msg1_result.dcm";

 if( ! -e $result ) {
   print LOG "Unable to locate RWL query results from rpt_mgr under test: $result\n";
   return 1;
 }

 if( ! -e $resultMESA ) {
   print LOG "Unable to locate RWL query results from MESA rpt_mgr: $resultMESA\n";
   print LOG "This indicates a bug; please log a bug report.\n";
   return 1;
 }

 $x = rpt_mgr::evaluate_one_gpsps_resp( $logLevel, $result, $resultMESA);

 print LOG "\n";
 return $x;
}


##### Main starts here

die "Usage <log level: 1-4> <AE Title of your GPPPS SCU> " if (scalar(@ARGV) < 2);

$logLevel     = $ARGV[0];
#$titleGPPPSSCU = $ARGV[1];

open LOG, ">1603/grade_1603.txt" or die "Could not open output file 1603/grade_1603.txt";
my $mesaVersion = mesa::getMESAVersion();
print LOG "CTX: $mesaVersion \n";
$diff = 0;

# evaluate worklist provided.
$diff += x_1603_1;	# Evaluate worklist provided (original worklist)
$diff += x_1603_2;	# Evaluate worklist provided (after claim)
$diff += x_1603_3;	# Evaluate worklist provided (after defer)

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 1603/grade_1603.txt \n";

exit $diff;
