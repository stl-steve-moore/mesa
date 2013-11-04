#!/usr/local/bin/perl -w

# Runs the Xref Manager scripts interactively

use Env;
use lib "scripts";
require xref_mgr;
require xref_mgr_workflow;

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
  print "Transaction 1 not necessary to test the XRef Mgr\n";
  return 0;
}

sub processTransaction2 {
  print "Transaction 2 not necessary to test the XRef Mgr\n";
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
    $rtnValue = xref_mgr::processTransaction1($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "ITI-2") {
    shift (@tokens); shift (@tokens);
    $rtnValue = processTransaction2(@tokens);
  } elsif ($trans eq "ITI-8") {
    shift (@tokens); shift (@tokens);
    $rtnValue = xref_mgr::processTransaction8($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "ITI-9") {
    shift (@tokens); shift (@tokens);
    $rtnValue = xref_mgr::processTransaction9($logLevel, $selfTest, @tokens);
  } else {
    die "Unable to process command <$cmd>\n";
  }
  return $rtnValue;
}

sub xrefSet {
  my ($cmd, $logLevel, $selfTest) = @_;

  my @tokens = split /\s+/, $cmd;
  my $verb       = $tokens[0];
  return 1 if ($verb ne "XREF_SET");

  my $hl7Msg = "../../msgs/" . $tokens[1];
  my $xrefValue  = $tokens[2];

  print "Cross Reference: $hl7Msg, $xrefValue\n";
  my ($x, $pid, $authority);
  ($x, $pid) = mesa::getFieldLog($logLevel, $hl7Msg, "PID", "3", "1", "Patient ID");
  return 1 if ($x != 0);
  ($x, $issuer) = mesa::getFieldLog($logLevel, $hl7Msg, "PID", "3", "4", "Issuer");
  return 1 if ($x != 0);

  $x = "$MESA_TARGET/bin/mesa_update_column -c patid $pid -c issuer '$issuer' xrefkey '$xrefValue' patient xref_mgr";
  print "$x\n" if ($logLevel >= 3);

  my $rtnValue = 0;
  print `$x`;
  if ($?) {
    print "Unable to update MESA xref mgr: $x\n";
    $rtnValue = 1;
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
  } elsif ($verb[0] eq "XREF_SET") {
    $rtnValue = xrefSet($cmd, $logLevel, $selfTest);
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

%varnames = mesa::get_config_params("xref_mgr.cfg");
if (xref_mgr::test_var_names(%varnames) != 0) {
  print "Some problem with the variables in xref_mgr.cfg\n";
  exit 1;
}

$testXRefPortADTHL7 = $varnames{"TEST_XREF_PORT_ADT_HL7"};
$testXRefHostADTHL7 = $varnames{"TEST_XREF_HOST_ADT_HL7"};
$testXRefPortQueryHL7 = $varnames{"TEST_XREF_PORT_QUERY_HL7"};
$testXRefHostQueryHL7 = $varnames{"TEST_XREF_HOST_QUERY_HL7"};

$mesaXRefPortHL7 = $varnames{"MESA_XREF_PORT_HL7"};
$mesaXRefHostHL7 = $varnames{"MESA_XREF_HOST_HL7"};

print `perl scripts/reset_servers.pl`;
die "Could not reset servers \n" if ($?);

my $fileName = "../common/$ARGV[0]/$ARGV[0]" . ".txt";
open TESTFILE, $fileName or die "Could not open: $fileName\n";

$logLevel = $ARGV[1];
$selfTest = 0;
$selfTest = 1 if (scalar(@ARGV) > 2);
print "Test XRef Mgr Port ADT HL7 = $testXRefPortADTHL7\n";
print "Test XRef Mgr Host ADT HL7 = $testXRefHostADTHL7\n";
print "Test XRef Mgr Port Query HL7 = $testXRefPortQueryHL7\n";
print "Test XRef Mgr Host Query HL7 = $testXRefHostQueryHL7\n";
print "MESA XRef Mgr Port HL7 = $mesaXRefPortHL7\n";
print "MESA XRef Mgr Host HL7 = $mesaXRefHostHL7\n";

while ($l = <TESTFILE>) {
  chomp $l;
  $v = processOneLine($l, $logLevel, $selfTest);
  die "Could not process line $l" if ($v != 0);
}
close TESTFILE;

goodbye;
