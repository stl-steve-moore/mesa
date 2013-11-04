#!/usr/local/bin/perl -w

# Runs the PD Supplier scripts interactively

use Env;
use lib "scripts";
require pd_consumer;
require pd_consumer_workflow;

$SIG{INT} = \&goodbye;


sub goodbye () {
  print "Exiting...\n";

  exit 1;
}

sub testVarValues {
 return 0;
}

sub print_config_params {
  foreach $varname (keys %varnames) {
    print "Variable $varname = $varnames{$varname} \n";
  }
}

sub processTransaction {
  my $cmd = shift(@_);
  my $logLevel = shift(@_);
  my $selfTest = shift(@_);

  my @tokens = split /\s+/, $cmd;
  my $verb = $tokens[0];
  my $trans= $tokens[1];

  my $rtnValue = 0;

  if ($trans eq "ITI-30") {
    $rtnValue = 1;
    shift (@tokens); shift (@tokens);
    $rtnValue = pd_consumer::processTransaction30($logLevel, $selfTest, @tokens);
  } else {
    die "Unable to process command <$cmd>\n";
  }
  return $rtnValue;
}

sub mesaInternal {
  my $cmd = shift(@_);
  my $logLevel = shift(@_);
  my $selfTest = shift(@_);

  my @tokens = split /\s+/, $cmd;
  my $verb = $tokens[0];
  my $trans= $tokens[1];

  my $rtnValue = 1;

  if ($trans eq "MESA-RESET") {
    print "Internal command to reset MESA servers; this clears database entries.\n";
    print `perl scripts/reset_servers.pl`;
    die "Could not reset servers \n" if ($?);
    $rtnValue = 0;
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
  my ($x, $pid);
  ($x, $pid) = mesa::getFieldLog($logLevel, $hl7Msg, "PID", "3", "0", "Patient ID");
  return 1 if ($x != 0);

  my $patientName;
  ($x, $patientName) = mesa::getFieldLog($logLevel, $hl7Msg, "PID", "5", "0", "Patient Name");
  print "Patient Name: $patientName \n";
  print "Patient ID:   $pid\n";
  print "\nHit <ENTER> when ready (q to quit) --> ";
  $x = <STDIN>;
  goodbye if ($x =~ /^q/);
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
  } elsif ($verb[0] eq "PATIENT") {
    printPatient($cmd);
  } elsif ($verb[0] eq "MESA-INTERNAL") {
    mesaInternal($cmd, $logLevel, $selfTest);
  } elsif ($verb[0] eq "PROFILE") {
    if ($verb[1] ne "PDQ") {
      die "This script is for the PDQ profile, not $verb[1]";
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

%varnames = mesa::get_config_params("pd_consumer.cfg");
if (pd_consumer::test_var_names(%varnames) != 0) {
  print "Some problem with the variables in pd_consumer.cfg\n";
  exit 1;
}

$testPDCPAMPortHL7 = $varnames{"TEST_PDC_PAM_PORT_HL7"};
$testPDCPAMHostHL7 = $varnames{"TEST_PDC_PAM_HOST_HL7"};

$mesaPDCPAMPortHL7 = $varnames{"MESA_PDC_PAM_PORT"};
$mesaPDCPAMHostHL7 = $varnames{"MESA_PDC_PAM_HOST"};

testVarValues($testPDCPAMPortHL7, $testPDCPAMHostHL7, $mesaPDCPAMPortHL7, $mesaPDCPAMHostHL7);

my $fileName = "../common/$ARGV[0]/$ARGV[0]" . ".txt";
open TESTFILE, $fileName or die "Could not open: $fileName\n";

$logLevel = $ARGV[1];
$selfTest = 0;
$selfTest = 1 if (scalar(@ARGV) > 2);
print "MESA PDC PAM Port HL7 = $mesaPDCPAMPortHL7\n";
print "MESA PDC PAM Host HL7 = $mesaPDCPAMHostHL7\n";
my $lineNumber = 1;

while ($l = <TESTFILE>) {
  chomp $l;
  print "\nLine number: $lineNumber\n";
  $v = processOneLine($l, $logLevel, $selfTest);
  die "Could not process line $lineNumber $l" if ($v != 0);
  $lineNumber += 1;
}
close TESTFILE;

goodbye;
