#Teri: note to self - need to add eval of second MPPS
#!/usr/local/bin/perl -w

use Env;

use lib "../../../rad/actors/ordfil/scripts";
require ordfil;

sub goodbye() {
  exit 1;
}
# Evaluate Patient demographics
sub x_20106_2 {
  print LOG "CTX: Order Filler 20106.2\n";
  print LOG "CTX: Evaluating Patient Name\n";

  $x = mesa::compareAttribute($logLevel, "0010 0010", "20106/mwl_q1/test/msg1_result.dcm", "20106/mwl_q1/mesa/msg1_result.dcm");
  if ($x != 0) {
	$diff += 1;
  }
  print LOG "\n";
  return $diff;
}

# Evaluate response to request for SPS for IVUS system.
sub x_20106_4 {
  print LOG "CTX: Order Filler 20106.4 \n";
  print LOG "CTX: Evaluating MWL response for SPS for IVUS - triggered by HD MPPS\n";

  @p1MWLFilesTEST =  ordfil::mwl_search_by_procedure_code_aetitle($logLevel, "20106/mwl_q1/test", "CATH.001", "LAB7_IVUS");
  @p1MWLFilesMESA = ordfil::mwl_search_by_procedure_code_aetitle($logLevel, "20106/mwl_q1/mesa", "CATH.001", "LAB7_IVUS");

  if (scalar(@p1MWLFilesTEST) == 0) {
    print LOG "ERR: Unable to locate MWL results for requested procedure CATH.001 and AE Title LAB7_IVUS\n";
    print LOG "ERR:  You should examine the MWL results in 20106/mwl_q1/test \n";
    $diff += 1;
    return $diff;
  }
  if (scalar(@p1MWLFilesTEST) != 1) {
    print LOG "ERR: More than one SPS found in MWL for requested procedure CATH.001 and AE Title LAB7_IVUS\n";
    print LOG "ERR:  You should examine the MWL results in 20106/mwl_q1/test \n";
    $diff += 1;
    return $diff;
  }
  if (scalar(@p1MWLFilesMESA) != 1) {
    my $countMESA = scalar(@p1MWLFilesMESA);
    print LOG "ERR: MESA MWL contains $countMESA SPS for CATH.001/LAB7_IVUS\n";
    print LOG "ERR:  Expected value is 1.\n";
    print LOG "ERR:  This is an error in the test configuration/run \n";
    print LOG "ERR:  You should examine the MWL results in 20106/mwl_q1/mesa \n";
    $diff += 1;
    return $diff;
  }
  $diff = 0;
  $diff += mesa::evaluate_one_mwl_resp_card_mpps_trigger_no_order (
 		$logLevel,
 		"$p1MWLFilesTEST[0]",
 		"$p1MWLFilesMESA[0]",
		"$MESA_STORAGE/modality/T20106/mpps.status");
 
  print LOG "\n";
  return $diff;
}

sub x_20106_6 {
 print LOG "CTX: Order Filler 20106.6 \n";
 print LOG "CTX Examing PPS messages for P2/X2/X2 forwarded to Image Mgr \n";

 $diff += mesa::evaluate_mpps_mpps_mgr(
        $logLevel,
        "$MESA_STORAGE/modality/T20106",
        "$MESA_STORAGE/imgmgr/mpps/$titleMPPSMgr",
                "1"
                );
 print LOG "\n";
}

sub x_20106_8 {
  print LOG "CTX: Order Filler 20106.8 \n";
  print LOG "CTX:  Evaluating HL7 Scheduling Message to Image Manager\n";

  $diff += mesa::evaluate_ORM_scheduling_post_procedure (
                $logLevel,
                "../../msgs/sched/20106/20106.108.o01.hl7",
                "$MESA_STORAGE/imgmgr/hl7/1001.hl7",
                "$MESA_STORAGE/modality/T20106");
}


# Evaluate response to request for SPS for XA system.
sub x_20102_6 {
  print LOG "CTX: Order Filler 20102.6 \n";
  print LOG "CTX: Evaluating MWL response for SPS for XA - triggered by HD MPPS\n";

  @p1MWLFilesTEST =  ordfil::mwl_search_by_procedure_code_aetitle($logLevel, "20102/mwl_q2/test", "CATH.001", "LAB7_XA");
  @p1MWLFilesMESA = ordfil::mwl_search_by_procedure_code_aetitle($logLevel, "20102/mwl_q2/mesa", "CATH.001", "LAB7_XA");

  if (scalar(@p1MWLFilesTEST) == 0) {
    print LOG "ERR: Unable to locate MWL results for requested procedure CATH.001 and AE Title LAB7_XA\n";
    print LOG "ERR:  You should examine the MWL results in 20102/mwl_q2 \n";
    $diff += 1;
    return $diff;
  }
  if (scalar(@p1MWLFilesTEST) != 1) {
    print LOG "ERR: More than one SPS found in MWL for requested procedure CATH.001 and AE Title LAB7_XA\n";
    print LOG "ERR:  You should examine the MWL results in 20102/mwl_q2 \n";
    $diff += 1;
    return $diff;
  }
  if (scalar(@p1MWLFilesMESA) != 1) {
    my $countMESA = scalar(@p1MWLFilesMESA);
    print LOG "ERR: MESA MWL contains $countMESA SPS for CATH.001/LAB7_XA\n";
    print LOG "ERR:  Expected value is 1.\n";
    print LOG "ERR:  This is an error in the test configuration/run \n";
    print LOG "ERR:  You should examine the MWL results in 20102/mwl_q2/mesa \n";
    $diff += 1;
    return $diff;
  }
  $diff += mesa::evaluate_one_mwl_resp(
 		$logLevel,
 		"$p1MWLFilesTEST[0]",
 		"$p1MWLFilesMESA[0]");
 
  print LOG "\n";
  return $diff;
}

# Look for things that should be common among MWL responses
sub x_20102_8 {
  print LOG "CTX: Order Filler 20102.8 \n";
  print LOG "CTX: Evaluating MWL responses as a group after MPPS trigger\n";

  @p1MWLFilesTEST =  ordfil::mwl_search_by_procedure_code_only($logLevel, "20102/mwl_q2/test", "CATH.001");

  if (scalar(@p1MWLFilesTEST) == 0) {
    print LOG "ERR: Unable to locate MWL results for requested procedure CATH.001 \n";
    print LOG "ERR:  You should examine the MWL results in 20102/mwl_q2 \n";
    $diff += 1;
    return $diff;
  }
  if (scalar(@p1MWLFilesTEST) != 3) {
    my $countSPS = scalar(@p1MWLFilesTEST);
    print LOG "ERR: We should find 3 SPS after the MPPS trigger; we only found $countSPS\n";
    print LOG "ERR:  You should examine the MWL results in 20102/mwl_q2 \n";
    $diff += 1;
    return $diff;
  }
  my $studyUID1 = mesa::getDICOMAttribute($logLevel, $p1MWLFilesTEST[0], "0020 000D");
  my $studyUID2 = mesa::getDICOMAttribute($logLevel, $p1MWLFilesTEST[1], "0020 000D");
  my $studyUID3 = mesa::getDICOMAttribute($logLevel, $p1MWLFilesTEST[2], "0020 000D");

  print LOG "CTX Study Instance UIDs from MWL\n" if ($logLevel >= 3);
  print LOG "CTX   $studyUID1\n" if ($logLevel >= 3);
  print LOG "CTX   $studyUID2\n" if ($logLevel >= 3);
  print LOG "CTX   $studyUID3\n" if ($logLevel >= 3);

  if ($studyUID1 ne $studyUID2) {
    print LOG "ERR Study UIDs in MWL are not the same\n";
    print LOG "ERR  $studyUID1\n";
    print LOG "ERR  $studyUID2\n";
    $diff += 1;
    return $diff;
  }

  if ($studyUID1 ne $studyUID3) {
    print LOG "ERR Study UIDs in MWL are not the same\n";
    print LOG "ERR  $studyUID1\n";
    print LOG "ERR  $studyUID3\n";
    $diff += 1;
    return $diff;
  }
 
  print LOG "\n";
  return $diff;
}


### Main starts here

die "Usage: <log level: 1-4> <AE Title of your MPPS Mgr>" if (scalar(@ARGV) < 2);

$logLevel     = $ARGV[0];
$titleMPPSMgr = $ARGV[1];
open LOG, ">20106/grade_20106.txt" or die "?!";
$diff = 0;

x_20106_2;
x_20106_4;
x_20106_6;
x_20106_8;
#x_20102_6;
#x_20106_8;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 20106/grade_20106.txt \n";

exit $diff;
