#!/usr/local/bin/perl -w

# Runs the Order Filler scripts interactively

use Env;
use lib "scripts";
use lib "../../../rad/actors/ordfil/scripts";
require ordfil;
require ordfil_workflow;

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

sub processTransaction2 {
  my ($logLevel, $selfTest, $src, $dst, $event, $msg, $testFillerORM) = @_;

  my $hl7Msg = "../../msgs/" . $msg;
  my $pid               = mesa::getField($hl7Msg, "PID", "3", "0", "Patient ID");
  my $patientName       = mesa::getField($hl7Msg, "PID", "5", "0", "Patient Name");
  my $procedureCode     = mesa::getField($hl7Msg, "OBR", "4", "0", "Procedure Code");
  my $placerOrderNumber = mesa::getField($hl7Msg, "ORC", "2", "0", "Placer Order Number");

  print "\nIHE Transaction 2: $pid $patientName $procedureCode \n";
  print "MESA will now send ORM^O01 message ($msg) to your Order Filler ($ofHostHL7 $ofPortHL7) \n" if ($event eq "ORDER");
  print "MESA will now send OOR^O02 message ($msg) to your Order Filler ($ofHostHL7 $ofPortHL7) \n" if ($event eq "ORDER_O02");
  if ($event eq "ORDER_O02") {
    print "Update O02: $MESA_STORAGE/$testFillerORM $hl7Msg \n" if ($logLevel >= 3);
    mesa::update_O02($logLevel, $hl7Msg, "$MESA_STORAGE/$testFillerORM");
  }
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
  my $inputORM = "$MESA_STORAGE/ordplc/1001.hl7";
  if (!-e $inputORM) {
    print "This script expected you to send an HL7 message to the MESA Order Placer.\n";
    print " We find no such message in $MESA_STORAGE/ordplc and must exit.\n";
    return 1;
  }
  mesa::update_O02($logLevel, $hl7Msg, $inputORM);

  print "\nIHE Transaction 3: $pid $patientName \n";
  print "MESA will now send O02 message back to your Order Filler. It should\n";
  print " have an updated Placer Order Number for you.\n";
  print " Placer Order number is $placerOrderNumber \n";
  print "Hit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  goodbye if ($x =~ /^q/);

  $x = mesa::send_hl7_log($logLevel, "../../msgs", $msg, $ofHostHL7, $ofPortHL7);
  mesa::xmit_error($msg) if ($x != 0);
}

sub transaction3_OP {
  my ($logLevel, $selfTest, $src, $dst, $event, $msg, $extraOrder) = @_;
  my $hl7Msg = "../../msgs/" . $msg;
  my $pid               = mesa::getField($hl7Msg, "PID", "3", "0", "Patient ID");
  my $patientName       = mesa::getField($hl7Msg, "PID", "5", "0", "Patient Name");
  my $placerOrderNumber = mesa::getField($hl7Msg, "ORC", "2", "0", "Placer Order Number");

  print "\nIHE Transaction 3: $pid $patientName \n";
  print "DSS/OF is expected to send HL7 message to MESA Order Placer ($host $mesaOrderPlacerPortHL7) for event $event \n";
  print " MESA sample status message is found in $hl7Msg\n";
  print " Placer Order number is $placerOrderNumber \n" if (($event eq "CANCEL") || ($event eq "STATUS"));
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
    $x = mesa::send_hl7_log($logLevel, "../../msgs", $msg, "localhost", $mesaOrderFillerPortHL7);
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


# This is for post scheduling. The images have been created.
# We need to update our scheduling message.

sub processTransaction4b {
  my ($src, $dst, $event, $msg, $outputDir, $inputDir, $SPSCode, $PPSCode)  = @_;

  my $hl7Msg = "../../msgs/" . $msg;
  my $pid           = mesa::getField($hl7Msg, "PID", "3", "1", "Patient ID");
  my $patientName   = mesa::getField($hl7Msg, "PID", "5", "0", "Patient Name");
  my $procedureCode = mesa::getField($hl7Msg, "OBR", "4", "1", "Procedure Code");
  my $modality      = mesa::getField($hl7Msg, "OBR", "24", "1", "Service Sector ID");

  print "This is the POST scheduling operation for transaction 4\n";
  print "Your DSS/OF should schedule SPS step(s) for $patientName\n";
  print " The procedure code is $procedureCode, the modality should be $modality\n";
  print "Hit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  goodbye if ($x =~ /^q/);

  print "PID: $pid Name: $patientName Code: $procedureCode \n";

  my $modalityDir = "$MESA_STORAGE/modality/" . $outputDir;
  my $accessionNum = "ACC";
  my $requestedProcedureID = "REQPROID";
  my $scheduledProcedureStepID = "SPSID";
  $x = mesa::update_scheduling_ORM_post_procedure($logLevel, $hl7Msg, $modalityDir, $accessionNum, $requestedProcedureID, $scheduledProcedureStepID);
  print "Unable to update the scheduling message with post procedure data\n" if ($x != 0);
 
  return $x;
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

  print "About to send MWL query to test system.\n" if ($logLevel >= 3);
  $x = mesa::send_cfind_mwl($logLevel, "mwl/mwlquery_pid.dcm",
	$mwlAE, $mwlHost, $mwlPort, $outDir . "/test");
  return 1 if ($x != 0);

  print "About to send MWL query to MESA system.\n" if ($logLevel >= 3);
  $x = mesa::send_cfind_mwl($logLevel, "mwl/mwlquery_pid.dcm",
	$mwlAE, "localhost", $mesaOFPortDICOM, $outDir . "/mesa");
  return 1 if ($x != 0);

  return 0;
}

sub processTransaction6 {
  die "Should not process transaction [CARD-1]\n";
  my $src   = shift(@_);
  my $dst   = shift(@_);
  my $event = shift(@_);
  my $inputDir = shift(@_);

  print "IHE Transaction [CARD-1]: \n";
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
  my ($src, $dst, $event, $inputDir, $modalityAEMPPS) = @_;

  print "IHE Transaction 7: \n";
  print "MESA will send MPPS message from dir ($inputDir) for event ($event) to your ($dst)\n";
  print "MPPS parameters for DSS/OF: $mppsAE $mppsHost $mppsPort \n";
  print "Hit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  goodbye if ($x =~ /^q/);

  mesa::send_mpps_complete($inputDir, $modalityAEMPPS, $mppsAE, $mppsHost, $mppsPort);
  mesa::send_mpps_complete($inputDir, $modalityAEMPPS, $mppsAE, "localhost", $mesaIMPortDICOM);

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

  print "IHE Transaction [CARD-2]: \n";
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

  if ($dst eq "OF") {
    print "IHE Transaction 12: \n";
    my $hl7Msg = "../../msgs/" . $msg;
    my $pid = mesa::getField($hl7Msg, "PID", "3", "0", "Patient ID");
    my $patientName = mesa::getField($hl7Msg, "PID", "5", "0", "Patient Name");

    print "MESA will send HL7 message ($msg) for event $event to $dst\n";
    print "The next step after this may be a request for you to forward this HL7 message\n";
    print " to the MESA Image Manager. The test will direct you as required.\n";
    print "Hit <ENTER> when ready (q to quit) --> ";
    my $x = <STDIN>;
    goodbye if ($x =~ /^q/);
    $x = mesa::send_hl7_log($logLevel, "../../msgs", $msg, $ofHostHL7, $ofPortHL7);
    mesa::xmit_error($msg) if ($x != 0);
  } elsif ($dst eq "IM") {
    print "IHE Transaction 12: \n";
    my $hl7Msg = "../../msgs/" . $msg;
    my $pid = mesa::getField($hl7Msg, "PID", "3", "0", "Patient ID");
    my $patientName = mesa::getField($hl7Msg, "PID", "5", "0", "Patient Name");

    print "DSS/OF is expected to send HL7 message to MESA IM ($host $mesaIMPortHL7) for event $event \n";
    print "Hit <ENTER> when ready (q to quit) --> ";
    my $x = <STDIN>;
    goodbye if ($x =~ /^q/);

    if ($selfTest == 1) {
      print "Looks like this is run directly for MESA testing; send order to MESA IM \n";
      $x = mesa::send_hl7("../../msgs", $msg, "localhost", $mesaIMPortHL7);
      mesa::xmit_error($msg) if ($x != 0);
    } else {
    }
  }

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
  print "Transaction 14 not needed for DSS/OF tests\n";
  return 0;
}

sub processTransactionCARD1 {
  my ($src, $dst, $event, $inputDir, $modalityAEMPPS, $flagSPS) = @_;

  print "IHE Cardiology Transaction 1: \n";
  print "MESA will send MPPS message from dir ($inputDir) for event ($event) to your ($dst)\n";
  print "MPPS parameters for DSS/OF: $mppsAE $mppsHost $mppsPort \n";
  print "Hit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  goodbye if ($x =~ /^q/);

  mesa::send_mpps_in_progress($inputDir, $modalityAEMPPS, $mppsAE, $mppsHost, $mppsPort);
  mesa::send_mpps_in_progress($inputDir, $modalityAEMPPS, $mppsAE, "localhost", $mesaIMPortDICOM);

  if ($flagSPS eq "SPS-YES") {
    print "Now that you have the MPPS in Progress message, you are \n";
    print " expected to schedule remaining SPS for this patient.\n";
    print " There will be no order entry; please perform the scheduling now.\n";
    print "Hit <ENTER> when ready (q to quit) --> ";
  } elsif ($flagSPS eq "SPS-NO") {
    print "This must be after the first MPPS for this room. Therefore, no\n";
    print " MWL scheduling is expected or desired.\n";
    print "Hit <ENTER> when ready (q to quit) --> ";
  } else {
    print "Illegal value found for flagSPS in function processCARD1 ($flagSPS).\n";
    print " This means there is an error in the list of test transactions.\n";
    die;
  }

  $x = <STDIN>;
  goodbye if ($x =~ /^q/);

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
    $rtnValue = ordfil::processTransaction1($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "2") {
    shift (@tokens); shift (@tokens);
    $rtnValue = processTransaction2($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "3") {
    shift (@tokens); shift (@tokens);
    $rtnValue = processTransaction3($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "4a") {
    shift (@tokens); shift (@tokens);
    $rtnValue = ordfil::processTransaction4a($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "4c") {
    shift (@tokens); shift (@tokens);
    $rtnValue = ordfil::processTransaction4c($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "4aa") {
    shift (@tokens); shift (@tokens);
    $rtnValue = ordfil::processTransaction4aa($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "4ax") {
    shift (@tokens); shift (@tokens);
    $rtnValue = ordfil::processTransaction4ax($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "4b") {
    shift (@tokens); shift (@tokens);
    $rtnValue = processTransaction4b(@tokens);
  } elsif ($trans eq "4") {
    shift (@tokens); shift (@tokens);
    $rtnValue = ordfil::processTransaction4($logLevel, $selfTest, @tokens);
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
  } elsif ($trans eq "CARD-1") {
    shift (@tokens); shift (@tokens);
    $rtnValue = processTransactionCARD1(@tokens);
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
  $modName =~ s/\^/_/;	# Because of problems passing ^ through the shell
  #$patientName =~ s/\^/_/;	# Because of problems passing ^ through the shell

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

sub processMESAInternal {
  my $cmd = shift(@_);
  my $logLevel = shift(@_);
  my $selfTest = shift(@_);
  my @tokens = split /\s+/, $cmd;
  my $verb = $tokens[0];
  my $trans= $tokens[1];

  my $rtnValue = 0;

  if ($trans eq "CARD-SCHEDULE") {
    shift (@tokens); shift (@tokens);
    $rtnValue = ordfil::processCardiologySchedule($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "CATH-SCHEDULE-MPPS-TRIGGER") {
    shift (@tokens); shift (@tokens);
    $rtnValue = ordfil::processCardiologyScheduleMPPSTrigger($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "ECHO-SCHEDULE-MPPS-TRIGGER-NO-ORDER") {
    shift (@tokens); shift (@tokens);
    $rtnValue = ordfil::processCardiologyScheduleMPPSTriggerNoOrder($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "ECHO-SCHEDULE-MPPS-TRIGGER-NO-ORDER-WITH-ADT") {
    shift (@tokens); shift (@tokens);
    $rtnValue = ordfil::processCardiologyScheduleMPPSTriggerNoOrderWithADT($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "CATH-SCHEDULE-MPPS-TRIGGER-NO-ORDER") {
    shift (@tokens); shift (@tokens);
    $rtnValue = ordfil::processCardiologyScheduleMPPSTriggerNoOrder($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "GEN-SOP-INSTANCES") {
    shift (@tokens); shift (@tokens);
    $rtnValue = mesa::generateSOPInstances($logLevel, $selfTest, $mwlAE, $mwlHost, $mwlPort, @tokens);
  } elsif ($trans eq "GEN-UNSCHED-SOP-INSTANCES") {
    shift (@tokens);
    $rtnValue = mesa::produceUnscheduledImages($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "UPDATE-PATIENT-DEMO") {
    shift (@tokens); shift (@tokens);
    $rtnValue = mesa::updatePatientDemographics($logLevel, $selfTest, @tokens);
  } else {
    die "Unable to process command <$cmd>\n";
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

  my $rtnValue = 0;

  if ($trans eq "CARD-SCHEDULE") {
    shift (@tokens); shift (@tokens);
    $rtnValue = ordfil::processCardiologyScheduleMessage($logLevel, $selfTest, @tokens);
  } else {
    die "Unable to process command <$cmd>\n";
  }
  return $rtnValue;
}

sub processOneLine {
  my $cmd  = shift(@_);
  my $logLevel  = shift(@_);
  my $selfTest  = shift(@_);

  if ($cmd eq "") {	# An empty line is a comment
    return 0;
  }

  my @verb = split /\s+/, $cmd;
  my $rtnValue = 0;
#  print "$verb[0] \n";

  if ($verb[0] eq "TRANSACTION") {
    $rtnValue = processTransaction($cmd, $logLevel, $selfTest);
  } elsif ($verb[0] eq "EXIT") {
    print "EXIT command found\n";
    exit 0;
  } elsif ($verb[0] eq "TEXT") {
    printText($cmd);
  } elsif ($verb[0] eq "TEXT_OF") {
    printText($cmd);
  } elsif ($verb[0] eq "UNSCHEDULED-IMAGES") {
    $rtnValue = unscheduledImages($cmd, $logLevel, $selfTest);
  } elsif ($verb[0] eq "PATIENT") {
    printPatient($cmd);
  } elsif ($verb[0] eq "MESA-INTERNAL") {
    $rtnValue = processMESAInternal($cmd, $logLevel, $selfTest);
  } elsif ($verb[0] eq "MESSAGE") {
    $rtnValue = processMessage($cmd, $logLevel, $selfTest);
  } elsif ($verb[0] eq "PROFILE") {
    if ($verb[1] !~ m/ECHO_WORKFLOW/) {
      die "This Order Filler script is for the Cardiology Echo profile, not $verb[1]";
    }
  } elsif (substr($verb[0], 0, 1) eq "#") {
    print "Comment: $cmd \n";
  } else {
    die "Did not recognize verb in command: $cmd \n";
  }
  return $rtnValue;
}

# Main starts here

die "Usage: <test number> <output level: 0-4>\n" if (scalar(@ARGV) < 2);

$host = `hostname`; chomp $host;

%varnames = mesa::get_config_params("ordfil_test.cfg");
if (ordfil::test_var_names(%varnames) != 0) {
  print "Some problem with the variables in ordfil_test.cfg\n";
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

$mesaOrderFillerPortHL7 = $varnames{"MESA_ORD_FIL_PORT_HL7"};
$mesaOrderPlacerPortHL7 = $varnames{"MESA_ORD_PLC_PORT_HL7"};
$mesaIMPortHL7 = $varnames{"MESA_IMG_MGR_PORT_HL7"};
$mesaIMPortDICOM = $varnames{"MESA_IMG_MGR_PORT_DCM"};
$mesaOFPortDICOM = $varnames{"MESA_ORD_FIL_PORT_DCM"};

print `perl scripts/reset_servers.pl`;
die "Could not reset servers" if ($?);


my $fileName = "../common/$ARGV[0]/$ARGV[0]" . ".txt";
open TESTFILE, $fileName or die "Could not open: $fileName\n";
$logLevel = $ARGV[1];
$selfTest = 0;
$selfTest = 1 if (scalar(@ARGV) > 2);
my $lineNumber = 1;

while ($l = <TESTFILE>) {
  chomp $l;
  print "\nTest Line Number: $lineNumber $l\n";
  $lineNumber += 1;
  $v = processOneLine($l, $logLevel, $selfTest);
  die "Could not process line $l" if ($v != 0);
}
close TESTFILE;

goodbye;
