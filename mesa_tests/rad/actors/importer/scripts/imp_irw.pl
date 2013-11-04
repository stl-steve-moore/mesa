#!/usr/local/bin/perl -w

# Runs the Importer tests interactively

use Env;
use lib "scripts";
use lib "../../../common/scripts";
require imp;
require imp_common;
require imp_transactions;
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

  if ($trans eq "RAD-1") {
    shift (@tokens); shift (@tokens);
    $rtnValue = imp_transactions::processTransaction1($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "RAD-2") {
    shift (@tokens); shift (@tokens);
    $rtnValue = imp_transactions::processTransaction2($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "RAD-5") {
    shift (@tokens); shift (@tokens);
    $rtnValue = imp_transactions::processTransaction5($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "RAD-12") {
    shift (@tokens); shift (@tokens);
    $rtnValue = imp_transactions::processTransaction12($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "RAD-59") {
    shift (@tokens); shift (@tokens);
    $rtnValue = imp_transactions::processTransaction59($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "RAD-60") {
    shift (@tokens); shift (@tokens);
    $rtnValue = imp_transactions::processTransaction60($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "RAD-61") {
    shift (@tokens); shift (@tokens);
    $rtnValue = imp_transactions::processTransaction61($logLevel, $selfTest, @tokens);
  } else {
    die "Unable to process command <$cmd>\n";
  }
  return $rtnValue;
}

sub printText {
  my ($cmd) = @_;
  my $txtFile = "";
  my @tokens = split /\s+/, $cmd;
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


sub unscheduledImages {
  my ($cmd, $logLevel, $selfTest) = @_;
  my @tokens = split /\s+/, $cmd;

  my $rtnValue      = 0;
  my $verb          = $tokens[0];
  my $outputDir     = $tokens[1];
  my $hl7Msg        = "../../msgs/" . $tokens[2];
  my $modality      = $tokens[3];
  my $procedureCode = $tokens[4];
  my $performedCode = $tokens[5];
  my $inputDir      = $tokens[6];

  my $pid         = mesa::getField($hl7Msg, "PID", "3", "1", "Patient ID");
  my $patientName = mesa::getField($hl7Msg, "PID", "5", "0", "Patient Name");
  my $modName = $patientName;
  $modName =~ s/\^/_/;	# Because of problems passing ^ through the shell
  #$patientName =~ s/\^/_/;	# Because of problems passing ^ through the shell

  print "Test script now produces unscheduled images for $patientName\n";

  my $x = "perl scripts/produce_unscheduled_images.pl " .
	" $modality " .
	" MODALITY1 " .
	" $pid " .
	" $procedureCode " .
	" $outputDir " .
	" $performedCode " .
	" $inputDir " .
	" $modName ";
  print "$x\n" if ($logLevel >= 3);

  print `$x`;

  
  if ($?) {
    print "Unable to produce unscheduled images.\n";
    print "This is a configuration problem or MESA bug\n";
    print "Please log a bug report; \n";
    print " Run this test with log level 4, capture all output; capture the\n";
    print " file generatestudy.out and include this information in the bug report.\n";
    $rtnValue = 1;
  }

  return $rtnValue;
}

sub processMESAInternal {
  my ($cmd, $logLevel, $selfTest) = @_;
  my @tokens = split /\s+/, $cmd;
  my $verb = $tokens[0];
  my $trans= $tokens[1];

  my $rtnValue = 0;

  if ($trans eq "RAD-SCHEDULE") {
    shift (@tokens); shift(@tokens);
    #$rtnValue = imp::processInternalSchedulingRequest($logLevel, $selfTest, @tokens);
    $rtnValue = mesa::processInternalSchedulingRequest($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "PRODUCE-MPPS-CLINICAL") {
    shift (@tokens); shift (@tokens);
    $rtnValue = mesa_dicom::create_mpps_messages($logLevel, @tokens);
  } elsif ($trans eq "PRODUCE-MPPS-CLINICAL-MWL") {
    shift (@tokens); shift (@tokens);
    $rtnValue = mesa_dicom::create_mpps_messages_mwl($logLevel, @tokens);
  } elsif ($trans eq "PRODUCE-MPPS-IMPORT") {
    shift (@tokens); shift (@tokens);
    $rtnValue = mesa_dicom::create_mpps_messages($logLevel, @tokens);
  } elsif ($trans eq "COERCE-OBJECTS-ADT") {
    shift (@tokens); shift (@tokens);
    $rtnValue = mesa_dicom::coerceObjectsADT($logLevel, @tokens);
  } elsif ($trans eq "PRODUCE-MPPS-IMPORT-MWL") {
    shift (@tokens); shift (@tokens);
    $rtnValue = mesa_dicom::create_mpps_messages_mwl($logLevel, @tokens);
  } elsif ($trans eq "PRODUCE-MPPS-IMPORT-MWL-EXC") {
    shift (@tokens); shift (@tokens);
    $rtnValue = mesa_dicom::create_mpps_messages_mwl_exception($logLevel, @tokens);
  } elsif ($trans eq "PPM-SCHEDULE") {
    shift (@tokens); shift (@tokens);
    $rtnValue = mesa::processPPMSchedulingRequest($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "GEN-MPPS-ABANDON") {
    shift (@tokens); shift (@tokens);
    $rtnValue = mesa::generateMPPSAbandon($logLevel, $selfTest, $mwlAE, $mwlHost, $mwlPort, @tokens);
  } elsif ($trans eq "GEN-SOP-INSTANCES") {
    shift (@tokens); shift (@tokens);
    #$rtnValue = imp::generateSOPInstances($logLevel, $selfTest, @tokens);
    $rtnValue = mesa::generateSOPInstances($logLevel, $selfTest, $mwlAE, $mwlHost, $mwlPort, @tokens);
  } elsif ($trans eq "GEN-UNSCHED-SOP-INSTANCES") {
    shift (@tokens);
    $rtnValue = mesa::produceUnscheduledImages($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "MOD-MPPS") {
    shift (@tokens); shift (@tokens);
    $rtnValue = mesa::modifyMPPS($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "GPPPS-N-CREATE") {
    shift (@tokens); shift (@tokens);
    $rtnValue = mesa::gpppsNCreate($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "GPPPS-N-SET") {
    shift (@tokens); shift (@tokens);
    $rtnValue = mesa::gpppsNSet($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "COERCE-IMPORT-OBJECT-ATTRIBUTES"){
    shift (@tokens); shift (@tokens);
    $rtnValue = mesa_dicom::coerceImportDicomObjectAttributes($logLevel, @tokens);
  } elsif ($trans eq "COERCE-DIGITIZED-OBJECT-ATTRIBUTES"){
    shift (@tokens); shift (@tokens);
    $rtnValue = mesa_dicom::coerceDigitizedDicomObjectAttributes($logLevel, @tokens);
  }else{
    die "Unable to process command <$cmd>";
  }

  return $rtnValue;
}


#sub processMessage {
#  my $cmd = shift(@_);
#  my $logLevel = shift(@_);
#  my $selfTest = shift(@_);
#  my @tokens = split /\s+/, $cmd;
#  my $verb = $tokens[0];
#  my $trans= $tokens[1];
#
#  my $rtnValue = 0;
#  if ($trans eq "RAD-SCHEDULE") {
#    shift (@tokens); shift (@tokens);
#    $rtnValue = imp::announceSchedulingParameters($logLevel, $selfTest, @tokens);
#  } else {
#    die "Unable to process command <$cmd>\n";
#  }
#  return $rtnValue;
#}


sub processOneLine {
  my ($cmd, $logLevel, $selfTest, $testCase)  = @_;

  if ($cmd eq "") {	# An empty line is a comment
    return 0;
  }

  my @verb = split /\s+/, $cmd;
  my $rtnValue = 0;

  if ($verb[0] eq "TRANSACTION") {
    $rtnValue = processTransaction($cmd, $logLevel, $selfTest);
  } elsif ($verb[0] eq "EXIT") {
    print "EXIT command found\n";
    exit 0;
  } elsif ($verb[0] eq "TEXT") {
     printText($cmd);
#  } elsif ($verb[0] eq "LOCALSCHEDULING") {
#    localScheduling($cmd);
  } elsif ($verb[0] eq "MESA-INTERNAL") {
    $rtnValue = processMESAInternal($cmd, $logLevel, $selfTest);
#  } elsif ($verb[0] eq "MESSAGE") {
#    $rtnValue = processMessage($cmd, $logLevel, $selfTest);
#  } elsif ($verb[0] eq "UNSCHEDULED-IMAGES") {
#    $rtnValue = unscheduledImages($cmd, $logLevel, $selfTest);
  } elsif ($verb[0] eq "PATIENT") {
    printPatient($cmd);
  } elsif ($verb[0] eq "PROFILE") {
    if ($verb[1] ne "IRWF") {
      die "This Importer script is for the IRWF profile, not $verb[1]";
    }
  } elsif (substr($verb[0], 0, 1) eq "#") {
    print "Comment: $cmd \n";
  } else {
    die "Did not recognize verb in command: $cmd \n";
  }
  return $rtnValue;
}

sub testConfigurationVariables {
  die "No MESA_IMG_MGR_PORT_HL7"  if ! $mesaIMPortHL7;
  die "No MESA_IMG_MGR_PORT_DCM"  if ! $mesaIMPortDICOM;
  die "No MESA_IMG_MGR_AE_MPPS"   if ! $mesaIMAEMPPS;
  die "No MESA_IMG_MGR_AE_CSTORE" if ! $mesaIMAECStore;
  die "No MESA_OF_HOST"		  if ! $mesaOFHost;
  die "No MESA_OF_PORT_DCM"	  if ! $mesaOFPortDICOM;
  die "No MESA_OF_AE_MWL"	  if ! $mesaOFAEMWL;
  die "No MESA_OF_PORT_HL7"	  if ! $mesaOFPortHL7;
}

# Main starts here

die "Usage: <test number> <output level: 0-4>\n" if (scalar(@ARGV) < 2);

$host = `hostname`; chomp $host;

%varnames = mesa_get::get_config_params("imp_test.cfg");
if (imp::test_var_names(%varnames) != 0) {
  print "Some problem with the variables in imp_test.cfg\n";
  exit 1;
}


$mesaIMPortHL7        = $varnames{"MESA_IMG_MGR_PORT_HL7"};
$mesaIMPortDICOM      = $varnames{"MESA_IMG_MGR_PORT_DCM"};
$mesaIMAEMPPS         = $varnames{"MESA_IMG_MGR_AE_MPPS"};
$mesaIMAECStore       = $varnames{"MESA_IMG_MGR_AE_CSTORE"};

#$mesaOFHost	      = $varnames{"MESA_OF_HOST"};

$mesaOFPortDICOM      = $varnames{"MESA_OF_PORT_DCM"};
$mesaOFHost           = $varnames{"MESA_OF_HOST"};
$mesaOFAEMWL          = $varnames{"MESA_OF_AE_MWL"};
$mesaOFPortHL7        = $varnames{"MESA_OF_PORT_HL7"};
testConfigurationVariables();

my $fileName = "../common/$ARGV[0]/$ARGV[0]" . ".txt";
open TESTFILE, $fileName or die "Could not open: $fileName\n";
$logLevel = $ARGV[1];
$selfTest = 0;
$selfTest = 1 if (scalar(@ARGV) > 2);
$testCase = $ARGV[0];

die "MESA Environment Problem; look in mesa_environment.log" if (mesa_utility::testMESAEnvironment($logLevel) != 0);

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
