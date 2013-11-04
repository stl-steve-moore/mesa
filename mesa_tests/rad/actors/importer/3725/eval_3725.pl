#!/usr/local/bin/perl -w

use Env;

use lib "../../../common/scripts";
require mesa_evaluate;

sub goodbye() {
  exit 1;
}

# Examine MPPS messages:  Import

sub x_3725_1 {
 print LOG "\nCTX: Importer 3725.1 \n";
 print LOG "CTX:  Evaluating MPPS for Import\n";

 
  my @mpps = mesa_get::find_mpps_dir_by_patient_id($logLevel, $titleMPPSMgr, $patientID);
  
  if (scalar(@mpps) == 0) {
    print LOG "ERR: 0 MPPS directory found under MESA Image Manager storage area for $patientID; Are you using the correct patient id 3725?\n";
    return 1;
  }elsif(scalar(@mpps) > 1){
    print LOG "ERR: More than one MPPS directory found under MESA Image Manager storage area for $patientID; that is an error\n";
    return 1;
  }else{
    print LOG "CTX: One MPPS directory found for $patientID: $mpps[0]\n" if($logLevel >= 3);
  }

  my $errorCount = mesa_evaluate::eval_mpps_nCreate_importer(
		$logLevel,
		$titleMPPSMgr,
		"$MESA_STORAGE/tmp/3725-mpps/mpps.crt",
		"$mpps[0]/mpps.dcm");
  
  $errorCount += mesa_evaluate::eval_mpps_nSet_importer(
		$logLevel,
		$titleMPPSMgr,
		"$MESA_STORAGE/tmp/3725-mpps/mpps.set",
		"$mpps[0]/mpps.dcm");

  print LOG "\n";
  return $errorCount;
}


# Examine C-Store objects after coercion
sub x_3725_2 {
 print LOG "\nCTX: Importer 3725.2 \n";
 print LOG "CTX:  Evaluating C-Store objects\n";
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
    print LOG "CTX: There are a total of $len SOP Instances stored to MESA Image Manager.\n" if($logLevel >= 3);
    print LOG "CTX: @x\n" if($logLevel >= 5);
  }

 my $errorCount = mesa_evaluate::eval_cstore_importer(
		$logLevel,
		$titleMPPSMgr,
		"$MESA_STORAGE/tmp/3725-instances/1001.dcm",
		#"3725/mwl_q1/test/msg1_result.dcm",
		$x[0]);

 print LOG "\n";
 return $errorCount;
}

### Main starts here

die "Usage: <log level: 1-4> <AE Title of your MPPS SCU>" if (scalar(@ARGV) < 2);

$logLevel = $ARGV[0];
$titleMPPSMgr = $ARGV[1];
open LOG, ">3725/grade_3725.txt" or die "?!";
$diff = 0;

$masterFile = "$MESA_STORAGE/tmp/3725-mpps/mpps.crt";
(my $status, $patientID) = mesa_get::getDICOMValue($logLevel, $masterFile, "", "0010 0020", 0);

$diff += x_3725_1;
$diff += x_3725_2;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 3725/grade_3725.txt \n";

exit $diff;
