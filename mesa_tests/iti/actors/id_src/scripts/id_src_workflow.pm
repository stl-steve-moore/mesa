#!/usr/local/bin/perl -w

# Common routines for Patient ID Source workflow tests.

use Env;

package id_src;
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
    print "IHE Transaction 8 from ($src) to ($dst) is not required for ID Source test\n";
    return 0;
  }

  my $hl7Msg = "../../msgs/" . $msg;
  my ($x, $pid, $patientName);
  ($x, $pid) = mesa::getFieldLog($logLevel, $hl7Msg, "PID", "3", "0", "Patient ID");
  ($x, $patientName) = mesa::getFieldLog($logLevel, $hl7Msg, "PID", "5", "0", "Patient Name");

  print "IHE Transaction 8: $pid $patientName \n";
  print "\nYou are expected to send an ADT message to the MESA actor XRef Mgr\n";
  print "The event type is: $event\n";
  print "MESA host: $main::host, port $main::mesaXRefPortHL7 \n";
  print "Name: $patientName, PID: $pid\n";
  print "All parameters can be found in file $hl7Msg\n";

  print "Hit <ENTER> when ready (q to quit) --> ";
  $x = <STDIN>;
  main::goodbye if ($x =~ /^q/);

  if ($selfTest == 1) {
    print "MESA will send ADT message ($msg) for event $event to MESA $dst\n";
    $x = mesa::send_hl7_log($logLevel, "../../msgs", $msg, "localhost", $main::mesaXRefPortHL7);
    mesa::xmit_error($msg) if ($x != 0);
  }

  return 0;
}

1;
