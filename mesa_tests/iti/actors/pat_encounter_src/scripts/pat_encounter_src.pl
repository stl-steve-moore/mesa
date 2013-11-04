#!/usr/local/bin/perl -w

# Runs the Patient Encounter Source scripts interactively

use Env;
use lib "scripts";
use lib "../../../common/scripts";
require pat_encounter_src;
require mesa_common;

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
  print "Transaction 1 not necessary to test the Patient Demographics Source\n";
  return 0;
}

sub processTransaction2 {
  print "Transaction 2 not necessary to test the Patient Demographics Source\n";
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

  if ($trans eq "ITI-1") {
    shift (@tokens); shift (@tokens);
    $rtnValue = processTransaction1($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "ITI-2") {
    shift (@tokens); shift (@tokens);
    $rtnValue = processTransaction2(@tokens);
  } elsif ($trans eq "ITI-8") {
    shift (@tokens); shift (@tokens);
    $rtnValue = pat_encounter_src::processTransaction8($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "ITI-30") {
    print "Do you need the patient demographics information(Y/N) --> ";
    my $x = <STDIN>;
    if ($x =~ /^Y/ || $x =~ /^y/){
      shift (@tokens); shift (@tokens);
      $rtnValue = pat_encounter_src::processTransaction30($logLevel, $selfTest, @tokens);
    }
  } elsif ($trans eq "ITI-31") {
    shift (@tokens); shift (@tokens);
    $rtnValue = pat_encounter_src::processTransaction31($logLevel, $selfTest, @tokens);
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
  my ($x, $pid, $patientName);
  ($x, $pid) = mesa::getFieldLog($logLevel, $hl7Msg, "PID", "3", "0", "Patient ID");
  return 1 if ($x != 0);

  ($x, $patientName) = mesa::getFieldLog($logLevel, $hl7Msg, "PID", "5", "0", "Patient Name");
  return 1 if ($x != 0);

  print "Patient Name: $patientName \n";
  print "Patient ID:   $pid\n";
  print "\nHit <ENTER> when ready (q to quit) --> ";
  $x = <STDIN>;
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
    if ($verb[1] ne "SCHEDULED_WORKFLOW") {
      die "This ADT script is for the Scheduled Workflow profile, not $verb[1]";
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

%varnames = mesa::get_config_params("pat_encounter_src.cfg");
if (pat_encounter_src::test_var_names(%varnames) != 0) {
  print "Some problem with the variables in pat_encounter_src.cfg\n";
  exit 1;
}

$mesaPatEncounterSrcPortHL7     = $varnames{"MESA_PES_PORT_HL7"};
$mesaPatEncounterCmrPortHL7     = $varnames{"MESA_PEC_PORT_HL7"};

$testPatEncounterSrcHostHL7     = $varnames{"TEST_PES_HOST_HL7"};
$testPatEncounterSrcPortHL7	= $varnames{"TEST_PES_PORT_HL7"};


my $fileName = "../common/$ARGV[0]/$ARGV[0]" . ".txt";
open TESTFILE, $fileName or die "Could not open: $fileName\n";

$logLevel = $ARGV[1];
$selfTest = 0;
$selfTest = 1 if (scalar(@ARGV) > 2);

die "MESA Environment Problem" if (mesa_utility::testMESAEnvironment($logLevel) != 0);
my $version = mesa::getMESAVersion();
print "MESA Version: $version\n";
($x, $date, $timeMin) = mesa_get::getDateTime($logLevel);
die "Could not get current date/time" if ($x != 0);
print "Date/time = $date $timeMin\n";

print `perl scripts/reset_servers.pl`;
die "Could not reset servers \n" if ($?);

print "MESA Patient Encounter Source Port HL7 = $mesaPatEncounterSrcPortHL7\n";
print "MESA Patient Encounter Consumer Port HL7 = $mesaPatEncounterCmrPortHL7\n";
print "TEST Patient Encounter Source Host HL7 = $testPatEncounterSrcHostHL7\n";
print "TEST Patient Encounter Source Port HL7 = $testPatEncounterSrcPortHL7\n";

while ($l = <TESTFILE>) {
  chomp $l;
  $v = processOneLine($l, $logLevel, $selfTest);
  die "Could not process line $l" if ($v != 0);
}
close TESTFILE;

goodbye;
