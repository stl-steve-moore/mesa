#!/usr/local/bin/perl -w

# Common routines for Patient Demographic Workflow

use Env;

package pd_consumer;
require Exporter;
@ISA = qw(Exporter);


sub print_config_params {
  foreach $varname (keys %varnames) {
    print "Variable $varname = $varnames{$varname} \n";
  }
}

sub processTransaction8 {
  my $logLevel = shift(@_);
  my $selfTest = shift(@_);
  my $src = shift(@_);
  my $dst = shift(@_);
  my $event = shift(@_);
  my $msg = shift(@_);

  if ($dst ne "PD_SUPPLIER") {
    print "IHE Transaction 8 from ($src) to ($dst) is not required for PD Consumer test\n";
    return 0;
  }

  my $hl7Msg = "../../msgs/" . $msg;
  my ($x, $pid, $patientName);
  ($x, $pid) = mesa::getFieldLog($logLevel, $hl7Msg, "PID", "3", "0", "Patient ID");
  return 1 if ($x != 0);

  ($x, $patientName) = mesa::getFieldLog($logLevel, $hl7Msg, "PID", "5", "0", "Patient Name");
  return 1 if ($x != 0);

  print "IHE Transaction 8: $pid $patientName \n";
  print "MESA Patient ID Source will send ADT message to the MESA PD Supplier.\n";
  print "The event type is: $event\n";
  print "host: $main::mesaPDSHostHL7, port $main::mesaPDSPortHL7 \n";
  print "Name: $patientName, PID: $pid\n";

  print "Hit <ENTER> when ready (q to quit) --> ";
  $x = <STDIN>;
  main::goodbye if ($x =~ /^q/);

  $x = mesa::send_hl7_log($logLevel, "../../msgs", $msg, $main::mesaPDSHostHL7, $main::mesaPDSPortHL7);
  mesa::xmit_error($msg) if ($x != 0);

  return 0;
}

sub processTransaction8MESAOnly {
  my $logLevel = shift(@_);
  my $selfTest = shift(@_);
  my $src = shift(@_);
  my $dst = shift(@_);
  my $event = shift(@_);
  my $msg = shift(@_);

  if ($dst ne "PD_SUPPLIER") {
    print "IHE Transaction 8 from ($src) to ($dst) is not required for PD Supplier test\n";
    return 0;
  }

  my $hl7Msg = "../../msgs/" . $msg;
  my ($x, $pid, $patientName);
  ($x, $pid) = mesa::getFieldLog($logLevel, $hl7Msg, "PID", "3", "0", "Patient ID");
  return 1 if ($x != 0);

  ($x, $patientName) = mesa::getFieldLog($logLevel, $hl7Msg, "PID", "5", "0", "Patient Name");
  return 1 if ($x != 0);

  print "IHE Transaction 8: $pid $patientName \n";
  print "MESA Patient ID Source will send ADT message to MESA PD Supplier.\n";
  print "The event type is: $event\n";
  print "host: $main::mesaPDSHostHL7, port $main::mesaPDSPortHL7 \n";
  print "Name: $patientName, PID: $pid\n";

  print "Hit <ENTER> when ready (q to quit) --> ";
  $x = <STDIN>;
  main::goodbye if ($x =~ /^q/);

  $x = mesa::send_hl7_log($logLevel, "../../msgs", $msg, $main::mesaPDSHostHL7, $main::mesaPDSPortHL7);
  mesa::xmit_error($msg) if ($x != 0);

  return 0;
}

sub processTransaction9 {
  my ($logLevel, $selfTest, $src, $dst, $event, $msg, $testOutputFile, $mesaOutputFile) = @_;

  if ($dst ne "XREF") {
    print "IHE Transaction 9 from ($src) to ($dst) is not required for XRef Mgr test\n";
    return 0;
  }
  mesa::rm_files($testOutputFile);
  mesa::rm_files($mesaOutputFile);

  my $hl7Msg = "../../msgs/" . $msg;
  my ($x, $pid);
  ($x, $pid) = mesa::getFieldLog($logLevel, $hl7Msg, "QPD", "3", "0", "Person ID");
  return 1 if ($x != 0);

  print "IHE Transaction 9: $pid \n";
  print "MESA Patient ID Consumer will send QBP message to your XRef Mgr.\n";
  print "The event type is: $event\n";
  print "host: $main::testXRefHostHL7, port $main::testXRefPortHL7 \n";
  print "PID: $pid\n";

  print "Hit <ENTER> when ready (q to quit) --> ";
  $x = <STDIN>;
  main::goodbye if ($x =~ /^q/);

  $x = mesa::send_hl7_capture($logLevel, "../../msgs", $msg,
	$main::testXRefHostHL7, $main::testXRefPortHL7, $testOutputFile);
  mesa::xmit_error($msg) if ($x != 0);

  $x = mesa::send_hl7_capture($logLevel, "../../msgs", $msg,
	$main::mesaXRefHostHL7, $main::mesaXRefPortHL7, $mesaOutputFile);
  mesa::xmit_error($msg) if ($x != 0);

  return 0;
}

sub processTransaction21 {
  my ($logLevel, $selfTest, $src, $dst, $event, $msg, $testOutputDirectory, $mesaOutputDirectory) = @_;

  if ($dst ne "PD_SUPPLIER") {
    print "IHE Transaction 21 from ($src) to ($dst) is not required for PDQ Supplier test\n";
    return 0;
  }
  mesa::delete_directory($logLevel, $mesaOutputDirectory);
  mesa::create_directory($logLevel, $mesaOutputDirectory);

  my $hl7Msg = "../../msgs/" . $msg;
  my ($x, $pid);
  ($x, $pid) = mesa::getFieldLog($logLevel, $hl7Msg, "QPD", "3", "0", "Demographics");
  return 1 if ($x != 0);

  print "IHE ITI Transaction 21: $pid \n";
  print "Your Patient Demographics Consumer should send QBP message to the MESA PD Supplier.\n";
  print "The event type is: $event\n";
  print "Your query specification should be: $pid\n";
  print "MESA port $main::mesaPDSPortHL7 \n";

  print "Hit <ENTER> when ready (q to quit) --> ";
  $x = <STDIN>;
  main::goodbye if ($x =~ /^q/);

  if ($selfTest) {
    $x = mesa::send_hl7_pdq_query($logLevel, "../../msgs", $msg,
	$main::mesaPDSHostHL7, $main::mesaPDSPortHL7, $mesaOutputDirectory);
    mesa::xmit_error($msg) if ($x != 0);
  }

  return 0;
}

sub processTransaction30 {
  my $logLevel = shift(@_);
  my $selfTest = shift(@_);
  my $src = shift(@_);
  my $dst = shift(@_);
  my $event = shift(@_);
  my $msg = shift(@_);

  my $hl7Msg = "../../msgs/" . $msg;
  my ($x, $pid, $patientName);
  ($x, $pid) = mesa::getFieldLog($logLevel, $hl7Msg, "PID", "3", "0", "Patient ID");
  ($x, $patientName) = mesa::getFieldLog($logLevel, $hl7Msg, "PID", "5", "0", "Patient Name");

  print "IHE Transaction 30: $pid $patientName \n";
  print "\nMESA will send ADT message for event ($event) to your Test Patient Demographics Consumer ($main::testPDCPAMHostHL7)\n";
  print "Hit <ENTER> when ready (q to quit) --> ";
  $x = <STDIN>;
  main::goodbye if ($x =~ /^q/);
  $x = mesa::send_hl7_log($logLevel, "../../msgs", $msg, $main::testPDCPAMHostHL7, $main::testPDCPAMPortHL7);
  mesa::xmit_error($msg) if ($x != 0);

  if ($selfTest == 1) {
    print "MESA will send ADT message ($msg) for event $event to MESA $dst\n";
    $x = mesa::send_hl7_log($logLevel, "../../msgs", $msg, "localhost", $main::mesaPDCPAMPortHL7);
    mesa::xmit_error($msg) if ($x != 0);
  }

  return 0;
}

1;
