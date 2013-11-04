#!/usr/local/bin/perl -w

# Runs the Image Manager scripts interactively

use Env;
use lib "scripts";
use lib "../../../common/scripts";
require imgmgr;
require imgmgr_transactions;
require mesa_common;

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

sub processTransaction {
  my ($cmd, $logLevel) = @_;
  my @tokens = split /\s+/, $cmd;
  my $verb = $tokens[0];
  my $trans= $tokens[1];
  my $rtnValue = 0;

  if ($trans eq "1") {
    shift (@tokens); shift (@tokens);
    imgmgr::processTransaction1($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "RAD-8") {
    shift (@tokens); shift (@tokens);
    $rtnValue = imgmgr_transactions::processTransaction8($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "RAD-10") {
    shift (@tokens); shift (@tokens);
    $rtnValue = imgmgr_transactions::processTransaction10($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "RAD-14") {
    shift (@tokens); shift (@tokens);
    $rtnValue = imgmgr_transactions::processTransaction14($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "RAD-56") {
    shift (@tokens); shift (@tokens);
    $rtnValue = imgmgr_transactions::processTransaction8($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "RAD-57") {
    shift (@tokens); shift (@tokens);
    $rtnValue = imgmgr_transactions::processTransaction8($logLevel, $selfTest, @tokens);
  } else {
    die "Unimplemented transaction for command: <$cmd>\n";
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

#sub localScheduling {
#  my $cmd = shift(@_);
#  my @tokens = split /\s+/, $cmd;
#
#  my $orderFile = $tokens[1];
#  print "Local scheduling for file: $orderFile \n";
#}

sub processMESAInternal {
  my ($cmd, $logLevel, $selfTest) = @_;
  my @tokens = split /\s+/, $cmd;
  my $verb = $tokens[0];
  my $trans= $tokens[1];

  my $rtnValue = 0;
  if ($trans eq "BLEND") {
    shift (@tokens); shift (@tokens);
    my ($verb, $paramsFile, $superimposed, $underlying, $dst) = @tokens;
    $paramsFile = "../common/" . $paramsFile;
    $superimposed = $main::MESA_STORAGE . "/" . $superimposed;
    $underlying = $main::MESA_STORAGE . "/" . $underlying;
    $dst = $main::MESA_STORAGE . "/" . $dst;
    $rtnValue = mesa_dicom::create_BSPS($logLevel, $selfTest,
        $paramsFile, $superimposed, $underlying, $dst);
  } elsif ($trans eq "SPATIAL-REGISTRATION") {
    shift (@tokens); shift (@tokens);
    my ($verb, $paramsFile, $superimposed, $underlying, $dst) = @tokens;
    $paramsFile = "../common/" . $paramsFile;
    $superimposed = $main::MESA_STORAGE . "/" . $superimposed;
    $underlying = $main::MESA_STORAGE . "/" . $underlying;
    $dst = $main::MESA_STORAGE . "/" . $dst;
    $rtnValue = mesa_dicom::create_SPATIAL($logLevel, $selfTest,
        $paramsFile, $superimposed, $underlying, $dst);
  } elsif ($trans eq "STORAGE-COMMITMENT") {
    shift (@tokens); shift (@tokens);
    my ($verb, $src, $dst) = @tokens;
    $src = $main::MESA_STORAGE . "/" . $src;
    $dst = $main::MESA_STORAGE . "/" . $dst;
    $rtnValue = mesa_dicom::create_storage_commitment($logLevel, $selfTest,
        $verb, $src, $dst);
  } elsif ($trans eq "RAD-SCHEDULE") {
    shift (@tokens); shift(@tokens);
    $rtnValue = mesa::processInternalSchedulingRequest($logLevel, $selfTest, @tokens);

  } elsif ($trans eq "GEN-MPPS-ABANDON") {
    shift (@tokens); shift (@tokens);
    $rtnValue = mesa::generateMPPSAbandon($logLevel, $selfTest, "MESAMWL", $mesaOFHost, $mesaOFPortDICOM, @tokens);
  } elsif ($trans eq "GEN-SOP-INSTANCES") {
    shift (@tokens); shift (@tokens);
    $rtnValue = mesa::generateSOPInstances($logLevel, $selfTest, "MESAMWL", $mesaOFHost, $mesaOFPortDICOM, @tokens);
    return 1 if ($rtnValue != 0);
    $rtnValue = mesa::update_scheduling_ORM_message($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "GEN-UNSCHED-SOP-INSTANCES") {
    shift (@tokens);
    $rtnValue = mesa::produceUnscheduledImages($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "MOD-MPPS") {
    shift (@tokens); shift (@tokens);
    $rtnValue = mesa::modifyMPPS($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "GEN-IAN") {
    shift (@tokens); shift (@tokens);
    $rtnValue = mesa::generateIAN($logLevel, $selfTest, $imCFindAE, @tokens);
  } else {
    die "Unable to process command <$cmd>";
  }

  return $rtnValue;
}

sub processMessage {
  my $cmd = shift(@_);
  my $logLevel = shift(@_);
  my $selfTest = shift(@_);
  my @tokens = split /\s+/, $cmd;
  my $verb = $tokens[0];
  my $trans= $tokens[1];

  if ($trans eq "RAD-SCHEDULE") {
    # Nothing to do, we are not going to announce this
    $rtnValue = 0;
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
  } elsif ($verb[0] eq "TEXT") {
    printText($cmd);
  } elsif ($verb[0] eq "EXIT") {
    print "Found EXIT command\n";
    exit 0;
#  } elsif ($verb[0] eq "LOCALSCHEDULING") {
#    localScheduling($cmd);
  } elsif ($verb[0] eq "MESA-INTERNAL") {
    $rtn = processMESAInternal($cmd, $logLevel, $selfTest);
  } elsif ($verb[0] eq "MESSAGE") {
    $rtn = processMessage($cmd, $logLevel, $selfTest);
  } elsif ($verb[0] eq "PATIENT") {
    printPatient($cmd);
  } elsif ($verb[0] eq "PROFILE") {
    if ($verb[1] ne "FUS") {
      die "This Image Manager script is for the FUS profile, not $verb[1]";
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

%varnames = mesa::get_config_params("imgmgr_test.cfg");
if (imgmgr::test_var_names(%varnames) != 0) {
  print "Some problem with the variables in imgmgr_test.cfg\n";
  exit 1;
}

$mesaImgMgrPortDICOM  = $varnames{"MESA_IMGMGR_DICOM_PT"};
$mesaImgMgrPortHL7    = $varnames{"MESA_IMGMGR_HL7_PORT"};	# We don't need this value
$mesaModPortDICOM     = $varnames{"MESA_MODALITY_PORT"};

$mesaOFPortDICOM      = $varnames{"MESA_OF_DICOM_PORT"};
$mesaOFPortHL7        = $varnames{"MESA_OF_HL7_PORT"};
$mesaOFHost           = $varnames{"MESA_OF_HOST"};
$mesaOFAE             = $varnames{"MESA_OF_AE"};

$mppsHost             = $varnames{"TEST_MPPS_HOST"};
$mppsPort             = $varnames{"TEST_MPPS_PORT"};
$mppsAE               = $varnames{"TEST_MPPS_AE"};

$imCStoreHost         = $varnames{"TEST_CSTORE_HOST"};
$imCStorePort         = $varnames{"TEST_CSTORE_PORT"};
$imCStoreAE           = $varnames{"TEST_CSTORE_AE"};

$imCFindHost          = $varnames{"TEST_CFIND_HOST"};
$imCFindPort          = $varnames{"TEST_CFIND_PORT"};
$imCFindAE            = $varnames{"TEST_CFIND_AE"};

$imCMoveHost          = $varnames{"TEST_CMOVE_HOST"};
$imCMovePort          = $varnames{"TEST_CMOVE_PORT"};
$imCMoveAE            = $varnames{"TEST_CMOVE_AE"};

$imCommitHost         = $varnames{"TEST_COMMIT_HOST"};
$imCommitPort         = $varnames{"TEST_COMMIT_PORT"};
$imCommitAE           = $varnames{"TEST_COMMIT_AE"};

$imHL7Host            = $varnames{"TEST_HL7_HOST"};
$imHL7Port            = $varnames{"TEST_HL7_PORT"};
#$imAE		      = $varnames{"TEST_IMGMGR_AE"};

$mesaWkstationAE      = $varnames{"MESA_WKSTATION_AE"};
$mesaWkstationPort    = $varnames{"MESA_WKSTATION_PORT"};

testVarValues($imCommitAE, $mppsPort,
 $mppsAE, $imCommitHost, $mppsHost, $imCommitPort,
 $mesaModPortDICOM,
 $mesaImgMgrPortHL7,
 $mesaWkstationAE,
 $mesaWkstationPort,
 $imCFindPort,
 $imCFindHost,
 $mesaImgMgrPortDICOM,
 $imCMoveHost,
 $imCStoreAE,
 $imCMoveAE,
 $mesaOFAE,
 $imCStoreHost,
 $imCMovePort,
 $imCStorePort,
 $imHL7Port,
 $imHL7Host,
 $mesaOFPortHL7);

my $fileName = "../common/$ARGV[0]/$ARGV[0]" . ".txt";
open TESTFILE, $fileName or die "Could not open: $fileName\n";
$logLevel = $ARGV[1];
$selfTest = 0;
$selfTest = 1 if (scalar(@ARGV) > 2);

die "MESA Environment Problem" if (mesa::testMESAEnvironment($logLevel) != 0);
my $version = mesa_get::getMESAVersion();
print "MESA Version: $version\n";
($x, $date, $timeMin) = mesa_get::getDateTime($logLevel);
die "Could not get current date/time" if ($x != 0);
print "Date/time = $date $timeMin\n";

print `perl scripts/reset_servers.pl`;

my $lineNum = 1;
while ($l = <TESTFILE>) {
  chomp $l;
  print "$lineNum $l\n"; $lineNum += 1;
  my $x = processOneLine($l, $logLevel, $selfTest);
  die "Could not process line $l\n" if ($x != 0);
}
close TESTFILE;

goodbye;
