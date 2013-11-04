#!/usr/local/bin/perl -w

use Env;

use lib "../../../common/scripts";
require mesa_evaluate;

sub goodbye() {
  exit 1;
}

# Examine C-Store objects
sub x_20712_1 {
   print LOG "CTX: Cardiology Stress Workflow Test 20712.1 \n";
   print LOG "CTX: Evaluating C-Store objects\n";
   ($status, @x) = mesa_get::getSOPInstanceFileNamesByPatientAttribute($logLevel, "imgmgr", "patid" , $patientID);
   if ($status != 0) {
      print LOG "ERR: Could not get SOP Instance list from MESA imgmgr database\n";
      return 1;
   }

   if (scalar(@x) == 0) {
      print LOG "ERR: 0 SOP Instances stored to MESA Image Manager; that is an error\n";
      return 1;
   }else{
      my $len = @x;
      print LOG "CTX: There are total of $len SOP Instances stored to MESA Image Manager.\n" if($logLevel >= 3);
      print LOG "CTX: @x\n" if($logLevel >= 3);
   }
  
   my $refObject = "$MESA_STORAGE/modality/T20712/x1.dcm";
   my $testObject = $x[0];
   
   if (! -e $testObject) {
      print main::LOG "ERR: Reference Object file $testObject does not exist; please post a bugzilla error\n";
      return 1;
   }
   
   if (! -e $refObject) {
      print main::LOG "ERR: Reference Object file $refObject does not exist; please post a bugzilla error\n";
      return 1;
   }

   $errorCount += mesa_evaluate::eval_cardiology_stress_cstore(
		$logLevel,
		$refObject,
		$testObject);
		
   print LOG "\n";
   return $errorCount;
}

### Main starts here

die "Usage: <log level: 1-4>" if (scalar(@ARGV) < 1);

$logLevel = $ARGV[0];
open LOG, ">20712/grade_20712.txt" or die "?!";
$diff = 0;
$patientID = "20712";

$diff += x_20712_1;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 20712/grade_20712.txt \n";

exit $diff;
