#!/usr/local/bin/perl -w

# Runs the MOD tests for the MAMMO profile.

use Env;
use lib "scripts";
use lib "../../../common/scripts";
require mod;
#require imp_common;
require mammo_transactions;
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

sub processTransaction {
  my $cmd = shift(@_);
  my $logLevel = shift(@_);
  my $selfTest = shift(@_);
  my @tokens = split /\s+/, $cmd;
  my $verb = $tokens[0];
  my $trans= $tokens[1];

  my $rtnValue = 0;

  if ($trans eq "RAD-8") {
    shift (@tokens); shift (@tokens);
    $rtnValue = mammo_transactions::processTransaction8($logLevel, $selfTest, @tokens);
  } else {
    die "Unable to process command <$cmd>\n";
  }
  return $rtnValue;
}

sub printText {
  my ($cmd, $keyExist) = @_;
  my $txtFile = "";
  my @tokens = split /\s+/, $cmd;
  if (($tokens[1] =~ m/fini/) && $keyExist ) {
    $tokens[1] =~ s/fini/ordfil_fini/ ;
  } else {
    ## Nothing here
  }
  $txtFile = "../common/" . $tokens[1];
  open TXT, $txtFile or die "Could not open text file: $txtFile";
  while ($line = <TXT>) {
    print $line;
  }
  close TXT;
  print "\nHit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  goodbye if ($x =~ /^q/);
}

sub processMessage {
  my $cmd = shift(@_);
  my $logLevel = shift(@_);
  my $selfTest = shift(@_);
  my @tokens = split /\s+/, $cmd;
  my $verb = $tokens[0];
  my $trans= $tokens[1];

  my $rtnValue = 0;
  if ($trans eq "RAD-SCHEDULE") {
    shift (@tokens); shift (@tokens);
    $rtnValue = imp::announceSchedulingParameters($logLevel, $selfTest, @tokens);
  } else {
    die "Unable to process command <$cmd>\n";
  }
  return $rtnValue;
}


sub processOneLine {
  my ($cmd, $logLevel, $selfTest, $testCase)  = @_;

  if ($cmd eq "") {	# An empty line is a comment
    return 0;
  }

  my @verb = split /\s+/, $cmd;
  my $rtnValue = 0;
  my $keyExist = 0;

  # Check to see if $testCase exists in %testCase
  if (exists($testCase{$testCase})) {
    $keyExist = 1;
  } else {
    $keyExist = 0;
  }

  if ($verb[0] eq "TRANSACTION") {
    $rtnValue = processTransaction($cmd, $logLevel, $selfTest);
  } elsif ($verb[0] eq "EXIT") {
    print "EXIT command found\n";
    exit 0;
  } elsif ($verb[0] eq "TEXT") {
     printText($cmd, $keyExist);
#  } elsif ($verb[0] eq "LOCALSCHEDULING") {
#    localScheduling($cmd);
  } elsif ($verb[0] eq "MESA-INTERNAL") {
    $rtnValue = processMESAInternal($cmd, $logLevel, $selfTest);
  } elsif ($verb[0] eq "MESSAGE") {
    $rtnValue = processMessage($cmd, $logLevel, $selfTest);
  } elsif ($verb[0] eq "UNSCHEDULED-IMAGES") {
    $rtnValue = unscheduledImages($cmd, $logLevel, $selfTest);
  } elsif ($verb[0] eq "PATIENT") {
    printPatient($cmd);
  } elsif ($verb[0] eq "PROFILE") {
    if ($verb[1] ne "MAMMO") {
      die "This mammo script is for the MAMMO profile, not $verb[1]";
    }
  } elsif (substr($verb[0], 0, 1) eq "#") {
    print "Comment: $cmd \n";
  } else {
    die "Did not recognize verb in command: $cmd \n";
  }
  return $rtnValue;
}

#MESA_IMGMGR_HOST = localhost
#MESA_IMGMGR_DICOM_PT = 2300
#MESA_IMGMGR_AE = MESA_IMGMGR

sub testConfigurationVariables {
  die "No MESA_IMGMGR_AE"		if ! $mesaImgMgrAE;
  die "No MESA_IMGMGR_HOST"		if ! $mesaImgMgrHost;
  die "No MESA_IMGMGR_DICOM_PT"		if ! $mesaImgMgrPort;
}

# Main starts here

die "Usage: <test number> <output level: 0-4>\n" if (scalar(@ARGV) < 2);

$host = `hostname`; chomp $host;

%varnames = mesa_get::get_config_params("mod_mammo_test.cfg");
if (mod::test_var_names(%varnames) != 0) {
  print "Some problem with the variables in mod_mammo_test.cfg\n";
  exit 1;
}

$mesaImgMgrAE	= $varnames{"MESA_IMGMGR_AE"};
$mesaImgMgrHost	= $varnames{"MESA_IMGMGR_HOST"};
$mesaImgMgrPort	= $varnames{"MESA_IMGMGR_DICOM_PT"};
testConfigurationVariables();

my $fileName = "../common/$ARGV[0]/$ARGV[0]" . ".txt";
open TESTFILE, $fileName or die "Could not open: $fileName\n";
$logLevel = $ARGV[1];
$selfTest = 0;
$selfTest = 1 if (scalar(@ARGV) > 2);
$testCase = $ARGV[0];

die "MESA Environment Problem; look in mesa_environment.log" if (mesa::testMESAEnvironment($logLevel) != 0);

my $version = mesa_get::getMESAVersion();
print "MESA Version: $version\n";
($x, $date, $timeMin) = mesa_get::getDateTime($logLevel);
die "Could not get current date/time" if ($x != 0);
print "Date/time = $date $timeMin\n";

print "About to reset MESA servers\n";
print `perl scripts/reset_servers.pl`;
die "Could not reset servers" if ($?);

my $lineNum = 1;
while ($l = <TESTFILE>) {
  chomp $l;
  print "$lineNum $l\n\n";
  $lineNum += 1;
  $v = processOneLine($l, $logLevel, $selfTest, $testCase);
  die "Could not process line $l" if ($v != 0);
}
close TESTFILE;

goodbye;
