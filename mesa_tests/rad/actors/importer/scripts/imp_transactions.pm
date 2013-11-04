#!/usr/local/bin/perl -w

# This module contains the functions for handling transactions
# in the context of the "Importer" actor.

use Env;

package imp_transactions;
require Exporter;
@ISA = qw(Exporter);


sub processTransaction1 {
  my ($logLevel, $selfTest, $src, $dst, $event, $msg) = @_;

  #if ($dst ne "PMI") {
  #if ($dst eq "PMI") {
  #  print "IHE Transaction RAD-1 from ($src) to ($dst) is not required for PMI test\n";
  #  return 0;
  #}

  my ($pid, $patientName, $status) = ("", "", "");
  my $hl7Msg = "../../msgs/$msg";
  ($Status, $pid) = mesa_get::getHL7Field($logLevel, $hl7Msg, "PID", "3", "0", "Patient ID", "2.3.1");
  ($status, $patientName) = mesa_get::getHL7Field($logLevel, $hl7Msg, "PID", "5", "0", "Patient Name", "2.3.1");

  print "IHE Transaction Rad-1: $pid $patientName \n";

  #if ($selfTest == 0) {
    print "MESA $src will send ADT message ($msg) for event $event to MESA $dst\n";
    $x = mesa_xmit::send_hl7(
	$logLevel, "../../msgs/$msg", "localhost",
	$main::mesaOFPortHL7, "2.3.1");
    mesa::xmit_error($msg) if ($x != 0);
  #}

  #print "\nMESA will now send ADT message ($msg) to your PMI actor ($main::testPMIHostHL7 $main::testPMIPortHL7) \n";
  #print "Hit <ENTER> when ready (q to quit) --> ";
  #my $x = <STDIN>;
  #main::goodbye if ($x =~ /^q/);
  #$x = mesa_xmit::send_hl7(
	#$logLevel, "../../msgs/$msg", $main::testPMIHostHL7, $main::testPMIPortHL7, "2.3.1");
  #mesa::xmit_error($msg) if ($x != 0);
   print "\n";
  return 0;
}

sub processTransaction1Secure {
  return 1;
#  my ($logLevel, $selfTest, $src, $dst, $event, $msg) = @_;
#
#  if ($dst ne "OF") {
#    print "IHE Transaction 1 from ($src) to ($dst) is not required for DSS/OF test\n";
#    return 0;
#  }
#
#  my $hl7Msg = "../../msgs/" . $msg;
#  my $pid = mesa::getField($hl7Msg, "PID", "3", "0", "Patient ID");
#  my $patientName = mesa::getField($hl7Msg, "PID", "5", "0", "Patient Name");
#
#  print "IHE Transaction 1: $pid $patientName \n";
#
#  if ($selfTest == 0) {
#    print "MESA will send ADT message ($msg) for event $event to MESA $dst\n";
#    $x = mesa::send_hl7_secure(
#	"../../msgs", $msg, "localhost", $main::mesaOrderFillerPortHL7,
#	"randoms.dat",
#	"mesa_1.key.pem",
#	"mesa_1.cert.pem",
#	"test_sys_1.cert.pem",
#	"NULL-SHA");
#    mesa::xmit_error($msg) if ($x != 0);
#  }
#
#  print "\nMESA will now send ADT message ($msg) to your Order Filler ($main::ofHostHL7 $main::ofPortHL7) \n";
#  print "Hit <ENTER> when ready (q to quit) --> ";
#  my $x = <STDIN>;
#  main::goodbye if ($x =~ /^q/);
#  $x = mesa::send_hl7_secure(
#	"../../msgs", $msg, $main::ofHostHL7, $main::ofPortHL7,
#	"randoms.dat",
#	"mesa_1.key.pem",
#	"mesa_1.cert.pem",
#	"test_sys_1.cert.pem",
#	"NULL-SHA");
#  mesa::xmit_error($msg) if ($x != 0);
#  
#   print "\n";
#  return 0;
}

sub processTransaction2 {
  my ($logLevel, $selfTest, $src, $dst, $event, $msg) = @_;

  my ($hl7Msg, $pid, $patientName, $procedureCode, $placerOrderNumber, $x) = (0,0,0,0,0,0);

  $hl7Msg = "../../msgs/" . $msg;
  ($x, $pid)               = mesa_get::getHL7Field($logLevel, $hl7Msg, "PID", "3", "0", "Patient ID", "2.3.1");
  return 1 if ($x != 0);
  ($x, $patientName)       = mesa_get::getHL7Field($logLevel, $hl7Msg, "PID", "5", "0", "Patient Name", "2.3.1");
  return 1 if ($x != 0);
  ($x, $procedureCode)     = mesa_get::getHL7Field($logLevel, $hl7Msg, "OBR", "4", "0", "Procedure Code", "2.3.1");
  return 1 if ($x != 0);
  ($x, $placerOrderNumber) = mesa_get::getHL7Field($logLevel, $hl7Msg, "ORC", "2", "0", "Placer Order Number", "2.3.1");
  return 1 if ($x != 0);

  print "IHE Rad-2: $pid $patientName $procedureCode \n";

  # Send a copy of the Order to MESA for our own purposes.
  print "MESA $src will send ORM message ($msg) for event $event to MESA $dst\n";
  $x = mesa_xmit::send_hl7($logLevel, $hl7Msg, $main::mesaOFHost, $main::mesaOFPortHL7, "2.3.1");
  mesa::xmit_error($msg) if ($x != 0);

  print "\n";
  return 0;
}

sub processTransaction2Secure {
  return 1;
#  my ($logLevel, $selfTest, $src, $dst, $event, $msg) = @_;
#
#  my $hl7Msg = "../../msgs/" . $msg;
#  my $pid               = mesa::getField($hl7Msg, "PID", "3", "0", "Patient ID");
#  my $patientName       = mesa::getField($hl7Msg, "PID", "5", "0", "Patient Name");
#  my $procedureCode     = mesa::getField($hl7Msg, "OBR", "4", "0", "Procedure Code");
#  my $placerOrderNumber = mesa::getField($hl7Msg, "ORC", "2", "0", "Placer Order Number");
#
#  print "\nIHE Transaction 2: $pid $patientName $procedureCode \n";
#  print "MESA will now send ORM^O01 message ($msg) to your Order Filler ($main::ofHostHL7 $main::ofPortHL7) \n" if ($event eq "ORDER");
#  print "MESA will now send ORR^O02 message ($msg) to your Order Filler ($main::ofHostHL7 $main::ofPortHL7) \n" if ($event eq "ORDER_O02");
#  print " Placer Order Number $placerOrderNumber \n";
#  print "Hit <ENTER> when ready (q to quit) --> ";
#  my $x = <STDIN>;
#  main::goodbye if ($x =~ /^q/);
#  $x = mesa::send_hl7_secure(
#	"../../msgs", $msg, $main::ofHostHL7, $main::ofPortHL7,
#	"randoms.dat",
#	"mesa_1.key.pem",
#	"mesa_1.cert.pem",
#	"test_sys_1.cert.pem",
#	"NULL-SHA");
#  mesa::xmit_error($msg) if ($x != 0);
#
#  if ($selfTest == 1) {
#    print "Looks like this is run directly for MESA testing; skip order copy to MESA DSS/OF \n";
#  } else {
#    # Send a copy of the Order to MESA for our own purposes.
#    print "MESA will send ORM message ($msg) for event $event to MESA $dst\n";
#    $x = mesa::send_hl7_secure(
#	"../../msgs", $msg, "localhost", $main::mesaOrderFillerPortHL7,
#	"randoms.dat",
#	"mesa_1.key.pem",
#	"mesa_1.cert.pem",
#	"test_sys_1.cert.pem",
#	"NULL-SHA");
#    mesa::xmit_error($msg) if ($x != 0);
#  }
#  return 0;
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
  return 1;
#  my ($logLevel, $selfTest, $src, $dst, $event, $msg, $extraOrder) = @_;
#  my $rtn = 1;
#  if ($dst eq "OF") {
#    $rtn = transaction3_OF(@_);
#  } elsif ($dst eq "OP") {
#    $rtn = transaction3_OP(@_);
#  } else {
#    print "For transaction3, we do not recognize destination $dst\n";
#    $rtn = 1;
#  }
#  return $rtn;
}

sub processTransaction5 {
  my ($logLevel, $selfTest, $src, $dst, $event, $msg, $outDir) = @_;

  my $hl7Msg = "../../msgs/" . $msg;
  my $pid = mesa::getField($hl7Msg, "PID", "3", "0", "Patient ID");
  my $pidShort = mesa::getField($hl7Msg, "PID", "3", "1", "Patient ID");
  my $patientName = mesa::getField($hl7Msg, "PID", "5", "0", "Patient Name");
  my $procedureCode = mesa::getField($hl7Msg, "OBR", "4", "0", "Procedure Code");

  print "IHE Transaction RAD-5: $pid $patientName $procedureCode \n";
  print "IMPORTER actor is expected to send MWL query for Patient ID $pidShort\n";
  print "MWL query should go to $main::mesaOFAEMWL (hostname: " . mesa_get::getHostName() . ", port:$main::mesaOFPortDICOM)\n";
  print "Hit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  main::goodbye if ($x =~ /^q/);

  #if ($selfTest == 1) {
    $x = mesa::construct_mwl_query_pid(
	$logLevel, "mwl/mwlquery_template.txt", "mwl/mwlquery_pid.txt",
	"mwl/mwlquery_pid.dcm", $pidShort);

    if ($x != 0){
      print "\nError in mesa::construct_mwl_query_pid.\n";
      return 1;
    }

    if ($logLevel >= 3){
      print "MESA testing tool is about to send MWL query for subsequent internal actions.\n";
      #print "\$logLevel: ".$logLevel."\n";
      #print "\$mesaOFAEMWL: ".$main::mesaOFAEMWL."\n";
      #print "\$mesaOFHost: ".$main::mesaOFHost."\n";
      #print "\$outDir: ".$outDir."\n";
      #print "About to send MWL query to MESA system.\n";
    }
    $x = mesa::send_cfind_mwl($logLevel, "mwl/mwlquery_pid.dcm",
      $main::mesaOFAEMWL, $main::mesaOFHost, $main::mesaOFPortDICOM, $outDir . "/test");
    if ($x != 0){
      print "\nError in mesa::send_cfind_mwl.\n";
      return 1;
    }
  #}

  return 0;
}


sub processTransaction12 {
  return 1;
#  my ($logLevel, $selfTest, $src, $dst, $event, $msg) = @_;
#
#  if ($dst ne "PMI") {
#    print "IHE Transaction RAD-12 from ($src) to ($dst) is not required for PMI test\n";
#    return 0;
#  }
#
#  my ($pid, $patientName, $status) = ("", "", "");
#  my $hl7Msg = "../../msgs/$msg";
#  ($status, $pid) = mesa_get::getHL7Field($logLevel, $hl7Msg, "PID", "3", "0", "Patient ID", "2.3.1");
#  ($status, $patientName) = mesa_get::getHL7Field($logLevel, $hl7Msg, "PID", "5", "0", "Patient Name", "2.3.1");
#
#  print "IHE Transaction Rad-12: $pid $patientName \n";
#
#  if ($selfTest == 0) {
#    print "MESA will send ADT message ($msg) for event $event to MESA $dst\n";
#    $x = mesa::send_hl7_log(
#	$logLevel, "../../msgs/$msg", "localhost",
#	$main::mesaPMIPortHL7);
#    mesa::xmit_error($msg) if ($x != 0);
#  }
#
#  print "\nMESA will now send ADT message ($msg) to your PMI actor ($main::testPMIHostHL7 $main::testPMIPortHL7) \n";
#  print "Hit <ENTER> when ready (q to quit) --> ";
#  my $x = <STDIN>;
#  main::goodbye if ($x =~ /^q/);
#  $x = mesa_xmit::send_hl7(
#	$logLevel, "../../msgs/$msg", $main::testPMIHostHL7, $main::testPMIPortHL7, "2.3.1");
#  mesa::xmit_error($msg) if ($x != 0);
#  return 0;
}

# processTransaction59
# This is MPPS In Progress
sub processTransaction59 {
  my ($logLevel, $selfTest, $src, $dst, $event, $input, $modalityAEMPPS) = @_;

  print "IHE RAD-59: \n";
  print "IMPORTER actor is expected to send MPPS IN PROGRESS message (N-Create)\n";
  print "MPPS N-Create should go to MESA Image Manager ($main::mesaIMAEMPPS, $main::mesaIMPortDICOM)\n";
  print "Hit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  return 1 if ($x =~ /^q/);

  if ($selfTest == 1) {
    my $inputDir = "$main::MESA_STORAGE/$input";
    $status = mesa_xmit::send_MPPS_in_progress($logLevel, $inputDir, $modalityAEMPPS, $main::mesaIMAEMPPS, "localhost", $main::mesaIMPortDICOM);
    if ($status != 0) {
      print "imp_transactions::processTransaction59 could not send MPPS N-Create to MESA in self test mode\n";
      return 1;
    }
  }
  return 0;
}

# processTransaction60
# This is MPPS COMPLETED or DISCONTINUED
sub processTransaction60 {
  my ($logLevel, $selfTest, $src, $dst, $event, $input, $modalityAEMPPS) = @_;

  print "IHE RAD-60: \n";
  print "IMPORTER actor is expected to send MPPS $event message (N-Set)\n";
  print "MPPS N-Set should go to MESA Image Manager ($main::mesaIMAEMPPS, $main::mesaIMPortDICOM)\n";
  print "Hit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  return 1 if ($x =~ /^q/);

  if ($selfTest == 1) {
    my $inputDir = "$main::MESA_STORAGE/$input";
    $status = mesa_xmit::send_MPPS_complete($logLevel, $inputDir, $modalityAEMPPS, $main::mesaIMAEMPPS, "localhost", $main::mesaIMPortDICOM);
    if ($status != 0) {
      print "imp_transactions::processTransaction60 could not send MPPS N-Set to MESA in self test mode\n";
      return 1;
    }
  }
  return 0;
}

# processTransaction61
# This is C-Store
sub processTransaction61 {
  my ($logLevel, $selfTest, $src, $dst, $event, $input, $modalityAECStore) = @_;

  print "IHE RAD-61: \n";
  print "IMPORTER actor is expected to send DICOM objects (C-Store)\n";
  print "C-Store should go to MESA Image Manager ($main::mesaIMAECStore, $main::mesaIMPortDICOM)\n";
  print "Hit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  main::goodbye if ($x =~ /^q/);

  if ($selfTest == 1) {
    my $inputDir = "$main::MESA_STORAGE/$input";
    $status = mesa_xmit::sendCStoreDirectory($logLevel, "", $inputDir, $modalityAECStore, $main::mesaIMAECStore, "localhost", $main::mesaIMPortDICOM, 0);
    if ($status != 0) {
      print "imp_transactions::processTransaction61 could not C-Store objects to MESA in self test mode\n";
      return 1;
    }
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
#  print " The Procedure Code is $procedureCode\n";
#  print " The modality should be $modality\n";
#  print " The SPS Location should be $SPSLocation\n";
#  print " PID: $pid Name: $patientName Code: $procedureCode \n";
#  print "Hit <ENTER> when ready (q to quit) --> ";
#  my $x = <STDIN>;
#  main::goodbye if ($x =~ /^q/);
#
#  if ($modality eq "MR") {
##    pmi::local_scheduling_mr($logLevel, $SPSLocation, $scheduledAET);
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
  print " The Procedure Code is $procedureCode\n";
  print " The modality should be $modality\n";
  print " The SPS Location should be $SPSLocation\n";
  print "Hit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  main::goodbye if ($x =~ /^q/);

  if ($modality eq "MR") {
#    pmi::local_scheduling_mr($logLevel, $SPSLocation, $scheduledAET);
    mesa::local_scheduling_mr($logLevel, $SPSLocation, $scheduledAET);
  } elsif ($modality eq "RT") {
    pmi::local_scheduling_rt($logLevel, $SPSLocation, $scheduledAET);
  } elsif ($modality eq "HD") {
    pmi::local_scheduling_hd($logLevel, $SPSLocation, $scheduledAET);
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
#  print " The Procedure Code is $procedureCode\n";
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
  print " The Procedure Code is $procedureCode\n";
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
  print " The Procedure Code is $procedureCode\n";
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
  print " The Procedure Code is $procedureCode\n";
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
#    pmi::local_scheduling_mr();
#  } elsif ($modality eq "RT") {
#    pmi::local_scheduling_rt();
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
