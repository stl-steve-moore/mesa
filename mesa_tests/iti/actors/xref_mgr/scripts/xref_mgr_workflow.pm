#!/usr/local/bin/perl -w

# Common routines for ADT workflow tests.

use Env;

package xref_mgr;
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

  if ($dst ne "XREF") {
    print "IHE Transaction 8 from ($src) to ($dst) is not required for XRef Mgr test\n";
    return 0;
  }

  my $hl7Msg = "../../msgs/" . $msg;
  my ($x, $pid, $patientName);
  ($x, $pid) = mesa::getFieldLog($logLevel, $hl7Msg, "PID", "3", "0", "Patient ID");
  return 1 if ($x != 0);

  ($x, $patientName) = mesa::getFieldLog($logLevel, $hl7Msg, "PID", "5", "0", "Patient Name");
  return 1 if ($x != 0);

  print "IHE Transaction 8: $pid $patientName \n";
  print "MESA Patient ID Source will send ADT message to your XRef Mgr.\n";
  print "The event type is: $event\n";
  print "host: $main::testXRefHostADTHL7, port $main::testXRefPortADTHL7 \n";
  print "Name: $patientName, PID: $pid\n";

  print "Hit <ENTER> when ready (q to quit) --> ";
  $x = <STDIN>;
  main::goodbye if ($x =~ /^q/);

  $x = mesa::send_hl7_log($logLevel, "../../msgs", $msg, $main::testXRefHostADTHL7, $main::testXRefPortADTHL7);
  mesa::xmit_error($msg) if ($x != 0);

  # Send a copy of the message to the MESA XRef Manager
  $x = mesa::send_hl7_log($logLevel, "../../msgs", $msg, $main::mesaXRefHostHL7, $main::mesaXRefPortHL7);
  mesa::xmit_error($msg) if ($x != 0);

  return 0;
}

sub processTransaction9 {
  my ($logLevel, $selfTest, $src, $dst, $event, $msg, $testOutputFile, $mesaOutputFile) = @_;

  if ($dst ne "XREF") {
    print "IHE Transaction 9 from ($src) to ($dst) is not required for XRef Mgr test\n";
    return 0;
  }
  mesa::delete_directory($logLevel, $testOutputFile);
  mesa::delete_directory($logLevel, $mesaOutputFile);
  mesa::create_directory($logLevel, $testOutputFile);
  mesa::create_directory($logLevel, $mesaOutputFile);

  my $hl7Msg = "../../msgs/" . $msg;
  my ($x, $pid);
  ($x, $pid) = mesa::getFieldLog($logLevel, $hl7Msg, "QPD", "3", "0", "Person ID");
  return 1 if ($x != 0);

  print "IHE Transaction 9: $pid \n";
  print "MESA Patient ID Consumer will send QBP message to your XRef Mgr.\n";
  print "The event type is: $event\n";
  print "host: $main::testXRefHostQueryHL7, port $main::testXRefPortQueryHL7 \n";
  print "PID: $pid\n";

  print "Hit <ENTER> when ready (q to quit) --> ";
  $x = <STDIN>;
  main::goodbye if ($x =~ /^q/);

#  $x = mesa::send_hl7_capture($logLevel, "../../msgs", $msg,
  $x = mesa::send_hl7_pdq_query($logLevel, "../../msgs", $msg,
	$main::testXRefHostQueryHL7, $main::testXRefPortQueryHL7, $testOutputFile);
  mesa::xmit_error($msg) if ($x != 0);

#  $x = mesa::send_hl7_capture($logLevel, "../../msgs", $msg,
  $x = mesa::send_hl7_pdq_query($logLevel, "../../msgs", $msg,
	$main::mesaXRefHostHL7, $main::mesaXRefPortHL7, $mesaOutputFile);
  mesa::xmit_error($msg) if ($x != 0);

  return 0;
}

1;
