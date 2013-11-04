use Env;

package imgmgr;
require Exporter;
@ISA = qw(Exporter);


sub processTransaction1 {
  my ($logLevel, $selfTest, $src, $dst, $event, $msg) = @_;

  if ($dst ne "OF") {
    print "IHE Transaction 1 from ($src) to ($dst) is not required for IM test\n";
    return;
  }

  my $hl7Msg = "../../msgs/" . $msg;
  my $pid = mesa::getField($hl7Msg, "PID", "3", "0", "Patient ID");
  my $patientName = mesa::getField($hl7Msg, "PID", "5", "0", "Patient Name");

  print "IHE Transaction 1: $pid $patientName \n";
  print "MESA will send ADT message ($msg) for event $event to MESA $dst\n";

  $x = mesa::send_hl7_log($logLevel, "../../msgs", $msg, "localhost", $main::mesaOFPortHL7);
  mesa::xmit_error($msg) if ($x != 0);
}

sub processTransaction2 {
  my ($logLevel, $selfTest, $src, $dst, $event, $msg) = @_;

  my $hl7Msg        = "../../msgs/" . $msg;
  my $pid           = mesa::getField($hl7Msg, "PID", "3", "0", "Patient ID");
  my $patientName   = mesa::getField($hl7Msg, "PID", "5", "0", "Patient Name");
  my $procedureCode = mesa::getField($hl7Msg, "OBR", "4", "0", "Procedure Code");

  print "IHE Transaction 2: $pid $patientName $procedureCode \n";
  print "MESA will send ORM message ($msg) for event $event to MESA $dst\n";

  $x = mesa::send_hl7_log(
	$logLevel, "../../msgs", $msg, "localhost", $main::mesaOFPortHL7);
  mesa::xmit_error($msg) if ($x != 0);
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

  my $SPSLocation = "";
  my $scheduledAET = "";
  die "Need values fpr SPSLocation, scheduledAET";

  mesa::local_scheduling_mr($logLevel, $SPSLocation, $scheduledAET);

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

sub processTransaction4aSecure {
  my ($logLevel, $selfTest, $src, $dst, $event, $msg, $outputDir, $inputDir, $SPSCode, $PPSCode) = @_;

  my $hl7Msg        = "../../msgs/" . $msg;
  my $pid           = mesa::getField($hl7Msg, "PID", "3", "1", "Patient ID");
  my $patientName   = mesa::getField($hl7Msg, "PID", "5", "0", "Patient Name");
  my $procedureCode = mesa::getField($hl7Msg, "OBR", "4", "1", "Procedure Code");

  print "IHE Transaction 4a: $pid $patientName $procedureCode \n";

  my $SPSLocation = "";
  my $scheduledAET = "";
  die "Need values fpr SPSLocation, scheduledAET";

  mesa::local_scheduling_mr($logLevel, $SPSLocation, $scheduledAET);

  my $x = "perl scripts/produce_scheduled_images_secure.pl MR MESA_MOD " .
	" $pid $procedureCode $outputDir MESA localhost $main::mesaOFPortDICOM " .
	" $SPSCode $PPSCode $inputDir ";
  print "$x \n";
  print `$x`;
  die "Could not schedule and produce data for this procedure \n" if $?;

  print "This is the scheduling prelude to transaction 4\n";
  print "All work here is internal to the MESA software \n";

  print "PID: $pid Name: $patientName Code: $procedureCode \n";
  my $z = mesa::update_scheduling_ORM($logLevel, $hl7Msg, "$main::MESA_STORAGE/modality/$outputDir");
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
  my $accessionNumber   = mesa::getField($hl7Msg, "ORC", "3", "1", "Filler Order Number");
  mesa::setField($logLevel, $hl7Msg, "OBR", "18", "0", "Accession Number", $accessionNumber);

  #my $z = mesa::update_scheduling_ORM($logLevel, $hl7Msg, "$MESA_STORAGE/modality/$modDirectory");
  #return 1 if ($z);

  print "IHE Transaction 4: $pid $patientName $procedureCode \n";
  print "MESA will send ORM message ($msg) for event $event to your $dst\n";
  print "Hit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  main::goodbye if ($x =~ /^q/);

  print "ll = $logLevel, msg = $msg, host = $imHL7Host, port = $imHL7Port\n";
  $x = mesa::send_hl7_log($logLevel, "../../msgs", $msg, $imHL7Host, $imHL7Port);
  mesa::xmit_error($msg) if ($x != 0);
  return 0;
}

sub processTransaction4Secure {
  my ($logLevel, $selfTest, $src, $dst, $event, $msg, $modDirectory) = @_;

  my $hl7Msg            = "../../msgs/" . $msg;
  my $pid               = mesa::getField($hl7Msg, "PID", "3", "0", "Patient ID");
  my $patientName       = mesa::getField($hl7Msg, "PID", "5", "0", "Patient Name");
  my $procedureCode     = mesa::getField($hl7Msg, "OBR", "4", "0", "Procedure Code");
  my $accessionNumber   = mesa::getField($hl7Msg, "ORC", "3", "1", "Filler Order Number");
  mesa::setField($logLevel, $hl7Msg, "OBR", "18", "0", "Accession Number", $accessionNumber);

  #my $z = mesa::update_scheduling_ORM($logLevel, $hl7Msg, "$MESA_STORAGE/modality/$modDirectory");
  #return 1 if ($z);

  print "IHE Transaction 4: $pid $patientName $procedureCode \n";
  print "MESA will send ORM message ($msg) for event $event to your $dst\n";
  print "Hit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  main::goodbye if ($x =~ /^q/);

  print "log level = $logLevel, msg = $msg, host = $main::imHL7Host, port = $main::imHL7Port\n";
  $x = mesa::send_hl7_secure(
	"../../msgs", $msg, $main::imHL7Host, $main::imHL7Port,
	"randoms.dat",
	"mesa_1.key.pem",
	"mesa_1.cert.pem",
	"test_sys_1.cert.pem",
	"NULL-SHA");

  mesa::xmit_error($msg) if ($x != 0);
  return 0;
}

sub processTransaction5 {
  print "Transaction 5 is not necessary to test the Image Manager \n";
  return 0;
}

sub processTransaction6 {
  my ($logLevel, $selfTest, $src, $dst, $event, $inputDir, $modalityAEMPPS) = @_;

  print "IHE Transaction 6: \n";
  print "MESA will send MPPS message from dir ($inputDir) for event ($event) to your ($dst)\n";
  print "Hit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  main::goodbye if ($x =~ /^q/);

  mesa::send_mpps_in_progress_log($logLevel, $inputDir, "$modalityAEMPPS", $main::mppsAE, $main::mppsHost, $main::mppsPort);
  mesa::send_mpps_in_progress_log($logLevel, $inputDir, "$modalityAEMPPS", $main::mppsAE, "localhost", $main::mesaOFPortDICOM);
  return 0;
}

sub processTransaction6Secure {
  my ($logLevel, $selfTest, $src, $dst, $event, $inputDir) = @_;

  print "IHE Transaction 6: \n";
  print "MESA will send MPPS message from dir ($inputDir) for event ($event) to your ($dst)\n";
  print "Hit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  main::goodbye if ($x =~ /^q/);

  # Send MPPS to Image Manager under test
  mesa::send_mpps_in_progress_secure(
	$inputDir, "MODALITY1",
	$main::mppsAE, $main::mppsHost, $main::mppsPort,
	"randoms.dat",
	"mesa_1.key.pem",
	"mesa_1.cert.pem",
	"test_sys_1.cert.pem",
	"NULL-SHA");

  # Send same MPPS to the MESA Order Filler
  mesa::send_mpps_in_progress_secure(
	$inputDir, "MODALITY1",
	$main::mppsAE, "localhost", $main::mesaOFPortDICOM,
	"randoms.dat",
	"test_sys_1.key.pem",
	"test_sys_1.cert.pem",
	"mesa_1.cert.pem",
	"NULL-SHA");

  return 0;
}

sub processTransaction7 {
  my ($logLevel, $selfTest, $src, $dst, $event, $inputDir, $modalityAEMPPS) = @_;

  print "IHE Transaction 7: \n";
  print "MESA will send MPPS message from dir ($inputDir) for event ($event) to your ($dst)\n";
  print "Hit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  main::goodbye if ($x =~ /^q/);

  mesa::send_mpps_complete($inputDir, $modalityAEMPPS, $main::mppsAE, $main::mppsHost, $main::mppsPort);
  mesa::send_mpps_complete($inputDir, $modalityAEMPPS, $main::mppsAE, "localhost", $main::mesaOFPortDICOM);
  return 0;
}

sub processTransaction7Secure {
  my ($logLevel, $selfTest, $src, $dst, $event, $inputDir) = @_;

  print "IHE Transaction 7: \n";
  print "MESA will send MPPS message from dir ($inputDir) for event ($event) to your ($dst)\n";
  print "Hit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  main::goodbye if ($x =~ /^q/);

  # Send MPPS to Image Manager under test
  mesa::send_mpps_complete_secure(
	$inputDir, "MODALITY1",
	$main::mppsAE, $main::mppsHost, $main::mppsPort,
	"randoms.dat",
	"mesa_1.key.pem",
	"mesa_1.cert.pem",
	"test_sys_1.cert.pem",
	"NULL-SHA");

  # Send same MPPS to MESA Order Filler
  mesa::send_mpps_complete_secure(
	$inputDir, "MODALITY1",
	$main::mppsAE, "localhost", $main::mesaOFPortDICOM,
	"randoms.dat",
	"test_sys_1.key.pem",
	"test_sys_1.cert.pem",
	"mesa_1.cert.pem",
	"NULL-SHA");
  return 0;
}

sub processTransaction8 {
  my ($logLevel, $selfTest, $src, $dst, $event, $inputDir, $modalityAE) = @_;

  print "IHE Transaction 8: \n";
  print "MESA will send images from dir ($inputDir) for event ($event) to your $dst\n";
  print "Hit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  main::goodbye if ($x =~ /^q/);

  mesa::store_images($inputDir, "", $modalityAE, $main::imCStoreAE, $main::imCStoreHost, $main::imCStorePort, 0);

  mesa::store_images($inputDir, "", $modalityAE, "MESA_IMG_MGR", "localhost", $main::mesaImgMgrPortDICOM, 1);
  return 0;
}

sub processTransaction8Secure {
  my ($logLevel, $selfTest, $src, $dst, $event, $inputDir) = @_;

  print "IHE Transaction 8: \n";
  print "MESA will send images from dir ($inputDir) for event ($event) to your $dst\n";
  print "Hit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  main::goodbye if ($x =~ /^q/);

  # Send images to Image Manager under test
  mesa::store_images_secure($inputDir, "", "MODALITY1",
	$main::imCStoreAE, $main::imCStoreHost, $main::imCStorePort, 0,
	"randoms.dat",
	"mesa_1.key.pem",
	"mesa_1.cert.pem",
	"test_sys_1.cert.pem",
	"NULL-SHA");

  # Send same images to MESA Image Manager, but omit pixel data.
  mesa::store_images_secure($inputDir, "", "MODALITY1",
	"MESA_IMG_MGR", "localhost", $main::mesaImgMgrPortDICOM, 1,
	"randoms.dat",
	"mesa_1.key.pem",
	"mesa_1.cert.pem",
	"test_sys_1.cert.pem",
	"NULL-SHA");
  return 0;
}

sub processTransaction10 {
  my ($logLevel, $selfTest, $src, $dst, $event, $inputDir, $callingAETitle) = @_;

  print "IHE Transaction 10: \n";
  if ($event eq "COMMIT-N-ACTION") {
    print "MESA will send Storage Commitment message from dir ($inputDir) for event ($event) to your $dst\n";
    print "Calling AE title will be: $callingAETitle\n";
    print "Hit <ENTER> when ready (q to quit) --> ";
    my $x = <STDIN>;
    main::goodbye if ($x =~ /^q/);
    mesa::send_storage_commit_naction($inputDir, $main::imCommitAE,
		$main::imCommitHost, $main::imCommitPort, $callingAETitle);
  } elsif ($event eq "COMMIT-N-EVENT") {
    mesa::send_storage_commit_nevent($inputDir, $main::mesaModPortDICOM);
  } else {
    die "Unrecognized event for Transaction 10: $event \n";
  }
  return 0;
}

sub processTransaction10Secure {
  my ($logLevel, $selfTest, $src, $dst, $event, $inputDir) = @_;

  print "IHE Transaction 10: \n";
  if ($event eq "COMMIT-N-ACTION") {
    print "MESA will send Storage Commitment message from dir ($inputDir) for event ($event) to your $dst\n";
    print "Hit <ENTER> when ready (q to quit) --> ";
    my $x = <STDIN>;
    main::goodbye if ($x =~ /^q/);
    mesa::send_storage_commit_naction_secure(
	$inputDir, $main::imCommitAE,
	$main::imCommitHost, $main::imCommitPort,
	"randoms.dat",
	"mesa_1.key.pem",
	"mesa_1.cert.pem",
	"test_sys_1.cert.pem",
	"NULL-SHA");
  } elsif ($event eq "COMMIT-N-EVENT") {
    mesa::send_storage_commit_nevent_secure(
	$logLevel,
	$inputDir, $main::mesaModPortDICOM,
	"randoms.dat",
	"test_sys_1.key.pem",
	"test_sys_1.cert.pem",
	"mesa_1.cert.pem",
	"NULL-SHA");
  } else {
    die "Unrecognized event for Transaction 10: $event \n";
  }
  return 0;
}

sub processTransaction12 {
  my ($logLevel, $selfTest, $src, $dst, $event, $msg) = @_;

  print "IHE Transaction 12: \n";
  print "MESA will send HL7 message ($msg) for event $event to $dst\n";

  if ($dst eq "IM") {
    print "Hit <ENTER> when ready (q to quit) --> ";
    my $x = <STDIN>;
    main::goodbye if ($x =~ /^q/);
    $x = mesa::send_hl7_log($logLevel, "../../msgs", $msg, $main::imHL7Host, $main::imHL7Port);
    mesa::xmit_error($msg) if ($x != 0);

    if ($selfTest == 0) {	# If not self test, then we need a copy
      $x = mesa::send_hl7_log($logLevel, "../../msgs", $msg, "localhost", $main::mesaImgMgrPortHL7);
      mesa::xmit_error($msg) if ($x != 0);
    }
  } else {
    print " We will ignore message sent to $dst. It is not required for IM test\n";
  }
}

sub processTransaction12Secure {
  my ($logLevel, $selfTest, $src, $dst, $event, $msg) = @_;

  print "IHE Transaction 12 (Secure): \n";
  print "MESA will send HL7 message ($msg) for event $event to $dst\n";

  if ($dst eq "IM") {
    print "Hit <ENTER> when ready (q to quit) --> ";
    my $x = <STDIN>;
    main::goodbye if ($x =~ /^q/);
    $x = mesa::send_hl7_secure(
	"../../msgs", $msg, $main::imHL7Host, $main::imHL7Port,
	"randoms.dat",
	"mesa_1.key.pem",
	"mesa_1.cert.pem",
	"test_sys_1.cert.pem",
	"NULL-SHA");
    mesa::xmit_error($msg) if ($x != 0);

    if ($selfTest == 0) {	# If not self test, then we need a copy
      $x = mesa::send_hl7_secure(
	"../../msgs", $msg, "localhost", $main::mesaImgMgrPortHL7,
	"randoms.dat",
	"mesa_1.key.pem",
	"mesa_1.cert.pem",
	"test_sys_1.cert.pem",
	"NULL-SHA");
      mesa::xmit_error($msg) if ($x != 0);
    }
  } else {
    print " We will ignore message sent to $dst. It is not required for IM test\n";
  }
}

sub processTransaction13 {
  my $src = shift(@_);
  my $dst = shift(@_);
  my $event = shift(@_);
  my $msg = shift(@_);

  my $hl7Msg = "../../msgs/" . $msg;
  my $pid = mesa::getField($hl7Msg, "PID", "3", "0", "Patient ID");
  my $patientName = mesa::getField($hl7Msg, "PID", "5", "0", "Patient Name");
  my $procedureCode = mesa::getField($hl7Msg, "OBR", "4", "0", "Procedure Code");

  print "IHE Transaction 13: $pid $patientName $procedureCode \n";
  print "MESA will send ORM message ($msg) for event $event to your $dst\n";

  $x = mesa::send_hl7("../../msgs", $msg, $imHL7Host, $imHL7Port);
  mesa::xmit_error($msg) if ($x != 0);
}

sub processTransaction14 {
  my ($logLevel, $selfTest, $src, $dst, $event, $inputParam, $inDir, $outDir) = @_;
# inputParam varies according to the event; for QUERY, it is the name of the  
# directory used to store images relative to $MESA_STORAGE/modality.
# for QUERY-NAME-HL7, it is name of file relative to messages directory 
# inDir is the location where the templates for queries are stored.
# outDir is the location the output objects are stored.
  die "Not enough parameters passed to Transaction 14.  Be sure output directory " .
      "is defined" if not defined $outDir;

  print "IHE Transaction 14: \n";
  print "MESA will send CFIND message ($outDir) for event $event to your $dst\n";
  print "Hit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  main::goodbye if ($x =~ /^q/);

# clean out and create the output directory
    mesa::delete_directory(1, $outDir);
    mesa::create_directory(1, $outDir);

  if ($event eq "QUERY") {
    my $fullPath = "$main::MESA_STORAGE/modality/" . $inputParam . "/x1.dcm";
    ($x, $studyInstanceUID) = mesa::getDICOMAttribute($logLevel, $fullPath, "0020 000D");
    if ($x != 0) {
      print "Unable to get DICOM Study Instance UID from $fullPath $x\n";
      return 1;
    }

    $x = mesa::construct_cfind_query_study(
	$logLevel,
	"$inDir/cfind_study_uid_templ.txt",
	"$outDir/cfind_study_uid.txt",
	"$outDir/cfind_study_level.dcm",
	$studyInstanceUID);
    return 1 if ($x != 0);
  } elsif ($event eq "QUERY-NAME-HL7") {
    my $hl7Msg = "../../msgs/$inputParam";
    my $patientName = mesa::getField($hl7Msg, "PID", "5", "0", "Patient Name");
    $x = mesa::construct_cfind_query_patient_name(
	$logLevel,
	"$inDir/cfind_study_patient_name_templ.txt",
	"$outDir/cfind_study_patient_name.txt",
	"$outDir/cfind_study_level.dcm",
	$patientName);
  } else {
    print "For transaction 14, we do not recognize event $event\n";
    return 1;
  }

  $x = mesa::send_cfind_log(
		$logLevel,
		"$outDir/cfind_study_level.dcm",
		$main::imCFindAE, $main::imCFindHost, $main::imCFindPort,
		"$outDir/test");
  return 1 if ($x != 0);

# Repeat the process for queries to MESA Image Manager
  $x = mesa::send_cfind_log(
		$logLevel,
		"$outDir/cfind_study_level.dcm",
		"MESA_ARCHIVE", "localhost", $main::mesaImgMgrPortDICOM,
		"$outDir/mesa");
  return 1 if ($x != 0);
  return 0;
}

sub processTransaction14Secure {
  my ($logLevel, $selfTest, $src, $dst, $event, $inputParam, $inDir, $outDir) = @_;
# inputParam varies according to the event; for QUERY, it is the name of the  
# directory used to store images relative to $MESA_STORAGE/modality.
# for QUERY-NAME-HL7, it is name of file relative to messages directory 
# inDir is the location where the templates for queries are stored.
# outDir is the location the output objects are stored.
  die "Not enough parameters passed to Transaction 14.  Be sure output directory " .
      "is defined" if not defined $outDir;

  print "IHE Transaction 14: \n";
  print "MESA will send CFIND message ($outDir) for event $event to your $dst\n";
  print "Hit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  main::goodbye if ($x =~ /^q/);

# clean out and create the output directory
    mesa::delete_directory(1, $outDir);
    mesa::create_directory(1, $outDir);

  if ($event eq "QUERY") {
    my $fullPath = "$main::MESA_STORAGE/modality/" . $inputParam . "/x1.dcm";
    ($x, $studyInstanceUID) = mesa::getDICOMAttribute($logLevel, $fullPath, "0020 000D");
    if ($x != 0) {
      print "Unable to get DICOM Study Instance UID from $fullPath $x\n";
      return 1;
    }

    $x = mesa::construct_cfind_query_study(
	$logLevel,
	"$inDir/cfind_study_uid_templ.txt",
	"$outDir/cfind_study_uid.txt",
	"$outDir/cfind_study_level.dcm",
	$studyInstanceUID);
    return 1 if ($x != 0);
  } elsif ($event eq "QUERY-NAME-HL7") {
    my $hl7Msg = "../../msgs/$inputParam";
    my $patientName = mesa::getField($hl7Msg, "PID", "5", "0", "Patient Name");
    $x = mesa::construct_cfind_query_patient_name(
	$logLevel,
	"$inDir/cfind_study_patient_name_templ.txt",
	"$outDir/cfind_study_patient_name.txt",
	"$outDir/cfind_study_level.dcm",
	$patientName);
  } else {
    print "For transaction 14, we do not recognize event $event\n";
    return 1;
  }

  $x = mesa::send_cfind_secure(
		$logLevel,
		"$outDir/cfind_study_level.dcm",
		$main::imCFindAE, $main::imCFindHost, $main::imCFindPort,
		"$outDir/test",
		"randoms.dat",
		"mesa_1.key.pem",
		"mesa_1.cert.pem",
		"test_sys_1.cert.pem",
		"NULL-SHA");
  return 1 if ($x != 0);

# Repeat the process for queries to MESA Image Manager
  $x = mesa::send_cfind_secure(
		$logLevel,
		"$outDir/cfind_study_level.dcm",
		"MESA_ARCHIVE", "localhost", $main::mesaImgMgrPortDICOM,
		"$outDir/mesa",
		"randoms.dat",
		"mesa_1.key.pem",
		"mesa_1.cert.pem",
		"test_sys_1.cert.pem",
		"NULL-SHA");
  return 1 if ($x != 0);
  return 0;
}

sub processTransaction16 {
    my ($logLevel, $selfTest, $src, $dst, $event, $inputParam, $inDir, $outDir) = @_;
    print "IHE Transaction 16: \n";
    print "MESA will send CMOVE message for event $event to your $dst\n";
    print "Hit <ENTER> when ready (q to quit) --> ";
    my $x = <STDIN>;
    main::goodbye if ($x =~ /^q/);

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

    my $cmoveString = "$main::MESA_TARGET/bin/cmove -a MESA -c $imCStoreAE " .
        "-f $outDir/cmove.dcm -x STUDY $imCStoreHost " . 
        "$imCStorePort $mesaWkstationAE";

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
    main::goodbye if ($x =~ /^q/);

    mesa::delete_directory($logLevel, $outDir);
    mesa::create_directory($logLevel, $outDir);

    my $imageFile = "$MESA_STORAGE/modality/$inputParam/x1.dcm";
# create sr.dcm file from the text srFile.
    my $srFileDcm = "$outDir/sr.dcm";
    my $cmd = "$main::MESA_TARGET/bin/dcm_create_object -i $srFile $srFileDcm";
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

    $cmd = "$main::MESA_TARGET/bin/ncreate -a $mesaWkstationAE -c $imCStoreAE" .
        " $imCStoreHost $imCStorePort mpps $mppsFile $main::mpps_uid ";
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
    main::goodbye if ($x =~ /^q/);

    mesa::delete_directory($logLevel, $outDir);
    mesa::create_directory($logLevel, $outDir);

    my $mppsFile = "$outDir/mpps.dcm";

    mesa::createT21MPPS($templateFile, $mppsFile);

    my $cmd = "$main::MESA_TARGET/bin/nset -a $mesaWkstationAE -c $imCStoreAE" .
        " $imCStoreHost $imCStorePort mpps $mppsFile $main::mpps_uid ";
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
    main::goodbye if ($x =~ /^q/);

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
    main::goodbye if ($x =~ /^q/);

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

    my $cmoveString = "$main::MESA_TARGET/bin/cmove -a MESA -c $imCStoreAE " .
        "-f $outDir/cmove.dcm -x STUDY $imCStoreHost " . 
        "$imCStorePort $mesaWkstationAE";

    print "$cmoveString \n";
    print `$cmoveString`;
    if ($?) {
        print "Could not send C-Move request \n";
        return 1;
    }

    return 0;
}

#sub processTransaction {
#  my ($cmd, $logLevel) = @_;
#  my @tokens = split /\s+/, $cmd;
#  my $verb = $tokens[0];
#  my $trans= $tokens[1];
#  my $rtnValue = 0;
#
#  if ($trans eq "1") {
#    shift (@tokens); shift (@tokens);
#    processTransaction1(@tokens);
#  } elsif ($trans eq "2") {
#    shift (@tokens); shift (@tokens);
#    processTransaction2(@tokens);
#  } elsif ($trans eq "3") {
#    shift (@tokens); shift (@tokens);
#    processTransaction3($logLevel, $selfTest, @tokens);
#  } elsif ($trans eq "4a") {
#    shift (@tokens); shift (@tokens);
#    $rtnValue = processTransaction4a($logLevel, $selfTest, @tokens);
#  } elsif ($trans eq "4b") {
#    shift (@tokens); shift (@tokens);
#    $rtnValue = processTransaction4b($logLevel, $selfTest, @tokens);
#  } elsif ($trans eq "4") {
#    shift (@tokens); shift (@tokens);
#    $rtnValue = processTransaction4($logLevel, $selfTest, @tokens);
#  } elsif ($trans eq "5") {
#    shift (@tokens); shift (@tokens);
#    processTransaction5(@tokens);
#  } elsif ($trans eq "6") {
#    shift (@tokens); shift (@tokens);
#    processTransaction6(@tokens);
#  } elsif ($trans eq "7") {
#    shift (@tokens); shift (@tokens);
#    processTransaction7(@tokens);
#  } elsif ($trans eq "8") {
#    shift (@tokens); shift (@tokens);
#    processTransaction8(@tokens);
#  } elsif ($trans eq "10") {
#    shift (@tokens); shift (@tokens);
#    processTransaction10(@tokens);
#  } elsif ($trans eq "12") {
#    shift (@tokens); shift (@tokens);
#    processTransaction12(@tokens);
#  } elsif ($trans eq "13") {
#    shift (@tokens); shift (@tokens);
#    processTransaction13(@tokens);
#  } elsif ($trans eq "14") {
#    shift (@tokens); shift (@tokens);
#    $rtnValue = processTransaction14($logLevel, $selfTest, @tokens);
#  } elsif ($trans eq "16") {
#    shift (@tokens); shift (@tokens);
#    $rtnValue = processTransaction16($logLevel, $selfTest, @tokens);
#  } elsif ($trans eq "20") {
#    shift (@tokens); shift (@tokens);
#    $rtnValue = processTransaction20($logLevel, $selfTest, @tokens);
#  } elsif ($trans eq "21") {
#    shift (@tokens); shift (@tokens);
#    $rtnValue = processTransaction21($logLevel, $selfTest, @tokens);
#  } elsif ($trans eq "43") {
#    shift (@tokens); shift (@tokens);
#    $rtnValue = processTransaction43($logLevel, $selfTest, @tokens);
#  } elsif ($trans eq "44") {
#    shift (@tokens); shift (@tokens);
#    $rtnValue = processTransaction44($logLevel, $selfTest, @tokens);
#  } elsif ($trans eq "45") {
#    shift (@tokens); shift (@tokens);
#    $rtnValue = processTransaction45($logLevel, $selfTest, @tokens);
#  } else {
#    die "Unable to process command <$cmd>\n";
#  }
#  return $rtnValue;
#}

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
  main::goodbye if ($x =~ /^q/);
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
  main::goodbye if ($x =~ /^q/);
}

#sub localScheduling {
#  my $cmd = shift(@_);
#  my @tokens = split /\s+/, $cmd;
#
#  my $orderFile = $tokens[1];
#  print "Local scheduling for file: $orderFile \n";
#}

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

# Entries below are for Cardiology Workflow

sub processCardiologyScheduleMessage {
  # There is nothing to do here. If this were a DSS/OF test,
  # we would tell the DSS/OF to schedule an SPS in the MWL.

  return 0;
}

# processCardiologySchedule
# This function schedules steps for Cardiology specifc codes.
sub processCardiologySchedule {
  my ($logLevel, $selfTest, $src, $dst, $event, $msg, $outputDir, $inputDir, $SPSCode, $PPSCode, $SPSLocation, $scheduledAET)  = @_;

  my $hl7Msg = "../../msgs/" . $msg;
  my $pid           = mesa::getField($hl7Msg, "PID", "3", "1", "Patient ID");
  my $patientName   = mesa::getField($hl7Msg, "PID", "5", "0", "Patient Name");
  my $universalServiceID = mesa::getField($hl7Msg, "OBR", "4", "0", "Universal Service ID");
  my $procedureCode = mesa::getField($hl7Msg, "OBR", "4", "1", "Procedure Code");
  my $modality      = mesa::getField($hl7Msg, "OBR", "24", "1", "Service Sector ID");

  print "This is the MESA scheduling prelude to transaction 4\n";
  print "The MESA (DSS/OF) tools will now perform appropriate scheduling\n";
  print " The Universal Service ID is $universalServiceID\n";
  print " The Procedure Code  is $procedureCode\n";
  print " The modality should be $modality\n";
  print " The SPS Location should be $SPSLocation\n";
  print " The Scheduled AE Title is $scheduledAET\n";
  print "Hit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  main::goodbye if ($x =~ /^q/);
  if ($modality eq "MR") {
    mesa::local_scheduling_mr($logLevel, $SPSLocation, $scheduledAET);
  } elsif ($modality eq "RT") {
    mesa::local_scheduling_rt($logLevel, $SPSLocation, $scheduledAET);
  } elsif ($modality eq "HD") {
    mesa::local_scheduling_hd($logLevel, $SPSLocation, $scheduledAET);
  } else {
    printf "Unrecognized modality type for local scheduling: $modality \n";
    exit 1;
  }

#  $x = "perl ../../../rad/actors/imgmgr/scripts/produce_scheduled_images.pl $modality $scheduledAET" .
#        " $pid $procedureCode $outputDir " .
#        " $main::mesaOFAE $main::mesaOFHost $main::mesaOFPortDICOM " .
#        " $SPSCode $PPSCode $inputDir ";
#  print "$x \n";
#  print `$x`;
#  die "Could not schedule and produce data for this procedure \n" if $?;

  print "PID: $pid Name: $patientName Code: $procedureCode \n";
  return 0;
}

# generateSOPInstances
# This function schedules steps for Cardiology specifc codes.
sub generateSOPInstances {
  my ($logLevel, $selfTest, $src, $dst, $event, $msg, $outputDir, $inputDir, $SPSCode, $PPSCode, $SPSLocation, $scheduledAET)  = @_;

  my $hl7Msg = "../../msgs/" . $msg;
  my $pid           = mesa::getField($hl7Msg, "PID", "3", "1", "Patient ID");
  my $patientName   = mesa::getField($hl7Msg, "PID", "5", "0", "Patient Name");
  my $universalServiceID = mesa::getField($hl7Msg, "OBR", "4", "0", "Universal Service ID");
  my $procedureCode = mesa::getField($hl7Msg, "OBR", "4", "1", "Procedure Code");
  my $modality      = mesa::getField($hl7Msg, "OBR", "24", "1", "Service Sector ID");

  print "This is the MESA step for producing SOP Instances\n";
  print " The Universal Service ID is $universalServiceID\n";
  print " The Procedure Code  is $procedureCode\n";
  print " The modality should be $modality\n";
  print " The SPS Location should be $SPSLocation\n";
  print " The Scheduled AE Title is $scheduledAET\n";
  print "Hit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  main::goodbye if ($x =~ /^q/);

  $x = "perl ../../../rad/actors/imgmgr/scripts/produce_scheduled_images.pl $modality $scheduledAET" .
        " $pid $procedureCode $outputDir " .
        " $main::mesaOFAE $main::mesaOFHost $main::mesaOFPortDICOM " .
        " $SPSCode $PPSCode $inputDir ";
  print "$x \n";
  print `$x`;
  die "Could not produce SOP Instances for this procedure \n" if $?;

  print "PID: $pid Name: $patientName Code: $procedureCode \n";
  return 0;
}

# processCardiologyScheduleMPPSTrigger
# This function schedules steps for Cardiology specifc codes.
sub processCardiologyScheduleMPPSTrigger {
  my ($logLevel, $selfTest, $src, $dst, $event, $msg, $outputDir, $inputDir, $SPSCode, $PPSCode, $SPSLocation, $scheduledAET, $modality, $SPSIndex)  = @_;

  my $hl7Msg = "../../msgs/" . $msg;
  my $pid           = mesa::getField($hl7Msg, "PID", "3", "1", "Patient ID");
  my $patientName   = mesa::getField($hl7Msg, "PID", "5", "0", "Patient Name");
  my $universalServiceID = mesa::getField($hl7Msg, "OBR", "4", "0", "Universal Service ID");
  my $procedureCode = mesa::getField($hl7Msg, "OBR", "4", "1", "Procedure Code");

  print "This is the MESA scheduling step that is triggered by MPPS events in Cath Workflow\n";
  print "The MESA (DSS/OF) tools will now perform appropriate scheduling\n";
  print " The Universal Service ID is $universalServiceID\n";
  print " The Procedure Code  is $procedureCode\n";
  print " The modality should be $modality\n";
  print " The scheduled AE title should be $scheduledAET\n";
  print " The SPS Location should be $SPSLocation\n";
  print " The SPS Index (MESA convention) is $SPSIndex\n";
  print "Hit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  main::goodbye if ($x =~ /^q/);

  if ($modality eq "IVUS") {
    mesa::local_scheduling_ivus_mpps_trigger($logLevel, $SPSLocation, $scheduledAET, $SPSCode, $SPSIndex);
  } elsif ($modality eq "XA") {
    mesa::local_scheduling_xa_mpps_trigger($logLevel, $SPSLocation, $scheduledAET, $SPSCode, $SPSIndex);
  } else {
    printf "Unrecognized modality type for local scheduling: $modality \n";
    exit 1;
  }
  $x = "perl ../../../rad/actors/imgmgr/scripts/produce_scheduled_images.pl $modality MESA_MOD " .
        " $pid $procedureCode $outputDir " .
        " $main::mesaOFAE $main::mesaOFHost $main::mesaOFPortDICOM " .
        " $SPSCode $PPSCode $inputDir ";
  print "$x \n";
  print `$x`;
  die "Could not schedule and produce data for this procedure \n" if $?;

  print "PID: $pid Name: $patientName Code: $procedureCode \n";
  return 0;
}


sub processTransactionCard1 {
  my ($logLevel, $selfTest, $src, $dst, $event, $inputDir, $modalityAE) = @_;

  print "IHE Transaction Cardiology-1: \n";
  print "MESA will send MPPS message from dir ($inputDir) for event ($event) to your ($dst)\n";
  print "Hit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  main::goodbye if ($x =~ /^q/);

  mesa::send_mpps_in_progress_log($logLevel, $inputDir, $modalityAE, $main::mppsAE, $main::mppsHost, $main::mppsPort);
  mesa::send_mpps_in_progress_log($logLevel, $inputDir, $modalityAE, $main::mppsAE, "localhost", $main::mesaOFPortDICOM);
  return 0;
}

sub processTransaction49 {
  my ($logLevel, $selfTest, $imgmgrAEMPPS, $src, $dst, $event, $inputDir) = @_;

  print "IHE Transaction RAD-49: \n";
  if($selfTest == 1){
    print "MESA will send IAN message to $main::mesaOFAE running at $main::mesaOFHost:$main::mesaOFPortDICOM\n";
  } else{
    print "Please send your IAN message to $main::mesaOFAE running at $main::mesaOFHost:$main::mesaOFPortDICOM\n";
  }
  print "Hit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  main::goodbye if ($x =~ /^q/);

  if($selfTest == 1){
    mesa::send_ian_log($logLevel, $inputDir, $imgmgrAEMPPS, $main::mesaOFAE, $main::mesaOFHost, $main::mesaOFPortDICOM);
  }
  return 0;
}
1;
