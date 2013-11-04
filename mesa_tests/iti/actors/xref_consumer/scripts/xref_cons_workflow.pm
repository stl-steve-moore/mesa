#!/usr/local/bin/perl -w

# Common routines for ADT workflow tests.

use Env;

package xref_cons;
require Exporter;
@ISA = qw(Exporter);


sub print_config_params {
  foreach $varname (keys %varnames) {
    print "Variable $varname = $varnames{$varname} \n";
  }
}

sub processTransaction8 {
  my ($logLevel, $selfTest, $src, $dst, $event, $msg) = @_;

  if ($dst ne "XREF") {
    print "IHE Transaction 8 from ($src) to ($dst) is not required for XRef Consumer test\n";
    return 0;
  }

  my $hl7Msg = "../../msgs/" . $msg;
  my ($x, $pid, $patientName);
  ($x, $pid) = mesa::getFieldLog($logLevel, $hl7Msg, "PID", "3", "0", "Patient ID");
  return 1 if ($x != 0);

  ($x, $patientName) = mesa::getFieldLog($logLevel, $hl7Msg, "PID", "5", "0", "Patient Name");
  return 1 if ($x != 0);

  print "IHE Transaction 8: $pid $patientName \n";
  print "MESA Patient ID Source will send ADT message to the MESA XRef Mgr.\n";
  print "The event type is: $event\n";
  print "host: $main::mesaXRefHostHL7, port $main::mesaXRefPortHL7 \n";
  print "Name: $patientName, PID: $pid\n";

  print "Hit <ENTER> when ready (q to quit) --> ";
  $x = <STDIN>;
  main::goodbye if ($x =~ /^q/);

  $x = mesa::send_hl7_log($logLevel, "../../msgs", $msg, $main::mesaXRefHostHL7, $main::mesaXRefPortHL7);
  mesa::xmit_error($msg) if ($x != 0);

  return 0;
}

sub processTransaction9 {
  my ($logLevel, $selfTest, $src, $dst, $event, $msg, $testOutputFile, $mesaOutputFile) = @_;

  if ($dst ne "XREF") {
    print "IHE Transaction 9 from ($src) to ($dst) is not required for XRef Consumer test\n";
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
  print "MESA Patient ID Consumer will send QBP message to MESA XRef Mgr.\n";
  print "The event type is: $event\n";
  print "host: $main::mesaXRefHostHL7, port $main::mesaXRefPortHL7 \n";
  print "PID: $pid\n";

  print "Your XRef Consumer is expected to send a query with this identifier\n";
  print " to the MESA Cross Reference Manager.\n";

  print "Hit <ENTER> when ready (q to quit) --> ";
  $x = <STDIN>;
  main::goodbye if ($x =~ /^q/);

  if ($selfTest != 0) {
    $x = mesa::send_hl7_pdq_query($logLevel, "../../msgs", $msg,
	$main::mesaXRefHostHL7, $main::mesaXRefPortHL7, $mesaOutputFile);
    mesa::xmit_error($msg) if ($x != 0);
  }

  return 0;
}

1;
