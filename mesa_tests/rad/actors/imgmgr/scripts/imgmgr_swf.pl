#!/usr/local/bin/perl -w

# Runs the Image Manager scripts interactively

use Env;
use lib "scripts";
use lib "../../../common/scripts";
require imgmgr;
require imgmgr_workflow;
require imgmgr_transactions;
require mesa_common;

$SIG{INT} = \&goodbye;

sub testVarValues {
 return 0;
}

sub goodbye () {
  print "Exiting...\n";

  exit 1;
}

sub print_config_params {
  foreach $varname (keys %varnames) {
    print "Variable $varname = $varnames{$varname} \n";
  }
}

sub transaction3_OF {
  my ($logLevel, $selfTest, $src, $dst, $event, $msg, $extraOrder) = @_;

  my $hl7Msg = "../../msgs/" . $msg;
  my $pid               = mesa::getField($hl7Msg, "PID", "3", "0", "Patient ID");
  my $patientName       = mesa::getField($hl7Msg, "PID", "5", "0", "Patient Name");
  my $placerOrderNumber = mesa::getField($hl7Msg, "ORC", "2", "0", "Placer Order Number");

  if ($dst ne "OF") {
    print "Function transaction3_OF called with a destination of $dst\n";
    print "This is a programming error; please log a bug report.\n";
    return 1;
  }

  if ($event ne "ORDER_O02") {
    print "Transaction 3 with a destination of OF has event $event\n";
    print "This script expects the event to be ORDER_O02. This must be an\n";
    print "error in the test sequence. Please log a bug report.\n";
    return 1;
  }

  print "\nIHE Transaction 3: $pid $patientName \n";
  print "We will ignore original order and use the extra order in a future transaction\n" if ($logLevel >= 3);
  return 0;
}

sub transaction3_OP {
  my ($logLevel, $selfTest, $src, $dst, $event, $msg, $extraOrder) = @_;
  my $hl7Msg = "../../msgs/" . $msg;
  my $pid               = mesa::getField($hl7Msg, "PID", "3", "0", "Patient ID");
  my $patientName       = mesa::getField($hl7Msg, "PID", "5", "0", "Patient Name");
  my $placerOrderNumber = mesa::getField($hl7Msg, "ORC", "2", "0", "Placer Order Number");

  print "\nIHE Transaction 3: $pid $patientName \n";
  print "MESA DSS/OF would be expected to send order to Order Placer.\n" if ($logLevel >= 3);
  print "Image Manager test can ignore this event\n";

  # Send a copy of the extra Order to MESA so we can schedule it
  if ($event eq "ORDER") {
    print "About to send Order back to MESA Order Filler for our scheduling\n";
    $x = mesa::send_hl7_log($logLevel, "../../msgs", $extraOrder, "localhost", $mesaOFPortHL7);
    mesa::xmit_error($msg) if ($x != 0);
  }
  return 0;
}

sub processTransaction3 {
  my ($logLevel, $selfTest, $src, $dst, $event, $msg, $extraOrder) = @_;
  my $rtn = 1;
  if ($dst eq "OF") {
    $rtn = transaction3_OF(@_);
  } elsif ($dst eq "OP") {
    $rtn = transaction3_OP(@_);
  } else {
    print "For transaction3, we do not recognize destination $dst\n";
    $rtn = 1;
  }
  return $rtn;
}


sub processTransaction4a {
  my ($logLevel, $selfTest, $src, $dst, $event, $msg, $outputDir, $inputDir, $SPSCode, $PPSCode) = @_;

  my $hl7Msg = "../../msgs/" . $msg;
  my $pid = mesa::getField($hl7Msg, "PID", "3", "1", "Patient ID");
  my $patientName = mesa::getField($hl7Msg, "PID", "5", "0", "Patient Name");
  my $procedureCode = mesa::getField($hl7Msg, "OBR", "4", "1", "Procedure Code");

  print "IHE Transaction 4a: $pid $patientName $procedureCode \n";

  mesa::local_scheduling_mr($logLevel);

  my $x = "perl scripts/produce_scheduled_images.pl MR MESA_MOD " .
	" $pid $procedureCode $outputDir MESA localhost $mesaOFPortDICOM " .
	" $SPSCode $PPSCode $inputDir ";
  print "$x \n";
  print `$x`;
  die "Could not schedule and produce data for this procedure \n" if $?;

  print "This is the scheduling prelude to transaction 4\n";
  print "All work here is internal to the MESA software \n";

  print "PID: $pid Name: $patientName Code: $procedureCode \n";
  my $z = mesa::update_scheduling_ORM($logLevel, $hl7Msg, "$MESA_STORAGE/modality/$outputDir");
  return 1 if ($z);

  return 0;
}

# This is for post scheduling. The images have been created.
# We need to update our scheduling message.

sub processTransaction4b {
  my ($logLevel, $selfTest, $src, $dst, $event, $msg, $outputDir, $inputDir, $SPSCode, $PPSCode)  = @_;

  print "This is the post scheduling operation for transaction 4\n";
  print "All work here is internal to the MESA software \n";

  my $hl7Msg = "../../msgs/" . $msg;
  my $pid = mesa::getField($hl7Msg, "PID", "3", "1", "Patient ID");
  my $patientName = mesa::getField($hl7Msg, "PID", "5", "0", "Patient Name");
  my $procedureCode = mesa::getField($hl7Msg, "OBR", "4", "1", "Procedure Code");
  my $modality = mesa::getField($hl7Msg, "OBR", "24", "1", "Service Sector ID");
  print "This is the post scheduling operation for transaction 4\n";
  print "All work here is internal to the MESA software \n";

  print "PID: $pid Name: $patientName Code: $procedureCode \n";

  my $status;
  my $modalityDir = "$MESA_STORAGE/modality/" . $outputDir;
  my $accessionNum = "ACC";
  my $requestedProcedureID;
  ($status, $requestedProcedureID) = mesa::getRequestedProcedureID($logLevel, "ordfil");
  return 1 if ($status != 0);

  my $scheduledProcedureStepID;
  ($status, $scheduledProcedureStepID) = mesa::getSPSID($logLevel, "ordfil");
  return 1 if ($status != 0);

  my $x = mesa::update_scheduling_ORM_post_procedure($logLevel, $hl7Msg, $modalityDir,
	$accessionNum, $requestedProcedureID, $scheduledProcedureStepID);
  print "Unable to update the scheduling message with post procedure data\n" if ($x != 0);

  return $x;
}

sub processTransaction4 {
  my ($logLevel, $selfTest, $src, $dst, $event, $msg, $modDirectory) = @_;

  my $hl7Msg = "../../msgs/" . $msg;
  my $pid = mesa::getField($hl7Msg, "PID", "3", "0", "Patient ID");
  my $patientName = mesa::getField($hl7Msg, "PID", "5", "0", "Patient Name");
  my $procedureCode = mesa::getField($hl7Msg, "OBR", "4", "0", "Procedure Code");
#  my $accessionNumber   = mesa::getField($hl7Msg, "ORC", "3", "1", "Filler Order Number");
#  mesa::setField($logLevel, $hl7Msg, "OBR", "18", "0", "Accession Number", $accessionNumber);

  #my $z = mesa::update_scheduling_ORM($logLevel, $hl7Msg, "$MESA_STORAGE/modality/$modDirectory");
  #return 1 if ($z);

  print "IHE Transaction 4: $pid $patientName $procedureCode \n";
  print "MESA will send ORM message ($msg) for event $event to your $dst\n";
  print "Hit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  goodbye if ($x =~ /^q/);

  print "ll = $logLevel, msg = $msg, host = $imHL7Host, port = $imHL7Port\n";
  $x = mesa::send_hl7_log($logLevel, "../../msgs", $msg, $imHL7Host, $imHL7Port);
  mesa::xmit_error($msg) if ($x != 0);

}

sub processTransaction5 {
  print "Transaction 5 is not necessary to test the Image Manager \n";
  return 0;
}

sub processTransaction12xxx {
  my $src = shift(@_);
  my $dst = shift(@_);
  my $event = shift(@_);
  my $msg = shift(@_);

  print "IHE Transaction 12: \n";
  print "MESA will send HL7 message ($msg) for event $event to $dst\n";
  if ($dst eq "IM") {
    print "Hit <ENTER> when ready (q to quit) --> ";
    my $x = <STDIN>;
    goodbye if ($x =~ /^q/);
    $x = mesa::send_hl7("../../msgs", $msg, $imHL7Host, $imHL7Port);
    mesa::xmit_error($msg) if ($x != 0);
  } else {
    print " We will ignore message sent to $dst. It is not required for IM test\n";
  }
}

sub processTransaction13 {
  my ($src, $dst, $event, $msg, $origSchedule) = @_;

  my $hl7Msg = "../../msgs/" . $msg;
  $origSchedule = "../../msgs/$origSchedule";
  my $pid = mesa::getField($hl7Msg, "PID", "3", "0", "Patient ID");
  my $patientName = mesa::getField($hl7Msg, "PID", "5", "0", "Patient Name");
  my $procedureCode = mesa::getField($hl7Msg, "OBR", "4", "0", "Procedure Code");
  my $accessionNumber = mesa::getField($origSchedule, "OBR", "18", "0", "Accession Number");
  mesa::setField($logLevel, $hl7Msg, "OBR", "18", "0", "Accession Number", $accessionNumber);
  my $studyUIDField = mesa::getField($origSchedule, "ZDS", "1", "0", "Study Instance UID");
  mesa::setField($logLevel, $hl7Msg, "ZDS", "1", "0", "Study Instance UID", $studyUIDField);

  print "IHE Transaction 13: $pid $patientName $procedureCode \n";
  print "MESA will send ORM message ($msg) for event $event to your $dst\n";

  $x = mesa::send_hl7("../../msgs", $msg, $imHL7Host, $imHL7Port);
  mesa::xmit_error($msg) if ($x != 0);
}

sub processTransaction16 {
    my ($logLevel, $selfTest, $src, $dst, $event, $inputParam, $inDir, $outDir) = @_;
    print "IHE Transaction 16: \n";
    print "MESA will send CMOVE message for event $event to your $dst\n";
    print "Hit <ENTER> when ready (q to quit) --> ";
    my $x = <STDIN>;
    goodbye if ($x =~ /^q/);

    my $cfindResponse = $inDir . "/test/msg1_result.dcm";
    my ($errorCode, $studyInstanceUID) = mesa::getDICOMAttribute($logLevel, 
            $cfindResponse, "0020 000D");
    if ($errorCode) {
        print "Cannot find study instance UID in $cfindResponse\n";
        return 1;
    }

    print "Looking for SIUID = $studyInstanceUID\n";
    print "writing to $outDir/cmove.dcm\n";

    my @elements = split "\n", <<CMOVE; 
0020 000D, $studyInstanceUID
0008 0052, STUDY
CMOVE

    mesa::create_dcm("", $outDir, "cmove.dcm", @elements);

    my $cmoveString = "$main::MESA_TARGET/bin/cmove -a MESA -c $imCMoveAE " .
        "-f $outDir/cmove.dcm -x STUDY $imCMoveHost " . 
        "$imCMovePort $mesaWkstationAE";

    print "$cmoveString \n";
    print `$cmoveString`;
    if ($?) {
        print "Could not send C-Move request \n";
        return 1;
    }

    return 0;
}

sub processTransaction20 {
    my ($logLevel, $selfTest, $src, $dst, $event, $inputParam, $templateFile, $srFile, $outDir) = @_;
    print "IHE Transaction 20: \n";
    print "MESA will send MPPS message from $src for event ($event) to your ($dst)\n";
    print "Hit <ENTER> when ready (q to quit) --> ";
    my $x = <STDIN>;
    goodbye if ($x =~ /^q/);

    mesa::delete_directory($logLevel, $outDir);
    mesa::create_directory($logLevel, $outDir);

    my $modifiedSRFile = $srFile . ".mod";
    open TXTIN, "<$srFile" or die "Could not open text file for input: $srFile";
    open TXTOUT, ">$modifiedSRFile" or die "Could not open text file for output: $modifiedSRFile";
    while ($l = <TXTIN>) {
      print TXTOUT $l;
    }
    close TXTIN;

    my $cmdX = "$main::MESA_TARGET/bin/mesa_identifier mod1 series_uid";
    my $seriesUID = `$cmdX`;
    die "Could not obtain Series UID.  The following failed:\n\t$cmdX\n" if ($?);
    print TXTOUT "0020 000E $seriesUID\n";

    close TXTOUT;

    my $imageFile = "$MESA_STORAGE/modality/$inputParam/x1.dcm";
# create sr.dcm file from the text srFile.
    my $srFileDcm = "$outDir/sr.dcm";
    my $cmd = "$main::MESA_TARGET/bin/dcm_create_object -i $modifiedSRFile $srFileDcm";
    print $cmd . "\n" if $logLevel >= 3;
    print `$cmd`;
    if ($?) {
        print "Could not create dcm object $srFileDcm from $srFile:\n$cmd\n";
        return 1;
    }

    my $mppsFile = "$outDir/mpps.dcm";
    print "Image File: $imageFile\n" if $logLevel >= 3;

    my $verbose = 0; # = 1 for verbose
    mesa::createT20MPPS($imageFile, $srFileDcm, $templateFile, $mppsFile, $verbose);

# this mpps UID will be used for transactions 21 and 43 as well
    $main::mpps_uid = `$main::MESA_TARGET/bin/mesa_identifier mod1 pps_uid`;

    $cmd = "$main::MESA_TARGET/bin/ncreate -a $mesaWkstationAE -c $mppsAE" .
        " $mppsHost $mppsPort mpps $mppsFile $main::mpps_uid ";
    print "$cmd \n";
    print `$cmd`;
    if ($?) {
        print "Could not send MPPS N-Create to Image Manager\n";
        return 1;
    }

# now forward the MPPS on to the Order Filler
    $cmd = "$main::MESA_TARGET/bin/ncreate -a $imCStoreAE -c $mesaOFAE" .
        " $mesaOFHost $mesaOFPortDICOM mpps $mppsFile $main::mpps_uid ";
    print "$cmd \n";
    print `$cmd`;
    if ($?) {
        print "Could not send MPPS N-Create to Order Filler\n";
        return 1;
    }
    return 0;
}

sub processTransaction21 {
    my ($logLevel, $selfTest, $src, $dst, $event, $templateFile, $outDir) = @_;
    print "IHE Transaction 21: \n";
#    print "MESA will send MPPS message from dir ($inputDir) for event " .
#        "($event) to your ($dst)\n";
    print "Hit <ENTER> when ready (q to quit) --> ";
    my $x = <STDIN>;
    goodbye if ($x =~ /^q/);

    mesa::delete_directory($logLevel, $outDir);
    mesa::create_directory($logLevel, $outDir);

    my $mppsFile = "$outDir/mpps.dcm";

    mesa::createT21MPPS($templateFile, $mppsFile);

    my $cmd = "$main::MESA_TARGET/bin/nset -a $mesaWkstationAE -c $mppsAE " .
        " $mppsHost $mppsPort mpps $mppsFile $main::mpps_uid ";
    print "$cmd \n";
    print `$cmd`;
    if ($?) {
        print "Could not send MPPS N-Set to Image Manager \n";
        return 1;
    }

# now forward the MPPS on to the Order Filler
    $cmd = "$main::MESA_TARGET/bin/nset -a $imCStoreAE -c $mesaOFAE" .
        " $mesaOFHost $mesaOFPortDICOM mpps $mppsFile $main::mpps_uid ";
    print "$cmd \n";
    print `$cmd`;
    if ($?) {
        print "Could not send MPPS N-Set to Order Filler \n";
        return 1;
    }
    return 0;
}

sub processTransaction43 {
    my ($logLevel, $selfTest, $src, $dst, $event, $inputParam, $srFile, $outDir) = @_;
    print "IHE Transaction 43: \n";
    print "MESA will store evidence document $srFile \n";

    mesa::delete_directory($logLevel, $outDir);
    mesa::create_directory($logLevel, $outDir);

    my $srFileNew = "$outDir/srUID.dcm";
    my $imageFile = "$MESA_STORAGE/modality/$inputParam/x1.dcm";

    mesa::createT43EvDoc($srFile, $imageFile, $main::mpps_uid, $srFileNew);

# Now send the modified SR object
    my $cstore = "$main::MESA_TARGET/bin/cstore -a $mesaWkstationAE"
        . " -c $imCStoreAE $imCStoreHost $imCStorePort";

    print "$cstore $srFileNew\n";
    print `$cstore $srFileNew`;
    if ($?) {
      print "Could not send $srFileNew to Image Manager \n";
      return 1;
    }

# Send a copy of the Evidence document to the MESA Image Manager
    $cstore = "$main::MESA_TARGET/bin/cstore -a $mesaWkstationAE"
        . " -c $imCStoreAE localhost     $mesaImgMgrPortDICOM";

    print "$cstore $srFileNew\n";
    print `$cstore $srFileNew`;
    if ($?) {
      print "Could not send $srFileNew to Image Manager \n";
      return 1;
    }

# Create the NAction and NEvent objects we will use in T10.  We will store these
# in the $MESA_STORAGE tree where T10 will be able to find it.  In actuality, the
# action file will be used for both the naction and nevent calls. 
    my $NActionFile = "$MESA_STORAGE/modality/$inputParam/sc.xxx";
    my $NEventFile = "$MESA_STORAGE/modality/$inputParam/NEvent.dcm";
    mesa::createT10Objects($srFileNew, $NActionFile, $NEventFile);

    return 0;
}

sub processTransaction44 {
    my ($logLevel, $selfTest, $src, $dst, $event, $EDFile, $inDir, $outDir) = @_;
    print "IHE Transaction 44: \n";
    print "MESA will do an Evidence Document Query \n";
    print "Hit <ENTER> when ready (q to quit) --> ";
    my $x = <STDIN>;
    goodbye if ($x =~ /^q/);

    die "Not enough parameters passed to Transaction 14.  Be sure output directory " .
        "is defined" if not defined $outDir;

# clean out and create the output directory
    mesa::delete_directory(1, $outDir);
    mesa::create_directory(1, $outDir);

    ($x, $studyInstanceUID) = mesa::getDICOMAttribute($logLevel, $EDFile, "0020 000D");
    if ($x != 0) {
        print "Unable to get DICOM Study Instance UID from $EDFile $x\n";
        return 1;
    }

    $x = mesa::construct_cfind_query_study(
            $logLevel,
            "$inDir/cfind_study_uid_templ.txt",
            "$outDir/cfind_study_uid.txt",
            "$outDir/cfind_study_level.dcm",
            $studyInstanceUID) and return 1;

    $x = mesa::send_cfind_log(
            $logLevel,
            "$outDir/cfind_study_level.dcm",
            $imCFindAE, $imCFindHost, $imCFindPort,
            "$outDir/test") and return 1;

# Repeat the process for queries to MESA Image Manager
    $x = mesa::send_cfind_log(
            $logLevel,
            "$outDir/cfind_study_level.dcm",
            "MESA_ARCHIVE", "localhost", $mesaImgMgrPortDICOM,
            "$outDir/mesa") and return 1;

    return 0;
}

sub processTransaction45 {
# inDir is the output dir of T44
    my ($logLevel, $selfTest, $src, $dst, $event, $inDir, $outDir) = @_;
    print "IHE Transaction 45: \n";
    print "MESA will Retrieve an Evidence Document\n";
    print "Hit <ENTER> when ready (q to quit) --> ";
    my $x = <STDIN>;
    goodbye if ($x =~ /^q/);

    my $cfindResponse = $inDir . "/test/msg1_result.dcm";
    my ($errorCode, $studyInstanceUID) = mesa::getDICOMAttribute($logLevel, 
            $cfindResponse, "0020 000D");
    if ($errorCode) {
        print "Cannot find study instance UID in $cfindResponse\n";
        return 1;
    }

    print "Looking for SIUID = $studyInstanceUID\n";
    print "writing to $outDir/cmove.dcm\n";

    my @elements = split "\n", <<CMOVE; 
0020 000D, $studyInstanceUID
0008 0052, STUDY
CMOVE

    mesa::create_dcm("", $outDir, "cmove.dcm", @elements);

    my $cmoveString = "$main::MESA_TARGET/bin/cmove -a MESA -c $imCMoveAE " .
        "-f $outDir/cmove.dcm -x STUDY $imCMoveHost " . 
        "$imCMovePort $mesaWkstationAE";

    print "$cmoveString \n";
    print `$cmoveString`;
    if ($?) {
        print "Could not send C-Move request \n";
        return 1;
    }

    return 0;
}

sub processTransaction {
  my ($cmd, $logLevel) = @_;
  my @tokens = split /\s+/, $cmd;
  my $verb = $tokens[0];
  my $trans= $tokens[1];
  my $rtnValue = 0;

  if ($trans eq "1") {
    shift (@tokens); shift (@tokens);
    imgmgr::processTransaction1($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "RAD-8") {
    shift (@tokens); shift (@tokens);
    $rtnValue = imgmgr_transactions::processTransaction8($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "2") {
    shift (@tokens); shift (@tokens);
    imgmgr::processTransaction2($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "3") {
    shift (@tokens); shift (@tokens);
    $rtnValue = processTransaction3($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "4a") {
    shift (@tokens); shift (@tokens);
    $rtnValue = processTransaction4a($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "4b") {
    shift (@tokens); shift (@tokens);
    $rtnValue = processTransaction4b($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "4") {
    shift (@tokens); shift (@tokens);
    $rtnValue = processTransaction4($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "5") {
    shift (@tokens); shift (@tokens);
    processTransaction5(@tokens);
  } elsif ($trans eq "6") {
    shift (@tokens); shift (@tokens);
    imgmgr::processTransaction6($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "7") {
    shift (@tokens); shift (@tokens);
    imgmgr::processTransaction7($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "8") {
    shift (@tokens); shift (@tokens);
    $rtnValue = imgmgr::processTransaction8($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "10") {
    shift (@tokens); shift (@tokens);
    $rtnValue = imgmgr::processTransaction10($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "12") {
    shift (@tokens); shift (@tokens);
    imgmgr::processTransaction12($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "13") {
    shift (@tokens); shift (@tokens);
    processTransaction13(@tokens);
  } elsif ($trans eq "14") {
    shift (@tokens); shift (@tokens);
    $rtnValue = imgmgr::processTransaction14($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "16") {
    shift (@tokens); shift (@tokens);
    $rtnValue = processTransaction16($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "20") {
    shift (@tokens); shift (@tokens);
    $rtnValue = processTransaction20($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "21") {
    shift (@tokens); shift (@tokens);
    $rtnValue = processTransaction21($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "43") {
    shift (@tokens); shift (@tokens);
    $rtnValue = processTransaction43($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "44") {
    shift (@tokens); shift (@tokens);
    $rtnValue = processTransaction44($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "45") {
    shift (@tokens); shift (@tokens);
    $rtnValue = processTransaction45($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "RAD-49") {
    shift (@tokens); shift (@tokens);
    $rtnValue = imgmgr::processTransaction49($logLevel, $selfTest, $mppsAE, @tokens);
  } else {
    die "Unable to process command <$cmd>\n";
  }
  return $rtnValue;
}

sub printText {
  my $cmd = shift(@_);
  my @tokens = split /\s+/, $cmd;

  my $txtFile = "../common/" . $tokens[1];
  open TXT, $txtFile or die "Could not open text file: $txtFile";
  while ($line = <TXT>) {
    print $line;
  }
  close TXT;
  print "\nHit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  goodbye if ($x =~ /^q/);
}

sub printPatient {
  my $cmd = shift(@_);
  my @tokens = split /\s+/, $cmd;

  my $hl7Msg = "../../msgs/" . $tokens[1];
  my $pid = mesa::getField($hl7Msg, "PID", "3", "0", "Patient ID");
  my $patientName = mesa::getField($hl7Msg, "PID", "5", "0", "Patient Name");
  print "Patient Name: $patientName \n";
  print "Patient ID:   $pid\n";
  print "\nHit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  goodbye if ($x =~ /^q/);
}

#sub localScheduling {
#  my $cmd = shift(@_);
#  my @tokens = split /\s+/, $cmd;
#
#  my $orderFile = $tokens[1];
#  print "Local scheduling for file: $orderFile \n";
#}

sub processMESAInternal {
  my ($cmd, $logLevel, $selfTest) = @_;
  my @tokens = split /\s+/, $cmd;
  my $verb = $tokens[0];
  my $trans= $tokens[1];

  my $rtnValue = 0;
  if ($trans eq "RAD-SCHEDULE") {
    shift (@tokens); shift(@tokens);
    $rtnValue = mesa::processInternalSchedulingRequest($logLevel, $selfTest, @tokens);

  } elsif ($trans eq "GEN-MPPS-ABANDON") {
    shift (@tokens); shift (@tokens);
    $rtnValue = mesa::generateMPPSAbandon($logLevel, $selfTest, "MESAMWL", $mesaOFHost, $mesaOFPortDICOM, @tokens);
  } elsif ($trans eq "GEN-MPPS-ABANDON-CODED") {
    shift (@tokens); shift (@tokens);
    $rtnValue = mesa::generateMPPSAbandonCoded($logLevel, $selfTest, "MESAMWL", $mesaOFHost, $mesaOFPortDICOM, @tokens);
  } elsif ($trans eq "GEN-SOP-INSTANCES") {
    shift (@tokens); shift (@tokens);
    $rtnValue = mesa::generateSOPInstances($logLevel, $selfTest, "MESAMWL", $mesaOFHost, $mesaOFPortDICOM, @tokens);
    return 1 if ($rtnValue != 0);
    $rtnValue = mesa::update_scheduling_ORM_message($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "GEN-UNSCHED-SOP-INSTANCES") {
    shift (@tokens);
    $rtnValue = mesa::produceUnscheduledImages($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "MOD-MPPS") {
    shift (@tokens); shift (@tokens);
    $rtnValue = mesa::modifyMPPS($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "GEN-IAN") {
    shift (@tokens); shift (@tokens);
    $rtnValue = mesa::generateIAN($logLevel, $selfTest, $imCFindAE, @tokens);
  } else {
    die "Unable to process command <$cmd>";
  }

  return $rtnValue;
}

sub processMessage {
  my $cmd = shift(@_);
  my $logLevel = shift(@_);
  my $selfTest = shift(@_);
  my @tokens = split /\s+/, $cmd;
  my $verb = $tokens[0];
  my $trans= $tokens[1];

  if ($trans eq "RAD-SCHEDULE") {
    # Nothing to do, we are not going to announce this
    $rtnValue = 0;
  } else {
    die "Unable to process command <$cmd>\n";
  }
  return $rtnValue;
}


sub unscheduledImages {
  my ($cmd, $logLevel, $selfTest) = @_;
  my @tokens = split /\s+/, $cmd;

  my $rtnValue      = 0;
  my $verb          = $tokens[0];
  my $outputDir     = $tokens[1];
  my $hl7Msg        = "../../msgs/" . $tokens[2];
  my $modality      = $tokens[3];
  my $procedureCode = $tokens[4];
  my $performedCode = $tokens[5];
  my $inputDir      = $tokens[6];

  my $pid         = mesa::getField($hl7Msg, "PID", "3", "1", "Patient ID");
  my $patientName = mesa::getField($hl7Msg, "PID", "5", "0", "Patient Name");
  my $modName = $patientName;
  $modName =~ s/\^/_/;  # Because of problems passing ^ through the shell
  #$patientName =~ s/\^/_/;     # Because of problems passing ^ through the shell

  print "Test script now produces unscheduled images for $patientName\n";
  my $x = "perl scripts/produce_unscheduled_images.pl " .
        " $modality " .
        " MODALITY1 " .
        " $pid " .
        " $procedureCode " .
        " $outputDir " .
        " $performedCode " .
        " $inputDir " .
        " $modName ";
  print "$x\n" if ($logLevel >= 3);

  print `$x`;

  if ($?) {
    print "Unable to produce unscheduled images.\n";
    print "This is a configuration problem or MESA bug\n";
    print "Please log a bug report; \n";
    print " Run this test with log level 4, capture all output; capture the\n";
    print " file generatestudy.out and include this information in the bug report.\n";
    $rtnValue = 1;
  }

  return $rtnValue;
}


sub processOneLine {
  my ($cmd, $logLevel, $selfTest)  = @_;
  if ($cmd eq "") {
    return 0;
  }
  my @verb = split /\s+/, $cmd;
  my $rtn = 0;

#  print "$verb[0] \n";
  if ($verb[0] eq "TRANSACTION") {
    $rtn = processTransaction($cmd, $logLevel);
  } elsif ($verb[0] eq "TEXT") {
    printText($cmd);
  } elsif ($verb[0] eq "EXIT") {
    print "Found EXIT command\n";
    exit 0;
#  } elsif ($verb[0] eq "LOCALSCHEDULING") {
#    localScheduling($cmd);
  } elsif ($verb[0] eq "MESA-INTERNAL") {
    $rtn = processMESAInternal($cmd, $logLevel, $selfTest);
  } elsif ($verb[0] eq "MESSAGE") {
    $rtn = processMessage($cmd, $logLevel, $selfTest);
  } elsif ($verb[0] eq "UNSCHEDULED-IMAGES") {
    $rtn = unscheduledImages($cmd, $logLevel, $selfTest);
  } elsif ($verb[0] eq "PATIENT") {
    printPatient($cmd);
  } elsif ($verb[0] eq "PROFILE") {
    if ($verb[1] ne "SCHEDULED_WORKFLOW" && $verb[1] ne "SWF") {
      die "This Image Manager script is for the SWF profile, not $verb[1]";
    }
  } elsif (substr($verb[0], 0, 1) eq "#") {
    print "Comment: $cmd \n";
  } else {
    die "Did not recognize verb in command: $cmd \n";
  }
  return $rtn;
}

# Main starts here

die "Usage: <test number> <output level: 0-4>\n" if (scalar(@ARGV) < 2);

$host = `hostname`; chomp $host;

%varnames = mesa::get_config_params("imgmgr_test.cfg");
if (imgmgr::test_var_names(%varnames) != 0) {
  print "Some problem with the variables in imgmgr_test.cfg\n";
  exit 1;
}

$mesaImgMgrPortDICOM  = $varnames{"MESA_IMGMGR_DICOM_PT"};
$mesaImgMgrPortHL7    = $varnames{"MESA_IMGMGR_HL7_PORT"};	# We don't need this value
$mesaModPortDICOM     = $varnames{"MESA_MODALITY_PORT"};

$mesaOFPortDICOM      = $varnames{"MESA_OF_DICOM_PORT"};
$mesaOFPortHL7        = $varnames{"MESA_OF_HL7_PORT"};
$mesaOFHost           = $varnames{"MESA_OF_HOST"};
$mesaOFAE             = $varnames{"MESA_OF_AE"};

$mppsHost             = $varnames{"TEST_MPPS_HOST"};
$mppsPort             = $varnames{"TEST_MPPS_PORT"};
$mppsAE               = $varnames{"TEST_MPPS_AE"};

$imCStoreHost         = $varnames{"TEST_CSTORE_HOST"};
$imCStorePort         = $varnames{"TEST_CSTORE_PORT"};
$imCStoreAE           = $varnames{"TEST_CSTORE_AE"};

$imCFindHost          = $varnames{"TEST_CFIND_HOST"};
$imCFindPort          = $varnames{"TEST_CFIND_PORT"};
$imCFindAE            = $varnames{"TEST_CFIND_AE"};

$imCMoveHost          = $varnames{"TEST_CMOVE_HOST"};
$imCMovePort          = $varnames{"TEST_CMOVE_PORT"};
$imCMoveAE            = $varnames{"TEST_CMOVE_AE"};

$imCommitHost         = $varnames{"TEST_COMMIT_HOST"};
$imCommitPort         = $varnames{"TEST_COMMIT_PORT"};
$imCommitAE           = $varnames{"TEST_COMMIT_AE"};

$imHL7Host            = $varnames{"TEST_HL7_HOST"};
$imHL7Port            = $varnames{"TEST_HL7_PORT"};
#$imAE		      = $varnames{"TEST_IMGMGR_AE"};

$mesaWkstationAE      = $varnames{"MESA_WKSTATION_AE"};

testVarValues($imCommitAE, $mppsPort,
 $mppsAE, $imCommitHost, $mppsHost, $imCommitPort,
 $mesaModPortDICOM,
 $mesaImgMgrPortHL7);

my $fileName = "../common/$ARGV[0]/$ARGV[0]" . ".txt";
open TESTFILE, $fileName or die "Could not open: $fileName\n";
$logLevel = $ARGV[1];
$selfTest = 0;
$selfTest = 1 if (scalar(@ARGV) > 2);

die "MESA Environment Problem" if (mesa::testMESAEnvironment($logLevel) != 0);
my $version = mesa_get::getMESAVersion();
print "MESA Version: $version\n";
($x, $date, $timeMin) = mesa_get::getDateTime($logLevel);
die "Could not get current date/time" if ($x != 0);
print "Date/time = $date $timeMin\n";

print `perl scripts/reset_servers.pl`;

my $lineNum = 1;
while ($l = <TESTFILE>) {
  chomp $l;
  print "$lineNum $l\n"; $lineNum += 1;
  my $x = processOneLine($l, $logLevel, $selfTest);
  die "Could not process line $l\n" if ($x != 0);
}
close TESTFILE;

goodbye;
