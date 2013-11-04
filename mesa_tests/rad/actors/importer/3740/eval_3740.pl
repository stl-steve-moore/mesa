#!/usr/local/bin/perl -w

use Env;

use lib "../../../common/scripts";
require mesa_evaluate;

sub goodbye() {
  exit 1;
}

# Examine MPPS messages: Import

sub x_3740_1 {
  print LOG "CTX: Importer 3740.1 \n";
  print LOG "CTX:  Evaluating MPPS for Import\n";

  my @mpps = mesa_get::find_mpps_dir_by_patient_id($logLevel, $titleMPPSMgr, $patientID);
  
  if (scalar(@mpps) == 0) {
    print LOG "ERR: 0 MPPS directory found under MESA Image Manager storage area for $patientID; Are you using the correct patient id 3740?\n";
    return 1;
  }elsif(scalar(@mpps) > 1){
    print LOG "ERR: More than one MPPS directory found under MESA Image Manager storage area for $patientID; that is an error\n";
    return 1;
  }else{
    print LOG "CTX: One MPPS dirctory found for $patientID: $mpps[0]\n" if($logLevel >= 3);
  }

  my $refMPPS = "$MESA_STORAGE/tmp/3740-mpps/mpps.set";
  my $testMPPS = "$mpps[0]/mpps.dcm";
  my @constant = (
     "EQUAL", "",          0 , "0040 0252", "$testMPPS",  "DISCONTINUED", "PPS Status",
     "EQUAL", "0040 0281", 0,  "0008 0100", "$testMPPS",  "110523", "Code Value",
     "EQUAL", "0040 0281", 0,  "0008 0102", "$testMPPS",  "DCM", "Code Scheme Designator",
     "EQUAL", "0040 0281", 0,  "0008 0104", "$testMPPS",  "Object Set Incomplete", "Code Meaning",
  );
  my @existence = (
  	"0040 0281" , 0, "", "SEQEXIST", "Discontinuation Sequence",
  );
  
  my $errorCount = mesa_evaluate::processExistenceList($logLevel, $refMPPS, $testMPPS, @existence);
  $errorCount += mesa_evaluate::processConstantList($logLevel, @constant);
  
  #$errorCount += mesa_evaluate::eval_mpps_nSet_importer_status(
	#	$logLevel,
		#$titleMPPSMgr,
		#"$MESA_STORAGE/3740-mpps/mpps.set",
		#"$mpps[0]/mpps.dcm");

  print LOG "\n";
  return $errorCount;
}


# Examine C-Store objects after coercion
sub x_3740_2 {
   print LOG "CTX: Importer 3740.2 \n";
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
      print LOG "CTX: There are total of $len SOP Instances stored to MESA Image Manager.\n" if($logLevel >= 3);
      print LOG "CTX: @x\n" if($logLevel >= 5);
   }
  
   my $refObject = "$MESA_STORAGE/tmp/3740-instances/1001.dcm";
   my $testObject = $x[0];
   
   if (! -e $refObject) {
      print main::LOG "ERR: Reference Object file $refObject does not exist; please post a bugzilla error\n";
      return 1;
   }
   #if (! -e $testObject) {
   #   print main::LOG "ERR: Test Object file $testObject does not exist\n";
   #   print main::LOG "ERR: Look in the directory $MESA_STORAGE/imgmgr/instances\n";
   #   return 1;
   #}

   my @attributes = (
	"", 0, "0010 0010", "EQUAL",  "Patient Name",
	"", 0, "0010 0020", "EQUAL", "Patient ID",
   );
   my $errorCount = mesa_evaluate::processValueList($logLevel, $refObject, $testObject, @attributes);

   print LOG "\n";
   return $errorCount;
}

### Main starts here

die "Usage: <log level: 1-4> <AE Title of your MPPS SCU>" if (scalar(@ARGV) < 2);

$logLevel = $ARGV[0];
$titleMPPSMgr = $ARGV[1];
open LOG, ">3740/grade_3740.txt" or die "?!";
$diff = 0;

$masterFile = "$MESA_STORAGE/tmp/3740-mpps/mpps.crt";
(my $status, $patientID) = mesa_get::getDICOMValue($logLevel, $masterFile, "", "0010 0020", 0);

$diff += x_3740_1;
$diff += x_3740_2;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 3740/grade_3740.txt \n";

exit $diff;
