#!/usr/local/bin/perl -w

# Runs the Export Selector scripts interactively

use Env;
use lib "scripts";
require expsel;

$SIG{INT} = \&goodbye;

sub testVarValues {
 return 0;
}

sub goodbye () {
  print "Exiting...\n";

  exit 1;
}

sub print_config_params {
  foreach $varname (keys %varnames) {
    print "Variable $varname = $varnames{$varname} \n";
  }
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
  if ($trans eq "GEN-TF-SOP-INSTANCES") {
    shift (@tokens);
    print "MESA-INTERNAL:GEN-TF-SOP-INSTANCES:: \n";
  	print "Test script now produces unscheduled images as input to this test\n";
  	print "Hit <ENTER> when ready (q to quit) --> ";
  	my $x = <STDIN>;
  	goodbye if ($x =~ /^q/);
    $rtnValue = mesa::produceUnscheduledImagesTF($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "GEN-TF-KON") {
	shift (@tokens);
    print "MESA-INTERNAL:GEN-TF-KON:: \n";
  	print "Test script now produces MESA KON\n";
  	print "Hit <ENTER> when ready (q to quit) --> ";
  	my $x = <STDIN>;
  	goodbye if ($x =~ /^q/);
	$rtnValue = mesa::produceKONTF($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "GEN-TF-KON-MOD") {
	shift (@tokens);
    print "MESA-INTERNAL:GEN-TF-KON:: \n";
  	print "Test script now produces MESA KON\n";
  	print "Hit <ENTER> when ready (q to quit) --> ";
  	my $x = <STDIN>;
  	goodbye if ($x =~ /^q/);
	$rtnValue = mesa::produceMOD_KONTF($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "GEN-TF-KON2") {
	shift (@tokens);
    print "MESA-INTERNAL:GEN-TF-KON2:: \n";
  	print "Test script now produces MESA KON2\n";
  	print "Hit <ENTER> when ready (q to quit) --> ";
  	my $x = <STDIN>;
  	goodbye if ($x =~ /^q/);
	$rtnValue = mesa::produce_KONTF2($logLevel, $selfTest, @tokens);
  } elsif ($trans =~ m/DEIDENTIFY.*/ig) {
    shift (@tokens); shift (@tokens);
    expsel::processInternalDeidentify($logLevel, $selfTest, @tokens);
  } else {
    die "Unable to process command <$cmd>";
  }

  return $rtnValue;
}

sub processTransaction {
  my ($cmd, $logLevel) = @_;
  my @tokens = split /\s+/, $cmd;
  my $verb = $tokens[0];
  my $trans= $tokens[1];
  my $rtnValue = 0;

  if ($trans eq "RAD-50") {
    shift (@tokens); shift (@tokens);
	print "If the Export Manager is grouped with an Image Manager/Archive\n".
		   "Hit s to skip transaction RAD-50 between the Export Selector and the Export Manager.\n".
		   "Hit <ENTER> to continue with transaction RAD-50 (q to quit) --> ";
	my $x = <STDIN>;
	goodbye if ($x =~ /^q/);
	return 0 if ($x =~ /^s/);
    expsel::processTransaction50($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "RAD-51") {
    shift (@tokens); shift (@tokens);
	print "If the Export Manager is grouped with an Image Manager/Archive\n".
		   "Hit s to skip transaction RAD-51 between the Export Selector and the Export Manager.\n".
		   "Hit <ENTER> to continue with transaction RAD-52 (q to quit) --> ";
	my $x = <STDIN>;
	goodbye if ($x =~ /^q/);
	return 0 if ($x =~ /^s/);
    expsel::processTransaction51($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "RAD-52") {
    shift (@tokens); shift (@tokens);
    expsel::processTransaction52($logLevel, $selfTest, @tokens);
  } elsif ($trans =~ /RAD-53/) {
    shift (@tokens); shift (@tokens);
    expsel::processTransaction53($logLevel, $selfTest, @tokens);
  } else {
    die "Unable to process command <$cmd>\n";
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

#  print "$verb[0] \n";
  if ($verb[0] eq "TRANSACTION") {
    $rtn = processTransaction($cmd, $logLevel);
  } elsif ($verb[0] eq "MESA-INTERNAL") {
    $rtn = processMESAInternal($cmd, $logLevel, $selfTest);
  } elsif ($verb[0] eq "TEXT") {
    printText($cmd);
  } elsif ($verb[0] eq "EXIT") {
    print "Found EXIT command\n";
    exit 0;
#  } elsif ($verb[0] eq "LOCALSCHEDULING") {
#    localScheduling($cmd);
  } elsif ($verb[0] eq "PROFILE") {
    if ($verb[1] ne "TCE") {
      die "This Export Selector script is for the TCE profile, not $verb[1]";
    }
  } elsif (substr($verb[0], 0, 1) eq "#") {
    print "Comment: $cmd \n";
  } else {
    die "Did not recognize verb in command: $cmd \n";
  }
  return $rtn;
}

# Main starts here

die "Usage: <test number> <output level: 0-4>\n" if (scalar(@ARGV) < 2);

$host = `hostname`; chomp $host;

%varnames = mesa::get_config_params("expsel_test.cfg");
if (expsel::test_var_names(%varnames) != 0) {
  print "Some problem with the variables in expsel_test.cfg\n";
  exit 1;
}

$mesaExpMgrPortDICOM  = $varnames{"MESA_EXPMGR_DICOM_PT"}; die "MESA_EXPMGR_DICOM_PT" if ($mesaExpMgrPortDICOM eq ""); 
$mesaExpMgrTitle      = $varnames{"MESA_EXPMGR_AE"}; die "MESA_EXPMGR_AE" if ($mesaExpMgrTitle eq "");
$mesaSelectorAE       = $varnames{"MESA_SELECTOR_AE"}; die "MESA_SELECTOR_AE" if ($mesaSelectorAE eq "");

print `perl scripts/reset_servers.pl`;

my $fileName = "../common/$ARGV[0]/$ARGV[0]" . ".txt";
open TESTFILE, $fileName or die "Could not open: $fileName\n";
$logLevel = $ARGV[1];
$selfTest = 0;
$selfTest = 1 if (scalar(@ARGV) > 2);

my $lineNum = 1;
while ($l = <TESTFILE>) {
  chomp $l;
  print "\n$lineNum $l\n"; $lineNum += 1;
  my $x = processOneLine($l, $logLevel, $selfTest);
  die "Could not process line $l\n" if ($x != 0);
}
close TESTFILE;

goodbye;
