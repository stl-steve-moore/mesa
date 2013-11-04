#!/usr/local/bin/perl -w

# Runs the Order Placer scripts interactively

use Env;
use lib "scripts";
require ordplc;
require ordplc_workflow;

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

sub processTransaction3 {
  my ($logLevel, $selfTest, $src, $dst, $event, $msg) = @_;

  my $hl7Msg = "../../msgs/" . $msg;
  my $pid           = mesa::getField($hl7Msg, "PID", "3", "0", "Patient ID");
  my $patientName   = mesa::getField($hl7Msg, "PID", "5", "0", "Patient Name");
  my $procedureCode = mesa::getField($hl7Msg, "OBR", "4", "0", "Procedure Code");
  print "IHE Transaction 3: $pid $patientName $procedureCode \n";

  if ($dst eq "OF") {
    my $fillerOrderNumber = mesa::getField($hl7Msg, "OBR", "3", "0", "Filler Order Number");
    print "\nIn this part of Transaction 3, the Order Filler has sent an ORM\n";
    print " to your Order Placer. We expect your system to respond with an ORR.\n";
    
    print "Name: $patientName, PID: $pid, Universal Service ID: $procedureCode\n";
    print "Filler Order Number: $fillerOrderNumber\n";
    print "All parameters can be found in file $hl7Msg\n";

    print "Hit <ENTER> when ready (q to quit) --> ";
    my $x = <STDIN>;
    goodbye if ($x =~ /^q/);

    if ($selfTest == 1) {
      print "Looks like this is run directly for MESA testing; send ORM to MESA OF \n";
      $x = mesa::send_hl7_log($logLevel, "../../msgs", $msg, "localhost", $mesaOrderFillerPortHL7);
      mesa::xmit_error($msg) if ($x != 0);
    } else {
    }
  } else {
# We are going to send them an order.
    print "\nIn this part of Transaction 3, the Order Filler initiates the order\n";
    print "MESA will now send ORM message ($msg) to your Order Placer ($opHostHL7 $opPortHL7) \n";
    print "Hit <ENTER> when ready (q to quit) --> ";
    my $x = <STDIN>;
    goodbye if ($x =~ /^q/);
    $x = mesa::send_hl7_log($logLevel, "../../msgs", $msg, $opHostHL7, $opPortHL7);
    mesa::xmit_error($msg) if ($x != 0);
  }
  return 0;
}

sub processTransaction4a {
  print "Transaction 4a not necessary to test the Order Placer \n";
  return 0;
}

sub processTransaction4b {
  print "Transaction 4b not necessary to test the Order Placer \n";
  return 0;
}

sub processTransaction4 {
  print "Transaction 4 not necessary to test the Order Placer \n";
  return 0;
}

sub processTransaction5 {
  print "Transaction 5 not necessary to test the Order Placer \n";
  return 0;
}

sub processTransaction6 {
  print "Transaction 6 not necessary to test the Order Placer \n";
  return 0;
}

sub processTransaction7 {
  print "Transaction 7 not necessary to test the Order Placer \n";
  return 0;
}

sub processTransaction8 {
  print "Transaction 7 not necessary to test the Order Placer \n";
  return 0;
}

sub processTransaction10 {
  print "Transaction 10 not necessary to test the Order Placer \n";
  return 0;
}

sub processTransaction12 {
  my ($logLevel, $selfTest, $src, $dst, $event, $msg) = @_;

  if ($dst ne "OP") {
    print "IHE Transaction 12 from ($src) to ($dst) is not required for Order Placer test\n";
    return 0;
  }

  my $hl7Msg = "../../msgs/" . $msg;
  my $pid =         mesa::getField($hl7Msg, "PID", "3", "0", "Patient ID");
  my $patientName = mesa::getField($hl7Msg, "PID", "5", "0", "Patient Name");

  print "IHE Transaction 12: $pid $patientName \n";
  print "MESA will send ADT message ($msg) for event $event to MESA $dst\n";

  if ($selfTest == 1) {
    print "Looks like this is run directly for MESA testing; skip ADT to MESA OP \n";
  } else {
    $x = mesa::send_hl7_log($logLevel, "../../msgs", $msg, "localhost", $mesaOrderFillerPortHL7);
    mesa::xmit_error($msg) if ($x != 0);
  }

  print "\nMESA will now send ADT message ($msg) to your Order Placer ($opHostHL7 $opPortHL7) \n";
  print "Hit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  goodbye if ($x =~ /^q/);
  $x = mesa::send_hl7_log($logLevel, "../../msgs", $msg, $opHostHL7, $opPortHL7);
  mesa::xmit_error($msg) if ($x != 0);
  return 0;
}

sub processTransaction13 {
  print "Transaction 13 not necessary to test the Order Placer \n";
  return 0;
}

sub processTransaction14 {
  print "Transaction 14 not needed for OP tests\n";
  return 0;
}

sub processTransaction {
  my ($cmd, $logLevel, $selfTest) = @_;
  my @tokens = split /\s+/, $cmd;
  my $verb = $tokens[0];
  my $trans= $tokens[1];

  my $rtnValue = 0;

  if ($trans eq "1") {
    shift (@tokens); shift (@tokens);
    $rtnValue = ordplc::processTransaction1Secure($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "2") {
    shift (@tokens); shift (@tokens);
    $rtnValue = ordplc::processTransaction2Secure($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "3") {
    shift (@tokens); shift (@tokens);
    $rtnValue = processTransaction3($logLevel, $selfTest, @tokens);
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
  print "LOCALSCHEDULING is not needed to test the Order Placer\n";
  return 0;
}

sub unscheduledImages {
  print "UNSCHEDULED-IMAGES is not needed to test the Order Placer\n";
  return 0;
}

sub processOneLine {
  my ($cmd, $logLevel, $selfTest)  = @_;
  if ($cmd eq "") {
    return 0;
  }
  my @verb = split /\s+/, $cmd;
  my $rtnValue = 0;

  if ($verb[0] eq "TRANSACTION") {
    $rtnValue = processTransaction($cmd, $logLevel, $selfTest);
  } elsif ($verb[0] eq "TEXT") {
    printText($cmd);
  } elsif ($verb[0] eq "LOCALSCHEDULING") {
    localScheduling($cmd);
  } elsif ($verb[0] eq "UNSCHEDULED-IMAGES") {
    $rtnValue = unscheduledImages($cmd, $logLevel, $selfTest);
  } elsif ($verb[0] eq "PATIENT") {
    printPatient($cmd);
  } elsif ($verb[0] eq "PROFILE") {
    if ($verb[1] ne "BASIC_SECURITY") {
      die "This Order Placer script is for the Basic Security profile, not $verb[1]";
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

%varnames = mesa::get_config_params("ordplc_test.cfg");
if (ordplc::test_var_names(%varnames) != 0) {
  print "Some problem with the variables in ordplc_test.cfg\n";
  exit 1;
}

$opHostHL7 = $varnames{"TEST_HL7_HOST"};
$opPortHL7 = $varnames{"TEST_HL7_PORT"};

#$mesaOrderPlacerPortHL7 = $varnames{"MESA_ORD_PLC_PORT_HL7"};
$mesaOrderFillerPortHL7 = $varnames{"MESA_ORD_FIL_PORT_HL7"};

print `perl scripts/reset_servers_secure.pl`;

my $fileName = "../common/$ARGV[0]/$ARGV[0]" . ".txt";
open TESTFILE, $fileName or die "Could not open: $fileName\n";
$logLevel = $ARGV[1];
$selfTest = 0;
if (scalar(@ARGV) > 2) {
  $selfTest = 1;
}

while ($l = <TESTFILE>) {
  chomp $l;
  $v = processOneLine($l, $logLevel, $selfTest);
  die "Could not process line $l" if ($v != 0);
}
close TESTFILE;

goodbye;
