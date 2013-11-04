#!/usr/local/bin/perl -w

# Common routines for Patient Encounter Source tests.

use Env;

use lib "../common/scripts";
require mesa;

package pat_encounter_consumer;
require Exporter;
@ISA = qw(Exporter);

sub test_var_names {
  my %h = @_;

  my $rtnVal = 0;
  my @names = (
    "MESA_PES_HOST_HL7",
    "MESA_PES_PORT_HL7",
    "TEST_PEC_HOST_HL7",
    "TEST_PEC_HOST_HL7",
    "MESA_PEC_HOST_HL7",
    "MESA_PEC_PORT_HL7"
  );

  foreach $n (@names) {
    my $v = $h{$n};
    if (! $v) {
      print "No value for $n \n";
      $rtnVal = 1;
    }
  }
  return $rtnVal;
}

sub print_config_params {
  foreach $varname (keys %varnames) {
    print "Variable $varname = $varnames{$varname} \n";
  }
}

sub processTransactionITI31 {
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

  print "\nIHE Transaction 31: \n";
  print "\nMESA Patient Encounter Source will send an ADT message to your test Patient Encounter Consumer\n";
  print "The event type is: $event\n";
  print "Test Patient Encounter Consumer host: $main::testPatEncounterCmrHostHL7, port $main::testPatEncounterCmrPortHL7 \n";
  print "Name: $patientName, PID: $pid\n";

  print "Hit <ENTER> when ready (q to quit) --> ";
  $x = <STDIN>;
  main::goodbye if ($x =~ /^q/);
  $x = mesa::send_hl7_log($logLevel, "../../msgs", $msg, $main::testPatEncounterCmrHostHL7, $main::testPatEncounterCmrPortHL7);
  mesa::xmit_error($msg) if ($x != 0);
  
  if ($selfTest == 1) {
    print "MESA will send ADT message ($msg) for event $event to MESA $dst\n";
    $x = mesa::send_hl7_log($logLevel, "../../msgs", $msg, "localhost", $main::mesaPatEncounterCmrPortHL7);
    mesa::xmit_error($msg) if ($x != 0);
  }
  
  print "\nThis the end of transaction 31\n";
  print "Hit <ENTER> when ready for the next step(q to quit) -->";
  $x = <STDIN>;
  main::goodbye if ($x =~ /^q/);

  return 0;
}

1;
