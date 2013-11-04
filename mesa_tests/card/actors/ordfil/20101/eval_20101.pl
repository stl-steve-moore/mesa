#!/usr/local/bin/perl -w

use Env;

use lib "../../../rad/actors/ordfil/scripts";
require ordfil;

sub goodbye() {
  exit 1;
}


# Evaluate response to request for first SPS for Hemodynamic system.
sub x_20101_2x {
  print LOG "CTX: Order Filler 20101.2 \n";
  print LOG "CTX: Evaluating MWL response for procedure CATH.001/XX-20011 \n";

  $p1MWLFile =     ordfil::mwl_find_matching_procedure_code("20101/mwl_q1/test", "CATH.001");
  $p1MWLFileMESA = ordfil::mwl_find_matching_procedure_code("20101/mwl_q1/mesa", "CATH.001");

  if ($p1MWLFile eq "") {
    print LOG "ERR: Unable to locate MWL results for requested procedure CATH.001\n";
    print LOG "ERR:  You should examine the MWL results in 20101/mwl_q1 \n";
    $diff += 1;
 } elsif ($p1MWLFileMESA eq "") {
    print LOG "ERR: MESA MWL does not include requested procedure CATH.001\n";
    print LOG "ERR:  This is an error in the test configuration/run \n";
    print LOG "ERR:  You should examine the MWL results in 20101/mwl_q1/mesa \n";
    $diff += 1;
  } else {
    $diff += mesa::evaluate_one_mwl_resp(
 		$logLevel,
 		"20101/mwl_q1/test/$p1MWLFile",
 		"20101/mwl_q1/mesa/$p1MWLFileMESA");
  }
 
  print LOG "\n";
}

# Evaluate response to request for SPS for first SPS
sub x_20101_2 {
  print LOG "CTX: Order Filler 20101.2 \n";
  print LOG "CTX: Evaluating MWL response for SPS for HD\n";

  @p1MWLFilesTEST =  ordfil::mwl_search_by_procedure_code_only($logLevel, "20101/mwl_q1/test", "CATH.001");
  @p1MWLFilesMESA = ordfil::mwl_search_by_procedure_code_only($logLevel, "20101/mwl_q1/mesa", "CATH.001");

  if (scalar(@p1MWLFilesTEST) == 0) {
    print LOG "ERR: Unable to locate MWL results for requested procedure CATH.001 \n";
    print LOG "ERR:  You should examine the MWL results in 20101/mwl_q1 \n";
    $diff += 1;
    return $diff;
  }
  if (scalar(@p1MWLFilesTEST) != 1) {
    print LOG "ERR: More than one SPS found in MWL for requested procedure CATH.001 \n";
    print LOG "ERR:  You should examine the MWL results in 20101/mwl_q2 \n";
    $diff += 1;
    return $diff;
  }
  if (scalar(@p1MWLFilesMESA) != 1) {
    my $countMESA = scalar(@p1MWLFilesMESA);
    print LOG "ERR: MESA MWL contains $countMESA SPS for CATH.001\n";
    print LOG "ERR:  Expected value is 1.\n";
    print LOG "ERR:  This is an error in the test configuration/run \n";
    print LOG "ERR:  You should examine the MWL results in 20101/mwl_q2/mesa \n";
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

# Evaluate response to request for SPS for IVUS system.
sub x_20101_4 {
  print LOG "CTX: Order Filler 20101.4 \n";
  print LOG "CTX: Evaluating MWL response for SPS for IVUS - triggered by HD MPPS\n";

  @p1MWLFilesTEST =  ordfil::mwl_search_by_procedure_code_aetitle($logLevel, "20101/mwl_q2/test", "CATH.001", "LAB7_IVUS");
  @p1MWLFilesMESA = ordfil::mwl_search_by_procedure_code_aetitle($logLevel, "20101/mwl_q2/mesa", "CATH.001", "LAB7_IVUS");

  if (scalar(@p1MWLFilesTEST) == 0) {
    print LOG "ERR: Unable to locate MWL results for requested procedure CATH.001 and AE Title LAB7_IVUS\n";
    print LOG "ERR:  You should examine the MWL results in 20101/mwl_q2 \n";
    $diff += 1;
    return $diff;
  }
  if (scalar(@p1MWLFilesTEST) != 1) {
    print LOG "ERR: More than one SPS found in MWL for requested procedure CATH.001 and AE Title LAB7_IVUS\n";
    print LOG "ERR:  You should examine the MWL results in 20101/mwl_q2 \n";
    $diff += 1;
    return $diff;
  }
  if (scalar(@p1MWLFilesMESA) != 1) {
    my $countMESA = scalar(@p1MWLFilesMESA);
    print LOG "ERR: MESA MWL contains $countMESA SPS for CATH.001/LAB7_IVUS\n";
    print LOG "ERR:  Expected value is 1.\n";
    print LOG "ERR:  This is an error in the test configuration/run \n";
    print LOG "ERR:  You should examine the MWL results in 20101/mwl_q2/mesa \n";
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

# Evaluate response to request for SPS for XA system.
sub x_20101_6 {
  print LOG "CTX: Order Filler 20101.6 \n";
  print LOG "CTX: Evaluating MWL response for SPS for XA - triggered by HD MPPS\n";

  @p1MWLFilesTEST =  ordfil::mwl_search_by_procedure_code_aetitle($logLevel, "20101/mwl_q2/test", "CATH.001", "LAB7_XA");
  @p1MWLFilesMESA = ordfil::mwl_search_by_procedure_code_aetitle($logLevel, "20101/mwl_q2/mesa", "CATH.001", "LAB7_XA");

  if (scalar(@p1MWLFilesTEST) == 0) {
    print LOG "ERR: Unable to locate MWL results for requested procedure CATH.001 and AE Title LAB7_XA\n";
    print LOG "ERR:  You should examine the MWL results in 20101/mwl_q2 \n";
    $diff += 1;
    return $diff;
  }
  if (scalar(@p1MWLFilesTEST) != 1) {
    print LOG "ERR: More than one SPS found in MWL for requested procedure CATH.001 and AE Title LAB7_XA\n";
    print LOG "ERR:  You should examine the MWL results in 20101/mwl_q2 \n";
    $diff += 1;
    return $diff;
  }
  if (scalar(@p1MWLFilesMESA) != 1) {
    my $countMESA = scalar(@p1MWLFilesMESA);
    print LOG "ERR: MESA MWL contains $countMESA SPS for CATH.001/LAB7_XA\n";
    print LOG "ERR:  Expected value is 1.\n";
    print LOG "ERR:  This is an error in the test configuration/run \n";
    print LOG "ERR:  You should examine the MWL results in 20101/mwl_q2/mesa \n";
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
sub x_20101_8 {
  print LOG "CTX: Order Filler 20101.8 \n";
  print LOG "CTX: Evaluating MWL responses as a group after MPPS trigger\n";

  @p1MWLFilesTEST =  ordfil::mwl_search_by_procedure_code_only($logLevel, "20101/mwl_q2/test", "CATH.001");

  if (scalar(@p1MWLFilesTEST) == 0) {
    print LOG "ERR: Unable to locate MWL results for requested procedure CATH.001 \n";
    print LOG "ERR:  You should examine the MWL results in 20101/mwl_q2 \n";
    $diff += 1;
    return $diff;
  }
  if (scalar(@p1MWLFilesTEST) != 3) {
    my $countSPS = scalar(@p1MWLFilesTEST);
    print LOG "ERR: We should find 3 SPS after the MPPS trigger; we only found $countSPS\n";
    print LOG "ERR:  You should examine the MWL results in 20101/mwl_q2 \n";
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
#$titleMPPSMgr = $ARGV[1];
open LOG, ">20101/grade_20101.txt" or die "?!";
$diff = 0;

x_20101_2;
x_20101_4;
x_20101_6;
x_20101_8;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 20101/grade_20101.txt \n";

exit $diff;
