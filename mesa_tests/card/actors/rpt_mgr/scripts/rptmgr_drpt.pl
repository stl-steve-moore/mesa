#!/usr/local/bin/perl -w

# Runs the Report Manager scripts interactively

use Env;
use lib "scripts";
require rpt_mgr;

$SIG{INT} = \&goodbye;


sub goodbye () {
  print "Exiting...\n";

  exit 1;
}

sub processTransaction {
  my ($cmd, $logLevel) = @_;
  my @tokens = split /\s+/, $cmd;
  my $verb = $tokens[0];
  my $trans= $tokens[1];
  my $rtnValue = 0;

  if ($trans eq "CARD-7") {
    shift (@tokens); shift (@tokens);
#    print "CARD-7: Send a valid HL7 encapsulated report - unsolicited CARD-7\n";
#    print "MESA will generate/send a report to your Report Manager\n";
#    print "Hit <ENTER> when ready (q to quit) --> ";
#    my $x = <STDIN>;
#    goodbye if ($x =~ /^q/);
    $rtnValue = rpt_mgr::processTransactionCard7($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "CARD-8") {
    shift (@tokens); shift (@tokens);
    $rtnValue = rpt_mgr::processTransactionCard8($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "CARD-9") {
    shift (@tokens); shift (@tokens);
    $rtnValue = rpt_mgr::processTransactionCard9($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "RAD-10") {
    shift (@tokens); shift (@tokens);
    $rtnValue = rpt_mgr::processTransactionRad10($logLevel, $selfTest, @tokens);
  } else {
    die "Unable to process command <$cmd>\n";
  }
  return $rtnValue;
}

sub testVarValues {
 return 0;
}

sub print_config_params {
  foreach $varname (keys %varnames) {
    print "Variable $varname = $varnames{$varname} \n";
  }
}

sub printTextFile {
  my $txtFile = shift(@_);

  open TXT, $txtFile or die "Could not open text file: $txtFile";
  while ($line = <TXT>) {
    print $line;
  }
  close TXT;
  print "\nHit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  goodbye if ($x =~ /^q/);
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

sub processMESAInternal {
  my ($cmd, $logLevel, $selfTest) = @_;
  my @tokens = split /\s+/, $cmd;
  my $verb = $tokens[0];
  my $trans= $tokens[1];

  my $rtnValue = 0;
  if ($trans eq "GEN-DR-PDF") {
    shift(@tokens);
    shift(@tokens);
    if($selfTest == 1){
      print("MESA-INTERNAL:GEN-DR-PDF:: \n");
      print("Test script will generate DICOM object from HL7 message\n");
      print("Hit <ENTER> when ready (q to quit) --> ");
      my $x = <STDIN>;
      goodbye if ($x =~ /^q/);
      $rtnValue = rpt_mgr::generateDCMReport($logLevel, $selfTest, @tokens);
    }
  } else {
    die "Unable to process command <$cmd>";
  }

  return $rtnValue;
}

sub processOneLine {
  my ($cmd, $logLevel, $selfTest)  = @_;
  if ($cmd eq "") {
    return 0;
  }
  my @verb = split /\s+/, $cmd;
  my $rtn = 0;
  print "$verb[0] \n";
  if ($verb[0] eq "TRANSACTION") {
    $rtn = processTransaction($cmd, $logLevel);
  } elsif ($verb[0] eq "MESA-INTERNAL") {
     $rtn = processMESAInternal($cmd, $logLevel, $selfTest);
  }elsif ($verb[0] eq "TEXT") {
    printText($cmd);
  } elsif ($verb[0] eq "EXIT") {
    print "Found EXIT command\n";
    exit 0;
  } elsif (substr($verb[0], 0, 1) eq "#") {
    print "Comment: $cmd \n";
  } elsif ($verb[0] eq "PROFILE") {
    if ($verb[1] !~ m/DRPT_WORKFLOW/) {
      die "This Report Manager script is for the Cardiology DRPT profile, not $verb[1]";
    }
  } else {
    die "Did not recognize verb in command: $cmd \n";
  }
  return $rtn;
}


# Main starts here

if (scalar(@ARGV) < 2) {
  print "Usage: <test file> <output level: 0-4>\n";
  exit(1);
}

$host = `hostname`; chomp $host;

%varnames = mesa::get_config_params("rptmgr_test.cfg");
if (rpt_mgr::test_var_names(%varnames) != 0) {
  print "Some problem with the variables in rptmgr_test.cfg\n";
  exit 1;
}

$rptmgr_AE  = $varnames{"TEST_CSTORE_AE"};
$rptmgr_Host  = $varnames{"TEST_HL7_HOST"};
$rptmgr_Port  = $varnames{"TEST_HL7_PORT"};

$mesa_rptmgrAE  = $varnames{"MESA_RPT_MGR_AE"};
$mesa_rptmgrHost  = $varnames{"MESA_RPT_MGR_HOST"};
$mesa_rptmgrPort  = $varnames{"MESA_RPT_MGR_PORT"};

$mesa_rptrepAE  = $varnames{"MESA_RPT_REP_AE"};
$mesa_rptrepHost  = $varnames{"MESA_RPT_REP_HOST"};
$mesa_rptrepPort  = $varnames{"MESA_RPT_REP_PORT"};

$mesa_entrptrepAE  = $varnames{"MESA_ENT_RPT_REP_AE"};
$mesa_entrptrepHost  = $varnames{"MESA_ENT_RPT_REP_HOST"};
$mesa_entrptrepPort  = $varnames{"MESA_ENT_RPT_REP_PORT"};

$mesa_rptcrtAE  = $varnames{"MESA_RPT_CRT_AE"};

testVarValues($rptmgr_AE, $rptmgr_Host, $rptmgr_Port, $mesa_rptmgrAE, $mesa_rptmgrHost, $mesa_rptmgrPort, $mesa_rptrepAE, $mesa_rptrepHost, $mesa_rptrepPort, $mesa_rptcrtAE, $mesa_entrptrepAE, $mesa_entrptrepHost, $mesa_entrptrepPort);

print `perl scripts/reset_servers.pl`;
die "Could not reset servers" if ($?);

my $fileName = "../common/$ARGV[0]/$ARGV[0]" . ".txt";
open TESTFILE, $fileName or die "Could not open: $fileName\n";
$logLevel = $ARGV[1];
$selfTest = 0;
$selfTest = 1 if (scalar(@ARGV) > 2);

if (scalar(@ARGV) > 2) {
  $selfTest = 1;
}

#print_config_params();

while ($l = <TESTFILE>) {
  chomp $l;
  $v = processOneLine($l, $logLevel, $selfTest);
  die "Could not process line $l" if ($v != 0);
}
close TESTFILE;

goodbye;
