#!/usr/local/bin/perl -w

# Common routines for Patient Encounter Source tests.

use Env;

use lib "../common/scripts";
require mesa;

package pat_encounter_src;
require Exporter;
@ISA = qw(Exporter);

sub test_var_names {
  my %h = @_;

  my $rtnVal = 0;
  my @names = (
    "MESA_PES_HOST_HL7",
    "MESA_PES_PORT_HL7",
    "TEST_PES_HOST_HL7",
    "TEST_PES_HOST_HL7",
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

sub processTransaction30 {
  my $logLevel = shift(@_);
  my $selfTest = shift(@_);
  my $src = shift(@_);
  my $dst = shift(@_);
  my $event = shift(@_);
  my $msg = shift(@_);

  if ($dst ne "PE_SRC") {
    print "IHE Transaction 30 from ($src) to ($dst) is not required for Patient Encounter Source test\n";
    return 0;
  }

  my $hl7Msg = "../../msgs/" . $msg;
  my ($x, $pid, $patientName);
  ($x, $pid) = mesa::getFieldLog($logLevel, $hl7Msg, "PID", "3", "0", "Patient ID");
  ($x, $patientName) = mesa::getFieldLog($logLevel, $hl7Msg, "PID", "5", "0", "Patient Name");

  print "\nIHE Transaction 30: \n";
  print "\nMESA actor Patient Demographics Source will send an ADT message to your system\n";
  print "The event type is: $event\n";
  print "Your system host: $main::testPatEncounterSrcHostHL7, port $main::testPatEncounterSrcPortHL7 \n";
  print "Name: $patientName, PID: $pid\n";
  print "All parameters can be found in file $hl7Msg\n";

  print "Hit <ENTER> when ready (q to quit) --> ";
  $x = <STDIN>;
  die "Accepted user quit" if ($x =~ /^q/);
  
  #if ($selfTest == 1) {
    print "MESA is sending ADT message ($msg) for event $event to MESA $dst\n";
    $x = mesa::send_hl7_log($logLevel, "../../msgs", $msg, "localhost", $main::mesaPatEncounterSrcPortHL7);
    mesa::xmit_error($msg) if ($x != 0);
  #}else {
    print "MESA is sending ADT message ($msg) for event $event to your system\n";
    $x = mesa::send_hl7_log($logLevel, "../../msgs", $msg, $main::testPatEncounterSrcHostHL7, $main::testPatEncounterSrcPortHL7);
    mesa::xmit_error($msg) if ($x != 0);
  #}
  
  print "\nThis the end of transaction 30\n";
  print "Hit <ENTER> when ready for the next step(q to quit) -->";
  $x = <STDIN>;
  die "Accepted user quit" if ($x =~ /^q/);

  return 0;
}


sub processTransaction31 {
  my $logLevel = shift(@_);
  my $selfTest = shift(@_);
  my $src = shift(@_);
  my $dst = shift(@_);
  my $event = shift(@_);
  my $msg = shift(@_);

  if ($dst ne "PE_CMR") {
    print "IHE Transaction 30 from ($src) to ($dst) is not required for Patient Encounter Source test\n";
    return 0;
  }

  my $hl7Msg = "../../msgs/" . $msg;
  my ($x, $pid, $patientName);
  ($x, $pid) = mesa::getFieldLog($logLevel, $hl7Msg, "PID", "3", "0", "Patient ID");
  ($x, $patientName) = mesa::getFieldLog($logLevel, $hl7Msg, "PID", "5", "0", "Patient Name");

  print "\nIHE Transaction 31: \n";
  print "\nYour system is expected to send an ADT message to the MESA actor Patient Encounter Consumer\n";
  print "The event type is: $event\n";
  print "MESA host: $main::host, port $main::mesaPatEncounterCmrPortHL7 \n";
  print "Name: $patientName, PID: $pid\n";
  print "All parameters can be found in file $hl7Msg\n";

  print "Hit <ENTER> when ready (q to quit) --> ";
  $x = <STDIN>;
  die "Accepted user quit" if ($x =~ /^q/);
  
  if ($selfTest == 1) {
    print "MESA will send ADT message ($msg) for event $event to MESA $dst\n";
    $x = mesa::send_hl7_log($logLevel, "../../msgs", $msg, "localhost", $main::mesaPatEncounterCmrPortHL7);
    mesa::xmit_error($msg) if ($x != 0);
  }
  
  print "\nThis the end of transaction 31\n";
  print "Hit <ENTER> when ready for the next step(q to quit) -->";
  $x = <STDIN>;
  die "Accepted user quit" if ($x =~ /^q/);

  return 0;
}

1;
