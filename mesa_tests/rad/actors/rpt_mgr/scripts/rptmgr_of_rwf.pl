#!/usr/local/bin/perl -w

# Runs the Order Filler scripts interactively

use Env;
use lib "scripts";
require rpt_mgr;

$SIG{INT} = \&goodbye;


sub goodbye () {
  print "Exiting...\n";

  exit 1;
}

sub print_config_params {
  foreach $varname (keys %varnames) {
    print "Variable $varname = $varnames{$varname} \n";
  }
}

sub processTransaction1 {
  my ($logLevel, $selfTest, $src, $dst, $event, $msg) = @_;

  if ($dst ne "OF") {
    print "IHE Transaction 1 from ($src) to ($dst) is not required for DSS/OF test\n";
    return 0;
  }

  my $hl7Msg = "../../msgs/" . $msg;
  my $pid = mesa::getField($hl7Msg, "PID", "3", "0", "Patient ID");
  my $patientName = mesa::getField($hl7Msg, "PID", "5", "0", "Patient Name");

  print "IHE Transaction 1: $pid $patientName \n";

  if ($selfTest == 0) {
    print "MESA will send ADT message ($msg) for event $event to MESA $dst\n";
    $x = mesa::send_hl7_log($logLevel, "../../msgs", $msg, "localhost", $mesaOrderFillerPortHL7);
    mesa::xmit_error($msg) if ($x != 0);
  }

  print "\nMESA will now send ADT message ($msg) to your Order Filler ($ofHostHL7 $ofPortHL7) \n";
  print "Hit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  goodbye if ($x =~ /^q/);
  $x = mesa::send_hl7_log($logLevel, "../../msgs", $msg, $ofHostHL7, $ofPortHL7);
  mesa::xmit_error($msg) if ($x != 0);
  return 0;
}

sub processTransaction2 {
  my ($logLevel, $selfTest, $src, $dst, $event, $msg) = @_;

  my $hl7Msg = "../../msgs/" . $msg;
  my $pid               = mesa::getField($hl7Msg, "PID", "3", "0", "Patient ID");
  my $patientName       = mesa::getField($hl7Msg, "PID", "5", "0", "Patient Name");
  my $procedureCode     = mesa::getField($hl7Msg, "OBR", "4", "0", "Procedure Code");
  my $placerOrderNumber = mesa::getField($hl7Msg, "ORC", "2", "0", "Placer Order Number");

  print "\nIHE Transaction 2: $pid $patientName $procedureCode \n";
  print "MESA will now send ORM^O01 message ($msg) to your Order Filler ($ofHostHL7 $ofPortHL7) \n" if ($event eq "ORDER");
  print "MESA will now send OOR^O02 message ($msg) to your Order Filler ($ofHostHL7 $ofPortHL7) \n" if ($event eq "ORDER_O02");
  print " Placer Order Number $placerOrderNumber \n";
  print "Hit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  goodbye if ($x =~ /^q/);
  $x = mesa::send_hl7("../../msgs", $msg, $ofHostHL7, $ofPortHL7);
  mesa::xmit_error($msg) if ($x != 0);

  if ($selfTest == 1) {
    print "Looks like this is run directly for MESA testing; skip order copy to MESA DSS/OF \n";
  } else {
    # Send a copy of the Order to MESA for our own purposes.
    print "MESA will send ORM message ($msg) for event $event to MESA $dst\n";
    $x = mesa::send_hl7("../../msgs", $msg, "localhost", $mesaOrderFillerPortHL7);
    mesa::xmit_error($msg) if ($x != 0);
  }
  return 0;
}

sub processTransaction3 {
  my ($logLevel, $selfTest, $src, $dst, $event, $msg, $extraOrder) = @_;

  my $hl7Msg = "../../msgs/" . $msg;
  my $pid               = mesa::getField($hl7Msg, "PID", "3", "0", "Patient ID");
  my $patientName       = mesa::getField($hl7Msg, "PID", "5", "0", "Patient Name");
  my $placerOrderNumber = mesa::getField($hl7Msg, "ORC", "2", "0", "Placer Order Number");

  print "\nIHE Transaction 3: $pid $patientName \n";
  print "DSS/OF is expected to send HL7 message to MESA Order Placer ($host $mesaOrderPlacerPortHL7) for event $event \n";
  print " Placer Order number is $placerOrderNumber \n" if ($event eq "CANCEL");
  print "Hit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  goodbye if ($x =~ /^q/);

  if ($selfTest == 1) {
    print "Looks like this is run directly for MESA testing; send order to MESA OP \n";
    $x = mesa::send_hl7_log($logLevel, "../../msgs", $msg, "localhost", $mesaOrderPlacerPortHL7);
    mesa::xmit_error($msg) if ($x != 0);
  } else {
  }

  # Send a copy of that Order to MESA so we can schedule it
  if ($event eq "ORDER") {
    print "About to send Order back to MESA Order Filler for our scheduling\n";
    $x = mesa::send_hl7_log($logLevel, "../../msgs", $extraOrder, "localhost", $mesaOrderFillerPortHL7);
    mesa::xmit_error($msg) if ($x != 0);
  }
  return 0;
}

sub processTransaction4a {
  my ($logLevel, $src, $dst, $event, $msg, $outputDir, $inputDir, $SPSCode, $PPSCode)  = @_;

  my $hl7Msg = "../../msgs/" . $msg;
  my $pid = mesa::getField($hl7Msg, "PID", "3", "1", "Patient ID");
  my $patientName = mesa::getField($hl7Msg, "PID", "5", "0", "Patient Name");
  my $procedureCode = mesa::getField($hl7Msg, "OBR", "4", "1", "Procedure Code");
  my $modality = mesa::getField($hl7Msg, "OBR", "24", "1", "Service Sector ID");

  if ($modality eq "MR") {
    mesa::local_scheduling_mr($logLevel, "EASTMR", "MR3T");
  } elsif ($modality eq "RT") {
    mesa::local_scheduling_rt();
  } else {
    printf "Unrecognized modality type for local scheduling: $modality \n";
    exit 1;
  }

  my $x = "perl scripts/produce_scheduled_images.pl $modality MESA_MOD " .
	" $pid $procedureCode $outputDir $mwlAE $mwlHost $mwlPort " .
	" $SPSCode $PPSCode $inputDir $logLevel";
  print "$x \n";
  print `$x`;
  die "Could not schedule and produce data for this procedure \n" if $?;

  print "This is the scheduling prelude to transaction 4\n";
  print "All work here is internal to the MESA software \n";

  print "PID: $pid Name: $patientName Code: $procedureCode \n";
  return 0;
}

sub processTransaction4 {
  my $logLevel = shift(@_);
  my $selfTest = shift(@_);
  my $src = shift(@_);
  my $dst = shift(@_);
  my $event = shift(@_);
  my $msg = shift(@_);

  my $hl7Msg = "../../msgs/" . $msg;
  my $pid               = mesa::getField($hl7Msg, "PID", "3", "0", "Patient ID");
  my $patientName       = mesa::getField($hl7Msg, "PID", "5", "0", "Patient Name");
  my $procedureCode     = mesa::getField($hl7Msg, "OBR", "4", "0", "Procedure Code");
  my $placerOrderNumber = mesa::getField($hl7Msg, "ORC", "2", "0", "Placer Order Number");

  print "\nIHE Transaction 4: $pid $patientName $procedureCode \n";
  print "DSS/OF is expected to send HL7 message to MESA IM ($host $mesaIMPortHL7) for event $event \n";
  print " Placer Order Number is $placerOrderNumber \n";
  print "Hit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  goodbye if ($x =~ /^q/);

  if ($selfTest == 1) {
    print "Looks like this is run directly for MESA testing; send order to MESA IM \n";
    $x = mesa::send_hl7("../../msgs", $msg, "localhost", $mesaIMPortHL7);
    mesa::xmit_error($msg) if ($x != 0);
  } else {
  }
  return 0;
}

sub processTransaction5 {
  my ($logLevel, $selfTest, $src, $dst, $event, $msg, $outDir) = @_;

  my $hl7Msg = "../../msgs/" . $msg;
  my $pid = mesa::getField($hl7Msg, "PID", "3", "0", "Patient ID");
  my $pidShort = mesa::getField($hl7Msg, "PID", "3", "1", "Patient ID");
  my $patientName = mesa::getField($hl7Msg, "PID", "5", "0", "Patient Name");
  my $procedureCode = mesa::getField($hl7Msg, "OBR", "4", "0", "Procedure Code");

  print "\nIHE Transaction 5: $pid $patientName $procedureCode \n";
  print "MESA Modality will now send MWL query for patient with PID $pidShort\n";
  print "Hit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  goodbye if ($x =~ /^q/);

  $x = mesa::construct_mwl_query_pid(
	$logLevel, "mwl/mwlquery_template.txt", "mwl/mwlquery_pid.txt",
	"mwl/mwlquery_pid.dcm", $pidShort);

  return 1 if ($x != 0);

  $x = mesa::send_cfind_mwl($logLevel, "mwl/mwlquery_pid.dcm",
	$mwlAE, $mwlHost, $mwlPort, $outDir . "/test");
  return 1 if ($x != 0);

  $x = mesa::send_cfind_mwl($logLevel, "mwl/mwlquery_pid.dcm",
	$mwlAE, $mwlHost, $mwlPort, $outDir . "/mesa");
  return 1 if ($x != 0);

  return 0;
}

sub processTransaction6 {
  my $src   = shift(@_);
  my $dst   = shift(@_);
  my $event = shift(@_);
  my $inputDir = shift(@_);

  print "IHE Transaction 6: \n";
  print "MESA will send MPPS message from dir ($inputDir) for event ($event) to your ($dst)\n";
  print "MPPS parameters for DSS/OF: $mppsAE $mppsHost $mppsPort \n";
  print "Hit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  goodbye if ($x =~ /^q/);

  mesa::send_mpps_in_progress($inputDir, "MODALITY1", $mppsAE, $mppsHost, $mppsPort);
  mesa::send_mpps_in_progress($inputDir, "MODALITY1", $mppsAE, "localhost", $mesaIMPortDICOM);
  return 0;
}

sub processTransaction7 {
  my $src   = shift(@_);
  my $dst   = shift(@_);
  my $event = shift(@_);
  my $inputDir = shift(@_);

  print "IHE Transaction 7: \n";
  print "MESA will send MPPS message from dir ($inputDir) for event ($event) to your ($dst)\n";
  print "MPPS parameters for DSS/OF: $mppsAE $mppsHost $mppsPort \n";
  print "Hit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  goodbye if ($x =~ /^q/);

  mesa::send_mpps_complete($inputDir, "MODALITY1", $mppsAE, $mppsHost, $mppsPort);
  mesa::send_mpps_complete($inputDir, "MODALITY1", $mppsAE, "localhost", $mesaIMPortDICOM);

  print "MPPS is complete for this procedure step. If your system submits\n";
  print " Image Availability queries, you might want to check results now.\n";
  print "Hit <ENTER> when ready (q to quit) --> ";
  $x = <STDIN>;
  goodbye if ($x =~ /^q/);
  return 0;
}

sub processTransaction8 {
  my $src = shift(@_);
  my $dst = shift(@_);
  my $event = shift(@_);
  my $inputDir = shift(@_);

  print "IHE Transaction 8: \n";
  print "MESA will send images from dir ($inputDir) for event ($event) to MESA IM \n";

  mesa::store_images($inputDir, "", "MODALITY1", "MESA_IMG_MGR", "localhost", $mesaIMPortDICOM, 1);

  return 0;
}

sub processTransaction10 {
  my $src = shift(@_);
  my $dst = shift(@_);
  my $event = shift(@_);
  my $inputDir = shift(@_);

  print "IHE Transaction 10: \n";
  print "Skip this transaction; it is not required for testing DSS/OF \n";
  return 0;
}

sub processTransaction12 {
  my ($logLevel, $selfTest, $src, $dst, $event, $msg) = @_;

  if ($dst ne "OF") {
    print "OF test can ignore transaction for event $event, destination $dst \n";
    return 0;
  }

  print "IHE Transaction 12: \n";
  my $hl7Msg = "../../msgs/" . $msg;
  my $pid = mesa::getField($hl7Msg, "PID", "3", "0", "Patient ID");
  my $patientName = mesa::getField($hl7Msg, "PID", "5", "0", "Patient Name");

  print "MESA will send HL7 message ($msg) for event $event to $dst\n";
  my $x = <STDIN>;
  goodbye if ($x =~ /^q/);
  $x = mesa::send_hl7_log($logLevel, "../../msgs", $msg, $ofHostHL7, $ofPortHL7);
  mesa::xmit_error($msg) if ($x != 0);

  return 0;
}

sub processTransaction13 {
  my ($src, $dst, $event, $msg) = @_;

  my $hl7Msg = "../../msgs/" . $msg;
  my $pid               = mesa::getField($hl7Msg, "PID", "3", "0", "Patient ID");
  my $patientName       = mesa::getField($hl7Msg, "PID", "5", "0", "Patient Name");
  my $procedureCode     = mesa::getField($hl7Msg, "OBR", "4", "0", "Procedure Code");
  my $placerOrderNumber = mesa::getField($hl7Msg, "ORC", "2", "0", "Placer Order Number");


  print "\nIHE Transaction 13: $pid $patientName $procedureCode \n";
  print "DSS/OF is expected to send HL7 message to MESA IM ($host $mesaIMPortHL7) for event $event \n";
  print " Placer Order Number is $placerOrderNumber \n";
  print "Hit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  goodbye if ($x =~ /^q/);

  if ($selfTest == 1) {
    print "Looks like this is run directly for MESA testing; send order to MESA IM \n";
    $x = mesa::send_hl7("../../msgs", $msg, "localhost", $mesaIMPortHL7);
    mesa::xmit_error($msg) if ($x != 0);
  } else {
  }
  return 0;
}

sub processTransaction14 {
#  my $src = shift(@_);
#  my $dst = shift(@_);
#  my $event = shift(@_);
#  my $queryBase = shift(@_);
#  my $queryBaseMESA = $queryBase . "_mesa";
#
#  print "IHE Transaction 14: \n";
#  print "MESA will send CFIND message ($queryBase) for event $event to your $dst\n";
#  print "Hit <ENTER> when ready (q to quit) --> ";
#  my $x = <STDIN>;
#  goodbye if ($x =~ /^q/);
#
#
#  $x = "$MESA_TARGET/bin/dcm_create_object -i $queryBase.txt $queryBase.dcm";
#  print "$x\n";
#  print `$x`;
#  die "Unable to create C-Find command for $queryBase \n" if ($?);
#
#  mesa::delete_directory(1, $queryBase);
#  mesa::create_directory(1, $queryBase);
#
#  $x = mesa::send_cfind("$queryBase.dcm",
#		$imCFindAE, $imCFindHost, $imCFindPort,
#		$queryBase);
#  die "Unable to send C-Find command for $queryBase \n" if ($?);
#
## Repeat the process for queries to MESA Image Manager
#
#  mesa::delete_directory(1, $queryBaseMESA);
#  mesa::create_directory(1, $queryBaseMESA);
#
#  $x = mesa::send_cfind("$queryBase.dcm",
#		$imCFindAE, $imCFindHost, $imCFindPort,
#		$queryBaseMESA);
#  die "Unable to send C-Find command for $queryBaseMESA \n" if ($?);
  return 1;
}

# Report Submission
sub processTransaction24 {
  my ($logLevel, $selfTest, $src, $dst, $fileName) = @_;

if( 0) {
  print "\nIHE Transaction 24: \n" .
  "The MESA Report Creator ($mesa_rptcrtAE) will submit a report.\n" .
  "Skipping for now...\n";
} else {
  print "\nIHE Transaction 24: \n" .
  "The MESA Report Creator ($mesa_rptcrtAE) will submit a report.\n" .
  "Press <enter> when ready to continue or <q> to quit: ";
  my $x = <STDIN>;
  goodbye if ($x =~ /^q/);

  $deltaFile = "";
  $fileName = "../../msgs/" . $fileName;
print "$fileName, $rptmgr_AE, $rptmgr_Host, $rptmgr_Port\n";
  mesa::cstore_file($fileName,$deltaFile,$rptmgr_AE,$rptmgr_Host,$rptmgr_Port);
}

  return 0;
}

# Workitem claimed
sub processTransaction38 {
  my ($logLevel, $selfTest, $src, $dst, $rwlDir, $dcmMsg, $outDir) = @_;

  print "\nIHE Transaction 38: \n" .
  "The MESA Report Creator ($mesa_rptcrtAE) will send a GPSPS NACTION to\n" .
  "claim the workitem \n" .
  "Press <enter> when ready to continue or <q> to quit: ";
  my $x = <STDIN>;
  goodbye if ($x =~ /^q/);

  $resultDir = $outDir . "/test";
  $dcmMsg = "../../msgs/" . $dcmMsg;
  if ($MESA_OS eq "WINDOWS_NT") {
    $rwlDir =~ s(\/)(\\)g;
    $dcmMsg =~ s(\/)(\\)g;
    $resultDir =~ s(\/)(\\)g;
  }

  $test_spsSOPUID = rpt_mgr::getSOPUID($rwlDir . "/test/msg1_result.dcm");
  chomp $test_spsSOPUID;
  # print "test_spsSOPUID: " . $test_spsSOPUID . "\n";

  mesa::delete_directory($logLevel, $resultDir);
  mesa::create_directory($logLevel, $resultDir);

  $rtnVal = send_GPSPS_NACTION($mesa_rptcrtAE, $rptmgrRWL_AE, $rptmgrRWL_Host,
       $rptmgrRWL_Port,$test_spsSOPUID, $dcmMsg, $resultDir . "/rsp.txt");
  if( $rtnVal == 1) {
    print "\nFailed to claim workitem.\n";
    return 1;
  }
  # skip what would be the second workitem claim to MESA RPT MGR if we 
  # are self testing.
  if( $selfTest == 1) {return 0};

  print "\n" .
  "The MESA Report Creator ($mesa_rptcrtAE) will send a GPSPS NACTION to\n" .
  "the MESA Report Manager to claim the workitem \n" .
  "Press <enter> when ready to continue or <q> to quit: ";
  $x = <STDIN>;
  goodbye if ($x =~ /^q/);

  $mesa_spsSOPUID = rpt_mgr::getSOPUID($rwlDir . "/mesa/msg1_result.dcm");
  chomp $mesa_spsSOPUID;
  # print "mesa_spsSOPUID: " . $mesa_spsSOPUID . "\n";

  $resultDir = $outDir . "/mesa";
  mesa::delete_directory($logLevel, $resultDir);
  mesa::create_directory($logLevel, $resultDir);

  $rtnVal = send_GPSPS_NACTION($mesa_rptcrtAE, $mesa_rptmgrRWL_AE, $mesa_rptmgrRWL_Host,
       $mesa_rptmgrRWL_Port,$mesa_spsSOPUID, $dcmMsg, $resultDir . "/rsp.txt");
  if( $rtnVal == 1) {
    print "\nFailed to claim workitem.\n";
    return 1;
  }

  return 0;
}

sub send_GPSPS_NACTION {
  my ($srcAE, $dstAE, $dstHost, $dstPort, $sopuid, $dcmMsg, $outfile) = @_;

  if ($MESA_OS eq "WINDOWS_NT") {
    $dcmMsg =~ s(\/)(\\)g;
    $outfile =~ s(\/)(\\)g;
  }

  open OUTPUT, ">$outfile" or die "could not open file $outfile";

  $x = "$MESA_TARGET/bin/naction -a $srcAE -c $dstAE" .
       " $dstHost $dstPort GPSPS " .
       " $dcmMsg $sopuid";
  if( $MESA_OS eq "WINDOWS_NT") {
     $x =~ s(\/)(\\)g;
  }
   print "$x\n";
   # print `$x`;
   print OUTPUT `$x`;

  close OUTPUT;

  open INPUT, "<$outfile" or die "could not open file $outfile for reading.";
  while( $line = <INPUT>) {
    if( $line =~ "Successful operation") {
        close INPUT;
        return 0;
    }
  }
  close INPUT;
  return 1;
}

# Workitem completed
sub processTransaction41 {
  my ($logLevel, $selfTest, $src, $dst, $rwlDir, $dcmMsg, $outDir) = @_;

  print "\nIHE Transaction 41: \n" .
  "The MESA Report Creator ($mesa_rptcrtAE) will send a GPSPS NACTION to\n" .
  "complete the workitem \n" .
  "Press <enter> when ready to continue or <q> to quit: ";
  my $x = <STDIN>;
  goodbye if ($x =~ /^q/);

  $resultDir = $outDir . "/test";
  $dcmMsg = "../../msgs/" . $dcmMsg;
  if ($MESA_OS eq "WINDOWS_NT") {
    $rwlDir =~ s(\/)(\\)g;
    $dcmMsg =~ s(\/)(\\)g;
    $resultDir =~ s(\/)(\\)g;
  }

  $test_spsSOPUID = rpt_mgr::getSOPUID($rwlDir . "/test/msg1_result.dcm");
  chomp $test_spsSOPUID;
  # print "test_spsSOPUID: " . $test_spsSOPUID . "\n";

  mesa::delete_directory($logLevel, $resultDir);
  mesa::create_directory($logLevel, $resultDir);

  $rtnVal = send_GPSPS_NACTION($mesa_rptcrtAE, $rptmgrRWL_AE, $rptmgrRWL_Host,
       $rptmgrRWL_Port,$test_spsSOPUID, $dcmMsg, $resultDir . "/rsp.txt");
  if( $rtnVal == 1) {
    print "\nFailed to set SPS complete.\n";
    return 1;
  }

  # skip what would be the second workitem claim to MESA RPT MGR if we 
  # are self testing.
  if( $selfTest == 1) {return 0};

  print "\n" .
  "The MESA Report Creator ($mesa_rptcrtAE) will send a GPSPS NACTION to\n" .
  "the MESA Report Manager to complete the workitem \n" .
#  "Press <enter> when ready to continue or <q> to quit: ";
#  $x = <STDIN>;
#  goodbye if ($x =~ /^q/);

  $mesa_spsSOPUID = rpt_mgr::getSOPUID($rwlDir . "/mesa/msg1_result.dcm");
  chomp $mesa_spsSOPUID;
  # print "mesa_spsSOPUID: " . $mesa_spsSOPUID . "\n";

  $resultDir = $outDir . "/mesa";
  mesa::delete_directory($logLevel, $resultDir);
  mesa::create_directory($logLevel, $resultDir);

  $rtnVal = send_GPSPS_NACTION($mesa_rptcrtAE, $mesa_rptmgrRWL_AE, $mesa_rptmgrRWL_Host,
       $mesa_rptmgrRWL_Port,$mesa_spsSOPUID, $dcmMsg, $resultDir . "/rsp.txt");
  if( $rtnVal == 1) {
    print "\nFailed to set SPS complete.\n";
    return 1;
  }

  return 0;
}

# Workitem PPS in progress
sub processTransaction39 {
  my ($logLevel, $selfTest, $src, $dst, $procName, $rwlDir, $dcmMsg, $outDir) = @_;
  # procName Identifies which PPS is being created.
  # rwlDir   Root of path to file containing the GP SPS SOP UID file.
  # outDir   Root of path to directory for storage of generated pps object
  #          and text file with pps's sop instance UID
  # dcmMsg   Name of pps template object.

  print "\nIHE Transaction 39: \n" .
  "The MESA Report Creator ($mesa_rptcrtAE) will send a GPPPS NCREATE to\n" .
  "create the performed procedure step ($procName) in progress.\n" .
  "Press <enter> when ready to continue or <q> to quit: ";
  my $x = <STDIN>;
  goodbye if ($x =~ /^q/);

  $resultDir = $outDir . "/test";
  $msgFile = $resultDir . "/ppscreate.dcm";
  $dcmMsg = "../../msgs/" . $dcmMsg;

  $test_spsSOPUID = rpt_mgr::getSOPUID($rwlDir . "/test/msg1_result.dcm");
  chomp $test_spsSOPUID;
  print "test_spsSOPUID: " . $test_spsSOPUID . "\n";

  mesa::delete_directory($logLevel, $resultDir);
  mesa::create_directory($logLevel, $resultDir);

  $x = "$MESA_TARGET/bin/ppm_sched_gppps -s $test_spsSOPUID " .
       " -t $dcmMsg -o $msgFile " .
       " -i $resultDir/gppps_sopuid.txt ordfil ordfil";
  if( $MESA_OS eq "WINDOWS_NT") {
     $x =~ s(\/)(\\)g;
  }
  print "$x\n";
  print `$x`;

  $gppps_sopuid = rpt_mgr::getSOPUID($msgFile);
  chomp $gppps_sopuid;
  print "gppps_sopuid: " . $gppps_sopuid . "\n";

  $rtnVal = send_ppsCreate($mesa_rptcrtAE, $rptmgrRWL_AE, $rptmgrRWL_Host,
       $rptmgrRWL_Port,$gppps_sopuid, $msgFile, $resultDir . "/rsp.txt");
  if( $rtnVal == 1) {
    print "\nFailed to create PPS.\n";
    return 1;
  }

  # skip what would be the second PPS in-progress to MESA RPT MGR if we 
  # are self testing.
  if( $selfTest == 1) { return 0;}

  print "\n" .
  "The MESA Report Creator ($mesa_rptcrtAE) will send a GPPPS NCREATE to\n" .
  "the MESA Report Manager to create the performed procedure step \n" .
  "($procName) in progress.\n" .
  "Press <enter> when ready to continue or <q> to quit: ";
  $x = <STDIN>;
  goodbye if ($x =~ /^q/);

  $resultDir = $outDir . "/mesa";
  $msgFile = $resultDir . "/ppscreate.dcm";
  if ($MESA_OS eq "WINDOWS_NT") {
    $msgFile =~ s(\/)(\\)g;
    $resultDir =~ s(\/)(\\)g;
  }

  $mesa_spsSOPUID = rpt_mgr::getSOPUID($rwlDir . "/mesa/msg1_result.dcm");
  chomp $mesa_spsSOPUID;
  print "mesa_spsSOPUID: " . $mesa_spsSOPUID . "\n";

  mesa::delete_directory($logLevel, $resultDir);
  mesa::create_directory($logLevel, $resultDir);

  $x = "$MESA_TARGET/bin/ppm_sched_gppps -s $mesa_spsSOPUID " .
       " -t $dcmMsg -o $msgFile " .
       " -i $resultDir/gppps_sopuid.txt ordfil ordfil";
  if( $MESA_OS eq "WINDOWS_NT") {
     $x =~ s(\/)(\\)g;
  }
  print "$x\n";
  print `$x`;

  $gppps_sopuid = rpt_mgr::getSOPUID($msgFile);
  chomp $gppps_sopuid;
  print "gppps_sopuid: " . $gppps_sopuid . "\n";

  $rtnVal = send_ppsCreate($mesa_rptcrtAE, $mesa_rptmgrRWL_AE, $mesa_rptmgrRWL_Host,
       $mesa_rptmgrRWL_Port,$gppps_sopuid, $msgFile, $resultDir . "/rsp.txt");
  if( $rtnVal == 1) {
    print "\nFailed to create PPS.\n";
    return 1;
  }

  return 0;
}

# Performed Work Status Update
# 42a is the PPS Ncreate.
sub processTransaction42a {
  my ($logLevel, $selfTest, $src, $dst, $procName, $dcmMsg, $outDir) = @_;
  # logLevel
  # selfTest
  # src       Actor that is source of update message. This is ignored
  #           Actual value is created from config file in variable
  #           $rptmgr_AE
  # dst       Actor that is destination of update message.  This is ignored.
  #           Actual values are created from config file in variables
  #           $update_AE, $update_Port
  # procName  Name of performed procedure for this message. Ignored.
  # dcmMsg    Path to gppps ncreate message.
  # outDir    Root of path to files recording the response to the ncreate
  #           message.
  #
  #           Ignored arguments were kept so this transaction's definition 
  #           matches its corresponding transaction 39.

  print "\nIHE Transaction 42: \n" .
  "Report Manager ($rptmgr_AE) should send a Performed Work Status Update\n" .
  "(GPPPS NCREATE) to the MESA system at ($update_AE, $update_Port)\n" .
  "to indicate the performed procedure step in progress.\n" .
  "Press <enter> when ready to continue or <q> to quit: ";
  my $x = <STDIN>;
  goodbye if ($x =~ /^q/);

  $resultDir = $outDir . "/test";
  $msgFile = $resultDir . "/ppscreate.dcm";
  $dcmMsg = "../../msgs/" . $dcmMsg;
  if ($MESA_OS eq "WINDOWS_NT") {
    $dcmMsg =~ s(\/)(\\)g;
    $resultDir =~ s(\/)(\\)g;
  }

  $gppps_sopuid = rpt_mgr::getSOPUID($msgFile);
  chomp $gppps_sopuid;
  print "gppps_sopuid: " . $gppps_sopuid . "\n";

  $rtnVal = send_ppsCreate($mesa_rptmgrRWL_AE, $update_AE, "localhost",
       $update_Port, $gppps_sopuid, $msgFile, $resultDir . "/rsp.txt");
  if( $rtnVal == 1) {
    print "\nMESA RPT MGR Failed to send Performed Work Status update (Ncreate).\n";
    return 1;
  }

  # The RPTMG under test sends Work Status update.
  # skip this if we are not self testing.
  if( $selfTest == 0) { return 0;}

  $rtnVal = send_ppsCreate($rptmgr_AE, $update_AE, "localhost",
       $update_Port, $gppps_sopuid, $msgFile, $resultDir . "/rsp.txt");
  if( $rtnVal == 1) {
    print "\nMESA RPTMGR Failed to send Work Status Update (Ncreate) for selftest.\n";
    return 1;
  }

  return 0;
}

# Performed Work Status Update
# 42a is the PPS Ncreate.
#sub processTransaction42a {
#  my ($logLevel, $selfTest, $src, $dst, $procName, $dcmMsg, $outDir) = @_;
#
#  print "\nIHE Transaction 42: \n" .
#  "Report Manager ($rptmgr_AE) should send a Performed Work Status Update\n" .
#  "(GPPPS NCREATE) to the MESA Image Manager ($mesaIM_AE, $mesaIMPortDICOM)\n" .
#  "to indicate the performed procedure step in progress.\n" .
#  "Press <enter> when ready to continue or <q> to quit: ";
#  my $x = <STDIN>;
#  goodbye if ($x =~ /^q/);
#
#  $resultDir = $outDir . "/test";
#  $msgFile = $resultDir . "/ppscreate.dcm";
#  $dcmMsg = "../../msgs/" . $dcmMsg;
#  if ($MESA_OS eq "WINDOWS_NT") {
#    $dcmMsg =~ s(\/)(\\)g;
#    $resultDir =~ s(\/)(\\)g;
#  }
#
#  $gppps_sopuid = rpt_mgr::getSOPUID($msgFile);
#  chomp $gppps_sopuid;
#  print "gppps_sopuid: " . $gppps_sopuid . "\n";
#
#  $rtnVal = send_ppsCreate($mesa_rptmgrRWL_AE, $mesaIM_AE, "localhost",
#       $mesaIMPortDICOM, $gppps_sopuid, $msgFile, $resultDir . "/rsp.txt");
#  if( $rtnVal == 1) {
#    print "\nMESA RPT MGR Failed to send Performed Work Status update (Ncreate).\n";
#    return 1;
#  }
#
#  # The RPTMG under test sends Work Status update.
#  # skip this if we are not self testing.
#  if( $selfTest == 0) { return 0;}
#
#  $rtnVal = send_ppsCreate($rptmgr_AE, $mesaIM_AE, "ordfil",
#       $mesaIMPortDICOM, $gppps_sopuid, $msgFile, $resultDir . "/rsp.txt");
#  if( $rtnVal == 1) {
#    print "\nMESA RPTMGR Failed to send Work Status Update (Ncreate) for selftest.\n";
#    return 1;
#  }
#
#  return 0;
#}

sub send_ppsCreate {
  my ($srcAE, $dstAE, $dstHost, $dstPort, $sopuid, $dcmMsg, $outfile) = @_;

  if ($MESA_OS eq "WINDOWS_NT") {
    $dcmMsg =~ s(\/)(\\)g;
    $outfile =~ s(\/)(\\)g;
  }

  open OUTPUT, ">$outfile" or die "could not open file $outfile";

  $x = "$MESA_TARGET/bin/ncreate -a $srcAE -c $dstAE" .
         " $dstHost $dstPort gppps $dcmMsg $sopuid";
  if( $MESA_OS eq "WINDOWS_NT") {
     $x =~ s(\/)(\\)g;
  }
   print "$x\n";
   # print `$x`;
   print OUTPUT `$x`;

  close OUTPUT;

  open INPUT, "<$outfile" or die "could not open file $outfile for reading.";
  while( $line = <INPUT>) {
    if( $line =~ "Successful operation") {
        close INPUT;
        return 0;
    }
  }
  close INPUT;
  return 1;
}

# Workitem PPS completed
sub processTransaction40 {
  my ($logLevel, $selfTest, $src, $dst, $procName, $setMsg, $outDir) = @_;

  print "\nIHE Transaction 40: \n" .
  "The MESA Report Creator ($mesa_rptcrtAE) will send a GPPPS NSET to\n" .
  "update the performed procedure step ($procName).\n" .
  "Press <enter> when ready to continue or <q> to quit: ";
  my $x = <STDIN>;
  goodbye if ($x =~ /^q/);

  $resultDir = $outDir . "/test";
  $crtMsg = $resultDir . "/ppscreate.dcm";
  $setMsg = "../../msgs/" . $setMsg;
  if ($MESA_OS eq "WINDOWS_NT") {
    $crtMsg =~ s(\/)(\\)g;
    $setMsg =~ s(\/)(\\)g;
    $resultDir =~ s(\/)(\\)g;
  }

  $test_ppsSOPUID = rpt_mgr::getSOPUID($crtMsg);
  chomp $test_ppsSOPUID;
  print "test_ppsSOPUID: " . $test_ppsSOPUID . "\n";

  $rtnVal = send_ppsSet($mesa_rptcrtAE, $rptmgrRWL_AE, $rptmgrRWL_Host,
       $rptmgrRWL_Port,$test_ppsSOPUID, $setMsg, $resultDir . "/set_rsp.txt");
  if( $rtnVal == 1) {
    print "\nFailed to create PPS.\n";
    return 1;
  }

  # skip what would be the second gppps set to MESA RPT MGR if we 
  # are self testing.
  if( $selfTest == 1) { return 0;}

  print "\n" .
  "The MESA Report Creator ($mesa_rptcrtAE) will send a GPPPS NSET to\n" .
  "the MESA Report Manager to update the performed procedure step \n" .
  "($procName).\n" .
  "Press <enter> when ready to continue or <q> to quit: ";
  $x = <STDIN>;
  goodbye if ($x =~ /^q/);

  $resultDir = $outDir . "/mesa";
  $crtMsg = $resultDir . "/ppscreate.dcm";
  if ($MESA_OS eq "WINDOWS_NT") {
    $crtMsg =~ s(\/)(\\)g;
    $resultDir =~ s(\/)(\\)g;
  }

  $mesa_ppsSOPUID = rpt_mgr::getSOPUID($crtMsg);
  chomp $mesa_ppsSOPUID;
  print "mesa_ppsSOPUID: " . $mesa_ppsSOPUID . "\n";

  $rtnVal = send_ppsSet($mesa_rptcrtAE,$mesa_rptmgrRWL_AE, $mesa_rptmgrRWL_Host,
       $mesa_rptmgrRWL_Port,$mesa_ppsSOPUID, $setMsg, $resultDir . "/set_rsp.txt");
  if( $rtnVal == 1) {
    print "\nFailed to create PPS.\n";
    return 1;
  }

  return 0;
}

## Performed Work Status Update
## 42b is the PPS Nset.
#sub processTransaction42b {
#  my ($logLevel, $selfTest, $src, $dst, $procName, $setMsg, $outDir) = @_;
#
#  print "\nIHE Transaction 42: \n" .
#  "Report Manager ($rptmgr_AE) should send a Performed Work Status Update\n" .
#  "(GPPPS NSET) to the MESA Image Manager ($mesaIM_AE, $mesaIMPortDICOM)\n" .
#  "to indicate the performed procedure step completed.\n" .
#  "Press <enter> when ready to continue or <q> to quit: ";
#  my $x = <STDIN>;
#  goodbye if ($x =~ /^q/);
#
#  $resultDir = $outDir . "/test";
#  $crtMsg = $resultDir . "/ppscreate.dcm";
#  $setMsg = "../../msgs/" . $setMsg;
#  if ($MESA_OS eq "WINDOWS_NT") {
#    $crtMsg =~ s(\/)(\\)g;
#    $setMsg =~ s(\/)(\\)g;
#    $resultDir =~ s(\/)(\\)g;
#  }
#
#  $test_ppsSOPUID = rpt_mgr::getSOPUID($crtMsg);
#  chomp $test_ppsSOPUID;
#  print "test_ppsSOPUID: " . $test_ppsSOPUID . "\n";
#
#  $rtnVal = send_ppsSet($mesa_rptmgrRWL_AE, $mesaIM_AE, "localhost",
#       $mesaIMPortDICOM, $test_ppsSOPUID, $setMsg, $resultDir . "/rsp.txt");
#  if( $rtnVal == 1) {
#    print "\nMESA RPT MGR Failed to send Performed Work Status update (Nset).\n";
#    return 1;
#  }
#
#  # The RPTMG under test sends Work Status update.
#  # skip this if we are not self testing.
#  if( $selfTest == 0) { return 0;}
#
#  $rtnVal = send_ppsSet($rptmgr_AE, $mesaIM_AE, "ordfil",
#       $mesaIMPortDICOM, $test_ppsSOPUID, $setMsg, $resultDir . "/rsp.txt");
#  if( $rtnVal == 1) {
#    print "\nMESA RPTMGR Failed to send Work Status Update (Nset) for selftest.\n";
#    return 1;
#  }
#
#  return 0;
#}

# Performed Work Status Update
# 42b is the PPS Nset.
sub processTransaction42b {
  my ($logLevel, $selfTest, $src, $dst, $procName, $setMsg, $outDir) = @_;
  # logLevel
  # selfTest
  # src       Actor that is source of update message. This is ignored
  #           Actual value is created from config file in variable
  #           $rptmgr_AE
  # dst       Actor that is destination of update message.  This is ignored.
  #           Actual values are created from config file in variables
  #           $update_AE, $update_Port
  # procName  Name of performed procedure for this message. Ignored.
  # setMsg    Path to gppps nset message.
  # outDir    Root of path to files recording the response to the ncreate
  #           message.
  #
  #           Ignored arguments were kept so this transaction's definition 
  #           matches its corresponding transaction 40.

  print "\nIHE Transaction 42: \n" .
  "Report Manager ($rptmgr_AE) should send a Performed Work Status Update\n" .
  "(GPPPS NSET) to the MESA system at ($update_AE, $update_Port)\n" .
  "to indicate the performed procedure step completed.\n" .
  "Press <enter> when ready to continue or <q> to quit: ";
  my $x = <STDIN>;
  goodbye if ($x =~ /^q/);

  $resultDir = $outDir . "/test";
  $crtMsg = $resultDir . "/ppscreate.dcm";
  $setMsg = "../../msgs/" . $setMsg;
  if ($MESA_OS eq "WINDOWS_NT") {
    $crtMsg =~ s(\/)(\\)g;
    $setMsg =~ s(\/)(\\)g;
    $resultDir =~ s(\/)(\\)g;
  }

  $test_ppsSOPUID = rpt_mgr::getSOPUID($crtMsg);
  chomp $test_ppsSOPUID;
  print "test_ppsSOPUID: " . $test_ppsSOPUID . "\n";

  $rtnVal = send_ppsSet($mesa_rptmgrRWL_AE, $update_AE, "localhost",
       $update_Port, $test_ppsSOPUID, $setMsg, $resultDir . "/rsp.txt");
  if( $rtnVal == 1) {
    print "\nMESA RPT MGR Failed to send Performed Work Status update (Nset).\n";
    return 1;
  }

  # The RPTMG under test sends Work Status update.
  # skip this if we are not self testing.
  if( $selfTest == 0) { return 0;}

  $rtnVal = send_ppsSet($rptmgr_AE, $update_AE, "localhost",
       $update_Port, $test_ppsSOPUID, $setMsg, $resultDir . "/rsp.txt");
  if( $rtnVal == 1) {
    print "\nMESA RPTMGR Failed to send Work Status Update (Nset) for selftest.\n";
    return 1;
  }

  return 0;
}

sub send_ppsSet {
  my ($srcAE, $dstAE, $dstHost, $dstPort, $sopuid, $dcmMsg, $outfile) = @_;

  if ($MESA_OS eq "WINDOWS_NT") {
    $dcmMsg =~ s(\/)(\\)g;
    $outfile =~ s(\/)(\\)g;
  }

  open OUTPUT, ">$outfile" or die "could not open file $outfile";

  $x = "$MESA_TARGET/bin/nset -a $srcAE -c $dstAE" .
         " $dstHost $dstPort gppps $dcmMsg $sopuid";
  if( $MESA_OS eq "WINDOWS_NT") {
     $x =~ s(\/)(\\)g;
  }
   print "$x\n";
   # print `$x`;
   print OUTPUT `$x`;

  close OUTPUT;

  open INPUT, "<$outfile" or die "could not open file $outfile for reading.";
  while( $line = <INPUT>) {
    if( $line =~ "Successful operation") {
        close INPUT;
        return 0;
    }
  }
  close INPUT;
  return 1;
}

# Reporting Worklist Provided
sub processTransaction46 {
  my ($logLevel, $selfTest, $src, $dst, $dcmMsg, $outDir) = @_;

  print "\nIHE Transaction 46: \n";
  print "MESA will query for Reporting worklist.\n" .
  "Press <enter> when ready to continue or <q> to quit: ";
  my $x = <STDIN>;
  goodbye if ($x =~ /^q/);

  $dcmMsg = "../../msgs/" . $dcmMsg;
  $resultsDir = $outDir . "/test";
  $resultsDirMESA = $outDir . "/mesa";
  if ($MESA_OS eq "WINDOWS_NT") {
    $resultsDir =~ s(\/)(\\)g;
    $resultsDirMESA =~ s(\/)(\\)g;
  }

print "resultsDir: $resultsDir, resultsDirMesa: $resultsDirMESA\n";

  mesa::delete_directory($logLevel, $resultsDir);
  mesa::delete_directory($logLevel, $resultsDirMESA);

  mesa::create_directory($logLevel, $resultsDir);
  mesa::create_directory($logLevel, $resultsDirMESA);

  $x = "$MESA_TARGET/bin/cfind -a MODALITY1 -c $rptmgrRWL_AE" .
       " -f $dcmMsg -o $resultsDir" .
       " -x GPWL $rptmgrRWL_Host $rptmgrRWL_Port";
  if( $MESA_OS eq "WINDOWS_NT") {
     $x =~ s(\/)(\\)g;
  }
   print "$x\n";
   print `$x`;

  $x = "$MESA_TARGET/bin/cfind -a MODALITY1 -c $mesa_rptmgrRWL_AE" .
       " -f $dcmMsg -o $resultsDirMESA" .
       " -x GPWL $mesa_rptmgrRWL_Host $mesa_rptmgrRWL_Port";
  if( $MESA_OS eq "WINDOWS_NT") {
     $x =~ s(\/)(\\)g;
  }
   print "$x\n";
   print `$x`;

  return 0;
}


sub processTransaction {
  my $cmd = shift(@_);
  my $logLevel = shift(@_);
  my $selfTest = shift(@_);
  my @tokens = split /\s+/, $cmd;
  my $verb = $tokens[0];
  my $trans= $tokens[1];

  my $rtnValue = 0;

  if ($trans eq "1") {
    shift (@tokens); shift (@tokens);
    $rtnValue = processTransaction1($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "2") {
    shift (@tokens); shift (@tokens);
    $rtnValue = processTransaction2($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "3") {
    shift (@tokens); shift (@tokens);
    $rtnValue = processTransaction3($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "4a") {
    shift (@tokens); shift (@tokens);
    $rtnValue = processTransaction4a($logLevel, @tokens);
  } elsif ($trans eq "4") {
    shift (@tokens); shift (@tokens);
    $rtnValue = processTransaction4($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "5") {
    shift (@tokens); shift (@tokens);
    $rtnValue = processTransaction5($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "6") {
    shift (@tokens); shift (@tokens);
    $rtnValue = processTransaction6(@tokens);
  } elsif ($trans eq "7") {
    shift (@tokens); shift (@tokens);
    $rtnValue = processTransaction7(@tokens);
  } elsif ($trans eq "8") {
    shift (@tokens); shift (@tokens);
    $rtnValue = processTransaction8(@tokens);
  } elsif ($trans eq "10") {
    shift (@tokens); shift (@tokens);
    $rtnValue = processTransaction10(@tokens);
  } elsif ($trans eq "12") {
    shift (@tokens); shift (@tokens);
    $rtnValue = processTransaction12($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "13") {
    shift (@tokens); shift (@tokens);
    $rtnValue = processTransaction13(@tokens);
  } elsif ($trans eq "14") {
    shift (@tokens); shift (@tokens);
    $rtnValue = processTransaction14(@tokens);
  } elsif ($trans eq "24") {
    shift (@tokens); shift (@tokens);
    $rtnValue = processTransaction24($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "38") {
    shift (@tokens); shift (@tokens);
    $rtnValue = processTransaction38($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "39") {
    shift (@tokens); shift (@tokens);
    $rtnValue = processTransaction39($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "40") {
    shift (@tokens); shift (@tokens);
    $rtnValue = processTransaction40($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "41") {
    shift (@tokens); shift (@tokens);
    $rtnValue = processTransaction41($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "42a") {
    shift (@tokens); shift (@tokens);
    $rtnValue = processTransaction42a($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "42b") {
    shift (@tokens); shift (@tokens);
    $rtnValue = processTransaction42b($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "46") {
    shift (@tokens); shift (@tokens);
    $rtnValue = processTransaction46($logLevel, $selfTest, @tokens);
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

sub printTextFile {
  my $txtFile = shift(@_);

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

sub schedule_gpwl {
  my $cmd = shift(@_);
  my @tokens = split /\s+/, $cmd;

  my $promptFile = $tokens[1];
  my $gpspsFile  = "../../msgs/" . $tokens[2];
  my $msg  = $tokens[3];

  my $hl7Msg = "../../msgs/" . $msg;
  my $pid         = mesa::getField($hl7Msg, "PID", "3", "0", "Patient ID");
  my $patientName = mesa::getField($hl7Msg, "PID", "5", "0", "Patient Name");
  my $procCode    = mesa::getField($hl7Msg, "OBR", "4", "0", "Procedure Code");
  my $plaOrdNum = mesa::getField($hl7Msg, "ORC", "2", "0", "Placer Order Number");
  print "Please schedule the following work item and MESA will do the \n";
  print "same internally.\n";
  printTextFile("../common/" . $promptFile);
  mesa::local_scheduling_gpworkitem( $plaOrdNum, $procCode, $gpspsFile, "ordfil");
  return 0;
}

sub processOneLine {
  my $cmd  = shift(@_);
  my $logLevel  = shift(@_);
  my $selfTest  = shift(@_);
  my @verb = split /\s+/, $cmd;
  my $rtnValue = 0;
#  print "$verb[0] \n";

  if ($verb[0] eq "TRANSACTION") {
    $rtnValue = processTransaction($cmd, $logLevel, $selfTest);
  } elsif ($verb[0] eq "TEXT") {
    printText($cmd);
  } elsif ($verb[0] eq "SCHEDULE_GPWL") {
    schedule_gpwl($cmd);
  } elsif ($verb[0] eq "PATIENT") {
    printPatient($cmd);
  } elsif (substr($verb[0], 0, 1) eq "#") {
    print "Comment: $cmd \n";
  } else {
    die "Did not recognize verb in command: $cmd \n";
  }
  return $rtnValue;
}

# Main starts here

if (scalar(@ARGV) < 2) {
  print "Usage: <test file> <output level: 0-4>\n";
  exit(1);
}

$host = `hostname`; chomp $host;

%varnames = mesa::get_config_params("rptmgr_test.cfg");
if (rpt_mgr::test_var_names(%varnames) != 0) {
  print "Some problem with the variables in rptmgr_test.cfg\n";
  exit 1;
}

$ofHostHL7 = $varnames{"TEST_HL7_HOST"};
$ofPortHL7 = $varnames{"TEST_HL7_PORT"};
$mwlAE     = $varnames{"TEST_MWL_AE"};
$mwlHost   = $varnames{"TEST_MWL_HOST"};
$mwlPort   = $varnames{"TEST_MWL_PORT"};
$mppsAE    = $varnames{"TEST_MPPS_AE"};
$mppsHost  = $varnames{"TEST_MPPS_HOST"};
$mppsPort  = $varnames{"TEST_MPPS_PORT"};
$rptmgrRWL_AE  = $varnames{"TEST_RPT_MGR_RWL_AE"};
$rptmgrRWL_Host  = $varnames{"TEST_RPT_MGR_RWL_HOST"};
$rptmgrRWL_Port  = $varnames{"TEST_RPT_MGR_RWL_PORT"};
#$rptmgr_AE  = $varnames{"TEST_RPT_MGR_AE"};
#$rptmgr_Host  = $varnames{"TEST_RPT_MGR_HOST"};
#$rptmgr_Port  = $varnames{"TEST_RPT_MGR_PORT"};
$rptmgr_AE  = $varnames{"TEST_MANAGER_AE"};
$rptmgr_Host  = $varnames{"TEST_MANAGER_HOST"};
$rptmgr_Port  = $varnames{"TEST_MANAGER_PORT"};
$update_AE  = $varnames{"MESA_UPDATE_AE"};
$update_Port  = $varnames{"MESA_UPDATE_PORT"};

$mesaOrderFillerPortHL7 = $varnames{"MESA_ORD_FIL_PORT_HL7"};
$mesaOrderPlacerPortHL7 = $varnames{"MESA_ORD_PLC_PORT_HL7"};
$mesaIMPortHL7 = $varnames{"MESA_IMG_MGR_PORT_HL7"};
$mesaIMPortDICOM = $varnames{"MESA_IMG_MGR_PORT_DCM"};
#$mesaIM_AE = $varnames{"MESA_IMG_MGR_AE"};
$mesa_rptmgrRWL_AE  = $varnames{"MESA_RPT_MGR_RWL_AE"};
$mesa_rptmgrRWL_Host  = $varnames{"MESA_RPT_MGR_RWL_HOST"};
$mesa_rptmgrRWL_Port  = $varnames{"MESA_RPT_MGR_RWL_PORT"};
# $mesa_rptmgrAE  = $varnames{"MESA_RPT_MGR_AE"};
# $mesa_rptmgrHost  = $varnames{"MESA_RPT_MGR_HOST"};
# $mesa_rptmgrPort  = $varnames{"MESA_RPT_MGR_PORT"};
# $mesa_rptrepAE  = $varnames{"MESA_RPT_REP_AE"};
# $mesa_rptrepHost  = $varnames{"MESA_RPT_REP_HOST"};
# $mesa_rptrepPort  = $varnames{"MESA_RPT_REP_PORT"};
$mesa_rptcrtAE  = $varnames{"MESA_RPT_CRT_AE"};

print `perl scripts/reset_servers.pl`;
die "Could not reset servers" if ($?);

open TESTFILE, $ARGV[0] or die "Could not open: $ARGV[0]\n";
$logLevel = $ARGV[1];
$selfTest = 0;
if (scalar(@ARGV) > 2) {
  $selfTest = 1;
}

while ($l = <TESTFILE>) {
  chomp $l;
  $v = processOneLine($l, $logLevel, $selfTest);
  die "Could not process line $l" if ($v != 0);
}
close TESTFILE;

goodbye;
