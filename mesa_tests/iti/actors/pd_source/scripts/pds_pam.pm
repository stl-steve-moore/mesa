#!/usr/local/bin/perl -w

# Common routines for Patient Demographics Source workflow tests.

use Env;

use lib "../common/scripts";
require mesa;

package pds_pam;
require Exporter;
@ISA = qw(Exporter);

sub test_var_names {
  my %h = @_;

  my $rtnVal = 0;
  my @names = (
        "MESA_PDC_PAM_PORT_HL7",
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

  if ($dst ne "PD_CMR") {
    print "IHE Transaction 30 from ($src) to ($dst) is not required for Patient Demographics Source test\n";
    return 0;
  }

  my $hl7Msg = "../../msgs/" . $msg;
  my ($x, $pid, $patientName);
  ($x, $pid) = mesa::getFieldLog($logLevel, $hl7Msg, "PID", "3", "0", "Patient ID");
  ($x, $patientName) = mesa::getFieldLog($logLevel, $hl7Msg, "PID", "5", "0", "Patient Name");

  print "IHE Transaction 30: $pid $patientName \n";
  print "\nYou are expected to send an ADT message to the MESA actor Patient Demographics Consumer\n";
  print "The event type is: $event\n";
  print "MESA host: $main::host, port $main::mesaPdcPamPortHL7 \n";
  print "Name: $patientName, PID: $pid\n";
  print "All parameters can be found in file $hl7Msg\n";

  print "Hit <ENTER> when ready (q to quit) --> ";
  $x = <STDIN>;
  main::goodbye if ($x =~ /^q/);

  if ($selfTest == 1) {
    print "MESA will send ADT message ($msg) for event $event to MESA $dst\n";
    $x = mesa::send_hl7_log($logLevel, "../../msgs", $msg, "localhost", $main::mesaPdcPamPortHL7);
    mesa::xmit_error($msg) if ($x != 0);
  }
 
  print "\n";

  return 0;
}

1;
