#!/usr/local/bin/perl -w

# General GET package for MESA scripts.

use Env;

package mesa_evaluate;

require Exporter;
@ISA = qw(Exporter);

# We do not wish to export any subroutines.
@EXPORT = qw(
);

sub eval_mpps_nCreate_importer {
  my ($logLevel, $titleMPPSMgr, $referenceMPPS, $testMPPS) = @_;

  print main::LOG "CTX: mesa_dicom_eval::eval_mpps_nCreate_importer $titleMPPSMgr, $referenceMPPS, $testMPPS\n" if ($logLevel >= 3);

  if (! -e $referenceMPPS) {
    print main::LOG "ERR: Reference MPPS file $referenceMPPS does not exist; please post a bugzilla error\n";
    return 1;
  }
  if (! -e $testMPPS) {
    print main::LOG "ERR: Test MPPS file $testMPPS does not exist\n";
    print main::LOG "ERR: Is the AE title for MPPS SCU <$testMPPS>\n";
    print main::LOG "ERR: Look in the directory $MESA_STORAGE/imgmgr/mpps\n";
    return 1;
  }

  my @attributesMPPS = (
       # "", 0, "0008 0060", "EQUAL", "Modality",
       #call patient module
        #"", 0, "0010 0010", "NAME",  "Patient Name",
        #"", 0, "0010 0020", "EQUAL", "Patient ID",
        #"", 0, "0010 0030", "EQUAL", "Birth Date",
        #"", 0, "0010 0040", "EQUAL", "Sex",
        # do not call general study module in mpps messageS 
	"0040 0270", 1, "0020 000D", "EQUAL", "Study Inst UID",
	"0040 0270", 1, "0008 0050", "EQUAL", "Accession Number",
        "0040 0270", 1, "0040 1001", "NONZEROLENGTH_EQUAL", "Req Proc ID",
        "0040 0270", 1, "0040 0009", "NONZEROLENGTH_EQUAL", "SPS ID",
        "0040 0270", 1, "0040 0007", "NONZEROLENGTH_EQUAL", "SPS Description",
	
	#"0040 0008", 1, "0008 0100", "NONZEROLENGTH_EQUAL", "Sched Protocol Code Seq - Code Value",
	#"0040 0008", 1, "0008 0102", "NONZEROLENGTH_EQUAL", "Sched Protocol Code Seq - Code Scheme Designator",
	#"0040 0008", 1, "0008 0103", "NONZEROLENGTH_EQUAL", "Sched Protocol Code Seq - Code Meaning",

	#"0040 0260", 1, "0008 0100", "NONZEROLENGTH_EQUAL", "Performed Protocol Code Seq - Code Value",
	#"0040 0260", 1, "0008 0102", "NONZEROLENGTH_EQUAL", "Performed Protocol Code Seq - Code Scheme Designator",
	#"0040 0260", 1, "0008 0104", "NONZEROLENGTH_EQUAL", "Performed Protocol Code Seq - Code Meaning",
	
	"0008 1032", 1, "0008 0100", "NONZEROLENGTH_EQUAL", "Procedure Code Seq - Code Value",
	"0008 1032", 1, "0008 0102", "NONZEROLENGTH_EQUAL", "Procedure Code Seq - Code Scheme Designator",
	"0008 1032", 1, "0008 0104", "NONZEROLENGTH_EQUAL", "Procedure Code Seq - Code Meaning",
	
        "", 0, "0040 0253", "EXIST", "PPS ID",
        "", 0, "0040 0254", "EXIST", "PPS Description",
	#As SM said, no coding for the following two tag in MPPS so do not check them 20006.07.10
	#"", 0, "0008 1150", "NONZEROLENGTH_EQUAL", "Referenced SOP Class UID",
	#"", 0, "0008 1155", "EXIST", "Referenced SOP Inst UID",
  );

  my @sequences = (
  	"0040 0270", 0, "", "SEQEXIST", "Sched  Step Attributes Sequence",
  	"0040 0260", 0, "", "SEQEXIST", "Performed Protocol Code Sequence",
  );
  
  my @subseqAtts = (
  	"0008 1110", 0, "0008 1150", "EQUAL", "Reference SOP Class UID",
	"0008 1110", 0, "0008 1155", "EQUAL", "Reference SOP Inst UID",
	"0040 0008", 1, "0008 0100", "NONZEROLENGTH_EQUAL", "Sched Protocol Code Seq - Code Value",
	"0040 0008", 1, "0008 0102", "NONZEROLENGTH_EQUAL", "Sched Protocol Code Seq - Code Scheme Designator",
	"0040 0008", 1, "0008 0104", "NONZEROLENGTH_EQUAL", "Sched Protocol Code Seq - Code Meaning",
  );
  
  my $errorCount = 0;
  
  $errorCount += validatePatientModule($logLevel, $referenceMPPS, $testMPPS);
  #$errorCount += validateStudyModule($logLevel, $referenceMPPS, $testMPPS);  
  $errorCount += processValueList($logLevel, $referenceMPPS, $testMPPS, @attributesMPPS);
  $errorCount += processExistenceList($logLevel, $referenceMPPS, $testMPPS, @sequences);
  
  my $ref_0040_0270 = dcmDumpElement($logLevel, "0040 0270", $referenceMPPS, "$main::MESA_STORAGE/tmp/ref_0040_0270.dcm"); 
  my $test_0040_0270 = dcmDumpElement($logLevel, "0040 0270", $testMPPS, "$main::MESA_STORAGE/tmp/test_0040_0270.dcm");
   
  $errorCount += processValueList($logLevel, "$ref_0040_0270", "$test_0040_0270", @subseqAtts);
  #$errorCount += processExistenceList($logLevel, "$ref_0040_0270", "$test_0040_0270", @subseqAtts);
  
  # start eval 0040 0260 seq
  ($status, my %ref_0040_0260_hash) = getMultipleItemsFromSequence($logLevel, $referenceMPPS, "0040 0260", "0008 0100","0008 0102","0008 0104");
  ($status, my %test_0040_0260_hash) = getMultipleItemsFromSequence($logLevel, $referenceMPPS, "0040 0260", "0008 0100","0008 0102","0008 0104");
  #my %test_copy = %test_0040_0260_hash;
  my $retValue = hashContains($logLevel, \%test_0040_0260_hash,\%ref_0040_0260_hash);
  
  if($retValue != 1){
     $errorCount++;
     print main::LOG "ERR: The Performed Protocol Code Seq in Test MPPS does not contain the following code sequence(s):\n";
  }else{
     print main::LOG "CTX: The Performed Protocol Code Seq in Test MPPS contains the following code sequence(s):\n";
  }
  my @keys = sort (keys(%test_0040_0260_hash));
  foreach (@keys){
     my @tokens = split /\^/, $_;
     print main::LOG "  Code Value: $tokens[0]\n";
     print main::LOG "  Code Scheme Designator: $tokens[1]\n";
     print main::LOG "  Code Meaning: $tokens[2]\n";     
  }
  #end eval 0040 0260 seq
  
  return $errorCount;
}

sub mesa_evaluate::eval_storage_commit_SCU_requests {
  my ($logLevel, $commitDir, $dbName) = @_;

  print main::LOG "CTX: mesa_evaluate::eval_storage_commit_SCU_requests $dbName $commitDir \n" if ($logLevel >= 3);

  my %openRequests = mesa_evaluate::getOpenSCRequestsHash($logLevel, $commitDir);
  my ($x, @storedInstanceUIDs) = mesa_get::getSOPInstancesFromDB($logLevel, $dbName);

  my $rtnValue = 0;
  foreach $uid(@storedInstanceUIDs) {
    print main::LOG "CTX: Stored SOP Instance UID: $uid\n" if ($logLevel >= 3);
    my $sopClass = $openRequests{$uid};
    if (!$sopClass  || $sopClass eq "") {
      print main::LOG "ERR: SOP Instance UID found in DB not listed in Storage Commit Request,\n";
      print main::LOG "ERR:  or, you did not include the SOP Class UID\n";
      print main::LOG "ERR:  $uid\n";
      $rtnValue += 1;
    }
  }

  $keyCount = keys %openRequests;
  $count = scalar(@storedInstanceUIDs);
  print main::LOG "CTX: Stored objects: $count, commit requests: $keyCount\n" if ($logLevel >= 3);
  if ($keyCount != $count) {
    print main::LOG "ERR: Stored objects ($count) do not match commit requests ($keyCount)\n";
    $rtnValue += 1;
  }

  return $rtnValue;
}


#sub eval_mpps_PMI {
#  my ($logLevel, $titleMPPSMgr, $referenceMPPS, $testMPPS) = @_;

#  print main::LOG "CTX: mesa_dicom_eval::eval_mpps_PMI $titleMPPSMgr, $referenceMPPS, $testMPPS\n" if ($logLevel >= 3);

#  if (! -e $referenceMPPS) {
#    print main::LOG "ERR: Reference MPPS file $referenceMPPS does not exist; please post a bugzilla error\n";
#    return 1;
#  }
#  if (! -e $testMPPS) {
#    print main::LOG "ERR: Test MPPS file $testMPPS does not exist\n";
#    print main::LOG "ERR: Is the AE title for MPPS SCU <$testMPPS>\n";
#    print main::LOG "ERR: Look in the directory $MESA_STORAGE/imgmgr/mpps\n";
#    return 1;
#  }

 # my @attributesMPPS = (
#	"", 0, "0008 0060", "EQUAL", "Modality",
#	"", 0, "0010 0010", "NAME",  "Patient Name",
#	"", 0, "0010 0020", "EQUAL", "Patient ID",
#	"", 0, "0010 0030", "EQUAL", "Birth Date",
#	"", 0, "0010 0040", "EQUAL", "Sex",
#	"0040 0270", 1, "0008 0050", "EQUAL", "Accession Number",
#	"0040 0270", 1, "0040 1001", "FORMAT", "Req Proc ID",
#	"0040 0270", 1, "0040 0009", "FORMAT", "SPS ID",
#	"", 0, "0020 0010", "FORMAT", "Study ID",
#	"", 0, "0040 0253", "FORMAT", "PPS ID",
#	"", 0, "0040 0254", "FORMAT", "PPS Description",
#  );

#  my $idx = 0;
#  my $errorCount = 0;
#  while ($idx < scalar(@attributesMPPS)) {
#    $errorCount += eval_dicom_att($logLevel, $referenceMPPS, $testMPPS,
#	$attributesMPPS[$idx+0], $attributesMPPS[$idx+1], $attributesMPPS[$idx+2],
#	$attributesMPPS[$idx+3], $attributesMPPS[$idx+4]);
#    $idx += 5;
#  }
#  return $errorCount;
#}

sub processConstantList {
   my ($logLevel, @entries) = @_;
   my $idx = 0;
   my $errorCount = 0;
   while ($idx < scalar(@entries)) {
        my $evalType = $entries[$idx+0];
	my $seqTag = $entries[$idx+1];
	my $seqIndex = $entries[$idx+2];
	my $tag = $entries[$idx+3];
	my $testObj = $entries[$idx+4];
	my $refValue = $entries[$idx+5];
	my $attributeName = $entries[$idx+6];
	
	my ($status, $testValue)  = mesa_get::getDICOMValue($logLevel, $testObj, $seqTag, $tag, $seqIndex);
	print main::LOG "CTX: $seqTag $tag $seqIndex REF: <$refValue> TEST: <$testValue>\n" if ($logLevel >= 3);
	   
	if($evalType eq "EQUAL"){   
	   if ($testValue ne $refValue) {
      		print main::LOG "ERR: $seqTag $tag $seqIndex value mismatch REF: <$refValue> TEST: <$testValue> $attributeName\n";
      		$errorCount++;
           }
	}elsif($evalType eq "OR"){
	   @refValues = split /^/, $refValue;
	   #displayList("reference value list", @refValues) if($logLevel >=3);
	   my $retValue = arrayContains($testValue, @refValues);
	   if ($retValue != 1){
	      print main::LOG "ERR: $seqTag $tag $seqIndex value mismatch one of the following values seperated by ^ REF: <$refValue> TEST: <$testValue> $attributeName\n";
	      $errorCount++;
	   }
	}else {
           die "Unsupported evaluation type: $evalType";
        }
	$idx += 7;
   }	

   return $errorCount;
}

sub eval_cstore_importer {
   my ($logLevel, $titleMPPSMgr, $referenceObject, $testObject) = @_;

   print main::LOG "CTX: mesa_dicom_eval::eval_cstore_importer $titleMPPSMgr, $referenceObject, $testObject\n" if ($logLevel >= 3);

   if (! -e $referenceObject) {
      print main::LOG "ERR: Reference Object file $referenceObject does not exist; please post a bugzilla error\n";
      return 1;
   }
   if (! -e $testObject) {
      print main::LOG "ERR: Test Object file $testObject does not exist\n";
      print main::LOG "ERR: Look in the directory $MESA_STORAGE/imgmgr/instances\n";
      return 1;
   }

   my @attributes = (
	#call patient module
	#"", 0, "0010 0010", "EQUAL",  "Patient Name",
	#"", 0, "0010 0020", "EQUAL", "Patient ID",
	#"", 0, "0010 1000", "EQUAL", "Other Pat ID",
	#"", 0, "0010 0030", "EQUAL", "Birth Date",
	#"", 0, "0010 0040", "EQUAL", "Sex",

	#call study module #
	#"", 0, "0020 000D", "EQUAL", "Study Instance UID",

	#SteveM asked to wait for checking the following two
	#"0008 1110", 0, "0008 1150", "EQUAL" , "Referenced Study Sequence - Referenced SOP Class UID",
	#"0008 1110", 0, "0008 1155", "EQUAL" , "Referenced Study Sequence - Referenced SOP Instance UID", 
	
	"", 0, "0008 0050", "EQUAL", "Accession Number",
	"0008 1032", 0, "0008 0100", "EQUAL", "Code Value",
	"0008 1032", 0, "0008 0102", "EQUAL", "Coding Scheme Designator",
	"0008 1032", 0, "0008 0104", "EQUAL", "Code Meaning",
        "0008 1111", 0, "0008 1150", "EQUAL", "Referenced SOP Class UID",
	"0400 0561" , 0, "0400 0565", "EQUAL", "Reseaon for the attribute modification",
   );
  
   my @sequences = (
  	"0040 0275" , 0, "", "SEQEXIST", "Request Attributes Sequence",
	"", 0, "0040 0253", "EXIST", "Performed Procedure Step ID",
	"", 0, "0040 0254", "EXIST", "Performed Procedure Step Description",
	"0008 1111", 0, "", "SEQEXIST", "Referenced PPS Sequence",
	"0008 1111", 0, "0008 1155", "EXIST", "Referenced SOP Inst UID",
	"0400 0561" , 0, "", "SEQEXIST", "Original Attributes Sequence",
	#"0400 0561" , 0, "0400 0564", "EXIST", "Source of Previous Values",
	#"0400 0561" , 0, "0400 0562", "EXIST", "Attribute Modification Datetime",
	#"0400 0561" , 0, "0400 0563", "EXIST", "Modifying System",
   );
  
#   my @subsequences = (
#  	"0400 0550" , 0, "", "SEQEXIST", "Modified attributes sequence",
#	"0400 0550" , 0, "0020 000D", "NOTEXIST", "Original Value of Study Inst UID",
#   );
   $errorCount += validateOtherPatID($logLevel, $referenceObject, $testObject);
   $errorCount += validatePatientModule($logLevel, $referenceObject, $testObject);
   $errorCount += validateStudyModule($logLevel, $referenceObject, $testObject);  
   $errorCount += processValueList($logLevel, $referenceObject, $testObject, @attributes);
   $errorCount += processExistenceList($logLevel, $referenceObject, $testObject, @sequences);
 
   my $ref_0400_0561 = dcmDumpElement($logLevel, "0400 0561", $referenceObject, "$main::MESA_STORAGE/tmp/ref_0400_0561.dcm"); 
   my $test_0400_0561 = dcmDumpElement($logLevel, "0400 0561", $testObject, "$main::MESA_STORAGE/tmp/test_0400_0561.dcm");
   
   my @value_0400_0561 = (
  	"" , 0, "0400 0565", "EQUAL", "Reason for the attribute modification",
   );
   my @existence_0400_0561 = (
  	#"" , 0, "", "SEQEXIST", "Original Attributes Sequence",
	"" , 0, "0400 0564", "EXIST", "Source of Previous Values",
	"" , 0, "0400 0562", "EXIST", "Attribute Modification Datetime",
	"" , 0, "0400 0563", "EXIST", "Modifying System",
	"0400 0550" , 0, "processConstantList", "SEQEXIST", "Modified Attributes Sequence"
   );
  
   $errorCount += processValueList($logLevel, "$ref_0400_0561", "$test_0400_0561", @value_0400_0561);
   $errorCount += processExistenceList($logLevel, "$ref_0400_0561", "$test_0400_0561", @existence_0400_0561);
  
   #Check 0400 0565 seq under 0400 0561 seq.
   my $ref_0400_0550 = dcmDumpElement($logLevel, "0400 0550", $ref_0400_0561, "$main::MESA_STORAGE/tmp/ref_0400_0550.dcm"); 
   my $test_0400_0550 = dcmDumpElement($logLevel, "0400 0550", $test_0400_0561, "$main::MESA_STORAGE/tmp/test_0400_0550.dcm");
   
   #remove check due to bug fix 135: 0010 1000, 0008 1110, and 0008 1032
   my @value_0400_0550 = (
  	"" , 0, "0010 0010", "EQUAL", "Original Value of Patient ID",
	#"" , 0, "0010 1000", "EQUAL", "Original Value of Other Pat ID",
	"" , 0, "0010 0030", "EQUAL", "Original Value of Birth Date",
	"" , 0, "0008 0050", "EQUAL", "Original Value of Accession",
	#Ref Study Seq
	#"0008 1110", 0, "0008 1150", "EQUAL", "Referenced SOP Class UID",
	#"0008 1110", 0, "0008 1155", "EQUAL", "Referenced SOP Instance UID",
	#Procedure Code Seq 
	#"0008 1032", 0, "0008 0100", "EQUAL", "Code Value",
	#"0008 1032", 0, "0008 0102", "EQUAL", "Coding Scheme Designator",
	#"0008 1032", 0, "0008 0104", "EQUAL", "Code Meaning",
   );
   my @existence_0400_0550 = (
  	"" , 0, "0020 000D", "NOTEXIST", "Original Value of Study Inst UID",
   );

   $errorCount += processValueList($logLevel, "$ref_0400_0550", "$test_0400_0550", @value_0400_0550);
   $errorCount += processExistenceList($logLevel, "$ref_0400_0550", "$test_0400_0550", @existence_0400_0550);
  
   #check (0018 A001) Contributing Eqt Seq
   my $ref_0018_A001 = dcmDumpElement($logLevel, "0018 A001", $referenceObject, "$main::MESA_STORAGE/tmp/ref_0018_A001.dcm"); 
   my $test_0018_A001 = dcmDumpElement($logLevel, "0018 A001", $testObject, "$main::MESA_STORAGE/tmp/test_0018_A001.dcm");
   
   my @value_0018_A001 = (
  	"0040 A170", 0, "0008 0100", "EQUAL", "Code Value",
	"0040 A170", 0, "0008 0102", "EQUAL", "Coding Scheme Designator",
	"0040 A170", 0, "0008 0104", "EQUAL", "Code Meaning",
   );
   
   my @existence_0018_A001 = (
  	"" , 0, "0008 0070", "EXIST", "Manufacturer",
	"" , 0, "0008 0080", "EXIST", "Institution",
	"" , 0, "0008 1010", "EXIST", "Station Name",
	"" , 0, "0018 A002", "EXIST", "Contr Date/Time",
   );
   
   print main::LOG "CTX: Examine attributes in 0018 A001 Contributing Equipment Sequence\n" if ($logLevel >= 3);
   $errorCount += processValueList($logLevel, "$ref_0018_A001", "$test_0018_A001", @value_0018_A001);
   $errorCount += processExistenceList($logLevel, "$ref_0018_A001", "$test_0018_A001", @existence_0018_A001);

   return $errorCount;
}

sub processValueList {
   my ($logLevel, $ref, $test, @entries) = @_;
   my $idx = 0;
   my $errorCount = 0;
   while ($idx < scalar(@entries)) {
	$errorCount += eval_dicom_att($logLevel, $ref, $test,
	$entries[$idx+0], $entries[$idx+1], $entries[$idx+2],
	$entries[$idx+3], $entries[$idx+4]);
	$idx += 5;
   }
   return $errorCount;
}

sub processExistenceList {
   my ($logLevel, $ref, $test, @entries) = @_;
   my $idx = 0;
   my $errorCount = 0;
   my $count = scalar(@entries);
   print main::LOG "$ref $test $count\n" if($logLevel >= 3);

   while ($idx < scalar(@entries)) {
	$errorCount += eval_dicom_seq($logLevel, $ref, $test,
	$entries[$idx+0], $entries[$idx+1], $entries[$idx+2],
	$entries[$idx+3], $entries[$idx+4]);
	$idx += 5;
   }
   return $errorCount;
}

#sub eval_dicom_att_diff_tag {
#  my ($logLevel, $evalType,
#	$seqTag1, $seqIndex1, $tag1, $reference,  $attributeName1,
#	$seqTag2, $seqIndex2, $tag2, $test,  $attributeName2,) = @_;
#	
#  print main::LOG "CTX: $reference $test\n" if ($logLevel >= 5);
#
#  ($status, $refValue)  = mesa_get::getDICOMValue($logLevel, $reference, $seqTag1, $tag1, $seqIndex1);
#  ($status, $testValue) = mesa_get::getDICOMValue($logLevel, $test,      $seqTag2, $tag2, $seqIndex2);
#  
#  print main::LOG "CTX: $seqTag1 $tag1 $seqIndex1 REF: <$refValue> $seqTag2 $tag2 $seqIndex2 TEST: <$testValue>\n" if ($logLevel >= 3);
#  
#  my $rtnValue = 0;
#  if ($evalType eq "EQUAL") {
#    if ($testValue ne $refValue) {
#      print main::LOG "ERR: value mismatch $seqTag1 $tag1 $seqIndex1 REF: <$refValue> $attributeName1 with $seqTag2 $tag2 $seqIndex2 TEST: <$testValue> $attributeName2\n";
#      $rtnValue = 1;
#    }else {
#    die "Unsupported evaluation type: $evalType";
#    }
#  }
#  return $rtnValue;
#}
  
	
sub eval_bsps_evd_creator {
  my ($logLevel, $referenceObject, $testObject, $underlying, $superimposed) = @_;

  print main::LOG "CTX: mesa_dicom_eval::eval_bsps_evd_creator $referenceObject, $testObject\n" if ($logLevel >= 3);

  if (! -e $referenceObject) {
    print main::LOG "ERR: Reference Object file $referenceObject does not exist; please post a bugzilla error\n";
    return 1;
  }
  if (! -e $testObject) {
    print main::LOG "ERR: Test Object file $testObject does not exist\n";
    print main::LOG "ERR: Look in the directory $MESA_STORAGE/imgmgr/instances\n";
    return 1;
  }

  my $errorCount = 0;
  $errorCount += validatePatientModule($logLevel, $referenceObject, $testObject);
  $errorCount += validateStudyModule($logLevel, $referenceObject, $testObject);
  $errorCount += validateBSPModule($logLevel, $referenceObject, $testObject);
  $errorCount += checkSeriesModule($logLevel, $testObject, $underlying, $superimposed);

  return $errorCount;
}


sub checkSeriesModule {
  my ($logLevel, $test, $underLying, $superImposed) = @_;
  print main::LOG "\nCTX: mesa_dicom_eval::checkSeriesModule\n";
  print main::LOG "Checking to see if the Series Instance UID in the test object is different than that of the images referenced\n";

  my @superimposedFiles = mesa_get::getDirectoryListFullPath($logLevel, $superImposed);
  if (scalar(@superimposedFiles) == 0) {
    print main::LOG "ERR: mesa_dicom_eval::checkSeriesModule found no DICOM files in $superImposed\n";
    return 1;
  }

  my ($y, $superimposedFile) = mesa_get::getDICOMFileByTag($logLevel, "0020 0013",
  "1" , @superimposedFiles);
  if ($y != 0) {
    print main::LOG "ERR: mesa_dicom_eval::checkSeriesModule Did not find a file in superimposed files for 0020 0013 1\n";
    return 1;
  }

  ($status, $superImposedValue)  = mesa_get::getDICOMValue($logLevel, $superimposedFile, "", "0020 000E", "0");

  my @underlyingFiles = mesa_get::getDirectoryListFullPath($logLevel, $underLying);
  if (scalar(@underlyingFiles) == 0) {
    print main::LOG "ERR: mesa_dicom_eval::checkSeriesModule found no DICOM files in $underLying\n";
    return 1;
  }

  my ($z, $underlyingFile) = mesa_get::getDICOMFileByTag($logLevel, "0020 0013", "1" , @underlyingFiles);
  if ($z != 0) {
    print main::LOG "ERR: mesa_dicom_eval::checkSeriesModule Did not find a file in underlying files for 0020 0013 1\n";
    return 1;
  }

  ($status, $underLyingValue)  = mesa_get::getDICOMValue($logLevel, $underlyingFile, "", "0020 000E", "0");

  ## Get the value from test object
  ($status, $testValue)  = mesa_get::getDICOMValue($logLevel, $test, "", "0020 000E", "0");

  $errorCount = 0;
  ## Check to see if the testValue is different from $superImposedValue and $unlerLyingValue
  $errorCount ++ if (($testValue eq $underLyingValue) || ($testValue eq $superImposedValue));
  if ($errorCount) { print main::LOG "ERR: "; }
  unless ($errorCount) { print main::LOG "CTX: "; }
  print main::LOG "TEST <$testValue> PT<$superImposedValue> CT<$underLyingValue>\n\n";

  return $errorCount;
}
	
sub eval_spatial_evd_creator {
  my ($logLevel, $referenceObject, $testObject, $underlying, $superimposed) = @_;

  print main::LOG "CTX: mesa_dicom_eval::eval_spatial_evd_creator $referenceObject, $testObject\n" if ($logLevel >= 3);

  if (! -e $referenceObject) {
    print main::LOG "ERR: Reference Object file $referenceObject does not exist; please post a bugzilla error\n";
    return 1;
  }
  if (! -e $testObject) {
    print main::LOG "ERR: Test Object file $testObject does not exist\n";
    print main::LOG "ERR: Look in the directory $MESA_STORAGE/imgmgr/instances\n";
    return 1;
  }

  my $errorCount = 0;
  $errorCount += validatePatientModule($logLevel, $referenceObject, $testObject);
  $errorCount += validateStudyModule($logLevel, $referenceObject, $testObject);
  $errorCount += checkSeriesModule($logLevel, $testObject, $underlying, $superimposed);
  $errorCount += validateSpatialModule($logLevel, $referenceObject, $testObject);

  return $errorCount;
}


sub eval_spatial_bsps_evd_creator {
  my ($logLevel, $referenceObject, $testObject) = @_;

  print main::LOG "CTX: mesa_dicom_eval::eval_spatial_bsps_evd_creator $referenceObject, $testObject\n" if ($logLevel >= 3);

  if (! -e $referenceObject) {
    print main::LOG "ERR: Reference Object file $referenceObject does not exist; please post a bugzilla error\n";
    return 1;
  }
  if (! -e $testObject) {
    print main::LOG "ERR: Test Object file $testObject does not exist\n";
    print main::LOG "ERR: Look in the directory $MESA_STORAGE/imgmgr/instances\n";
    return 1;
  }

  my $errorCount = 0;
  $errorCount += validateSpatialBSPSModule($logLevel, $referenceObject, $testObject);

  return $errorCount;
}


sub evalCFindBSPSInstanceLevel {
  my ($logLevel, $referenceObject, $testObject) = @_;

  print main::LOG "CTX: mesa_dicom_eval::evalCFindBSPSInstanceLevel $referenceObject, $testObject\n" if ($logLevel >= 3);

  my @attributes = (
	"", 0, "0070 0080", "EQUAL",  "Presentation Label",
	"", 0, "0070 0082", "EQUAL",  "Presentation Creation Date",
	"", 0, "0070 0083", "EQUAL",  "Presentation Creation Time",
	"", 0, "0070 0084", "EQUAL",  "Presentation Creator\'s Name",
  );

  my $idx = 0;
  my $errorCount = 0;
  while ($idx < scalar(@attributes)) {
    $errorCount += eval_dicom_att($logLevel, $referenceObject, $testObject,
	$attributes[$idx+0], $attributes[$idx+1], $attributes[$idx+2],
	$attributes[$idx+3], $attributes[$idx+4]);
    $idx += 5;
  }
  return $errorCount;
}

# Private functions probably only used by the public functions above.

sub eval_dicom_att {
  my ($logLevel, $reference, $test,
	$seqTag, $seqIndex, $tag, $evalType, $attributeName) = @_;

  print main::LOG "CTX: $reference $test\n" if ($logLevel >= 5);

  ($status, $refValue)  = mesa_get::getDICOMValue($logLevel, $reference, $seqTag, $tag, $seqIndex);
  ($status, $testValue) = mesa_get::getDICOMValue($logLevel, $test,      $seqTag, $tag, $seqIndex);

  if ($logLevel >= 3) {
    if ($evalType eq "NAME" || $evalType eq "EQUAL") {
      print main::LOG "CTX: $evalType $seqTag $tag $seqIndex REF: <$refValue> TEST: <$testValue>\n";
    } else {
      print main::LOG "CTX: $evalType $seqTag $tag $seqIndex <$testValue>\n";
    }
  }

  my $rtnValue = 0;
  if ($evalType eq "EQUAL") {
    if ($testValue ne $refValue) {
      print main::LOG "ERR: $seqTag $tag $seqIndex value mismatch REF: <$refValue> TEST: <$testValue> $attributeName\n";
      $rtnValue = 1;
    }
  } elsif ($evalType eq "UID") {
    die "Unsupported evaluation type: $evalType";
  } elsif ($evalType eq "FORMAT") {
#    die "Unsupported evaluation type: $evalType";
  } elsif ($evalType eq "NAME") {
    if ($testValue ne $refValue) {
      print main::LOG "ERR: $seqTag $tag $seqIndex value mismatch REF: <$refValue> TEST: <$testValue> $attributeName\n";
      $rtnValue = 1;
    }
  } elsif ($evalType eq "ZERO") {
    if ($testValue ne "") {
      print main::LOG "ERR: $seqTag $tag $seqIndex value should be 0-length TEST: <$testValue> $attributeName\n";
      $rtnValue = 1;
    }
  } elsif ($evalType eq "NONZEROLENGTH") {
    if ($testValue eq "") {
      print main::LOG "ERR: $seqTag $tag $seqIndex value should not be 0-length TEST: <$testValue> $attributeName\n";
      $rtnValue = 1;
    }
  } elsif ($evalType eq "NONZEROLENGTH_EQUAL") {
    if ($testValue eq "") {
      print main::LOG "ERR: $seqTag $tag $seqIndex value should not be 0-length TEST: <$testValue> $attributeName\n";
      $rtnValue = 1;
    } elsif ($testValue ne $refValue) {
      print main::LOG "ERR: $seqTag $tag $seqIndex value mismatch REF: <$refValue> TEST: <$testValue> $attributeName\n";
      $rtnValue = 1;
    }
  } elsif ($evalType eq "EXIST"){
    if($seqTag ne ""){
    	$x = "$main::MESA_TARGET/bin/dcm_print_element -x -s $seqTag $tag $test";
    } else{
	$x = "$main::MESA_TARGET/bin/dcm_print_element -x $tag $test";
    }
    print "$x\n" if ($logLevel >= 3);
    my $v = `$x`;
    if($v eq "1" && $evalType eq "EXIST"){
      print main::LOG "ERR: $tag: <$attributeName> should be present in TEST: $test \n";
      $rtnValue = 1;
    }elsif ($v ne "1" && $evalType eq "NOTEXIST"){
      print main::LOG "ERR: $tag: <$attributeName> should NOT present in TEST: $test \n";
      $rtnValue = 1;
    }
  } elsif ($evalType eq "RANGE") {
 	  my ($plus, $minus, $range) = split(/,/,$attributeName);
  	  my $refRange = $refValue * $range/100;
	  my $topRange = $refValue + $refRange;
	  my $lowRange = $refValue - $refRange;
	  print main::LOG "R A N G E : $refValue\t$range\t$refRange\t$topRange\t$lowRange\n";
      if ($plus && $minus) {
	    if (($testValue >= $lowRange) && ($testValue <= $topRange)) {
		  print main::LOG "R A N G E : Looks good\n";
	    } else {
	      print main::LOG "ERR: <testValue> out of range\n";
      	  $rtnValue = 1;
	    }
      } elsif ($plus) {
      } elsif ($minus) {
	  }
  }else {
    die "Unsupported evaluation type: $evalType";
  }

  return $rtnValue;
}

sub eval_dicom_seq{
  my ($logLevel, $reference, $test,
	$seqTag, $seqIndex, $tag, $evalType, $attributeName) = @_;

  print main::LOG "CTX: $test\n" if ($logLevel >= 5);
  
  my $rtnValue = 0;
  my $x;
  if ($evalType eq "SEQEXIST"){
    $x = "$main::MESA_TARGET/bin/dcm_print_element -x $seqTag $test";
    print "$x\n" if ($logLevel >= 3);
    my $v = `$x`;
    if($v != 3){
      print main::LOG "ERR: $seqTag: <$attributeName> does NOT exist with at least one item in TEST: $test \n";
      $rtnValue = 1;
    }else{
      print main::LOG "CTX: $seqTag: <$attributeName> exists with at least one item in TEST: $test \n";
    }
  } elsif ($evalType eq "EXIST" || $evalType eq "NOTEXIST"){
#    print "\n $seqTag \n";
    if($seqTag ne ""){
    	$x = "$main::MESA_TARGET/bin/dcm_print_element -x -s $seqTag $tag $test";
    } else{
	$x = "$main::MESA_TARGET/bin/dcm_print_element -x $tag $test";
    }
    print "$x\n" if ($logLevel >= 3);
    $v = `$x`;
    $v =~ s/^\s+//;
    $v =~ s/\s+$//;
    #print main::LOG "CTX $tag checking for existence; no message indicates success\n" if ($logLevel >= 3);
    #if($v eq "1" && $evalType eq "EXIST"){
    #  print main::LOG "ERR: $tag: <$attributeName> should present in TEST: $test \n";
    #  $rtnValue = 1;
    #}elsif ($v ne "1" && $evalType eq "NOTEXIST"){
    #  print main::LOG "ERR: return value is ($v)\n" if($logLevel >=3);
    #  print main::LOG "ERR: $tag: <$attributeName> should NOT present in Reference SOP Class UID TEST: $test \n";
    #  $rtnValue = 1;
    if($v eq "0"){
        print main::LOG "ERR: File $test not found.\n";
	$rtnValue = 1;
    }elsif($evalType eq "EXIST"){
      if ($v eq "1"){
        print main::LOG "ERR: $tag: <$attributeName> should present in TEST: $test \n";
        $rtnValue = 1;
      }else{
        print main::LOG "INFO: $tag: <$attributeName> present in TEST: $test \n";
        $rtnValue = 0;
      }
    }elsif ($evalType eq "NOTEXIST"){
      if ($v ne "1") {
         print main::LOG "ERR: return value is ($v)\n" if($logLevel >=3);
         print main::LOG "ERR: $tag: <$attributeName> should NOT present in Reference SOP Class UID TEST: $test \n";
         $rtnValue = 1;
      }else{
         print main::LOG "INFO: $tag: <$attributeName> does not present in TEST: $test \n";
         $rtnValue = 0;
      }
    }
  } else {
    die "Unsupported evaluation type: $evalType";
  }

  return $rtnValue;
}

sub eval_dicom_att_sequence {
  my ($logLevel, $reference, $test,
	$seqTag1, $seqTag2, $tag, $evalType, $attributeName) = @_;

  print main::LOG "CTX: $reference $test\n" if ($logLevel >= 5);

  ($status, $refValue)  = mesa_get::getDICOMValueSequence($logLevel, $reference, $seqTag1, $seqTag2, $tag);
  ($status, $testValue) = mesa_get::getDICOMValueSequence($logLevel, $test,      $seqTag1, $seqTag2, $tag);

  if ($logLevel >= 3) {
    if ($evalType eq "NAME" || $evalType eq "EQUAL") {
      print main::LOG "CTX: $evalType $seqTag1 $seqTag2 $tag REF: <$refValue> TEST: <$testValue>\n";
    } else {
      print main::LOG "CTX: $evalType $seqTag1 $seqTag2 $tag <$testValue>\n";
    }
  }

  my $rtnValue = 0;
  if ($evalType eq "EQUAL") {
    if ($testValue ne $refValue) {
      print main::LOG "ERR: $seqTag1 $seqTag2 $tag value mismatch REF: <$refValue> TEST: <$testValue> $attributeName\n";
      $rtnValue = 1;
    }
  } elsif ($evalType eq "UID") {
    die "Unsupported evaluation type: $evalType";
  } elsif ($evalType eq "FORMAT") {
#    die "Unsupported evaluation type: $evalType";
    if ($testValue eq "") {
      print main::LOG "ERR: Format test: ($seqTag1 $seqTag2 $tag) zero length value: TEST: $attributeName\n";
      $rtnValue = 1;
    }
  } elsif ($evalType eq "NAME") {
    if ($testValue ne $refValue) {
      print main::LOG "ERR: $seqTag1 $seqTag2 $tag value mismatch REF: <$refValue> TEST: <$testValue> $attributeName\n";
      $rtnValue = 1;
    }
  } elsif ($evalType eq "ZERO") {
    if ($testValue ne "") {
      print main::LOG "ERR: $seqTag1 $seqTag2 $tag value should be 0-length TEST: <$testValue> $attributeName\n";
      $rtnValue = 1;
    }
  } else {
    die "Unsupported evaluation type: $evalType";
  }

  return $rtnValue;
}


sub eval_mpps_nSet_importer {
  my ($logLevel, $titleMPPSMgr, $referenceMPPS, $testMPPS) = @_;

  print main::LOG "CTX: mesa_dicom_eval::eval_mpps_nSet_importer $titleMPPSMgr, $referenceMPPS, $testMPPS\n" if ($logLevel >= 3);

  if (! -e $referenceMPPS) {
    print main::LOG "ERR: Reference MPPS file $referenceMPPS does not exist; please post a bugzilla error\n";
    return 1;
  }
  if (! -e $testMPPS) {
    print main::LOG "ERR: Test MPPS file $testMPPS does not exist\n";
    print main::LOG "ERR: Is the AE title for MPPS SCU <$testMPPS>\n";
    print main::LOG "ERR: Look in the directory $MESA_STORAGE/imgmgr/mpps\n";
    return 1;
  }
  
  my @attributesMPPS = (
    "", 0, "0040 0252", "EQUAL",  "PPS Status",
    "0040 0340", 0, "0020 000e", "EQUAL", "Series Instance UID",
  );
  
  my $errorCount = 0;
  $errorCount += processValueList($logLevel, $referenceMPPS, $testMPPS, @attributesMPPS);
  
  # Check sequence 0040 0340
  my $test_0040_0340 = dcmDumpElement($logLevel, "0040 0340", $testMPPS, "$main::MESA_STORAGE/tmp/test_0040_0340.dcm");
  my $ref_0040_0340 = dcmDumpElement($logLevel, "0040 0340", $referenceMPPS, "$main::MESA_STORAGE/tmp/ref_0040_0340.dcm");
   
  ($status, my %testHash) = getMultiplePairsFromSequence($logLevel, $test_0040_0340, "0008 1140", "0008 1155", "0008 1150");
  ($status, my %refHash) = getMultiplePairsFromSequence($logLevel, $ref_0040_0340, "0008 1140", "0008 1155", "0008 1150");
  
  my $retValue = hashEqual($logLevel, \%testHash, \%refHash);
  if ($retValue == 0){
     print main::LOG "ERR: Referrenced Image Sequence (0008 1140) does not have all the image references\n";
     $errorCount++;
  }else{
     print main::LOG "CTX: Referrenced Image Sequence (0008 1140) has all the image references\n"; 
  }
  # End of checking sequence 0040 0340
  
  
  return $errorCount;
}

sub eval_mpps_nSet_importer_status {
  my ($logLevel, $titleMPPSMgr, $referenceMPPS, $testMPPS) = @_;

  print main::LOG "CTX: mesa_dicom_eval::eval_mpps_nSet_status $titleMPPSMgr, $referenceMPPS, $testMPPS\n" if ($logLevel >= 3);

  if (! -e $referenceMPPS) {
    print main::LOG "ERR: Reference MPPS file $referenceMPPS does not exist; please post a bugzilla error\n";
    return 1;
  }
  if (! -e $testMPPS) {
    print main::LOG "ERR: Test MPPS file $testMPPS does not exist\n";
    print main::LOG "ERR: Is the AE title for MPPS SCU <$testMPPS>\n";
    print main::LOG "ERR: Look in the directory $MESA_STORAGE/imgmgr/mpps\n";
    return 1;
  }
  
  my @attributesMPPS = (
    "", 0, "0040 0252", "EQUAL",  "PPS Status",
  );
  
  my $errorCount = 0;
  $errorCount += processValueList($logLevel, $referenceMPPS, $testMPPS, @attributesMPPS);
  
  return $errorCount;
}

# pass in the dcm to be dumped, tag of the element to be dumped, and path of where to dump.
# return dumped element.
sub dcmDumpElement {
   my ($logLevel, $tag, $dcm, $dumpTo, $idx) = @_;
   
   if (! $idx) {
     $idx = 1;
   }
      
   my $x = "$main::MESA_TARGET/bin/dcm_dump_element -i $idx $tag $dcm $dumpTo";
   print main::LOG "CTX: $x\n" if ($logLevel >= 3);
   `$x`;
   die if $?;
   return $dumpTo;
}

sub validatePatientModule {
  my ($logLevel, $referenceObject, $testObject) = @_;

  print main::LOG "\nCTX: mesa_dicom_eval::validatePatientModule $referenceObject, $testObject\n" if ($logLevel >= 3);

  my @attributes = (
	"", 0, "0010 0010", "EQUAL",  "Patient Name",
	"", 0, "0010 0020", "EQUAL", "Patient ID",
	"", 0, "0010 0030", "EQUAL", "Birth Date",
	"", 0, "0010 0040", "EQUAL", "Sex",
  );

  my $idx = 0;
  my $errorCount = 0;
  while ($idx < scalar(@attributes)) {
    $errorCount += eval_dicom_att($logLevel, $referenceObject, $testObject,
	$attributes[$idx+0], $attributes[$idx+1], $attributes[$idx+2],
	$attributes[$idx+3], $attributes[$idx+4]);
    $idx += 5;
  }
  return $errorCount;
}

sub validateBSPModule {
  my ($logLevel, $referenceObject, $testObject) = @_;

  print main::LOG "\nCTX: mesa_dicom_eval::validateBSPModule $referenceObject, $testObject\n" if ($logLevel >= 3);

  my @attributes = (
	"", 0, "0070 0403", "RANGE", "+,-,15",
	"0070 0402", 1, "0070 0405", "EQUAL", "Blending Position",
	"0070 0402", 2, "0070 0405", "EQUAL", "Blending Position",
  );

  my $idx = 0;
  my $errorCount = 0;
  while ($idx < scalar(@attributes)) {
    $errorCount += eval_dicom_att($logLevel, $referenceObject, $testObject,
	$attributes[$idx+0], $attributes[$idx+1], $attributes[$idx+2],
	$attributes[$idx+3], $attributes[$idx+4]);
    $idx += 5;
  }
  return $errorCount;
}

sub validateStudyModule {
  my ($logLevel, $referenceObject, $testObject) = @_;

  print main::LOG "\nCTX: mesa_dicom_eval::validateStudyModule $referenceObject, $testObject\n" if ($logLevel >= 3);

  my @attributes = (
	"", 1, "0020 000D", "EQUAL", "Study Inst UID",
  );

  my $idx = 0;
  my $errorCount = 0;
  while ($idx < scalar(@attributes)) {
    $errorCount += eval_dicom_att($logLevel, $referenceObject, $testObject,
	$attributes[$idx+0], $attributes[$idx+1], $attributes[$idx+2],
	$attributes[$idx+3], $attributes[$idx+4]);
    $idx += 5;
  }
  return $errorCount;
}

sub validateOtherPatID {
   my ($logLevel, $refObject, $testObject) = @_;
   my ($status, $refValue)  = mesa_get::getDICOMValue($logLevel, $refObject, "", "0010 1000", 0);
   ($status, my $testValue)  = mesa_get::getDICOMValue($logLevel, $testObject, "", "0010 1000", 0);

   my @refValues =  split /\\/,$refValue;
   my @testValues = split /\\/,$testValue;
   
   @refValues =  sort(@refValues);
   @testValues = sort(@testValues);
   displayList("reference list", @refValues) if($logLevel >=3);
   displayList("test list", @testValues) if($logLevel >=3);
   
   my $retValue = arrayEqual($logLevel, \@refValues, \@testValues);
   if ($retValue != 1){
      print main::LOG "ERR: 0010 1000 0 value mismatch REF: <$refValue> TEST: <$testValue> Other Patient ID\n";
      return 1;
   }else{
      print main::LOG "CTX: 0010 1000 0 value match REF: <$refValue> TEST: <$testValue> Other Patient ID\n";
      return 0;
   }

}

sub eval_cstore_digitizer {
   my ($logLevel, $titleMPPSMgr, $referenceObject, $testObject) = @_;

   print main::LOG "CTX: mesa_dicom_eval::eval_cstore_digitizer $titleMPPSMgr, $referenceObject, $testObject\n" if ($logLevel >= 3);

   if (! -e $referenceObject) {
      print main::LOG "ERR: Reference Object file $referenceObject does not exist; please post a bugzilla error\n";
      return 1;
   }
   if (! -e $testObject) {
      print main::LOG "ERR: Test Object file $testObject does not exist\n";
      print main::LOG "ERR: Look in the directory $MESA_STORAGE/imgmgr/instances\n";
      return 1;
   }

   my @attributes = (
        #call patient module
        #"", 0, "0010 0010", "EQUAL",  "Patient Name",
        #"", 0, "0010 0020", "EQUAL", "Patient ID",
        #"", 0, "0010 1000", "EQUAL", "Other Pat ID",
        #"", 0, "0010 0030", "EQUAL", "Birth Date",
        #"", 0, "0010 0040", "EQUAL", "Sex",

        #call study module #
        #"", 0, "0020 000D", "EQUAL", "Study Instance UID",

        "", 0, "0008 0050", "EQUAL", "Accession Number",
        "0008 1032", 0, "0008 0100", "EQUAL", "Code Value",
        "0008 1032", 0, "0008 0102", "EQUAL", "Coding Scheme Designator",
        "0008 1032", 0, "0008 0104", "EQUAL", "Code Meaning",
        "0008 1111", 0, "0008 1150", "EQUAL", "Referenced SOP Class UID",
        #"0400 0561" , 0, "0400 0565", "EQUAL", "Reseaon for the attribute modification",
   );

   my @sequences = (
        "0008 1110" , 0, "", "SEQEXIST", "Ref Study Sequence",
        "0040 0275" , 0, "", "SEQEXIST", "Request Attributes Sequence",
        "", 0, "0040 0253", "EXIST", "Performed Procedure Step ID",
        #"", 0, "0040 0254", "EXIST", "Performed Procedure Step Description",
        "0008 1111", 0, "", "SEQEXIST", "Referenced PPS Sequence",
        "0008 1111", 0, "0008 1155", "EXIST", "Referenced SOP Inst UID",
        "0400 0561" , 0, "", "SEQEXIST", "Original Attributes Sequence",
        #"0400 0561" , 0, "0400 0564", "EXIST", "Source of Previous Values",
        #"0400 0561" , 0, "0400 0562", "EXIST", "Attribute Modification Datetime",
        #"0400 0561" , 0, "0400 0563", "EXIST", "Modifying System",
   );

#   my @subsequences = (
#       "0400 0550" , 0, "", "SEQEXIST", "Modified attributes sequence",
#       "0400 0550" , 0, "0020 000D", "NOTEXIST", "Original Value of Study Inst UID",
#   );

   $errorCount += validatePatientModule($logLevel, $referenceObject, $testObject);
   $errorCount += validateOtherPatID($logLevel, $referenceObject, $testObject);
   $errorCount += validateStudyModule($logLevel, $referenceObject, $testObject);
   $errorCount += processValueList($logLevel, $referenceObject, $testObject, @attributes);
   $errorCount += processExistenceList($logLevel, $referenceObject, $testObject, @sequences);


   my $z1 = "$main::MESA_TARGET/bin/dcm_dump_element 0400 0561 $testObject $main::MESA_STORAGE/tmp/test_0400_0561.dcm";
   print main::LOG "CTX: $z1\n" if ($logLevel >= 3);
   `$z1`;
   die if $?;

   my $z2 = "$main::MESA_TARGET/bin/dcm_dump_element 0400 0561 $referenceObject $main::MESA_STORAGE/tmp/ref_0400_0561.dcm";
   print main::LOG "CTX: $z2\n" if ($logLevel >= 3);
   `$z2`;
   die if $?;

   my @value_0400_0561 = (
        "" , 0, "0400 0565", "EQUAL", "Reseaon for the attribute modification",
        "0400 0550" , 0, "0010 0010", "EQUAL", "Patient Name from original film or document",
   );
   my @existence_0400_0561 = (
        "" , 0, "0400 0564", "EXIST", "Source of Previous Values",
        "" , 0, "0400 0562", "EXIST", "Attribute Modification Datetime",
        "" , 0, "0400 0563", "EXIST", "Modifying System",
        "0400 0550" , 0, "", "SEQEXIST", "Modified Attributes Sequence"
   );

   $errorCount += processValueList($logLevel, "$main::MESA_STORAGE/tmp/ref_0400_0561.dcm", "$main::MESA_STORAGE/tmp/test_0400_0561.dcm", @value_0400_0561);
   $errorCount += processExistenceList($logLevel, "$main::MESA_STORAGE/tmp/ref_0400_0561.dcm", "$main::MESA_STORAGE/tmp/test_0400_0561.dcm", @existence_0400_0561);


   #check (0018 A001) Contributing Eqt Seq
   my $y1 = "$main::MESA_TARGET/bin/dcm_dump_element 0018 A001 $testObject $main::MESA_STORAGE/tmp/test_0018_A001.dcm";
   print main::LOG "CTX: $y1\n" if ($logLevel >= 3);
   `$y1`;
   die if $?;

   my $y2 = "$main::MESA_TARGET/bin/dcm_dump_element 0018 A001 $referenceObject $main::MESA_STORAGE/tmp/ref_0018_A001.dcm";
   print main::LOG "CTX: $y2\n" if ($logLevel >= 3);
   `$y2`;
   die if $?;

   #my @value_0018_A001 = (
   #     "0040 A170", 0, "0008 0100", "EQUAL", "Code Value",
   #     "0040 A170", 0, "0008 0102", "EQUAL", "Coding Scheme Designator",
   #     "0040 A170", 0, "0008 0104", "EQUAL", "Code Meaning",
   #);

   my @constant_0018_A001 = (
     "OR", "0040 A170", 0,  "0008 0100", "$main::MESA_STORAGE/tmp/test_0018_A001.dcm",  "FILMD^DOCD", "Code Value",
     "EQUAL", "0040 A170", 0,  "0008 0102", "$main::MESA_STORAGE/tmp/test_0018_A001.dcm",  "DCM", "Code Scheme Designator",
     "OR", "0040 A170", 0,  "0008 0104", "$main::MESA_STORAGE/tmp/test_0018_A001.dcm",  "Film Digitizer Equipment^Document Digitizer Equipment", "Code Meaning",
  );
  
   my @existence_0018_A001 = (
        "" , 0, "0008 0070", "EXIST", "Manufacturer",
        "" , 0, "0008 0080", "EXIST", "Institution",
        "" , 0, "0008 1010", "EXIST", "Station Name",
        "" , 0, "0018 A002", "EXIST", "Contr Date/Time",
   );

   #$errorCount += processValueList($logLevel, "$main::MESA_STORAGE/tmp/ref_0018_A001.dcm", "$main::MESA_STORAGE/tmp/test_0018_A001.dcm", @value_0018_A001);
   $errorCount += processConstantList($logLevel, @constant_0018_A001);
   $errorCount += processExistenceList($logLevel, "$main::MESA_STORAGE/tmp/ref_0018_A001.dcm", "$main::MESA_STORAGE/tmp/test_0018_A001.dcm", @existence_0018_A001);

   return $errorCount;
}

# Hash same size, sorted keys are equal, and each value are the same.
# Return 0 if the two hashes are NOT equal, otherwise return 1.
sub hashEqual{
  my ($logLevel, $h1, $h2) = @_;
  
  my %h1 = %{$h1};
  my %h2 = %{$h2};
  my @key1 = sort (keys(%h1));
  my @key2 = sort (keys(%h2));
  my $z1 = @key1;
  my $z2 = @key2;
  my $equal = 1;
  
  if($z1 != $z2){
    print main::LOG "ERR: Hash sizes are different.\n" if ($logLevel >=3);
    $equal = 0;
  }else{
    if(!arrayEqual($logLevel, \@key1, \@key2)){
      print main::LOG "ERR: Hash keys are different.\n" if ($logLevel >=3);
      $equal = 0;
    }else{
      foreach(@key1){
        if($h1{$_} ne $h2{$_}){
	  print main::LOG "ERR: Hash values for key($_) are different in the 2 hashes: $h1{$_} and $h2{$_}\n" if ($logLevel >=3);
	  $equal = 0;
	  last;
	}
      }
    }
  }
  return $equal;
}

# first hash keys are all contained in the second hash keys. corresponding values are the same as well.
# Return 0 if false, otherwise return 1 as true.
sub hashContains{
  my ($logLevel, $h1, $h2) = @_;
  
  my %h1 = %{$h1};
  my %h1_copy = %h1;
  my %h2 = %{$h2};
  my @key1 = sort (keys(%h1));
  my @key2 = sort (keys(%h2));
  
  my $contains = 1;
  
  foreach $i (@key1){
     my $retV1 = arrayContains($i, @key2);
     #print "retV1 = $retV1\n";
     if($retV1 == 1){
        print main::LOG "CTX: one key found\n" if($logLevel >= 4);
        if($h1{$i} eq $h2{$i}){
	   print "CTX: delete one entry\n" if($logLevel >= 4);
	   delete $h1_copy{$i};
	}
     }
  }
  
  my $size = keys(%h1_copy);
  
  #displayHash("", %h1_copy);
  displayHash("", %h1_copy);
  if($size > 0){
    print main::LOG "ERR: The first hash is not completely contained in the second hash.\n" if($logLevel >= 3);
    displayHash("to be checked",%h1) if($logLevel >= 3);
    displayHash("as container",%h2) if($logLevel >= 3);
    $contains = 0;
  }else{
     
  }
  
  return $contains;
}

sub arrayContains{
  my ($item, @items) = @_;
  my $contains = 0;
  
  foreach $j (@items){
    print main::LOG "INFO: comparing <$item> with <$j>\n"; 
    if($j eq $item){
      #print main::LOG "found\n";
      $contains = 1;
      last;
    }
  }
  return $contains;   
}

# array of same size and every item at the same index is the same.
# Return 0 if the two arrays are NOT equal, otherwise return 1.
sub arrayEqual{
  my ($logLevel, $a1, $a2) = @_;
  print main::LOG "CTX: arrayEqual start:\n" if($logLevel >=3);
  my $z1 = @{$a1};
  my $z2 = @{$a2};
  my $equal = 1;
  
  if($z1 != $z2){
    print main::LOG "ERR: In arrayEqual meothod, the two arrays are of different size.\n";
    $equal = 0;
  }
  
  for ($i = 0; $i<$z1 && $equal; $i++){
    print main::LOG "CTX: Comparing <@{$a1}[$i]> and <@{$a2}[$i]>\n";
    if(@{$a1}[$i] ne @{$a2}[$i]){
      print main::LOG "ERR: In arrayEqual meothod, <@{$a1}[$i]> ne <@{$a2}[$i]>\n";
      $equal = 0;
      last;
    }
  }
  print main::LOG "CTX: arrayEqual end:\n" if($logLevel >=3);  
  return $equal ;
}

#Pass in the dicom object, and grouptag, tag. If no grouptag, pass in ""
#return a hash
sub getMultiplePairsFromSequence {
  my ($logLevel, $dcm, $groupTag, $keyTag, $valueTag) = @_;
  my %hash;
  
  #for($i = $maxIndex; $i >=1; $i--){
      my $idx = 1;
      my $done = 0;
      while (! $done) {
        my ($s1, $key) = mesa_get::getDICOMValue($logLevel, $dcm, $groupTag, $keyTag, $idx);
	my ($s2, $value) = mesa_get::getDICOMValue($logLevel, $dcm, $groupTag, $valueTag, $idx);
        
        #print "$idx $s1 $s2 <$classUID> $instanceUID\n";
        if ($s1 != 0 ) {
          print main::LOG "ERR: Error occured when retrieving $idx pair of key from $dcm with group <$groupTag> and tag <$keyTag>\n";
	  return (1, %hash);
        }
	if ($s2 != 0) {
          print main::LOG "ERR: Error occurred when retrieving $idx pair of value from $dcm with group <$groupTag> and tag <$valueTag>\n";
	  return (1, %hash);
        }
        if ($key eq "") {
          $done = 1;
	  my $i = $idx - 1;
	  print main::LOG "INFO: There are total of $i pairs found and push into the hash.\n" if($logLevel >= 3);
        } else {
          $hash{$key} = $value;
          $idx++;
        }
      }
   #}
   displayHash("retrieved from $dcm",%hash) if($logLevel >= 3);
   return (0,%hash);
}

#Pass in the dicom object, and grouptag, tag. If no grouptag, pass in ""
#return a hash
sub getMultipleItemsFromSequence {
  my ($logLevel, $dcm, $groupTag, $tag1, $tag2, $tag3) = @_;
  my %hash;
  
  my $idx = 1;
  my $done = 0;
  while (! $done) {
     my ($s1, $v1) = mesa_get::getDICOMValue($logLevel, $dcm, $groupTag, $tag1, $idx);
     my ($s2, $v2) = mesa_get::getDICOMValue($logLevel, $dcm, $groupTag, $tag2, $idx);
     my ($s3, $v3) = mesa_get::getDICOMValue($logLevel, $dcm, $groupTag, $tag3, $idx);
     
     if ($s1 != 0 ) {
       print main::LOG "ERR: Error occurred when retrieving $idx pair of key from $dcm with group <$groupTag> and tag <$tag1>\n";
       return (1, %hash);
     }
     if ($s2 != 0) {
       print main::LOG "ERR: Error occurred when retrieving $idx pair of value from $dcm with group <$groupTag> and tag <$tag2>\n";
       return (1, %hash);
     }
     if ($s3 != 0) {
       print main::LOG "ERR: Error occured when retrieving $idx pair of value from $dcm with group <$groupTag> and tag <$tag3>\n";
       return (1, %hash);
     }
     
     if ($v1 eq "") {
       $done = 1;
       my $i = $idx - 1;
       print main::LOG "INFO: There are total of $i items found.\n" if($logLevel >= 3);
     } else {
       $hash{"$v1^$v2^$v3"} = "$v1^$v2^$v3";
       $idx++;
     }
   }

   displayHash("retrieved from $dcm",%hash) if($logLevel >= 3);
   return (0,%hash);
}

sub displayList{
  my($listName,@list)=@_;
  my $size = @list;
  print main::LOG "CTX: There are total of $size entries in the list $listName:\n";
  foreach(@list){
    print main::LOG "     $_\n";
  }
}

sub displayHash{
  my($mapName,%map)=@_;
  my $size = keys(%map);
  print main::LOG "INFO: There are total of $size entries in the hash $mapName:\n";
  foreach $key (keys (%map)){
    print main::LOG "     Key: $key    Value: $map{$key}\n";
  }
}

sub validateSpatialModule {
  my ($logLevel, $referenceObject, $testObject) = @_;

  print main::LOG "\nCTX: mesa_dicom_eval::validateSpatialModule $referenceObject, $testObject\n" if ($logLevel >= 3);

  my $z1 = "$main::MESA_TARGET/bin/dcm_dump_element 0070 0308 $testObject $main::MESA_STORAGE/tmp/test_0070_0308.dcm";
  print main::LOG "CTX: $z1\n" if ($logLevel >= 3);
   `$z1`;
  die if $?;

   my $z2 = "$main::MESA_TARGET/bin/dcm_dump_element 0070 0308 $referenceObject $main::MESA_STORAGE/tmp/ref_0070_0308.dcm";
   print main::LOG "CTX: $z2\n" if ($logLevel >= 3);
   `$z2`;
   die if $?;

   my @existence_0070_0308 = (
        "0070 0309" , 0, "", "SEQEXIST", "Matrix Registration Sequence",
   );

   $errorCount += processExistenceList($logLevel, "$main::MESA_STORAGE/tmp/ref_0070_0308.dcm", "$main::MESA_STORAGE/tmp/test_0070_0308.dcm", @existence_0070_0308);

  return $errorCount;
}

sub validateSpatialBSPSModule {
  my ($logLevel, $referenceBSPSObject, $testBSPSObject, $testSpatialObject) = @_;

  print main::LOG "\nCTX: mesa_dicom_eval::validateSpatialBSPSModule $referenceBSPSObject, $testBSPSObject\n" if ($logLevel >= 3);

  ## Check to see if Blending Sequence has the blending position set to SUPERIMPOSED 
  my $z1 = "$main::MESA_TARGET/bin/dcm_dump_element 0070 0402 $testBSPSObject $main::MESA_STORAGE/tmp/test_0070_0402.dcm";
  print main::LOG "CTX: $z1\n" if ($logLevel >= 3);
   `$z1`;
  die if $?;

  my $z2 = "$main::MESA_TARGET/bin/dcm_dump_element 0070 0402 $referenceBSPSObject $main::MESA_STORAGE/tmp/ref_0070_0402.dcm";
  print main::LOG "CTX: $z2\n" if ($logLevel >= 3);
  `$z2`;
  die if $?;

  my @value_0070_0402 = (
        "" , 0, "0070 0405", "EQUAL", "SUPERIMPOSED",
  );

  $errorCount += processValueList($logLevel, "$main::MESA_STORAGE/tmp/ref_0070_0402.dcm", "$main::MESA_STORAGE/tmp/test_0070_0402.dcm", @value_0070_0402);

  ## Check to see if  Referenced Spatial Registration Sequence has one sequence item
  my @existence_0070_0404 = (
        "0070 0404" , 0, "", "SEQEXIST", "Referenced Spatial Registration Sequence",
  );

  $errorCount += processExistenceList($logLevel, $referenceBSPSObject, $testBSPSObject, @existence_0070_0404);

  ## Check to see if the Series Inst UID in the Ref Spatial Registration Seq has "a" value
  print main::LOG "\nCTX: Check to see if the Series Inst UID in the Ref Spatial Registration Seq has \"a\" value\n";
  my $z3 = "$main::MESA_TARGET/bin/dcm_dump_element 0070 0404 $testBSPSObject $main::MESA_STORAGE/tmp/test_0070_0404.dcm";
  print main::LOG "CTX: $z3\n" if ($logLevel >= 3);
   `$z3`;
  die if $?;

   my $z4 = "$main::MESA_TARGET/bin/dcm_dump_element 0070 0404 $referenceBSPSObject $main::MESA_STORAGE/tmp/ref_0070_0404.dcm";
   print main::LOG "CTX: $z4\n" if ($logLevel >= 3);
   `$z4`;
   die if $?;

  my @existence_0020_000E = (
        "0008 1115" , 1, "0020 000E", "EXIST", "Series Inst UID",
  );

  $errorCount += processExistenceList($logLevel, "$main::MESA_STORAGE/tmp/ref_0070_0404.dcm", "$main::MESA_STORAGE/tmp/test_0070_0404.dcm", @existence_0020_000E);

  ## Check to see if the SOP Inst UID in the Ref Spatial Registration Seq has "a" value
  print main::LOG "\nCTX: Check to see if the SOP Inst UID in the Ref Saptial Registration Seq has \"a\" value\n";
  my $z5 = "$main::MESA_TARGET/bin/dcm_dump_element 0008 1115 $main::MESA_STORAGE/tmp/test_0070_0404.dcm $main::MESA_STORAGE/tmp/test_0008_1115.dcm";
  print main::LOG "\nCTX: $z5\n" if ($logLevel >= 3);
   `$z5`;
  die if $?;

   my $z6 = "$main::MESA_TARGET/bin/dcm_dump_element 0008 1115 $main::MESA_STORAGE/tmp/ref_0070_0404.dcm $main::MESA_STORAGE/tmp/ref_0008_1115.dcm";
   print main::LOG "CTX: $z6\n" if ($logLevel >= 3);
   `$z6`;
   die if $?;

  my @existence_0008_1155 = (
        "0008 1199" , 1, "0008 1155", "EXIST", "Ref SOP Inst UID",
  );

  $errorCount += processExistenceList($logLevel, "$main::MESA_STORAGE/tmp/ref_0008_1115.dcm", "$main::MESA_STORAGE/tmp/test_0008_1115.dcm", @existence_0008_1155);


  return $errorCount;
}

sub eval_cardiology_stress_cstore{
  my ($logLevel, $refObj, $testObj) = @_;

  my %ECG_STRESS_PROTOCOL_CODES=(
    "P2-7131C^SRT^Balke protocol"			    =>         "P2-7131C^SRT^Balke protocol",
    "P2-7131A^SRT^Bruce protocol"			    =>         "P2-7131A^SRT^Bruce protocol",
    "P2-7131D^SRT^Ellestad protocol"			    =>         "P2-7131D^SRT^Ellestad protocol",
    "P2-7131B^SRT^Modified Bruce protocol"		    =>         "P2-7131B^SRT^Modified Bruce protocol",
    "P2-713A1^SRT^Modified Naughton protocol"	    	    =>         "P2-713A1^SRT^Modified Naughton protocol",
    "P2-713A0^SRT^Naughton protocol"		    	    =>         "P2-713A0^SRT^Naughton protocol",
    "P2-7131F^SRT^Pepper protocol"		    	    =>         "P2-7131F^SRT^Pepper protocol",
    "P2-7131E^SRT^Ramp protocol"		    	    =>         "P2-7131E^SRT^Ramp protocol",
    "P2-31102^SRT^Bicycle Ergometer Stress Test protocol" =>         "P2-31102^SRT^Bicycle Ergometer Stress Test protocol",
    "PHARMSTRESS^99IHE^Pharmacologic Stress protocol"     =>         "PHARMSTRESS^99IHE^Pharmacologic Stress protocol",
    "PERSANTINE^99IHE^Persantine Stress protocol"	    =>         "PERSANTINE^99IHE^Persantine Stress protocol",
    "ADENOSINE^99IHE^Adenosine Stress protocol"	    =>         "ADENOSINE^99IHE^Adenosine Stress protocol",
    "DOBUTAMINE^99IHE^Dobutamine Stress protocol"	    =>         "DOBUTAMINE^99IHE^Dobutamine Stress protocol",
  );
  
   my @attributes = (
	"", 0, "0020 000d", "EQUAL", "Study Instance UID",
	"", 0, "0010 0020", "EQUAL", "Patient ID",
	"", 0, "0008 0016", "EQUAL", "SOP Class UID",
	"", 0, "0040 0254", "NONZEROLENGTH", "PPS Description",
	"", 0, "0018 1030", "NONZEROLENGTH", "Protocol Name",
   );
   my @existence = (
	"0040 0260" , 0, "", "SEQEXIST", "Performed Protocol Code Seq",
   );
   
   my $errorCount = processValueList($logLevel, $refObj, $testObj, @attributes);
   #$errorCount += processConstantList($logLevel, @constant);
   $errorCount += processExistenceList($logLevel, "", $testObj, @existence);
   
   ($status, my %test_0040_0260_hash) = getMultipleItemsFromSequence($logLevel, $testObj, "0040 0260", "0008 0100","0008 0102","0008 0104");
   my $size = scalar keys %test_0040_0260_hash;
   if ($size < 1){
      #$errorCount++;
      print main::LOG "ERR: No Performed Protocol Code Seq found in Test CStored Object\n";
   }else{
      my $retValue = hashContains($logLevel, \%test_0040_0260_hash,\%ECG_STRESS_PROTOCOL_CODES);
      if($retValue == 0){
         $errorCount++;
         print main::LOG "ERR: The Performed Protocol Code Seq in Test CStored Object does not contain the code sequences defined in Card TF-2 Table 4.2-12\n";
      }else{
         print main::LOG "INFO: The Performed Protocol Code Seq in Test CStored Object contains the code sequences defined in Card TF-2 Table 4.2-12\n";     
      }
      printCodeSequenceInHash(%test_0040_0260_hash) if($logLevel >= 3);
      #displayHash("", %ECG_STRESS_PROTOCOL_CODES);
   }
   
   $errorCount += validateAcquisitionSequence($logLevel, $refObj, $testObj);
   return $errorCount;
}

sub validateAcquisitionSequence {
  my ($logLevel, $refObj, $testObj) = @_;
  #my %hash;
  
  #my %CONCEPT_NAME_SEQ = {
  #  "109054^DCM^Patient State" => "109054^DCM^Patient State",
  #};
  
  my %REF_0040_A168_SEQ = (
    "F-01604^SRT^Resting State" => "F-01604^SRT^Resting State",
    "F-01602^SRT^Baseline State" => "F-01602^SRT^Baseline State",
    "F-01606^SRT^Exercise State" => "F-01606^SRT^Exercise State",
    "F-01608^SRT^Post-exercise State" => "F-01608^SRT^Post-exercise State",
  );
  
      
  my $idx = 1;
  my $done = 0;
  my $groupTag = "0040 0555";
  my $valuTypeTag = "0040 A040";
  my $hasCode = 0;
  my $hasNumeric = 0;
  my $errorCount = 0;
  
  while (! $done) {
    my ($s1, $valueType) = mesa_get::getDICOMValue($logLevel, $testObj, $groupTag, $valuTypeTag, $idx);

    if ($s1 != 0 ) {
      print main::LOG "ERR: Error occured when retrieving $idx item from $testObj with group <$groupTag> and tag <$valuTypeTag>\n";
      die "Error occured when retrieving $idx item from $testObj with group <$groupTag> and tag <$valuTypeTag>\n";
    }
    
    if ($valueType eq "") {
      $done = 1;
      my $i = $idx - 1;
      print main::LOG "INFO: There are total of $i items found in Acquisition Context Sequence.\n" if($logLevel >= 3);
    } elsif ($valueType eq "CODE") {
      $hasCode = 1;
      $test_0040_0555_code = dcmDumpElement($logLevel, "0040 0555", $testObj, "$main::MESA_STORAGE/tmp/test_0040_0555_code.dcm", $idx);
      my @exist_code = (
         "0040 A043" , 0, "", "SEQEXIST", "Concept Name Code Seq",
  	 "0040 A168" , 0, "", "SEQEXIST", "Concept Code Seq",
      );
      $errorCount += processExistenceList($logLevel, "", $test_0040_0555_code, @exist_code);
      
      my @constants_code = (
        "EQUAL", "0040 A043", 0 , "0008 0100", "$test_0040_0555_code",  "109054", "Code Value",
	"EQUAL", "0040 A043", 0 , "0008 0102", "$test_0040_0555_code",  "DCM", "Code Scheme Designator",
	"EQUAL", "0040 A043", 0 , "0008 0104", "$test_0040_0555_code",  "Patient State", "Code Meaning",
      );
      
      $errorCount = processConstantList($logLevel, @constants_code);
      
      ($status, my %test_0040_A168_hash) = getMultipleItemsFromSequence($logLevel, $test_0040_0555_code, "0040 A168", "0008 0100","0008 0102","0008 0104");
      my $retValue = hashContains($logLevel, \%test_0040_A168_hash,\%REF_0040_A168_SEQ);
      if($retValue != 1){
        $errorCount++;
     	print main::LOG "ERR: The Concept Code Seq of Value Type CODE in the C-Stored Object does not match the defined values:\n";
      }else{
        print main::LOG "CTX: The Concept Code Seq of Value Type CODE in the C-Stored Object matches the defined values.\n" if($logLevel >= 3);
      }
      printCodeSequenceInHash(%test_0040_A168_hash) if($logLevel >= 3);    
   } elsif ($valueType eq "NUMERIC") {
       $hasNumeric = 1;
       $test_0040_0555_num = dcmDumpElement($logLevel, "0040 0555", $testObj, "$main::MESA_STORAGE/tmp/test_0040_0555_num.dcm", $idx);
       #not able to know the $idx is the same in ref and test objects.
       #$ref_0040_0555_num = dcmDumpElement($logLevel, "0040 0555", $refObj, "$main::MESA_STORAGE/tmp/$ref_0040_0555_num.dcm", $idx);
       my @exist_num = (
   	"0040 A043" , 0, "", "SEQEXIST", "Concept Name Code Seq",
	"" , 0, "0040 A30A", "EXIST", "Numeric Value",
	"0040 08EA" , 0, "", "SEQEXIST", "Measurement Units Code Seq",
       );
       $errorCount += processExistenceList($logLevel, "", $test_0040_0555_num, @exist_num);
       
       my @constants_num = (
        "EQUAL", "0040 A043", 0 , "0008 0100", "$test_0040_0555_num",  "109055", "Code Value",
	"EQUAL", "0040 A043", 0 , "0008 0102", "$test_0040_0555_num",  "DCM", "Code Scheme Designator",
	"EQUAL", "0040 A043", 0 , "0008 0104", "$test_0040_0555_num",  "Protocol Stage", "Code Meaning",
	"EQUAL", "0040 08EA", 0 , "0008 0100", "$test_0040_0555_num",  "{stage}", "Code Value",
	"EQUAL", "0040 08EA", 0 , "0008 0102", "$test_0040_0555_num",  "UCUM", "Code Scheme Designator",
	"EQUAL", "0040 08EA", 0 , "0008 0104", "$test_0040_0555_num",  "Stage", "Code Meaning",
      );
      
      $errorCount += processConstantList($logLevel, @constants_num);
    }
    $idx++;
  }#end while
  
  if ($hasCode != 1){
     $errorCount++;
     print main::LOG "ERR: Acquisition Context sequence of CODE value type does not exist.\n";
  }else{
     print main::LOG "CTX: Acquisition Context sequence of CODE value type found.\n" if($logLevel >= 3);
  }
  
  if ($hasNumeric != 1){
     $errorCount++;
     print main::LOG "ERR: Acquisition Context sequence of NUMERIC value type does not exist.\n";
  }else{
     print main::LOG "CTX: Acquisition Context sequence of NUMERIC value type found.\n" if($logLevel >= 3);
  }
   #displayHash("retrieved from $testObj",%hash) if($logLevel >= 3);
  #return (0,%hash);
  return $errorCount;
}

sub printCodeSequenceInHash{
   my(%hash) = @_;
   my @keys = sort (keys(%hash));
   foreach (@keys){
     my @tokens = split /\^/, $_;
     print main::LOG "  Code Value: $tokens[0]\n";
     print main::LOG "  Code Scheme Designator: $tokens[1]\n";
     print main::LOG "  Code Meaning: $tokens[2]\n";     
   }
}

sub eval_mammo_presentation_image {
  my ($logLevel, $testObject) = @_;

  print main::LOG "\nCTX: mesa_dicom_eval::eval_mammo_presentation_image $testObject\n" if ($logLevel >= 3);
  my $errorCount = 0;
  my @existence_mammo_pres_image = (
	"" , 0, "0010 0010", "EXIST", "Patient Name",
	"" , 0, "0010 0020", "EXIST", "Patient ID",
	"" , 0, "0010 1010", "EXIST", "Patient's Age",
	"" , 0, "0010 0030", "EXIST", "Birth Date",
	"" , 0, "0008 0022", "EXIST", "Acq Date",
	"" , 0, "0008 0032", "EXIST", "Acq Time",
	"" , 0, "0008 1070", "EXIST", "Operator's Name",
	"" , 0, "0008 0070", "EXIST", "Manufacturer",
	"" , 0, "0008 0080", "EXIST", "Institution Name",
	"" , 0, "0008 0081", "EXIST", "Institution Address",
	"" , 0, "0008 1090", "EXIST", "Manufacturer Model Name",
	"" , 0, "0018 1000", "EXIST", "Device Serial Number",
	"" , 0, "0018 700a", "EXIST", "Detector ID",
	"" , 0, "0008 1010", "EXIST", "Station Name",
	"" , 0, "0018 1020", "EXIST", "Software Version",
	"0008 2112" , 0, "", "SEQEXIST", "Source Image Seq",
	"0008 2112" , 0, "0008 1150", "EXIST", "Ref SOP Class UID",
	"0008 2112" , 0, "0008 1155", "EXIST", "Ref SOP Inst. UID",
	"0008 2112" , 0, "0028 135A", "EXIST", "Spatial Locations Preserved",
	"" , 0, "0018 0060", "EXIST", "KVP",
	"" , 0, "0018 1152", "EXIST", "Exposure",
	"" , 0, "0018 1150", "EXIST", "Exposure Time",
	"" , 0, "0018 7050", "EXIST", "Filter Material",
	"" , 0, "0018 1191", "EXIST", "Anode Target",
	"" , 0, "0018 11a2", "EXIST", "Compression Force",
	"" , 0, "0018 11a0", "EXIST", "Body Part",
	"" , 0, "0018 1510", "EXIST", "Positioner Primary Angle",
	"" , 0, "0018 1405", "EXIST", "Relative X-ray Exposure",
	"" , 0, "0040 8302", "EXIST", "Entrance Dose in mGy",
	"" , 0, "0040 0316", "EXIST", "Organ Dose",
	"" , 0, "0028 0301", "EXIST", "Burned In Annotation",
	"" , 0, "0028 0120", "EXIST", "Pixel Padding Value",
	"" , 0, "0028 1300", "EXIST", "Implant Present",
	"" , 0, "0018 1114", "EXIST", "Estimated Radiographic Magnification Factor",
   );

   my @constants_mammo_pres_image = (
	"EQUAL", "", 0 , "0028 0301", "$testObject",  "NO", "Burned In Annotation",
        "EQUAL", "0008 2112", 0 , "0008 1150", "$testObject",  "1.2.840.10008.5.1.4.1.1.1.2.1", "Ref SOP Class UID",
   );

   my @constants_mammo_pres_image_digitizer = (
        "EQUAL", "", 0 , "0028 0301", "$testObject",  "YES", "Burned In Annotation",
        "EQUAL", "0008 2112", 0 , "0008 1150", "$testObject",  "1.2.840.10008.5.1.4.1.1.1.2.1", "Ref SOP Class UID",
   );
  if ($digitizer) {
    $errorCount += processConstantList($logLevel, @constants_mammo_pres_image_digitizer);
  } else {
    $errorCount += processConstantList($logLevel, @constants_mammo_pres_image);
  }

  $errorCount += processExistenceList($logLevel, "", "$testObject", @existence_mammo_pres_image);

  return $errorCount;
}

sub eval_mammo_processing_image {
  my ($logLevel, $testObject, $digitizer) = @_;

  print main::LOG "\nCTX: mesa_dicom_eval::eval_mammo_processing_image $testObject\n" if ($logLevel >= 3);
  my $errorCount = 0;
  my @existence_mammo_processing_image = (
	"" , 0, "0010 0010", "EXIST", "Patient Name",
	"" , 0, "0010 0020", "EXIST", "Patient ID",
	"" , 0, "0010 1010", "EXIST", "Patient's Age",
	"" , 0, "0010 0030", "EXIST", "Birth Date",
	"" , 0, "0008 0022", "EXIST", "Acq Date",
	"" , 0, "0008 0032", "EXIST", "Acq Time",
	"" , 0, "0008 1070", "EXIST", "Operator's Name",
	"" , 0, "0008 0070", "EXIST", "Manufacturer",
	"" , 0, "0008 0080", "EXIST", "Institution Name",
	"" , 0, "0008 0081", "EXIST", "Institution Address",
	"" , 0, "0008 1090", "EXIST", "Manufacturer Model Name",
	"" , 0, "0018 1000", "EXIST", "Device Serial Number",
	"" , 0, "0018 700a", "EXIST", "Detector ID",
	"" , 0, "0008 1010", "EXIST", "Station Name",
	"" , 0, "0018 1020", "EXIST", "Software Version",
	"" , 0, "0018 0060", "EXIST", "KVP",
	"" , 0, "0018 1152", "EXIST", "Exposure",
	"" , 0, "0018 1150", "EXIST", "Exposure Time",
	"" , 0, "0018 7050", "EXIST", "Filter Material",
	"" , 0, "0018 1191", "EXIST", "Anode Target",
	"" , 0, "0018 11a2", "EXIST", "Compression Force",
	"" , 0, "0018 11a0", "EXIST", "Body Part",
	"" , 0, "0018 1510", "EXIST", "Positioner Primary Angle",
	"" , 0, "0018 1405", "EXIST", "Relative X-ray Exposure",
	"" , 0, "0040 8302", "EXIST", "Entrance Dose in mGy",
	"" , 0, "0040 0316", "EXIST", "Organ Dose",
	"" , 0, "0028 0301", "EXIST", "Burned In Annotation",
#	"" , 0, "0028 0120", "EXIST", "Pixel Padding Value",
	"" , 0, "0028 1300", "EXIST", "Implant Present",
	"" , 0, "0018 1114", "EXIST", "Estimated Radiographic Magnification Factor",
   );

   my @constants_mammo_processing_image = (
	"EQUAL", "", 0 , "0028 0301", "$testObject",  "NO", "Burned In Annotation",
   );

  $errorCount += processExistenceList($logLevel, "", "$testObject", @existence_mammo_processing_image);
  $errorCount += processConstantList($logLevel, @constants_mammo_processing_image);

  return $errorCount;
}

sub eval_mammo_partialview_image {
  my ($logLevel, $testObject) = @_;

  print main::LOG "\nCTX: mesa_dicom_eval::eval_mammo_partialview_image $testObject\n" if ($logLevel >= 3);
  my $errorCount = 0;
  my @existence_mammo_partialview_image = (
	"" , 0, "0010 0010", "EXIST", "Patient Name",
	"" , 0, "0010 0020", "EXIST", "Patient ID",
	"" , 0, "0010 1010", "EXIST", "Patient's Age",
	"" , 0, "0010 0030", "EXIST", "Birth Date",
	"" , 0, "0008 0022", "EXIST", "Acq Date",
	"" , 0, "0008 0032", "EXIST", "Acq Time",
	"" , 0, "0008 1070", "EXIST", "Operator's Name",
	"" , 0, "0008 0070", "EXIST", "Manufacturer",
	"" , 0, "0008 0080", "EXIST", "Institution Name",
	"" , 0, "0008 0081", "EXIST", "Institution Address",
	"" , 0, "0008 1010", "EXIST", "Station Name",
	"" , 0, "0008 1090", "EXIST", "Manufacturer Model Name",
	"" , 0, "0018 700a", "EXIST", "Detector ID",
	"" , 0, "0018 1020", "EXIST", "Software Version",
	"" , 0, "0018 0060", "EXIST", "KVP",
	"" , 0, "0018 1000", "EXIST", "Device Serial Number",
	"" , 0, "0018 1152", "EXIST", "Exposure",
	"" , 0, "0018 1150", "EXIST", "Exposure Time",
	"" , 0, "0018 7050", "EXIST", "Filter Material",
	"" , 0, "0018 1191", "EXIST", "Anode Target",
	"" , 0, "0018 11a2", "EXIST", "Compression Force",
	"" , 0, "0018 11a0", "EXIST", "Body Part",
	"" , 0, "0018 1510", "EXIST", "Positioner Primary Angle",
	"" , 0, "0018 1405", "EXIST", "Relative X-ray Exposure",
	"" , 0, "0040 8302", "EXIST", "Entrance Dose in mGy",
	"" , 0, "0040 0316", "EXIST", "Organ Dose",
	"" , 0, "0028 0301", "EXIST", "Burned In Annotation",
	"" , 0, "0028 0120", "EXIST", "Pixel Padding Value",
	"" , 0, "0028 1300", "EXIST", "Implant Present",
	"" , 0, "0018 1114", "EXIST", "Estimated Radiographic Magnification Factor",
	"0028 1352" , 0, "", "SEQEXIST", "Partial View Code Sequence",
	
   );

   my @constants_mammo_partialview_image = (
	"EQUAL", "", 0 , "0028 1350", "$testObject",  "YES", "Partial View",
     	"OR", "0028 1352", 0,  "0008 0100", "$testObject",  "R-404CC\\R-404CE\\R-42191\\R-4094A\\R-4094D\\G-A104\\G-A110", "Code Value",
        "EQUAL", "0028 1352", 0 , "0008 0102", "$testObject",  "SRT", "Coding Scheme Designator",
     	"OR", "0028 1352", 0,  "0008 0104", "$testObject",  "Anterior\\Posterior\\Superior\\Inferior\\Medial\\Lateral\\Central", "Code Value",
   );

  $errorCount += processExistenceList($logLevel, "", "$testObject", @existence_mammo_partialview_image);
  $errorCount += processConstantList($logLevel, @constants_mammo_partialview_image);

  return $errorCount;
}

1;
