#!/usr/local/bin/perl -w

# Common routines for ADT workflow tests.

use Env;

package adt;
require Exporter;
@ISA = qw(Exporter);


sub print_config_params {
  foreach $varname (keys %varnames) {
    print "Variable $varname = $varnames{$varname} \n";
  }
}

sub processTransaction1 {
  my $logLevel = shift(@_);
  my $selfTest = shift(@_);
  my $src = shift(@_);
  my $dst = shift(@_);
  my $event = shift(@_);
  my $msg = shift(@_);

  if ($dst ne "OF") {
    print "IHE Transaction 1 from ($src) to ($dst) is not required for ADT test\n";
    return 0;
  }

  my $hl7Msg = "../../msgs/" . $msg;
  my $pid = mesa::getField($hl7Msg, "PID", "3", "0", "Patient ID");
  my $patientName = mesa::getField($hl7Msg, "PID", "5", "0", "Patient Name");

  print "IHE Transaction 1: $pid $patientName \n";
  print "\nYou are expected to send an ADT message to the MESA actor Order Filler\n";
  print "The event type is: $event\n";
  print "MESA host: $main::host, port $main::mesaOrderFillerPortHL7 \n";
  print "Name: $patientName, PID: $pid\n";
  print "All parameters can be found in file $hl7Msg\n";

  print "Hit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  main::goodbye if ($x =~ /^q/);

  if ($selfTest == 1) {
    print "MESA will send ADT message ($msg) for event $event to MESA $dst\n";
    $x = mesa::send_hl7("../../msgs", $msg, "localhost", $main::mesaOrderFillerPortHL7);
    mesa::xmit_error($msg) if ($x != 0);
  }

  return 0;
}

sub processTransaction1Secure {
  my $logLevel = shift(@_);
  my $selfTest = shift(@_);
  my $src = shift(@_);
  my $dst = shift(@_);
  my $event = shift(@_);
  my $msg = shift(@_);

  if ($dst ne "OF") {
    print "IHE Transaction 1 from ($src) to ($dst) is not required for ADT test\n";
    return 0;
  }

  my $hl7Msg = "../../msgs/" . $msg;
  my $pid = mesa::getField($hl7Msg, "PID", "3", "0", "Patient ID");
  my $patientName = mesa::getField($hl7Msg, "PID", "5", "0", "Patient Name");

  print "IHE Transaction 1: $pid $patientName \n";
  print "\nYou are expected to send an ADT message to the MESA actor Order Filler\n";
  print "\nThis transmission should use TLS.\n";
  print "The event type is: $event\n";
  print "MESA host: $main::host, port $main::mesaOrderFillerPortHL7 \n";
  print "Name: $patientName, PID: $pid\n";
  print "All parameters can be found in file $hl7Msg\n";

  print "Hit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  main::goodbye if ($x =~ /^q/);

  if ($selfTest == 1) {
    print "MESA will send ADT message ($msg) for event $event to MESA $dst\n";
    $x = mesa::send_hl7_secure(
	"../../msgs", $msg, "localhost", $main::mesaOrderFillerPortHL7,
	"randoms.dat",
	"test_sys_1.key.pem",
	"test_sys_1.cert.pem",
	"mesa_1.cert.pem",
	"NULL-SHA");
    mesa::xmit_error($msg) if ($x != 0);
  }

  return 0;
}

sub processTransaction2 {
  print "Transaction 2 not necessary to test the ADT\n";
  return 0;
}

sub processTransaction3 {
  print "Transaction 3 not necessary to test the ADT\n";
  return 0;
}

sub processTransaction4a {
  print "Transaction 4a not necessary to test the ADT\n";
  return 0;
}

sub processTransaction4b {
  print "Transaction 4b not necessary to test the ADT\n";
  return 0;
}

sub processTransaction4 {
  print "Transaction 4 not necessary to test the ADT\n";
  return 0;
}

sub processTransaction5 {
  print "Transaction 5 not necessary to test the ADT\n";
  return 0;
}

sub processTransaction6 {
  print "Transaction 6 not necessary to test the ADT\n";
  return 0;
}

sub processTransaction7 {
  print "Transaction 7 not necessary to test the ADT\n";
  return 0;
}

sub processTransaction8 {
  print "Transaction 7 not necessary to test the ADT\n";
  return 0;
}

sub processTransaction10 {
  print "Transaction 10 not necessary to test the ADT\n";
  return 0;
}

sub processTransaction12 {
  my ($logLevel, $selfTest, $src, $dst, $event, $msg) = @_;

  if ($dst ne "OF") {
    print "IHE Transaction 12 from ($src) to ($dst) is not required for ADT test\n";
    return 0;
  }

  my $hl7Msg = "../../msgs/" . $msg;
  my $pid = mesa::getField($hl7Msg, "PID", "3", "0", "Patient ID");
  my $patientName = mesa::getField($hl7Msg, "PID", "5", "0", "Patient Name");

  print "IHE Transaction 12: $pid $patientName \n";
  print "\nYou are expected to send an ADT message to the MESA actor Order Filler\n";
  print "The event type is: $event\n";
  print "MESA host: $host, port $mesaOrderFillerPortHL7 \n";
  print "Name: $patientName, PID: $pid\n";
  print "All parameters can be found in file $hl7Msg\n";

  print "Hit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  main::goodbye if ($x =~ /^q/);

  if ($selfTest == 1) {
    print "MESA will send ADT message ($msg) for event $event to MESA $dst\n";
    $x = mesa::send_hl7("../../msgs", $msg, "localhost", $mesaOrderFillerPortHL7);
    mesa::xmit_error($msg) if ($x != 0);
  }

  return 0;
}

sub processTransaction13 {
  print "Transaction 13 not necessary to test the ADT\n";
  return 0;
}

sub processTransaction14 {
  print "Transaction 14 is not needed to test the ADT actor\n";
  return 0;
}

sub announceSchedulingParameters {
  my ($logLevel, $selfTest, $src, $dst, $event, $msg, $outputDir, $inputDir, $SPSCode, $PPSCode, $SPSLocation, $scheduledAET)  = @_;

  print "This is the scheduling prelude to transaction Rad-4\n";
  print " Transaction Rad-4 and scheduling are not required for ADT tests\n";
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

  if ($trans eq "1") {
    shift (@tokens); shift (@tokens);
    $rtnValue = processTransaction1($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "2") {
    shift (@tokens); shift (@tokens);
    $rtnValue = processTransaction2(@tokens);
  } elsif ($trans eq "3") {
    shift (@tokens); shift (@tokens);
    $rtnValue = processTransaction3(@tokens);
  } elsif ($trans eq "4a") {
    shift (@tokens); shift (@tokens);
    $rtnValue = processTransaction4a(@tokens);
  } elsif ($trans eq "4b") {
    shift (@tokens); shift (@tokens);
    $rtnValue = processTransaction4b(@tokens);
  } elsif ($trans eq "4") {
    shift (@tokens); shift (@tokens);
    $rtnValue = processTransaction4(@tokens);
  } elsif ($trans eq "5") {
    shift (@tokens); shift (@tokens);
    $rtnValue = processTransaction5(@tokens);
  } elsif ($trans eq "6") {
    shift (@tokens); shift (@tokens);
    $rtnValue = processTransaction6(@tokens);
  } elsif ($trans eq "7") {
    shift (@tokens); shift (@tokens);
    $rtnValue = processTransaction7(@tokens);
  } elsif ($trans eq "8") {
    shift (@tokens); shift (@tokens);
    $rtnValue = processTransaction8(@tokens);
  } elsif ($trans eq "10") {
    shift (@tokens); shift (@tokens);
    $rtnValue = processTransaction10(@tokens);
  } elsif ($trans eq "12") {
    shift (@tokens); shift (@tokens);
    $rtnValue = processTransaction12($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "13") {
    shift (@tokens); shift (@tokens);
    $rtnValue = processTransaction13(@tokens);
  } elsif ($trans eq "14") {
    shift (@tokens); shift (@tokens);
    $rtnValue = processTransaction14(@tokens);
  } else {
    die "Unable to process command <$cmd>\n";
  }
  return $rtnValue;
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

sub localScheduling {
  print "LOCALSCHEDULING is not needed to test the ADT system\n";
  return 0;
}

sub unscheduledImages {
  print "UNSCHEDULED-IMAGES is not needed to test the ADT system\n";
  return 0;
}

1;
