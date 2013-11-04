#!/usr/local/bin/perl -w

# Runs the Importer tests interactively

use Env;
use lib "scripts";
use lib "../../../common/scripts";
require mod;
require mod_common;
require mod_transactions;
require mesa_common;
require mesa_dicom;

# %testCase has test case numbers
# New test case number(s) should be added to this hash when different 
# fini.txt needs to be rendered - remember, different actors use the
# common *.txt file :)
# Hash KEY matters here, not much concerned about the values they carry.:q

my %testCase = (
                151 => "true",
                152 => "true",
                153 => "true",
               );

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
    $x = mesa::send_hl7_log($logLevel, "../../msgs", $extraOrder, "localhost", $mesaOrderFillerPortHL7);
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

#sub processTransaction4a {
#  my ($logLevel, $selfTest, $src, $dst, $event, $msg, $outputDir, $inputDir, $SPSCode, $PPSCode)  = @_;
#
#  my $hl7Msg = "../../msgs/" . $msg;
#  my $pid           = mesa::getField($hl7Msg, "PID", "3", "1", "Patient ID");
#  my $patientName   = mesa::getField($hl7Msg, "PID", "5", "0", "Patient Name");
#  my $procedureCode = mesa::getField($hl7Msg, "OBR", "4", "1", "Procedure Code");
#  my $modality      = mesa::getField($hl7Msg, "OBR", "24", "1", "Service Sector ID");
#
#  print "This is the scheduling prelude to transaction 4\n";
#  print "Your DSS/OF should schedule SPS step(s) for $patientName\n";
#  print " The procedure code is $procedureCode, the modality should be $modality\n";
#  print "Hit <ENTER> when ready (q to quit) --> ";
#  my $x = <STDIN>;
#  goodbye if ($x =~ /^q/);
#
#  if ($modality eq "MR") {
#    imp::local_scheduling_mr($logLevel);
#  } elsif ($modality eq "RT") {
#    imp::local_scheduling_rt($logLevel);
#  } else {
#    printf "Unrecognized modality type for local scheduling: $modality \n";
#    exit 1;
#  }
#
#  $x = "perl scripts/produce_scheduled_images.pl $modality MESA_MOD " .
#	" $pid $procedureCode $outputDir $mwlAE $mwlHost $mwlPort " .
#	" $SPSCode $PPSCode $inputDir ";
#  print "$x \n";
#  print `$x`;
#  die "Could not schedule and produce data for this procedure \n" if $?;
#
#
#  print "PID: $pid Name: $patientName Code: $procedureCode \n";
#  return 0;
#}

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


sub processTransaction {
  my $cmd = shift(@_);
  my $logLevel = shift(@_);
  my $selfTest = shift(@_);
  my @tokens = split /\s+/, $cmd;
  my $verb = $tokens[0];
  my $trans= $tokens[1];

  my $rtnValue = 0;

  if ($trans eq "RAD-1") {
    shift (@tokens); shift (@tokens);
    $rtnValue = mod_transactions::processRAD1($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "RAD-2") {
    shift (@tokens); shift (@tokens);
    $rtnValue = mod_transactions::processRAD2($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "RAD-5") {
    shift (@tokens); shift (@tokens);
    $rtnValue = mod_transactions::processRAD5($logLevel, $selfTest, @tokens);
  #} elsif ($trans eq "2") {
  #  shift (@tokens); shift (@tokens);
  #  $rtnValue = processTransaction2($logLevel, $selfTest, @tokens);
  #} elsif ($trans eq "3") {
  #  shift (@tokens); shift (@tokens);
  #  $rtnValue = processTransaction3($logLevel, $selfTest, @tokens);
  #} elsif ($trans eq "4a") {
  #  shift (@tokens); shift (@tokens);
  #  $rtnValue = mod::processTransaction4a($logLevel, $selfTest, @tokens);
  #} elsif ($trans eq "4c") {
  #  shift (@tokens); shift (@tokens);
  #  $rtnValue = mod::processTransaction4c($logLevel, $selfTest, @tokens);
  #} elsif ($trans eq "4aa") {
  #  shift (@tokens); shift (@tokens);
  #  $rtnValue = mod::processTransaction4aa($logLevel, $selfTest, @tokens);
  #} elsif ($trans eq "4ax") {
  #  shift (@tokens); shift (@tokens);
  #  $rtnValue = mod::processTransaction4ax($logLevel, $selfTest, @tokens);
  #} elsif ($trans eq "4b") {
  #  shift (@tokens); shift (@tokens);
  #  $rtnValue = processTransaction4b(@tokens);
  #} elsif ($trans eq "4") {
  #  shift (@tokens); shift (@tokens);
  #  $rtnValue = mod::processTransaction4($logLevel, $selfTest, @tokens);
  #} elsif ($trans eq "5") {
  #  shift (@tokens); shift (@tokens);
  #  $rtnValue = processTransaction5($logLevel, $selfTest, @tokens);
  #} elsif ($trans eq "5a") {
  #  shift (@tokens); shift (@tokens);
  #  $rtnValue = mod::processTransaction5a($logLevel, $selfTest, @tokens);
  #} elsif ($trans eq "6") {
  #  shift (@tokens); shift (@tokens);
  #  $rtnValue = mod::processTransaction6(@tokens);
  #} elsif ($trans eq "7") {
  #  shift (@tokens); shift (@tokens);
  #  $rtnValue = mod::processTransaction7(@tokens);
  #} elsif ($trans eq "8") {
  #  shift (@tokens); shift (@tokens);
  #  $rtnValue = processTransaction8(@tokens);
  #} elsif ($trans eq "10") {
  #  shift (@tokens); shift (@tokens);
  #  $rtnValue = processTransaction10(@tokens);
  #} elsif ($trans eq "RAD-12") {
  #  shift (@tokens); shift (@tokens);
  #  $rtnValue = mod_transactions::processTransaction12($logLevel, $selfTest, @tokens);
  #} elsif ($trans eq "13") {
  #  shift (@tokens); shift (@tokens);
  #  $rtnValue = processTransaction13(@tokens);
  #} elsif ($trans eq "14") {
  #  shift (@tokens); shift (@tokens);
  #  $rtnValue = processTransaction14(@tokens);
  #} elsif ($trans eq "37") {
  #  shift (@tokens); shift (@tokens);
  #  $rtnValue = mod::processTransaction37($logLevel, $selfTest, @tokens);
  #} elsif ($trans eq "42") {
  #  shift (@tokens); shift (@tokens);
  #  $rtnValue = mod::processTransaction42($logLevel, $selfTest, @tokens);
  #} elsif ($trans eq "48") {
  #  shift (@tokens); shift (@tokens);
  #  $rtnValue = mod::processTransaction48($logLevel, $selfTest, @tokens);
  #} elsif ($trans eq "RAD-59") {
  #  shift (@tokens); shift (@tokens);
  #  $rtnValue = mod_transactions::processTransaction59($logLevel, $selfTest, @tokens);
  #} elsif ($trans eq "RAD-60") {
  #  shift (@tokens); shift (@tokens);
  #  $rtnValue = mod_transactions::processTransaction60($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "CARD-2") {
    shift (@tokens); shift (@tokens);
    $rtnValue = mod_transactions::processCARD2($logLevel, $selfTest, @tokens);
  } else {
    die "Unable to process command <$cmd>\n";
  }
  return $rtnValue;
}

sub printText {
  my ($cmd, $keyExist) = @_;
  my $txtFile = "";
  my @tokens = split /\s+/, $cmd;
  if (($tokens[1] =~ m/fini/) && $keyExist ) {
    $tokens[1] =~ s/fini/ordfil_fini/ ;
  } else {
    ## Nothing here
  }
  $txtFile = "../common/" . $tokens[1];
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
  my ($cmd, $logLevel, $selfTest) = @_;
  my @tokens = split /\s+/, $cmd;
  my $verb = $tokens[0];
  my $trans= $tokens[1];

  my $rtnValue = 0;

  if ($trans eq "RAD-SCHEDULE") {
    shift (@tokens); shift(@tokens);
    $rtnValue = mesa_dicom::processInternalSchedulingRequest($logLevel, $selfTest, @tokens);
#  } elsif ($trans eq "PRODUCE-MPPS-CLINICAL") {
#    shift (@tokens); shift (@tokens);
#    $rtnValue = mesa_dicom::create_mpps_messages($logLevel, @tokens);
#  } elsif ($trans eq "PRODUCE-MPPS-CLINICAL-MWL") {
#    shift (@tokens); shift (@tokens);
#    $rtnValue = mesa_dicom::create_mpps_messages_mwl($logLevel, @tokens);
#  } elsif ($trans eq "PRODUCE-MPPS-IMPORT") {
#    shift (@tokens); shift (@tokens);
#    $rtnValue = mesa_dicom::create_mpps_messages($logLevel, @tokens);
#  } elsif ($trans eq "COERCE-OBJECTS-ADT") {
#    shift (@tokens); shift (@tokens);
#    $rtnValue = mesa_dicom::coerceObjectsADT($logLevel, @tokens);
#  } elsif ($trans eq "PRODUCE-MPPS-IMPORT-MWL") {
#    shift (@tokens); shift (@tokens);
#    $rtnValue = mesa_dicom::create_mpps_messages_mwl($logLevel, @tokens);
#  } elsif ($trans eq "PRODUCE-MPPS-IMPORT-MWL-EXC") {
#    shift (@tokens); shift (@tokens);
#    $rtnValue = mesa_dicom::create_mpps_messages_mwl_exception($logLevel, @tokens);
#  } elsif ($trans eq "PPM-SCHEDULE") {
#    shift (@tokens); shift (@tokens);
#    $rtnValue = mesa::processPPMSchedulingRequest($logLevel, $selfTest, @tokens);
#  } elsif ($trans eq "GEN-MPPS-ABANDON") {
#    shift (@tokens); shift (@tokens);
#    $rtnValue = mesa::generateMPPSAbandon($logLevel, $selfTest, $mwlAE, $mwlHost, $mwlPort, @tokens);
  } elsif ($trans eq "GEN-SOP-INSTANCES") {
    shift (@tokens); shift (@tokens);
    $rtnValue = mesa_dicom::generateSOPInstances($logLevel, $selfTest, $mwlAE, $mwlHost, $mwlPort, @tokens);
#  } elsif ($trans eq "GEN-UNSCHED-SOP-INSTANCES") {
#    shift (@tokens);
#    $rtnValue = mesa::produceUnscheduledImages($logLevel, $selfTest, @tokens);
#  } elsif ($trans eq "MOD-MPPS") {
#    shift (@tokens); shift (@tokens);
#    $rtnValue = mesa::modifyMPPS($logLevel, $selfTest, @tokens);
#  } elsif ($trans eq "GPPPS-N-CREATE") {
#    shift (@tokens); shift (@tokens);
#    $rtnValue = mesa::gpppsNCreate($logLevel, $selfTest, @tokens);
#  } elsif ($trans eq "GPPPS-N-SET") {
#    shift (@tokens); shift (@tokens);
#    $rtnValue = mesa::gpppsNSet($logLevel, $selfTest, @tokens);
#  } elsif ($trans eq "COERCE-IMPORT-OBJECT-ATTRIBUTES"){
#    shift (@tokens); shift (@tokens);
#    $rtnValue = mesa_dicom::coerceImportDicomObjectAttributes($logLevel, @tokens);
#  } elsif ($trans eq "COERCE-DIGITIZED-OBJECT-ATTRIBUTES"){
#    shift (@tokens); shift (@tokens);
#    $rtnValue = mesa_dicom::coerceDigitizedDicomObjectAttributes($logLevel, @tokens);
  } elsif ($trans eq "ACQUIRE-12-Lead-ECG-WAVEFORM"){
    shift (@tokens); shift (@tokens);
    $rtnValue = mesa_dicom::acquire12LeadECGWaveform($logLevel, @tokens);
  } else{
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

  my $rtnValue = 0;
  if ($trans eq "RAD-SCHEDULE") {
    shift (@tokens); shift (@tokens);
    $rtnValue = mod_transactions::announceSchedulingParameters($logLevel, $selfTest, @tokens);
  } else {
    die "Unable to process command <$cmd>\n";
  }
  return $rtnValue;
}


sub processOneLine {
  my ($cmd, $logLevel, $selfTest, $testCase)  = @_;

  if ($cmd eq "") {	# An empty line is a comment
    return 0;
  }

  my @verb = split /\s+/, $cmd;
  my $rtnValue = 0;
  my $keyExist = 0;

  # Check to see if $testCase exists in %testCase
  if (exists($testCase{$testCase})) {
    $keyExist = 1;
  } else {
    $keyExist = 0;
  }

  if ($verb[0] eq "TRANSACTION") {
    $rtnValue = processTransaction($cmd, $logLevel, $selfTest);
  } elsif ($verb[0] eq "EXIT") {
    print "EXIT command found\n";
    exit 0;
  } elsif ($verb[0] eq "TEXT") {
     printText($cmd, $keyExist);
#  } elsif ($verb[0] eq "LOCALSCHEDULING") {
#    localScheduling($cmd);
  } elsif ($verb[0] eq "MESA-INTERNAL") {
    $rtnValue = processMESAInternal($cmd, $logLevel, $selfTest);
  } elsif ($verb[0] eq "MESSAGE") {
    $rtnValue = processMessage($cmd, $logLevel, $selfTest);
  } elsif ($verb[0] eq "UNSCHEDULED-IMAGES") {
    $rtnValue = unscheduledImages($cmd, $logLevel, $selfTest);
  } elsif ($verb[0] eq "PATIENT") {
    printPatient($cmd);
  } elsif ($verb[0] eq "PROFILE") {
    if ($verb[1] ne "STRESS") {
      die "This Importer script is for the STRESS profile, not $verb[1]";
    }
  } elsif (substr($verb[0], 0, 1) eq "#") {
    print "Comment: $cmd \n";
  } else {
    die "Did not recognize verb in command: $cmd \n";
  }
  return $rtnValue;
}

sub testConfigurationVariables {
  die "No MESA_IMG_MGR_PORT_HL7"  if ! $mesaIMPortHL7;
  die "No MESA_IMG_MGR_PORT_DCM"  if ! $mesaIMPortDICOM;
  die "No MESA_IMG_MGR_AE_MPPS"   if ! $mesaIMAEMPPS;
  die "No MESA_IMG_MGR_AE_CSTORE" if ! $mesaIMAECStore;
  die "No MESA_OF_HOST"		  if ! $mesaOFHost;
  die "No MESA_OF_PORT_DCM"	  if ! $mesaOFPortDICOM;
  die "No MESA_OF_AE"	          if ! $mesaOFAE;
  die "No MESA_OF_PORT_HL7"	  if ! $mesaOFPortHL7;
  die "No MESA_MWL_AE"	  	  if ! $mwlAE;
  die "No MESA_MWL_HOST"	  if ! $mwlHost;
  die "No MESA_MWL_PORT"	  if ! $mwlPort;
}

# Main starts here

die "Usage: <test number> <output level: 0-4>\n" if (scalar(@ARGV) < 2);

$host = `hostname`; chomp $host;

%varnames = mesa_get::get_config_params("mod_test.cfg");
if (mod::test_var_names(%varnames) != 0) {
  print "Some problem with the variables in mod_test.cfg\n";
  exit 1;
}


$mesaIMPortHL7        = $varnames{"MESA_IMG_MGR_PORT_HL7"};
$mesaIMPortDICOM      = $varnames{"MESA_IMG_MGR_PORT_DCM"};
$mesaIMAEMPPS         = $varnames{"MESA_IMG_MGR_AE_MPPS"};
$mesaIMAECStore       = $varnames{"MESA_IMG_MGR_AE_CSTORE"};

$mesaOFPortDICOM      = $varnames{"MESA_OF_PORT_DCM"};
$mesaOFHost           = $varnames{"MESA_OF_HOST"};
$mesaOFAE             = $varnames{"MESA_OF_AE"};
$mesaOFPortHL7        = $varnames{"MESA_OF_PORT_HL7"};

$mwlAE	 = $varnames{"MESA_MWL_AE"}; 
$mwlHost = $varnames{"MESA_MWL_HOST"};
$mwlPort = $varnames{"MESA_MWL_PORT"};

testConfigurationVariables();

my $fileName = "../common/$ARGV[0]/$ARGV[0]" . ".txt";
open TESTFILE, $fileName or die "Could not open: $fileName\n";
$logLevel = $ARGV[1];
$selfTest = 0;
$selfTest = 1 if (scalar(@ARGV) > 2);
$testCase = $ARGV[0];

die "MESA Environment Problem; look in mesa_environment.log" if (mesa::testMESAEnvironment($logLevel) != 0);

my $version = mesa_get::getMESAVersion();
print "MESA Version: $version\n";
($x, $date, $timeMin) = mesa_get::getDateTime($logLevel);
die "Could not get current date/time" if ($x != 0);
print "Date/time = $date $timeMin\n";

print "About to reset MESA servers\n";
print `perl scripts/reset_servers.pl`;
die "Could not reset servers" if ($?);

my $lineNum = 1;
while ($l = <TESTFILE>) {
  chomp $l;
  print "$lineNum $l\n\n";
  $lineNum += 1;
  $v = processOneLine($l, $logLevel, $selfTest, $testCase);
  die "Could not process line $l" if ($v != 0);
}
close TESTFILE;

goodbye;
