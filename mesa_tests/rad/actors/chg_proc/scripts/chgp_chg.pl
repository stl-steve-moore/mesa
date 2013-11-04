#!/usr/local/bin/perl -w

# Runs the Charge Processor scripts interactively

use Env;
use lib "scripts";
require chgp;

$SIG{INT} = \&goodbye;


sub goodbye () {
  print "Exiting...\n";

  exit 1;
}

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
  print "MESA host: $host, port $mesaOrderFillerPortHL7 \n";
  print "Name: $patientName, PID: $pid\n";
  print "All parameters can be found in file $hl7Msg\n";

  print "Hit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  goodbye if ($x =~ /^q/);

  if ($selfTest == 1) {
    print "MESA will send ADT message ($msg) for event $event to MESA $dst\n";
    $x = mesa::send_hl7("../../msgs", $msg, "localhost", $mesaOrderFillerPortHL7);
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
  goodbye if ($x =~ /^q/);

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

sub processTransaction35 {
  my $logLevel = shift(@_);
  my $selfTest = shift(@_);
  my $src = shift(@_);
  my $dst = shift(@_);
  my $event = shift(@_);
  my $msg = shift(@_);

  if ($dst ne "CP") {
    print "IHE Transaction 35 from ($src) to ($dst) is not required for Charge Processor test\n";
    return 0;
  }

  my $hl7Msg = "../../msgs/" . $msg;
  my $pid = mesa::getField($hl7Msg, "PID", "3", "0", "Patient ID");
  my $patientName = mesa::getField($hl7Msg, "PID", "5", "0", "Patient Name");

  print "IHE Transaction 35: $pid $patientName \n";
  print "The event type is $event\n";
  print "MESA ADT will send DFT^Pxx message to your Charge Processor\n";
  print "Your host is $testHL7Host, your port is $testHL7Port\n";
  print "Name: $patientName, PID: $pid\n";

  print "Hit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  goodbye if ($x =~ /^q/);

  $x = mesa::send_hl7_log($logLevel, "../../msgs", $msg, $testHL7Host, $testHL7Port);
  mesa::xmit_error($msg) if ($x != 0);

  return 0;
}

sub processTransaction36 {
  my $logLevel = shift(@_);
  my $selfTest = shift(@_);
  my $src = shift(@_);
  my $dst = shift(@_);
  my $event = shift(@_);
  my $msg = shift(@_);

  if ($dst ne "CP") {
    print "IHE Transaction 36 from ($src) to ($dst) is not required for Charge Processor test\n";
    return 0;
  }

  my $hl7Msg = "../../msgs/" . $msg;
  my $pid = mesa::getField($hl7Msg, "PID", "3", "0", "Patient ID");
  my $patientName = mesa::getField($hl7Msg, "PID", "5", "0", "Patient Name");

  print "IHE Transaction 36: $pid $patientName \n";
  print "The event type is $event\n";
  print "MESA ADT will send Pxx message to your Charge Processor\n";
  print "Your host is $testHL7Host, your port is $testHL7Port\n";
  print "Name: $patientName, PID: $pid\n";

  print "Hit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  goodbye if ($x =~ /^q/);

  $x = mesa::send_hl7_log($logLevel, "../../msgs", $msg, $testHL7Host, $testHL7Port);
  mesa::xmit_error($msg) if ($x != 0);

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
  } elsif ($trans eq "35") {
    shift (@tokens); shift (@tokens);
    $rtnValue = processTransaction35($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "36") {
    shift (@tokens); shift (@tokens);
    $rtnValue = processTransaction36($logLevel, $selfTest, @tokens);
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
  goodbye if ($x =~ /^q/);
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
  goodbye if ($x =~ /^q/);
}

sub localScheduling {
  print "LOCALSCHEDULING is not needed to test the ADT system\n";
  return 0;
}

sub unscheduledImages {
  print "UNSCHEDULED-IMAGES is not needed to test the ADT system\n";
  return 0;
}

sub processOneLine {
  my $cmd  = shift(@_);
  my $logLevel = shift(@_);
  my $selfTest = shift(@_);

  if ($cmd eq "") {
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
    if ($verb[1] ne "CHARGE_POSTING") {
      die "This script is for the Charge Posting profile, not $verb[1]";
    }
  } elsif (substr($verb[0], 0, 1) eq "#") {
    print "Comment: $cmd \n";
  } else {
    die "Did not recognize verb in command: $cmd \n";
  }
  return $rtnValue;
}

# Main starts here

die "Usage: <test number> <output level: 0-4>\n" if (scalar(@ARGV) < 2);

$host = `hostname`; chomp $host;

%varnames = mesa::get_config_params("chgp_test.cfg");
if (chgp::test_var_names(%varnames) != 0) {
  print "Some problem with the variables in chgp_test.cfg\n";
  exit 1;
}

$testHL7Host = $varnames{"TEST_HL7_HOST"};
$testHL7Port = $varnames{"TEST_HL7_PORT"};
$mesaOrderFillerPortHL7 = "2200";

print `perl scripts/reset_servers.pl`;
die "Could not reset servers \n" if ($?);

my $fileName = "../common/$ARGV[0]/$ARGV[0]" . ".txt";
open TESTFILE, $fileName or die "Could not open: $fileName\n";

$logLevel = $ARGV[1];
$selfTest = 0;
$selfTest = 1 if (scalar(@ARGV) > 2);

while ($l = <TESTFILE>) {
  chomp $l;
  $v = processOneLine($l, $logLevel, $selfTest);
  die "Could not process line $l" if ($v != 0);
}
close TESTFILE;

goodbye;
