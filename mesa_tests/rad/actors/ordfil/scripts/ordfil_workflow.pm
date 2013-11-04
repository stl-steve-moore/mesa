#!/usr/local/bin/perl -w

# Runs the Order Filler scripts interactively

use Env;

package ordfil;
require Exporter;
@ISA = qw(Exporter);


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
    $x = mesa::send_hl7_log(
	$logLevel, "../../msgs", $msg, "localhost",
	$main::mesaOrderFillerPortHL7);
    mesa::xmit_error($msg) if ($x != 0);
  }

  print "\nMESA will now send ADT message ($msg) to your Order Filler ($main::ofHostHL7 $main::ofPortHL7) \n";
  print "Hit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  main::goodbye if ($x =~ /^q/);
  $x = mesa::send_hl7_log(
	$logLevel, "../../msgs", $msg, $main::ofHostHL7, $main::ofPortHL7);
  mesa::xmit_error($msg) if ($x != 0);
  return 0;
}

sub processTransaction1Secure {
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
    $x = mesa::send_hl7_secure(
	"../../msgs", $msg, "localhost", $main::mesaOrderFillerPortHL7,
	"randoms.dat",
	"mesa_1.key.pem",
	"mesa_1.cert.pem",
	"test_sys_1.cert.pem",
	"NULL-SHA");
    mesa::xmit_error($msg) if ($x != 0);
  }

  print "\nMESA will now send ADT message ($msg) to your Order Filler ($main::ofHostHL7 $main::ofPortHL7) \n";
  print "Hit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  main::goodbye if ($x =~ /^q/);
  $x = mesa::send_hl7_secure(
	"../../msgs", $msg, $main::ofHostHL7, $main::ofPortHL7,
	"randoms.dat",
	"mesa_1.key.pem",
	"mesa_1.cert.pem",
	"test_sys_1.cert.pem",
	"NULL-SHA");
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
  print "MESA will now send ORR^O02 message ($msg) to your Order Filler ($ofHostHL7 $ofPortHL7) \n" if ($event eq "ORDER_O02");
  print " Placer Order Number $placerOrderNumber \n";
  print "Hit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  main::goodbye if ($x =~ /^q/);
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

sub processTransaction2Secure {
  my ($logLevel, $selfTest, $src, $dst, $event, $msg) = @_;

  my $hl7Msg = "../../msgs/" . $msg;
  my $pid               = mesa::getField($hl7Msg, "PID", "3", "0", "Patient ID");
  my $patientName       = mesa::getField($hl7Msg, "PID", "5", "0", "Patient Name");
  my $procedureCode     = mesa::getField($hl7Msg, "OBR", "4", "0", "Procedure Code");
  my $placerOrderNumber = mesa::getField($hl7Msg, "ORC", "2", "0", "Placer Order Number");

  print "\nIHE Transaction 2: $pid $patientName $procedureCode \n";
  print "MESA will now send ORM^O01 message ($msg) to your Order Filler ($main::ofHostHL7 $main::ofPortHL7) \n" if ($event eq "ORDER");
  print "MESA will now send ORR^O02 message ($msg) to your Order Filler ($main::ofHostHL7 $main::ofPortHL7) \n" if ($event eq "ORDER_O02");
  print " Placer Order Number $placerOrderNumber \n";
  print "Hit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  main::goodbye if ($x =~ /^q/);
  $x = mesa::send_hl7_secure(
	"../../msgs", $msg, $main::ofHostHL7, $main::ofPortHL7,
	"randoms.dat",
	"mesa_1.key.pem",
	"mesa_1.cert.pem",
	"test_sys_1.cert.pem",
	"NULL-SHA");
  mesa::xmit_error($msg) if ($x != 0);

  if ($selfTest == 1) {
    print "Looks like this is run directly for MESA testing; skip order copy to MESA DSS/OF \n";
  } else {
    # Send a copy of the Order to MESA for our own purposes.
    print "MESA will send ORM message ($msg) for event $event to MESA $dst\n";
    $x = mesa::send_hl7_secure(
	"../../msgs", $msg, "localhost", $main::mesaOrderFillerPortHL7,
	"randoms.dat",
	"mesa_1.key.pem",
	"mesa_1.cert.pem",
	"test_sys_1.cert.pem",
	"NULL-SHA");
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
  main::goodbye if ($x =~ /^q/);

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
  main::goodbye if ($x =~ /^q/);

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

sub processTransaction4a {
  die "ordfil::processTransaction4a";
  my ($logLevel, $selfTest, $src, $dst, $event, $msg, $outputDir, $inputDir, $SPSCode, $PPSCode, $SPSLocation, $scheduledAET)  = @_;

  my $hl7Msg = "../../msgs/" . $msg;
  my $pid           = mesa::getField($hl7Msg, "PID", "3", "1", "Patient ID");
  my $patientName   = mesa::getField($hl7Msg, "PID", "5", "0", "Patient Name");
  my $procedureCode = mesa::getField($hl7Msg, "OBR", "4", "1", "Procedure Code");
  my $modality      = mesa::getField($hl7Msg, "OBR", "24", "1", "Service Sector ID");

  print "This is the scheduling prelude to transaction Rad-4\n";
  print "Your DSS/OF should schedule SPS step(s) for $patientName\n";
  print " The procedure code is $procedureCode, the modality should be $modality\n";
  print "Hit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  main::goodbye if ($x =~ /^q/);

  if ($modality eq "MR") {
#    ordfil::local_scheduling_mr($logLevel);
    mesa::local_scheduling_mr($logLevel, $SPSLocation, $scheduledAET);
  } elsif ($modality eq "RT") {
    ordfil::local_scheduling_rt($logLevel);
  } else {
    die "Unrecognized modality type for local scheduling: $modality \n";
  }

  $x = "perl ../../../rad/actors/ordfil/scripts/produce_scheduled_images.pl $modality MESA_MOD " .
	" $pid $procedureCode $outputDir " .
	" $main::mwlAE $main::mwlHost $main::mwlPort " .
	" $SPSCode $PPSCode $inputDir ";
  print "$x \n";
  print `$x`;
  die "Could not schedule and produce data for this procedure \n" if $?;


  print "PID: $pid Name: $patientName Code: $procedureCode \n";
  return 0;
}

sub processTransaction4c {
  die "ordfil::processTransaction4c";
  my ($logLevel, $selfTest, $src, $dst, $event, $msg)  = @_;

  my $hl7Msg = "../../msgs/" . $msg;
  my $pid           = mesa::getField($hl7Msg, "PID", "3", "1", "Patient ID");
  my $patientName   = mesa::getField($hl7Msg, "PID", "5", "0", "Patient Name");
  my $procedureCode = mesa::getField($hl7Msg, "OBR", "4", "1", "Procedure Code");
  my $modality      = mesa::getField($hl7Msg, "OBR", "24", "1", "Service Sector ID");

  print "This is the scheduling prelude to transaction Rad-4\n";
  print "Your DSS/OF should schedule SPS step(s) for $patientName\n";
  print " The procedure code is $procedureCode, the modality should be $modality\n";
  print "Hit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  main::goodbye if ($x =~ /^q/);

  if ($modality eq "MR") {
    ordfil::local_scheduling_mr($logLevel);
    mesa::local_scheduling_mr($logLevel, $SPSLocation, $scheduledAET);
  } elsif ($modality eq "RT") {
    ordfil::local_scheduling_rt($logLevel);
  } else {
    die "Unrecognized modality type for local scheduling: $modality \n";
  }
  return 0;
}

sub processTransaction4aa {
  die "Transaction 4aa";
  my ($logLevel, $selfTest, $src, $dst, $event, $outputDir, $deltaNCreate, $deltaNSet)  = @_;

  ordfil::update_object("$main::MESA_STORAGE/modality/$outputDir/mpps.crt",    $deltaNCreate);
  ordfil::update_object("$main::MESA_STORAGE/modality/$outputDir/mpps.set",    $deltaNSet);
  ordfil::update_object("$main::MESA_STORAGE/modality/$outputDir/mpps.status", $deltaNSet);
  return 0;
}

sub processTransaction4ax {
  die "ordfil::processTransaction4ax";
  my ($logLevel, $selfTest, $src, $dst, $event, $msg, $outputDir, $inputDir, $SPSCode, $PPSCode)  = @_;

  my $hl7Msg = "../../msgs/" . $msg;
  my $pid           = mesa::getField($hl7Msg, "PID", "3", "1", "Patient ID");
  my $patientName   = mesa::getField($hl7Msg, "PID", "5", "0", "Patient Name");
  my $procedureCode = mesa::getField($hl7Msg, "OBR", "4", "1", "Procedure Code");
  my $modality      = mesa::getField($hl7Msg, "OBR", "24", "1", "Service Sector ID");

  print "This is the scheduling prelude to transaction Rad-4\n";
  print "Your DSS/OF should schedule SPS step(s) for $patientName\n";
  print " The procedure code is $procedureCode, the modality should be $modality\n";
  print "Hit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  main::goodbye if ($x =~ /^q/);

  if ($modality eq "MR") {
    ordfil::local_scheduling_mr($logLevel);
    mesa::local_scheduling_mr($logLevel, $SPSLocation, $scheduledAET);
  } elsif ($modality eq "RT") {
    ordfil::local_scheduling_rt($logLevel);
  } else {
    die "Unrecognized modality type for local scheduling: $modality \n";
  }

  $x = "perl scripts/produce_abandoned_step.pl $modality MESA_MOD " .
	" $pid $procedureCode $outputDir " .
	" $main::mwlAE $main::mwlHost $main::mwlPort " .
	" $SPSCode $PPSCode $inputDir 110513";
  print "$x \n";
  print `$x`;
  die "Could not schedule and produce data for this procedure \n" if $?;


  print "PID: $pid Name: $patientName Code: $procedureCode \n";
  return 0;
}

sub processTransaction4aSecure {
  die "ordfil::processTransaction4asecure";
  my ($logLevel, $selfTest, $src, $dst, $event, $msg, $outputDir, $inputDir, $SPSCode, $PPSCode)  = @_;

  my $hl7Msg = "../../msgs/" . $msg;
  my $pid           = mesa::getField($hl7Msg, "PID", "3", "1", "Patient ID");
  my $patientName   = mesa::getField($hl7Msg, "PID", "5", "0", "Patient Name");
  my $procedureCode = mesa::getField($hl7Msg, "OBR", "4", "1", "Procedure Code");
  my $modality      = mesa::getField($hl7Msg, "OBR", "24", "1", "Service Sector ID");

  print "This is the scheduling prelude to transaction Rad-4\n";
  print "Your DSS/OF should schedule SPS step(s) for $patientName\n";
  print " The procedure code is $procedureCode, the modality should be $modality\n";
  print "Hit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  main::goodbye if ($x =~ /^q/);

  if ($modality eq "MR") {
    ordfil::local_scheduling_mr($logLevel);
    mesa::local_scheduling_mr($logLevel, $SPSLocation, $scheduledAET);
  } elsif ($modality eq "RT") {
    ordfil::local_scheduling_rt($logLevel);
  } else {
    die "Unrecognized modality type for local scheduling: $modality \n";
  }

  $x = "perl scripts/produce_scheduled_images_secure.pl $modality MESA_MOD " .
	" $pid $procedureCode $outputDir $main::mwlAE $main::mwlHost $main::mwlPort " .
	" $SPSCode $PPSCode $inputDir ";
  print "$x \n";
  print `$x`;
  die "Could not schedule and produce data for this procedure \n" if $?;


  print "PID: $pid Name: $patientName Code: $procedureCode \n";
  return 0;
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
  main::goodbye if ($x =~ /^q/);

  print "PID: $pid Name: $patientName Code: $procedureCode \n";

  my $modalityDir = "$MESA_STORAGE/modality/" . $outputDir;
  my $accessionNum = "ACC";
  my $requestedProcedureID = "REQPROID";
  my $scheduledProcedureStepID = "SPSID";
  $x = mesa::update_scheduling_ORM_post_procedure($logLevel, $hl7Msg, $modalityDir, $accessionNum, $requestedProcedureID, $scheduledProcedureStepID);
  print "Unable to update the scheduling message with post procedure data\n" if ($x != 0);
 
  return $x;
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
  my $accessionNumber   = mesa::getField($hl7Msg, "ORC", "3", "1", "Filler Order Number");
  ordfil::update_accession_number($logLevel, "../../msgs/$msg", $accessionNumber);

  print "\nIHE Transaction 4: $pid $patientName $procedureCode \n";
  print "DSS/OF is expected to send HL7 message to MESA IM ($main::host $main::mesaIMPortHL7) for event $event \n";
  print " Placer Order Number is $placerOrderNumber \n";
  print "Hit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  main::goodbye if ($x =~ /^q/);

  if ($selfTest == 1) {
    print "Looks like this is run directly for MESA testing; send order to MESA IM \n";
    $x = mesa::send_hl7("../../msgs", $msg, "localhost", $main::mesaIMPortHL7);
    mesa::xmit_error($msg) if ($x != 0);
  } else {
  }
  return 0;
}

sub processTransaction4Secure {
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
  my $accessionNumber   = mesa::getField($hl7Msg, "ORC", "3", "1", "Filler Order Number");
  ordfil::update_accession_number($logLevel, "../../msgs/$msg", $accessionNumber);

  print "\nIHE Transaction 4: $pid $patientName $procedureCode \n";
  print "DSS/OF is expected to send HL7 message to MESA IM ($main::host $main::mesaIMPortHL7) for event $event \n";
  print " Placer Order Number is $placerOrderNumber \n";
  print "Hit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  main::goodbye if ($x =~ /^q/);

  if ($selfTest == 1) {
    print "Looks like this is run directly for MESA testing; send order to MESA IM \n";
    $x = mesa::send_hl7_secure(
	"../../msgs", $msg, "localhost", $main::mesaIMPortHL7,
	"randoms.dat",
	"test_sys_1.key.pem",
	"test_sys_1.cert.pem",
	"mesa_1.cert.pem",
	"NULL-SHA");
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
  main::goodbye if ($x =~ /^q/);

  $x = mesa::construct_mwl_query_pid(
	$logLevel, "mwl/mwlquery_template.txt", "mwl/mwlquery_pid.txt",
	"mwl/mwlquery_pid.dcm", $pidShort);

  return 1 if ($x != 0);

  print "About to send MWL query to test system.\n" if ($logLevel >= 3);
  print "\$logLevel: ".$logLevel."\n";
  print "\$mwlAE: ".$mwlAE."\n";
  print "\$mwlHost: ".$mwlHost."\n";
  print "\$outDir: ".$outDir."\n";
  $x = mesa::send_cfind_mwl($logLevel, "mwl/mwlquery_pid.dcm",
	$mwlAE, $mwlHost, $mwlPort, $outDir . "/test");
  return 1 if ($x != 0);

  print "About to send MWL query to MESA system.\n" if ($logLevel >= 3);
  $x = mesa::send_cfind_mwl($logLevel, "mwl/mwlquery_pid.dcm",
	$mwlAE, "localhost", $mesaOFPortDICOM, $outDir . "/mesa");
  return 1 if ($x != 0);

  return 0;
}


sub processTransaction5a {
  my ($logLevel, $selfTest, $src, $dst, $event, $key, $outDir) = @_;

  print "\nIHE Transaction 5a: $key $event\n";
  print "MESA Modality will now send MWL query based on the key: $key\n";
  print "Hit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  main::goodbye if ($x =~ /^q/);

  $x = mesa::construct_mwl_query_key(
	$logLevel, "mwl/mwlquery_template.txt", "mwl/mwlquery_key.txt",
	"mwl/mwlquery_key.dcm", $event, $key);

  return 1 if ($x != 0);

  print "About to send MWL query to test system.\n" if ($logLevel >= 3);
  print "\$logLevel: ".$logLevel."\n";
  print "\$mwlAE: ".$main::mwlAE."\n";
  print "\$mwlHost: ".$main::mwlHost."\n";
  print "\$outDir: ".$outDir."\n";
  $x = mesa::send_cfind_mwl($logLevel, "mwl/mwlquery_key.dcm",
	$main::mwlAE, $main::mwlHost, $main::mwlPort, $outDir . "/test");
  return 1 if ($x != 0);

  print "About to send MWL query to MESA system.\n" if ($logLevel >= 3);
  $x = mesa::send_cfind_mwl($logLevel, "mwl/mwlquery_key.dcm",
	$main::mwlAE, "localhost", $main::mesaOFPortDICOM, $outDir . "/mesa");
  return 1 if ($x != 0);

  return 0;
}

sub processTransaction5Secure {
  my ($logLevel, $selfTest, $src, $dst, $event, $msg, $outDir) = @_;

  my $hl7Msg        = "../../msgs/" . $msg;
  my $pid           = mesa::getField($hl7Msg, "PID", "3", "0", "Patient ID");
  my $pidShort      = mesa::getField($hl7Msg, "PID", "3", "1", "Patient ID");
  my $patientName   = mesa::getField($hl7Msg, "PID", "5", "0", "Patient Name");
  my $procedureCode = mesa::getField($hl7Msg, "OBR", "4", "0", "Procedure Code");

  print "\nIHE Transaction 5: $pid $patientName $procedureCode \n";
  print "MESA Modality will now send MWL query for patient with PID $pidShort\n";
  print "Hit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  main::goodbye if ($x =~ /^q/);

  $x = mesa::construct_mwl_query_pid(
	$logLevel, "mwl/mwlquery_template.txt", "mwl/mwlquery_pid.txt",
	"mwl/mwlquery_pid.dcm", $pidShort);

  return 1 if ($x != 0);

  print "About to send MWL query to test system.\n" if ($logLevel >= 3);
  $x = mesa::send_cfind_mwl_secure($logLevel, "mwl/mwlquery_pid.dcm",
	$mwlAE, $mwlHost, $mwlPort, $outDir . "/test",
	"randoms.dat",
	"mesa_1.key.pem",
	"mesa_1.cert.pem",
	"test_sys_1.cert.pem",
	"NULL-SHA");
  return 1 if ($x != 0);

  print "About to send MWL query to MESA system.\n" if ($logLevel >= 3);
  $x = mesa::send_cfind_mwl_secure($logLevel, "mwl/mwlquery_pid.dcm",
	$mwlAE, "localhost", $mesaOFPortDICOM, $outDir . "/mesa",
	"randoms.dat",
	"mesa_1.key.pem",
	"mesa_1.cert.pem",
	"test_sys_1.cert.pem",
	"NULL-SHA");
  return 1 if ($x != 0);

  return 0;
}

sub processTransaction6 {
  my ($src, $dst, $event, $inputDir, $modalityAEMPPS) = @_;

  print "IHE Transaction 6: \n";
  print "MESA will send MPPS message from dir ($inputDir) for event ($event) to your ($dst)\n";
  print "MPPS parameters for DSS/OF: $main::mppsAE $main::mppsHost $main::mppsPort \n";
  print "Modality MPPS AE: $modalityAEMPPS\n";
  print "Hit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  main::goodbye if ($x =~ /^q/);

  mesa::send_mpps_in_progress($inputDir, $modalityAEMPPS, $main::mppsAE, $main::mppsHost, $main::mppsPort);
  mesa::send_mpps_in_progress($inputDir, $modalityAEMPPS, $main::mppsAE, "localhost", $main::mesaIMPortDICOM);
  return 0;
}

sub processTransaction6Secure {
  my ($src, $dst, $event, $inputDir, $modalityAEMPPS) = @_;

  print "IHE Transaction 6: \n";
  print "MESA will send MPPS message from dir ($inputDir) for event ($event) to your ($dst)\n";
  print "MPPS parameters for DSS/OF: $main::mppsAE $main::mppsHost $main::mppsPort \n";
  print "Modality MPPS AE: $modalityAEMPPS\n";
  print "Hit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  main::goodbye if ($x =~ /^q/);

  mesa::send_mpps_in_progress_secure(
	$inputDir, $modalityAEMPPS,
	$main::mppsAE, $main::mppsHost, $main::mppsPort,
	"randoms.dat",
	"mesa_1.key.pem",
	"mesa_1.cert.pem",
	"test_sys_1.cert.pem",
	"NULL-SHA");
  mesa::send_mpps_in_progress_secure(
	$inputDir, $modalityAEMPPS,
	$main::mppsAE, "localhost", $main::mesaIMPortDICOM,
	"randoms.dat",
	"test_sys_1.key.pem",
	"test_sys_1.cert.pem",
	"mesa_1.cert.pem",
	"NULL-SHA");
  return 0;
}

sub processTransaction7 {
  my ($src, $dst, $event, $inputDir, $modalityAEMPPS) = @_;

  print "IHE Transaction 7: \n";
  print "MESA will send MPPS message from dir ($inputDir) for event ($event) to your ($dst)\n";
  print "MPPS parameters for DSS/OF: $main::mppsAE $main::mppsHost $main::mppsPort \n";
  print "Hit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  main::goodbye if ($x =~ /^q/);

  mesa::send_mpps_complete($inputDir, $modalityAEMPPS, $main::mppsAE, $main::mppsHost, $main::mppsPort);
  mesa::send_mpps_complete($inputDir, $modalityAEMPPS, $main::mppsAE, "localhost", $main::mesaIMPortDICOM);

  print "MPPS is complete for this procedure step. If your system submits\n";
  print " Image Availability queries, you might want to check results now.\n";
  print "Hit <ENTER> when ready (q to quit) --> ";
  $x = <STDIN>;
  main::goodbye if ($x =~ /^q/);
  return 0;
}

sub processTransaction7Secure {
  my ($src, $dst, $event, $inputDir, $modalityAEMPPS) = @_;

  print "IHE Transaction 7: \n";
  print "MESA will send MPPS message from dir ($inputDir) for event ($event) to your ($dst)\n";
  print "MPPS parameters for DSS/OF: $main::mppsAE $main::mppsHost $main::mppsPort \n";
  print "Hit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  main::goodbye if ($x =~ /^q/);

  mesa::send_mpps_complete_secure(
	$inputDir, $modalityAEMPPS,
	$main::mppsAE, $main::mppsHost, $main::mppsPort,
	"randoms.dat",
	"mesa_1.key.pem",
	"mesa_1.cert.pem",
	"test_sys_1.cert.pem",
	"NULL-SHA");
  mesa::send_mpps_complete_secure(
	$inputDir, $modalityAEMPPS,
	$main::mppsAE, "localhost", $main::mesaIMPortDICOM,
	"randoms.dat",
	"test_sys_1.key.pem",
	"test_sys_1.cert.pem",
	"mesa_1.cert.pem",
	"NULL-SHA");

  print "MPPS is complete for this procedure step. If your system submits\n";
  print " Image Availability queries, you might want to check results now.\n";
  print "Hit <ENTER> when ready (q to quit) --> ";
  $x = <STDIN>;
  main::goodbye if ($x =~ /^q/);
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

sub processTransaction8Secure {
  my ($src, $dst, $event, $inputDir) = @_;

  print "IHE Transaction 8: \n";
  print "MESA will send images from dir ($inputDir) for event ($event) to MESA IM \n";

  mesa::store_images_secure(
	$inputDir, "", "MODALITY1", "MESA_IMG_MGR",
	"localhost", $main::mesaIMPortDICOM, 0,
	"randoms.dat",
	"test_sys_1.key.pem",
	"test_sys_1.cert.pem",
	"mesa_1.cert.pem",
	"NULL-SHA");

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
    main::goodbye if ($x =~ /^q/);
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
    main::goodbye if ($x =~ /^q/);

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
  main::goodbye if ($x =~ /^q/);

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

sub processTransaction37 {
  my ($logLevel, $selfTest, $src, $dst, $event, $msg, $outDir) = @_;

  my $hl7Msg = "../../msgs/" . $msg;
  my $pid = mesa::getField($hl7Msg, "PID", "3", "0", "Patient ID");
  my $pidShort = mesa::getField($hl7Msg, "PID", "3", "1", "Patient ID");
  my $patientName = mesa::getField($hl7Msg, "PID", "5", "0", "Patient Name");

  print "\nIHE Transaction 37: $pid $patientName \n";
  print "MESA Evidence Creator/Image Disp will now send GPWL query for patient with PID $pidShort\n";
  print "This goes to the MESA PPM\n";
  print "Hit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  main::goodbye if ($x =~ /^q/);

  $x = mesa::construct_mwl_query_pid (
	$logLevel, "gpwl/gpwlquery_template.txt", "gpwl/gpwlquery_pid.txt",
	"gpwl/gpwlquery_pid.dcm", $pidShort);

  return 1 if ($x != 0);

#  print "About to send GPWL query to test system.\n" if ($logLevel >= 3);
#  print "\$logLevel: $logLevel\n";
#  print "\$mwlAE:    $main::mwlAE\n";
#  print "\$mwlHost:  $main::mwlHost\n";
#  print "\$outDir:   $main::outDir\n";
#  $x = mesa::send_cfind_mwl($logLevel, "gpwl/gpwlquery_pid.dcm",
#	$main::mwlAE, $main::mwlHost, $main::mwlPort, $outDir . "/test");
#  return 1 if ($x != 0);

  print "About to send MWL query to MESA system.\n" if ($logLevel >= 3);
  $x = mesa::send_cfind_gpwl($logLevel, "gpwl/gpwlquery_pid.dcm",
	"AE_PPM", "localhost", $main::mesaPPMPortDICOM, "$outDir/mesa", "WORKSTATIONAE");
  return 1 if ($x != 0);

  return 0;
}


sub processTransaction42 {
  my ($logLevel, $selfTest, $src, $dst, $event, $gpppsFile, $gpppsDirectory, $ppmAE) = @_;

  print "IHE Transaction 42: \n";
  print "MESA will send GP PPS message from file <$gpppsFile> for event ($event) to your ($dst)\n";
  print "GP PPS parameters for DSS/OF: $main::gpppsSCPAE $main::gpppsSCPHost $main::gpppsSCPPort \n";
  print "PPM GP PPS AE: $ppmAE\n";
  print "Hit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  main::goodbye if ($x =~ /^q/);

  return ordfil::processTransaction42NCreate(@_) if ($event eq "N-CREATE");
  return ordfil::processTransaction42NSet(@_) if ($event eq "N-SET");
  print "ordfil::processTransaction42 unregonized event: $event. Should be N-CREATE or N-SET\n";
  return 1;
}

sub processTransaction42NCreate {
  my ($logLevel, $selfTest, $src, $dst, $event, $gpppsFile, $gpppsDirectory, $ppmAE) = @_;

  my $gpppsPath = "../../msgs/$gpppsDirectory";
  mesa::send_gppps_in_progress($logLevel, $gpppsPath, $gpppsFile, $ppmAE, $main::gpppsSCPAE, $main::gpppsSCPHost, $main::gpppsSCPPort);

  return 0 if ($selfTest != 0);

  print "MESA GP PPS SCP Port: $main::mesaGPPPSSCPPort \n";
  mesa::send_gppps_in_progress($logLevel, $gpppsPath, $gpppsFile, $ppmAE, $main::gpppsSCPAE, "localhost", $main::mesaGPPPSSCPPort);
  return 0;
}

sub processTransaction42NSet {
  my ($logLevel, $selfTest, $src, $dst, $event, $gpppsFile, $gpppsDirectory, $ppmAE) = @_;

  my $gpppsPath = "../../msgs/$gpppsDirectory";
  mesa::send_gppps_complete($logLevel, $gpppsPath, $gpppsFile, $ppmAE, $main::gpppsSCPAE, $main::gpppsSCPHost, $main::gpppsSCPPort);

  return 0 if ($selfTest != 0);

  print "MESA GP PPS SCP Port: $main::mesaGPPPSSCPPort \n";
  mesa::send_gppps_complete($logLevel, $gpppsPath, $gpppsFile, $ppmAE, $main::gpppsSCPAE, "localhost", $main::mesaGPPPSSCPPort);
  return 0;
}

sub processTransaction48 {
  my ($logLevel, $selfTest, $src, $dst, $event, $msg) = @_;

  my $hl7Msg = "../../msgs/" . $msg;
  my $fillerAppID = mesa::getField($hl7Msg, "SCH", "2", "0", "Filler Appointment ID");
  my $eventReason = mesa::getField($hl7Msg, "SCH", "6", "0", "Event Reason");
  my $fillerContactPerson = mesa::getField($hl7Msg, "SCH", "16", "0", "Filler Contact Person");
  my $placerOrderNumber = mesa::getField($hl7Msg, "SCH", "26", "0", "Placer Order Number");
  my $fillerOrderNumber = mesa::getField($hl7Msg, "SCH", "27", "0", "Filler Order Number");

  my $appointmentType = "";
  if ($msg =~ m/s12/g) {
     $appointmentType = "NEW";
  } elsif ($msg =~ m/s13/g) {
     $appointmentType = "UPDATE";
  } else {
     $appointmentType = "CANCEL";
  }

  print "\nIHE Transaction 48: $fillerAppID $placerOrderNumber $fillerOrderNumber\n";
  print "\nDSS/OF is expected to send HL7 appointment notification message to MESA Order Placer ($main::mesaOrderPlacerPortHL7)\n";
  print " MESA sample $appointmentType APPOINT message is found in $hl7Msg\n";
  print "Hit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  main::goodbye if ($x =~ /^q/);

  if ($selfTest == 1) {
    print "Looks like this is run directly for MESA testing; send appointment message to MESA Order Placer \n";
    print "MESA will send $appointmentType APPOINT message ($hl7Msg) to MESA $dst\n";
    $x = mesa::send_hl7("../../msgs", $msg, "localhost", $main::mesaOrderPlacerPortHL7);
    mesa::xmit_error($msg) if ($x != 0);
  } else {
  }
  return 0;

}

# Radiology scheduling associated functions

sub announceSchedulingParameters {
  my ($logLevel, $selfTest, $src, $dst, $event, $msg, $outputDir, $inputDir, $SPSCode, $PPSCode, $SPSLocation, $scheduledAET)  = @_;

  my $hl7Msg = "../../msgs/" . $msg;
  my $pid           = mesa::getField($hl7Msg, "PID", "3", "1", "Patient ID");
  my $patientName   = mesa::getField($hl7Msg, "PID", "5", "0", "Patient Name");
  my $universalServiceID= mesa::getField($hl7Msg, "OBR", "4", "0", "Universal Service ID");
  my $modality      = mesa::getField($hl7Msg, "OBR", "24", "1", "Service Sector ID");

  print "This is the scheduling prelude to transaction Rad-4\n";
  print "Your DSS/OF should schedule SPS step(s) for $patientName\n";
  print " The Universal Service ID is $universalServiceID\n";
  print " The modality should be $modality\n";
  print " The Scheduled AE Title should be $scheduledAET\n";
  print " The SPS Location should be $SPSLocation\n";
  print "Hit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  main::goodbye if ($x =~ /^q/);

  return 0;
}

#sub processInternalSchedulingRequest{
#  my ($logLevel, $selfTest, $src, $dst, $event, $msg, $outputDir, $inputDir, $SPSCode, $PPSCode, $SPSLocation, $scheduledAET)  = @_;
#
#  my $hl7Msg = "../../msgs/" . $msg;
#  my $pid           = mesa::getField($hl7Msg, "PID", "3", "1", "Patient ID");
#  my $patientName   = mesa::getField($hl7Msg, "PID", "5", "0", "Patient Name");
#  my $universalServiceID = mesa::getField($hl7Msg, "OBR", "4", "0", "Universal Service ID");
#  my $procedureCode = mesa::getField($hl7Msg, "OBR", "4", "1", "Procedure Code");
#  my $modality      = mesa::getField($hl7Msg, "OBR", "24", "1", "Service Sector ID");
#
#  print "This is the MESA scheduling prelude to transaction Rad-4\n";
#  print "By now, you have already scheduled steps on your MWL server\n";
#  print "The MESA tools will now perform appropriate scheduling\n";
#  print " The Universal Service ID is $universalServiceID\n";
#  print " The Procedure Code  is $procedureCode\n";
#  print " The modality should be $modality\n";
#  print " The SPS Location should be $SPSLocation\n";
#  print " PID: $pid Name: $patientName Code: $procedureCode \n";
#  print "Hit <ENTER> when ready (q to quit) --> ";
#  my $x = <STDIN>;
#  main::goodbye if ($x =~ /^q/);
#
#  if ($modality eq "MR") {
##    ordfil::local_scheduling_mr($logLevel, $SPSLocation, $scheduledAET);
#    mesa::local_scheduling_mr($logLevel, $SPSLocation, $scheduledAET);
#  } elsif ($modality eq "RT") {
#    mesa::local_scheduling_rt($logLevel, $SPSLocation, $scheduledAET);
#  } elsif ($modality eq "HD") {
#    mesa::local_scheduling_hd($logLevel, $SPSLocation, $scheduledAET);
#  } else {
#    die "Unrecognized modality type for local scheduling: $modality \n";
#  }
#
#  return 0;
#}


# Functions that are specific to IHE-Cardiology follow here

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

  print "This is the MESA scheduling prelude to transaction Rad-4\n";
  print "By now, you have already scheduled steps on your MWL server\n";
  print "The MESA tools will now perform appropriate scheduling\n";
  print " The Universal Service ID is $universalServiceID\n";
  print " The Procedure Code  is $procedureCode\n";
  print " The modality should be $modality\n";
  print " The SPS Location should be $SPSLocation\n";
  print "Hit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  main::goodbye if ($x =~ /^q/);

  if ($modality eq "MR") {
#    ordfil::local_scheduling_mr($logLevel, $SPSLocation, $scheduledAET);
    mesa::local_scheduling_mr($logLevel, $SPSLocation, $scheduledAET);
  } elsif ($modality eq "RT") {
    ordfil::local_scheduling_rt($logLevel, $SPSLocation, $scheduledAET);
  } elsif ($modality eq "HD") {
    ordfil::local_scheduling_hd($logLevel, $SPSLocation, $scheduledAET);
  } elsif ($modality eq "US") {
    mesa::local_scheduling_us($logLevel, $SPSLocation, $scheduledAET);
  } else {
    die "Unrecognized modality type for local scheduling: $modality \n";
  }

#  $x = "perl ../../../rad/actors/ordfil/scripts/produce_scheduled_images.pl $modality MESA_MOD " .
#	" $pid $procedureCode $outputDir " .
#	" $main::mwlAE $main::mwlHost $main::mwlPort " .
#	" $SPSCode $PPSCode $inputDir ";
#  print "$x \n";
#  print `$x`;
#  die "Could not schedule and produce data for this procedure \n" if $?;

  print "PID: $pid Name: $patientName Code: $procedureCode \n";
  return 0;
}

# This function schedules steps for Cardiology specifc codes.
#sub generateSOPInstances {
#  my ($logLevel, $selfTest, $src, $dst, $event, $msg, $outputDir, $inputDir, $SPSCode, $PPSCode, $SPSLocation, $scheduledAET)  = @_;
#
#  my $hl7Msg = "../../msgs/" . $msg;
#  my $pid           = mesa::getField($hl7Msg, "PID", "3", "1", "Patient ID");
#  my $patientName   = mesa::getField($hl7Msg, "PID", "5", "0", "Patient Name");
#  my $universalServiceID = mesa::getField($hl7Msg, "OBR", "4", "0", "Universal Service ID");
#  my $procedureCode = mesa::getField($hl7Msg, "OBR", "4", "1", "Procedure Code");
#  my $modality      = mesa::getField($hl7Msg, "OBR", "24", "1", "Service Sector ID");
#
#  print "This is the MESA step to produce SOP instances\n";
#  print "By now, you have already scheduled steps on your MWL server\n";
#  print " The Universal Service ID is $universalServiceID\n";
#  print " The Procedure Code  is $procedureCode\n";
#  print " The modality should be $modality\n";
#  print " The SPS Location should be $SPSLocation\n";
#  print "Hit <ENTER> when ready (q to quit) --> ";
#  my $x = <STDIN>;
#  main::goodbye if ($x =~ /^q/);
#
#  $x = "perl ../../../rad/actors/ordfil/scripts/produce_scheduled_images.pl $modality MESA_MOD " .
#	" $pid $procedureCode $outputDir " .
#	" $main::mwlAE $main::mwlHost $main::mwlPort " .
#	" $SPSCode $PPSCode $inputDir ";
#  print "$x \n";
#  print `$x`;
#  die "Could not produce data for this step \n" if $?;
#
#  print "PID: $pid Name: $patientName Code: $procedureCode \n";
#  return 0;
#}

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
  print "By now, you have already scheduled steps on your MWL server\n";
  print "The MESA tools will now perform appropriate scheduling\n";
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
    $x = mesa::local_scheduling_ivus_mpps_trigger($logLevel, $SPSLocation, $scheduledAET, $SPSCode, $SPSIndex);
    return 1 if ($x != 0);
  } elsif ($modality eq "XA") {
    $x = mesa::local_scheduling_xa_mpps_trigger($logLevel, $SPSLocation, $scheduledAET, $SPSCode, $SPSIndex);
    return 1 if ($x != 0);
  } else {
    die "Unrecognized modality type for local scheduling: $modality \n";
  }

  $x = "perl ../../../rad/actors/ordfil/scripts/produce_scheduled_images.pl $modality MESA_MOD " .
	" $pid $procedureCode $outputDir " .
	" $main::mwlAE $main::mwlHost $main::mwlPort " .
	" $SPSCode $PPSCode $inputDir ";
  print "$x \n";
  print `$x`;
  die "Could not schedule and produce data for this procedure \n" if $?;

  print "PID: $pid Name: $patientName Code: $procedureCode \n";
  return 0;
}

# processCardiologyScheduleMPPSTriggerNoOrder
sub processCardiologyScheduleMPPSTriggerNoOrder {
  my ($logLevel, $selfTest, $src, $dst, $event, $msg, $outputDir, $inputDir, $SPSCode, $PPSCode, $SPSLocation, $scheduledAET, $modality, $SPSIndex, $mppsDir)  = @_;

  my $hl7Msg = "../../msgs/" . $msg;
  my $pid           = mesa::getField($hl7Msg, "PID", "3", "1", "Patient ID");
  my $patientName   = mesa::getField($hl7Msg, "PID", "5", "0", "Patient Name");
  my $universalServiceID = mesa::getField($hl7Msg, "OBR", "4", "0", "Universal Service ID");
  my $procedureCode = mesa::getField($hl7Msg, "OBR", "4", "1", "Procedure Code");

  print "This is the MESA scheduling step that is triggered by MPPS events in Cath Workflow\n";
  print "By now, you have already scheduled steps on your MWL server\n";
  print "The MESA tools will now perform appropriate scheduling\n";
  print " The Patient ID is $pid\n";
  print " The Patient Name is $patientName\n";
  print " The Universal Service ID is $universalServiceID\n";
  print " The Procedure Code  is $procedureCode\n";
  print " The modality should be $modality\n";
  print " The scheduled AE title should be $scheduledAET\n";
  print " The SPS Location should be $SPSLocation\n";
  print " The SPS Index (MESA convention) is $SPSIndex\n";
  print "Hit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  main::goodbye if ($x =~ /^q/);

  my ($status, $uid) = mesa::getDICOMAttribute($logLevel, "$main::MESA_STORAGE/modality/$mppsDir/x1.dcm", "0020 000D");
  mesa::setField($logLevel, $hl7Msg, "ZDS", 1, 0, "Study Instance UID", "$uid^100^Application^DICOM");

  $mppsDir = "$main::MESA_STORAGE/modality/$mppsDir";
  if ($modality eq "IVUS") {
    mesa::local_scheduling_ivus_mpps_trigger_no_order($logLevel, $SPSLocation, $scheduledAET, $SPSCode, $SPSIndex, $mppsDir, $universalServiceID);
  } elsif ($modality eq "XA") {
    mesa::local_scheduling_xa_mpps_trigger_no_order($logLevel, $SPSLocation, $scheduledAET, $SPSCode, $SPSIndex, $mppsDir, $universalServiceID);
  } elsif ($modality eq "ECHO") {
    mesa::local_scheduling_echo_mpps_trigger_no_order($logLevel, $SPSLocation, $scheduledAET, $SPSCode, $SPSIndex, $mppsDir, $universalServiceID);
  } else {
    die "Unrecognized modality type for local scheduling: $modality \n";
  }

  $x = "perl ../../../rad/actors/ordfil/scripts/produce_scheduled_images.pl $modality MESA_MOD " .
	" $pid $procedureCode $outputDir " .
	" $main::mwlAE $main::mwlHost $main::mwlPort " .
	" $SPSCode $PPSCode $inputDir ";
  print "$x \n";
  print `$x`;
  die "Could not schedule and produce data for this procedure \n" if $?;

  print "PID: $pid Name: $patientName Code: $procedureCode \n";
  return 0;
}

sub processCardiologyScheduleMPPSTriggerNoOrderWithADT {
  my ($logLevel, $selfTest, $src, $dst, $event, $msg, $outputDir, $inputDir, $SPSCode, $PPSCode, $SPSLocation, $scheduledAET, $modality, $SPSIndex, $mppsDir, $adt)  = @_;

  my $hl7Msg = "../../msgs/" . $msg;
  my $adtMsgPath = "../../msgs/$adt";
  my $pid           = mesa::getField($adtMsgPath, "PID", "3", "1", "Patient ID");
  my $patientName   = mesa::getField($adtMsgPath, "PID", "5", "0", "Patient Name");
  my $universalServiceID = mesa::getField($hl7Msg, "OBR", "4", "0", "Universal Service ID");
  my $procedureCode = mesa::getField($hl7Msg, "OBR", "4", "1", "Procedure Code");

print $pid."\n";
print $patientName."\n";
print $universalServiceID."\n";
print $procedureCode."\n";
  print "This is the MESA scheduling step that is triggered by MPPS events in Cath Workflow\n";
  print "By now, you have already scheduled steps on your MWL server\n";
  print "The MESA tools will now perform appropriate scheduling\n";
  print " The Universal Service ID is $universalServiceID\n";
  print " The Procedure Code  is $procedureCode\n";
  print " The modality should be $modality\n";
  print " The scheduled AE title should be $scheduledAET\n";
  print " The SPS Location should be $SPSLocation\n";
  print " The SPS Index (MESA convention) is $SPSIndex\n";
  print "Hit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  main::goodbye if ($x =~ /^q/);

  $mppsDir = "$main::MESA_STORAGE/modality/$mppsDir";
  if ($modality eq "IVUS") {
    die "processCardiologyScheduleMPPSTriggerNoOrderWithADT not ready for IVUS";
    mesa::local_scheduling_ivus_mpps_trigger_no_order($logLevel, $SPSLocation, $scheduledAET, $SPSCode, $SPSIndex, $mppsDir, $universalServiceID);
  } elsif ($modality eq "XA") {
    die "processCardiologyScheduleMPPSTriggerNoOrderWithADT not ready for XA";
    mesa::local_scheduling_xa_mpps_trigger_no_order($logLevel, $SPSLocation, $scheduledAET, $SPSCode, $SPSIndex, $mppsDir, $universalServiceID);
  } elsif ($modality eq "ECHO") {
    mesa::local_scheduling_echo_mpps_trigger_no_order_with_demographics($logLevel, $SPSLocation, $scheduledAET, $SPSCode, $SPSIndex, $mppsDir, $universalServiceID, $pid, $patientName);
  } else {
    die "Unrecognized modality type for local scheduling: $modality \n";
  }

  $x = "perl ../../../rad/actors/ordfil/scripts/produce_scheduled_images.pl $modality MESA_MOD " .
	" $pid $procedureCode $outputDir " .
	" $main::mwlAE $main::mwlHost $main::mwlPort " .
	" $SPSCode $PPSCode $inputDir ";
  print "$x \n";
  print `$x`;
  die "Could not schedule and produce data for this procedure \n" if $?;

  print "PID: $pid Name: $patientName Code: $procedureCode \n";
  return 0;
}

sub echoOrderMPPSTrigger {
  my ($logLevel, $selfTest, $src, $dst, $event, $msg, $outputDir, $inputDir, $SPSCode, $PPSCode, $SPSLocation, $scheduledAET, $modality, $SPSIndex, $mppsDir)  = @_;

  my $hl7Msg = "../../msgs/" . $msg;
  my $pid           = mesa::getField($hl7Msg, "PID", "3", "1", "Patient ID");
  my $patientName   = mesa::getField($hl7Msg, "PID", "5", "0", "Patient Name");
  my $universalServiceID = mesa::getField($hl7Msg, "OBR", "4", "0", "Universal Service ID");
  my $procedureCode = mesa::getField($hl7Msg, "OBR", "4", "1", "Procedure Code");

  print "This is the MESA ordering step that is triggered by MPPS events in Echo Workflow\n";
  print "By now, you have already produced the appropriate ORM message to send to the Order Placer\n";
  print " The Universal Service ID is $universalServiceID\n";
  print "Hit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  main::goodbye if ($x =~ /^q/);
}

sub echoScheduleMessageMPPSTrigger {
  my ($logLevel, $selfTest, $src, $dst, $event, $msg, $mppsDir)  = @_;

  my $hl7Msg = "../../msgs/" . $msg;
  my $pid           = mesa::getField($hl7Msg, "PID", "3", "1", "Patient ID");
  my $patientName   = mesa::getField($hl7Msg, "PID", "5", "0", "Patient Name");
  my $universalServiceID = mesa::getField($hl7Msg, "OBR", "4", "0", "Universal Service ID");
  my $procedureCode = mesa::getField($hl7Msg, "OBR", "4", "1", "Procedure Code");

  print "This is the MESA that produces a scheduling message for Image Mgrs based on MPPS triggers\n";
  print "By now, you have already produced the appropriate ORM message to send to the Image Manager\n";
  print " The Patient Name is         $patientName\n";
  print " The Patient ID is           $pid\n";
  print " The Universal Service ID is $universalServiceID\n";
  print " The MPPS directory          $mppsDir\n";
  print "Hit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  main::goodbye if ($x =~ /^q/);

  my $z = mesa::update_scheduling_ORM_post_procedure($logLevel, $hl7Msg, "$main::MESA_STORAGE/modality/$mppsDir",
	"ACCESSION", "REQUESTED", "SPSID");
  return 1 if ($z);

  return 0;
}

sub processCardiologyScheduleMessage {
  my ($logLevel, $selfTest, $src, $dst, $event, $msg, $outputDir, $inputDir, $SPSCode, $PPSCode, $SPSLocation, $scheduledAET)  = @_;

  my $hl7Msg = "../../msgs/" . $msg;
  my $pid           = mesa::getField($hl7Msg, "PID", "3", "1", "Patient ID");
  my $patientName   = mesa::getField($hl7Msg, "PID", "5", "0", "Patient Name");
  my $universalServiceID= mesa::getField($hl7Msg, "OBR", "4", "0", "Universal Service ID");
  my $modality      = mesa::getField($hl7Msg, "OBR", "24", "1", "Service Sector ID");

  print "This is the scheduling prelude to transaction Rad-4\n";
  print "Your DSS/OF should schedule SPS step(s) for $patientName\n";
  print " The Universal Service ID is $universalServiceID\n";
  print " The modality should be $modality\n";
  print " The Scheduled AE Title should be $scheduledAET\n";
  print " The SPS Location should be $SPSLocation\n";
  print "Hit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  main::goodbye if ($x =~ /^q/);

  return 0;
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
#  my $modality  = $tokens[2];
#  print "Local scheduling for file: $orderFile \n";
#  if ($modality eq "MR") {
#    ordfil::local_scheduling_mr();
#  } elsif ($modality eq "RT") {
#    ordfil::local_scheduling_rt();
#  } else {
#    printf "Unrecognized modality type for local scheduling: $modality \n";
#    exit 1;
#  }
#  return 0;
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

  my $pid         = mesa::getField($hl7Msg, "PID", "3", "0", "Patient ID");
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
  } elsif ($verb[0] eq "TEXT") {
    printText($cmd);
#  } elsif ($verb[0] eq "LOCALSCHEDULING") {
#    localScheduling($cmd);
  } elsif ($verb[0] eq "UNSCHEDULED-IMAGES") {
    $rtnValue = unscheduledImages($cmd, $logLevel, $selfTest);
  } elsif ($verb[0] eq "PATIENT") {
    printPatient($cmd);
  } elsif ($verb[0] eq "PROFILE") {
    if ($verb[1] ne "SCHEDULED_WORKFLOW") {
      die "This Order Filler script is for the SWF profile, not $verb[1]";
    }
  } elsif (substr($verb[0], 0, 1) eq "#") {
    print "Comment: $cmd \n";
  } else {
    die "Did not recognize verb in command: $cmd \n";
  }
  return $rtnValue;
}

1;
